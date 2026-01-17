# Execute a SPARQL UPDATE query

Execute a SPARQL UPDATE query

## Usage

``` r
rdf_store_update(store_idx, update)
```

## Arguments

- store_idx:

  Store index

- update:

  SPARQL UPDATE query string

## Examples

``` r
store <- rdf_store_new()
rdf_store_update(store, "INSERT DATA { <http://example.org/s> <http://example.org/p> 'val' }")
```
