# roxigraph 0.1.2

*   Downgraded `oxigraph` Rust dependency from 0.5.2 to 0.4.11 to comply with
    CRAN's policy requiring packages to build on a rustc release at least two
    years old. The 0.5.x line declares MSRV 1.87, which CRAN's reference Linux
    machines (Fedora 40, rustc 1.86.0) and the 1.77.2 policy ceiling do not
    satisfy. The 0.4.11 release declares MSRV 1.75 and provides equivalent
    in-memory and RocksDB-backed RDF/SPARQL functionality. See
    https://github.com/cboettig/roxigraph/issues/2 for the upgrade plan back
    to 0.5.x.
*   Bumped declared MSRV in `DESCRIPTION` and `Cargo.toml` from 1.70 to 1.75
    to accurately reflect the new dependency requirement.

# roxigraph 0.1.1

*   Fixed Rust version compatibility by pinning `oxigraph` dependency to 0.5.2, ensuring support for Rust 1.70.0+ (resolving issues with newer `oxigraph` requiring bleeding-edge Rust).
*   Added `libsnappy-dev` to SystemRequirements for RocksDB compression support.
*   Fixed linker warnings on macOS ARM64 (M1/M2) builds by setting a default `MACOSX_DEPLOYMENT_TARGET`.
