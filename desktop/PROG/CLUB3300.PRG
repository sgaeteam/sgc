*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : CLUB3300                         vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Lista de Convites                        ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 24/09/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

// Gerar arquivo temporario
aDbf:={}
AADD(aDbf,{"DATA"     ,"D", 08,00 })
AADD(aDbf,{"RG"       ,"C", 10,00 })
AADD(aDbf,{"SOCIO"    ,"C", 50,00 })
AADD(aDbf,{"CONVIDADO","C", 50,00 })

WHILE .T.
   sHour:=TIME()
   cArq1 :="TM"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE( cArq1, aDbf )
      RELEASE aDbf
      EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")
INDEX ON DTOS(data)+SOCIO TO (cArq1)

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("CONVSOC")
   SET INDEX TO CONVSOC3
ELSE
   DelDbfNtx(); RETURN
ENDIF

Telas(18,03,21,31,1,YCOREDIT,.T.)
WHILE .T.
   SETCOLOR(YCOREDIT)
   wpinic := wpfim := CTOD("")
   @ 19,05 SAY "Data Inicial: "GET wpinic PICT[@D] VALID !EMPTY(wpinic)
   @ 20,05 SAY "Data Final  : "GET wpfim  PICT[@D] VALID wpfim >= wpinic
   SETCURSOR(1); READ; SETCURSOR(0)
   
   IF LASTKEY()==K_ESC
      Rest_Tela(); DelDbfNtx(); RETURN
   ENDIF

   SELECT CONVSOC
   SET SOFTSEEK ON
   SEEK DTOS(wpinic)
   SET SOFTSEEK OFF

   IF DTACONV <= wpfim
      /* Gravar em arquivo temporario */
      Aguarde("Selecionando Convidados...")
      WHILE DTACONV>=wpinic.AND.DTACONV<=wpfim.AND.!EOF()
         wCodSoc    := CODSOC
         wDtaConv   := DTACONV
         wConvidado := NOMEC
         wRG        := RG
         SELECT SOCIOS
         DBSEEK(wCodSoc)
         wSocio := NOME
         SELECT (cArq1)
         DBAPPEND()
         FIELD->DATA      := wDtaConv
         FIELD->SOCIO     := wSocio
         FIELD->CONVIDADO := wConvidado
         FIELD->RG        := wRG
         SELECT CONVSOC
         DBSKIP()
      ENDDO
      Aguarde()
      SELECT (cArq1)
      DBGOTOP()
      IF EOF()
         Aviso("No h  convites emitidos neste periodo",,3)
      ELSE
         IF ChkImpr()
            SELECT (cArq1)
            continua   := .T.
            Imprimindo := MsgImp()
            Gera_TXT("CL3300.TXT")
            pg   := wnum := 0
            lCab := CabRel("LISTA DE CONVITES",wpinic,wpfim)
            lNome:= .T.
            WHILE continua.AND.!EOF()
               IF !lCab
                  lCab := CabRel("LISTA DE CONVITES",wpinic,wpfim)
               ENDIF
               Cab3300(01,00,DATA,"[@D]")
               Cab3300(00,10,RG)
               Cab3300(00,22,CONVIDADO)
               IF lNome
                  Cab3300(00,74,SOCIO)
                  wNome := SOCIO
               ENDIF
               DBSKIP()
               lNome := IF(SOCIO#wNome,.T.,.F.)
               IF PROW() > 58
                  EJECT
                  lCab := .F.
               ENDIF
            ENDDO
            IF continua
               @ 62,00 SAY "** Fim de Relatorio **"
               EJECT
            ENDIF
            Imp_Normal()
            Fim_TXT()
            SAVESCREEN(0,0,24,79)
            RUN nodosimp cl3300.txt 80 pre
            RESTSCREEN(0,0,24,79,0)
            DELETE FILE CL3300.TXT

            TiraMsgImp(Imprimindo)
         ELSE
            Aviso("Lista de convites vazia")
         ENDIF
      ENDIF
   ELSE
      Aviso("No h  convidados neste Perกodo")
   ENDIF
ENDDO
*ีอออออออออออออออออออออออออออออออธ
*ณ Testar Cancelamento Impresso ณ
*ิอออออออออออออออออออออออออออออออพ
PROCEDURE Cab3300(nProw,nPcol,cTexto,cMascara)
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
   @ PROW()   ,000 SAY "Clube 2004"
   Imp_Enor()
   @ PROW()+01,INT((80-LEN(TRIM(cTitulo)))/2) SAY cTitulo
   @ PROW()+02,000 SAY "Data: "+DTOC(DATE())
   @ PROW()   ,072 SAY "Pag.:"+STRZERO(pg,3)
   @ PROW()+01,000 SAY "Hora: "+TIME()
   @ PROW()+01,000 SAY "Periodo : "+DTOC(i)+" a "+DTOC(f)
   Imp_Compri()
   @ PROW()+01,000 SAY REPLICATE("-",115)
   @ PROW()+01,000 SAY "DATA      IDENTIDADE  CONVIDADO                                           SOCIO"
*                       99/99/99  9999999999  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX
*                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                                 1         2         3         4         5         6         7         8         9        10        11        12        13
   @ PROW()+01,000 SAY REPLICATE("-",115)
   RETURN .T.
