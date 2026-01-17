use extendr_api::prelude::*;
use oxigraph::io::RdfFormat;
use oxigraph::model::*;
use oxigraph::model::vocab::xsd;
use oxigraph::sparql::{QueryResults, SparqlEvaluator};
use oxigraph::store::Store;
use std::io::Cursor;
use std::sync::{Arc, Mutex};

// Global store registry using Arc for shared ownership
static STORES: Mutex<Vec<Arc<Store>>> = Mutex::new(Vec::new());

fn get_store(idx: i32) -> Arc<Store> {
    let stores = STORES.lock().unwrap();
    stores.get(idx as usize)
        .expect("Invalid store index")
        .clone()
}

/// Create a new in-memory RDF store
/// @return Store index (integer handle)
/// @export
#[extendr]
fn rdf_store_new() -> i32 {
    let store = Store::new().expect("Failed to create in-memory store");
    let mut stores = STORES.lock().unwrap();
    stores.push(Arc::new(store));
    (stores.len() - 1) as i32
}

/// Open or create a persistent RDF store at the given path
/// @param path Path to the store directory
/// @return Store index (integer handle)
/// @export
#[extendr]
fn rdf_store_open(path: &str) -> i32 {
    #[cfg(feature = "rocksdb")]
    {
        let store = Store::open(path).expect("Failed to open store");
        let mut stores = STORES.lock().unwrap();
        stores.push(Arc::new(store));
        (stores.len() - 1) as i32
    }
    #[cfg(not(feature = "rocksdb"))]
    {
        panic!("Persistent storage (RocksDB) is not supported on this platform (e.g. Windows).");
    }
}

/// Get the number of quads in the store
/// @param store_idx Store index
/// @return The number of quads
/// @export
#[extendr]
fn rdf_store_size(store_idx: i32) -> i32 {
    let store = get_store(store_idx);
    store.len().unwrap_or(0) as i32
}

/// Load RDF data into the store
/// @param store_idx Store index
/// @param data RDF data as a string
/// @param format RDF format: "turtle", "ntriples", "rdfxml", "nquads", "trig"
/// @param base_iri Optional base IRI for relative URIs
/// @export
#[extendr]
fn rdf_store_load(store_idx: i32, data: &str, format: &str, base_iri: Nullable<&str>) {
    let store = get_store(store_idx);
    
    let rdf_format = match format.to_lowercase().as_str() {
        "turtle" | "ttl" => RdfFormat::Turtle,
        "ntriples" | "nt" => RdfFormat::NTriples,
        "rdfxml" | "rdf" | "xml" => RdfFormat::RdfXml,
        "nquads" | "nq" => RdfFormat::NQuads,
        "trig" => RdfFormat::TriG,
        _ => panic!("Unknown format: {}. Use: turtle, ntriples, rdfxml, nquads, or trig", format),
    };

    let base = match base_iri {
        Nullable::NotNull(iri) => Some(iri),
        Nullable::Null => None,
    };

    let cursor = Cursor::new(data);
    
    // Use RdfParser to parse and insert quads one by one
    use oxigraph::io::RdfParser;
    
    let mut parser = RdfParser::from_format(rdf_format);
    if let Some(base_iri) = base {
        parser = parser.with_base_iri(base_iri).expect("Invalid base IRI");
    }
    
    for quad_result in parser.for_reader(cursor) {
        match quad_result {
            Ok(quad) => {
                store.insert(&quad).expect("Failed to insert quad");
            }
            Err(e) => panic!("Failed to parse RDF data: {}", e),
        }
    }
}

/// Serialize the store contents to a string
/// @param store_idx Store index
/// @param format RDF format: "turtle", "ntriples", "rdfxml", "nquads", "trig"
/// @return The serialized RDF data
/// @export
#[extendr]
fn rdf_store_dump(store_idx: i32, format: &str) -> String {
    let store = get_store(store_idx);
    
    // For serialization, we need to use graph formats that support named graphs
    // N-Triples and Turtle only support a single graph, so we use N-Quads and TriG instead
    let rdf_format = match format.to_lowercase().as_str() {
        "turtle" | "ttl" => RdfFormat::TriG,  // TriG is a superset of Turtle
        "ntriples" | "nt" => RdfFormat::NQuads,  // N-Quads is a superset of N-Triples
        "rdfxml" | "rdf" | "xml" => RdfFormat::RdfXml,
        "nquads" | "nq" => RdfFormat::NQuads,
        "trig" => RdfFormat::TriG,
        _ => panic!("Unknown format: {}. Use: turtle, ntriples, rdfxml, nquads, or trig", format),
    };

    let mut buffer = Vec::new();
    store.dump_to_writer(rdf_format, &mut buffer)
        .expect("Failed to dump RDF data");
    String::from_utf8(buffer).unwrap_or_default()
}

