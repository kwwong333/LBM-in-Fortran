program Advection_Diffusion_1D
    
   use test2
    implicit none
    ! CPU timing Variables 
    REAL :: t1, t2 

    ! Parameters
    INTEGER , PARAMETER :: N = 2000              ! number of nodes
    REAL , PARAMETER :: Ma = 0.1                  ! Mach number
    REAL , PARAMETER :: D = 1.0          ! diffusion coefficient
    REAL , PARAMETER :: c = 1.0                   ! molecular speed
    REAL , PARAMETER :: cs = 1.0/(3**0.5)            ! speed of sound
    REAL , PARAMETER :: u = Ma*cs                ! advection velocity
    INTEGER , PARAMETER :: T = 16000      ! number of timesteps
    REAL , PARAMETER :: beta = 1.0/(2.0*D/cs**2.0+1.0)   ! relaxation parameter
    REAL , PARAMETER :: alpha = 2.0                ! entropic stabilizer (constant for now)
    
    ! Initialize the array    
    real, dimension(3, N) :: f, f_eq
    real, dimension(T, N) :: rho_output           ! array for equilibrium funciton
    real, dimension (N) :: x, rho_0, rho

    ! Local variables
    integer :: i, j, fh, profile = 1
    character*20 :: filename


    CALL cpu_time(t1)
    WRITE(*,*) "-----------------------------------------------------"
    WRITE(*,*) "Calcuation Started - 1D Advection Diffusion Equation"
    WRITE(*,*) "-----------------------------------------------------"

    if (profile == 1) GOTO 999
    ! Initialze a steep gaussian profile
    999 WRITE(*,*) "Initialze a steep gaussian profile"
    do i = 1, N
        x (i) = i
        rho_0(i) = 1+0.5*exp(-5000.0*(i/real(N)-0.25)**2)
    end do

    WRITE(*,*) "Wriitng Initial profile"
    open (newunit=fh, action='write', file='initial_Gaussian.txt', status='replace')
    do i = 1, N
        write (fh, *) rho_0(i)
    end do
    close (fh)

    ! Initialize the equilibrim function
    do i = 1 , N
        CALL equilibrium_f(f_eq, rho_0(i), Ma, cs, c, u, i, N)
    end do
    
    ! Initalize the variables
    f=f_eq
    rho_output = 0
    rho = rho_0
    do i = 1, T

        WRITE(*,*) "Timestep:", i
        WRITE(*,*) "-----------------------------------------------------"
        WRITE(*,*) "- Advection Step"
        WRITE(*,*) "maximum moment before advection:", maxval(rho)
        WRITE(*,*) "minimum moment before advection:", minval(rho)
        CALL advection(f, N)
        WRITE(*,*) "maximum moment after advection:", maxval(rho)
        WRITE(*,*) "minimum moment after advection:", minval(rho)
        WRITE(*,*) "- Moment Calculation Step"
        CALL sum_moment(rho, f, N)
        WRITE(*,*) "maximum moment after moment calculation:", maxval(rho)
        WRITE(*,*) "minimum moment after moment calcualtion:", minval(rho)
        rho_output(i, :) = rho
        WRITE(*,*) "- Collision Step"
        CALL collision(f, rho, alpha, beta, Ma, c, cs, u, N)
        WRITE(*,*) "maximum moment after collision:", maxval(rho)
        WRITE(*,*) "minimum moment after collision:", minval(rho)
        WRITE(*,*) "-----------------------------------------------------"
    end do
   
    WRITE(filename,'(a,i4.4,a)') "density_end.txt"
    open (newunit=fh, action='write', file=filename, status='unknown')
    do i = 1, N   
            write (fh, *) rho_output(i, :)
    end do
    close(fh)

    WRITE(*,*) "Finished"
    WRITE(*,*) "-----------------------------------------------------"
    CALL cpu_time(t2)

    ! print used cpu time
    WRITE(*,*) "CPU Time : ",t2-t1
end program Advection_Diffusion_1D


