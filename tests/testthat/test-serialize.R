test_that("rdf_serialize outputs N-Quads", {
    store <- rdf_store()
    rdf_load(
        store,
        '<http://example.org/s> <http://example.org/p> "value" .',
        format = "ntriples"
    )

    output <- rdf_serialize(store, format = "nquads")

    expect_type(output, "character")
    expect_true(grepl("http://example.org/s", output))
    expect_true(grepl("http://example.org/p", output))
    expect_true(grepl("value", output))
})

test_that("rdf_serialize outputs TriG", {
    store <- rdf_store()
    rdf_load(
        store,
        '<http://example.org/s> <http://example.org/p> "value" .',
        format = "ntriples"
    )

    output <- rdf_serialize(store, format = "trig")

    expect_type(output, "character")
    expect_true(nchar(output) > 0)
})

test_that("rdf_serialize handles empty store", {
    store <- rdf_store()

    output <- rdf_serialize(store, format = "nquads")

    expect_type(output, "character")
    expect_equal(nchar(output), 0)
})
