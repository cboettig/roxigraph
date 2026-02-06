# Changelog

## roxigraph 0.1.1

- Fixed Rust version compatibility by pinning `oxigraph` dependency to
  0.5.2, ensuring support for Rust 1.70.0+ (resolving issues with newer
  `oxigraph` requiring bleeding-edge Rust).
- Added `libsnappy-dev` to SystemRequirements for RocksDB compression
  support.
- Suppressed “unused parameter” warnings in RocksDB build to prevent
  compilation failures on newer GCC/Clang compilers (`-Werror`
  behavior).
