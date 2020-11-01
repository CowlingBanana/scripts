#!/bin/bash

oldFilesLimit=7

dir="/tmp"

find ${dir} -type f -mtime {oldFilesLimit} -name '*' -execdir rm -- '{}' \;

