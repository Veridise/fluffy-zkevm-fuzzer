#! /bin/sh

mkdir -p out && protoc --go_out=out protos/fuzzer.proto
