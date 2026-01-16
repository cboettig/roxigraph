# Execute SPARQL Update

Executes a SPARQL UPDATE query to modify the store.

## Usage

``` r
sparql_update(store, update)
```

## Arguments

- store:

  An RDF store handle

- update:

  A SPARQL UPDATE query string

## Value

Invisibly returns NULL

## Examples

``` r
store <- rdf_store()
sparql_update(store, "INSERT DATA { <http://example.org/s> <http://example.org/p> 'value' }")
```
