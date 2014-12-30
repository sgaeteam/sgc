*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_213                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Consultar Pagamentos de Sขcios           ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 02/11/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

SELECT 4
IF NetUse("MUDAPG")
   SET INDEX TO DBIMUDA1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("PGSOC")
   SET INDEX TO DBIPGSO1,DBIPGSO2,DBIPGSO3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("CATEG")
   SET INDEX TO DBICATE1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 5
IF NetUse("SOCIOSI")
   SET INDEX TO DBISOCI2,DBISOCI1,DBISOCI3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2,DBISOCA1,DBISOCA3,DBISOCA4,DBISOCA5,DBISOCA6,DBISOCA7,DBISOCA8
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "10"
LinhaMsg(2); ProgName("GC213")
SET KEY -1 TO Mostra()
WHILE .T.
   SETCOLOR(YCOREDIT)
   wNomeSoc:=wSoci:=SPACE(50); wAnoRef:=SPACE(4); wAtIn:="A"

   Telas(17,3,20,62,1,YCOREDIT,.T.)
   Mensagem("Informe Nome do Sขcio")
   @ 18,05 SAY "Ativo ou Inativo (A/I)" GET wAtIn PICT "!"  VALID wAtIn $ "AI"
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; TeclaFuncao(); Rest_Tela(); EXIT; ENDIF

   IF wAtIn=="A"
      @ 19,05 SAY "Nome:" GET wNomeSoc PICT "@!" WHEN TeclaFuncao(.T.) VALID PTab(wNomeSoc,1,1,"Sขcio No Cadastrado")
   ELSE
      @ 19,05 SAY "Nome:" GET wSoci    PICT "@!" WHEN TeclaFuncao(.T.) VALID PTab(wSoci,5,1,"Sขcio No Cadastrado")
   ENDIF
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao(); Rest_Tela()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   IF wAtIn=="A"
      SELECT SOCIOS
   ELSE
      SELECT SOCIOSI
   ENDIF
   FOR a = 1 TO FCOUNT()
       xVar  := "w"+FIELDNAME(a)
       &xVar := FIELDGET(a)
   NEXT
   wNome      := IF(wAtIn=="A",wNomeSoc,wSoci)
   nMatricula := MATRICULA

   Telas(3,3,20,76,1,YCOREDIT,.T.,"Consultar Pagamentos de Sขcio")
   LimpaLinhaMsg()

   @ 04,05 SAY "         Nome:" GET wNome      PICT "@!"
   @ 07,32 SAY "Mat. Clube:"    GET MATRICULA  COLOR YCORREALCE
   TCateg(5,24,wCategoria)
   @ 05,05 SAY "    Categoria:" GET wCategoria PICT "99" WHEN TeclaFuncao(.T.) VALID !EMPTY(wCategoria).AND.TCateg(5,24,wCategoria)
   @ 06,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 07,05 SAY "Mat.Petrobr s:" GET wMatr2     PICT "99999999"
   @ 07,32 SAY "Mat. Clube: "
   @ 07,58 SAY "Unidade:"       GET wUnidade   PICT "@!"
   @ 08,05 SAY "      Lotao:" GET wLotacao   PICT "@!S18"
   @ 09,05 SAY " Funo Clube:" GET wFuncao    PICT "@!S18" WHEN TeclaFuncao(.T.) VALID TFunc(wFuncao)
   @ 08,32 SAY "      Fone:"    GET wFone      PICT "@R (999) 999-9999" WHEN TeclaFuncao()
   @ 09,32 SAY "     Ramal:"    GET wRamal     PICT "9999"
   @ 10,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 11,32 SAY " Dt.Adeso:"    GET wDtAdesao  PICT "@D"
   IF wAtIn=="I"
      @ 11,54 SAY "Status: "
      @ 11,62 SAY "Desligado" COLOR YCORAVISO
   ENDIF
   @ 12,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 13,05 SAY "Mes/Ano Situao       Valor        Mes/Ano Situao       Valor"
   CLEAR GETS

   WHILE .T.
      @ 11,05 SAY "     Ano Ref.:" GET wAnoRef PICT "9999" VALID !EMPTY(wAnoRef)
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()==K_ESC .OR. EMPTY(wAnoRef); EXIT; ENDIF
      TabPagSoc(nMatricula)
      IF wCategoria#"01"
         PRIVATE aGMes[12]
         nOp :=1
         WHILE .T.
            nPos:=13
            FOR k = 1 TO 12
                aGMes[k] := STRZERO(k,2)
                @ IF(k=7,nPos:=14,++nPos),IF(k>6,40,4) PROMPT " "
            NEXT
            MENU TO nOp
            READ
            IF LASTKEY()==K_ESC
               EXIT
            ELSE
               aGAno:=STRZERO(VAL(wAnoRef),4)
               SELECT PGSOC
               IF DBSEEK(nMatricula+aGAno+aGMes[nOp])
                  Telas(6,15,11,50,1,YCOREDIT,.T.)
                  @ 07,17 SAY "Nง do Recibo:" GET RECIBO  PICT "99999"
                  @ 08,17 SAY "Dt.Pagamento:" GET DTPAG   PICT "@D"
                  @ 09,17 SAY "Nง Documento:" GET DOC     PICT "@!"
                  @ 10,17 SAY "Recebido por:" GET USUARIO
                  CLEAR GETS
                  Mensagem("Tecle algo para continuar...")
                  INKEY(0)
                  Rest_Tela()
               ENDIF
            ENDIF
         ENDDO
      ENDIF
   ENDDO
   Rest_Tela()
