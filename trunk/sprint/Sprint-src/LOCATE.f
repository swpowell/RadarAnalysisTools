      FUNCTION LOCATE(NAM,LST,LEN)
C        LOCATES A TEXT STRING IN A SET OF VALID CANDIDATES
      DIMENSION LST(LEN)
      IF(LEN.LE.0) GO TO 20
      DO 10 I=1,LEN
         L=I
         IF(NAM.EQ.LST(L)) GO TO 30
   10 CONTINUE
   20 L=0
   30 LOCATE=L
      RETURN
      END