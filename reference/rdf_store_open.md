# Open or create a persistent RDF store at the given path

Open or create a persistent RDF store at the given path

## Usage

``` r
rdf_store_open(path)
```

## Arguments

- path:

  Path to the store directory

## Value

Store index (integer handle)

## Examples

``` r
# \donttest{
if (.Platform$OS.type != "windows") {
  store <- rdf_store_open(file.path(tempdir(), "roxigraph_test"))
}
# }
```
