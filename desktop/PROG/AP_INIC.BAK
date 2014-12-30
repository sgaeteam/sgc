*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_INIC                          vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Tela de Apresentacao Logotipo e Senha    ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 09/08/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL s := m := n := 0, col := 9

!NetLogo

// Impressora
PUBLIC wExpandOn, wExpandOff, wCompr_On, wCompr_Off, wExpand_Med, wImpressora, pg

// Cores
PUBLIC YCORGERAL,YCORAVISO,YCOREDIT,YCORMENU,YCORREALCE,YCORBARRA,YCORTECLAS

// Usuario
PUBLIC lTm, cTempo := TIME(), cChave, cUsuario, nNivel, cPrg := ""; cDtSys:=DATE()

SETCURSOR(0)
cCorAnt := SETCOLOR()
CLS

a7  = "         ฿฿฿฿฿฿฿฿฿฿\        ฿฿฿฿฿฿฿฿฿\        ฿฿฿฿฿฿฿฿฿\  (tm)"
a8  = "      ฿฿฿฿฿฿฿฿฿฿฿฿฿฿\    ฿฿฿฿฿฿฿฿฿฿฿฿฿\     ฿฿฿฿฿฿฿฿฿฿฿฿฿\"
a9  = "    ฿฿฿฿฿฿\            ฿฿฿฿฿\     ฿฿฿฿\   ฿฿฿฿฿\     ฿฿฿฿\"
a10 = "    ฿฿฿฿฿\            ฿฿฿฿฿\             ฿฿฿฿฿\"
a11 = "     ฿฿฿฿฿฿฿฿฿฿฿฿\   ฿฿฿฿฿\             ฿฿฿฿฿\"
a12 = "             ฿฿฿฿฿\  ฿฿฿฿฿\    ฿฿฿฿฿\   ฿฿฿฿฿\"
a13 = "  ฿฿฿฿\      ฿฿฿฿฿\  ฿฿฿฿฿\     ฿฿฿฿\   ฿฿฿฿฿฿\    ฿฿฿฿\"
a14 = "   ฿฿฿฿฿฿฿฿฿฿฿฿฿฿\    ฿฿฿฿฿฿฿฿฿฿฿฿฿\     ฿฿฿฿฿฿฿฿฿฿฿฿฿\"
a15 = "     ฿฿฿฿฿฿฿฿฿฿\        ฿฿฿฿฿฿฿฿฿\         ฿฿฿฿฿฿฿฿฿\"

linha = 15
SETCOLOR("G/N")
@ 01,00 TO 18,79 DOUBLE
@ 18,00 TO 24,79 DOUBLE
@ 18,00 SAY CHR(204)
@ 18,79 SAY CHR(185)

SETCOLOR("N/W")
@ 02,12 SAY "        SISTEMA DE GERENCIAMENTO DO CLUBE 2004        "
SETCOLOR("B+")

WHILE .T.
   linha     = LTRIM(STR(linha))
   titulo    = a&linha.
   linha     = VAL(linha)
   linha_aux = 7
   WHILE linha > linha_aux
      @ linha_aux-1,1 SAY SPACE(78)
      @ linha_aux,col SAY titulo
      INKEY(0.05)
      linha_aux++
   ENDDO
   @ linha-1,1 SAY SPACE(78)

   DO CASE
      CASE linha >= 7 .AND. linha <= 9
           SETCOLOR("W+")
      CASE linha > 9 .AND. linha <= 12
           SETCOLOR("GR+")
      CASE linha > 12
           SETCOLOR("B+")
   ENDCASE
   @ linha,col SAY titulo
   linha--
   IF linha < 7
      EXIT
   ENDIF
ENDDO

SETCOLOR(cCorAnt)
@ 19,01,23,78 BOX "ฑฑฑฑฑฑฑฑฑ"
SETCOLOR("W/W")
JanelaExp(19,13,23,61,"        ",.T.)
SETCOLOR("N/W")
@ 19,15 SAY "Vitor Freire - Consultoria e Inform tica       "
@ 20,15 SAY "e-mail: vitor.freire1@gmail.com                "
@ 21,15 SAY "Fones: (71) 9106-5520 8721-7040 3378-7008      "

GeraConfig()          /* Gerar/Ler Arquivos de Configurao do Sistema */
GeraSys()             /* Gerar Arquivos de Controle do Sistema */
IF NetUse("USUARIO.SYS","USER")
   SET INDEX TO USUARIO
ELSE
   DBCLOSEALL()
   Autor(.F.)         /* Termino Anormal */
ENDIF

