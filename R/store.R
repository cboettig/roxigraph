#' Create an RDF Store
#'
#' Creates a new RDF store, either in-memory or backed by persistent storage.
#'
#' @param path Optional path for persistent storage. If NULL (default), creates
#'   an in-memory store.
#' @return An RDF store handle (integer)
#' @export
#' @examples
#' # In-memory store
#' store <- rdf_store()
#'
#' # Persistent store (not supported on Windows)
#' \donttest{
#' if (.Platform$OS.type != "windows") {
#'   store <- rdf_store(file.path(tempdir(), "my_store"))
#' }
#' }
rdf_store <- function(path = NULL) {
    if (is.null(path)) {
        rdf_store_new()
    } else {
        rdf_store_open(path)
    }
}

#' Execute a SPARQL Query
#'
#' Executes a SPARQL query against the RDF store.
#'
#' @param store An RDF store handle
#' @param query A SPARQL query string
#' @return For SELECT queries, a data.frame with results. For ASK queries, a logical.
#'   For CONSTRUCT/DESCRIBE queries, a data.frame with subject, predicate, object columns.
#' @export
#' @examples
#' store <- rdf_store()
#' rdf_load(store, '<http://example.org/s> <http://example.org/p> "hello" .', format = "ntriples")
#' sparql_query(store, "SELECT * WHERE { ?s ?p ?o }")
sparql_query <- function(store, query) {
    rdf_store_query(store, query)
}

#' Load RDF Data
#'
#' Loads RDF data into the store from a string.
#'
#' @param store An RDF store handle
#' @param data RDF data as a character string
#' @param format RDF format: "turtle", "ntriples", "rdfxml", "nquads", or "trig"
#' @param base_iri Optional base IRI for resolving relative URIs
#' @return Invisibly returns NULL
#' @export
#' @examples
#' store <- rdf_store()
#' rdf_load(store, '<http://example.org/s> <http://example.org/p> "value" .', format = "ntriples")
rdf_load <- function(store, data, format = "turtle", base_iri = NULL) {
    rdf_store_load(store, data, format, base_iri)
    invisible(NULL)
}

#' Load RDF from File
#'
#' Loads RDF data into the store from a file.
#'
#' @param store An RDF store handle
#' @param file Path to the RDF file
#' @param format RDF format. If NULL, guessed from file extension.
#' @param base_iri Optional base IRI for resolving relative URIs
#' @return Invisibly returns NULL
#' @export
#' @examples
#' store <- rdf_store()
#' # Create a temporary RDF file
#' tmp <- tempfile(fileext = ".nt")
#' writeLines('<http://example.org/s> <http://example.org/p> "value" .', tmp)
#' rdf_load_file(store, tmp)
#' rdf_size(store)
rdf_load_file <- function(store, file, format = NULL, base_iri = NULL) {
    if (is.null(format)) {
        ext <- tolower(tools::file_ext(file))
        format <- switch(
            ext,
            "ttl" = "turtle",
            "nt" = "ntriples",
            "rdf" = "rdfxml",
            "xml" = "rdfxml",
            "nq" = "nquads",
            "trig" = "trig",
            stop("Cannot guess format from extension: ", ext)
        )
    }
    data <- paste(readLines(file, warn = FALSE), collapse = "\n")
    rdf_store_load(store, data, format, base_iri)
    invisible(NULL)
}

#' Serialize RDF Data
#'
#' Serializes the store contents to a string.
#'
#' @param store An RDF store handle
#' @param format RDF format: "turtle", "ntriples", "rdfxml", "nquads", or "trig"
#' @return The serialized RDF data as a character string
#' @export
#' @examples
#' store <- rdf_store()
#' rdf_load(store, '<http://example.org/s> <http://example.org/p> "value" .', format = "ntriples")
#' rdf_serialize(store, format = "turtle")
rdf_serialize <- function(store, format = "turtle") {
    rdf_store_dump(store, format)
}

#' Get Store Size
#'
#' Returns the number of quads (triples) in the store.
#'
#' @param store An RDF store handle
#' @return The number of quads as an integer
#' @export
#' @examples
#' store <- rdf_store()
#' rdf_size(store)
rdf_size <- function(store) {
    rdf_store_size(store)
}

#' Add a Triple
#'
#' Adds a single triple to the store.
#'
#' @param store An RDF store handle
#' @param subject Subject IRI (e.g., `"<http://example.org/s>"`) or blank node ("_:b1")
#' @param predicate Predicate IRI (e.g., `"<http://example.org/p>"`)
#' @param object Object: IRI, blank node, or literal (e.g., '"value"')
#' @param graph Optional named graph IRI
#' @return Invisibly returns NULL
#' @export
#' @examples
#' store <- rdf_store()
#' rdf_add(store, "<http://example.org/s>", "<http://example.org/p>", '"hello"')
#' rdf_size(store)
rdf_add <- function(store, subject, predicate, object, graph = NULL) {
    rdf_store_insert(store, subject, predicate, object, graph)
    invisible(NULL)
}

#' Remove a Triple
#'
#' Removes a single triple from the store.
#'
#' @param store An RDF store handle
#' @param subject Subject IRI or blank node
#' @param predicate Predicate IRI
#' @param object Object: IRI, blank node, or literal
#' @param graph Optional named graph IRI
#' @return Invisibly returns NULL
#' @export
#' @examples
#' store <- rdf_store()
#' rdf_add(store, "<http://example.org/s>", "<http://example.org/p>", '"hello"')
#' rdf_remove(store, "<http://example.org/s>", "<http://example.org/p>", '"hello"')
#' rdf_size(store)
rdf_remove <- function(store, subject, predicate, object, graph = NULL) {
    rdf_store_remove(store, subject, predicate, object, graph)
    invisible(NULL)
}

#' Execute SPARQL Update
#'
#' Executes a SPARQL UPDATE query to modify the store.
#'
#' @param store An RDF store handle
#' @param update A SPARQL UPDATE query string
#' @return Invisibly returns NULL
#' @export
#' @examples
#' store <- rdf_store()
#' sparql_update(store, "INSERT DATA { <http://example.org/s> <http://example.org/p> 'value' }")
sparql_update <- function(store, update) {
    rdf_store_update(store, update)
    invisible(NULL)
}
