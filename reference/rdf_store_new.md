# Create a new in-memory RDF store

Create a new in-memory RDF store

## Usage

``` r
rdf_store_new()
```

## Value

Store index (integer handle)

## Arguments

This function takes no arguments.

## Examples

``` r
store <- rdf_store_new()
rdf_store_size(store)
#> [1] 0
```
