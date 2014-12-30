*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_211                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Registrar Pagamentos de Sขcios           ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 18/10/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PROCEDURE AP_211(pOper)
PUBLIC nParcelas,nSomaPer

DBCLOSEALL()
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

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2,DBISOCA1,DBISOCA3,DBISOCA4,DBISOCA5,DBISOCA6,DBISOCA7,DBISOCA8
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "10"
LinhaMsg(2); ProgName("GC211")
SET KEY -1 TO Mostra()
WHILE .T.
   SETCOLOR(YCOREDIT)
   wNomeSoc := SPACE(50)
   wPeriodoi:= wPeriodof:= SPACE(6)

   Telas(18,3,20,62,1,YCOREDIT,.T.)
   Mensagem("Informe Nome do Sขcio")
   @ 19,05 SAY "Nome:" GET wNomeSoc PICT "@!" WHEN TeclaFuncao(.T.) VALID;
               PTab(wNomeSoc,1,1,"Sขcio No Cadastrado")
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao(); Rest_Tela()
   IF LASTKEY()==K_ESC .OR. EMPTY(wNomeSoc); EXIT; ENDIF

   SELECT SOCIOS
   FOR a = 1 TO FCOUNT()
       xVar  := "w"+FIELDNAME(a)
       &xVar := FIELDGET(a)
   NEXT
   wNome      := wNomeSoc
   nMatricula := MATRICULA

   Telas(3,3,19,76,1,YCOREDIT,.T.,IF(pOper=1,"Incluso",IF(pOper=2,"Alterao","Excluso"))+" de Pagamento de Sขcios")
   LimpaLinhaMsg()

   @ 04,05 SAY "         Nome:" GET wNome      PICT "@!"
   @ 07,32 SAY "Mat. Clube:"    GET MATRICULA  COLOR YCORREALCE
   TCateg(5,24,wCategoria)
   @ 05,05 SAY "    Categoria:" GET wCategoria PICT "99" WHEN TeclaFuncao(.T.) VALID !EMPTY(wCategoria).AND.TCateg(5,24,wCategoria)
   @ 06,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 07,05 SAY "Mat.Petrobr s:" GET wMatr2     PICT "99999999"
   @ 07,32 SAY "Mat. Clube: "
   @ 08,05 SAY "      Unidade:" GET wUnidade   PICT "@!"
   @ 08,32 SAY "      Fone:"    GET wFone      PICT "@R (999) 999-9999"
   @ 09,05 SAY "      Lotao:" GET wLotacao   PICT "@!S18"
   @ 09,32 SAY "     Ramal:"    GET wRamal     PICT "9999"
   @ 10,03 SAY "ร"+REPL("ฤ",72)+"ด"
   CLEAR GETS

   IF CATEG->CODCAT=="01"
      Aviso("Ateno: Categoria de pagamento em folha",,2)
      Rest_Tela()
      LOOP
   ELSEIF CATEG->MENSALID==0.00
      Aviso("Ateno: Categoria no paga mensalidade",,2)
      Rest_Tela()
      LOOP
   ENDIF

   Telas(6,58,19,76,1,YCOREDIT,.T.,"Situao")
   WHILE .T.
      /* Montagem do vetor contendo os pagamentos efetuados ou nao no ano */
      TabPagSoc(nMatricula)

      lNovo     := lDeleta := lAchou := .F.
      nParcelas := 1 ; nCustoDep := 0.00
      @ 11,05 SAY "   Mes/Ano De:" GET wPeriodoi PICT "@R 99/9999" VALID  ;
         (!EMPTY(LEFT(wPeriodoi,2)).AND.!EMPTY(RIGHT(wPeriodoi,2))).AND.;
         VAL(LEFT(wPeriodoi,2))>=1.AND.VAL(LEFT(wPeriodoi,2))<=12
      IF pOper#2
         @ 11,38 SAY "Mes/Ano At:"  GET wPeriodof PICT "@R 99/9999" VALID ;
         (!EMPTY(LEFT(wPeriodof,2)).AND.!EMPTY(RIGHT(wPeriodof,2))).AND. ;
         VAL(LEFT(wPeriodof,2))>=1.AND.VAL(LEFT(wPeriodof,2))<=12 .AND.  ;
         (VAL(RIGHT(wPeriodof,4)+LEFT(wPeriodof,4))>=VAL(RIGHT(wPeriodoi,2)+LEFT(wPeriodoi,2)))
      ENDIF
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()==K_ESC .OR. EMPTY(wPeriodoi); EXIT; ENDIF

      SELECT PGSOC
      IF pOper>=2
         IF !DBSEEK(nMatricula+RIGHT(wPeriodoi,4)+LEFT(wPeriodoi,2))
            IF pOper==3
               Aviso("No h  pagamento efetuado neste mes...",,2)
            ELSEIF pOper==2
               Aviso("No h  pagamento neste mes a ser alterado...",,2)
            ENDIF
            LOOP
         ENDIF
         IF pOper==3
            TDifPer(pOper,wPeriodoi,wPeriodof,0,.T.)
         ENDIF
      ELSE
         /* Verificar situacao do Socio no periodo informado */
         IF !TDifPer(pOper,wPeriodoi,wPeriodof,0,.T.)
            LOOP
         ENDIF

         /* Pesquisar todos os socios vinculados ao titular */
         IF wMatr2 # SPACE(8)
            SELECT SOCIOS
            nRegAnt := RECNO()
            SET ORDER TO 4
            IF DBSEEK(wMatr2)
               Aguarde("Localizando Sขcios Afim")
               WHILE MATR2==wMatr2.AND.!EOF()
                  IF MATRICULA # nMatricula
                     nCustoDep += CalcCateg(CATEGORIA)
                  ENDIF
                  SELECT SOCIOS
                  DBSKIP()
               ENDDO
               Aguarde()
            ENDIF
            SELECT SOCIOS
            SET ORDER TO 1
            GO nRegAnt
            TCateg(5,24,CATEGORIA)
         ENDIF

         SELECT PGSOC
         DBGOBOTTOM()
         DBSKIP()
      ENDIF
      FOR a = 1 TO FCOUNT()
          xVar  := "w"+FIELDNAME(a)
          &xVar := FIELDGET(a)
      NEXT
      IF pOper==1
         wValor   := (CATEG->MENSALID+nCustoDep) * nParcelas
         wUsuario := cUsuario
