c
c----------------------------------------------------------------------X
c
      SUBROUTINE ARC
C
C  DRAW ARCS OF CONSTANT HEIGHT ON ELEVATION OR COPLANE ANGLE SCANS
C
      INCLUDE 'dim.inc'
      INCLUDE 'data.inc'
      INCLUDE 'input.inc'
      CHARACTER*4  IH

      LOGICAL IFLAG
      LOGICAL FIRSTPT,WRITEH

      REAL NSMIN,NSMAX
      COMMON /INPUTCH/NAMFLD(MXF),IRATYP,ICORD
      CHARACTER*8 NAMFLD,IRATYP,ICORD
      COMMON /TERPC/U1,V1,U2,V2,U,V
      COMMON /ORIGINCH/NETWORK
      CHARACTER*8 NETWORK
      COMMON/ORIGIN/X0R,Y0R,H0,AZCOR,BAZ,XRD,YRD

      DIMENSION IARCBUF(1500),DELT(17),NCHAR(17)
      DIMENSION IARC(800)

      DATA IDSK,MXNR,MXLEN/7,1000,12000/
      DATA R/8507./
      DATA NDELT/17/
      DATA DELT/0.05,.10,.25,.50,1.0,2.5,5.0,10.,25.,50.,100.,250.,500.,
     +          1000.,2500.,5000.,10000./
      DATA NCHAR/2,1,2,1,1,1,0,0,0,0,0,0,0,0,0,0,0/
      DATA IFIL/0/

      RP2=2.0*R
      AZ1=AZMIN(ITPOLD)/57.2958
      AZ2=AZMAX(ITPOLD)/57.2958
      BAZR=(BAZ+AZROT(ITPOLD))/57.2958
      DELAZ=0.04363323
      IF((AZ2-AZ1)/DELAZ.LT.10.) DELAZ=(AZ2-AZ1)/10.
      AZLAST=AZ2+DELAZ
   20 CALL RNGLIM(XMIN(ITPOLD),XMAX(ITPOLD),YMIN(ITPOLD),YMAX(ITPOLD),
     +DMAX,DMIN)
      DPMIN=DMIN*DMIN/RP2
      DPMAX=DMAX*DMAX/RP2
      X=XMAX(ITPOLD)
      IF(ABS(XMAX(ITPOLD)).LT.ABS(XMIN(ITPOLD))) X=XMIN(ITPOLD)
      Y=YMAX(ITPOLD)
      IF(ABS(YMAX(ITPOLD)).LT.ABS(YMIN(ITPOLD))) Y=YMIN(ITPOLD)
      AZPR=ATAN2(X,Y)
      IF(IAZC.AND.AZPR.LT.0) AZPR=AZPR+6.28318531
      IF(AZPR-AZ1.LE.2.*DELAZ.OR.AZ2-AZPR.LE.2.*DELAZ)AZPR=(AZ1+AZ2)/2.0
      CALL GETSET (KA,KB,LA,LB,XC,XD,YC,YD,LTYPE)
      CRTCONV=(KB-KA)/(XMAX(ITPOLD)-XMIN(ITPOLD))
      RG1=GXMIN(ITPOLD)
      RG2=GXMAX(ITPOLD)
      HT1=GYMIN(ITPOLD)
      HT2=GYMAX(ITPOLD)
      IEL=FXOLD*10
      IF(FXOLD.GT.80..OR.FXOLD.LT.0.) RETURN
      CALL GETUSV('LW',ILW)
      JLW=1000
      CALL SETUSV('LW',JLW)
200   TANEL=TAN(FXOLD*0.01745)
      IF(ITPOLD.NE.2)THEN
         RTAN=R*TANEL
         RTANSQ=RTAN*RTAN
         HMIN=DMIN*TANEL+DPMIN+H0
         HMAX=DMAX*TANEL+DPMAX+H0
      ELSE
         HMIN=DMIN*TANEL+H0
         HMAX=DMAX*TANEL+H0
      END IF
      DELTAH=(HMAX-HMIN)/(IARCS(ITPOLD)-1)
  220 DO 221 I=2,NDELT
      I1=I
  221 IF(DELT(I-1)+0.5*(DELT(I)-DELT(I-1)).GT.DELTAH) GO TO 222
222   DELTAH=DELT(I1-1)
      N=NCHAR(I1-1)
      I=HMAX/DELTAH
      J=HMIN/DELTAH
      NARCS=I-J
      H=J*DELTAH
      DO 290 I=1,NARCS
      H=H+DELTAH
      NTOT=(ALOG10(H)+1)+N+1
      IF(N.EQ.0) THEN
         WRITE (IH, 1030) H
