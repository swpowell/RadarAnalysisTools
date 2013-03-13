      
      SUBROUTINE SKIPP(IUNIT,ISKIP)
C
C        THIS SUBROUTINE CONTAINS 2 PROCEDURES
C           -SKPVOL SKIPS ISKIP VOLUMES (FILES)
C           -SKPREC SKIPS ISKIP RECORDS
C
      DIMENSION JUNK(1)
      DATA NBKI,MODE,NTYPE/1,1,2/
C
      ENTRY SKPVOL(IUNIT,ISKIP)
C
      IF (ISKIP.LE.0) GOTO 250
      
      CALL FILETYP(IUNIT,ICDF,NST)
      print *,'SKIPP: iunit,icdf,nst=',iunit,icdf,nst
      IF (ICDF.EQ.0) THEN
C
C     FILE IS COS BLOCKED BINARY
C
         KTREC = 0
         DO 200 I=1,ISKIP
 50         CONTINUE
            CALL  RDTAPE (IUNIT,MODE,NTYPE,JUNK,NBKI)
            CALL  IOWAIT (IUNIT, ISTA, IWD)
            IF(ISTA .EQ. 3 .OR. ISTA .EQ. 2) GO TO 200
            IF(ISTA .EQ. 1) GO TO 100
            KTREC = KTREC+1
            GO TO 50
 100        CONTINUE
            KTREC = 0
 200     CONTINUE
      ELSE IF (ICDF.EQ.1) THEN
C
C     FILE IS PURE BINARY
C
         CALL CSKPVOL(IUNIT,ISKIP,NST)
      END IF
  250 CONTINUE
      RETURN
C
      ENTRY SKPREC(IUNIT,ISKIP)
C
         
      IF (ISKIP.LE.0) GOTO 350
      DO 300 I=1,ISKIP
         CALL RDTAPE(IUNIT,MODE,NTYPE,JUNK,NBKI)
         CALL IOWAIT(IUNIT,NST,NWDS)
         IF (NST.NE.0) GOTO 525
 300  CONTINUE
  350 CONTINUE
      RETURN
 525  CONTINUE
      CALL TAPMES(IUNIT,NST)
      CALL CEDERX(545,1)
      CALL FLUSH_STDOUT
      RETURN
      END
