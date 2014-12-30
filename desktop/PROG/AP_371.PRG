*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_371                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Receita do Aluguel do Salao de Festas    ณ
*ณ PROGRAMADOR    : VITOR SMITH FREIRE   - NETCOM            ณ
*ณ DATA CRIACAO   : 10/12/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

SELECT 1
IF NetUse("DBCLSF","SALAO")
   SET INDEX TO DBILSF1
ELSE
   DBCLOSEALL()
   RETURN
ENDIF

ProgName("GC371")
WHILE .T.
   Telas(18,3,20,33,1,YCOREDIT,.T.)
   SETCOLOR(YCOREDIT)
   Mensagem("Informe o Mes/Ano do Aluguel")
   wMesAno := SPACE(6)
   @ 19,05 SAY "Mes/Ano Aluguel:" GET wMesAno PICT "@R 99/9999" VALID;
     EMPTY(wMesAno).OR.LEN(ALLTRIM(wMesAno))==6
   SETCURSOR(1)
   READ
   SETCURSOR(0)

   Rest_Tela()
   IF EMPTY(wMesAno)
      EXIT
   ENDIF

   sData   := CTOD("01/"+LEFT(wMesAno,2)+"/"+RIGHT(wMesAno,4))
   sMesExt := MesExt(sData)+"/"+STR(YEAR(sData),4)
   nMes    := MONTH(sData)
   nRefrig := nCerveja := nAluguel := 0.00
   nQRefr  := nQCerv   := nQAlugue := 0
   FOR nDiaMes:=1 TO 31
       IF DBSEEK(DTOS(sData))
          nRefrig  += VALREF * QTDREF
          nQRefr   += QTDREF
          nCerveja += VALCER * QTDCER
          nQCerv   += QTDCER
          nAluguel += VALALU
          IF ALUGUEL=="A"
             nQAlugue++
          ENDIF
       ENDIF
       sData++
       IF nMes<>MONTH(sData)
          EXIT
       ENDIF
   NEXT

   IF (nRefrig+nCerveja+nAluguel)=0.00
      Aviso("No houve receita em "+wMesAno)
   ELSE
      IF ChkImpr()
         cAviso := MsgImp()
         ImpReceita()
         TiraMsgImp(cAviso)
         Beep(2)
         Mensagem("Fim de Impresso! Tecle algo...")
         INKEY(0)
         Mensagem()
      ENDIF
   ENDIF
ENDDO
SETCURSOR(0)
DBCLOSEALL()
SETKEY(K_F2,NIL)
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Listagem            ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE ImpReceita()
   Gera_TXT("AP371.TXT")
   SETPRC(0,0)
   lCabec := Cab371()
   @ PROW()+1,00 SAY "Refrigerantes"
   @ PROW()  ,20 SAY nQRefr   PICT "@E 999,999"
   @ PROW()  ,36 SAY nRefrig  PICT "@E 99,999,999,999.99"
   @ PROW()+1,00 SAY "Cervejas"
   @ PROW()  ,20 SAY nQCerv   PICT "@E 999,999"
   @ PROW()  ,36 SAY nCerveja PICT "@E 99,999,999,999.99"
   @ PROW()+1,00 SAY "Aluguel"
   @ PROW()  ,20 SAY nQAlugue PICT "@E 999,999"
   @ PROW()  ,36 SAY nAluguel PICT "@E 99,999,999,999.99"
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp ap371.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE AP371.TXT

   RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Imprimir Cabecalho             ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION Cab371()
   @ PROW()   ,00 SAY "Clube 2004"
   @ PROW()   ,71 SAY DTOC(DATE()) PICT "@D"
   @ PROW()+02,18 SAY "LISTAGEM DA RECEITA DE ALUGUEL DO SALAO DE FESTAS"
   @ PROW()+02,33 SAY UPPER(sMesExt)
   @ PROW()+01,00 SAY REPLICATE("-",79)
   @ PROW()+01,00 SAY "ITEM                QUANTIDADE                  VALOR"
   @ PROW()+01,00 SAY REPLICATE("-",79)
   RETURN .T.