*        @ 15,49 SAY SUBS(cUsuario,1,AT(" ",cUsuario)-1) COLOR YCORREALCE
      ELSEIF pOper==2
*        @ 15,49 SAY SUBS(wUsuario,1,AT(" ",wUsuario)-1) COLOR YCORREALCE
      ELSEIF pOper==3
         wValor   := nSomaPer
*        @ 15,49 SAY SUBS(wUsuario,1,AT(" ",wUsuario)-1) COLOR YCORREALCE
      ENDIF
      IF wDoc==SPACE(6)
         wTipoPg:="D"
      ELSEIF wDoc#SPACE(6)
         wTipoPg:="C"
      ENDIF

      @ 12,05 SAY " Nง do Recibo:" GET wRecibo  PICT "99999" VALID !EMPTY(wRecibo)
      @ 13,05 SAY " Dt.Pagamento:" GET wDtPag   PICT "@D"    VALID !EMPTY(wDtPag)
      @ 14,05 SAY "   Tipo Pagto:" GET wTipoPg  PICT "!"     WHEN HTela(3) VALID VTela(3)
      @ 15,05 SAY " Nง Documento:" GET wDoc     PICT "@!"    WHEN wTipoPg="C" VALID !EMPTY(wDoc)
      @ 15,35 SAY " Recebido Por:" GET wUsuario PICT "@!S8"  VALID !EMPTY(wUsuario)
      @ 16,05 SAY "        Valor:" GET wValor   PICT "@E 999,999,999.99" VALID wValor > 0
      @ 17,03 SAY "ร"+REPL("ฤ",54)  //+"ด"
      @ 18,05 SAY "   Observao:" GET wObs     PICT "@!S33"

      IF !NetLReg()
         CLEAR GETS
         LOOP
      ENDIF
      IF EOF()
         SETCURSOR(1); READ; SETCURSOR(0)
         msg   := "Confirma os Dados ? "
         lNovo := .T.
      ELSE
         IF pOper==3
            CLEAR GETS
            lDeleta := .T.
            msg     := "Confirma Excluso ? "
         ELSE
            SETCURSOR(1); READ; SETCURSOR(0)
            msg     := "Confirma Alterao ? "
            lAltera := .T.
         ENDIF
      ENDIF
      IF LASTKEY() <> K_ESC
         IF Confirma(msg)
            IF lDeleta
               IF !NetLReg()
                  LOOP
               ENDIF
               /* Eliminar o periodo abrangido */
               TDifPer(pOper,wPeriodoi,wPeriodof,wValor,.F.)
               UNLOCK
            ELSE
               IF lNovo
                  wUsuario := cUsuario
                  /* Calcular diferenca de meses entre os dois periodos */
                  TDifPer(pOper,wPeriodoi,wPeriodof,wValor,.F.)
               ELSE
                  SELECT PGSOC
                  wAnoMes := RIGHT(wPeriodoi,2)+LEFT(wPeriodoi,2)
                  FOR a = 1 TO FCOUNT()
                      xVar  := "w"+FIELDNAME(a)
                      FIELDPUT(a,&xVar)
                  NEXT
                  FIELD->MATRICULA := SOCIOS->MATRICULA
                  FIELD->CATEGORIA := SOCIOS->CATEGORIA
               ENDIF
               UNLOCK
               DBCOMMITALL()
            ENDIF
         ENDIF
      ELSE
         UNLOCK
         CLEAR GETS
      ENDIF
      IF LEN(Telas)==6 ; Rest_Tela() ; ENDIF
      SCROLL(12,20,16,56)
      SCROLL(18,20,18,56)
   ENDDO
   Rest_Tela()
   Rest_Tela()
