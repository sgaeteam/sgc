*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_341                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Mala Direta por Categoria                ณ
*ณ PROGRAMADOR    : Wilson Campos        - NETCOM            ณ
*ณ DATA CRIACAO   : 04/10/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
SELECT 2

IF NetUse("CATEG")
   SET INDEX TO DBICATE1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA3
  * reindex
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("GC341"); LinhaMsg(2)

SET KEY -1 TO Mostra()
Telas(18,3,20,19,1,YCOREDIT,.T.)
@ 19,05 SAY "Categoria:"

SETCOLOR(YCOREDIT)
WHILE .T.
   wCat := SPACE(2)
   Continua:=.T.
   TeclaFuncao(.T.)
   @ 19,16 get wCat pict[!!] VALID empty(wCat).or.PTAB(wCat,2,1,"Categoria No Encontrada")
   SetCursor(1); READ; SetCursor(0)
   TeclaFuncao()
   
   IF EMPTY(wCat); EXIT; ENDIF
    
   SELECT 1
   DBSEEK(wCat)
    
   if TestImp().and.ChkImpr()
      cAviso := MsgImp(.F.)

      Gera_TXT("AP341E.TXT"); SETPRC(0,0)

      while wCat==CATEGORIA .and. !eof()

         wNome1 := NOME     ; wNome2 := SPACE(50) 
         wEnd1  := ENDERECO ; wEnd2  := SPACE(50) 
         wBair1 := BAIRRO   ; wBair2 := SPACE(20) 
         wCid1  := CIDADE   ; wCid2  := SPACE(30) 
         wUf1   := ESTADO   ; wUf2   := SPACE(02) 
         wCep1  := CEP      ; wCep2  := SPACE(08) 
         wLota1 := LOTACAO  ; wLota2 := SPACE(25) 
         wMatric1:= MATRICULA; wMatric2:=SPACE(5) 
         wUnidad1:=UNIDADE  ; wUnidad2:= SPACE(8) 
         DBSKIP()
         
         if wCat==CATEGORIA
	    wNome2 := NOME
            wEnd2  := ENDERECO ; wBair2 := BAIRRO
            wCid2  := CIDADE   ; wUf2   := ESTADO
            wCep2  := CEP      ; wLota2 := LOTACAO
            wMatric2:= MATRICULA; wUnidad2:=UNIDADE
            DBSKIP()

         endif

         Compr_On()
         Cab_ESC(0,003,wNome1)
         Cab_ESC(0,061,wNome2)
         Cab_ESC(1,002,wEnd1)
         Cab_ESC(0,060,wEnd2)
         Cab_ESC(1,002,wBair1)
         Cab_ESC(0,060,wBair2)
         Cab_ESC(1,002,wCid1)
         Cab_ESC(0,042,wUf1)
         Cab_ESC(0,045,wCep1,"[@R 99999-999]")
         Cab_ESC(0,060,wCid2)
         Cab_ESC(0,104,wUf2)
         Cab_ESC(0,107,wCep2,"[@R 99999-999]")
         
	 /*Cab_ESC(1,002,wUnidad1)
         Cab_ESC(0,012,wLota1)
         Cab_ESC(0,040,wMatric1)
         Cab_ESC(0,080,wUnidad2)
         Cab_ESC(0,090,wLota2)
         Cab_ESC(0,131,wMatric2)
         Cab_ESC(0,153,wUnidad3)
         Cab_ESC(0,168,wLota3)
         Cab_ESC(0,196,wMatric3)*/
         Cab_ESC(3,00,"")
	 
         DBSKIP()
      enddo
      Imp_Normal()
      SET DEVI TO SCREEN
      TiraMsgImp(cAviso)
      WaitMsg("Fim de Impresso! Tecle algo...")
   endif
   SETCOLOR(YCOREDIT)
ENDDO
Rest_Tela()
dbCloseAll(); RETURN


*ีออออออออออออออออออออออออออออออธ
*ณ Controle Tecla ESC           ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Cab_ESC(nProw,nPcol,cTexto,cMascara)
   IF continua .AND. (continua := EscPrint())
      IF VALTYPE( cMascara ) = "U"
         @ PROW()+nProw,nPcol SAY cTexto
      ELSE
         @ PROW()+nProw,nPcol SAY cTexto PICT &cMascara.
      ENDIF
   ELSE
      DBGOBOTTOM()
      DBSKIP()
   ENDIF
   RETURN

*ีออออออออออออออออออออออออออออออธ
*ณ Teste de Impressao           ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TestImp()
   IF Confirma("Faz Teste de Impresso ?").AND.ChkImpr()
      cAviso := MsgImp(.F.)
      Gera_TXT("TESTE.TXT")
      Compr_On()
      WHILE .T.
         Cab_ESC(1,002,REPL("*",50))
         Cab_ESC(0,065,REPL("*",50))
         Cab_ESC(0,121,REPL("*",50))
         Cab_ESC(1,002,REPL("*",50))
         Cab_ESC(0,065,REPL("*",50))
         Cab_ESC(0,121,REPL("*",50))
         Cab_ESC(1,002,REPL("*",20))
         Cab_ESC(0,065,REPL("*",20))
         Cab_ESC(0,121,REPL("*",20))
         Cab_ESC(1,002,REPL("*",30))
         Cab_ESC(0,065,REPL("*",30))
         Cab_ESC(0,121,REPL("*",30))
         Cab_ESC(5,00,"")
         Fim_TXT()
         SAVESCREEN(0,0,24,79)
         RUN nodosimp teste.txt 80 pre
         RESTSCREEN(0,0,24,79,0)
         DELETE FILE TESTE.TXT

         TiraMsgImp(cAviso)
         IF !Confirma("Continua o Teste ?"); EXIT; ENDIF
         cAviso := MsgImp(.F.)
         Gera_TXT("TESTE.TXT")
      ENDDO
      Compr_Off()
      Fim_TXT()
      SAVESCREEN(0,0,24,79)
      RUN nodosimp teste.txt 80 pre
      RESTSCREEN(0,0,24,79,0)
      DELETE FILE TESTE.TXT

      TiraMsgImp(cAviso)
   ENDIF
   RETURN .T.
