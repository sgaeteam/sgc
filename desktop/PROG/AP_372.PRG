*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_372                           vrs 001 ณ
*ณ FINALIDADE     : Imprimir Cadastro Clientes Selecionados  ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 27/08/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PUBLIC continua, pg, xtela := SAVESCREEN(2,0,24,79)

SELECT 1
IF NetUse("CADCLI","CLIENTE")
   SET INDEX TO CADCLIN, CADCLIC
ELSE
   DBCLOSEALL()
   RETURN
ENDIF

IF EOF()
   Aviso("Cadastro de Clientes Vazio!",,3)
   RETURN
ENDIF

Area_Dados()
Telas(19,3,21,22,1,YCOREDIT,.T.)
SET KEY -1 TO Mostra
aSelCod := {}
WHILE .T.
   SET KEY -1 TO Mostra
   SETCURSOR(1)
   SETCOLOR(YCOREDIT)
   Mensagem("Informe o Cขdigo do Cliente")
   wCod := SPACE(4)
   @ 20,05 SAY "Cliente:" GET wCod PICT "9999" WHEN TeclaFuncao(.T.)
   READ

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      IF LEN(aSelCod)>=1
         Rest_Tela()
      ENDIF
      EXIT
   ENDIF

   IF EMPTY(wCod)
      IF LEN(aSelCod) > 0
         Rest_Tela()
         ImpCli()
         aSelCod := {}
         Rest_Tela()
         Telas(19,3,21,32,1,YCOREDIT,.T.)
         LOOP
      ELSE
         EXIT
      ENDIF
   ENDIF

   SET ORDER TO 2
   IF DBSEEK(wCod)
      AADD(aSelCod,CODCLI)
      // Display para acompanhamento de Selecao
      IF LEN(aSelCod)==1
         Telas(7,10,11,70,1,YCOREDIT,.T.)
      ENDIF
      @ 08,12 SAY "Quantidade Selecionada: " + STRZERO(LEN(aSelCod),4)
      @ 09,10 SAY "ร"+REPL("ฤ",59)+"ด"
      @ 10,12 SAY "Empresa:"
      @ 10,21 SAY NOMEC PICT "@!S48" COLOR YCORREALCE
   ELSE
      Aviso("Cliente no Cadastrado! Tecle algo...")
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
      cAviso := MsgImp()
      Gera_TXT("AP372.TXT")
      SETPRC(0,0)
      nQuant   := pg := 0
      continua := .T.
      CabRel110()
      FOR y = 1 TO LEN(aSelCod)
         DBSEEK(aSelCod[y])
         Compr_On()
         Cab110(01,002,"CODIGO  :")
         Cab110(00,012,CODCLI)
         Cab110(00,012,CODCLI)
         Cab110(00,020,"NOME:")
         Cab110(00,026,NOMEC)
         Cab110(00,026,NOMEC)
         Cab110(01,002,REPLI("-",130))
         Cab110(01,002,"ENDERECO:")
         Cab110(00,012,ENDEC)
         Cab110(00,012,ENDEC)
         Cab110(00,055,"CIDADE   :")
         Cab110(00,066,CIDADEC)
         Cab110(00,066,CIDADEC)
         Cab110(00,100,"BAIRRO:")
         Cab110(00,108,BAIRROC)
         Cab110(00,108,BAIRROC)
         Cab110(01,002,"CEP     :")
         Cab110(00,012,CEPC)
         Cab110(00,012,CEPC)
         Cab110(00,055,"ESTADO   :")
         Cab110(00,066,UFC)
         Cab110(00,066,UFC)
         IF !EMPTY(CGCC)
            Cab110(01,002,"C.G.C.  :")
            Cab110(00,012,CGCC,"[@R 99.999.999/9999-99]")
            Cab110(00,012,CGCC,"[@R 99.999.999/9999-99]")
            Cab110(00,055,"INSC.EST.:")
            Cab110(00,066,INSCC)
            Cab110(00,066,INSCC)
         ELSE
            Cab110(01,002,"C.P.F.  :")
            Cab110(00,012,CPF,"[@R 999.999.999-99]")
            Cab110(00,012,CPF,"[@R 999.999.999-99]")
         ENDIF
         Cab110(01,002,"CONTATO :")
         Cab110(00,012,CONTC)
         Cab110(00,012,CONTC)
         Cab110(01,002,"FONE(1) :")
         Cab110(00,012,TEL1C,"[@R (999) 999-9999]")
         Cab110(00,012,TEL1C,"[@R (999) 999-9999]")
         Cab110(00,030,"RAMAL:")
         Cab110(00,037,RAM1C)
         Cab110(00,037,RAM1C)
         Cab110(00,055,"FONE(2)  :")
         Cab110(00,066,TEL2C,"[@R (999) 999-9999]")
         Cab110(00,066,TEL2C,"[@R (999) 999-9999]")
         Cab110(00,084,"RAMAL:")
         Cab110(00,091,RAM2C)
         Cab110(00,091,RAM2C)
         Cab110(00,100,"FAX:")
         Cab110(00,105,FAXC,"[@R (999) 999-9999]")
         Cab110(00,105,FAXC,"[@R (999) 999-9999]")
         Cab110(01,002,REPL("=",130))
         nQuant++
         IF nQuant==7 .AND. !EOF()
            EJECT
            CabRel110()
            nQuant := 0
         ENDIF
      NEXT
      Compr_Off()
      @ 62,00 SAY "* * * Final de Relatorio * * *"
      EJECT
      Fim_TXT()
      SAVESCREEN(0,0,24,79)
      RUN nodosimp ap372.txt 80 pre
      RESTSCREEN(0,0,24,79,0)
      DELETE FILE AP372.TXT

      TiraMsgImp(cAviso)
   ENDIF
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho de Clientes        ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE CabRel110()
   pg++
   Compr_Off()
   @ PROW()+1,002 SAY cUsuario
   @ PROW()  ,070 SAY DATE()
   @ PROW()+1,069 SAY "Pag.:"+STRZERO(pg,4)
   @ PROW()+1,002 SAY "LISTA DE CLIENTES"
   @ PROW()  ,002 SAY "LISTA DE CLIENTES"
   Compr_On()
   @ PROW()+1,002 SAY REPLICATE("_",130)
   RETURN                                                                       
*ีออออออออออออออออออออออออออออออธ
*ณ Cancelamento de Impressao    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE Cab110(nProw,nPcol,cTexto,cMascara)
   IF Continua
      Continua := EscPrint()
      IF Continua
         IF VALTYPE( cMascara ) = "U"
            @ PROW()+nProw,nPcol SAY cTexto
         ELSE
            @ PROW()+nProw,nPcol SAY cTexto PICT &cMascara
         ENDIF
      ENDIF
   ELSE
      GO BOTT
      DBSKIP()
   ENDIF
   RETURN

/*
Montagem do Lay-Out do Relatorio
        1         2         3         4         5         6         7         8         9        10        11        12        13
234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

CODIGO  : 9999    NOME: XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX
---------------------------------------------------------------------------------------------------------------------------------
ENDERECO: XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx   CIDADE   : XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX    BAIRRO: XXXXXXXXXXxxxxxxxxxx
CEP     : 99.999-999                                 ESTADO   : XX
C.G.C.  : 99.999.999/9999-99                         INSC.EST.: XXXXXXXXXX
CONTATO : XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX
FONE(1) : (999) 999-9999    RAMAL: 9999              FONE(2)  : (999) 999-9999    RAMAL: 9999     FAX: (999) 999-9999
=================================================================================================================================
*/
