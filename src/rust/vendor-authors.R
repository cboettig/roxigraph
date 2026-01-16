# Generate inst/AUTHORS from cargo metadata
# This script is called by the cleanup script during R CMD build

if (!require('jsonlite', quietly = TRUE)) {
    install.packages('jsonlite', repos = 'https://cloud.r-project.org')
}

metadata <- jsonlite::fromJSON(pipe("cargo metadata --format-version 1"))
packages <- metadata$packages
stopifnot(is.data.frame(packages))

# Filter out the main package and packages without authors
packages <- subset(
    packages,
    sapply(packages$authors, length) > 0 & name != 'roxigraph'
)

# Format authors (remove email addresses)
authors <- vapply(
    packages$authors,
    function(x) {
        paste(sub(" <.*>", "", x), collapse = ', ')
    },
    character(1)
)

# Create formatted lines
lines <- sprintf(" - %s %s: %s", packages$name, packages$version, authors)

# Create inst directory if needed
dir.create('../../inst', showWarnings = FALSE)

# Write AUTHORS file
footer <- sprintf(
    "\n(This file was auto-generated from 'cargo metadata' on %s)",
    Sys.Date()
)
writeLines(
    c('Authors of vendored cargo crates', lines, footer),
    '../../inst/AUTHORS'
)

message("Generated inst/AUTHORS with ", length(lines), " crate entries")
