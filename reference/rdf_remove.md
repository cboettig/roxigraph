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

## Examples

``` r
store <- rdf_store()
rdf_add(store, "<http://example.org/s>", "<http://example.org/p>", '"hello"')
rdf_remove(store, "<http://example.org/s>", "<http://example.org/p>", '"hello"')
rdf_size(store)
#> [1] 0
```