/// Execute a SPARQL query and return results as a data frame
/// @param store_idx Store index
/// @param query SPARQL query string
/// @return Query results as a data frame (for SELECT) or logical (for ASK)
/// @export
#[extendr]
fn rdf_store_query(store_idx: i32, query: &str) -> Robj {
    let store = get_store(store_idx);
    
    let results = SparqlEvaluator::new()
        .parse_query(query)
        .expect("Failed to parse SPARQL query")
        .on_store(&store)
        .execute()
        .expect("Failed to execute query");
    
    match results {
        QueryResults::Solutions(solutions) => {
            let variables: Vec<String> = solutions.variables().iter()
                .map(|v| v.as_str().to_string())
                .collect();
            
            let mut columns: Vec<Vec<Option<String>>> = variables.iter()
                .map(|_| Vec::new())
                .collect();
            
            for solution_result in solutions {
                match solution_result {
                    Ok(solution) => {
                        for (i, var) in variables.iter().enumerate() {
                            let value = solution.get(var.as_str())
                                .map(|term| term_to_string(term));
                            columns[i].push(value);
                        }
                    }
                    Err(e) => panic!("Error reading solution: {}", e),
                }
            }
            
            // Build a list of character vectors
            let mut list_items: Vec<Robj> = Vec::new();
            for col in columns {
                let strings: Vec<Robj> = col.into_iter()
                    .map(|opt| match opt {
                        Some(s) => r!(s),
                        None => ().into(),
                    })
                    .collect();
                list_items.push(List::from_values(strings).into_robj());
            }
            
            let mut result_list = List::from_values(list_items);
            result_list.set_names(variables).unwrap();
            
            // Set class to data.frame
            result_list.set_class(&["data.frame"]).unwrap();
            
            // Add row names
            let nrows = if result_list.len() > 0 {
                if let Some(first_col) = result_list.iter().next() {
                    first_col.1.len()
                } else {
                    0
                }
            } else {
                0
            };
            
            let row_names: Vec<i32> = (1..=nrows as i32).collect();
            result_list.set_attrib(row_names_symbol(), row_names).unwrap();
            
            result_list.into_robj()
        }
        QueryResults::Boolean(result) => {
            r!(result)
        }
        QueryResults::Graph(triples) => {
            let mut subjects = Vec::new();
            let mut predicates = Vec::new();
            let mut objects = Vec::new();
            
            for triple_result in triples {
                match triple_result {
                    Ok(triple) => {
                        subjects.push(named_or_blank_to_string(&triple.subject));
                        predicates.push(format!("<{}>", triple.predicate.as_str()));
                        objects.push(term_to_string(&triple.object));
                    }
                    Err(e) => panic!("Error reading triple: {}", e),
                }
            }
            
            data_frame!(
                subject = subjects,
                predicate = predicates,
                object = objects
            ).into_robj()
        }
    }
}

/// Insert a triple into the store
/// @param store_idx Store index
/// @param subject Subject IRI (e.g., "<http://example.org/s>") or blank node ("_:b1")
/// @param predicate Predicate IRI (e.g., "<http://example.org/p>")
/// @param object Object (IRI, blank node, or literal with quotes e.g., "\"value\"")
/// @param graph Optional graph name IRI
/// @export
#[extendr]
fn rdf_store_insert(
    store_idx: i32,
    subject: &str,
    predicate: &str,
    object: &str,
    graph: Nullable<&str>,
) {
    let store = get_store(store_idx);
    let subj = parse_subject(subject);
    let pred = parse_predicate(predicate);
    let obj = parse_term(object);
    let graph_name = match graph {
        Nullable::NotNull(g) => GraphName::NamedNode(NamedNode::new(g.trim_matches(|c| c == '<' || c == '>')).unwrap()),
        Nullable::Null => GraphName::DefaultGraph,
    };
    
    let quad = Quad::new(subj, pred, obj, graph_name);
    store.insert(&quad).unwrap();
}

