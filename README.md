fluffy-zkevm-fuzzer
===================

This repo describes how you can use a simplified version of the 
[Fluffy fuzzer](https://github.com/snuspl/fluffy) to test the implementation of 
[Scroll's zkEVM](https://github.com/scroll-tech/zkevm-circuits).
First, we use Fluffy to generate interesting test cases. 
To do so, Fluffy performs coverage-guided structured fuzzing of the openethereum client.
After generating a few interesting inputs (in a protobuf format), 
we use those inputs to test the zkEVM implementation.
This fuzzer can only detect crashes.

## Structure

* `rustproto`: Protocol buffers used by Fluffy.
* `custom-libfuzzer`: An instrumented version of `rust-fuzz/libfuzzer` to enable Fluffy's mutations.
* `openethereum-fluffy-fuzzing`: The openethereum client source code and the implementation of the Fluffy fuzzer.
* `zkevm-circuits`: The implementation of Scroll's zkEVM and some helper scripts for testing zkEVM using test cases produced by Fluffy.

## Instructions

### Download

```
git clone --recurse-submodules -j8 git@github.com:Veridise/fluffy-zkevm-fuzzer.git
```

### Run Fluffy on openethereum

```bash
cd ./openethereum-fluffy-fuzzing/crates/evmfuzz
cargo fuzz run --dev fuzz_target_1
```

This will produce some interesting inputs in
`./openethereum-fluffy-fuzzing/crates/evmfuzz/fuzz/corpus/fuzz_target_1`.

### Test zkEVM

After letting the fuzzer run for at least a few hours, run the following commands:

```
cp -r openethereum-fluffy-fuzzing/crates/evmfuzz/fuzz/corpus/fuzz_target_1 zkevm-circuits/integration-tests/fuzzing_inputs
cd ./zkevm-circuits/integration-tests
./fuzz_run.sh test_cases 2>&1 | tee fuzzer_output
```

To check for any crashes run:

```
grep panicked fuzzer_output | sort | uniq | less
```
