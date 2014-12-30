*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_214                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Consultar Pagamentos de Usu rios         ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 02/11/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

SELECT 5
IF NetUse("COBRANCA")
   SET INDEX TO DBICOBR1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 4
IF NetUse("USUARIOS")
   SET INDEX TO DBIUSU2,DBIUSU1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("PGUSU")
   SET INDEX TO DBIPGUS1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("ATIV")
   SET INDEX TO DBIATIV1,DBIATIV2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("USUATIV")
   SET INDEX TO DBIUSAT2,DBIUSAT1,DBIUSAT3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "10"
LinhaMsg(2); ProgName("GC214")
SET KEY -1 TO Mostra()
WHILE .T.
   SETCURSOR(1)
   SETCOLOR(YCOREDIT)

   wNomeUsu := SPACE(50)
   wAtiv    := SPACE(2); wAnoRef := SPACE(4)

   Telas(18,3,20,62,1,YCOREDIT,.T.)
   Mensagem("Informe Nome do Usu rio")
   @ 19,05 SAY "Nome:" GET wNomeUsu PICT "@!" WHEN TeclaFuncao(.T.) VALID;
               PTab(wNomeUsu,4,2,"Usu rio No Cadastrado")
   READ

   TeclaFuncao(); Rest_Tela()
   IF LASTKEY()==K_ESC .OR. EMPTY(wNomeUsu); EXIT; ENDIF

   SELECT USUARIOS
   FOR a = 1 TO FCOUNT()
       xVar  := "w"+FIELDNAME(a)
       &xVar := FIELDGET(a)
   NEXT
   nMatricula := MATRICULA
   wInscr     := CTOD("")
   wNome      := wNomeUsu

   Telas(3,3,20,76,1,YCOREDIT,.T.,"Consultar Pagamentos de Usu rio")
   LimpaLinhaMsg()

   TCobra1(6,24,wCobranca)
   @ 04,05 SAY "        Nome:" GET wNome     PICT "@!"
   @ 05,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 06,05 SAY "    Cobrana:" GET wCobranca PICT "99"
   @ 07,05 SAY " Respons vel:" GET wRespon   PICT "@!"
   @ 08,05 SAY "  Identidade:" GET wRG
   @ 08,38 SAY "CPF:"          GET wCPF      PICT "@R 999 999 999-99"
   @ 09,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 10,32 SAY "Inscrio:"    GET wInscr    PICT "@D"
   @ 12,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 13,05 SAY "Mes/Ano Situao       Valor        Mes/Ano Situao       Valor"
   CLEAR GETS

   aAtiv := {}
   PegaAtiv()
   IF LEN(aAtiv)==0
      Aviso("Usu rio no possui Atividade")
      Rest_Tela()
      LOOP
   ENDIF
   vachoice:=vlin:=1 ; vpos:=0
   WHILE .T.
       /* Preencher vetores com atividades desempenhadas */
      Telas(9,18,14,49,1,YCOREDIT,.T.,"Atividade")
      vachoice := ACHOICE(10,19,13,48,aAtiv,.T.,"BUNDA",vlin,vpos)
      Rest_Tela()

      IF vachoice<>0
         wAtiv := LEFT(aAtiv[vachoice],2)
         @ 10,05 SAY "   Atividade:" GET wAtiv PICT "99" WHEN .F.
      ENDIF
      IF LASTKEY()==K_ESC .OR. vachoice==0
         EXIT
      ENDIF

      wInscr := TDtInscr()
      @ 10,32 SAY "Inscrio:" GET wInscr PICT "@D"
      CLEAR GETS

      @ 11,05 SAY "    Ano Ref.:" GET wAnoRef PICT "9999" VALID !EMPTY(wAnoRef)
      READ
      IF LASTKEY()==K_ESC .OR. EMPTY(wAnoRef)
         LOOP
      ENDIF
      TabPagUsu(nMatricula,wAtiv)

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
               SELECT PGUSU
               IF DBSEEK(nMatricula+wAtiv+aGAno+aGMes[nOp])
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

*     Mensagem("Tecle algo para continuar...")
*     INKEY(0)
   ENDDO
   Rest_Tela()
ENDDO
SETCURSOR(0)
SETKEY(K_F2,NIL)
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Calcular Dif.entre Periodos  ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TDtInscr()
   LOCAL cArq:=SELECT()
   SELECT USUATIV
   SET ORDER TO 1
   DBSEEK(nMatricula+wAtiv)
   SELECT (cArq)
   RETURN(USUATIV->DTINSCR)
*ีออออออออออออออออออออออออออออออธ
*ณ Vetor de Pagamentos no Ano   ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE TabPagUsu(pMatr,pAtiv)
   LOCAL aMes[12], aAno[12], aSit[12], aVlPg[12], nLin:=14
   cIns := SUBS(DTOC(wInscr),7,4)+SUBS(DTOC(wInscr),4,2)
   SELECT PGUSU
   AFILL(aAno,STRZERO(VAL(wAnoRef),4))
   FOR pg = 1 TO 6
       aMes[pg]  := STRZERO(pg,2)
       aSit[pg]  := IF(DBSEEK(pMatr+pAtiv+aAno[pg]+aMes[pg]),"Pago     ",;
                    IF(cIns>(aAno[pg]+aMes[pg]),"         ","         "))
       aVlPg[pg] := PGUSU->VALOR
       @ nLin,05 SAY aMes[pg]+"/"+aAno[pg]
       @ nLin,13 SAY aSit[pg]  COLOR YCORREALCE
       @ nLin,23 SAY aVlPg[pg] PICT "@E 999,999,999.99" COLOR YCORREALCE
       nLin++
   NEXT
   nLin := 14
   FOR pg = 7 TO 12
       aMes[pg]  := STRZERO(pg,2)
       aSit[pg]  := IF(DBSEEK(pMatr+pAtiv+aAno[pg]+aMes[pg]),"Pago     ",;
                    IF(cIns>(aAno[pg]+aMes[pg]),"         ","         "))
       aVlPg[pg] := PGUSU->VALOR
       @ nLin,41 SAY aMes[pg]+"/"+aAno[pg]
       @ nLin,49 SAY aSit[pg]  COLOR YCORREALCE
       @ nLin,59 SAY aVlPg[pg] PICT "@E 999,999,999.99" COLOR YCORREALCE
       nLin++
   NEXT
   RETURN
