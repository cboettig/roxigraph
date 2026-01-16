# Load RDF from File

Loads RDF data into the store from a file.

## Usage

``` r
rdf_load_file(store, file, format = NULL, base_iri = NULL)
```

## Arguments

- store:

  An RDF store handle

- file:

  Path to the RDF file

- format:

  RDF format. If NULL, guessed from file extension.

- base_iri:

  Optional base IRI for resolving relative URIs

## Value

Invisibly returns NULL
