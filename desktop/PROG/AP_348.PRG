*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_348                           vrs 001 ณ
*ณ FINALIDADE     : Gerar Etiqueta Selecionada de Usuarios   ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 20/01/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PUBLIC continua, pg, xtela := SAVESCREEN(2,0,24,79)

SELECT 3
IF NetUse("USUARIOS")
   SET INDEX TO DBIUSU1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

IF EOF()
   Aviso("Cadastro de Usu rios Vazio!",,3)
   RETURN
ENDIF

Area_Dados(); ProgName("GC348")
Telas(19,3,21,65,1,YCOREDIT,.T.)
SET KEY -1 TO Mostra()
aSelCod := {}
WHILE .T.
   SETCURSOR(1)
   SETCOLOR(YCOREDIT)
   Mensagem("Informe o Nome do Usu rio")
   wNomeUsu := SPACE(50)
   @ 20,05 SAY "Usu rio:" GET wNomeUsu PICT "@!" WHEN TeclaFuncao(.T.)
   READ

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      IF LEN(aSelCod)>=1
         Rest_Tela()
      ENDIF
      EXIT
   ENDIF

   IF EMPTY(wNomeUsu)
      IF LEN(aSelCod) > 0
         Rest_Tela()
         ImpCli()
         aSelCod := {}
         Rest_Tela()
         Telas(19,3,21,65,1,YCOREDIT,.T.)
         LOOP
      ELSE
         EXIT
      ENDIF
   ENDIF

   IF DBSEEK(wNomeUsu)
      AADD(aSelCod,{NOME,ENDERECO})
      // Display para acompanhamento de Selecao
      IF LEN(aSelCod)==1
         Telas(7,10,11,70,1,YCOREDIT,.T.)
      ENDIF
      @ 08,12 SAY "Quantidade Selecionada: " + STRZERO(LEN(aSelCod),4)
      @ 09,10 SAY "ร"+REPL("ฤ",59)+"ด"
      @ 10,12 SAY "Usu rio:"
      @ 10,21 SAY NOME PICT "@!S48" COLOR YCORREALCE
   ELSE
      Aviso("Sขcio no Localizado! Tecle algo...")
   ENDIF
ENDDO
Rest_Tela()
SETCURSOR(0)
SETKEY(K_F2,NIL)
RELEASE continua, pg
DBCLOSEALL()
RESTSCREEN(2,0,24,79,xtela)
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Impresso Regs. Selecionados ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpCli()
   IF ChkImpr()
      continua := .T.
      cAviso   := MsgImp()
      Gera_TXT("AP348.TXT")
      SETPRC(0,0)
      FOR y = 1 TO LEN(aSelCod)
         DBSEEK(aSelCod[y][1])
         Compr_On()
         wNome1 := aSelCod[y][1]
         wNome2 := SPACE(50) ; wNome3 := SPACE(50)
         wEnd1  := aSelCod[y][2]
         wEnd2  := SPACE(60) ; wEnd3  := SPACE(60)
         wBair1 := BAIRRO; wBair2 := wBair3 := SPACE(15)
         wCity1 := CIDADE; wCity2 := wCity3 := SPACE(15)
         IF (wCont:=(LEN(aSelCod) - y)) > 0
            y++
            DBSEEK(aSelCod[y][1])
            wNome2 := aSelCod[y][1]
            wEnd2  := aSelCod[y][2]
            wBair2 := BAIRRO; wCity2 := CIDADE
            IF wCont > 1
               y++
               DBSEEK(aSelCod[y][1])
               wNome3 := aSelCod[y][1]
               wEnd3  := aSelCod[y][2]
               wBair3 := BAIRRO; wCity3 := CIDADE
            ENDIF
         ENDIF
         Cab110ET(1,002,wNome1)
         Cab110ET(0,065,wNome2)
         Cab110ET(0,128,wNome3)

         Cab110ET(1,002,wEnd1)
         Cab110ET(0,065,wEnd2)
         Cab110ET(0,128,wEnd3)

         Cab110ET(1,02,wBair1)
         Cab110ET(0,30,wCity1)
         Cab110ET(0,65,wBair2)
         Cab110ET(0,93,wCity2)
         Cab110ET(0,128,wBair3)
         Cab110ET(0,156,wCity3)
         @ PROW()+3,000 SAY ""
      NEXT
      Imp_Normal()
      Compr_Off()
      EJECT
      Fim_TXT()
      SAVESCREEN(0,0,24,79)
      RUN nodosimp ap348.txt 80 pre
      RESTSCREEN(0,0,24,79,0)
      DELETE FILE AP348.TXT

      TiraMsgImp(cAviso)
   ENDIF
   RETURN NIL
