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
