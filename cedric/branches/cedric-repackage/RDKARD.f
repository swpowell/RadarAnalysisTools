      SUBROUTINE RDKARD(KRD)
C
C        READS CARD IN 10A8 FORMAT
C
      CHARACTER*(*) KRD(10)
C
      READ 101, KRD
 101  FORMAT (10A8)
      RETURN
      END
