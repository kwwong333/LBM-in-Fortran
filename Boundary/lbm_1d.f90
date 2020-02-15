module LBM_1D
! Contains all LBM related  modules for 1D simulation
! Subrotines
!   - sum_moment
!   - equilibrium_f
!   - lbm_shift

contains

subroutine sum_moment (rho, f, N)
    implicit none
    integer :: i, N
    real, dimension (3, N) :: f
    real, dimension (N) :: rho
    
    WRITE(*,*) rho(1), rho(2), rho(3)

    do i = 1, N
        rho(i) = f(1,i) + f(2,i) + f(3,i)
    end do

    WRITE(*,*) rho(1), rho(2), rho(3)

    return
end

subroutine equilibrium_f (f_eq, rho_, Ma, cs, u, c, i, N)
    implicit none
    real :: Ma, cs, u, c
    integer :: i, N
    real, dimension(3, N) :: f_eq
    real :: rho_
    
    f_eq(1,i)=2.0*rho_*(2.0-sqrt(1.0+Ma**2.0))/3.0
    f_eq(2,i)=rho_*((u*c-cs**2.0)/(2.0*cs**2.0)+sqrt(1.0+Ma**2.0))/3.0
    f_eq(3,i)=rho_*((-u*c-cs**2.0)/(2.0*cs**2.0)+sqrt(1.0+Ma**2.0))/3.0

    return
end
        
subroutine advection (f, N)
    implicit none
    integer :: N
    real, dimension(3, N) :: f
    call lbm_shift(f, N)
    return
end 
    
subroutine collision (f, rho, alpha, beta, Ma, cs, u, c, N)
    implicit none
    real, dimension(3, N) :: f, f_eqt
    real, dimension(N) :: rho
    real :: Ma, cs, alpha, beta, u, c
    integer :: i, N

    f_eqt = f

    do i = 1, N
        CALL equilibrium_f(f_eqt, rho(i), Ma, cs, u, c, i, N)
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
    integer:: i, j, N
    real :: left_bnd, right_bnd
    
    ! Periodic Boundary
    right_bnd= f(2, N)
    left_bnd = f(3, 1)
    
    do i = N, 1, -1
        f(2, i) = f(2, i-1)
        !write(*,*) i
    end do
    
    do j = 1, N
        f(3, j) = f(3, j+1)
    end do
    
    f(2,1) = right_bnd
    f(3,N) = left_bnd
    
    WRITE(*,*) "LBM shift performed"
    return
end
    
    
end module LBM_1D
