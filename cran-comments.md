## Resubmission

This is a resubmission addressing the following issues from the previous review:

* **Software names**: Added single quotes around all software names in DESCRIPTION (e.g., 'Rust', 'Oxigraph', 'RocksDB', 'SPARQL', etc.)

* **References**: Added reference URL for Oxigraph (<https://github.com/oxigraph/oxigraph>) in DESCRIPTION

* **Missing \value tags**: Added @return documentation to all exported functions:
  - rdf_store_insert.Rd
  - rdf_store_load.Rd
  - rdf_store_remove.Rd
  - rdf_store_update.Rd

* **Missing \arguments**: Added explicit Arguments section to rdf_store_new.Rd (function takes no arguments)

* **\dontrun usage**: Replaced \dontrun{} with \donttest{} in:
  - rdf_store.Rd
  - rdf_store_open.Rd
  
  These examples require persistent file storage and are correctly wrapped in \donttest{} as they write to disk.
## R CMD check results

0 errors | 0 warnings | 1 note

* This is release 0.1.1.

* Pinned internal Rust dependencies to ensure compatibility with older Rust versions (1.70+).
