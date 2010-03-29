c
c----------------------------------------------------------------------X
c
      SUBROUTINE GETMRK(INDAT,NMRK,XMRK,YMRK,ZMRK,AMRK,MXK,IMRK,NET,
     X                  NNET,SMRK,OLAT,OLON,ANGXAX,CMRK,ORLAT,ORLON)
C
C  READ IN LANDMARK POSITIONS (LAT-LON-HEIGHT) FROM MRKFILE:
C     CONVERT THEM TO (X,Y) FROM (OLAT,OLON)
C  NOTE: (OLAT,OLON) MUST BE THE (LAT,LON) OF THE PLOTTING WINDOW ORIGIN,
C        WHERE THE WINDOW IS DEFINED BY (GXMIN,GXMAX,GYMIN,GYMAX)
C
C     FOR EACH OF (20) POSSIBLE NETWORKS:
C                 NET - NUMBER OF NETWORKS
C                NNET - NUMBER OF STATIONS IN NTH NETWORK
C                SMRK - PLOTTING SYMBOL (COMPLEX CHARACTER SET)
C     XMRK,YMRK,ZMRK  - (X,Y,Z) position of landmark relative to origin
C     AMRK            - Angular convergence relative to origin found by 
C                       the azimuth of a line from the station to one deg
C                       north of the station.
C     CMRK            - Character size for station names.
C
      DIMENSION XMRK(MXK),YMRK(MXK),ZMRK(MXK),AMRK(MXK)
      DIMENSION NNET(20)
      CHARACTER MRKFILE*32,IDIR*4,NSTAT*8
      CHARACTER*11 MRKDAT(6)
      CHARACTER*8 INDAT(10)
      CHARACTER*8 BLANK
      CHARACTER*7 NMRK(MXK)
      CHARACTER*6 SMRK(20)
      DATA BLANK/'        '/
      DATA TORAD,TODEG/0.017453293,57.29577951/

      IF(INDAT(9).EQ.BLANK)THEN
         READ(INDAT,3)IDIR,OLAT,OLON,CMRK
 3       FORMAT(/////A4,4X,/F8.0/F8.0//F8.0)
      ELSE
         READ(INDAT,4)IDIR,OLAT,OLON,ANGXAX,CMRK
 4       FORMAT(/////A4,4X,/F8.0/F8.0/F8.0/F8.0)
      END IF
      IF(OLAT.EQ.0.0 .AND. ORLAT.NE.0.0)OLAT=ORLAT
      IF(OLON.EQ.0.0 .AND. ORLON.NE.0.0)OLON=ORLON
      IF(IDIR.EQ.'WEST')THEN
         OLON=+1.0*ABS(OLON)
      ELSE
         OLON=-1.0*ABS(OLON)
      END IF
      MRKFILE=INDAT(2)//INDAT(3)//INDAT(4)//INDAT(5)
      WRITE(6,5)MRKFILE,IDIR,OLAT,OLON,ANGXAX
 5    FORMAT(1X,'GETMRK: LANDMARK POSITION FILE= ',A32,A4,4X,2F12.5,
     X     F8.1)
      OPEN(UNIT=9,FILE=MRKFILE,STATUS='OLD')
      
      IMRK=0
      NET=0
 6    READ(9,61,END=20)(MRKDAT(I),I=1,6)
 61   FORMAT(6A11)
      WRITE(6,7)(MRKDAT(I),I=1,6)
 7    FORMAT(6A11)
      IF(MRKDAT(1)(2:2).EQ.'&')THEN
         NET=NET+1
         IF(NET.GT.20)NET=20
         READ(MRKDAT,8)SMRK(NET),FMRK
 8       FORMAT(1X,A6,4X/F11.0////)
         NNET(NET)=INT(FMRK)
         WRITE(6,9)NET,SMRK(NET),NNET(NET)
 9       FORMAT(1X,'NET,SMRK,NNET=',I8,2X,A6,I8)
         GO TO 6
      END IF
      IF(MRKDAT(1)(2:8).NE.'STATION')GO TO 6
 10   READ(9,11,END=20)NSTAT,PLAT,PLON,ZMSL
 11   FORMAT(1X,A8,2X,3F11.6)
      IF(IDIR.EQ.'WEST')THEN
         PLON=+1.0*ABS(PLON)
      ELSE
         PLON=-1.0*ABS(PLON)
      END IF
      IF(PLAT.EQ.0.0 .AND. PLON.EQ.0.0 .AND. ZMSL.EQ.0.0)GO TO 10
      
      CALL LL2XYDRV(PLAT,PLON,X,Y,OLAT,OLON,ANGXAX)
      IMRK=IMRK+1
      IF(IMRK.GT.MXK)THEN
         IMRK=IMRK-1
         CLOSE (UNIT=9)
         RETURN
      END IF
      XMRK(IMRK)=X
      YMRK(IMRK)=Y
      ZMRK(IMRK)=ZMSL/1000.0
      HRNG=SQRT(X*X+Y*Y)

      IF(Y.EQ.0.0.AND.X.EQ.0.0)THEN
         AZ=180.0
      ELSE IF(Y.EQ.0.0.AND.X.GT.0.0)THEN
         AZ=90.0
      ELSE IF(Y.EQ.0.0.AND.X.LT.0.0)THEN
         AZ=270.0
      ELSE
         AZ=TODEG*ATAN2(X,Y)
      END IF
      IF(AZ.LT.0.0)THEN
         AZIM=AZ+360.0
      ELSE
         AZIM=AZ
      END IF
      PPLAT=PLAT+1.0
      PPLON=PLON
      CALL LL2XYDRV(PPLAT,PPLON,XN,YN,OLAT,OLON,ANGXAX)
      DX=XN-X
      DY=YN-Y
      AMRK(IMRK)=TODEG*ATAN2(DX,DY)
      WRITE(NMRK(IMRK),13)NSTAT
 13   FORMAT(A7)
      WRITE(6,15)IMRK,NMRK(IMRK),PLAT,PLON,ZMSL,
     +     X,Y,ZMRK(IMRK),AMRK(IMRK),HRNG,AZIM
 15   FORMAT(1X,'I,NAME,LL,Z=',I6,2X,A7,1X,2F10.4,F8.1,
     +     '  X,Y,Z,DA=',4F8.2,' HRNG,AZ=',2F8.2)
      GO TO 10

 20   CONTINUE
      CLOSE (UNIT=9)
      RETURN
      END
