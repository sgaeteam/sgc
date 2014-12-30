*--ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : CLUB3101                         vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Lista de Socios para assinatura          ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 11/06/1999                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

SELECT 6
IF NetUse("UNIDADE")
   SET INDEX TO DBIUNID1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 5
IF NetUse("PGSOC")
   SET INDEX TO DBIPGSO1
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
   SET INDEX TO DBISOCA3,DBISOCA5,DBISOCA2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SET KEY -1 TO Mostra()
Telas(15,3,19,59,1,YCOREDIT,.T.)
WHILE .T.
   SETCOLOR(YCOREDIT)
   wCat   := SPACE(2) ; wUnidade := SPACE(8); wLimite := CTOD("  /  /  ")
   lAchou := .F.; wDevice:="I"; wDescr:=SPACE(30)
   Mensagem("Preencha os campos necess rios")
   @ 16,05 SAY "Categoria:" GET wCat       PICT "99"    WHEN TeclaFuncao(.T.) ;
     VALID EMPTY(wCat).OR.PTab(wCat,2,1,"Categoria No Cadastrada")
   @ 17,05 SAY "  Unidade:" GET wUnidade   PICT "@!"    WHEN TeclaFuncao(.T.) ;
     VALID EMPTY(wUnidade).OR.PTab(wUnidade,6,1,"Unidade No Cadastrada")
   @ 18,05 SAY "Dt.Limite:" GET wLimite    PICT "@D"    WHEN TeclaFuncao() VALID !EMPTY(wLimite)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      IF LEN(Telas)==4; Rest_Tela(); ENDIF
      Rest_Tela(); EXIT
   ENDIF
   IF !EMPTY(wCat); wDescr:=CATEG->DESCR; ENDIF
   
   lAchou := .T.
   SELECT SOCIOS
   IF wDevice=="I"
      IF !EMPTY(wCat)
         DBSETORDER(1)
         lAchou := DBSEEK(wCat)
      ENDIF
      IF !EMPTY(wUnidade)
         DBSETORDER(2)
         lAchou := DBSEEK(wUnidade)
      ENDIF
   ENDIF
   SOCIOS->(DBSETORDER(3))

   IF lAchou
      IF wDevice=="I"
         IF ChkImpr()
            continua := .T.
            Imprimindo := MsgImp()
            Gera_TXT("CL3101.TXT")
            pg   := nQtdSoc := 0
            lCab := CabRel("SOCIOS ADIDOS ATE: "+DTOC(wLimite))
            WHILE continua.AND.!EOF()
               lOk := .T.
               IF !lCab; lCab := CabRel("SOCIOS ADIDOS ATE: "+DTOC(wLimite)); ENDIF
               IF NaoDevedor(wLimite,SOCIOS->MATRICULA,SOCIOS->DTADESAO,SOCIOS->CATEGORIA)
                  IF SOCIOS->DTADESAO <= wLimite
                     IF !EMPTY(wCat).AND.!EMPTY(wUnidade)
                        IF CATEGORIA==wCat.AND.UNIDADE==wUnidade
                           IF lOk
                              Imp_Compri()
                              Cab3101(1,05,++nQtdSoc,"[@E 99999]")
                              Cab3101(0,13,NOME)
                              Cab3101(0,68,DTADESAO)
                              Cab3101(0,82,REPL("_",45))
                              Cab3101(1,00,"")
                           ENDIF
                        ENDIF
                     ELSEIF EMPTY(wUnidade).AND.!EMPTY(wCat)
                        IF CATEGORIA==wCat
                           Imp_Compri()
                           Cab3101(1,05,++nQtdSoc,"[@E 99999]")
                           Cab3101(0,13,NOME)
                           Cab3101(0,68,DTADESAO)
                           Cab3101(0,82,REPL("_",45))
                           Cab3101(1,00,"")
                        ENDIF
                     ELSEIF EMPTY(wCat).AND.!EMPTY(wUnidade)
                        lOk := .T.
                        IF UNIDADE==wUnidade
                           IF lOk
                              Imp_Compri()
                              Cab3101(1,05,++nQtdSoc,"[@E 99999]")
                              Cab3101(0,13,NOME)
                              Cab3101(0,68,DTADESAO)
                              Cab3101(0,82,REPL("_",45))
                              Cab3101(1,00,"")
                           ENDIF
                        ENDIF
                     ELSEIF EMPTY(wCat).AND.EMPTY(wUnidade)
                        IF lOk
                           Imp_Compri()
                           Cab3101(1,05,++nQtdSoc,"[@E 99999]")
                           Cab3101(0,13,NOME)
                           Cab3101(0,68,DTADESAO)
                           Cab3101(0,82,REPL("_",45))
                           Cab3101(1,00,"")
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
               DBSKIP()
               IF PROW() >= 57
                  EJECT; lCab := .F.
               ENDIF
            ENDDO
            IF continua
               @ PROW()+2,08 SAY "** Fim de Relatorio **"; EJECT
            ENDIF
            Imp_Normal()
            Fim_TXT()
            SAVESCREEN(0,0,24,79)
            RUN nodosimp cl3101.txt 80 pre
            RESTSCREEN(0,0,24,79,0)
            DELETE FILE CL3101.TXT

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
SETKEY(K_F2,NIL)
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Tecla de Cancelamento        ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE Cab3101(nProw,nPcol,cTexto,cMascara)
   IF Continua
      Continua := EscPrint()
      IF (PROW() < 1 .OR. PROW() > 60) .AND. Continua
         pg++
         IF PROW() > 60; EJECT; ENDIF
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

   Telas(6,0,22,79,1,"W/N",.F.)
   oBr:=TBROWSEDB(7,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "

   IF !EMPTY(wCat)
      DBSETORDER(1)
      lAchou := DBSEEK(wCat)
      oBr:gobottomblock = {||goto_bott(wCat)}
      oBr:gotopblock    = {||goto_top(wCat)}
      oBr:skipblock     = {|n| move_pointer(n, wCat, {|n| CATEGORIA})}
   ENDIF
   IF !EMPTY(wUnidade)
      DBSETORDER(2)
      lAchou := DBSEEK(wUnidade)
      oBr:gobottomblock = {||goto_bott(wUnidade)}
      oBr:gotopblock    = {||goto_top(wUnidade)}
      oBr:skipblock     = {|n| move_pointer(n, wUnidade, {|n| UNIDADE})}
   ENDIF

   oCol:=TBCOLUMNNEW("Sขcio"    ,{|| TRANSFORM(NOME,"@!S30")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Matrกcula",{|| MATRICULA})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Endereo" ,{|| TRANSFORM(ENDERECO,"@!S30") })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Bairro"   ,{|| BAIRRO })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Cidade"   ,{|| CIDADE })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("CEP"      ,{|| TRANSFORM(CEP,"@R 99.999-999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Unidade"  ,{|| UNIDADE})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Lotao"  ,{|| TRANSFORM(LOTACAO,"@!S20")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Funo"   ,{|| TRANSFORM(FUNCAO,"@!S20")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fone"     ,{|| TRANSFORM(TEL,"@R (999) 999-9999")})
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
  SETCOLOR(corant); Rest_Tela(2)
  SET FILTER TO
  RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho do Relatorio       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION CabRel(cTitulo)
   pg++
   Imp_Normal()
   Imp_Exp()
   @ PROW()+1,005 SAY "Clube 2004"
   Imp_Enor()
   Imp_Normal()
   @ PROW()+01,005 SAY "Data: "+DTOC(DATE())
   @ PROW()   ,069 SAY "Pag.:"+STRZERO(pg,3)
   @ PROW()+01,000 SAY "Hora: "+TIME()
   @ PROW()+03,000 SAY PADC(cTitulo,80)
   IF !EMPTY(wCat).AND.!EMPTY(wUnidade)
      @ PROW()+02,005 SAY "Categoria: "+wDescr  //PICT "@!S25"
      @ PROW()   ,055 SAY "Unidade: "  +wUnidade
   ELSEIF EMPTY(wUnidade).AND.!EMPTY(wCat)
      @ PROW()+02,005 SAY "Categoria: "+wDescr  //PICT "@!S25"
   ELSEIF EMPTY(wCat).AND.!EMPTY(wUnidade)
      @ PROW()+02,005 SAY "Unidade: "+wUnidade
   ENDIF
   Imp_Compri()
   @ PROW()+01,005 SAY REPL("ฤ",125)
   @ PROW()+01,005 SAY "  Nง    NOME DO SOCIO                                          DT ADESAO                    ASSINATURA"
*                       99999   XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX     99/99/9999    _____________________________________________
*                       56789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                            1         2         3         4         5         6         7         8         9        10        11         12       13
   @ PROW()+01,005 SAY REPL("ฤ",125)
   @ PROW()+01,000 SAY ""
   RETURN .T.

*ีออออออออออออออออออออออออออออออธ
*ณ Verificar se Socio  Devedor ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION NaoDevedor(dLimite, wMatr, ddtAdesao,wCat)
    lOk := .T. 
    IF wCat $ "02_09" //Socios que Pagam
       wdtAdesao := DTOC(ddtAdesao)
       wAnoMes := STRZERO(YEAR(ddtAdesao),4)+SUBSTR(wdtAdesao,4,2)
       nAno := VAL(LEFT(wAnoMes,4))
       nMes := VAL(RIGHT(wAnoMes,2))
       WHILE !CTOD("01/"+StrZero(nMes,2)+"/"+StrZero(nAno,4))>=dLimite
           lOk:=PGSOC->(DBSEEK( wMatr + wAnoMes ))
           IF !lOk; EXIT; ENDIF
           IF nMes = 12; nAno++; nMes := 0; ENDIF
           nMes++
           wAnoMes := StrZero(nAno,4)+StrZero(nMes,2)
       ENDDO
    ENDIF
    RETURN lOk    
