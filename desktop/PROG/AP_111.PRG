*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_111                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cadastrar Sขcios                         ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 24/09/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
#include "COMMAND.CH"

PROCEDURE AP_111(pOper)

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

SELECT 11
IF !NetUse("CLUB.CFG","CLUBCFG")     /* Renovacao de Convites */
   DelDbfNtx(); RETURN
ENDIF
wLimite := CLUBCFG->LIMITE
USE

SELECT 9
IF NetUse("CCONV")                   /* Cadastro de Convites */
   SET INDEX TO CCONV
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 8
IF NetUse("DEPEND")
   SET INDEX TO DBIDEPA2,DBIDEPA1,DBIDEPA3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 7
IF NetUse("AREAC")
   SET INDEX TO DBIAREA1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 6
IF NetUse("UNIDADE")
   SET INDEX TO DBIUNID1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 5
IF NetUse("COBRANCA")
   SET INDEX TO DBICOBR1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 4
IF !NetUse("DBPARM")
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("FUNC")
   SET INDEX TO DBIFUNC2,DBIFUNC1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("CATEG")
   SET INDEX TO DBICATE1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2,DBISOCA1,DBISOCA3,DBISOCA4,DBISOCA5,DBISOCA6,DBISOCA7,DBISOCA8,DBISOCA9
