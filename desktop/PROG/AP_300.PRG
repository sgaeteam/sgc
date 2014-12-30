*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AP_300                           vrs 001 ³
*³ VRS 001        : Desenvolvimento                          ³
*³ FINALIDADE     : Imprimir Relat¢rios do Sistema           ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ³
*³ DATA CRIACAO   : 09/08/1994                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

Telas(2,36,13,53,1,YCORMENU,.T.)
LinhaMsg(2)
WHILE .T.
  SETCURSOR(0)
  SETCOLOR(YCORMENU)
  SETKEY(K_LEFT ,{|| cEsquerda()})
  SETKEY(K_RIGHT,{|| cDireita()})

  cOpHelp1 := "3"
  cOpHelp2 := "00"
  ProgName("GC300")

  @ 03,37 PROMPT " Estratificado " MESSAGE Msg("Ficha Cadastral de S¢cios Estratificado")
  @ 04,37 PROMPT " Maiores de 21  " MESSAGE Msg("Lista de Dependentes maiores que 21 anos de idade")
  @ 05,37 PROMPT " Financeiro    " MESSAGE Msg("Rela‡„o de Pagamentos")
  @ 06,37 PROMPT " Mala Direta   " MESSAGE Msg("Impressao de Etiqueta para Mala Direta")
  @ 07,37 PROMPT " S¢cios        " MESSAGE Msg("Lista de S¢cios")
  @ 08,37 PROMPT " Convidados    " MESSAGE Msg("Lista de Convidados")
  @ 09,37 PROMPT " Aluguel Sal„o  " MESSAGE Msg("Receita de Aluguel do Sal„o de Festas")
  @ 10,37 PROMPT " Convites       " MESSAGE Msg("Lista de Qtde de Convidados no Periodo")
  @ 11,37 PROMPT " Usu rios       " MESSAGE Msg("Lista de Usu rios")
  @ 12,37 PROMPT " Carteiras      " MESSAGE Msg("Emiss„o de Carteiras de Identifica‡„o de S¢cios")
  MENU TO nMenu_3

  SETKEY(K_LEFT,NIL)
  SETKEY(K_RIGHT,NIL)

  IF nMenu_3 = 0
     Rest_Tela()
     LinhaMsg(1)
     RETURN
  ENDIF

  IF nMenu_3 = 1
     Telas(3,53,6,66,1,YCORMENU,.T.)
     LinhaMsg(2)
     WHILE .T.
        SETCOLOR(YCORMENU)
        @ 04,54 PROMPT " Nome      " MESSAGE Msg("Ordem Alfab‚tica")
        @ 05,54 PROMPT " Matr¡cula " MESSAGE Msg("Ordem por Matr¡cula")
        MENU TO nMenu_31

        IF nMenu_31 = 0
           LinhaMsg(1)
           EXIT
        ELSEIF nMenu_31 = 1 .OR. nMenu_31 = 2
           IF Acesso(1); AP_311(nMenu_31); ENDIF
        ENDIF
     ENDDO
     Rest_Tela()
  ELSEIF nMenu_3 = 2
     IF Acesso(1)
        AP_320()
     ENDIF
  ELSEIF nMenu_3 = 3
     Telas(5,53,13,66,1,YCORMENU,.T.)
     LinhaMsg(2)
     WHILE .T.
        SETCOLOR(YCORMENU)
        @ 06,54 PROMPT " S¢cios PG  " MESSAGE Msg("Lista de S¢cios que Pagam")
        @ 07,54 PROMPT " S¢cios NPG " MESSAGE Msg("Lista de S¢cios que N„o Pagam")
        @ 08,54 PROMPT " Ativ.  PG  " MESSAGE Msg("Lista de Usu rios que Pagam")
        @ 09,54 PROMPT " Ativ.  NPG " MESSAGE Msg("Lista de Usu rios que N„o Pagam")
        @ 10,54 PROMPT " Pagamentos " MESSAGE Msg("Lista de Usu rios Pagantes no Mes")
        @ 11,54 PROMPT " Historico S" MESSAGE Msg("Historico de Pagamentos de Socios")
        @ 12,54 PROMPT " Historico U" MESSAGE Msg("Historico de Pagamentos de Usuarios")
        MENU TO nMenu_33

        IF nMenu_33 = 0
           LinhaMsg(1)
           EXIT
        ELSEIF nMenu_33 = 1 .OR. nMenu_33 = 2
           IF Acesso(3); AP_331(nMenu_33); ENDIF
        ELSEIF nMenu_33 = 3 .OR. nMenu_33 = 4 .OR. nMenu_33 = 5
           IF Acesso(3); AP_332(nMenu_33); ENDIF
        ELSEIF nMenu_33 = 6
           IF Acesso(3); AP_333(nMenu_33); ENDIF
        ELSEIF nMenu_33 = 7
           IF Acesso(3); AP_334(nMenu_33); ENDIF
        ENDIF
     ENDDO
     Rest_Tela()
  ELSEIF nMenu_3 = 4
     Telas(06,53,12,65,1,YCORMENU,.T.)
     LinhaMsg(2)
     WHILE .T.
        SETCOLOR(YCORMENU)
        @ 07,54 PROMPT " Categoria " MESSAGE Msg("Gera Etiqueta por Categoria")
        @ 08,54 PROMPT " Unidade   " MESSAGE Msg("Gera Etiqueta por Unidade")
        @ 09,54 PROMPT " Anivers. " MESSAGE Msg("Gera Etiqueta e Carta para Aniversariantes")
        @ 10,54 PROMPT " Fun‡„o   " MESSAGE Msg("Gera Etiqueta de Funcion rios do Clube")
        @ 11,54 PROMPT " Nome     " MESSAGE Msg("Gera Etiqueta Selecionado por Nome")
        MENU TO nMenu_34

        IF nMenu_34 = 0
           LinhaMsg(1)
           EXIT
        ELSEIF nMenu_34 = 1
           IF Acesso(3); AP_341(); ENDIF
        ELSEIF nMenu_34 = 2
           IF Acesso(3); AP_342(); ENDIF
        ELSEIF nMenu_34 = 3
           Telas(09,65,12,76,1,YCORMENU,.T.)
           LinhaMsg(2)
           WHILE .T.
              SETCOLOR(YCORMENU)
              @ 10,66 PROMPT " Etiqueta " MESSAGE Msg("Gera Etiqueta dos Aniversariantes")
              @ 11,66 PROMPT " Carta    " MESSAGE Msg("Gera Carta Padronizada para Aniversariantes")
              MENU TO nMenu_343

              IF nMenu_343 = 0
                 LinhaMsg(1)
                 EXIT
              ELSEIF nMenu_343 = 1
                 IF Acesso(1); AP_343(); ENDIF
              ELSEIF nMenu_343 = 2
                 IF Acesso(1); AP_344(); ENDIF
              ENDIF
           ENDDO
           Rest_Tela()
        ELSEIF nMenu_34 = 4
           Telas(10,65,13,76,1,YCORMENU,.T.)
           LinhaMsg(2)
           WHILE .T.
              SETCOLOR(YCORMENU)
              @ 11,66 PROMPT " Etiqueta " MESSAGE Msg("Gera Etiqueta dos Funcion rios")
              @ 12,66 PROMPT " Carta    " MESSAGE Msg("Gera Carta Padronizada para Funcion rios")
              MENU TO nMenu_344

              IF nMenu_344 = 0
                 LinhaMsg(1)
                 EXIT
              ELSEIF nMenu_344 = 1
                 IF Acesso(1); AP_345(); ENDIF
              ELSEIF nMenu_344 = 2
                 IF Acesso(1); AP_346(); ENDIF
              ENDIF
           ENDDO
           Rest_Tela()
        ELSEIF nMenu_34 = 5
           Telas(11,65,14,76,1,YCORMENU,.T.)
           LinhaMsg(2)
           WHILE .T.
              SETCOLOR(YCORMENU)
              @ 12,66 PROMPT " S¢cios   " MESSAGE Msg("Gera Etiqueta Selecionado dos S¢cios por Nome")
              @ 13,66 PROMPT " Usu rios " MESSAGE Msg("Gera Etiqueta Selecionado dos Usu rios por Nome")
              MENU TO nMenu_345

              IF nMenu_345 = 0
                 LinhaMsg(1)
                 EXIT
              ELSEIF nMenu_345 = 1
                 IF Acesso(1); AP_347(); ENDIF
              ELSEIF nMenu_345 = 2
                 IF Acesso(1); AP_348(); ENDIF
              ENDIF
           ENDDO
           Rest_Tela()
        ENDIF
     ENDDO
     Rest_Tela()
  ELSEIF nMenu_3 = 5
     Telas(07,53,12,67,1,YCORMENU,.T.)
     LinhaMsg(2)
     WHILE .T.
        SETCOLOR(YCORMENU)
        @ 08,54 PROMPT " S¢cio      " MESSAGE Msg("Lista de S¢cio por Nome")
        @ 09,54 PROMPT " S¢cio Port " MESSAGE Msg("Socios Portaria")
        @ 10,54 PROMPT " S¢cio Desat" MESSAGE Msg("Socios Desativados")
        @ 11,54 PROMPT " Assinatura " MESSAGE Msg("Lista de S¢cios para assinatura")
        MENU TO nMenu_36

        IF nMenu_36 = 0
           LinhaMsg(1)
           EXIT
        ELSEIF nMenu_36 = 1
           IF Acesso(1); CLUB3100(); ENDIF
        ELSEIF nMenu_36 = 2
           IF Acesso(1); CLUB3111(); ENDIF
        ELSEIF nMenu_36 = 3
           IF Acesso(1); CLUB31DD(); ENDIF
        ELSEIF nMenu_36 = 4
           IF Acesso(1); CLUB3101(); ENDIF
        ENDIF
     ENDDO
     Rest_Tela()
  ELSEIF nMenu_3 = 6
     Telas(08,53,12,63,1,YCORMENU,.T.)
     LinhaMsg(2)
     WHILE .T.
        SETCOLOR(YCORMENU)
        @ 09,54 PROMPT " Nome    " MESSAGE Msg("Lista de Convidados por Nome")
        @ 10,54 PROMPT " Per¡odo " MESSAGE Msg("Lista de Convidados por Periodo")
        @ 11,54 PROMPT " S¢cio   " MESSAGE Msg("Lista de Convidados por S¢cio no Per¡odo")
        MENU TO nMenu_36

        IF nMenu_36 = 0
           LinhaMsg(1)
           EXIT
        ELSEIF nMenu_36 = 1
           IF Acesso(1); CLUB3200(); ENDIF
        ELSEIF nMenu_36 = 2
           IF Acesso(1); CLUB3300(); ENDIF
        ELSEIF nMenu_36 = 3
           IF Acesso(1); CLUB3310(); ENDIF
        ENDIF
     ENDDO
     Rest_Tela()
  ELSEIF nMenu_3 = 7
     AP_371()
  ELSEIF nMenu_3 = 8
     IF Acesso(1); CLUB3400(); ENDIF
  ELSEIF nMenu_3 = 9
     IF Acesso(1); CLUB3500(); ENDIF
  ELSEIF nMenu_3 = 10
     Telas(12,53,18,69,1,YCORMENU,.T.)
     WHILE .T.
        SETCOLOR(YCORMENU)
        @ 13,54 PROMPT " Carteiras    " MESSAGE Msg("Gerar Carteirinhas")
        @ 14,54 PROMPT " C¢d.Barras(T)" MESSAGE Msg("Gerar C¢digos de Barras Tit.")
        @ 15,54 PROMPT " C¢d.Barras(D)" MESSAGE Msg("Gerar C¢digos de Barras Dep")
        @ 16,54 PROMPT " Barras GT    " MESSAGE Msg("Gerar C¢digos de Barras geral Titular")
        @ 17,54 PROMPT " Barras GD    " MESSAGE Msg("Gerar C¢digos de Barras geral dependentes")
        MENU TO nMenu_22

        IF nMenu_22 = 0
           EXIT
        ELSEIF nMenu_22 = 1
           IF Acesso(3); AP_380(); ENDIF
        ELSEIF nMenu_22 = 2
           IF Acesso(3); AP_381(); ENDIF
        ELSEIF nMenu_22 = 3
           IF Acesso(3); AP_381D(); ENDIF
        ELSEIF nMenu_22 = 4
           IF Acesso(3); AP_381GT(); ENDIF
        ELSEIF nMenu_22 = 5
           IF Acesso(3); AP_381GD(); ENDIF
        ENDIF
     ENDDO
     Rest_Tela()
   ENDIF
ENDDO