1030     FORMAT(F4.0)
      END IF
      IF(N.EQ.1) THEN
         WRITE (IH, 1031) H
1031     FORMAT(F4.1)
      END IF
      IF(N.EQ.2) THEN
         WRITE (IH, 1032) H
1032     FORMAT(F4.2)
      END IF
      AZ=AZ1-DELAZ
      IF(ITPOLD.NE.2)THEN
         D=-RTAN+SQRT(RTANSQ-RP2*(H0-H))
      ELSE
         IF(AZ.EQ.BAZR)AZ=AZ+DELAZ
         D=H/(ABS(SIN(AZ-BAZR))*TANEL)
      END IF
      X0=D*SIN(AZ)
      Y0=D*COS(AZ)
      IF(ICVRT) THEN
         CALL CONVERT(X0,Y0)
      END IF
      FIRSTPT=.TRUE.
      WRITEH=.FALSE.
  230 AZ=AZ+DELAZ
      IF(ITPOLD.EQ.2)THEN
         IF(AZ.EQ.BAZR)AZ=AZ+DELAZ
         D=H/(ABS(SIN(AZ-BAZR))*TANEL)
      END IF
      IF(AZ.GE.AZLAST) GO TO 290
      X=D*SIN(AZ)
      Y=D*COS(AZ)
      IF(ICVRT) THEN
         CALL CONVERT(X,Y)
      END IF
      IF(X.LT.RG1.OR.X.GT.RG2) GO TO 250
      IF(Y.LT.HT1.OR.Y.GT.HT2) GO TO 250
      IF(WRITEH) GO TO 235
      IF(ABS(AZ-AZPR).LE.DELAZ/2.0) GO TO 260
  235 IF(.NOT.FIRSTPT) GO TO 240
      U1=X
      V1=Y
      U2=X0
      V2=Y0
      CALL TERP(RG1,RG2,HT1,HT2)
      CALL FRSTPT(U,V)
      FIRSTPT=.FALSE.
  240 CALL VECTOR(X,Y)
  245 X0=X
      Y0=Y
      GO TO 230
  250 IF(FIRSTPT) GO TO 245
      U1=X0
      V1=Y0
      U2=X
      V2=Y
      CALL TERP(RG1,RG2,HT1,HT2)
      CALL LINE(X0,Y0,U,V)
      FIRSTPT=.TRUE.
      GO TO 230
  260 IF(.NOT.FIRSTPT) GO TO 261
      U1=X
      V1=Y
      U2=X0
      V2=Y0
      CALL TERP(RG1,RG2,HT1,HT2)
      CALL FRSTPT(U,V)
  261 CALL VECTOR(X,Y)
      J=0
      AZP=AZ
  262 AZP=AZP+(DELAZ/4.0)
      IF(ITPOLD.EQ.2)THEN
         IF(AZP.EQ.BAZR)AZP=AZP+DELAZ
         D=H/(ABS(SIN(AZP-BAZR))*TANEL)
      END IF
      J=J+1
      X0=D*SIN(AZP)
      Y0=D*COS(AZP)
      IF(ICVRT) THEN
         CALL CONVERT(X0,Y0)
      END IF
      IXUNITS=ABS(X-X0)*CRTCONV
      IYUNITS=ABS(Y-Y0)*CRTCONV
      IF(IYUNITS.LE.12.AND.IXUNITS.LE.NTOT*8) GO TO 262
      X=(X0+X)/2.0
      Y=(Y0+Y)/2.0
      CALL PLCHMQ (X, Y, IH, 12.0, 0.0,0.0)
      CALL FRSTPT(X0,Y0)
      J=(J-1)/4+1
      AZ=AZ+DELAZ*J-DELAZ
      WRITEH=.TRUE.
      FIRSTPT=.FALSE.
      IF(X0.LT.RG1.OR.X0.GT.RG2) FIRSTPT=.TRUE.
      IF(Y0.LT.HT1.OR.Y0.GT.HT2) FIRSTPT=.TRUE.
      GO TO 230
  290 CONTINUE
  300 CONTINUE
      CALL SETUSV('LW',ILW)
      RETURN

 1001 FORMAT(I5)
 1003 FORMAT(1X,' ARC READ ERROR, STATUS',O20)
 1004 FORMAT(1X,' ARC WRITE ERROR,STATUS',O20)
 1020 FORMAT(  '(F',I1,'.',I1,')'   )
      END