ENDDO
SETCURSOR(0)
SETKEY(K_F2,NIL)
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Vetor de Pagamentos no Ano   ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE TabPagSoc(pMatr)
   LOCAL aMes[12], aAno[12], aSit[12], aVlPg[12], nLin:=14
   cIns     := SUBS(DTOC(SOCIOS->DTADESAO),7,2)+SUBS(DTOC(SOCIOS->DTADESAO),4,2)
   pMes     := SUBS(DTOC(DATE()),4,2)
   pAno     := SUBS(DTOC(DATE()),7,4)

   SELECT PGSOC
   AFILL(aAno,STRZERO(VAL(wAnoRef),4))
   FOR pg = 1 TO 6
       aMes[pg]  := STRZERO(pg,2)
       IF wCategoria=="01"
          SELECT MUDAPG
          SET SOFTSEEK ON
          IF !DBSEEK(wCategoria+aAno[pg]+aMes[pg])
             DBSKIP(-1)
             IF BOF()
                DBGOBOTTOM()
                DBSKIP()
             ENDIF
          ENDIF
          wValor := MENSALID
          SET SOFTSEEK OFF
          SELECT PGSOC
          aSit[pg]  := IF(cIns>(aAno[pg]+aMes[pg]),SPACE(9),;
                       IF(VAL(aAno[pg]) < VAL(pAno),"Pago     ",;
                       IF(VAL(aAno[pg]) = VAL(pAno),IF(VAL(pMes)<VAL(aMes[pg]),"Em Aberto","Pago     "),"Em Aberto")))
          aVlPg[pg] := IF(cIns>(aAno[pg]+aMes[pg]),0.00,;
                       IF(VAL(aAno[pg]) < VAL(pAno),wValor,;
                       IF(VAL(aAno[pg]) = VAL(pAno),IF(VAL(pMes)<VAL(aMes[pg]),0.00,wValor),0.00)))
       ELSE
          aSit[pg]  := IF(DBSEEK(pMatr+aAno[pg]+aMes[pg]),"Pago     ",;
                       IF(cIns>(aAno[pg]+aMes[pg]),"         ","Em Aberto"))
          aVlPg[pg] := PGSOC->VALOR
       ENDIF
       @ nLin,05 SAY aMes[pg]+"/"+aAno[pg]
       @ nLin,13 SAY aSit[pg]  COLOR YCORREALCE
       @ nLin,23 SAY aVlPg[pg] PICT "@E 999,999,999.99" COLOR YCORREALCE
       nLin++
   NEXT
   nLin := 14
   FOR pg = 7 TO 12
       aMes[pg]  := STRZERO(pg,2)
       IF wCategoria=="01"
          SELECT MUDAPG
          IF DBSEEK(wCategoria+aAno[pg]+aMes[pg])
             wValor := MENSALID
          ENDIF
          SELECT PGSOC
          aSit[pg]  := IF(cIns>(aAno[pg]+aMes[pg]),SPACE(9),;
                       IF(VAL(aAno[pg]) < VAL(pAno),"Pago     ",;
                       IF(VAL(aAno[pg]) = VAL(pAno),IF(VAL(pMes)<VAL(aMes[pg]),"Em Aberto","Pago     "),"Em Aberto")))

          aVlPg[pg] := IF(cIns>(aAno[pg]+aMes[pg]),0.00,;
                       IF(VAL(aAno[pg]) < VAL(pAno),wValor,;
                       IF(VAL(aAno[pg]) = VAL(pAno),IF(VAL(pMes)<VAL(aMes[pg]),0.00,wValor),0.00)))
       ELSE
          aSit[pg] := IF(DBSEEK(pMatr+aAno[pg]+aMes[pg]),"Pago     ",;
                      IF(cIns>(aAno[pg]+aMes[pg]),"         ","Em Aberto"))
          aVlPg[pg] := PGSOC->VALOR
       ENDIF
       @ nLin,41 SAY aMes[pg]+"/"+aAno[pg]
       @ nLin,49 SAY aSit[pg]  COLOR YCORREALCE
       @ nLin,59 SAY aVlPg[pg] PICT "@E 999,999,999.99" COLOR YCORREALCE
       nLin++
   NEXT
   RETURN    
