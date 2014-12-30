*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_420                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Copiar/Recuperar Arquivos do Sistema     ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 04/01/1994                               ณ
*ณ ATUALIZACAO    : 09/08/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

Telas(7,52,10,71,1,YCORMENU,.T.)
WHILE .T.
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "4"
   cOpHelp2 := "20"

   ProgName("AP420")

   @ 08,53 PROMPT " Cขpias Segurana " MESSAGE Msg("Realiza Backup dos Arquivos do Sistema")
   @ 09,53 PROMPT " Restaurao      " MESSAGE Msg("Restaura Cขpia de Segurana")
   MENU TO nMenu_5b

   IF nMenu_5b = 0
      Rest_Tela()
      RETURN
   ENDIF

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)

   IF nNivel < 5
      Aviso("Usu rio no Autorizado!",,3)
      LOOP
   ENDIF

   DO CASE
      CASE nMenu_5b = 1
           AP_421()
      CASE nMenu_5b = 2
           AP_422()
   ENDCASE
ENDDO
