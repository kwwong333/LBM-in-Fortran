subroutine Advection_Diffusion_1D()
   
     use LBM_1D
    
     implicit none
     ! CPU timing Variables 
     REAL :: t1, t2 
 
     ! Parameters
     INTEGER , PARAMETER :: N = 400                       ! number of nodes
     REAL , PARAMETER :: Ma = 0.1                         ! Mach number
     REAL , PARAMETER :: D = 1.0                          ! diffusion coefficient
     REAL , PARAMETER :: c = 1.0                          ! molecular speed
     REAL , PARAMETER :: cs = 1.0/(3**0.5)                ! speed of sound
     REAL , PARAMETER :: u = Ma*cs                        ! advection velocity
     INTEGER , PARAMETER :: T = floor(0.5*N/u)            ! number of timesteps
     REAL , PARAMETER :: beta = 1.0/(2.0*D/cs**2.0+1.0)   ! relaxation parameter
     REAL , PARAMETER :: alpha = 2.0                      ! entropic stabilizer (constant for now)
     
     ! Initialise the array    
     real, dimension(3, N) :: f, f_eq
     real, dimension(T, N) :: rho_output           ! array for equilibrium function
     real, dimension (N) :: x, rho_0, rho
 
     ! Local variables
     integer :: i, j, fh, profile = 1
     character*20 :: filename
 
     CALL cpu_time(t1)
 
     write(*,*) "-----------------------------------------------------"
     write(*,*) "Calculation Started - 1D Advection Diffusion Equation"
     write(*,*) "-----------------------------------------------------"
 
     
     ! Initialze a steep gaussian profile
     write(*,*) "Initialze a steep gaussian profile"
     
     do i = 1, N
         rho_0(i) = 1+0.5*exp(-5000.0*(i/real(N)-0.25)**2)
     end do
 
     write(*,*) "Writing Initial profile"
     
     
     open (newunit=fh, action='write', file='initial_Gaussian.txt', status='replace')
     do i = 1, N
         write (fh, *) rho_0(i)
     end do
     close (fh)
     
 
     ! Initialise the equilibrium function
     do i = 1 , N
         CALL equilibrium_f(f_eq, rho_0(i), Ma, cs, u, c, i, N)
     end do
     
     ! Initalize the variables
     f=f_eq
     rho_output = 0
     rho = rho_0
 
     do i = 1, T
 
         write(*,*) "Timestep:", i
         write(*,*) "-----------------------------------------------------"
         write(*,*) "- Advection Step"
         write(*,*) "maximum moment before advection:", maxval(rho)
         write(*,*) "minimum moment before advection:", minval(rho)
         CALL advection(f, N)

         write(*,*) "maximum moment after advection:", maxval(rho)
         write(*,*) "minimum moment after advection:", minval(rho)
         write(*,*) "- Moment Calculation Step"
         CALL sum_moment(rho, f, N)

         write(*,*) "maximum moment after moment calculation:", maxval(rho)
         write(*,*) "minimum moment after moment calcualtion:", minval(rho)
         rho_output(i, :) = rho

         write(*,*) "- Collision Step"
         CALL collision (f, rho, alpha, beta, Ma, cs, u, c, N)
         write(*,*) "maximum moment after collision:", maxval(rho)
         write(*,*) "minimum moment after collision:", minval(rho)
         write(*,*) "-----------------------------------------------------"
     end do

     write(*,*) shape(rho)
     write(filename,'(a,i4.4,a)') "density_end.txt"
     
     open (newunit=fh, action='write', file=filename, status='unknown')
        do i = 1, T 
            if (mod(i, 50)==0) then
                write (fh, *) rho_output(i,:)
            end if
        end do
     close(fh)
 
     write(*,*) "Finished"
     write(*,*) "-----------------------------------------------------"
 
     CALL cpu_time(t2)
 
     ! print used cpu time
     write(*,*) "CPU Time : ",t2-t1
 
 end subroutine Advection_Diffusion_1D
 
 
 
