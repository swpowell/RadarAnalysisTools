      SUBROUTINE IGTDAT(IWRD,IDAT,N,MAXFLD)
C
C        RETURNS SIGNED 16-BIT INTEGER VALUES FROM A PACKED 64-BIT CRAY WORD
C
      INTEGER CVMGP
      DIMENSION IDAT(MAXFLD)
      CALL GBYTES(IWRD,IDAT,0,16,0,N)
      DO 10 I=1,N
         IT1=IDAT(I)
      IT2=CVMGP(IT1-65536,IT1,IT1-32768)
      IDAT(I)=IT2
   10 CONTINUE
      RETURN
      END