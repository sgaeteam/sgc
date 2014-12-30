*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_100                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Menu de Cadastro                         ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 09/08/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LinhaMsg(2)
WHILE .T.
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "1"
   cOpHelp2 := "00"
   cPrg     := "GC100"

   Telas(2,7,9,20,1,YCORMENU,.T.)
   @ 05,07 SAY "ร"+REPL("ฤ",12)+"ด"
   @ 07,07 SAY "ร"+REPL("ฤ",12)+"ด"

   ProgName(cPrg)
   @ 03,8 PROMPT " Sขcios    " MESSAGE Msg("Cadastrar/Atualizar Associados")
   @ 04,8 PROMPT " Usu rios  " MESSAGE Msg("Cadastrar/Atualizar Usu rios das Atividades")
   @ 06,8 PROMPT " Tabelas   " MESSAGE Msg("Cadastrar/Atualizar Tabelas")
   @ 08,8 PROMPT " Senhas    " MESSAGE Msg("Cadastrar/Atualizar Senhas de Acesso")
   MENU TO nMenu_1

   IF nMenu_1 = 0
      Rest_Tela(); LinhaMsg(1); EXIT
   ENDIF

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)

   IF nMenu_1 = 1
      Telas(3,20,9,34,1,YCORMENU,.T.)
      tela11 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 06,20 SAY "ร"+REPL("ฤ",13)+"ด"
         @ 04,21 PROMPT " Titular    " MESSAGE Msg("Cadastramento de Sขcio Titular")
         @ 05,21 PROMPT " Dependente " MESSAGE Msg("Cadastramento de Sขcio Dependente")
         @ 07,21 PROMPT " Desativar   " MESSAGE Msg("Desativar Sขcios e seus Dependentes")
         @ 08,21 PROMPT " Reativar    " MESSAGE Msg("Reativar Sขcios e seus Dependentes")
         MENU TO nMenu_11

         IF nMenu_11 = 0
            LinhaMsg(1)
            EXIT
         ELSEIF nMenu_11 = 1
            Telas(4,34,9,47,1,YCORMENU,.T.)
            tela111 := SAVESCREEN(0,0,24,79)
            LinhaMsg(2)
            WHILE .T.
               SETCOLOR(YCORMENU)
               @ 05,35 PROMPT " Incluir    " MESSAGE Msg("Incluir Novo Sขcio Titular")
               @ 06,35 PROMPT " Alterar    " MESSAGE Msg("Alterar Sขcio Titular")
               @ 07,35 PROMPT " Consultar " MESSAGE Msg("Consultar Sขcio Titular Ativo")
               @ 08,35 PROMPT " Dependente " MESSAGE Msg("Consultar Dependentes")
               MENU TO nMenu_111

               IF nMenu_111 = 0
                  Rest_Tela(); LinhaMsg(1); EXIT
               ELSEIF nMenu_111 = 1 .OR. nMenu_111 = 2
                  IF Acesso(IF(nMenu_111=3,1,3))
                     AP_111(nMenu_111)
                  ENDIF
               ELSEIF nMenu_111 = 3
                  Telas(7,47,10,59,1,YCORMENU,.T.)
                  tela113 := SAVESCREEN(0,0,24,79)
                  WHILE .T.
                     SETCOLOR(YCORMENU)
                     @ 08,48 PROMPT " Nome      " MESSAGE Msg("Consulta por Nome")
                     @ 09,48 PROMPT " Matrกcula " MESSAGE Msg("Consulta por Matrกcula")
                     MENU TO nMenu_113

                     IF nMenu_113 = 0
                        EXIT
                     ELSEIF nMenu_113 = 1
                        IF Acesso(1); AP_11A(); ENDIF
                     ELSEIF nMenu_113 = 2
                        IF Acesso(1); AP_11D(); ENDIF
                     ENDIF
                     RESTSCREEN(0,0,24,79,tela113)
                  ENDDO
                  Rest_Tela()

               ELSEIF nMenu_111 = 4
                  IF Acesso(1); AP_11C(); ENDIF
               ENDIF
               RESTSCREEN(0,0,24,79,tela111)
            ENDDO
         ELSEIF nMenu_11 = 2
            Telas(5,34,10,46,1,YCORMENU,.T.)
            tela112 := SAVESCREEN(0,0,24,79)
            LinhaMsg(2)
            WHILE .T.
               SETCOLOR(YCORMENU)
               @ 06,35 PROMPT " Incluir   " MESSAGE Msg("Incluir Novo Dependente")
               @ 07,35 PROMPT " Alterar   " MESSAGE Msg("Alterar Dados do Dependente")
               @ 08,35 PROMPT " Excluir   " MESSAGE Msg("Excluir Dependente")
               @ 09,35 PROMPT " Consultar " MESSAGE Msg("Consultar Dependente")
               MENU TO nMenu_112

               IF nMenu_112 = 0
                  Rest_Tela()
                  LinhaMsg(1)
                  EXIT
               ELSEIF nMenu_112 = 1 .OR. nMenu_112 = 2 .OR. nMenu_112 = 3 .OR. nMenu_112 = 4
                  IF Acesso(IF(nMenu_112=4,1,IF(nMenu_112=3,5,3)))
                     AP_112(nMenu_112)
                  ENDIF
               ENDIF
               RESTSCREEN(0,0,24,79,tela112)
            ENDDO
         ELSEIF nMenu_11 = 3
            IF Acesso(5)
               AP_113()
            ENDIF
         ELSEIF nMenu_11 = 4
            IF Acesso(5)
               AP_114()
            ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela11)
      ENDDO
      Rest_Tela()
   ELSEIF nMenu_1 = 2
      Telas(4,20,9,32,1,YCORMENU,.T.)
      tela22 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 05,21 PROMPT " Incluir   " MESSAGE Msg("Incluir Novo Usu rio")
         @ 06,21 PROMPT " Alterar   " MESSAGE Msg("Alterar/Incluir/Excluir Atividades de Usu rios Cadastrados")
         @ 07,21 PROMPT " Excluir   " MESSAGE Msg("Excluir Usu rios Cadastrados e suas Atividades")
         @ 08,21 PROMPT " Consultar " MESSAGE Msg("Consultar Usu rios Cadastrados")
         MENU TO nMenu_22

         IF nMenu_22 = 0
            LinhaMsg(1)
            Rest_Tela()
            EXIT
         ELSE
            IF Acesso(IF(nMenu_22=4,1,IF(nMenu_22=3,5,3)))
               AP_120(nMenu_22)
            ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela22)
      ENDDO
   ELSEIF nMenu_1 = 3
      IF Acesso(9)
         AP_130()
      ENDIF
   ELSEIF nMenu_1 = 4
      AP_150()
   ENDIF
   Rest_Tela()
ENDDO
