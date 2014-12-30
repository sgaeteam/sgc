*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_347                           vrs 001 ณ
*ณ FINALIDADE     : Gerar Etiqueta Selecionada de Socios     ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 20/01/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PUBLIC continua, pg, xtela := SAVESCREEN(2,0,24,79)

DBCLOSEALL()
SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

IF EOF()
   Aviso("Cadastro de Sขcios Vazio!",,3)
   RETURN
ENDIF

Area_Dados(); ProgName("GC347")
nTelas:=LEN(Telas)
aSelCod := {}
Telas(18,3,21,65,1,YCOREDIT,.T.)
SET KEY -1 TO Mostra()
WHILE .T.
   SETCURSOR(1)
   SETCOLOR(YCOREDIT)
   Mensagem("Informe o Nome do Sขcio")
   wNomeSoc := SPACE(50); wLocal := "R"
   @ 19,05 SAY "Local:" GET wLocal   PICT "!"  WHEN HTela(4).AND.TeclaFuncao();
     VALID EMPTY(wLocal).OR.VTela(4)
   @ 20,05 SAY "Sขcio:" GET wNomeSoc PICT "@!" WHEN !EMPTY(wLocal).AND.TeclaFuncao(.T.)
   READ

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      pTelas:=LEN(Telas)-1
      FOR p=nTelas TO pTelas
          Rest_Tela()
      NEXT
      EXIT
   ENDIF

   IF EMPTY(wNomeSoc)
      IF LEN(aSelCod) > 0
         ImpCli()
         IF Confirma("Impresso Ok ? ")
            aSelCod := {}
            Rest_Tela()
         ENDIF
         LOOP
      ELSE
         EXIT
      ENDIF
   ENDIF

   IF DBSEEK(wNomeSoc)
      AADD(aSelCod,{NOME,wLocal})
      // Display para acompanhamento de Selecao
      IF LEN(aSelCod)==1
         Telas(7,10,11,70,1,YCOREDIT,.T.)
      ENDIF
      @ 08,12 SAY "Quantidade Selecionada: " + STRZERO(LEN(aSelCod),4)
      @ 09,10 SAY "ร"+REPL("ฤ",59)+"ด"
      @ 10,12 SAY "Sขcio:"
      @ 10,19 SAY NOME PICT "@!S50" COLOR YCORREALCE
   ELSE
      Aviso("Sขcio no Localizado! Tecle algo...")
   ENDIF
ENDDO
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
      continua:= .T.
      cAviso  := MsgImp()
      Gera_TXT("AP347.TXT")
      SETPRC(0,0)
      FOR y = 1 TO LEN(aSelCod)
         DBSEEK(aSelCod[y][1])
         Compr_On()
         wNome1 := aSelCod[y][1]
         wNome2 := SPACE(50); wNome3 := SPACE(50)
         wEnd1  := IF(aSelCod[y][2]=="R",ENDERECO,LOTACAO)
         wEnd2  := SPACE(60); wEnd3  := SPACE(60)
         IF aSelCod[y][2]=="R"
            wBair1 := BAIRRO
            wCity1 := CIDADE
            wUf1   := ESTADO
            wCep1  := CEP
         ELSE
            wBair1 := MATR2;    wCity1 := UNIDADE
            wUf1   := SPACE(2); wCep1  := SPACE(8)
         ENDIF
         wBair2 := wBair3 := SPACE(15)
         wCity2 := wCity3 := SPACE(15)
         wUf2   := wUf3   := SPACE(2)
         wCep2  := wCep3  := SPACE(8)
         IF (wCont:=(LEN(aSelCod) - y)) > 0
            y++
            DBSEEK(aSelCod[y][1])
            wNome2 := aSelCod[y][1]
            wEnd2  := IF(aSelCod[y][2]=="R",ENDERECO,LOTACAO)
            IF aSelCod[y][2]=="R"
               wBair2 := BAIRRO; wCity2 := CIDADE
               wUf2   := ESTADO; wCep2  := CEP
            ELSE
               wBair2 := MATR2; wCity2 := UNIDADE
            ENDIF
            IF wCont > 1
               y++
               DBSEEK(aSelCod[y][1])
               wNome3 := aSelCod[y][1]
               wEnd3  := IF(aSelCod[y][2]=="R",ENDERECO,LOTACAO)
               IF aSelCod[y][2]=="R"
                  wBair3 := BAIRRO; wCity3 := CIDADE
                  wUf3   := ESTADO; wCep3  := CEP
               ELSE
                  wBair3 := MATR2; wCity3 := UNIDADE
               ENDIF
            ENDIF
         ENDIF
         Cab110ET(1,002,wNome1)
         Cab110ET(0,065,wNome2)
         Cab110ET(0,128,wNome3)

         Cab110ET(1,002,wEnd1)
         Cab110ET(0,065,wEnd2)
         Cab110ET(0,128,wEnd3)

         Cab110ET(1,02,wBair1)
         Cab110ET(0,20,wCep1,"[@R 99999-999]")
         Cab110ET(0,30,wCity1)
         Cab110ET(0,48,wUf1)
         Cab110ET(0,65,wBair2)
         Cab110ET(0,83,wCep2,"[@R 99999-999]")
         Cab110ET(0,93,wCity2)
         Cab110ET(0,111,wUf2)
         Cab110ET(0,128,wBair3)
         Cab110ET(0,146,wCep3,"[@R 99999-999]")
         Cab110ET(0,156,wCity3)
         Cab110ET(0,174,wUf3)
         @ PROW()+3,000 SAY ""
      NEXT
      Imp_Normal()
      Compr_Off()
      EJECT
      Fim_TXT()
      SAVESCREEN(0,0,24,79)
      RUN nodosimp ap347.txt 80 pre
      RESTSCREEN(0,0,24,79,0)
      DELETE FILE AP347.TXT

      TiraMsgImp(cAviso)
   ENDIF
   RETURN NIL
