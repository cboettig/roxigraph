# Serialize the store contents to a string

Serialize the store contents to a string

## Usage

``` r
rdf_store_dump(store_idx, format)
```

## Arguments

- store_idx:

  Store index

- format:

  RDF format: "turtle", "ntriples", "rdfxml", "nquads", "trig"

## Value

The serialized RDF data

## Examples

``` r
store <- rdf_store_new()
rdf_store_load(store, '<http://example.org/s> <http://example.org/p> "v" .', "ntriples", NULL)
rdf_store_dump(store, "turtle")
#> [1] "<http://example.org/s> <http://example.org/p> \"v\" .\n"
```
