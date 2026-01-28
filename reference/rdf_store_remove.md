# Remove a triple from the store

Remove a triple from the store

## Usage

``` r
rdf_store_remove(store_idx, subject, predicate, object, graph)
```

## Arguments

- store_idx:

  Store index

- subject:

  Subject IRI or blank node

- predicate:

  Predicate IRI

- object:

  Object

- graph:

  Optional graph name IRI

## Value

No return value, called for side effects (removing triples from the
store)

## Examples

``` r
store <- rdf_store_new()
rdf_store_insert(store, "<http://example.org/s>", "<http://example.org/p>", '"val"', NULL)
rdf_store_remove(store, "<http://example.org/s>", "<http://example.org/p>", '"val"', NULL)
```
