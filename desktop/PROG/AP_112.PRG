*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_112                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cadastrar Dependentes                    ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 06/10/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PROCEDURE AP_112(pOper)

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD( aDbf, { "NOME"  ,"C", 50, 0 } )
AADD( aDbf, { "GRAU"  ,"C", 10, 0 } )

WHILE .T.
   sHour:=TIME()
   cArq1:="TM"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE(cArq1,aDbf); RELEASE aDbf; EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")
INDEX ON nome TO (cArq1)

SELECT 5
IF !NetUse("DBPARM")
   DelDbfNtx(); RETURN
ENDIF

SELECT 4
IF NetUse("CATEG")
   SET INDEX TO DBICATE1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DEPEND")
   SET INDEX TO DBIDEPA2,DBIDEPA1,DBIDEPA3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("COBRANCA")
   SET INDEX TO DBICOBR1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2,DBISOCA1,DBISOCA3,DBISOCA4,DBISOCA5,DBISOCA6,DBISOCA7,DBISOCA8
ELSE
   DelDbfNtx(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "10"
LinhaMsg(2)
ProgName("GC112")
SET KEY -1 TO Mostra()
WHILE .T.
   Telas(18,3,20,62,1,YCOREDIT,.T.)
   SETCURSOR(1)
   SETCOLOR(YCOREDIT)
   lNovo := lDeleta := lAchou := .F.
   wNomeDep := SPACE(50)
   wNomeSoc := SPACE(50)

   IF pOper==1
      Mensagem("Informe Nome do Sขcio Titular")
      @ 19,05 SAY "Nome:" GET wNomeSoc PICT "@!" WHEN TeclaFuncao(.T.)
   ELSE
      Mensagem("Informe Nome do Dependente")
      @ 19,05 SAY "Nome:" GET wNomeDep PICT "@!" WHEN IF(pOper>=2,TeclaFuncao(.T.),TeclaFuncao())
   ENDIF
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   Rest_Tela()
   IF LASTKEY()==K_ESC .OR. EMPTY(IF(pOper=1,wNomeSoc,wNomeDep))
      EXIT
   ENDIF

   IF pOper==1
      SELECT SOCIOS
      SET ORDER TO 1
      IF !DBSEEK(wNomeSoc)
         Aviso("Sขcio no Cadastrado !")
         LOOP
      ENDIF
      /* Preencher arquivo temporario */
      vMatricula := MATRICULA
      SELECT DEPEND
      SET ORDER TO 2
      IF DBSEEK(vMatricula)
         WHILE MATRICULA==vMatricula.AND.!EOF()
            SELECT (cArq1)
            DBAPPEND()
            FIELD->NOME := DEPEND->NOME; FIELD->GRAU := DEPEND->GRAU
            SELECT DEPEND
            DBSKIP()
         ENDDO
      ENDIF
      SET ORDER TO 1
      SELECT SOCIOS
   ELSE
      SELECT DEPEND
      IF DBSEEK(wNomeDep)
         lAchou := .T.
         IF pOper==1
            Aviso("Dependente j  Cadastrado !")
            LOOP
         ENDIF
         IF pOper==2.AND.!NetLReg()
            LOOP
         ENDIF
      ELSE
         IF pOper>=2
            Aviso("Dependente no Cadastrado !")
            LOOP
         ENDIF
      ENDIF
   ENDIF

   FOR a = 1 TO FCOUNT()
       xVar  := "w"+FIELDNAME(a)
       &xVar := FIELDGET(a)
   NEXT

   Telas(3,3,14,76,1,YCOREDIT,.T.,IF(pOper=1,"Incluso",IF(pOper=2,"Alterao",IF(pOper=3,"Excluso","Consulta")))+" de Dependente")
   IF pOper==1
      TCateg(5,24,wCategoria)
      wNome     := SPACE(50)
      wCateg    := wCategoria
      wSexo     := SPACE(1)
      wGrau     := SPACE(10)
      wCobranca := SPACE(2)
      wDtNas    := CTOD("")
      SELECT DEPEND
      DBGOBOTTOM()
      DBSKIP()
   ELSE
      SELECT SOCIOS
      SET ORDER TO 2
      IF DBSEEK(wMatricula)
         wNomeSoc   := NOME
         wCateg     := CATEGORIA
         TCateg(5,24,wCateg)
      ELSE
         wNomeSoc   := SPACE(50)
         wCateg     := SPACE(2)
         wMatricula := SPACE(7)
      ENDIF
      TCobra1(13,24,wCobranca)
   ENDIF

   @ 04,05 SAY "      Titular:" GET wNomeSoc   PICT "@!"
   @ 05,05 SAY "    Categoria:" GET wCateg     PICT "99"
   @ 06,05 SAY "  Matr. Clube:" GET wMatricula PICT "99999" COLOR YCORREALCE
   @ 07,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 09,05 SAY "         Sexo:" GET wSexo      PICT "!"  WHEN TeclaFuncao() VALID wSexo $ "MF"
   @ 10,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 11,05 SAY " Grau Parent.:" GET wGrau      PICT "@!"
   @ 12,05 SAY "Dt.Nascimento:" GET wDtNas     PICT "@D" WHEN TeclaFuncao() VALID !EMPTY(wDtNas)
   @ 13,05 SAY "     Cobrana:" GET wCobranca  PICT "99" WHEN TeclaFuncao(.T.) VALID !EMPTY(wCobranca).AND.TCobra1(13,24,wCobranca)
   CLEAR GETS
   LimpaLinhaMsg()

   WHILE .T.
      IF pOper==1
         lNovo := lDeleta := lAchou := .F.
         wNome     := SPACE(50)
         wSexo     := SPACE(1)
         wGrau     := SPACE(10)
         wCobranca := SPACE(2)
         wDtNas    := CTOD("")

         Mensagem("Informe Nome do Dependente")
         @ 08,05 SAY "   Dependente:" GET wNome PICT "@!" WHEN TeclaFuncao(.T.)
         SETCURSOR(1); READ; SETCURSOR(0)

         TeclaFuncao()
         IF LASTKEY()==K_ESC .OR. EMPTY(wNome); EXIT; ENDIF

         SELECT DEPEND
         IF DBSEEK(wNome)
            lAchou := .T.
            IF pOper==1
               Aviso("Dependente j  Cadastrado !"); LOOP
            ENDIF
            FOR a = 1 TO FCOUNT()
                xVar  := "w"+FIELDNAME(a)
                &xVar := FIELDGET(a)
            NEXT
         ENDIF
      ELSE
         @ 08,05 SAY "   Dependente:" GET wNomeDep  PICT "@!"
      ENDIF
      @ 09,05 SAY "         Sexo:" GET wSexo     PICT "!"  WHEN TeclaFuncao() VALID wSexo $ "MF"
      @ 10,03 SAY "ร"+REPL("ฤ",72)+"ด"
      @ 11,05 SAY " Grau Parent.:" GET wGrau     PICT "@!"
      @ 12,05 SAY "Dt.Nascimento:" GET wDtNas    PICT "@D" WHEN TeclaFuncao() VALID !EMPTY(wDtNas)
      @ 13,05 SAY "     Cobrana:" GET wCobranca PICT "99" WHEN TeclaFuncao(.T.) VALID !EMPTY(wCobranca).AND.TCobra1(13,24,wCobranca)
      LimpaLinhaMsg()

      IF EOF()
         SETCURSOR(1); READ; SETCURSOR(0)
         msg   := "Confirma os Dados ? "
         lNovo := .T.
      ELSE
         IF pOper==2
            IF Acesso(3)
               SETCURSOR(1); READ; SETCURSOR(0)
               msg     := "Confirma Alterao ? "
               lAltera := .T.
            ELSE
               CLEAR GETS; EXIT
            ENDIF
         ELSEIF pOper==3
            CLEAR GETS
            IF Acesso(3)
               msg     := "Confirma Excluso ? "
               lDeleta := .T.
            ELSE
               EXIT
            ENDIF
         ELSEIF pOper==4
            Mensagem("Tecle algo para continuar...")
            INKEY(0)
            CLEAR GETS; EXIT
         ENDIF
      ENDIF
      IF LASTKEY() <> K_ESC
         IF Confirma(msg)
            SELECT DEPEND
            IF lDeleta
               WHILE !NetLReg(); ENDDO
               DBDELETE(); DBCOMMIT()
               EXIT
            ELSE
               IF lNovo
                  WHILE !NetApp(); ENDDO
                  (cArq1)->(DBAPPEND()) /* Incluir registro no temporario */
               ENDIF
               (cArq1)->NOME := wNome
               (cArq1)->GRAU := wGrau
               IF pOper#1 ; wNome := wNomeDep ; ENDIF
               FOR a = 1 TO FCOUNT()
                   xVar  := "w"+FIELDNAME(a)
                   FIELDPUT(a,&xVar)
               NEXT
            ENDIF
            DBCOMMITALL()
            IF pOper==2; EXIT; ENDIF
         ELSE
            EXIT
         ENDIF
      ELSE
         CLEAR GETS
         IF pOper#1 ; EXIT ; ENDIF
      ENDIF
      UNLOCK ALL
      SCROLL(08,20,09,50)
      SCROLL(11,20,12,50)
      SCROLL(13,20,13,50)
   ENDDO
   UNLOCK ALL
   SCROLL(08,20,09,50)
   SCROLL(11,20,12,50)
   SCROLL(13,20,13,50)
   Rest_Tela()
   SELECT (cArq1); ZAP
ENDDO
SETKEY(K_F2,NIL)
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Validar Cobrana             ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TCobra1(nLin,nCol,wCobra)
   LOCAL cArq1:=SELECT()
   IF !EMPTY(wCobra)
      SELECT COBRANCA
      IF !DBSEEK(wCobra)
         Aviso("Cobrana no Cadastrada",,3)
         SELECT(cArq1)
         RETURN .F.
      ENDIF
      nTamTexto:= 79-nCol
      @ nLin,nCol   SAY CHR(26)
      @ nLin,nCol+2 SAY IF(nTamTexto<50,SUBS(DESCR,1,nTamTexto-5),DESCR) COLOR YCORREALCE
      SELECT(cArq1)
      TeclaFuncao()
   ENDIF
   RETURN .T.
