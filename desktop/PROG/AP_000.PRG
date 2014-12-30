*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_000                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Menu Principal                           ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 09/08/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
#include "BOX.CH"
#include "FILEIO.CH"
#include "COMMAND.CH"

LOCAL nHandle
PUBLIC cVrs := "2.0", wTime1

// Help
PUBLIC cOphelp1, cOphelp2, cHmsg1 := cHmsg2 := '', nCall := 0

// Miscelania
PUBLIC calc_lin, calc_col, cale_lin, cale_col, corrente, atual, m_date

calc_lin := 2
cale_lin := 1
calc_col := 0
cale_col := -1
corrente := atual := 0.0000
m_date   := DATE()
c_nLado  := c_nBorda := c_wBorda := 1

aBorda   := { "ฺฤฟณูฤภณ", "ีอธณพอิณ", "ึฤทบฝฤำบ", ;
              "ฺฤทบผอิณ", "ษอธณูฤำบ", "ษอปบผอศบ", ;
              "Û฿ÛÞÛÜÛÝ", "ÜÜÜÛÛÜÛÛ", "ษอปบผอศบฑ" }

aCor     := { "N",  "B",   "G",   "BG", "R",  "RB", ;
              "GR", "W",   "N+",  "B+", "G+", "BG+", ;
              "R+", "RB+", "GR+", "W+" }

SETCURSOR(0)
//SETCANCEL(.F.)

Abertura()
cCorant := SETCOLOR()

// Criacao dos Arquivos de Trabalho
lCria := Cria_Arqs()
IF !lCria
   Finalizar()
ENDIF

DBCLOSEALL()
IF NetUse("CLUB.CFG","CLUBCFG","C")
   wDtRenova   := FIELD->DTRENOVA
   wLimite     := FIELD->LIMITE
ENDIF
IF NetUse("APL.CFG","APLCFG")
   wImpressora := FIELD->IMPRESSORA
   wExpandOn   := FIELD->EXPANDON
   wExpandOff  := FIELD->EXPANDOFF
   wCompr_On   := FIELD->COMPR_ON
   wCompr_Off  := FIELD->COMPR_OFF
   wExpand_Med := FIELD->EXPAND_MED
   USE
ENDIF

SETKEY(K_F1,{||Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)})
SETKEY(K_INS,{||SETCURSOR(IF(READINSERT(!Insere()),1,3))})

QuadroGeral("SGC - Verso "+cVrs)
@ 00,50 SAY "<"+SUBS(cUsuario,1,AT(" ",cUsuario)-1)+">" COLOR YCORAVISO
LinhaMsg(1)
WHILE .T.
   SETCOLOR(YCORMENU)
   SETKEY(K_F4,{|| Calculadora(@calc_lin,@calc_col,YCORMENU)})
   SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
   SETKEY(K_LEFT ,NIL)
   SETKEY(K_RIGHT,NIL)

   cOpHelp1 := "0"
   cOpHelp2 := "00"
   cPrg     := "GC000"

   ProgName(cPrg)
   @ 01,07 PROMPT " Cadastro "      MESSAGE Msg("Cadastrar Sขcios/Tabelas")
   @ 01,20 PROMPT " Administrao " MESSAGE Msg("Administrao dos Dados Cadastrados")
   @ 01,36 PROMPT " Relatขrios "    MESSAGE Msg("Listagens Diversas")
   @ 01,52 PROMPT " Utilit rios "   MESSAGE Msg("Rotinas Diversas")
   MENU TO nMenu_1

   IF nMenu_1 == 0
      IF Saida()
         Finalizar()
         RETURN
      ENDIF
   ENDIF

   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   DO CASE
      CASE nMenu_1 == 1
           AP_100()
      CASE nMenu_1 == 2
           AP_200()
      CASE nMenu_1 == 3
           AP_300()
      CASE nMenu_1 == 4
           AP_400()
   ENDCASE
ENDDO
*ีออออออออออออออออออออออออออออออธ
*ณ Finalizao do Sistema       ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Finalizar()
   SETKEY(K_F1,NIL)
   SETKEY(K_F4,NIL)
   SETKEY(K_F5,NIL)
   DBCLOSEALL()
   IF NetUse("USUARIO.SYS","USER")
      SET INDEX TO USUARIO
   ELSE
      DBCLOSEALL()
      RETURN
   ENDIF
   LOCATE FOR USUARIO==cUsuario
   IF FOUND()
      IF NetLReg()
         REPLACE EM_USO WITH .F.
         UNLOCK
      ENDIF
   ENDIF
   RETURN
