# Lattice Boltzmann in Fortran (LBFortran)

The code would be implemented using the new functionalites in Fortran 2008/2018. However, the usage of the coarray may be limited in LBFortran as the support from OpenACC for GPU computing is not quite available yet. Similar to MP-CFD, the code would be adopted in modular oriented code. The coding philosphory would be put on future extension.

1D advection diffusion equation: Completed the general framework using single file. <- 11.01.2020

1D Navier Stokes Equation

Further ideas at the moment:
1. Separate the modules/subroutine into different files
2. extend to NS equation
3. prepare a technical note on the implementation
4. 2D simulations
