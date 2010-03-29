      SUBROUTINE KARDIN(KARD)
C
C-----THIS SUBROUTINE IS RESPONSIBLE FOR READING
C  ONE ENTIRE INPUT CARD IMAGE FORMAT.
C
      CHARACTER*8 KARD(10)
      CHARACTER*3 KCOM,KEYW
      CHARACTER*1 ICHK,IAST
      DATA KCOM/'C  '/
      DATA IAST/'*'/
C
C        CONTINUE TO READ IN MORE CARD IMAGES IF A COMMENT IS ENCOUNTERED:
C
 10   CONTINUE
C
      READ(5,1000) KARD
 1000 FORMAT(10A8)
      WRITE(6,2000) KARD
 2000 FORMAT(' >>>>>',10A8,'<<<<< ')
      READ (KARD,3000)KEYW
 3000 FORMAT(A3)
      IF (KEYW.EQ.KCOM) GO TO 10
C
C        CHECK FOR A *COMMENT
C
      READ (KARD,3001)ICHK
 3001 FORMAT(A1)
      IF(ICHK.EQ.IAST) GO TO 10
C
      RETURN
      END