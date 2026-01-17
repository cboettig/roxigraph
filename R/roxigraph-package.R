#' @title roxigraph: RDF and SPARQL for R
#'
#' @description
#' Provides RDF storage and SPARQL 1.1 query capabilities by wrapping the
#' 'Oxigraph' graph database library. Supports in-memory and persistent ('RocksDB')
#' storage, multiple RDF serialization formats, and full SPARQL 1.1 Query and
#' Update support.
#'
#' @section Main Functions:
#' \itemize{
#'   \item \code{\link{rdf_store}}: Create an RDF store
#'   \item \code{\link{rdf_load}}: Load RDF data
#'   \item \code{\link{sparql_query}}: Execute SPARQL queries
#'   \item \code{\link{sparql_update}}: Execute SPARQL updates
#'   \item \code{\link{rdf_serialize}}: Serialize RDF data
#' }
#'
#' @seealso
#' Useful links:
#' \itemize{
#'   \item \url{https://github.com/cboettig/roxigraph}
#'   \item \url{https://github.com/oxigraph/oxigraph}
#'   \item Report bugs at \url{https://github.com/cboettig/roxigraph/issues}
#' }
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @useDynLib roxigraph, .registration = TRUE
## usethis namespace: end
NULL
