*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_212                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Registrar Pagamentos de Usu rios         ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 18/10/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PROCEDURE AP_212(pOper)
PUBLIC nParcelas,nSomaPer

DBCLOSEALL()
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
LinhaMsg(2); ProgName("GC212")
SET KEY -1 TO Mostra()
WHILE .T.
   
   SETCOLOR(YCOREDIT)

   wNomeUsu := SPACE(50)
   wAtiv    := SPACE(2)
   wPeriodoi:= wPeriodof:= SPACE(6)

   Telas(18,3,20,62,1,YCOREDIT,.T.)
   Mensagem("Informe Nome do Usu rio")
   @ 19,05 SAY "Nome:" GET wNomeUsu PICT "@!" WHEN TeclaFuncao(.T.) VALID;
               PTab(wNomeUsu,4,2,"Usu rio No Cadastrado")
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   Rest_Tela()
   IF LASTKEY()==K_ESC .OR. EMPTY(wNomeUsu)
      EXIT
   ENDIF

   SELECT USUARIOS
   FOR a = 1 TO FCOUNT()
       xVar  := "w"+FIELDNAME(a)
       &xVar := FIELDGET(a)
   NEXT
   nMatricula := MATRICULA
   wInscr     := CTOD("")
   wNome      := wNomeUsu

   Telas(3,3,19,76,1,YCOREDIT,.T.,IF(pOper=1,"Incluso",IF(pOper=2,"Alterao","Excluso"))+" de Pagamento de Usu rios")
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
   CLEAR GETS

   aAtiv := {}
   PegaAtiv()
   IF LEN(aAtiv)==0
      Aviso("Usu rio no possui Atividade")
      Rest_Tela()
      LOOP
   ENDIF
   Telas(6,58,19,76,1,YCOREDIT,.T.,"Situao")
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
      lNovo := lDeleta := lAchou := .F.
      nParcelas := 1
      wInscr    := TDtInscr()
      @ 10,32 SAY "Inscrio:" GET wInscr PICT "@D"
      CLEAR GETS

      /* Montagem do vetor contendo os pagamentos efetuados ou nao no ano */
      TabPagUsu(nMatricula,wAtiv)

      @ 11,05 SAY "  Mes/Ano De:"  GET wPeriodoi PICT "@R 99/9999" VALID ;
         (!EMPTY(LEFT(wPeriodoi,2)).AND.!EMPTY(RIGHT(wPeriodoi,2))).AND.;
         VAL(LEFT(wPeriodoi,2))>=1.AND.VAL(LEFT(wPeriodoi,2))<=12
      IF pOper#2
         @ 11,30 SAY "Mes/Ano At:" GET wPeriodof PICT "@R 99/9999" VALID   ;
           (!EMPTY(LEFT(wPeriodof,2)).AND.!EMPTY(RIGHT(wPeriodof,2))).AND.;
           VAL(LEFT(wPeriodof,2))>=1.AND.VAL(LEFT(wPeriodof,2))<=12  .AND.;
           (VAL(RIGHT(wPeriodof,4)+LEFT(wPeriodof,4))>=VAL(RIGHT(wPeriodoi,2)+LEFT(wPeriodoi,2)))
      ENDIF
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()==K_ESC .OR. EMPTY(wPeriodoi)
         SCROLL(12,20,16,54)
         SCROLL(18,20,18,54)
         LOOP
      ENDIF

      SELECT PGUSU
      IF pOper>=2
         IF !DBSEEK(nMatricula+wAtiv+RIGHT(wPeriodoi,4)+LEFT(wPeriodoi,2))
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
         IF !TDifPer(pOper,wPeriodoi,wPeriodof,0,.T.)
            LOOP
         ENDIF
         DBGOBOTTOM()
         DBSKIP()
      ENDIF
      FOR a = 1 TO FCOUNT()
          xVar  := "w"+FIELDNAME(a)
          &xVar := FIELDGET(a)
      NEXT
      IF pOper==1
         wValor := ATIV->MENSALID * nParcelas
         wUsuario := cUsuario
*        @ 15,48 SAY SUBS(cUsuario,1,AT(" ",cUsuario)-1) COLOR YCORREALCE
      ELSEIF pOper==2
*        @ 15,48 SAY SUBS(wUsuario,1,AT(" ",wUsuario)-1) COLOR YCORREALCE
      ELSEIF pOper==3
         wValor := nSomaPer
*        @ 15,48 SAY SUBS(wUsuario,1,AT(" ",wUsuario)-1) COLOR YCORREALCE
      ENDIF
      IF wDoc==SPACE(6)
         wTipoPg:="D"
      ELSEIF wDoc#SPACE(6)
         wTipoPg:="C"
      ENDIF

      @ 12,05 SAY "Nง do Recibo:" GET wRecibo  PICT "99999" VALID !EMPTY(wRecibo)
      @ 13,05 SAY "Dt.Pagamento:" GET wDtPag   PICT "@D"    VALID !EMPTY(wDtPag)
      @ 14,05 SAY "  Tipo Pagto:" GET wTipoPg  PICT "!"     WHEN HTela(3) VALID VTela(3)
      @ 15,05 SAY "Nง Documento:" GET wDoc     PICT "@!"    WHEN wTipoPg="C" VALID !EMPTY(wDoc)
      @ 15,35 SAY "Recebido Por:" GET wUsuario PICT "@!S8"  VALID !EMPTY(wUsuario)
      @ 16,05 SAY "       Valor:" GET wValor   PICT "@E 999,999,999.99" VALID wValor > 0
      @ 17,03 SAY "ร"+REPL("ฤ",54)+"ด"
      @ 18,05 SAY "  Observao:" GET wObs     PICT "@!S33"

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
                  SELECT PGUSU
                  IF NetLReg()
                     wAtividade := wAtiv
                     wAnoMes    := RIGHT(wPeriodoi,2)+LEFT(wPeriodoi,2)
                     FOR a = 1 TO FCOUNT()
                         xVar  := "w"+FIELDNAME(a)
                         FIELDPUT(a,&xVar)
                     NEXT
                     FIELD->MATRICULA := USUARIOS->MATRICULA
                     FIELD->NOME      := USUARIOS->NOME
                     FIELD->ATIVIDADE := USUATIV->ATIVIDADE
                  ENDIF
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
      TabPagUsu(nMatricula,wAtiv)
      SCROLL(12,19,16,56)
      SCROLL(18,19,18,56)
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
*ณ Controlar Tecla Pressionada  ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION BUNDA(mens,lin,pos)
vpos=pos
vlin=lin
SAVE SCREEN

