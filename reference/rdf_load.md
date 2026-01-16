# Load RDF Data

Loads RDF data into the store from a string.

## Usage

``` r
rdf_load(store, data, format = "turtle", base_iri = NULL)
```

## Arguments

- store:

  An RDF store handle

- data:

  RDF data as a character string

- format:

  RDF format: "turtle", "ntriples", "rdfxml", "nquads", or "trig"

- base_iri:

  Optional base IRI for resolving relative URIs

## Value

Invisibly returns NULL

## Examples

``` r
store <- rdf_store()
rdf_load(store, '<http://example.org/s> <http://example.org/p> "value" .', format = "ntriples")
```
