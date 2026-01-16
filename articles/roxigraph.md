# Getting Started with roxigraph

## Introduction

**roxigraph** provides RDF storage and SPARQL query capabilities for R
by wrapping the [Oxigraph](https://github.com/oxigraph/oxigraph) graph
database. This vignette introduces the core functionality.

## Creating an RDF Store

``` r
library(roxigraph)

# Create an in-memory store
store <- rdf_store()
```

For persistent storage that survives R sessions:

``` r
store <- rdf_store("/path/to/database")
```

## Loading RDF Data

roxigraph supports multiple RDF serialization formats:

### Turtle

``` r
turtle_data <- '
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix ex: <http://example.org/> .

ex:alice a foaf:Person ;
         foaf:name "Alice" ;
         foaf:age 30 ;
         foaf:knows ex:bob .

ex:bob a foaf:Person ;
       foaf:name "Bob" ;
       foaf:age 25 .
'

rdf_load(store, turtle_data, format = "turtle")
rdf_size(store)
#> [1] 7
```

### N-Triples

``` r
store2 <- rdf_store()
nt_data <- '<http://example.org/s> <http://example.org/p> "object" .'
rdf_load(store2, nt_data, format = "ntriples")
```

### From Files

``` r
rdf_load_file(store, "data.ttl", format = "turtle")
rdf_load_file(store, "data.nt") # Format guessed from extension
```

## SPARQL Queries

### SELECT Queries

``` r
# Find all people and their names
results <- sparql_query(store, "
  PREFIX foaf: <http://xmlns.com/foaf/0.1/>
  SELECT ?person ?name
  WHERE {
    ?person a foaf:Person ;
            foaf:name ?name .
  }
")
results
#>                       person    name
#> 1   <http://example.org/bob>   "Bob"
#> 2 <http://example.org/alice> "Alice"
```

### Filtering and Sorting

``` r
# Find people over 26
sparql_query(store, "
  PREFIX foaf: <http://xmlns.com/foaf/0.1/>
  SELECT ?name ?age
  WHERE {
    ?person foaf:name ?name ;
            foaf:age ?age .
    FILTER(?age > 26)
  }
  ORDER BY DESC(?age)
")
#>      name                                              age
#> 1 "Alice" "30"^^<http://www.w3.org/2001/XMLSchema#integer>
```

### ASK Queries

``` r
# Check if Alice exists
sparql_query(store, "
  PREFIX ex: <http://example.org/>
  ASK { ex:alice ?p ?o }
")
#> [1] TRUE
```

### Aggregation

``` r
sparql_query(store, "
  PREFIX foaf: <http://xmlns.com/foaf/0.1/>
  SELECT (COUNT(?person) as ?count) (AVG(?age) as ?avg_age)
  WHERE {
    ?person a foaf:Person ;
            foaf:age ?age .
  }
")
#>                                             count
#> 1 "2"^^<http://www.w3.org/2001/XMLSchema#integer>
#>                                              avg_age
#> 1 "27.5"^^<http://www.w3.org/2001/XMLSchema#decimal>
```

## Modifying Data

### SPARQL Update

``` r
# Add new data
sparql_update(store, "
  PREFIX foaf: <http://xmlns.com/foaf/0.1/>
  PREFIX ex: <http://example.org/>

  INSERT DATA {
    ex:carol a foaf:Person ;
             foaf:name 'Carol' ;
             foaf:age 28 .
  }
")

rdf_size(store)
#> [1] 10
```

### Direct Triple Manipulation

``` r
# Add a triple
rdf_add(
    store, "<http://example.org/carol>",
    "<http://xmlns.com/foaf/0.1/knows>",
    "<http://example.org/alice>"
)

# Remove a triple
rdf_remove(
    store, "<http://example.org/carol>",
    "<http://xmlns.com/foaf/0.1/knows>",
    "<http://example.org/alice>"
)
```

## Serialization

Export your RDF data:

``` r
# Export to N-Quads format
output <- rdf_serialize(store, format = "nquads")
cat(substr(output, 1, 500), "...\n")
#> <http://example.org/carol> <http://xmlns.com/foaf/0.1/age> "28"^^<http://www.w3.org/2001/XMLSchema#integer> .
#> <http://example.org/carol> <http://xmlns.com/foaf/0.1/name> "Carol" .
#> <http://example.org/carol> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://xmlns.com/foaf/0.1/Person> .
#> <http://example.org/bob> <http://xmlns.com/foaf/0.1/age> "25"^^<http://www.w3.org/2001/XMLSchema#integer> .
#> <http://example.org/bob> <http://xmlns.com/foaf/0.1/name> "Bob" .
#> <http://example.org/bob> <http:/ ...
```

Supported output formats: `nquads`, `trig`, `rdfxml`

## Best Practices

1.  **Use prefixes** in SPARQL queries for readability
2.  **Choose the right storage**: In-memory for temporary data,
    persistent for large datasets
3.  **Batch operations**: Use
    [`rdf_load()`](https://cboettig.github.io/roxigraph/reference/rdf_load.md)
    for bulk data rather than individual
    [`rdf_add()`](https://cboettig.github.io/roxigraph/reference/rdf_add.md)
    calls
4.  **Close persistent stores**: R will handle cleanup, but explicit
    management helps with large databases

## Further Reading

- [SPARQL 1.1 Query Language](https://www.w3.org/TR/sparql11-query/)
- [SPARQL 1.1 Update](https://www.w3.org/TR/sparql11-update/)
- [Turtle - RDF 1.1](https://www.w3.org/TR/turtle/)
- [Oxigraph Documentation](https://github.com/oxigraph/oxigraph)