DO CASE
   CASE LASTKEY()==K_ENTER
        vvalor=1
   CASE LASTKEY()==K_ESC
        vvalor=0
   OTHER
        vvalor=2
ENDCASE
RESTORE SCREEN
RETURN vvalor
*ีออออออออออออออออออออออออออออออธ
*ณ Atividades Utilizadas        ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION PegaAtiv()
   LOCAL cArq:=SELECT()

   SELECT USUATIV
   SET ORDER TO 1
   DBSEEK(nMatricula)
   WHILE MATRICULA==nMatricula
      AADD(aAtiv,ATIVIDADE+" "+TAtiv(ATIVIDADE))
      DBSKIP()
   ENDDO
   SELECT (cArq)
   RETURN NIL
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
   LOCAL aMes[12], aAno[12], aSit[12], nLin:=7
   cIns := SUBS(DTOC(wInscr),7,2)+SUBS(DTOC(wInscr),4,2)
   SELECT PGUSU
   AFILL(aAno,cAno:=STRZERO(VAL(RIGHT(DTOC(DATE()),4)),4))
   FOR pg = 1 TO 12
       aMes[pg] := STRZERO(pg,2)
       aSit[pg] := IF(DBSEEK(pMatr+pAtiv+aAno[pg]+aMes[pg]),"Pago     ",;
                   IF(cIns>(aAno[pg]+aMes[pg]),"         ","         "))
       @ nLin,59 SAY aMes[pg]+"/"+aAno[pg]
       @ nLin,67 SAY aSit[pg] COLOR YCORREALCE
       nLin++
   NEXT
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Calcular Ultimo Dia do Mes   ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION UltDia(pMes,pAno,pDataRef)
   LOCAL nIncrem:=0, sComp:="/"+pMes+"/"+pAno
   WHILE .T.
      wDia := STRZERO(DAY(pDataRef)-nIncrem++,2)
      IF !EMPTY(CTOD(wDia+sComp))
         EXIT
      ENDIF
   ENDDO
   RETURN(CTOD(wDia+sComp))
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
   wAnoMesAnt := STRZERO(nAnoAnt,4)+STRZERO(nMesAnt,2)
   wDataPag   := UltDia(nMesIni,nAnoIni,wInscr)

   /* Verificar se o periodo informado  menor que data de inscrio */
   IF wDataPag < wInscr
      Aviso("Usu rio inscrito apขs este mes...",,2)
      RETURN .F.
   ELSEIF wInscr==wDataPag
      SELECT PGUSU
      IF DBSEEK(nMatricula+wAtiv+(nAnoIni+nMesIni))
         IF pOper==1
            Aviso("Ateno: Mes j  foi pago",,2)
            RETURN .F.
         ENDIF
      ENDIF
   ELSEIF wInscr < wDataPag
      SELECT PGUSU
      IF !DBSEEK(nMatricula+wAtiv+wAnoMesAnt)
*        IF pOper==1
*           Aviso("Ateno: Mes anterior em dbito",,2)
*           RETURN .F.
*        ENDIF
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
       SELECT PGUSU
       IF nMes==13 ; nAno++ ; nMes:=1 ; ENDIF
       wAnoMes := STRZERO(nAno,4)+STRZERO(nMes,2)
       IF pOper==3                                       /* Exclusao */
          IF DBSEEK(nMatricula+wAtiv+wAnoMes)
             IF !pValid
                IF NetLReg()
                   DBDELETE()
                ENDIF
             ENDIF
             nSomaPer += VALOR
          ENDIF
       ELSE
          IF !DBSEEK(nMatricula+wAtiv+wAnoMes)
             IF !pValid
                IF NetApp()
                   wValor := nValMedio
                   FOR a = 1 TO FCOUNT()
                       xVar  := "w"+FIELDNAME(a)
                       FIELDPUT(a,&xVar)
                   NEXT
                   FIELD->MATRICULA := USUARIOS->MATRICULA
                   FIELD->NOME      := USUARIOS->NOME
                   FIELD->ATIVIDADE := USUATIV->ATIVIDADE
                ENDIF
             ENDIF
             UNLOCK
          ELSE
             IF nQMes=1
                Aviso("Ateno: Este mes j  foi pago",,2)
             ELSEIF nQMes>1
                Aviso("Ateno: Existem meses pagos neste intervalo",,3)
             ENDIF
             RETURN .F.
          ENDIF
       ENDIF
       nMes++
   NEXT
   RETURN .T.
