# roxigraph 0.1.1

*   Fixed Rust version compatibility by pinning `oxigraph` dependency to 0.5.2, ensuring support for Rust 1.70.0+ (resolving issues with newer `oxigraph` requiring bleeding-edge Rust).
*   Added `libsnappy-dev` to SystemRequirements for RocksDB compression support.
*   Fixed linker warnings on macOS ARM64 (M1/M2) builds by setting a default `MACOSX_DEPLOYMENT_TARGET`.
