      FUNCTION ICONSC(IHMS)
C
C        CONVERTS HHMMSS TO SECONDS
C
      IHR=IHMS/10000
      IMIN=(IHMS-(IHR*10000))/100
      ISEC=IHMS-(IHR*100+IMIN)*100
      ICONSC=(IHR*60+IMIN)*60+ISEC
      RETURN
      END
