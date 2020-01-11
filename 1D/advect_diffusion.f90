program Advection_Diffusion_1D
    implicit none
    ! CPU timing Variables 
    REAL :: t1, t2 

    ! Parameters
    INTEGER , PARAMETER :: N = 400              ! number of nodes
    REAL , PARAMETER :: Ma = 0.1                  ! Mach number
    REAL , PARAMETER :: D = 5.0E-08            ! diffusion coefficient
    REAL , PARAMETER :: c = 2.0                   ! molecular speed
    REAL , PARAMETER :: cs = 1.0/(3**0.5)            ! speed of sound
    REAL , PARAMETER :: u = Ma*cs                ! advection velocity
    INTEGER , PARAMETER :: T = floor(0.5*N/u)       ! number of timesteps
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
        CALL advection(f, N)
        WRITE(*,*) "maximum moment before:", maxval(rho)
        WRITE(*,*) "minimum moment before:", minval(rho)
        WRITE(*,*) "- Moment Calculation Step"
        CALL sum_moment(rho, f, N)
        WRITE(*,*) "maximum moment after:", maxval(rho)
        WRITE(*,*) "minimum moment after:", minval(rho)
        rho_output(i, :) = rho
        WRITE(*,*) "- Collision Step"
        CALL collision(f, rho, alpha, beta, Ma, c, cs, u, N)
        WRITE(*,*) "-----------------------------------------------------"
    end do
   
    WRITE(filename,'(a,i4.4,a)') "time", i,".txt"
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

subroutine sum_moment (rho, f, N)
    implicit none
    integer :: i, N
    real, dimension (3, N) :: f
    real, dimension (N) :: rho
    do i = 1, N
        rho(i) = f(1,i) + f(2,i) + f(3,i)
    end do
    return
end

subroutine equilibrium_f (f_eq, rho_, Ma, cs, c, u, i, N)
    implicit none
    real:: Ma, cs, c, u
    integer :: i, N
    real, dimension(3, N) :: f_eq
    real :: rho_
    f_eq(1,i)=2.0*rho_*(2.0-sqrt(1.0+Ma**2.0))/3.0
    f_eq(2,i)=rho_*(( Ma*cs-cs**2.0)/(2.0*cs**2.0)+sqrt(1.0+Ma**2.0))/3.0
    f_eq(3,i)=rho_*((-Ma*cs-cs**2.0)/(2.0*cs**2.0)+sqrt(1.0+Ma**2.0))/3.0
    return
end

subroutine advection (f, N)
    implicit none
    integer :: N
    real, dimension(3, N) :: f
    call lbm_shift(f, N)
    return
end 

subroutine collision (f, rho, alpha, beta, Ma, c, cs, u, N)
    implicit none
    real, dimension(3, N) :: f, f_eqt
    real, dimension(N) :: rho
    real :: Ma, cs, c, u, alpha, beta
    integer :: i, N
    f_eqt = f
    do i = 1, N
        CALL equilibrium_f(f_eqt, rho(i), Ma, cs, c, u, i, N)
    end do
    
    do i = 1, N
        f(1,i) = f(1,i)+alpha*beta*(f_eqt(1,i)-f(1,i))
        f(2,i) = f(2,i)+alpha*beta*(f_eqt(2,i)-f(2,i))
        f(3,i) = f(3,i)+alpha*beta*(f_eqt(3,i)-f(3,i))
    end do

    return
end

subroutine lbm_shift(f, N)
    implicit none
    real, dimension(3, N) :: f
    integer:: i, N
    do i = 1, N
        if (i == N) then
            f(2, N) = f(2, N-1)
            f(3, N) = f(3, 1)
        else if (i == 1) then
            f(2, 1) = f(2, N)
            f(3, 1) = f(3, 2)
        else 
            f(2, i) = f(2, i-1)
            f(3, i) = f(3, i+1)
        end if
    end do
    WRITE(*,*) "LBM shift performed"
    return
end

