# Serialize RDF Data

Serializes the store contents to a string.

## Usage

``` r
rdf_serialize(store, format = "turtle")
```

## Arguments

- store:

  An RDF store handle

- format:

  RDF format: "turtle", "ntriples", "rdfxml", "nquads", or "trig"

## Value

The serialized RDF data as a character string

## Examples

``` r
store <- rdf_store()
rdf_load(store, '<http://example.org/s> <http://example.org/p> "value" .', format = "ntriples")
rdf_serialize(store, format = "turtle")
#> [1] "<http://example.org/s> <http://example.org/p> \"value\" .\n"
```
