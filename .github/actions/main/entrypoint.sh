#!/bin/bash -l

if [ $1 = "dtrace" ]; then
    export DTRACE_TESTS=1
fi

if [ -z $2 ]; then

    mkdir build
    cd build

    if [ -z $1 ] || [ $1 = "default" ] || [ $1 = "dtrace" ]; then
        cmake ..
    elif [ $1 = "ossl110" ]; then
        cmake -DOPENSSL_ROOT_DIR=/opt/openssl-1.1.0 ..
    elif [ $1 = "ossl111" ]; then
        cmake -DOPENSSL_ROOT_DIR=/opt/openssl-1.1.1 ..
    elif [ $1 = "fuzz" ]; then
        FUZZ_ASAN=ASAN_OPTIONS=detect_leaks=0 CC=clang CXX=clang++ cmake -DBUILD_FUZZER=ON ..
    fi

    cd ..
    make -C build

elif [ $1 = 'fuzz' ] && [ $2 = 'fuzz-extra' ]; then
    FUZZ_ASAN=ASAN_OPTIONS=detect_leaks=0 ./build/h2o-fuzzer-http1 -close_fd_mask=3 -runs=1 -max_len=16384 ./fuzz/http1-corpus < /dev/null
    FUZZ_ASAN=ASAN_OPTIONS=detect_leaks=0 ./build/h2o-fuzzer-http2 -close_fd_mask=3 -runs=1 -max_len=16384 ./fuzz/http2-corpus < /dev/null
    FUZZ_ASAN=ASAN_OPTIONS=detect_leaks=0 ./build/h2o-fuzzer-url -close_fd_mask=3 -runs=1 -max_len=16384 ./fuzz/url-corpus < /dev/null
elif [ $2 = "buildcheckdependencies" ]; then
    make -C build checkdepends
elif [ $2 = "batch-1" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/[0-4]*.t
elif [ $2 = "batch-2" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50[a-l]*.t
elif [ $2 = "batch-3" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50mimemap.t
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50mruby.t
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50mruby-[a-l]*.t
elif [ $2 = "batch-4" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50mruby-m*.t
elif [ $2 = "batch-5" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50reverse-proxy-[a0-9]*.t
elif [ $2 = "batch-6" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50reverse-proxy-[b-z]*.t
elif [ $2 = "batch-7" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50redirect.t
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50[s-z]*.t
elif [ $2 = "batch-8" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50mruby-[n-z]*.t
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50[n-q]*.t
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/[8-9a-zA-Z]*.t
fi
