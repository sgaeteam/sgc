*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : CLUB3400                         vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Listar Qtde de Convidados no Periodo     ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 24/09/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

// Gerar arquivo temporario
aDbf:={}
AADD(aDbf,{"DATA", "D", 08,00 })
AADD(aDbf,{"QTDE" ,"N", 04,00 })

WHILE .T.
   sHour:=TIME()
   cArq1 :="TM"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE( cArq1, aDbf )
      RELEASE aDbf
      EXIT
   ENDIF
ENDDO
SELECT 2
NetUse(cArq1,,"E")
INDEX ON DTOS(data) TO (cArq1)

SELECT 1
IF NetUse("CONVSOC")
   SET INDEX TO CONVSOC3, CONVSOC1, CONVSOC2
ELSE
   DelDbfNtx(); RETURN
ENDIF

Telas(18,03,21,30,1,YCOREDIT,.T.)
WHILE .T.
   SETCOLOR(YCOREDIT)
   wpinic := wpfim := CTOD(SPACE(8))
   @ 19,05 SAY "Data Inicial: "Get wPinic PICT[@D] VALID !EMPTY(wpinic)
   @ 20,05 SAY "Data Final  : "Get wPfim  PICT[@D] VALID wpfim >= wpinic
   SETCURSOR(1); READ; SETCURSOR(0)
   
   IF LASTKEY()==K_ESC
      Rest_Tela(); DelDbfNtx(); RETURN
   ENDIF

   SELECT CONVSOC
   SET SOFTSEEK ON
   SEEK DTOS(wpinic)
   SET SOFTSEEK OFF

   IF DTACONV <= wpfim
      Aguarde("Gerando Listagem")
      SELECT CONVSOC
      lCheio := .F.

      WHILE DTACONV >= wpinic .AND. DTACONV <= wpfim
         wdtaconv := DTACONV
         SELECT (cArq1)
         IF !DBSEEK(DTOS(wdtaconv))
            DBAPPEND()
            FIELD->DATA := wdtaconv
            FIELD->QTDE := 1
            lCheio      := .T.
         ELSE
            FIELD->QTDE := FIELD->QTDE+1
         ENDIF
         SELECT CONVSOC
         DBSKIP()
      ENDDO
      Aguarde()

      IF lCheio .AND. ChkImpr()
         SELECT (cArq1)
         DBGOTOP()
         continua   := .T.
         Imprimindo := MsgImp()
         Gera_TXT("CL3400.TXT")
         pg   := nTotPer := 0
         lCab := CabRel("LISTA DE CONVIDADOS POR PERIODO",wpinic,wpfim)
         WHILE continua.AND.!EOF()
            IF !lCab
               lCab := CabRel("LISTA DE CONVIDADOS POR PERIODO",wpinic,wpfim)
            ENDIF
            Cab3400(01,00,DATA)
            Cab3400(00,16,QTDE)
            nTotPer += QTDE
            DBSKIP()
            IF PROW() > 58
               EJECT
              lCab := .F.
            ENDIF
         ENDDO
         @ PROW()+01,000 SAY REPLICATE("-",80)
         Cab3400(01,00,"Total no Periodo :")
         Cab3400(00,20,nTotPer,"[@E 9,999]")
         IF continua
            @ 62,00 SAY "** Fim de Relatorio **"
            EJECT
         ENDIF
         Fim_TXT()
         SAVESCREEN(0,0,24,79)
         RUN nodosimp cl3400.txt 80 pre
         RESTSCREEN(0,0,24,79,0)
         DELETE FILE CL3400.TXT

         TiraMsgImp(Imprimindo)
      ELSE
         Aviso("Lista de convidados vazia")
      ENDIF
   ELSE
      Aviso("Perกodo no existe convidados")
   ENDIF
   SELECT (cArq1); ZAP
ENDDO
*ีอออออออออออออออออออออออออออออออธ
*ณ Testar Cancelamento Impresso ณ
*ิอออออออออออออออออออออออออออออออพ
PROCEDURE Cab3400(nProw,nPcol,cTexto,cMascara)
   IF Continua
      Continua := EscPrint()
      IF (PROW()<1.OR.PROW()>60).AND.Continua
         pg++
         IF PROW() > 60
            EJECT
         ENDIF
      ENDIF
      IF VALTYPE(cMascara)=="U"
         @ PROW()+nProw,nPcol SAY cTexto
      ELSE
         @ PROW()+nProw,nPcol SAY cTexto PICT &cMascara
      ENDIF
   ELSE
      Imp_Normal()
      GO BOTTOM
      DBSKIP()
   ENDIF
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Cabecalho                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION CabRel(cTitulo,i,f)
   pg++
   Imp_Exp()
   @ Prow()   ,000 SAY "Clube 2004"
   Imp_Enor()
   @ PROW()+01,INT((80-LEN(TRIM(cTitulo)))/2) SAY cTitulo
   @ PROW()+02,000 SAY "Data: "+DTOC(DATE())
   @ PROW()   ,072 SAY "Pag.:"+STRZERO(pg,3)
   @ PROW()+01,000 SAY "Hora: "+TIME()
   @ PROW()+01,000 SAY "Periodo : "+DTOC(i)+" a "+DTOC(f)
   @ PROW()+01,000 SAY REPLICATE("-",80)
   @ PROW()+01,000 SAY "DATA            QUANT.DE CONVIDADOS"
   @ PROW()+01,000 SAY REPLICATE("-",80)
   RETURN .T.
