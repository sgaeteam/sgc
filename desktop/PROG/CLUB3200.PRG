*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : CLUB3200                         vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Lista de Convidados por Nome             ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 24/09/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

// Gerar arquivo temporario
aDbf:={}
AADD(aDbf,{"NOME", "C", 50,00 })

WHILE .T.
   sHour:=TIME()
   cArq1 :="TM"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE( cArq1, aDbf )
      RELEASE aDbf
      EXIT
   ENDIF
ENDDO
SELECT 3
NetUse(cArq1,,"E")
INDEX ON nome TO (cArq1)

SELECT 2
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("CONVSOC")
   SET INDEX TO CONVSOC2, CONVSOC1, CONVSOC3
ELSE
   DelDbfNtx(); RETURN
ENDIF

/* Alimentar o aquivo temporario com os nomes dos convidados evitando
   duplicidade  na pesquisa */
Aguarde("Checkando Duplicidades...")
WHILE !EOF()
   cNome := NOMEC
   SELECT (cArq1)
   IF !DBSEEK(cNome)
      DBAPPEND(); FIELD->NOME := cNome
   ENDIF
   SELECT CONVSOC; DBSKIP()
ENDDO
Aguarde()

Telas(19,03,21,75,1,YCOREDIT,.T.)
SET KEY -1 TO Mostra()
WHILE .T.
   SETCOLOR(YCOREDIT)
   cNomeConv := SPACE(50)
   @ 20,05 SAY "Nome do Convidado:"GET cNomeConv PICT "@!" WHEN TeclaFuncao(.T.);
     VALID Ptab(cNomeConv,1,1,"Convidado no Encontrado!")
   SETCURSOR(1); READ; SETCURSOR(0)
   
   IF LASTKEY()==K_ESC
      Rest_Tela(); SETKEY(K_F2,NIL); DelDbfNtx(); RETURN
   ENDIF

   IF ChkImpr()
      continua   := .T.
      Imprimindo := MsgImp()
      Gera_TXT("CL3200.TXT")
      pg   := wnum := 0
      lCab := CabRel("LISTA DE CONVIDADOS")

      WHILE NOMEC==cNomeConv .AND. continua .AND. !EOF()
         IF !lCab
            lCab := CabRel("LISTA DE CONVIDADOS")
         ENDIF
         wMatricula := CODSOC
         Cab3200(01,00,DTACONV,"[@D]")
         SELECT SOCIOS
         DBSEEK(wMatricula)
         Cab3200(00,11,NOME)
         SELECT CONVSOC
         DBSKIP()
         IF PROW() > 58
            EJECT ; lCab := .F.
         ENDIF
      ENDDO
      IF continua
         @ 62,00 SAY "** Fim de Relatorio **"; EJECT
      ENDIF
      Fim_TXT()
      SAVESCREEN(0,0,24,79)
      RUN nodosimp cl3200.txt 80 pre
      RESTSCREEN(0,0,24,79,0)
      DELETE FILE CL3200.TXT

      TiraMsgImp(Imprimindo)
   ENDIF
ENDDO
*ีอออออออออออออออออออออออออออออออธ
*ณ Testar Cancelamento Impresso ณ
*ิอออออออออออออออออออออออออออออออพ
PROCEDURE Cab3200(nProw,nPcol,cTexto,cMascara)
   IF Continua
      Continua := EscPrint()
      IF (PROW()<1.OR.PROW()>60).AND.Continua
         pg++
         IF PROW() > 60; EJECT; ENDIF
      ENDIF
      IF VALTYPE(cMascara)=="U"
         @ PROW()+nProw,nPcol SAY cTexto
      ELSE
         @ PROW()+nProw,nPcol SAY cTexto PICT &cMascara
      ENDIF
   ELSE
      Imp_Normal(); GO BOTTOM; DBSKIP()
   ENDIF
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Cabecalho                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNC CabRel(cTitulo)
   pg++
   Imp_Exp()
   @ PROW()   ,000 SAY "Clube 2004"
   Imp_Enor()
   Imp_Normal()
   @ PROW()+01,INT((80-LEN(TRIM(cTitulo)))/2) SAY cTitulo
   @ PROW()+02,000 SAY "Data: "+DTOC(DATE())
   @ PROW()   ,072 SAY "Pag.:"+STRZERO(pg,3)
   @ PROW()+01,000 SAY "Hora: "+TIME()
   @ PROW()+01,000 SAY "Nome Convidado : "+ cNomeConv
   @ PROW()+01,000 SAY REPLICATE("-",80)
   @ PROW()+01,000 SAY "DATA       SOCIO"
   @ PROW()+01,000 SAY REPLICATE("-",130)
   RETURN .T.
