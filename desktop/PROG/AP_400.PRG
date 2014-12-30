*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_400                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Auxiliar o Sistema (Utilit rios)         ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 30/12/1993                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PUBLIC lAlterado := .F.

Telas(2,52,8,68,1,YCORMENU,.T.)
WHILE .T.
   LinhaMsg(2)
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "4"
   cOpHelp2 := "00"

   ProgName("GC400")

   @ 03,53 PROMPT " Configura”es " MESSAGE Msg("Configura”es do Sistema")
   @ 04,53 PROMPT " Disco         " MESSAGE Msg("Copiar/Recuperar Arquivos do Sistema em Disquete")
   @ 05,53 PROMPT " Arquivos      " MESSAGE Msg("Manuteno dos Registros e/ou Arquivos do Sistema")
   @ 06,53 PROMPT " Acesso ao DOS " MESSAGE Msg("Acessar o Sistema Operacional MS-DOS")
   @ 07,53 PROMPT " Dir.Impresso " MESSAGE Msg("Direcionar Saida de Impresso")
   MENU TO nMenu_5

   IF nMenu_5 = 0
      Rest_Tela()
      LinhaMsg(1)
      IF lAlterado ; Area_Dados() ; RELEASE lAlterado ; ENDIF
      RETURN
   ENDIF

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)

   DO CASE
      CASE nMenu_5 = 1
           AP_410()
      CASE nMenu_5 = 2
           AP_420()
      CASE nMenu_5 = 3
           AP_430()
      CASE nMenu_5 = 4
           IF nNivel < 3
              Aviso("Acesso no Permitido!",,3)
           ELSE
              Acess_DOS()
           ENDIF
      CASE nMenu_5 = 5
//           Cap_Imp()
   ENDCASE
ENDDO
*ีออออออออออออออออออออออออออออออธ
*ณ Rotina de Acesso ao DOS      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE Acess_DOS()
   LOCAL tela := SAVESCREEN(00,00,24,79), corant := SETCOLOR(), wDir := CURDIR()
   SETCOLOR("")
   CLS
   SETCOLOR("W+*/N")
   @ 00,15 TO 03,65
   SETCOLOR("")
   @ 01,19 SAY "SGC - Sistema de Gerenciamento do Clube 2004"
   @ 02,22 SAY "Para retornar ao SISTEMA digite EXIT"
   @ 04,00
   SETCURSOR(1)
   ! COMMAND.COM
   CLS
   MudaDir(wDir)
   SETCOLOR(corant)
   RESTSCREEN(00,00,24,79,tela)
   RETURN
