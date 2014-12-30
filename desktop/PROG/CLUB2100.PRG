*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณPROGRAMA     : CLUB2100                         vrs 001    ณ
*ณVRS 001      : Desenvolvimento                             ณ
*ณFINALIDADE   : Manuteno de Convites                      ณ
*ณPROGRAMADOR  : VITOR FREIRE/WILSON CAMPOS                  ณ
*ณDATA CRIACAO : 09/08/1994                                  ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2,DBISOCA1,DBISOCA3,DBISOCA4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("CONVSOC",,"C")
   SET INDEX TO CONVSOC2,CONVSOC1,CONVSOC3,CONVSOC4,CONVSOC5
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("CADCONVT",,"E")
   SET INDEX TO CATCONV2, CATCONV1, CATCONV3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 4
IF NetUse("CCONV",,"E")
   SET INDEX TO CCONV
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SET KEY -1 TO Mostra()
WHILE .T.
   SETCOLOR(YCOREDIT)
   Telas(19,03,21,71,1,YCOREDIT,.T.)
   LinhaMsg(3)

   cNomeSoc := SPACE(50)
   @ 20,05 SAY "Nome do Sขcio:" GET cNomeSoc PICT "@!" WHEN TeclaFuncao(.T.);
     VALID Ptab(cNomeSoc,1,1,"Sขcio No Cadastrado")
   SETCURSOR(1); READ; SETCURSOR(0)
   
   Rest_Tela()
   TeclaFuncao()
   IF LASTKEY()==K_ESC .OR. EMPTY(cNomeSoc)
      LinhaMsg(2); EXIT
   ENDIF

   SELECT SOCIOS
   WHILE !NetLReg(); ENDDO
   FOR a = 1 TO FCOUNT()
       Var := "w"+FIELDNAME(a)
       &Var := FIELDGET(a)
   NEXT
   wNome := cNomeSoc

   Telas(07,03,15,76,1,YCOREDIT,.T.)
   WHILE .T.
      SETCOLOR(YCOREDIT)
      Novo := Deleta := .F.
      SELECT CCONV
      IF !DBSEEK(wMatricula)
         WHILE !NetApp(); ENDDO
         FIELD->MATRICULA := wMatricula
         FIELD->QDISP     := wLimite
         FIELD->QCONMES   := wLimite
         DBUNLOCK()
      ENDIF
      vQdisp := FIELD->QDISP

      @ 08,05 SAY "   Matrกcula:" GET wMatricula PICT[99999]
      @ 09,05 SAY "  Disponกvel:" GET vQdisp     PICT[99]
      @ 10,05 SAY "        Nome:" GET wNome      PICT[@!S40]
      CLEAR GETS
   
      SELECT CADCONVT
      SET FILTER TO CODSOC==wMatricula
      DBGOTOP()

      cNomec   := SPACE(50)
      cDtaConv := CTOD("")
      cRG      := SPACE(10)
      SETCURSOR(1)
      @ 12,05 SAY "Convidado(a):" GET cNomeC   PICT[@!]
      @ 13,05 SAY "Identidade  :" GET cRG      PICT[9999999999]
      @ 14,05 SAY "Data Convite:" GET cDTACONV PICT[@D]
      CLEAR GETS

      @ 12,05 SAY "Convidado(a):" GET cNomeC   PICT[@!] VALID !EMPTY(cNomeC).AND.TConv(cRG)
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()==K_ESC; EXIT; ENDIF

      IF DBSEEK(wMatricula+cNomeC)
         WHILE !NetLReg(); ENDDO
         FOR a = 1 TO FCOUNT()
             Var  := "c"+FIELDNAME(a)
             &Var := FIELDGET(a)
         NEXT
         Novo := .F.
      ELSE
         KEYBOARD CHR(13)
         Novo := .T.
      ENDIF
      @ 12,05 SAY "Convidado(a):" GET cNomeC   PICT[@!] VALID !EMPTY(cNomeC)
      @ 13,05 SAY "Identidade  :" GET cRG      PICT[9999999999] VALID !EMPTY(cRG)
      @ 14,05 SAY "Data Convite:" GET cDtaConv PICT[@D] VALID !EMPTY(cDtaConv) .and. cDtaConv >= date()

      IF EOF()
         SETCURSOR(1); READ; SETCURSOR(0)
         MSG = "Confirma os Dados ? "
         Novo := .T.
      ELSE
         DeleAltera()
         IF LASTKEY()==K_ENTER
            SETCURSOR(1); READ; SETCURSOR(0)
            msg    := "Confirma Alterao ? "
            Altera := .T.
         ELSEIF LASTKEY()==K_DEL
            CLEAR GETS
            msg    := "Confirma a Excluso ? "
            Deleta := .T.
         ENDIF
      ENDIF
      IF LASTKEY() <> K_ESC
         IF vQdisp == 2 .AND. !Deleta
            Aviso("Sขcio possuir  apenas 1 convite.")
         ELSEIF vQdisp == 0 .AND. !Deleta
            Aviso("Sem disponibilidade para convites.")
            EXIT
         ENDIF

         IF Confirma(msg)
            Aguarde(" Gravando Informa”es ")
            SELECT CADCONVT
            IF Deleta
               DBDELETE()
               SELECT CCONV
               vQdisp++
               WHILE NetLReg()
                  FIELD->QDISP := vQdisp
                  EXIT
               ENDDO
               UNLOCK ALL
            ELSE
               IF Novo
                  WHILE !NetApp(); ENDDO
               ENDIF

               cCodsoc   := wMatricula
               cEndec    := " "
               cFlagimp  := .F.
               FOR a = 1 TO FCOUNT()
                   Var := "c"+FIELDNAME(a)
                   FIELDPUT(a,&Var)
               NEXT

               IF Novo
                  SELECT CCONV
                  vQdisp--
                  WHILE NetLReg()
                     FIELD->QDISP := vQdisp
                     EXIT
                  ENDDO
                  UNLOCK
               ENDIF
               SELECT CADCONVT
            ENDIF
            Aguarde()
            UNLOCK ALL
            DBCOMMITALL()
	    cArea := Select()
	    msg := "Imprime Convite"
	    IF Confirma(msg)
	       IMPCON()
	    Endif
            SELECT(cArea)
         ENDIF
      ELSE
         CLEAR GETS
      ENDIF
      UNLOCK ALL
   ENDDO
   SELECT CADCONVT
   SET FILTER TO
   SELECT SOCIOS
   UNLOCK ALL
   DBCOMMITALL()
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL)
SETCURSOR(0)
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Convites Pendentes  ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpCon()
   SELECT CADCONVT
   IF EOF()
      Aviso("No h  convites pendentes"); RETURN
   ENDIF

   continua:=.T.; pg:=0
   IF ChkImpr()
      Imprimindo := MsgImp()
      wCont      := 0; lSaida:=.F.
      Gera_TXT("CL2100.TXT")
      WHILE !EOF()
         IF !FlagImp
            cab22i(01,08,"+"+REPL("-",60)+"+")
            cab22i(01,08,"|")
            cab22i(00,69,"|")
            Imp_Exp()
            cab22i(00,11,"Clube 2004")
            cab22i(00,11,"Clube 2004")
            Imp_Enor()
            Imp_Normal()
            FOR i= 1 TO 2
                cab22i(01,08,"|")
                cab22i(00,69,"|")
            NEXT
            cab22i(01,08,"|")
            cab22i(00,34,"CONVITE")
            cab22i(00,34,"CONVITE")
            cab22i(00,69,"|")
            FOR i= 1 TO 2
                cab22i(01,08,"|")
                cab22i(00,69,"|")
            NEXT
            cab22i(00,11,"SOCIO: "+SOCIOS->NOME)
            cab22i(00,11,"SOCIO: "+SOCIOS->NOME)
            cab22i(01,08,"|")
            cab22i(00,69,"|")
            cab22i(01,08,"|  Convidamos o(a) Sr(a). ")
            cab22i(00,34,SUBSTR(NOMEC,1,35))
            cab22i(00,34,SUBSTR(NOMEC,1,35))
            cab22i(00,69,"|")
            cab22i(01,08,"|  para frequentar as instalacoes  do  CLUBE 2004  no  dia   |")
            cab22i(01,08,"|  "+DTOC(DTACONV)+", sendo o associado responsavel pela conduta do   |")
            cab22i(01,08,"|  convidado.                                                |")
            FOR i= 1 TO 2
                cab22i(01,08,"|")
                cab22i(00,69,"|")
            NEXT
            cab22i(01,08,"|  -------------------------    --------------------------   |")
            cab22i(01,08,"|           SOCIO                       DIRETOR              |")
            cab22i(01,08,"|")
            cab22i(00,69,"|")
            cab22i(01,08,"+"+REPL("-",60)+"+")

            SELECT CCONV
            DBSEEK(CADCONVT->CODSOC)
            IF _FIELD->QDISP > 0
               cab22i(01,08,"Voce tem direito a trazer "+STR(_FIELD->QDISP,2)+" convidados ainda este mes")
            ENDIF

            cab22i(01,08,"")
            SELECT CADCONVT
            wCont++
            IF !lSaida
               lSaida:=.T.
            ENDIF
            IF wCont==3
               wCont := 0; EJECT
            ENDIF
         ENDIF
         DBSKIP()
      ENDDO
      EJECT
      Fim_TXT()
      SAVESCREEN(0,0,24,79)
      RUN nodosimp cl2100.txt 80 pre
      RESTSCREEN(0,0,24,79,0)
      DELETE FILE CL2100.TXT

      TiraMsgImp(Imprimindo)
      SELECT CADCONVT
      DBGOTOP()
      WHILE !EOF()
         FOR a = 1 TO FCOUNT()
             Var  := "w"+FIELDNAME(a)
             &Var := FIELDGET(a)
         NEXT
         SELECT CONVSOC
         IF NetApp()
            FOR a = 1 TO FCOUNT()
                Var := "w"+FIELDNAME(a)
                FIELDPUT(a,&Var)
            NEXT
         ENDIF
         SELECT CADCONVT
         DBSKIP()
      ENDDO
      ZAP
   ENDIF
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Tecla de Cancelamento        ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE cab22i(nProw,nPcol,cTexto,cMascara)
   IF Continua
      Continua := EscPrint()
      IF Continua
         IF VALTYPE(cMascara)=="U"
            @ PROW()+nProw,nPcol SAY cTexto
         ELSE
            @ PROW()+nProw,nPcol SAY cTexto PICT &cMascara
         ENDIF
      ENDIF
   ELSE
      GO BOTTOM; DBSKIP()
   ENDIF
   RETURN NIL
*ีออออออออออออออออออออออออออออออออออธ
*ณ Testar se convidado j  informado ณ
*ิออออออออออออออออออออออออออออออออออพ
PROCEDURE TConv(pRg)
  IF CONVSOC->(DBSEEK(pRg+DTOS(DATE())))
     Aviso("Pessoa j  convidada pelo sขcio "+RTRIM(SOCIOS->NOME))
     RETURN .F.
  ENDIF
  RETURN .T.
