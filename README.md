# Parabricks WDL

This is a repository of WDL workflow files for popular Parabricks tools. 

## Quick Start 

Install Sprocket

```
curl https://sh.rustup.rs -sSf | sh
cargo install sprocket --locked
```

Download data and run all tests 

```
make
```

## Full Tutorial 

### Installing Sprocket 

Install [Rust](https://rust-lang.org/) using [rustup](https://rustup.rs/). This will also install [Cargo](https://doc.rust-lang.org/cargo/), the Rust package manager 

```
curl https://sh.rustup.rs -sSf | sh
```

Install [Sprocket](https://sprocket.bio/) using Cargo 

```
cargo install sprocket --locked
```

Hint: If OpenSSL issues arise, then users may need to run `sudo apt install libssl-dev`

### Running the tests 

Download data and run all tests 

`make` 

Download data and run individual tests (Ex. fq2bam) 

`make fq2bam` 

**Note**: There is a known issue with fq2bammeth (resolving index files) that will be resolved in the next release of Parabricks. 

## Future Work 

* Update test data to use shared files when possible (Ex. All germline use the same reference)
* Set defaults for common params (memory, num_cpus, qc_metrics=true, etc.) to reduce clutter 
* Split base_url and file_url in data download scripts. See `starfusion/tests/download_data.sh`. 