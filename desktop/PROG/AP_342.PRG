*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_342                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Mala Direta por Unidade                  ณ
*ณ PROGRAMADOR    : David Dias           - NETCOM            ณ
*ณ DATA CRIACAO   : 04/10/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
*// Gerar Arquivo Temporario
*aDbf:={}
*AADD(aDbf,{"NOME"       ,"C",   50,0})
*AADD(aDbf,{"MATRICULA"  ,"C",    5,0})
*AADD(aDbf,{"LOTACAO"    ,"C",   25,0})
*AADD(aDbf,{"UNIDADE"    ,"C",    8,0})
*AADD(aDbf,{"FUNCAO"     ,"C",   20,0})
*WHILE .T.
*   sHour:=TIME()
*   cArq1:="TM"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
*   IF !FILE(cArq1+".DBF")
*      DBCREATE(cArq1,aDbf); RELEASE aDbf; EXIT
*   ENDIF
*ENDDO
*SELECT 10
*NetUse(cArq1,,"E")
*INDEX ON NOME TO (cArq1)

SELECT 6
IF NetUse("UNIDADE")
   SET INDEX TO DBIUNID1
ELSE
   DBCLOSEALL(); RETURN
*   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA5
ELSE
   DBCLOSEALL(); RETURN
*   DelDbfNtx(); RETURN
ENDIF

ProgName("GC342"); LinhaMsg(2)
SET KEY -1 TO Mostra()
SETCOLOR(YCOREDIT)
Telas(17,3,20,25,1,YCOREDIT,.T.)
@ 18,05 SAY "Unidade  :"
@ 19,05 SAY "Faixa de :   a"
WHILE .T.
   SETCOLOR(YCOREDIT)
   wUnidade := SPACE(8); wFaixaI:="A"; wFaixaF:="Z"
   Continua:=.T.
   @ 18,16 GET wUnidade PICT "@!"  VALID !EMPTY(wUnidade).AND.Ptab(wUnidade,6,1,"Unidade nao Localizada!")
   @ 19,16 GET wFaixaI  PICT "!"   VALID LASTKEY()==K_UP.OR.!EMPTY(wFaixaI)
   @ 19,20 GET wFaixaF  PICT "!"   VALID LASTKEY()==K_UP.OR.!EMPTY(wFaixaF).AND.wFaixaF>=wFaixaI
   SetCursor(1); READ; TeclaFuncao(); SetCursor(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   IF !DBSEEK(wUnidade+wFaixaI)
      Aviso("Nao ha socios desta unidade iniciado pela letra "+wFaixaI); LOOP
   ELSE
      if Confirma("Imprimir Mala Direta ? ")
         if TestImp().and.ChkImpr()
            cAviso := MsgImp(.F.)
            Gera_TXT("AP342.TXT")
            SETPRC(0,0)
            Imp_Compri()
            while wUnidade==UNIDADE.and.!eof()
               IF SUBS(NOME,1,1)==wFaixaI.OR.ASC(NOME)<=ASC(wFaixaF)
                  wNome2 := space(50); wUnidad2 := sPace(8)
                  wLota2 := space(25); wMatric2 := space(5)
                  wNome1 := NOME;    wUnidad1 := UNIDADE
                  wLota1 := LOTACAO; wMatric1 := MATRICULA
                  DBSKIP()
                  if wUnidade==UNIDADE
                     IF SUBS(NOME,1,1)==wFaixaI.OR.ASC(NOME)<=ASC(wFaixaF)
                        wNome2 := NOME;    wUnidad2 := UNIDADE
                        wLota2 := LOTACAO; wMatric2 := MATRICULA
                        DBSKIP()
                     ENDIF
                  ENDIF
                  CabET2(1,02,wNome1)
                  CabET2(0,65,wNome2)
                  CabET2(1,02,wUnidad1)
                  cabet2(0,12,wLota1)
                  cabet2(0,40,wMatric1)
                  CabET2(0,65,wUnidad2)
                  cabet2(0,75,wLota2)
                  cabet2(0,103,wMatric2)
                  CabET2(4,00,"")
               ENDIF
            enddo
            Imp_Normal()
            SET DEVI TO SCREEN
            TiraMsgImp(cAviso)
            Mensagem("Fim de Impresso! Tecle algo...")
            INKEY(0)
            Mensagem()
         ENDIF
      endif
   endif
ENDDO
Rest_Tela()
DBCLOSEALL(); RETURN
*DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Controle Tecla ESC           ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE CabET2(nProw,nPcol,cTexto,cMascara)
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
*ณ Testar Impressao Etiqueta    ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TestImp()
   if Confirma("Faz Teste de Impressao ?").and.ChkImpr()
      cAviso := MsgImp(.F.)
      Gera_TXT("TESTE.TXT")
      Imp_Compri()
      while .T.
	 CabET2(1,02,replicate("*",50))
	 CabET2(0,65,replicate("*",50))
	 CabET2(0,128,replicate("*",50))

	 CabET2(1,02,replicate("*",08))
	 cabet2(0,12,replicate("*",25))
	 cabet2(0,40,replicate("*",5))
	 CabET2(0,65,Replicate("*",08))
	 cabet2(0,75,replicate("*",25))
	 cabet2(0,103,replicate("*",5))

	 CabET2(4,00,"")
         Fim_TXT()
         SAVESCREEN(0,0,24,79)
         RUN nodosimp teste.txt 80 pre
         RESTSCREEN(0,0,24,79,0)
         DELETE FILE TESTE.TXT
	 TiraMsgImp(cAviso)
	 if !Confirma("Continua o Teste ?")
	    exit
	 end
	 cAviso := MsgImp(.F.)
         Gera_TXT("TESTE.TXT")
      enddo
      Imp_Normal()
      Fim_TXT()
      SAVESCREEN(0,0,24,79)
      RUN nodosimp teste.txt 80 pre
      RESTSCREEN(0,0,24,79,0)
      DELETE FILE TESTE.TXT
      TiraMsgImp(cAviso)
   endif
return .t.
