# Execute a SPARQL Query

Executes a SPARQL query against the RDF store.

## Usage

``` r
sparql_query(store, query)
```

## Arguments

- store:

  An RDF store handle

- query:

  A SPARQL query string

## Value

For SELECT queries, a data.frame with results. For ASK queries, a
logical. For CONSTRUCT/DESCRIBE queries, a data.frame with subject,
predicate, object columns.

## Examples

``` r
store <- rdf_store()
rdf_load(store, '<http://example.org/s> <http://example.org/p> "hello" .', format = "ntriples")
sparql_query(store, "SELECT * WHERE { ?s ?p ?o }")
#>         o                      p                      s
#> 1 "hello" <http://example.org/p> <http://example.org/s>
```