//   Autor(.F.)         /* Termino Normal */
*ีออออออออออออออออออออออออออออออธ
*ณ Nome do Programa em Execuo ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE ProgName(prg)
   @ 01,00 SAY prg COLOR "W/R"
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Exibe linha Msg p/teclas funcณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION LinhaMsg(modo)
   LOCAL corant := SETCOLOR()

   DEFAULT modo TO 1
   SETCOLOR(YCORMENU)
   @ 24,00 SAY SPACE(80)

   IF modo == 1
      @ 24,00 SAY "   -Saกda      -Help    -Calculadora    -Calendario"
      SETCOLOR(YCORTECLAS)
      @ 24,00 SAY "ESC" 
      @ 24,13 SAY "F1"
      @ 24,22 SAY "F4"
      @ 24,38 SAY "F5"
   ELSEIF modo==2
      @ 24,00 SAY "   -Retorna    -Help    -Calculadora    -Calendario"
      SETCOLOR(YCORTECLAS)
      @ 24,00 SAY "ESC" 
      @ 24,13 SAY "F1"  
      @ 24,22 SAY "F4"
      @ 24,38 SAY "F5"
   ELSEIF modo==3
      @ 24,00 SAY "  -Movimentao     -Alterao     -Finalizao"
      SETCOLOR(YCORTECLAS)
      @ 24,00 SAY ""
      @ 24,17 SAY "ฤู"
      @ 24,32 SAY "ESC"
   ELSEIF modo==4
      @ 24,00 SAY "   -Retorna    -Ajuda     -Altera    -Inclui   -Exclui"
      SETCOLOR(YCORTECLAS)
      @ 24,00 SAY "ESC" 
      @ 24,13 SAY "F2"  
      @ 24,25 SAY "A"
      @ 24,36 SAY "I"
      @ 24,46 SAY "E"
   ELSEIF modo==5
      @ 24,00 SAY "  -Cor da Letra    -Cor do Fundo     -Confirmar     -Abandonar"
*                  0123456789012345678901234567890123456789012345678901234567890123456789
*                            1         2         3         4         5         6
      SETCOLOR(YCORTECLAS)
      @ 24,00 SAY ""
      @ 24,17 SAY CHR(27)+CHR(26)
      @ 24,34 SAY "ฤู"
      @ 24,49 SAY "ESC"
   ELSEIF modo==6
      @ 24,00 SAY "   -Cancela"
      SETCOLOR(YCORTECLAS)
      @ 24,00 SAY "ESC"
   ELSEIF modo==7
      @ 24,00 SAY "   -Retorna    -Ajuda   -Calculadora    -Calendario"
      SETCOLOR(YCORTECLAS)
      @ 24,00 SAY "ESC" 
      @ 24,13 SAY "F2"
      @ 24,22 SAY "F4"
      @ 24,38 SAY "F5"
   ELSEIF modo==8
      @ 24,00 SAY "   -Retorna    -Ajuda     -Altera    -Inclui       -Exclui     -Calendario"
      SETCOLOR(YCORTECLAS)
      @ 24,00 SAY "ESC" 
      @ 24,13 SAY "F2"  
      @ 24,23 SAY "ฤู"
      @ 24,35 SAY "F4"
      @ 24,46 SAY "ALT-E"
      @ 24,61 SAY "F5"
   ELSEIF modo==9
      @ 24,00 SAY "  -Movimentao     -Gravar     -Imprimir      -Abortar"
      SETCOLOR(YCORTECLAS)
      @ 24,00 SAY ""
      @ 24,18 SAY "F2"
      @ 24,30 SAY "F3"
      @ 24,43 SAY "ESC"
   ELSEIF modo==10
      @ 24,00 SAY "   -Retorna    -Help    -Calculadora    -Calendario    -Dependentes"
      SETCOLOR(YCORTECLAS)
      @ 24,00 SAY "ESC" 
      @ 24,13 SAY "F1"  
      @ 24,22 SAY "F4"
      @ 24,38 SAY "F5"
      @ 24,53 SAY "F7"
   ELSEIF modo==15
      @ 24,00 SAY "   -Retorna   -Imprime Relatorio"
      SETCOLOR(YCORTECLAS)
      @ 24,00 SAY "ESC" 
      @ 24,12 SAY "F9"
   ELSEIF modo==16
      @ 24,00 SAY "   -Retorna      -Seleciona    -Imprime Carteirinha"
      SETCOLOR(YCORTECLAS)
      @ 24,00 SAY "ESC" 
      @ 24,12 SAY "ENTER"
      @ 24,29 SAY "F9"
   ENDIF
   SETCOLOR(corant)
   RETURN NIL
*ีออออออออออออออออออออออออออออออออธ
*ณ Mensagem da Linha 23           ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION Linha23(pTexto,pLinha)
   LOCAL lContCor:=.T., nCol:=1, nPosic
   DEFAULT pLinha TO 23

   @ pLinha,00 SAY SPACE(80) COLOR YCORMENU
   nPosic := AT("^",pTexto)
*  pTexto := RIGHT(pTexto,LEN(pTexto)-nPosic)
   WHILE nPosic<>0
      IF (nPosic:=AT("^",pTexto))<>0
         @ pLinha,nCol SAY SUBS(pTexto,1,nPosic-1) COLOR IF(lContCor,YCORMENU,YCORTECLAS)
         lContCor=!lContCor
         pTexto := RIGHT(pTexto,LEN(pTexto)-(nPosic))
         nCol   += nPosic-1
      ENDIF
   ENDDO
   @ pLinha,nCol SAY pTexto COLOR IF(lContCor,YCORMENU,YCORTECLAS)
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Verificar Acesso de Usu rio  ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Acesso(pNivel)
   IF nNivel >= pNivel
      RETURN .T.
   ELSE
      Aviso("Usu rio no Autorizado...",,3)
      RETURN .F.
   ENDIF
