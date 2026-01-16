# Add a Triple

Adds a single triple to the store.

## Usage

``` r
rdf_add(store, subject, predicate, object, graph = NULL)
```

## Arguments

- store:

  An RDF store handle

- subject:

  Subject IRI (e.g., "<http://example.org/s>") or blank node ("\_:b1")

- predicate:

  Predicate IRI (e.g., "<http://example.org/p>")

- object:

  Object: IRI, blank node, or literal (e.g., '"value"')

- graph:

  Optional named graph IRI

## Value

Invisibly returns NULL
