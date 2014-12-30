*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³PROGRAMA     : AP_200                           vrs 001    ³
*³VRS 001      : Desenvolvimento                             ³
*³FINALIDADE   : Administra‡„o dos Dados Cadastrados         ³
*³PROGRAMADOR  : VITOR A.SMITH FREIRE - NETCOM               ³
*³DATA CRIACAO : 09/08/1994                                  ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"
PUBLIC nLimite

Telas(2,20,7,34,1,YCORMENU,.T.)
LinhaMsg(2)
WHILE .T.
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "2"
   cOpHelp2 := "10"
   ProgName("GC200")

   @ 05,20 SAY "Ã"+REPL("Ä",13)+"´"
   @ 03,21 PROMPT " Pagamentos " MESSAGE Msg("Registrar Pagamentos de Mensalidades")
   @ 04,21 PROMPT " Alugu‚is   " MESSAGE Msg("Alugu‚is de Areas do Clube")
   @ 06,21 PROMPT " Convites   " MESSAGE Msg("Digitar/Emitir Convites")
   MENU TO nMenu_2

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)

   IF nMenu_2 = 0
      RELEASE nLimite
      Rest_Tela()
      LinhaMsg(1)
      RETURN
   ENDIF

   IF nMenu_2 = 1
      Telas(3,34,6,48,1,YCORMENU,.T.)
      tela22 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 04,35 PROMPT " S¢cios     " MESSAGE Msg("Pagamento de S¢cios")
         @ 05,35 PROMPT " Usu rios   " MESSAGE Msg("Pagamento de Usu rios por Atividade")
         MENU TO nMenu_21

         IF nMenu_21 = 0
            LinhaMsg(1)
            EXIT
         ELSEIF nMenu_21 = 1
            Telas(4,48,9,60,1,YCORMENU,.T.)
            tela211 := SAVESCREEN(0,0,24,79)
            LinhaMsg(2)
            WHILE .T.
               SETCOLOR(YCORMENU)
               @ 05,49 PROMPT " Incluir   " MESSAGE Msg("Incluir Pagamento de S¢cio")
               @ 06,49 PROMPT " Alterar   " MESSAGE Msg("Alterar Pagamento de S¢cio")
               @ 07,49 PROMPT " Cancelar  " MESSAGE Msg("Cancelar Pagamento de S¢cio")
               @ 08,49 PROMPT " Consultar " MESSAGE Msg("Consultar Pagamentos de S¢cios")
               MENU TO nMenu_211

               IF nMenu_211 = 0
                  Rest_Tela()
                  LinhaMsg(1)
                  EXIT
               ELSEIF nMenu_211 = 1 .OR. nMenu_211 = 2 .OR. nMenu_211 = 3
                  IF Acesso(IF(nMenu_211=3,5,3))
                     AP_211(nMenu_211)
                  ENDIF
               ELSEIF nMenu_211 = 4
                  IF Acesso(1)
                     AP_213()
                  ENDIF
               ENDIF
               RESTSCREEN(0,0,24,79,tela211)
            ENDDO
         ELSEIF nMenu_21 = 2
            Telas(5,48,10,60,1,YCORMENU,.T.)
            tela211 := SAVESCREEN(0,0,24,79)
            LinhaMsg(2)
            WHILE .T.
               SETCOLOR(YCORMENU)
               @ 06,49 PROMPT " Incluir   " MESSAGE Msg("Incluir Pagamento de Usu rios")
               @ 07,49 PROMPT " Alterar   " MESSAGE Msg("Alterar Pagamento de Usu rios")
               @ 08,49 PROMPT " Cancelar  " MESSAGE Msg("Cancelar Pagamento de Usu rios")
               @ 09,49 PROMPT " Consultar " MESSAGE Msg("Consultar Pagamentos de Usu rios")
               MENU TO nMenu_212

               IF nMenu_212 = 0
                  Rest_Tela()
                  LinhaMsg(1)
                  EXIT
               ELSEIF nMenu_212 = 1 .OR. nMenu_212 = 2 .OR. nMenu_212 = 3
                  IF Acesso(IF(nMenu_212=3,5,3))
                     AP_212(nMenu_212)
                  ENDIF
               ELSEIF nMenu_212 = 4
                  IF Acesso(1)
                     AP_214()
                  ENDIF
               ENDIF
               RESTSCREEN(0,0,24,79,tela211)
            ENDDO
         ENDIF
         RESTSCREEN(0,0,24,79,tela22)
      ENDDO
      Rest_Tela()
   ELSEIF nMenu_2 = 2
      Telas(4,34,6,50,1,YCORMENU,.T.)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 05,35 PROMPT " SalÆo Festas " MESSAGE Msg("Aluguel do SalÆo de Festas")
         MENU TO nMenu_22

         IF nMenu_22 = 0
            LinhaMsg(1)
            EXIT
         ELSEIF nMenu_22 = 1
            Telas(5,50,8,61,1,YCORMENU,.T.)
            tela221 := SAVESCREEN(0,0,24,79)
            LinhaMsg(2)
            WHILE .T.
               SETCOLOR(YCORMENU)
               @ 06,51 PROMPT " Superior " MESSAGE Msg("Aluguel do Sal„o de Festas Superior")
               @ 07,51 PROMPT " Inferior " MESSAGE Msg("Aluguel do Sal„o de Festas Inferior")
               MENU TO nMenu_221

               IF nMenu_221 = 0
                  Rest_Tela()
                  LinhaMsg(1)
                  EXIT
               ELSEIF nMenu_221 = 1 .OR. nMenu_221 = 2
                  AP_221(nMenu_221)
               ENDIF
               RESTSCREEN(0,0,24,79,tela221)
            ENDDO
         ENDIF
      ENDDO
      Rest_Tela()
   ELSEIF nMenu_2 = 3
      Telas(6,34,IF(nNivel=9,10,9),44,1,YCORMENU,.T.)
      tela23 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 07,35 PROMPT " Edita   " MESSAGE Msg("Gerar Convites")
         @ 08,35 PROMPT " Imprime " MESSAGE Msg("Imprimir Convites Previamente Gerados")
         IF nNivel==9
            @ 09,35 PROMPT " Limite  " MESSAGE Msg("Mudan‡a de Limite de Convites por S¢cio")
         ENDIF
         MENU TO nMenu_23

         IF nMenu_23 = 0
            LinhaMsg(1)
            EXIT
         ELSEIF nMenu_23 = 1
            IF Acesso(3)
               CLUB2100()
            ENDIF
         ELSEIF nMenu_23 = 2
            IF Acesso(3)
               CLUB2200()
            ENDIF
         ELSEIF nMenu_23 = 3
            IF MudaLimite()
               SELECT CCONV
               Aguarde("Renovando Convites...")
               DBGOTOP()
               WHILE !EOF()
                  FIELD->QCONMES := nLimite
                  FIELD->QDISP   := nLimite
                  DBSKIP()
               ENDDO
               DBCOMMITALL()
               Aguarde()
            ENDIF
            DBCLOSEALL()
         ENDIF
         RESTSCREEN(0,0,24,79,tela23)
      ENDDO
      Rest_Tela()
   ENDIF
