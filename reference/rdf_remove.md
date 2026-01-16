# Remove a Triple

Removes a single triple from the store.

## Usage

``` r
rdf_remove(store, subject, predicate, object, graph = NULL)
```

## Arguments

- store:

  An RDF store handle

- subject:

  Subject IRI or blank node

- predicate:

  Predicate IRI

- object:

  Object: IRI, blank node, or literal

- graph:

  Optional named graph IRI

## Value

Invisibly returns NULL
