#!/bin/bash
P=$PWD
# fat&hexa&quad
make -f MakefileAll clean
make -f  MakefileAll
# quad
#ssh quad01    "cd $P; make -f Makefilequad clean; make -f Makefilequad"
