*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : CLUB3100                         vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Lista de Socios                          ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 11/01/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"NOME"       ,"C",   50,0})
AADD(aDbf,{"MATRICULA"  ,"C",    5,0})
AADD(aDbf,{"ENDERECO"   ,"C",   60,0})
AADD(aDbf,{"BAIRRO"     ,"C",   15,0})
AADD(aDbf,{"CIDADE"     ,"C",   15,0})
AADD(aDbf,{"ESTADO"     ,"C",    2,0})
AADD(aDbf,{"CEP"        ,"C",    8,0})
AADD(aDbf,{"LOTACAO"    ,"C",   25,0})
AADD(aDbf,{"FUNCAO"     ,"C",   20,0})
AADD(aDbf,{"TEL"        ,"C",   10,0})
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

SELECT 6
IF NetUse("UNIDADE")
   SET INDEX TO DBIUNID1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 7
IF NetUse("AREAC")
   SET INDEX TO DBIAREA1
ELSE
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
   SET INDEX TO DBISOCA1,DBISOCA2,DBISOCA3,DBISOCA7,DBISOCA5,DBISOCA8,DBISOCA9
ELSE
   DelDbfNtx(); RETURN
ENDIF

ProgName("GC310")
SET KEY -1 TO Mostra()
Telas(15,3,21,59,1,YCOREDIT,.T.)
WHILE .T.
   SETCOLOR(YCOREDIT)
   wCat     := SPACE(2) ; wFuncao := SPACE(20) ; wLotacao := SPACE(25)
   wUnidade := SPACE(8) ; wDscrArea := SPACE(30) ; wArea := SPACE(2)
   nQtdSoc  := 0 ; lAchou := .F.; wDevice:=" "; wDescr:=SPACE(30)

   Mensagem("Preencha os campos necess rios")
   @ 16,05 SAY "Categoria:" GET wCat       PICT "99"    WHEN TeclaFuncao(.T.) ;
     VALID EMPTY(wCat).OR.PTab(wCat,2,1,"Categoria No Cadastrada")
   @ 17,05 SAY "     Area:" GET wArea      PICT "@!"    WHEN TeclaFuncao(.T.);
     VALID EMPTY(wArea).OR.PTab(wArea,7,1,"Area de Competncia No Cadastrada")
   @ 18,05 SAY "  Lotao:" GET wLotacao   PICT "@!"    WHEN TeclaFuncao()
   @ 19,05 SAY "  Unidade:" GET wUnidade   PICT "@!"    WHEN TeclaFuncao(.T.) ;
     VALID EMPTY(wUnidade).OR.PTab(wUnidade,6,1,"Unidade No Cadastrada")
   @ 20,05 SAY "    Saกda:" GET wDevice    PICT "!" WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      IF LEN(telas)==4; Rest_Tela(); ENDIF
      EXIT
   ENDIF
   IF !EMPTY(wCat); wDescr:=CATEG->DESCR; ENDIF
   
   SELECT SOCIOS; DBSETORDER(1)
   IF wDevice=="I"
      IF !EMPTY(wCat)
         SET ORDER TO 3
         lAchou := DBSEEK(wCat)
      ENDIF
      IF !EMPTY(wArea).AND.!lAchou
         SET ORDER TO 6
         lAchou := DBSEEK(wArea)
         IF !lAchou
            SET ORDER TO 7
            lAchou := DBSEEK(wArea)
         ENDIF
      ENDIF
      IF !EMPTY(wLotacao).AND.!lAchou
         DBGOTOP()
         Aguarde("Selecionando...")
         LOCATE ALL FOR RTRIM(wLotacao) $ LOTACAO
         IF FOUND()
            lAchou := .T.
         ENDIF
         Aguarde()
      ENDIF
      IF !EMPTY(wUnidade).AND.!lAchou
         SET ORDER TO  5
         lAchou := DBSEEK(wUnidade)
      ENDIF
   ELSE
      lAchou:=.T.
   ENDIF

   IF lAchou
      IF wDevice=="I"
         IF ChkImpr()
            IF !EMPTY(wArea);wDscrArea:=AREAC->DESCR;ENDIF
            continua := .T.
            Imprimindo := MsgImp()
            Gera_TXT("CL3100.TXT")
            pg   := 0
            lCab := CabRel("LISTA DE SOCIOS")
            SOCIOS->(DBGOTOP())
            WHILE continua.AND.!EOF()
               lOk := .T.
               IF !lCab; lCab := CabRel("LISTA DE SOCIOS"); ENDIF
               IF EMPTY(wLotacao).AND.!EMPTY(wCat).AND.!EMPTY(wUnidade)
                  IF CATEGORIA==wCat.AND.UNIDADE==wUnidade
                     IF !EMPTY(wArea)
                        IF AREA#wArea.AND.AREA2#wArea
                           lOk := .F.
                        ENDIF
                     ENDIF
                     IF lOk
                        ImpReg()
                        Cab3100(01,007,LOTACAO)
                        Cab3100(00,048,CIDADE)
                        Cab3100(00,066,FUNCAO)
                        Cab3100(00,089,CEP,"[@R XX.XXX-XXX]")
                        Cab3100(00,111,ESTADO)
                        Cab3100(01,000,"")
                        nQtdSoc++
                     ENDIF
                  ENDIF
               ELSEIF EMPTY(wLotacao).AND.EMPTY(wUnidade).AND.!EMPTY(wCat)
                  IF CATEGORIA==wCat
                     IF !EMPTY(wArea)
                        IF AREA#wArea.AND.AREA2#wArea
                           lOk := .F.
                        ENDIF
                     ENDIF
                     IF lOk
                        ImpReg()
                        Cab3100(01,007,LOTACAO)
                        Cab3100(00,035,UNIDADE)
                        Cab3100(00,048,CIDADE)
                        Cab3100(00,066,FUNCAO)
                        Cab3100(00,089,CEP,"[@R XX.XXX-XXX]")
                        Cab3100(00,111,ESTADO)
                        Cab3100(01,000,"")
                        nQtdSoc++
                     ENDIF
                  ENDIF
               ELSEIF EMPTY(wLotacao).AND.EMPTY(wUnidade).AND.EMPTY(wCat)
                  IF !EMPTY(wArea)
                     IF AREA#wArea.AND.AREA2#wArea
                        lOk := .F.
                     ENDIF
                  ENDIF
                  IF lOk
                     ImpReg()
                     Cab3100(01,007,LOTACAO)
                     Cab3100(00,035,UNIDADE)
                     Cab3100(00,048,CIDADE)
                     Cab3100(00,066,FUNCAO)
                     Cab3100(00,089,CEP,"[@R XX.XXX-XXX]")
                     Cab3100(00,111,ESTADO)
                     Cab3100(00,121,CATEGORIA)
                     Cab3100(01,000,"")
                     nQtdSoc++
                  ENDIF
               ELSEIF EMPTY(wCat).AND.!EMPTY(wLotacao).AND.!EMPTY(wUnidade)
                  lOk := .T.
                  IF LOTACAO==wLotacao.AND.UNIDADE==wUnidade
                     IF !EMPTY(wArea)
                        IF AREA#wArea.AND.AREA2#wArea
                           lOk := .F.
                        ENDIF
                     ENDIF
                     IF lOk
                        ImpReg()
                        Cab3100(01,048,CIDADE)
                        Cab3100(00,066,FUNCAO)
                        Cab3100(00,089,CEP,"[@R XX.XXX-XXX]")
                        Cab3100(00,111,ESTADO)
                        Cab3100(00,121,CATEGORIA)
                        Cab3100(01,000,"")
                        nQtdSoc++
                     ENDIF
                  ENDIF
               ELSEIF EMPTY(wCat).AND.EMPTY(wLotacao).AND.!EMPTY(wUnidade)
                  lOk := .T.
                  IF UNIDADE==wUnidade
                     IF !EMPTY(wArea)
                        IF AREA#wArea.AND.AREA2#wArea
                           lOk := .F.
                        ENDIF
                     ENDIF
                     IF lOk
                        ImpReg()
                        Cab3100(01,007,LOTACAO)
                        Cab3100(00,048,CIDADE)
                        Cab3100(00,066,FUNCAO)
                        Cab3100(00,089,CEP,"[@R XX.XXX-XXX]")
                        Cab3100(00,111,ESTADO)
                        Cab3100(00,121,CATEGORIA)
                        Cab3100(01,000,"")
                        nQtdSoc++
                     ENDIF
                  ENDIF
               ELSEIF EMPTY(wCat).AND.EMPTY(wUnidade).AND.!EMPTY(wLotacao)
                  lOk := .T.
                  IF LOTACAO==wLotacao
                     IF !EMPTY(wArea)
                        IF AREA#wArea.AND.AREA2#wArea
                           lOk := .F.
                        ENDIF
                     ENDIF
                     IF lOk
                        ImpReg()
                        Cab3100(01,035,UNIDADE)
                        Cab3100(00,048,CIDADE)
                        Cab3100(00,066,FUNCAO)
                        Cab3100(00,089,CEP,"[@R XX.XXX-XXX]")
                        Cab3100(00,111,ESTADO)
                        Cab3100(00,121,CATEGORIA)
                        Cab3100(01,000,"")
                        nQtdSoc++
                     ENDIF
                  ENDIF
               ENDIF
               DBSKIP()
               IF PROW() > 58
                  EJECT; lCab := .F.
               ENDIF
            ENDDO
            @ PROW()+02,000 SAY "TOTAL SOCIOS => "+STR(nQtdSoc,5)
            IF continua
               @ 62,00 say "** Fim de Relatorio **"
               EJECT
            ENDIF
            Imp_Normal()
            Fim_TXT()
            SAVESCREEN(0,0,24,79)
            RUN nodosimp cl3100.txt 80 pre
            RESTSCREEN(0,0,24,79,0)
            DELETE FILE CL3100.TXT

            TiraMsgImp(Imprimindo)
            Beep(2)
         ENDIF
      ELSE
         /* Impressao em tela */
         lAchou:=.F.; BrowCad()
      ENDIF
   ELSE
      Aviso("No h  sขcios com estas especifica”es",,3)
   ENDIF