/// Remove a triple from the store
/// @param store_idx Store index
/// @param subject Subject IRI or blank node
/// @param predicate Predicate IRI
/// @param object Object
/// @param graph Optional graph name IRI
/// @export
#[extendr]
fn rdf_store_remove(
    store_idx: i32,
    subject: &str,
    predicate: &str,
    object: &str,
    graph: Nullable<&str>,
) {
    let store = get_store(store_idx);
    let subj = parse_subject(subject);
    let pred = parse_predicate(predicate);
    let obj = parse_term(object);
    let graph_name = match graph {
        Nullable::NotNull(g) => GraphName::NamedNode(NamedNode::new(g.trim_matches(|c| c == '<' || c == '>')).unwrap()),
        Nullable::Null => GraphName::DefaultGraph,
    };
    
    let quad = Quad::new(subj, pred, obj, graph_name);
    store.remove(&quad).unwrap();
}

/// Execute a SPARQL UPDATE query
/// @param store_idx Store index
/// @param update SPARQL UPDATE query string
/// @export
#[extendr]
fn rdf_store_update(store_idx: i32, update: &str) {
    let store = get_store(store_idx);
    store.update(update).expect("Update error");
}

// Helper functions
fn term_to_string(term: &Term) -> String {
    match term {
        Term::NamedNode(n) => format!("<{}>", n.as_str()),
        Term::BlankNode(b) => format!("_:{}", b.as_str()),
        Term::Literal(l) => {
            if let Some(lang) = l.language() {
                format!("\"{}\"@{}", l.value(), lang)
            } else if l.datatype() == xsd::STRING {
                format!("\"{}\"", l.value())
            } else {
                format!("\"{}\"^^<{}>", l.value(), l.datatype().as_str())
            }
        }
    }
}

fn named_or_blank_to_string(subj: &NamedOrBlankNode) -> String {
    match subj {
        NamedOrBlankNode::NamedNode(n) => format!("<{}>", n.as_str()),
        NamedOrBlankNode::BlankNode(b) => format!("_:{}", b.as_str()),
    }
}

fn parse_subject(s: &str) -> NamedOrBlankNode {
    let s = s.trim();
    if s.starts_with("_:") {
        NamedOrBlankNode::BlankNode(BlankNode::new(&s[2..]).unwrap())
    } else {
        let iri = s.trim_matches(|c| c == '<' || c == '>');
        NamedOrBlankNode::NamedNode(NamedNode::new(iri).unwrap())
    }
}

fn parse_predicate(s: &str) -> NamedNode {
    let iri = s.trim().trim_matches(|c| c == '<' || c == '>');
    NamedNode::new(iri).unwrap()
}

fn parse_term(s: &str) -> Term {
    let s = s.trim();
    if s.starts_with("_:") {
        Term::BlankNode(BlankNode::new(&s[2..]).unwrap())
    } else if s.starts_with('<') && s.ends_with('>') {
        let iri = &s[1..s.len()-1];
        Term::NamedNode(NamedNode::new(iri).unwrap())
    } else if s.starts_with('"') {
        // Parse literal
        if let Some(lang_pos) = s.rfind("\"@") {
            let value = &s[1..lang_pos];
            let lang = &s[lang_pos+2..];
            Term::Literal(Literal::new_language_tagged_literal(value, lang).unwrap())
        } else if let Some(type_pos) = s.rfind("\"^^<") {
            let value = &s[1..type_pos];
            let datatype = &s[type_pos+4..s.len()-1];
            Term::Literal(Literal::new_typed_literal(value, NamedNode::new(datatype).unwrap()))
        } else if s.ends_with('"') {
            let value = &s[1..s.len()-1];
            Term::Literal(Literal::new_simple_literal(value))
        } else {
            panic!("Invalid literal: {}", s)
        }
    } else {
        // Try as IRI without angle brackets
        Term::NamedNode(NamedNode::new(s).unwrap())
    }
}

// Macro to generate exports.
extendr_module! {
    mod roxigraph;
    fn rdf_store_new;
    fn rdf_store_open;
    fn rdf_store_size;
    fn rdf_store_load;
    fn rdf_store_dump;
    fn rdf_store_query;
    fn rdf_store_insert;
    fn rdf_store_remove;
    fn rdf_store_update;
}
