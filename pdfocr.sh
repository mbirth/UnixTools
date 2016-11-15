#!/bin/sh
# Remove -noprepoc for bad scans
# TODO: Test with colour PDFs
pdfsandwich -debug -nopreproc -coo "-colorspace Gray -colors 256" -rgb -lang deu -verbose "$1"
