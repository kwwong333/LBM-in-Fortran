module test2

contains
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
        
        do i = 2, N-1
            CALL equilibrium_f(f_eqt, rho(i), Ma, cs, c, u, i, N)
        end do
        
        do i = 2, N-1
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
        real :: left_bnd, right_bnd
        
        ! Periodic Boundary
        right_bnd= f(2, N)
        left_bnd = f(3, 1)
        
        do i = N, 2
            f(2, i) = f(2, i-1)
        end do
        
        do i = 1, N-1
            f(3, i) = f(3, i+1)
        end do
        
        f(2,1) = right_bnd
        f(3,N) = left_bnd
        
        WRITE(*,*) "LBM shift performed"
        return
    end
        
    
end module test2
