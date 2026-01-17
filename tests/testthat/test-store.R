test_that("rdf_store creates in-memory store", {
    store <- rdf_store()
    expect_type(store, "integer")
    expect_equal(rdf_size(store), 0)
})

test_that("rdf_store creates persistent store", {
    skip_on_cran() # Requires file system access
    skip_on_os("windows") # RocksDB disabled on Windows

    tmp_dir <- tempfile("roxigraph_test_")
    store <- rdf_store(tmp_dir)
    expect_type(store, "integer")

    # Add data
    rdf_load(
        store,
        '<http://example.org/s> <http://example.org/p> "test" .',
        format = "ntriples"
    )
    expect_equal(rdf_size(store), 1)

    # Cleanup
    unlink(tmp_dir, recursive = TRUE)
})

test_that("rdf_size returns correct count", {
    store <- rdf_store()
    expect_equal(rdf_size(store), 0)

    rdf_load(
        store,
        '<http://ex.org/a> <http://ex.org/b> "1" .',
        format = "ntriples"
    )
    expect_equal(rdf_size(store), 1)

    rdf_load(
        store,
        '<http://ex.org/c> <http://ex.org/d> "2" .',
        format = "ntriples"
    )
    expect_equal(rdf_size(store), 2)
})
