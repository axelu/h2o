#!/bin/sh -l

if [ -z $1 ]; then
    cmake -B build . -DCMAKE_BUILD_TYPE=None -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_LIBDIR=/usr/lib -DCMAKE_INSTALL_PREFIX=/usr -DWITH_MRUBY=ON
    make -C build
elif [ $1 = "buildcheckdependencies" ]; then
    # https://stackoverflow.com/questions/60828698/print-targets-that-need-to-be-remade/60828699#60828
    # dbg="`make -dni -C build check 2>/dev/null`"
    # all="`echo -n "$dbg" | sed -rn "s/^ *Must remake target '(.+)'\.$/\1/p"`"
    # mks="`echo -n "$dbg" | sed -rn "s/^ *Reading makefile '([^']+)'.*$/\1/p"`"
    # far="`echo -n "$all" | grep -vxF "$mks"`"
    # tan="`echo -n "$far" | awk '!/^CMake/ && !/^cmake/ && !/check/ && !/\// {print;}'`"
    # for i in $tan
    # do
    #    make -C build $i
    # done
    make -C build checkdepends
elif [ $1 = "batch-1" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/[0-4]*.t
elif [ $1 = "batch-2" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50[a-l]*.t
elif [ $1 = "batch-3" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50mimemap.t
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50mruby.t
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50mruby-[a-l]*.t
elif [ $1 = "batch-4" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50mruby-m*.t
elif [ $1 = "batch-5" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50reverse-proxy-[a0-9]*.t
elif [ $1 = "batch-6" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50reverse-proxy-[b-z]*.t
elif [ $1 = "batch-7" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50redirect.t
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50[s-z]*.t
elif [ $1 = "batch-8" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50mruby-[n-z]*.t
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/50[n-q]*.t
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/[8-9a-zA-Z]*.t
elif [ $1 = "runalltests" ]; then
    env H2O_ROOT=. BINARY_DIR=build prove -I. -v t/*.t
elif [ $1 = "runcheck" ]; then
    make -C build check
fi
