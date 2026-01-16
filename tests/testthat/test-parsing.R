test_that("rdf_load parses N-Triples", {
    store <- rdf_store()

    nt_data <- '<http://example.org/s> <http://example.org/p> "hello" .'
    rdf_load(store, nt_data, format = "ntriples")

    expect_equal(rdf_size(store), 1)
})

test_that("rdf_load parses Turtle", {
    store <- rdf_store()

    turtle_data <- '@prefix ex: <http://example.org/> .
ex:subject ex:predicate "object" .'

    rdf_load(store, turtle_data, format = "turtle")
    expect_equal(rdf_size(store), 1)
})

test_that("rdf_load parses Turtle with multiple triples", {
    store <- rdf_store()

    turtle_data <- '@prefix ex: <http://example.org/> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .

ex:alice foaf:name "Alice" ;
         foaf:knows ex:bob .
ex:bob foaf:name "Bob" .'

    rdf_load(store, turtle_data, format = "turtle")
    expect_equal(rdf_size(store), 3)
})

test_that("rdf_load handles language tags", {
    store <- rdf_store()

    data <- '<http://example.org/s> <http://example.org/label> "Hello"@en .'
    rdf_load(store, data, format = "ntriples")

    results <- sparql_query(store, "SELECT ?o WHERE { ?s ?p ?o }")
    expect_true(grepl("@en", results$o[1]))
})

test_that("rdf_load handles typed literals", {
    store <- rdf_store()

    data <- '<http://example.org/s> <http://example.org/value> "42"^^<http://www.w3.org/2001/XMLSchema#integer> .'
    rdf_load(store, data, format = "ntriples")

    results <- sparql_query(store, "SELECT ?o WHERE { ?s ?p ?o }")
    expect_true(grepl("42", results$o[1]))
})

test_that("rdf_load_file reads from file", {
    store <- rdf_store()

    tmp_file <- tempfile(fileext = ".nt")
    writeLines(
        '<http://example.org/s> <http://example.org/p> "from file" .',
        tmp_file
    )

    rdf_load_file(store, tmp_file)
    expect_equal(rdf_size(store), 1)

    unlink(tmp_file)
})
