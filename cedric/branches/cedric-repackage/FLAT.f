      SUBROUTINE FLAT(KRD,IFLAT)
C
C     THIS SUBROUTINE ENABLES/DISABLES FLAT EARTH GEOMETRY AND
C     REFRACTION CORRECTIONS. IT AFFECTS THE ELEVATION COMMAND
C     AND THE REMAPPING FROM COPLANE TO CARTESIAN.
C
      CHARACTER*8 KRD(10)

      IF (KRD(2).EQ.'ON') THEN
         IFLAT=1
         WRITE(*,10)
 10      FORMAT(/,5X,'FLAT EARTH MODE ENABLED.')
         WRITE(8,25)
 25      FORMAT(5X,'NO CORRECTIONS FOR CURVATURE OF EARTH OR ',
     X          'REFRACTION WILL BE MADE')
      ELSE
         IFLAT=0
         WRITE(*,30)
 30      FORMAT(/,5X,'FLAT EARTH MODE DISABLED')
         WRITE(*,40)
 40      FORMAT(5X,'CORRECTIONS FOR CURVATURE OF EARTH WILL',
     X          ' BE MADE WHERE APPROPRIATE')
      END IF

      RETURN

      END
         
