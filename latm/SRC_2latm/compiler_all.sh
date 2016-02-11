#!/bin/bash
P=$PWD
# medusa&hexa
make -f MakefileAll clean
make -f  MakefileAll
# quad
#ssh quad01    "cd $P; make -f Makefilequad clean; make -f Makefilequad"