ELSE
   DelDbfNtx(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "10"
ProgName("GC111"); LinhaMsg(10)
SET KEY -1 TO Mostra()
SET KEY -6 TO Mostra()
WHILE .T.
   lNovo := lDeleta := lAchou := .F.
   wNomeSoc := SPACE(50)
    
   Telas(18,3,20,62,1,YCOREDIT,.T.); SETCOLOR(YCOREDIT)
   Mensagem("Informe Nome do Sขcio")
   @ 19,05 SAY "Nome:" GET wNomeSoc PICT "@!" WHEN IF(pOper>=2,TeclaFuncao(.T.),TeclaFuncao())
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao(); Rest_Tela()
   IF LASTKEY()==K_ESC .OR. EMPTY(wNomeSoc); EXIT; ENDIF

   SELECT SOCIOS
   SET ORDER TO 1
   IF NOME#wNomeSoc
      IF DBSEEK(wNomeSoc)
         lAchou := .T.
         IF pOper==1
            Aviso("Sขcio j  Cadastrado !"); LOOP
         ENDIF
         IF pOper==2.AND.!NetLReg(); LOOP; ENDIF

         /* Preencher arquivo temporario */
         vMatricula := MATRICULA
         SELECT DEPEND
         SET ORDER TO 2
         IF DBSEEK(vMatricula)
            WHILE MATRICULA==vMatricula.AND.!EOF()
               SELECT (cArq1); DBAPPEND()
               FIELD->NOME := DEPEND->NOME; FIELD->GRAU := DEPEND->GRAU
               SELECT DEPEND; DBSKIP()
            ENDDO
         ENDIF
         SET ORDER TO 1
         SELECT SOCIOS
      ELSE
         IF pOper>=2
            Aviso("Sขcio no Cadastrado !")
            LOOP
         ENDIF
      ENDIF
   ELSE
      lAchou := .T.
      IF pOper==1
         Aviso("Sขcio j  Cadastrado !"); LOOP
      ENDIF
      IF pOper==2.AND.!NetLReg(); LOOP; ENDIF

      /* Preencher arquivo temporario */
      vMatricula := MATRICULA
      SELECT DEPEND
      SET ORDER TO 2
      IF DBSEEK(vMatricula)
         WHILE MATRICULA==vMatricula.AND.!EOF()
            SELECT (cArq1); DBAPPEND()
            FIELD->NOME := DEPEND->NOME; FIELD->GRAU := DEPEND->GRAU
            SELECT DEPEND; DBSKIP()
         ENDDO
      ENDIF
      SET ORDER TO 1
      SELECT SOCIOS
   ENDIF

   FOR a = 1 TO FCOUNT()
       xVar  := "w"+FIELDNAME(a)
       &xVar := FIELDGET(a)
   NEXT
   wNome := wNomeSoc
   IF !lAchou ; wNacional := "BRASILEIRA" ; ENDIF

   Telas(3,3,21,76,1,YCOREDIT,.T.,IF(pOper=1,"Incluso",IF(pOper=2,"Alterao","Consulta"))+" de Sขcios")
   @ 04,05 SAY "         Nome:"  GET wNome PICT "@!"
   IF lAchou
      /* Display da Matricula */
      @ 07,38 SAY "Mat. Clube: " GET MATRICULA COLOR YCORREALCE
      TCateg(5,24,wCategoria,,pOper)
   ENDIF
   TArea(8,53,wArea,,pOper)
   TArea(9,53,wArea2,,pOper)
   TCobra(18,54,wCobranca)
   CLEAR GETS

   LimpaLinhaMsg()
   EntraDados(pOper)

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
            CLEAR GETS; LOOP
         ENDIF
      ELSEIF pOper==3
         Mensagem("Tecle algo para continuar...")
         SETCURSOR(1); READ; SETCURSOR(0)
         CLEAR GETS; Rest_Tela()
         (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
         LOOP
      ENDIF
   ENDIF
   IF LASTKEY() <> K_ESC
      IF Confirma(msg)
         IF lNovo
            IF !NetApp(); LOOP; ENDIF
         ENDIF
         SELECT DBPARM
         DBGOTOP()
         IF EOF() ; NetApp() ; ENDIF
         IF NetLReg()
            IF lNovo
               wMatricula := STRZERO(VAL(MATRICULA)+1,5)
               FIELD->MATRICULA  := wMatricula
            ENDIF
            SELECT SOCIOS
            FOR a = 1 TO FCOUNT()
                xVar  := "w"+FIELDNAME(a)
                FIELDPUT(a,&xVar)
            NEXT
            IF lNovo
               @ 07,50 SAY wMatricula COLOR YCORREALCE
               Mensagem("Tecle algo para continuar...")
               INKEY(0)
               CCONV->(DBAPPEND())
               CCONV->MATRICULA := wMatricula
               CCONV->QCONMES   := wLimite
               CCONV->QDISP     := wLimite
            ENDIF
            UNLOCK
         ENDIF
         UNLOCK
         DBCOMMITALL()
      ENDIF
   ELSE
      CLEAR GETS
   ENDIF
   UNLOCK ALL
   (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL)
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Entrada de Dados             ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION EntraDados(pOper)
   @ 04,05 SAY "         Nome:" GET wNome PICT "@!" WHEN TeclaFuncao().AND.IF(pOper#2,.F.,.T.)
   @ 05,05 SAY "    Categoria:" GET wCategoria PICT "99" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(wCategoria).AND.TCateg(5,24,wCategoria,,pOper)
   @ 06,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 07,05 SAY "Mat.Petrobr s:" GET wMatr2     PICT "99999999" WHEN TeclaFuncao();
     .AND.wCategoria#"02" .or. wCategoria#"09" VALID TAfim(wMatr2)
   @ 07,38 SAY "Mat. Clube: "
   @ 07,58 SAY "Unidade:"       GET wUnidade   PICT "@!"    WHEN wCategoria#"02";
     VALID TUnid(wUnidade)
   @ 08,05 SAY "      Lotao:" GET wLotacao   PICT "@!S20" WHEN TeclaFuncao();
     .AND.wCategoria#"02"
   @ 09,05 SAY " Funo Clube:" GET wFuncao    PICT "@!S20" WHEN TeclaFuncao(.T.);
     .AND.wCategoria#"02" VALID TFunc(wFuncao)
   @ 08,44 SAY "Area:"          GET wArea      PICT "@!"    WHEN TeclaFuncao(.T.);
     .AND.wCategoria#"02" VALID TArea(8,53,wArea,,pOper)
   @ 09,44 SAY "    :"          GET wArea2     PICT "@!"    WHEN TeclaFuncao(.T.);
     .AND.wCategoria#"02" VALID TArea(9,53,wArea2,,pOper)
   @ 10,38 SAY "      Fone:"    GET wFone      PICT "@R (999) 999-9999" WHEN TeclaFuncao();
     .AND.wCategoria#"02"
   @ 10,67 SAY "R:"             GET wRamal     PICT "9999" WHEN wCategoria#"02"

*  @ 10,03 SAY "ร"+REPL("ฤ",72)+"ด"

   @ 11,05 SAY "Dt.Nascimento:" GET wDatNas    PICT "@D"
   @ 12,05 SAY "Nacionalidade:" GET wNacional  PICT "@!"
   @ 13,05 SAY " Naturalidade:" GET wNatural   PICT "@!"
   @ 14,05 SAY "         Sexo:" GET wSexo      PICT "!" VALID wSexo $ "MF"
   @ 15,05 SAY " Estado Civil:" GET wEstCivil  PICT "!" VALID TEstCivil(wEstCivil)
   @ 16,05 SAY "          CPF:" GET wCPF       PICT "@R 999 999 999-99" VALID EMPTY(wCPF).OR.ChkCPF(wCPF)
   @ 17,05 SAY "   Identidade:" GET wRG
   @ 18,05 SAY "    Profisso:" GET wProfissao PICT "@!"
   @ 11,38 SAY "  Endereo:"    GET wEndereco  PICT "@!S25"
   @ 12,38 SAY "    Bairro:"    GET wBairro    PICT "@!"
   @ 13,38 SAY "    Cidade:"    GET wCidade    PICT "@!"
   @ 14,38 SAY "    Estado:"    GET wEstado    PICT "!!" VALID ChkUF(wEstado)
   @ 15,38 SAY "       CEP:"    GET wCEP       PICT "@R 99.999-999"
   @ 16,38 SAY "      Fone:"    GET wTel       PICT "@R (999) 999-9999"
   @ 17,38 SAY " Dt.Adeso:"    GET wDtAdesao  PICT "@D" WHEN TeclaFuncao().AND.nNivel>=9 VALID !EMPTY(wDtAdesao)
   @ 18,38 SAY "  Cobrana:"    GET wCobranca  PICT "99" WHEN TeclaFuncao(.T.) VALID !EMPTY(wCobranca).AND.TCobra(18,54,wCobranca)
   @ 19,05 SAY "   Observao:" GET wObs       PICT "@!S54" WHEN TeclaFuncao()
   @ 20,05 SAY " Motivo Reat.:" GET wMotivo    PICT "@!S30" WHEN .F.
   @ 20,52 SAY "Usuario:"       GET wUsuario   PICT "@!" WHEN .F.
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Testar se  Socio Afim       ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TAfim(pMatr)
   LOCAL cOrdem := INDEXORD()
   IF wCategoria=="07"
      SELECT SOCIOS
      nRegAntes := RECNO()
      SET ORDER TO 4
      IF DBSEEK(pMatr)
         wObs := "DESCONTO MENSALIDADE DO SOCIO "+SOCIOS->NOME
         @ 20,20 SAY wObs PICT "@!S54" COLOR YCORREALCE
         SET ORDER TO (cOrdem)
         GO nRegAntes
      ELSE
         Aviso("Sขcio Titular no Localizado")
         SET ORDER TO (cOrdem)
         GO nRegAntes
         RETURN .F.
      ENDIF
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Validar Categoria            ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TCateg(nLin,nCol,wCat,cPic,pOper)
   LOCAL cArq:=SELECT()
   DEFAULT cPic TO "@!"

   IF !EMPTY(wCat)
      SELECT CATEG
      IF !DBSEEK(wCat)
         IF Acesso(3)
            IF Confirma("Categoria no Cadastrada! Deseja Cadastrar ?")
               GetList:={}
               wDescr := SPACE(50)
               wMensal:= 0.00
               Telas(16,2,20,60,c_nBorda,YCOREDIT,.T.,"Incluso de Categoria")
               @ 17,03 SAY "Categoria  :"
               @ 17,16 SAY wCat PICT "99" COLOR YCORREALCE
               @ 18,03 SAY "Descrio  :" GET wDescr  PICT "@!S40" VALID !EMPTY(wDescr)
               @ 19,03 SAY "Mensalidade:" GET wMensal PICT "@E 999,999,999.99"
               READ
               Rest_Tela()
               IF LASTKEY()#K_ESC
                  IF NetApp()
                     REPLACE _FIELD->CODCAT   WITH wCat,;
                             _FIELD->DESCR    WITH wDescr,;
                             _FIELD->MENSALID WITH wMensal
                     UNLOCK
                     DBCOMMITALL()
                     ProcOk("Gravado")
                     nTamTexto:= 79-nCol
                     @ nLin,nCol   SAY CHR(26)
                     @ nLin,nCol+2 SAY IF(nTamTexto<50,SUBS(CATEG->DESCR,1,nTamTexto-5),CATEG->DESCR) PICT (cPic) COLOR YCORREALCE
                     SELECT(cArq)
                     IF pOper#NIL ; EntraDados(pOper) ; ENDIF
                     RETURN .T.
                  ENDIF
               ENDIF
               IF pOper#NIL ; EntraDados(pOper) ; ENDIF
            ENDIF
         ENDIF
         SELECT(cArq)
         RETURN .F.
      ENDIF
      nTamTexto:= 79-nCol
      @ nLin,nCol   SAY CHR(26)
      @ nLin,nCol+2 SAY IF(nTamTexto<50,SUBS(CATEG->DESCR,1,nTamTexto-5),CATEG->DESCR) PICT (cPic) COLOR YCORREALCE
      SELECT(cArq)
   ELSE
      @ nLin,nCol SAY SPACE(15)
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Validar Area de Competencia  ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TArea(nLin,nCol,pArea,cPic,pOper)
   LOCAL cArq:=SELECT()
   DEFAULT cPic TO "@!"

   IF !EMPTY(pArea)
      SELECT AREAC
      IF !DBSEEK(pArea)
         IF Acesso(3)
            IF Confirma("Area de Competncia no Cadastrada! Deseja Cadastrar ?")
               GetList:={}
               wDescr := SPACE(30)
               Telas(17,2,20,45,c_nBorda,YCOREDIT,.T.,"Incluso de Area Comp.")
               @ 18,03 SAY "Area     :"
               @ 18,14 SAY pArea                   PICT "@!" COLOR YCORREALCE
               @ 19,03 SAY "Descrio:" GET wDescr PICT "@!S40" VALID !EMPTY(wDescr)
               READ
               Rest_Tela()
               IF LASTKEY()#K_ESC
                  IF NetApp()
                     REPLACE _FIELD->AREACOMP WITH pArea,;
                             _FIELD->DESCR    WITH wDescr
                     UNLOCK
                     DBCOMMITALL()
                     ProcOk("Gravado")
                     nTamTexto:= 79-nCol
                     @ nLin,nCol   SAY CHR(26)
                     @ nLin,nCol+2 SAY IF(nTamTexto<50,SUBS(AREAC->DESCR,1,nTamTexto-5),AREAC->DESCR) PICT (cPic) COLOR YCORREALCE
                     SELECT(cArq)
                     IF pOper#NIL ; EntraDados(pOper) ; ENDIF
                     RETURN .T.
                  ENDIF
               ENDIF
               IF pOper#NIL ; EntraDados(pOper) ; ENDIF
            ENDIF
         ENDIF
         SELECT(cArq)
         RETURN .F.
      ENDIF
      nTamTexto:= 79-nCol
      @ nLin,nCol   SAY CHR(26)
      @ nLin,nCol+2 SAY IF(nTamTexto<50,SUBS(AREAC->DESCR,1,nTamTexto-5),AREAC->DESCR) PICT (cPic) COLOR YCORREALCE
      SELECT(cArq)
   ELSE
      @ nLin,nCol SAY SPACE(15)
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Validar Estado Civil         ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TEstCivil(pSit)
   IF !(pSit $ "SCDV")
      tela := SAVESCREEN(2,0,24,79)
      Quadro(14,22,19,40,,YCOREDIT,.T.,,.T.)
      @ 15,24 SAY "S-Solteiro(a)"
      @ 16,24 SAY "C-Casado(a)"
      @ 17,24 SAY "D-Desquitado(a)"
      @ 18,24 SAY "V-Viฃvo(a)"
      Aviso("Estados Civis V lidos : S, C, D ou V",,2)
      RESTSCREEN(2,0,24,79,tela)
      RETURN .F.
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Validar Funo               ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TFunc(pFunc)
   LOCAL cArq:=SELECT()
   IF !EMPTY(pFunc)
      SELECT FUNC
      IF !DBSEEK(pFunc)
         IF Confirma("Funo no Cadastrada! Deseja Cadastrar ?")
            IF NetApp()
               REPLACE _FIELD->DESCR   WITH pFunc,;
                       _FIELD->CODFUNC WITH STRZERO(RECNO(),2)
               UNLOCK
               DBCOMMITALL()
               ProcOk("Gravado")
               SELECT(cArq)
               RETURN .T.
            ENDIF
         ENDIF
         SELECT(cArq)
         RETURN .F.
      ENDIF
      SELECT(cArq)
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Validar Cobrana             ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TCobra(nLin,nCol,wCobra)
   LOCAL cArq1:=SELECT()
   IF !EMPTY(wCobra)
      SELECT COBRANCA
      IF !DBSEEK(wCobra)
         IF Acesso(3)
            IF Confirma("Cobrana no Cadastrada! Deseja Cadastrar ?")
               GetList:={}
               wDescr := SPACE(50)
               Telas(16,2,19,60,c_nBorda,YCOREDIT,.T.,"Incluso de Cobrana")
               @ 17,03 SAY "Cขdigo   :"
               @ 17,16 SAY STRZERO(VAL(wCobra),2)  PICT "99" COLOR YCORREALCE
               @ 18,03 SAY "Descrio:" GET wDescr PICT "@!S40" VALID !EMPTY(wDescr)
               READ
               Rest_Tela()
               IF LASTKEY()#K_ESC
                  IF NetApp()
                     REPLACE _FIELD->CODLOCAL WITH STRZERO(VAL(wCobra),2),;
                             _FIELD->DESCR    WITH wDescr
                     UNLOCK
                     DBCOMMITALL()
                     ProcOk("Gravado")
                     nTamTexto:= 79-nCol
                     @ nLin,nCol   SAY CHR(26)
                     @ nLin,nCol+2 SAY IF(nTamTexto<50,SUBS(DESCR,1,nTamTexto-5),DESCR) COLOR YCORREALCE
                     SELECT(cArq1)
                     EntraDados()
                     RETURN .T.
                  ENDIF
               ENDIF
               EntraDados()
            ENDIF
         ENDIF
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
*ีออออออออออออออออออออออออออออออธ
*ณ Validar Unidade              ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TUnid(wUni,pOper)
   LOCAL cArq:=SELECT()

   IF !EMPTY(wUni)
      SELECT UNIDADE
      IF !DBSEEK(wUni)
         IF Acesso(3)
            IF Confirma("Unidade no Cadastrada! Deseja Cadastrar ?")
               IF NetApp()
                  REPLACE _FIELD->DESCR WITH wUni
                  UNLOCK
                  DBCOMMITALL()
                  ProcOk("Gravado")
                  SELECT(cArq)
                  IF pOper#NIL ; EntraDados(pOper) ; ENDIF
                  RETURN .T.
               ENDIF
               IF pOper#NIL ; EntraDados(pOper) ; ENDIF
            ENDIF
         ENDIF
         SELECT(cArq)
         RETURN .F.
      ENDIF
      SELECT(cArq)
   ENDIF
   RETURN .T.
