#!/bin/bash

test_func() {
  am=$1
  for ((i=1; i<=am; i++)); do
    echo "$i"
  done
}
