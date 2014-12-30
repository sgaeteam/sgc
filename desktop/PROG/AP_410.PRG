*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_410                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Configurao do Sistema                  ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 23/01/1994                               ณ
*ณ ATUALIZACAO    : 09/08/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

Telas(7,52,10,65,1,YCORMENU,.T.)
WHILE .T.
   LinhaMsg(2)
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "4"
   cOpHelp2 := "10"

   ProgName("GC410")

   @ 08,53 PROMPT " Cores      " MESSAGE Msg("Configura Cores do Sistema")
   @ 09,53 PROMPT " Impressora " MESSAGE Msg("Configura Impressora em uso")
   MENU TO nMenu_5a

   IF nMenu_5a = 0
      Rest_Tela()
      IF lAlterado ; Area_Dados() ; ENDIF
      Quadro(2,52,8,68,1,YCORMENU,.T.,,.T.)
      RETURN
   ENDIF

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)

   DO CASE
      CASE nMenu_5a = 1
           lAlt_Cor := .F.
           lAlt_Cor := ConfigCores("APL.CFG","GC412")
           IF lAlt_Cor
              lAlterado := .T.
              Area_Menu()
              @ 01,07 SAY " Cadastro "      COLOR YCORMENU
              @ 01,20 SAY " Administrao " COLOR YCORMENU
              @ 01,36 SAY " Relatขrios "    COLOR YCORMENU
              @ 01,52 SAY " Utilit rios "   COLOR YCORMENU
              Area_Dados()
              Quadro(2,52,8,68,1,YCORMENU,.T.,,.T.)
              @ 03,53 SAY " Configura”es " 
              @ 04,53 SAY " Disco         " 
              @ 05,53 SAY " Arquivos      " 
              @ 06,53 SAY " Acesso ao DOS " 
              Quadro(7,52,10,65,1,YCORMENU,,,.T.)
           ENDIF
      CASE nMenu_5a = 2
           telaImp := SAVESCREEN(2,0,22,79)
           Area_Dados()
           ConfigImpr("APL.CFG","GC413")
           RESTSCREEN(2,0,22,79,telaImp)
   ENDCASE
ENDDO
