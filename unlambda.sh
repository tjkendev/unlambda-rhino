#!/bin/sh

usage() {
  cat <<EOF
usage: unlambda.sh [-e encoding] [-v] [-h] [target]

Options:
  -e, --encode  : set file encode to load (UTF-8, Shift_JIS, etc)
  -v, --version : display version
  -h, --help    : display help (this usage)
  target        : Unlambda script file to run
EOF
  exit 1
}

run() {
  rhino -opt -1 js/main.js $@
  exit 1
}

ARGS=$@

if [ ! -f main.js ];
then
  make all
fi

if [ "$OPTIND" = 1 ]; then
  while getopts e:hv-- OPT
  do
    case $OPT in
      h | --help)
        usage
        ;;
      v | --version)
        run -v
        ;;
      \?)
        usage
        ;;
    esac
  done
fi

run $ARGS
