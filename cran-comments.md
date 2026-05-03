## Resubmission

This release (0.1.2) addresses the rustc version-compatibility issue
flagged by Prof. Brian Ripley on 2026-04-30:

> error: rustc 1.86.0 is not supported by the following packages:
>    oxigraph@0.5.2 requires rustc 1.87
>    [... and the matching oxrdf, oxttl, sparesults, etc. crates]

The previous release pinned the Rust dependency to `oxigraph` 0.5.2,
but the entire 0.5.x line of `oxigraph` and its companion crates declares
`rust-version = "1.87"`, which exceeds the CRAN policy requirement of
testing on a rustc at least two years old (1.77.2 as of this submission).

In this release we have downgraded the pinned Rust dependency to
`oxigraph = "=0.4.11"`. Every vendored `oxigraph`-family crate
(`oxigraph`, `oxrdf`, `oxrdfio`, `oxrdfxml`, `oxrocksdb-sys`, `oxttl`,
`oxjsonld`, `sparesults`, `spareval`, `spargebra`, `sparopt`) now
declares `rust-version = "1.75"`, which is comfortably below the 1.77.2
ceiling. We have updated `DESCRIPTION` and `Cargo.toml` accordingly to
declare a minimum supported rustc of 1.75.

We have verified locally that the package builds with rustc 1.77.2 on
Linux x86_64 using the offline-vendored sources.

A tracking issue (https://github.com/cboettig/roxigraph/issues/2)
records the path back to oxigraph 0.5.x once CRAN's two-year rustc
ceiling reaches 1.87.

## R CMD check results

`R CMD check --as-cran` produces 0 errors and 0 warnings.

The remaining INFO is the expected "installed size" note (~11 Mb)
arising from the statically-linked vendored Rust + RocksDB C++ object
code, which is unavoidable for this package.

* This is release 0.1.2.

* All carry-over fixes from 0.1.1 (M1 Mac linker warnings, libsnappy-dev
  system requirement, single-quoted software names, \value tags, etc.)
  are retained.
