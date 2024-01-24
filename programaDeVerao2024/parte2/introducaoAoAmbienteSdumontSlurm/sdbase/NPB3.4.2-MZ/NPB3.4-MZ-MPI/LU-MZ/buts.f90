!---------------------------------------------------------------------
!---------------------------------------------------------------------

      subroutine buts( nx, nxmax, ny, nz, k, ist, iend,  &
     &                 omega, v, tv, d, udx, udy, udz)

!---------------------------------------------------------------------
!---------------------------------------------------------------------

!---------------------------------------------------------------------
!
!   compute the regular-sparse, block upper triangular solution:
!
!                     v <-- ( U-inv ) * v
!
!---------------------------------------------------------------------

      implicit none

!---------------------------------------------------------------------
!  input parameters
!---------------------------------------------------------------------
      integer nx, nxmax, ny, nz
      integer k, ist, iend
      double precision  omega
!---------------------------------------------------------------------
      double precision v(5,-1:nxmax+2,ny,nz), tv(5,nxmax,ny),  &
     &                 d(5,5,nxmax,ny), udx(5,5,nxmax,ny),  &
     &                 udy(5,5,nxmax,ny), udz(5,5,nxmax,ny)

!---------------------------------------------------------------------
!  local variables
!---------------------------------------------------------------------
      integer i, j, m
      double precision  tmp, tmp1, tmat(5,5)


!$OMP DO SCHEDULE(STATIC)
      do j = ny-1, 2, -1
         do i = iend, ist, -1
            do m = 1, 5
                  tv( m, i, j ) =  &
     &      omega * (  udz( m, 1, i, j ) * v( 1, i, j, k+1 )  &
     &               + udz( m, 2, i, j ) * v( 2, i, j, k+1 )  &
     &               + udz( m, 3, i, j ) * v( 3, i, j, k+1 )  &
     &               + udz( m, 4, i, j ) * v( 4, i, j, k+1 )  &
     &               + udz( m, 5, i, j ) * v( 5, i, j, k+1 ) )
            end do
         end do
      end do
!$OMP END DO nowait

!$OMP DO SCHEDULE(STATIC)
      do j = ny-1, 2, -1
         do i = iend, ist, -1
            do m = 1, 5
                  tv( m, i, j ) = tv( m, i, j )  &
     & + omega * ( udy( m, 1, i, j ) * v( 1, i, j+1, k )  &
     &           + udx( m, 1, i, j ) * v( 1, i+1, j, k )  &
     &           + udy( m, 2, i, j ) * v( 2, i, j+1, k )  &
     &           + udx( m, 2, i, j ) * v( 2, i+1, j, k )  &
     &           + udy( m, 3, i, j ) * v( 3, i, j+1, k )  &
     &           + udx( m, 3, i, j ) * v( 3, i+1, j, k )  &
     &           + udy( m, 4, i, j ) * v( 4, i, j+1, k )  &
     &           + udx( m, 4, i, j ) * v( 4, i+1, j, k )  &
     &           + udy( m, 5, i, j ) * v( 5, i, j+1, k )  &
     &           + udx( m, 5, i, j ) * v( 5, i+1, j, k ) )
            end do

