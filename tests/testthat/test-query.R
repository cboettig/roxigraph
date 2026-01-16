test_that("sparql_query returns data frame for SELECT", {
    store <- rdf_store()
    rdf_load(
        store,
        '<http://ex.org/s> <http://ex.org/p> "value" .',
        format = "ntriples"
    )

    results <- sparql_query(store, "SELECT * WHERE { ?s ?p ?o }")

    expect_s3_class(results, "data.frame")
    expect_true(all(c("s", "p", "o") %in% names(results)))
    expect_equal(nrow(results), 1)
})

test_that("sparql_query returns logical for ASK", {
    store <- rdf_store()
    rdf_load(
        store,
        '<http://ex.org/s> <http://ex.org/p> "value" .',
        format = "ntriples"
    )

    result_true <- sparql_query(store, "ASK { ?s ?p ?o }")
    expect_true(result_true)

    result_false <- sparql_query(store, "ASK { <http://nonexistent> ?p ?o }")
    expect_false(result_false)
})

test_that("sparql_query handles FILTER", {
    store <- rdf_store()
    turtle <- '@prefix ex: <http://example.org/> .
ex:a ex:value "10"^^<http://www.w3.org/2001/XMLSchema#integer> .
ex:b ex:value "20"^^<http://www.w3.org/2001/XMLSchema#integer> .
ex:c ex:value "30"^^<http://www.w3.org/2001/XMLSchema#integer> .'

    rdf_load(store, turtle, format = "turtle")

    results <- sparql_query(
        store,
        "
    PREFIX ex: <http://example.org/>
    SELECT ?s ?v WHERE { ?s ex:value ?v FILTER(?v > 15) }
  "
    )

    expect_equal(nrow(results), 2)
})

test_that("sparql_query handles ORDER BY", {
    store <- rdf_store()
    rdf_load(
        store,
        '
    <http://ex.org/c> <http://ex.org/name> "Charlie" .
    <http://ex.org/a> <http://ex.org/name> "Alice" .
    <http://ex.org/b> <http://ex.org/name> "Bob" .
  ',
        format = "ntriples"
    )

    results <- sparql_query(
        store,
        "SELECT ?n WHERE { ?s <http://ex.org/name> ?n } ORDER BY ?n"
    )

    expect_equal(nrow(results), 3)
    # First result should be Alice (alphabetically first)
    expect_true(grepl("Alice", results$n[1]))
})

test_that("sparql_query handles LIMIT", {
    store <- rdf_store()
    turtle <- '@prefix ex: <http://example.org/> .
ex:a ex:p "1" .
ex:b ex:p "2" .
ex:c ex:p "3" .'

    rdf_load(store, turtle, format = "turtle")

    results <- sparql_query(store, "SELECT * WHERE { ?s ?p ?o } LIMIT 2")
    expect_equal(nrow(results), 2)
})

test_that("sparql_query handles OPTIONAL", {
    store <- rdf_store()
    turtle <- '@prefix ex: <http://example.org/> .
ex:a ex:name "Alice" ; ex:age "30" .
ex:b ex:name "Bob" .'

    rdf_load(store, turtle, format = "turtle")

    results <- sparql_query(
        store,
        "
    PREFIX ex: <http://example.org/>
    SELECT ?name ?age WHERE {
      ?s ex:name ?name .
      OPTIONAL { ?s ex:age ?age }
    }
  "
    )

    expect_equal(nrow(results), 2)
})

test_that("sparql_query handles COUNT", {
    store <- rdf_store()
    rdf_load(
        store,
        '
    <http://ex.org/a> <http://ex.org/p> "1" .
    <http://ex.org/b> <http://ex.org/p> "2" .
    <http://ex.org/c> <http://ex.org/p> "3" .
  ',
        format = "ntriples"
    )

    results <- sparql_query(
        store,
        "SELECT (COUNT(*) as ?count) WHERE { ?s ?p ?o }"
    )

    expect_equal(nrow(results), 1)
    expect_true("count" %in% names(results))
})
