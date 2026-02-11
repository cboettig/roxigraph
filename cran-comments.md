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

* ADDRESSED M1 MAC LINKER WARNINGS:
  We have addressed the linker warnings seen on M1 Macs:
  `ld: warning: object file ... was built for newer 'macOS' version (26.2) than being linked (26.0)`
  
  This was caused by `rustc` defaulting to a newer macOS target than the one used by R for linking. We have fixed this by explicitly setting a default `MACOSX_DEPLOYMENT_TARGET` in `src/Makevars.in` if it is not already provided by the environment. This ensures that the Rust components are built with a deployment target compatible with the R build environment on macOS ARM64.