ENDDO
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Testar Mudanca de Mes        ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION MudaLimite()
   LOCAL lFlag := .F.

   SELECT 3
   IF NetUse("SOCIOS")
      SET INDEX TO DBISOCA1
   ELSE
      RETURN .F.
   ENDIF
   SOCIOS->(DBGOTOP())

   SELECT 2
   IF NetUse("CCONV",,"E")
      SET INDEX TO CCONV
   ELSE
      RETURN .F.
   ENDIF

   SELECT 1
   IF !NetUse("CLUB.CFG","CLUBCFG","C")
      RETURN .F.
   ENDIF
   nLimite   := LIMITE
   dDtRenova := DTRENOVA
   Telas(13,18,17,50,1,YCOREDIT,.T.)
   WHILE .T.
      Mensagem("Informe novo limite de convites por S¢cio")
      @ 14,20 SAY "Ult.Atualiza‡Æo: "+DTOC(dDtRenova)
      @ 15,20 SAY "Data Renova‡Æo.: "+DTOC(DATE())
      @ 16,20 SAY "Novo Limite....:" GET nLimite PICT "99" VALID nLimite > 0
      SETCURSOR(1); READ; SETCURSOR(0)
      Mensagem()
      IF LASTKEY()==K_ESC
         EXIT
      ELSE
         IF Confirma("Confirma Novo Limite ? ").AND.NetLReg()
            FIELD->DTRENOVA := DATE(); FIELD->LIMITE := nLimite
            lflag := .T.
            // Verificar inexistencia de socio no cadastro de convites
            Aguarde("Atualizando convites...")
            WHILE !SOCIOS->(EOF())
               xMatr:=SOCIOS->MATRICULA
               IF !CCONV->(DBSEEK(xMatr))
                  WHILE !CCONV->(NetApp()); ENDDO
                  REPLACE CCONV->MATRICULA WITH SOCIOS->MATRICULA
                  CCONV->(DBCOMMIT()); CCONV->(DBUNLOCK())
               ENDIF
               SOCIOS->(DBSKIP())
            ENDDO
            EXIT
         ENDIF
      ENDIF
   ENDDO
   Rest_Tela()
   RETURN(lFlag)