!---------------------------------------------------------------------
!   diagonal block inversion
!---------------------------------------------------------------------
            do m = 1, 5
               tmat( m, 1 ) = d( m, 1, i, j )
               tmat( m, 2 ) = d( m, 2, i, j )
               tmat( m, 3 ) = d( m, 3, i, j )
               tmat( m, 4 ) = d( m, 4, i, j )
               tmat( m, 5 ) = d( m, 5, i, j )
            end do

            tmp1 = 1.0d0 / tmat( 1, 1 )
            tmp = tmp1 * tmat( 2, 1 )
            tmat( 2, 2 ) =  tmat( 2, 2 )  &
     &           - tmp * tmat( 1, 2 )
            tmat( 2, 3 ) =  tmat( 2, 3 )  &
     &           - tmp * tmat( 1, 3 )
            tmat( 2, 4 ) =  tmat( 2, 4 )  &
     &           - tmp * tmat( 1, 4 )
            tmat( 2, 5 ) =  tmat( 2, 5 )  &
     &           - tmp * tmat( 1, 5 )
            tv( 2, i, j ) = tv( 2, i, j )  &
     &        - tv( 1, i, j ) * tmp

            tmp = tmp1 * tmat( 3, 1 )
            tmat( 3, 2 ) =  tmat( 3, 2 )  &
     &           - tmp * tmat( 1, 2 )
            tmat( 3, 3 ) =  tmat( 3, 3 )  &
     &           - tmp * tmat( 1, 3 )
            tmat( 3, 4 ) =  tmat( 3, 4 )  &
     &           - tmp * tmat( 1, 4 )
            tmat( 3, 5 ) =  tmat( 3, 5 )  &
     &           - tmp * tmat( 1, 5 )
            tv( 3, i, j ) = tv( 3, i, j )  &
     &        - tv( 1, i, j ) * tmp

            tmp = tmp1 * tmat( 4, 1 )
            tmat( 4, 2 ) =  tmat( 4, 2 )  &
     &           - tmp * tmat( 1, 2 )
            tmat( 4, 3 ) =  tmat( 4, 3 )  &
     &           - tmp * tmat( 1, 3 )
            tmat( 4, 4 ) =  tmat( 4, 4 )  &
     &           - tmp * tmat( 1, 4 )
            tmat( 4, 5 ) =  tmat( 4, 5 )  &
     &           - tmp * tmat( 1, 5 )
            tv( 4, i, j ) = tv( 4, i, j )  &
     &        - tv( 1, i, j ) * tmp

            tmp = tmp1 * tmat( 5, 1 )
            tmat( 5, 2 ) =  tmat( 5, 2 )  &
     &           - tmp * tmat( 1, 2 )
            tmat( 5, 3 ) =  tmat( 5, 3 )  &
     &           - tmp * tmat( 1, 3 )
            tmat( 5, 4 ) =  tmat( 5, 4 )  &
     &           - tmp * tmat( 1, 4 )
            tmat( 5, 5 ) =  tmat( 5, 5 )  &
     &           - tmp * tmat( 1, 5 )
            tv( 5, i, j ) = tv( 5, i, j )  &
     &        - tv( 1, i, j ) * tmp



            tmp1 = 1.0d0 / tmat( 2, 2 )
            tmp = tmp1 * tmat( 3, 2 )
            tmat( 3, 3 ) =  tmat( 3, 3 )  &
     &           - tmp * tmat( 2, 3 )
            tmat( 3, 4 ) =  tmat( 3, 4 )  &
     &           - tmp * tmat( 2, 4 )
            tmat( 3, 5 ) =  tmat( 3, 5 )  &
     &           - tmp * tmat( 2, 5 )
            tv( 3, i, j ) = tv( 3, i, j )  &
     &        - tv( 2, i, j ) * tmp

            tmp = tmp1 * tmat( 4, 2 )
            tmat( 4, 3 ) =  tmat( 4, 3 )  &
     &           - tmp * tmat( 2, 3 )
            tmat( 4, 4 ) =  tmat( 4, 4 )  &
     &           - tmp * tmat( 2, 4 )
            tmat( 4, 5 ) =  tmat( 4, 5 )  &
     &           - tmp * tmat( 2, 5 )
            tv( 4, i, j ) = tv( 4, i, j )  &
     &        - tv( 2, i, j ) * tmp

            tmp = tmp1 * tmat( 5, 2 )
            tmat( 5, 3 ) =  tmat( 5, 3 )  &
     &           - tmp * tmat( 2, 3 )
            tmat( 5, 4 ) =  tmat( 5, 4 )  &
     &           - tmp * tmat( 2, 4 )
            tmat( 5, 5 ) =  tmat( 5, 5 )  &
     &           - tmp * tmat( 2, 5 )
            tv( 5, i, j ) = tv( 5, i, j )  &
     &        - tv( 2, i, j ) * tmp



            tmp1 = 1.0d0 / tmat( 3, 3 )
            tmp = tmp1 * tmat( 4, 3 )
            tmat( 4, 4 ) =  tmat( 4, 4 )  &
     &           - tmp * tmat( 3, 4 )
            tmat( 4, 5 ) =  tmat( 4, 5 )  &
     &           - tmp * tmat( 3, 5 )
            tv( 4, i, j ) = tv( 4, i, j )  &
     &        - tv( 3, i, j ) * tmp

            tmp = tmp1 * tmat( 5, 3 )
            tmat( 5, 4 ) =  tmat( 5, 4 )  &
     &           - tmp * tmat( 3, 4 )
            tmat( 5, 5 ) =  tmat( 5, 5 )  &
     &           - tmp * tmat( 3, 5 )
            tv( 5, i, j ) = tv( 5, i, j )  &
     &        - tv( 3, i, j ) * tmp



            tmp1 = 1.0d0 / tmat( 4, 4 )
            tmp = tmp1 * tmat( 5, 4 )
            tmat( 5, 5 ) =  tmat( 5, 5 )  &
     &           - tmp * tmat( 4, 5 )
            tv( 5, i, j ) = tv( 5, i, j )  &
     &        - tv( 4, i, j ) * tmp

!---------------------------------------------------------------------
!   back substitution
!---------------------------------------------------------------------
            tv( 5, i, j ) = tv( 5, i, j )  &
     &                      / tmat( 5, 5 )

            tv( 4, i, j ) = tv( 4, i, j )  &
     &           - tmat( 4, 5 ) * tv( 5, i, j )
            tv( 4, i, j ) = tv( 4, i, j )  &
     &                      / tmat( 4, 4 )

            tv( 3, i, j ) = tv( 3, i, j )  &
     &           - tmat( 3, 4 ) * tv( 4, i, j )  &
     &           - tmat( 3, 5 ) * tv( 5, i, j )
            tv( 3, i, j ) = tv( 3, i, j )  &
     &                      / tmat( 3, 3 )

            tv( 2, i, j ) = tv( 2, i, j )  &
     &           - tmat( 2, 3 ) * tv( 3, i, j )  &
     &           - tmat( 2, 4 ) * tv( 4, i, j )  &
     &           - tmat( 2, 5 ) * tv( 5, i, j )
            tv( 2, i, j ) = tv( 2, i, j )  &
     &                      / tmat( 2, 2 )

            tv( 1, i, j ) = tv( 1, i, j )  &
     &           - tmat( 1, 2 ) * tv( 2, i, j )  &
     &           - tmat( 1, 3 ) * tv( 3, i, j )  &
     &           - tmat( 1, 4 ) * tv( 4, i, j )  &
     &           - tmat( 1, 5 ) * tv( 5, i, j )
            tv( 1, i, j ) = tv( 1, i, j )  &
     &                      / tmat( 1, 1 )

            v( 1, i, j, k ) = v( 1, i, j, k ) - tv( 1, i, j )
            v( 2, i, j, k ) = v( 2, i, j, k ) - tv( 2, i, j )
            v( 3, i, j, k ) = v( 3, i, j, k ) - tv( 3, i, j )
            v( 4, i, j, k ) = v( 4, i, j, k ) - tv( 4, i, j )
            v( 5, i, j, k ) = v( 5, i, j, k ) - tv( 5, i, j )

        enddo
      end do
!$OMP END DO nowait

 
      return
      end
