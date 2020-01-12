#!/bin/bash
#
# gfrotran command for program compilation    
#

gfortran -c 1D/*/*.f90 \
            Boundary/*.f90 \
            -J 2D/ \
            -L /usr/local/Cellar/hdf5/1.10.5_1/lib \
            -I /usr/local/Cellar/hdf5/1.10.5_1/include
gfortran *.o -o bin/program.out
            
