      SUBROUTINE ASDPMD (IA,IB,NRP)
C  TO CONVERT UNPACKED ASCII CODES TO ALPHANUMERIC CHARACTERS
      INCLUDE 'CEDRIC.INC'
      DIMENSION IA(1),IB(1)
C      DATA I6BL/6R      /
      NUMSHFT=WORDSZ-16

      DO 10 I=1,NRP
         IB(I)=ICEDSHFT(IA(I),NUMSHFT)

C
C     THE FOLLOWING COMMENTED COMMAND IS USED IN THE CRAY VERSION.
C     HOWEVER, I'M NOT SURE WHAT IT DOES. (B. Anderson)
C         IB(I)=OR(IB(I),I6BL)
 10   CONTINUE
      RETURN
      END
