# Insert a triple into the store

Insert a triple into the store

## Usage

``` r
rdf_store_insert(store_idx, subject, predicate, object, graph)
```

## Arguments

- store_idx:

  Store index

- subject:

  Subject IRI (e.g., "<http://example.org/s>") or blank node ("\_:b1")

- predicate:

  Predicate IRI (e.g., "<http://example.org/p>")

- object:

  Object (IRI, blank node, or literal with quotes e.g., "\\value\\")

- graph:

  Optional graph name IRI

## Examples

``` r
store <- rdf_store_new()
rdf_store_insert(store, "<http://example.org/s>", "<http://example.org/p>", '"val"', NULL)
```
