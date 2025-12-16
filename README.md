# Parabricks WDL

This is a repository of WDL workflow files for popular Parabricks tools. 

## Quick Start 

Download the test data: 

```
make
```

Run the tests: 

```
```

## Requirements 

Install [Rust](https://rust-lang.org/) using [rustup](https://rustup.rs/). This will also install [Cargo](https://doc.rust-lang.org/cargo/), the Rust package manager. 

```
curl https://sh.rustup.rs -sSf | sh
```

Install [Sprocket](https://sprocket.bio/) using Cargo. 

```
cargo install sprocket --locked
```

Hint: If OpenSSL issues arise, then users may need to run `sudo apt install libssl-dev`. 

## Downloading the test data 

Download the entire test dataset: 

`make` 

Download only data for individual tests: 

`make fq2bam` 

## Running the tests 

```
sprocket run ./fq2bam/tests/test.wdl ./fq2bam/tests/params.json
```
