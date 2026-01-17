# Execute a SPARQL query and return results as a data frame

Execute a SPARQL query and return results as a data frame

## Usage

``` r
rdf_store_query(store_idx, query)
```

## Arguments

- store_idx:

  Store index

- query:

  SPARQL query string

## Value

Query results as a data frame (for SELECT) or logical (for ASK)

## Examples

``` r
store <- rdf_store_new()
rdf_store_load(store, '<http://example.org/s> <http://example.org/p> "v" .', "ntriples", NULL)
rdf_store_query(store, "SELECT * WHERE { ?s ?p ?o }")
#>     o                      p                      s
#> 1 "v" <http://example.org/p> <http://example.org/s>
```
