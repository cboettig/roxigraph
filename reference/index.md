# Package index

## Store Management

Create and manage RDF stores

- [`rdf_store()`](https://cboettig.github.io/roxigraph/reference/rdf_store.md)
  : Create an RDF Store
- [`rdf_store_new()`](https://cboettig.github.io/roxigraph/reference/rdf_store_new.md)
  : Create a new in-memory RDF store
- [`rdf_store_open()`](https://cboettig.github.io/roxigraph/reference/rdf_store_open.md)
  : Open or create a persistent RDF store at the given path
- [`rdf_size()`](https://cboettig.github.io/roxigraph/reference/rdf_size.md)
  : Get Store Size
- [`rdf_store_size()`](https://cboettig.github.io/roxigraph/reference/rdf_store_size.md)
  : Get the number of quads in the store

## Loading Data

Parse and load RDF data

- [`rdf_load()`](https://cboettig.github.io/roxigraph/reference/rdf_load.md)
  : Load RDF Data
- [`rdf_load_file()`](https://cboettig.github.io/roxigraph/reference/rdf_load_file.md)
  : Load RDF from File
- [`rdf_store_load()`](https://cboettig.github.io/roxigraph/reference/rdf_store_load.md)
  : Load RDF data into the store
- [`rdf_store_insert()`](https://cboettig.github.io/roxigraph/reference/rdf_store_insert.md)
  : Insert a triple into the store

## SPARQL

Query and update RDF data

- [`sparql_query()`](https://cboettig.github.io/roxigraph/reference/sparql_query.md)
  : Execute a SPARQL Query
- [`sparql_update()`](https://cboettig.github.io/roxigraph/reference/sparql_update.md)
  : Execute SPARQL Update
- [`rdf_store_query()`](https://cboettig.github.io/roxigraph/reference/rdf_store_query.md)
  : Execute a SPARQL query and return results as a data frame
- [`rdf_store_update()`](https://cboettig.github.io/roxigraph/reference/rdf_store_update.md)
  : Execute a SPARQL UPDATE query

## Triple Manipulation

Direct triple operations

- [`rdf_add()`](https://cboettig.github.io/roxigraph/reference/rdf_add.md)
  : Add a Triple
- [`rdf_remove()`](https://cboettig.github.io/roxigraph/reference/rdf_remove.md)
  : Remove a Triple
- [`rdf_store_remove()`](https://cboettig.github.io/roxigraph/reference/rdf_store_remove.md)
  : Remove a triple from the store

## Serialization

Export RDF data

- [`rdf_serialize()`](https://cboettig.github.io/roxigraph/reference/rdf_serialize.md)
  : Serialize RDF Data
- [`rdf_store_dump()`](https://cboettig.github.io/roxigraph/reference/rdf_store_dump.md)
  : Serialize the store contents to a string
