*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : CORA120L                         vrs 003 ณ
*ณ FINALIDADE     : Imprimir Cadastro de socios              ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE                     ณ
*ณ DATA CRIACAO   : 17/07/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ

#include "INKEY.CH"

PUBLIC continua, pg
corant := SETCOLOR()

SELECT 2
IF NetUse("CATEG")
   SET INDEX TO DBICATE1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2
ELSE
   DelDbfNtx(); RETURN
ENDIF

IF EOF()
   Mensagem("Cadastro de Socios Vazio. Tecle algo...")
   RETURN
ENDIF

SET KEY -1 TO Mostra()

wCat     := SPACE(2)

Telas(15,3,17,59,1,YCOREDIT,.T.)

@ 16,05 SAY "Categoria:" GET wCat       PICT "99"    WHEN TeclaFuncao(.T.) ;
     VALID EMPTY(wCat).OR.PTab(wCat,2,1,"Categoria No Cadastrada")
READ

if lastkey()=27
   Rest_Tela()
   return
Endif
   
ncat := categ->descr

Rest_Tela()

IF ChkImpr()
*  Imprimindo := PoeMsgImp()
   Gera_TXT("CL3111.TXT")
   SETPRC(0,0)
   nQuant   := pg := 0
   continua := .T.
   CabRel110()
   WHILE !EOF() .and. Continua
      IF CATEGORIA==wCat
         Imp_Compri()
         Cab110(01,002,MATRICULA)
         Cab110(00,009,MATR2)
         Cab110(00,018,NOME)
         Cab110(00,060,UNIDADE)
         Cab110(00,070,LOTACAO)
         If wcat = "07"
            Cab110(00,090,substr(obs,30,30))
	 Endif	 
	 DBSKIP()
      Else
        DBSKIP()
        Loop	
      Endif	
      nQuant++
      IF nQuant==54 .AND. !EOF()
         EJECT
         CabRel110()
         nQuant := 0
      ENDIF
   ENDDO
   IF continua
      Imp_Normal()
      @ 62,00 say "* * * Final de Relatorio * * *"
      EJECT
   ENDIF
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp cl3111.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE CL3111.TXT

*  TiraMsgImp(Imprimindo)
ENDIF

/*VTELA:=SAVESCREEN(02,00,24,79)
LinhaMsg2(6)   && Mensagem da linha 24
LinhaMsg(10)   && Mensagem da linha 23
LERTEXTO("RELCORA.TXT")
RESTSCREEN(02,00,24,79,VTELA)
*/
RELEASE continua, pg
SETCOLOR(corant)
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho de Clientes        ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE CabRel110()
   pg++
   Imp_Normal()
   @ PROW()+1,002 SAY "Clube 2004"
   @ PROW()  ,069 SAY DATE()
   @ PROW()+1,068 SAY "Pag.:"+STRZERO(pg,4)
   Imp_Exp()
   @ PROW()+1,020 SAY "LISTA DE SOCIOS"
   Imp_ENor()
   Imp_Compri()
   @ PROW()+1,002 SAY REPLICATE("=",130)
   @ PROW()+1,002 SAY "Matric"
   @ PROW()  ,009 SAY "Mat.Petro"
   @ PROW()  ,025 SAY "Nome"
   @ PROW()  ,060 SAY "Unidade"
   @ PROW()  ,070 SAY "Lotacao"
   @ PROW()  ,090 SAY "Categoria :"+wCat+"-"+substr(ncat,1,20)
   @ PROW()+1,002 SAY REPLICATE("=",130)
   
   RETURN                                                                       
*ีออออออออออออออออออออออออออออออธ
*ณ Cancelamento de Impressao    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE Cab110(nProw,nPcol,cTexto,cMascara)
   IF Continua
      Continua := EscPrint()
      IF Continua
         IF VALTYPE( cMascara ) = "U"
            @ Prow()+nProw,nPcol say cTexto
         ELSE
            @ Prow()+nProw,nPcol say cTexto pict &cMascara
         ENDIF
      ENDIF
   ELSE
      GO BOTT
      dbSkip()
   ENDIF
   RETURN
/*
Montagem do Lay-Out do Relatorio
        1         2         3         4         5         6         7         8         9        10        11        12        13
234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

CODIGO  : 9999    NOME: XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx
---------------------------------------------------------------------------------------------------------------------------------
ENDERECO: XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx   CIDADE   : XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX    BAIRRO: XXXXXXXXXXxxxxxxxxxx
CEP     : 99.999-999                                 ESTADO   : XX
C.G.C.  : 99.999.999/9999-99                         INSC.EST.: XXXXXXXXXX
CONTATO : XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX
FONE(1) : (999) 999-9999    RAMAL: 9999              FONE(2)  : (999) 999-9999    RAMAL: 9999     FAX: (999) 999-9999
=================================================================================================================================
*/
