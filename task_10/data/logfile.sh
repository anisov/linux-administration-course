#!/bin/bash

WORD=$1
LOG=$2
echo "Find world: $(grep $WORD $LOG) count: $(grep $WORD $LOG | wc -l)" 
