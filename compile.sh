#!/bin/bash
#
# gfrotran command for program compilation
# Dependence    
#

gfortran -c *.f90 \
	    1D/*/*.f08 \
            Boundary/*.f90  -J lib/  
            #-L /usr/local/Cellar/hdf5/1.10.5_1/lib \
            #-I /usr/local/Cellar/hdf5/1.10.5_1/include
            # -Jdir /lib/ 
gfortran *.o -o bin/LBM_Fort.exe
            
