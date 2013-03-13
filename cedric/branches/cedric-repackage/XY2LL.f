c
c----------------------------------------------------------------------X
c
      SUBROUTINE XY2LL (DEGLAT,DEGLON,X,Y,SWLAT,SWLON)
C
C-----COMPUTES LATITUDE AND LONGITUDE FROM X,Y COORDINATES RELATIVE TO
C     LOCATION SPECIFIED BY SWLAT,SWLON.
C
C     DEGLAT- OUTPUT PARAMETER IN DEGREES OF LATITUDE
C     DEGLON- OUTPUT PARAMETER IN DEGREES OF LONGITUDE
C     X,Y-    INPUT COORDINATES OF LOCATION TO BE CONVERTED
C     SWLAT-  INPUT PARAMETER IN DEG OF LATITUDE OF REFERENCE LOCATION
C     SWLON-  INPUT PARAMETER IN DEG OF LONG. OF REFERERENCE LOCATION
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      REAL DEGLAT,DEGLON,X,Y,SWLAT,SWLON

C      REAL  ACZ
C      REAL  CANG
C      REAL  DTR
      DOUBLE PRECISION  LAMDA1,LAMDA2
C      REAL  PHI1,PHI2
C      REAL  R
C      REAL  RTD
C      REAL  SANG
C      REAL  THETA
C
      DATA DEGARC/111.354/
      DATA DTR,RTD/0.017453293,57.2957795/
C
      DEGLAT = SWLAT
      DEGLON = SWLON
C
      R = SQRT(X*X + Y*Y)
      IF (R .LT. 0.01) GO TO 10
C
      THETA = ATAN2(X,Y)
      R = (R/DEGARC) * DTR
C
      PHI1 = DTR * SWLAT
      LAMDA1 = DTR * SWLON
C
      SANG = COS(THETA)*COS(PHI1)*SIN(R)+SIN(PHI1)*COS(R)
      IF(ABS(SANG).GT.1.0) THEN
         IF(SANG .LT. 0.0) SANG = -1.0
         IF(SANG .GT. 0.0) SANG =  1.0
      ENDIF
CSANG=SIGN(1.0,SANG)
      PHI2=ASIN(SANG)
C
      CANG = (COS(R)-SIN(PHI1)*SIN(PHI2))/(COS(PHI1)*COS(PHI2))
      IF(ABS(CANG).GT.1.0) THEN
         IF(CANG .LT. 0.0) CANG = -1.0
         IF(CANG .GT. 0.0) CANG =  1.0
      ENDIF
CCANG=SIGN(1.0,CANG)
      ACZ=ACOS(CANG)
C
      IF (X .LT. 0.0) THEN
          LAMDA2 = LAMDA1 + ACZ
      ELSE
          LAMDA2 = LAMDA1 - ACZ
      END IF
C
      DEGLAT = RTD * PHI2
      DEGLON = RTD * LAMDA2
C
 10   CONTINUE
C
      RETURN
      END
