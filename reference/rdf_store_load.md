# Load RDF data into the store

Load RDF data into the store

## Usage

``` r
rdf_store_load(store_idx, data, format, base_iri)
```

## Arguments

- store_idx:

  Store index

- data:

  RDF data as a string

- format:

  RDF format: "turtle", "ntriples", "rdfxml", "nquads", "trig"

- base_iri:

  Optional base IRI for relative URIs
