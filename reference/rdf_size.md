# Get Store Size

Returns the number of quads (triples) in the store.

## Usage

``` r
rdf_size(store)
```

## Arguments

- store:

  An RDF store handle

## Value

The number of quads as an integer

## Examples

``` r
store <- rdf_store()
rdf_size(store)
#> [1] 0
```
