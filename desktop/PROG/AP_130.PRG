*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_130                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Cadastrar Tabelas                        ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 09/08/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

Telas(6,20,13,33,1,YCORMENU,.T.)
LinhaMsg(2)
WHILE .T.
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "1"
   cOpHelp2 := "30"
   cPrg     := "GC130"

   ProgName(cPrg)
   @ 07,21 PROMPT " Categorias " MESSAGE Msg("Cadastrar/Atualizar Tabela de Categorias")
   @ 08,21 PROMPT " Atividades " MESSAGE Msg("Cadastrar/Atualizar Tabela de Atividades")
   @ 09,21 PROMPT " Cobrana   " MESSAGE Msg("Cadastrar/Atualizar Tabela de Cobrana")
   @ 10,21 PROMPT " Fun”es    " MESSAGE Msg("Cadastrar/Atualizar Tabela de Fun”es existentes no Clube")
   @ 11,21 PROMPT " Unidades   " MESSAGE Msg("Cadastrar/Atualizar Tabela de Unidades de Lotao")
   @ 12,21 PROMPT " Areas Comp." MESSAGE Msg("Cadastrar/Atualizar Tabela de Areas de Competncia")
   MENU TO nMenu_3

   IF nMenu_3 = 0
      Rest_Tela()
      LinhaMsg(1)
      RETURN
   ENDIF

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)

   IF nNivel < 5
      Aviso("Usu rio no Autorizado!",,3)
      LOOP
   ENDIF

   IF nMenu_3 = 1
      AP_131()
   ELSEIF nMenu_3 = 2
      AP_132()
   ELSEIF nMenu_3 = 3
      AP_133()
   ELSEIF nMenu_3 = 4
      AP_134()
   ELSEIF nMenu_3 = 5
      AP_135()
   ELSEIF nMenu_3 = 6
      AP_136()
   ENDIF
ENDDO
