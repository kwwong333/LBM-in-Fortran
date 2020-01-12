gfortran -c 1D/*/*.f90 \
            Boundary/*.f90 -J 2D/
gfortran *.o -o bin/program.out
            