ENDDO
SETKEY(K_F2,NIL); Rest_Tela()
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Tecla de Cancelamento        ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Cab3100(nProw,nPcol,cTexto,cMascara)
   IF Continua
      Continua := EscPrint()
      IF (PROW() < 1 .OR. PROW() > 60) .AND. Continua
         pg++
         IF PROW() > 60
            EJECT
         ENDIF
      ENDIF
      IF VALTYPE( cMascara ) = "U"
         @ PROW()+nProw,nPcol SAY cTexto
      ELSE
         @ PROW()+nProw,nPcol SAY cTexto PICT &cMascara
      ENDIF
   ELSE
      Imp_Normal()
      DBGOBOTTOM()
      DBSKIP()
   ENDIF
   RETURN NIL
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse do Cadastro             ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol

   SETCOLOR("W/N")
   Telas(2,0,5,79,1,"W/N",.F.)
   @ 03,02 SAY "Categoria: "+wDescr  PICT "@!S25"
   @ 04,02 SAY "  Unidade: "+wUnidade
*   @ 03,40 SAY "   Area: "+IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
   @ 03,40 SAY "   Area: "+AREAC->DESCR
   @ 04,40 SAY "Lotacao: "+wLotacao

   Telas(6,0,22,79,1,"W/N",.F.)
   oBr:=TBROWSEDB(7,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "

   IF !EMPTY(wCat)
      DBSETORDER(3)
      lAchou := DBSEEK(wCat)
      oBr:gobottomblock = {||goto_bott(wCat)}
      oBr:gotopblock    = {||goto_top(wCat)}
      oBr:skipblock     = {|n| move_pointer(n, wCat, {|n| CATEGORIA})}
   ENDIF
   IF !EMPTY(wArea).AND.!lAchou
      Aguarde("Selecionando...")
      (cArq1)->(__DBZAP())
      SOCIOS->(DBGOTOP())
      WHILE !SOCIOS->(EOF())
         IF AREA==wArea.OR.AREA2==wArea
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->NOME      WITH SOCIOS->NOME      ,;
                    (cArq1)->MATRICULA WITH SOCIOS->MATRICULA ,;
                    (cArq1)->ENDERECO  WITH SOCIOS->ENDERECO  ,;
                    (cArq1)->BAIRRO    WITH SOCIOS->BAIRRO    ,;
                    (cArq1)->CIDADE    WITH SOCIOS->CIDADE    ,;
                    (cArq1)->ESTADO    WITH SOCIOS->ESTADO    ,;
                    (cArq1)->CEP       WITH SOCIOS->CEP       ,;
                    (cArq1)->LOTACAO   WITH SOCIOS->LOTACAO   ,;
                    (cArq1)->FUNCAO    WITH SOCIOS->FUNCAO    ,;
                    (cArq1)->TEL       WITH SOCIOS->TEL
         ENDIF
         SOCIOS->(DBSKIP())
      ENDDO
      Aguarde()
      SELECT (cArq1)
      (cArq1)->(DBGOTOP())
   ENDIF
   IF !EMPTY(wLotacao).AND.!lAchou
      DBGOTOP()
      Aguarde("Selecionando...")
      SET FILTER TO RTRIM(wLotacao) $ LOTACAO
      DBGOTOP()
      IF !EOF(); lAchou := .T.; ENDIF
      Aguarde()
   ENDIF
   IF !EMPTY(wUnidade).AND.!lAchou
      DBSETORDER(5)
      lAchou := DBSEEK(wUnidade)
      oBr:gobottomblock = {||goto_bott(wUnidade)}
      oBr:gotopblock    = {||goto_top(wUnidade)}
      oBr:skipblock     = {|n| move_pointer(n, wUnidade, {|n| UNIDADE})}
   ENDIF


   oCol:=TBCOLUMNNEW("Sขcio",{|| TRANSFORM(NOME,"@!S30")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Matrกcula",{|| MATRICULA})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Endereo",{|| TRANSFORM(ENDERECO,"@!S30") })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Bairro",{|| BAIRRO })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Cidade",{|| CIDADE })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("UF",{|| ESTADO })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("CEP",{|| TRANSFORM(CEP,"@R 99.999-999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Lotao",{|| TRANSFORM(LOTACAO,"@!S20")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Funo",{|| TRANSFORM(FUNCAO,"@!S20")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fone",{|| TRANSFORM(TEL,"@R (999) 999-9999")})
   oBr:addColumn(oCol)

   oBr:Freeze=1
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
  SET FILTER TO
  RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho do Relatorio       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION CabRel(cTitulo)
   pg++
   Imp_Exp()
   @ PROW(),000 SAY "Clube 2004"
   Imp_Enor()
   Imp_Normal()
   @ PROW()+01,000 SAY PADC(cTitulo,80)
   @ PROW()+02,000 SAY "Data: "+DTOC(DATE())
   @ PROW()   ,069 SAY "Pag.:"+STRZERO(pg,3)
   @ PROW()+01,000 SAY "Hora: "+TIME()
   IF EMPTY(wLotacao).AND.!EMPTY(wCat).AND.!EMPTY(wUnidade)
      @ PROW()+01,000 SAY "Categoria: "+wDescr  PICT "@!S25"
      @ PROW()   ,055 SAY "Unidade: "  +wUnidade
      @ PROW()   ,095 SAY "   Area: " +IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
      Imp_Compri()
      @ PROW()+01,000 SAY REPL("-",132)
      @ PROW()+01,000 SAY "MAT.   SOCIO                                    ENDERECO                                 BAIRRO                TEL"
      @ PROW()+01,000 SAY "       LOTACAO                                  CIDADE            FUNCAO                 CEP                   UF"
   ELSEIF EMPTY(wLotacao).AND.EMPTY(wUnidade).AND.!EMPTY(wCat)
      @ PROW()+01,000 SAY "Categoria: "+wDescr  PICT "@!S25"
      @ PROW()   ,055 SAY "     Area: " +IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
      Imp_Compri()
      @ PROW()+01,000 SAY REPL("-",132)
      @ PROW()+01,000 SAY "MAT.   SOCIO                                    ENDERECO                                 BAIRRO                TEL"
      @ PROW()+01,000 SAY "       LOTACAO                     UNIDADE      CIDADE            FUNCAO                 CEP                   UF"
   ELSEIF EMPTY(wLotacao).AND.EMPTY(wUnidade).AND.EMPTY(wCat)
      @ PROW()+01,000 SAY "Area: " +IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
      Imp_Compri()
      @ PROW()+01,000 SAY REPL("-",132)
      @ PROW()+01,000 SAY "MAT.   SOCIO                                    ENDERECO                                 BAIRRO                TEL"
      @ PROW()+01,000 SAY "       LOTACAO                     UNIDADE      CIDADE            FUNCAO                 CEP                   UF    CATEGORIA"
   ELSEIF EMPTY(wCat).AND.!EMPTY(wLotacao).AND.!EMPTY(wUnidade)
      @ PROW()+01,000 SAY "Lotacao: "+wLotacao
      @ PROW()   ,055 SAY "Unidade: "+wUnidade
      @ PROW()   ,095 SAY "   Area: " +IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
      Imp_Compri()
      @ PROW()+01,000 SAY REPL("-",132)
      @ PROW()+01,000 SAY "MAT.   SOCIO                                    ENDERECO                                 BAIRRO                TEL"
      @ PROW()+01,000 SAY "                                                CIDADE            FUNCAO                 CEP                   UF    CATEGORIA"
   ELSEIF EMPTY(wCat).AND.EMPTY(wLotacao).AND.!EMPTY(wUnidade)
      @ PROW()+01,000 SAY "Unidade: "+wUnidade
      @ PROW()   ,055 SAY "   Area: " +IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
      Imp_Compri()
      @ PROW()+01,000 SAY REPL("-",132)
      @ PROW()+01,000 SAY "MAT.   SOCIO                                    ENDERECO                                 BAIRRO                TEL"
      @ PROW()+01,000 SAY "       LOTACAO                                  CIDADE            FUNCAO                 CEP                   UF    CATEGORIA"
   ELSEIF EMPTY(wCat).AND.EMPTY(wUnidade).AND.!EMPTY(wLotacao)
      @ PROW()+01,000 SAY "Lotacao: "+wLotacao
      @ PROW()   ,055 SAY "   Area: " +IF(EMPTY(wDscrArea),"",wDscrArea) PICT "@!"
      Imp_Compri()
      @ PROW()+01,000 SAY REPL("-",132)
      @ PROW()+01,000 SAY "MAT.   SOCIO                                    ENDERECO                                 BAIRRO                TEL"
      @ PROW()+01,000 SAY "                                   UNIDADE      CIDADE            FUNCAO                 CEP                   UF    CATEGORIA"
   ENDIF
*                          99999  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx XXXXXXXXXXxxxxxxxxxx  (999) 999-9999
*                                 XXXXXXXXXXxxxxxxxxxxXXXXX   XXXXXXXX     XXXXXXXXXXxxxxx   XXXXXXXXXXxxxxxxxxxx   99.999-999            XX       99         XX        99
*                          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                                    1         2         3         4         5         6         7         8         9        10        11         12       13
   @ PROW()+01,000 SAY REPL("-",132)
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Registro            ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE ImpReg()
  Cab3100(01,000,MATRICULA)
  Cab3100(00,007,NOME,"[@S40]")
  Cab3100(00,048,ENDERECO,"[@S40]")
  Cab3100(00,089,BAIRRO)
  Cab3100(00,111,TEL,"[@R (999) 999-9999]")
  RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Pesquisar Ponteiro do Browse   ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION Goto_Top(searcher)
   DBSEEK(searcher)
   RETURN NIL
*ีออออออออออออออออออออออออออออออออธ
*ณ Encontrar registro mais prox.  ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION Goto_Bott(searcher)
   LOCAL save_soft
   save_soft = SET(_SET_SOFTSEEK, .T.)
   SEEK SUBSTR(searcher, 1, LEN(searcher) - 1) + ;
        CHR(ASC(SUBSTR(searcher, LEN(searcher))) + 1)
   SKIP -1
   SET(_SET_SOFTSEEK, save_soft)
   RETURN NIL
*ีออออออออออออออออออออออออออออออออธ
*ณ Controla ponteiro no Browse    ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION Move_Pointer(num_to_skip,SEARCHER,d_key_cb)
   LOCAL num_skipped := 0

   IF EOF()
   ELSEIF num_to_skip = 0
      SKIP 0
   ELSE
      WHILE !EOF() .AND. !BOF() .AND. num_skipped != num_to_skip ;
                   .AND. EVAL(d_key_cb) = searcher
         IF num_to_skip > 0
            SKIP
            num_skipped++
         ELSE
            SKIP -1
            num_skipped--
         ENDIF
      ENDDO

      IF eof()
         SKIP -1
         num_skipped--
      ELSEIF bof()
         num_skipped++
         SKIP
         SKIP -1
      ELSEIF EVAL(d_key_cb) != searcher
         IF num_to_skip > 0
            SKIP -1
            num_skipped--
         ELSE
            SKIP
            num_skipped++
         ENDIF
      ENDIF
   ENDIF
   RETURN num_skipped
*ีออออออออออออออออออออออออออออออออธ
*ณ Processar Tecla do Browse      ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION ProcKey (oBr,nKey)
   STATIC aKey:= { K_DOWN,       { |oBr| oBr:down() } ,;
                   K_UP,         { |oBr| oBr:up() } ,;
                   K_PGDN,       { |oBr| oBr:pageDown() } ,;
                   K_PGUP,       { |oBr| oBr:pageUp() } ,;
                   K_CTRL_PGUP,  { |oBr| oBr:goTop() } ,;    
                   K_CTRL_PGDN,  { |oBr| oBr:goBottom() } ,;
                   K_RIGHT,      { |oBr| oBr:right() } ,;
                   K_LEFT,       { |oBr| oBr:left() } ,;
                   K_HOME,       { |oBr| oBr:home() } ,;
                   K_END,        { |oBr| oBr:end() } ,;
                   K_CTRL_LEFT,  { |oBr| oBr:panLeft() } ,;
                   K_CTRL_RIGHT, { |oBr| oBr:panRight() } ,;
                   K_CTRL_HOME,  { |oBr| oBr:panHome() } ,;
                   K_CTRL_END,   { |oBr| oBr:panEnd() } }
   LOCAL nI

   nI:=ASCAN(aKey,nKey)
   IF nI!=0
        EVAL(aKey[++nI],oBr)
   ENDIF
   RETURN NIL
