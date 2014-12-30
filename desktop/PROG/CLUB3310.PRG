*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : CLUB3310                         vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Lista de Convidados por Socio no Periodo ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 19/05/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

// Gerar arquivo temporario
aDbf:={}
AADD(aDbf,{"DATA", "D", 08,00 })
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
INDEX ON DTOS(data) TO (cArq1)

SELECT 2
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA1,DBISOCA2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("CONVSOC")
   SET INDEX TO CONVSOC4
ELSE
   DelDbfNtx(); RETURN
ENDIF

Telas(17,03,21,42,1,YCOREDIT,.T.)
SET KEY -1 TO Mostra()
WHILE .T.
   SETCOLOR(YCOREDIT)
   cCodSoc := SPACE(5); wPerIni:=wPerFim:=CTOD(""); wDevice:=" "
   @ 18,05 SAY "Cขd. Sขcio:" GET cCodSoc  PICT "99999" WHEN TeclaFuncao(.T.);
     VALID Ptab(cCodSoc,2,1,"Sขcio no Encontrado!")
   @ 19,05 SAY "   Perกodo:" GET wPerIni  PICT "@D" WHEN TeclaFuncao() VALID !EMPTY(wPerIni)
   @ 19,29 SAY "a "          GET wPerFim  PICT "@D" VALID LASTKEY()==K_UP.OR.wPerFim>=wPerIni
   @ 20,05 SAY "     Saกda:" GET wDevice  PICT "!"  WHEN HTela(5) VALID VTela(5)
   SET CONFIRM OFF
   SETCURSOR(1); READ; SETCURSOR(0)
   SET CONFIRM ON
   
   IF LASTKEY()==K_ESC; EXIT; ENDIF


   CONVSOC->(DBSEEK(cCodSoc+DTOS(wPerIni),.T.))
   IF !EOF().AND.CONVSOC->DTACONV>wPerFim
      Aviso("No houve convites neste Perกodo...")
   ELSE
      IF wDevice=="I"
         IF ChkImpr()
            continua   := .T.
            Imprimindo := MsgImp()
            Gera_TXT("CL3310.TXT")
            pg   := wnum := 0
            lCab := CabRel("LISTA DE CONVIDADOS POR SOCIO")

            SELECT CONVSOC
            WHILE CODSOC==cCodSoc.AND.DTACONV<=wPerFim.AND.continua.AND.!EOF()
               IF !lCab; lCab := CabRel("LISTA DE CONVIDADOS POR SOCIO"); ENDIF
               Cab3310(01,00,DTACONV,"[@D]")
               Cab3310(00,11,NOMEC)
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
            RUN nodosimp cl3310.txt 80 pre
            RESTSCREEN(0,0,24,79,0)
            DELETE FILE CL3310.TXT

            TiraMsgImp(Imprimindo)
         ENDIF
      ELSE
         SELECT CONVSOC
         WHILE CODSOC==cCodSoc.AND.DTACONV<=wPerFim.AND.!EOF()
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->DATA WITH DTACONV,;
                    (cArq1)->NOME WITH NOMEC
            DBSKIP()
         ENDDO
         SELECT (cArq1); DBGOTOP()
         BrowCad()
         (cArq1)->(__DBZAP())
      ENDIF
   ENDIF
ENDDO
Rest_Tela()
SETKEY(K_F2,NIL)
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse do Cadastro             ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol
   SETCOLOR(YCORGERAL)
   Telas(2,0,4,79,1,YCORGERAL,.F.)
   @ 03,02 SAY "Sขcio: "+SOCIOS->NOME
   Telas(5,0,22,79,1,YCORGERAL,.F.)
   oBr:=TBROWSEDB(6,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec:=YCORGERAL

*  oBr:gobottomblock = {||goto_bott(wPerFim)}
*  oBr:gotopblock    = {||goto_top(wPerIni)}
*  oBr:skipblock     = {|n| move_pointer(n, cCodSoc+DTOS(DTACONV), {|n| CODSOC+DTOS(DTACONV)})}

   oCol:=TBCOLUMNNEW("Data",{|| TRANSFORM(DATA,"@D")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Convidado",{|| TRANSFORM(NOME,"@!S40")})
   oBr:addColumn(oCol)

   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela(); Rest_Tela()
  RETURN NIL
*ีอออออออออออออออออออออออออออออออธ
*ณ Testar Cancelamento Impresso ณ
*ิอออออออออออออออออออออออออออออออพ
PROCEDURE Cab3310(nProw,nPcol,cTexto,cMascara)
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
   @ PROW()   ,00 SAY "Clube 2004"
   Imp_Enor()
   Imp_Normal()
   @ PROW()+01,00 SAY PADC(cTitulo,80)
   @ PROW()+02,00 SAY "Data: "+DTOC(DATE())
   @ PROW()   ,72 SAY "Pag.:"+STRZERO(pg,3)
   @ PROW()+01,00 SAY "Hora: "+TIME()
   @ PROW()+01,00 SAY "Nome do Socio: "+ SOCIOS->NOME
   @ PROW()+01,00 SAY REPLICATE("-",80)
   @ PROW()+01,00 SAY "DATA       CONVIDADO"
   @ PROW()+01,00 SAY REPLICATE("-",80)
   RETURN .T.
