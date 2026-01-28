# Create an RDF Store

Creates a new RDF store, either in-memory or backed by persistent
storage.

## Usage

``` r
rdf_store(path = NULL)
```

## Arguments

- path:

  Optional path for persistent storage. If NULL (default), creates an
  in-memory store.

## Value

An RDF store handle (integer)

## Examples

``` r
# In-memory store
store <- rdf_store()

# Persistent store (not supported on Windows)
# \donttest{
if (.Platform$OS.type != "windows") {
  store <- rdf_store(file.path(tempdir(), "my_store"))
}
# }
```
