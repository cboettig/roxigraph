test_that("sparql_update INSERT DATA works", {
    store <- rdf_store()

    sparql_update(
        store,
        "INSERT DATA { <http://ex.org/s> <http://ex.org/p> 'value' }"
    )

    expect_equal(rdf_size(store), 1)

    results <- sparql_query(store, "SELECT * WHERE { ?s ?p ?o }")
    expect_equal(nrow(results), 1)
})

test_that("sparql_update DELETE DATA works", {
    store <- rdf_store()
    rdf_load(
        store,
        '<http://ex.org/s> <http://ex.org/p> "value" .',
        format = "ntriples"
    )
    expect_equal(rdf_size(store), 1)

    sparql_update(
        store,
        "DELETE DATA { <http://ex.org/s> <http://ex.org/p> 'value' }"
    )

    expect_equal(rdf_size(store), 0)
})

test_that("sparql_update INSERT WHERE works", {
    store <- rdf_store()
    rdf_load(
        store,
        '<http://ex.org/a> <http://ex.org/name> "Alice" .',
        format = "ntriples"
    )

    sparql_update(
        store,
        "
    INSERT { ?s <http://ex.org/greeting> 'Hello' }
    WHERE { ?s <http://ex.org/name> ?name }
  "
    )

    expect_equal(rdf_size(store), 2)
})

test_that("rdf_add inserts triple", {
    store <- rdf_store()

    rdf_add(store, "<http://ex.org/s>", "<http://ex.org/p>", '"object"')

    expect_equal(rdf_size(store), 1)
})

test_that("rdf_remove deletes triple", {
    store <- rdf_store()
    rdf_add(store, "<http://ex.org/s>", "<http://ex.org/p>", '"object"')
    expect_equal(rdf_size(store), 1)

    rdf_remove(store, "<http://ex.org/s>", "<http://ex.org/p>", '"object"')

    expect_equal(rdf_size(store), 0)
})