ENDDO
RELEASE nParcelas,nSomaPer
SETCURSOR(0)
SETKEY(K_F2,NIL)
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Vetor de Pagamentos no Ano   ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE TabPagSoc(pMatr)
   LOCAL aMes[12], aAno[12], aSit[12], nLin:=7
   cIns := SUBS(DTOC(SOCIOS->DTADESAO),7,2)+SUBS(DTOC(SOCIOS->DTADESAO),4,2)
   SELECT PGSOC
   AFILL(aAno,cAno:=STRZERO(VAL(RIGHT(DTOC(DATE()),4)),4))
   FOR pg = 1 TO 12
       aMes[pg] := STRZERO(pg,2)
       aSit[pg] := IF(DBSEEK(pMatr+aAno[pg]+aMes[pg]),"Pago     ",;
                   IF(cIns>(aAno[pg]+aMes[pg]),"         ","Em Aberto"))
       @ nLin,59 SAY aMes[pg]+"/"+aAno[pg]
       @ nLin,67 SAY aSit[pg] COLOR YCORREALCE
       nLin++
   NEXT
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Calcular Dif.entre Periodos  ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TDifPer(pOper,pPerIni,pPerFim,pValor,pValid)
   LOCAL nAnoIni := RIGHT(pPerIni,4)
   LOCAL nMesIni := LEFT(pPerIni,2)
   LOCAL nAnoFim := RIGHT(pPerFim,4)
   LOCAL nMesFim := LEFT(pPerFim,2)

   nSomaPer := 0.00
   /* Verificar se pagamento do mes anterior foi efetuado */
   IF VAL(LEFT(pPerIni,2))==1
      nAnoAnt := VAL(RIGHT(pPerIni,4))-1
      nMesAnt := 12
   ELSE
      nAnoAnt := VAL(RIGHT(pPerIni,4))
      nMesAnt := VAL(LEFT(pPerIni,2))-1
   ENDIF
   wInscr     := SOCIOS->DTADESAO
   wAnoMesAnt := STRZERO(nAnoAnt,4)+STRZERO(nMesAnt,2)
   wDataPag   := UltDia(nMesIni,nAnoIni,wInscr)

   /* Verificar se o periodo informado  menor que data de inscrio */
   IF wDataPag < wInscr
      Aviso("Sขcio adido apขs este mes...",,2)
      RETURN .F.
   ELSEIF wInscr==wDataPag
      SELECT PGSOC
      IF DBSEEK(nMatricula+(nAnoIni+nMesIni))
         IF pOper==1
            Aviso("Ateno: Mes j  foi Pago",,2)
            RETURN .F.
         ENDIF
      ENDIF
   ELSEIF wInscr < wDataPag
      SELECT PGSOC
      IF !DBSEEK(nMatricula+wAnoMesAnt)
         IF pOper==1
            Aviso("Ateno: Mes anterior em dbito",,3)
            RETURN .F.
         ENDIF
      ENDIF
   ENDIF

   /* Verifica se possui mais de 1 mensalidade sendo paga */
   IF nAnoFim # nAnoIni
      nQMes := VAL(nMesFim)+((12*(VAL(nAnoFim)-VAL(nAnoIni)))-VAL(nMesIni)) + 1
   ELSE
      nQMes := (VAL(nMesFim)-VAL(nMesIni)) + 1
   ENDIF
   nParcelas := nQMes
   nValMedio := pValor/nQMes
   nMes      := VAL(nMesIni)
   nAno      := VAL(nAnoIni)
   FOR i = 1 TO nQMes
       SELECT PGSOC
       IF nMes==13 ; nAno++ ; nMes:=1 ; ENDIF
       wAnoMes := STRZERO(nAno,4)+STRZERO(nMes,2)
       IF pOper==3                                       /* Exclusao */
          IF DBSEEK(nMatricula+wAnoMes)
             IF !pValid
                WHILE !NetLReg(); ENDDO
                DBDELETE(); DBCOMMIT()
             ENDIF
             nSomaPer += VALOR
          ENDIF
       ELSE
          IF !DBSEEK(nMatricula+wAnoMes)
             IF !pValid
                IF NetApp()
                   wValor := nValMedio
                   FOR a = 1 TO FCOUNT()
                       xVar  := "w"+FIELDNAME(a)
                       FIELDPUT(a,&xVar)
                   NEXT
                   FIELD->MATRICULA := SOCIOS->MATRICULA
                   FIELD->CATEGORIA := SOCIOS->CATEGORIA
                ENDIF
             ENDIF
             UNLOCK
          ELSE
             IF nQMes=1
                Aviso("Ateno: Este mes j  foi pago",,2)
             ELSEIF nQMes>1
                Aviso("Ateno: Existem meses pagos neste intervalo...",,3)
             ENDIF
             RETURN .F.
          ENDIF
       ENDIF
       nMes++
   NEXT
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Calcular Mensalidade Categ.  ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION CalcCateg(pCateg)
   LOCAL cArq := SELECT()
   SELECT CATEG
   DBSEEK(pCateg)
   pMensalidade := MENSALID
   SELECT (cArq)
   RETURN(pMensalidade)
