*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_320                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Imprimir Dependentes maior de 21 anos    ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 02/11/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PUBLIC continua := .T., nPg := 0

DBCLOSEALL()
SELECT 1
IF NetUse("DEPEND")
   SET INDEX TO DBIDEPA2,DBIDEPA1
ELSE
   RETURN
ENDIF

ProgName("GC320")
/* Verificar se existe algum dependente > 21 anos */
WHILE !EOF()
   IF CalcIdade(DATE(),DTNAS) >= 21
      EXIT
   ENDIF
   DBSKIP()
ENDDO
IF EOF()
   Aviso("No h  dependentes maiores de 21 anos")
ELSE
   IF ChkImpr()
      cAviso := MsgImp()
      ImpApl()
      TiraMsgImp(cAviso)
      Beep(2)
      Mensagem("Fim de Impresso, tecle algo...")
      INKEY(0)
   ENDIF
ENDIF
RELEASE continua, nPg
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Listagem            ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE ImpApl()
   Gera_TXT("AP320.TXT")
   SETPRC(0,0)
   lCabec := CabApl()
   DBGOTOP()
   WHILE continua .AND. !EOF()
      IF !lCabec
         lCabec := CabApl()
      ENDIF
      IF CalcIdade(DATE(),DTNAS) >= 21
         ChkInterv("CabApl",1,01,MATRICULA,"[99999]")
         ChkInterv("CabApl",0,08,NOME)
         ChkInterv("CabApl",0,63,DTNAS,"[@D]")
      ENDIF
      DBSKIP()
      IF PROW() > 60
         lCabec := .F.
         EJECT
      ENDIF
   ENDDO
   @ PROW()+1,01 SAY " "
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp ap320.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE AP320.TXT
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho do Relatorio       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION CabApl()
   nPg++
*   @ PROW() ,002 SAY "Clube 2004"
   @ PROW()+1,067 SAY "Data:"+DTOC(DATE())
   @ PROW()+1,067 SAY "Pag.:"+STRZERO(nPg,3)
   @ PROW()+1,020 SAY "DEPENDENTES MAIORES QUE 21 ANOS DE IDADE"
   @ PROW()+1,001 SAY REPLICATE("=",79)
   @ PROW()+1,001 SAY "MATR.  NOME                                                DT.NASCIMENTO"
*                      99999  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX     99/99/99
*                      1234567890123456789012345678901234567890123456789012345678901234567890123456789
*                               1         2         3         4         5         6         7
   @ PROW()+1,001 SAY REPLICATE("=",79)
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Calcular Idade               ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION CalcIdade(wVenc,wData)
   IF MONTH(wData) = MONTH(wVenc)
      IF DAY(wData) <= DAY(wVenc)
         wIdade := YEAR(wVenc) - YEAR(wData)
      ELSE
         wIdade := YEAR(wVenc) - YEAR(wData)-1
      ENDIF
   ELSE
      IF MONTH(wData) < MONTH(wVenc)
         wIdade := YEAR(wVenc) - YEAR(wData)
      ELSE
         wIdade := YEAR(wVenc) - YEAR(wData)-1
      ENDIF
   ENDIF
   RETURN(wIdade)
