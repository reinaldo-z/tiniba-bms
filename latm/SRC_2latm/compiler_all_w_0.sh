#!/bin/bash
P=$PWD
# medusa&hexa
make -f MakefileAll_w_0 clean
make -f  MakefileAll_w_0
# quad
#ssh quad01    "cd $P; make -f Makefilequad clean; make -f Makefilequad"