lTm   := .F.
nCont := 1
WHILE .T.
   SETCOLOR("N/W")
   @ 23,15 SAY "Chave :"
   @ 23,38 SAY "Senha :"

   SETCURSOR(1)
   WHILE .T.
      SETCOLOR("N/W")
      cChave := cSenha := ""
      @ 23,24 SAY "["+SPACE(4)+"]"
      @ 23,47 SAY "["+SPACE(6)+"]"

      cChave := Test_Entry(23,25,4,cChave,"CH")
      IF DBSEEK(cChave)
         IF !EMPTY(cChave)
            lAchou_Chave := .T.
         ELSE
            lAchou_Chave := .F.
         ENDIF
      ELSE
         lAchou_Chave := .F.
      ENDIF

      SETCOLOR(",N/N")
      cSenha := Test_Entry(23,48,6,cSenha,"PW","N/W")
      IF LASTKEY() # K_TAB
         IF USER->SENHA == Codifica(cSenha)
            IF !EMPTY(cSenha)
               lAchou_Senha := .T.
            ELSE
               lAchou_Senha := .F.
            ENDIF
         ELSE
            lAchou_Senha := .F.
         ENDIF
         EXIT
      ELSE
         SETPOS(23,25)
      ENDIF
   ENDDO
   SETCURSOR(0)
   IF LASTKEY() # K_ESC
      IF nCont > 3
         Beep(3)
         SETCOLOR("W+/R")
         ImplodBox()
         ExplodBox(19,1,23,78)
         SETCOLOR("W+/R*")
         Centro(21,"Sem Autorizao. Acesso Negado !!!",2,78)
         INKEY(3)
         SETCOLOR(cCorAnt)
         CLS
         QOUT("SGC.EXE Copyright 1994. Virtual System - Verso 1.0")
         QOUT("Rua Chile, Ed.Braulio Xavier,Centro Fone 321-9111")
         QOUT("")
         SETCURSOR(1)
         QUIT
      ENDIF
      IF (!lAchou_Chave .AND. lAchou_Senha)  .OR. ;
         (lAchou_Chave  .AND. !lAchou_Senha) .OR. ;
         (!lAchou_Chave .AND. !lAchou_Senha)
         SAVE SCREEN
         Beep(3)
         SETCOLOR("W+/R")
         ImplodBox()
         ExplodBox(19,1,23,78)
         @ 21,25 SAY "Usu rio no Cadastrado..." COLOR "W+/R*"
         INKEY(2)
         SETCOLOR(cCorAnt)
         RESTORE SCREEN
      ELSEIF lAchou_Chave .AND. lAchou_Senha
         IF USER->EM_USO
            SAVE SCREEN
            Beep(3)
            SETCOLOR("W+/R")
            ImplodBox()
            ExplodBox(19,1,23,78)
            @ 21,25 SAY "Usu rio j  Ativo..." COLOR "W+/R*"
            INKEY(2)
            SETCOLOR(cCorAnt)
            RESTORE SCREEN
         ELSE
            telainic:=SAVESCREEN(0,0,24,79)
            SELECT USER
            cUsuario := USUARIO
            nNivel   := NIVEL
            IF NetLReg()
*              REPLACE EM_USO WITH .T.
            ENDIF
            AP_000()   /* Programa Principal */
            nCont  := 1
            RESTSCREEN(0,0,24,79,telainic)
         ENDIF
      ENDIF
   ELSE
      Autor(lTm)
   ENDIF
   nCont++
ENDDO
*ีออออออออออออออออออออออออออออออธ
*ณ Teste Entrada de Chave/Senha ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Test_Entry(lin,col,nDigitos,Password,cTeste,cor)
   LOCAL nContador := 1
   SETPOS(lin,col)
   WHILE nContador <= nDigitos .AND. LASTKEY() # 27
      tecla = 0
      WHILE tecla = 0 .AND. tecla # K_ESC
        tecla := INKEY()
      ENDDO
      IF LASTKEY() # K_ESC
         TONE(30,.01)
         IF cTeste == "PW"
            @ lin,col SAY 'þ' COLOR cor
         ELSE
            @ lin,col SAY UPPER(CHR(tecla)) COLOR "N/W"
         ENDIF
         col++
      ENDIF
      IF LASTKEY() == K_BS .AND. cPrg # "AP151" .AND. cPrg # "AP152"
         IF cTeste == "CH"
            col := 25
         ELSE
            col := 48
         ENDIF
         nContador := 0
         Password  := ""
         @ lin,col SAY SPACE(nDigitos) COLOR "N/W"
         SETPOS(lin,col)
      ELSEIF LASTKEY() == K_ENTER .OR. LASTKEY() == K_TAB
         EXIT
      ELSE
         Password += UPPER(CHR(tecla))
      ENDIF
      nContador++
   ENDDO
   RETURN(Password)
