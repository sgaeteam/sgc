*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_341                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Mala Direta por Categoria                ณ
*ณ PROGRAMADOR    :                      - NETCOM            ณ
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
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("GC341"); LinhaMsg(2)
SET KEY -1 TO Mostra()
SETCOLOR(YCOREDIT)
Telas(17,3,20,25,1,YCOREDIT,.T.)
@ 18,05 SAY "Categoria:"
@ 19,05 SAY "Faixa de :   a"
WHILE .T.
   SETCOLOR(YCOREDIT)
   wCat := SPACE(2); wFaixaI:="A"; wFaixaF:="Z"
   Continua:=.T.
   TeclaFuncao(.T.)
   @ 18,16 GET wCat    PICT "!!"  VALID !EMPTY(wCat)
   @ 19,16 GET wFaixaI PICT "!"   VALID LASTKEY()==K_UP.OR.!EMPTY(wFaixaI)
   @ 19,20 GET wFaixaF PICT "!"   VALID LASTKEY()==K_UP.OR.!EMPTY(wFaixaF).AND.wFaixaF>=wFaixaI
   SetCursor(1); READ; TeclaFuncao(); SetCursor(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF
   IF !DBSEEK(wCat+wFaixaI)
      Aviso("Nao ha socios desta categoria iniciado pela letra "+wFaixaI); LOOP
   ELSE
      if Confirma("Imprimir Mala Direta ? ")
         if Confirma("Jato de Tinta ?")
            if TestImp().and.ChkImpr()
               cAviso := MsgImp(.F.)
*               Gera_TXT("AP341.TXT")
               SET DEVI TO PRINT
               SETPRC(0,0)
               Imp_Compri()
               Cab110ET(3,06," ")
               WHILE wCat==CATEGORIA .and. !eof()
                  IF SUBS(NOME,1,1)==wFaixaI.OR.ASC(NOME)<=ASC(wFaixaF)
                     SETPRC(0,0)
                     wNome1  :=NOME;   wEnder1 :=ENDERECO
                     wBairro1:=BAIRRO; wCidade1:=CIDADE
                     wEstado1:=ESTADO; wCep1   :=CEP
                     wNome2 := SPACE(50); wEnder2 := SPACE(50)
                     wBairro2:=SPACE(15); wCidade2:=SPACE(15)
                     wEstado2:="  "; wCep2   :=SPACE(8)
                     DBSKIP()
                     if wCat==CATEGORIA
                        IF SUBS(NOME,1,1)==wFaixaI.OR.ASC(NOME)<=ASC(wFaixaF)
                           wNome2 := NOME; wEnder2 := ENDERECO
                           wBairro2:=BAIRRO; wCidade2:=CIDADE
                           wEstado2:=ESTADO; wCep2   :=CEP
                           DBSKIP()
                        ENDIF
                     ENDIF
                     Cab110ET(1,06,wNome1)
                     Cab110ET(0,66,wNome2)
                     Cab110ET(1,06,wEnder1)
                     Cab110ET(0,66,wEnder2)
                     Cab110ET(1,06,wBairro1)
                     Cab110ET(0,24,wCep1,"[@r 99999-999]")
                     Cab110ET(0,34,wCidade1)
                     Cab110ET(0,52,wEstado1)

                     Cab110ET(0,66,wBairro2)
                     Cab110ET(0,84,wCep2,"[@r 99999-999]")
                     Cab110ET(0,94,wCidade2)
                     Cab110ET(0,112,wEstado2)
                     Cab110ET(3,00,"")
                  ENDIF
                  DBSKIP()
               ENDDO
               Imp_Normal()
               SET DEVI TO SCREEN
*              Fim_TXT()
*              SAVESCREEN(0,0,24,79)
*              RUN nodosimp ap341.txt 80 pre
*              RESTSCREEN(0,0,24,79,0)
*              DELETE FILE AP341.TXT

               TiraMsgImp(cAviso)
               Mensagem("Fim de Impresso! Tecle algo...")
               INKEY(0)
               Mensagem()
            endif
         else
            if TestImp().and.ChkImpr()
               cAviso := MsgImp(.F.)
*               Gera_TXT("AP341.TXT")
               SET DEVI TO PRINT
               SETPRC(0,0)
               Imp_Compri()
               WHILE wCat==CATEGORIA .and. !eof()
                  IF SUBS(NOME,1,1)==wFaixaI.OR.ASC(NOME)<=ASC(wFaixaF)
                     SETPRC(0,0)
                     wNome1  :=NOME;   wEnder1 :=ENDERECO
                     wBairro1:=BAIRRO; wCidade1:=CIDADE
                     wEstado1:=ESTADO; wCep1   :=CEP
                     wNome2 := SPACE(50); wEnder2 := SPACE(50)
                     wBairro2:=SPACE(15); wCidade2:=SPACE(15)
                     wEstado2:="  "; wCep2   :=SPACE(8)
                     DBSKIP()
                     if wCat==CATEGORIA
                        IF SUBS(NOME,1,1)==wFaixaI.OR.ASC(NOME)<=ASC(wFaixaF)
                           wNome2 := NOME; wEnder2 := ENDERECO
                           wBairro2:=BAIRRO; wCidade2:=CIDADE
                           wEstado2:=ESTADO; wCep2   :=CEP
                           DBSKIP()
                        ENDIF
                     endif
                     Cab110ET(1,02,wNome1)
                     Cab110ET(0,65,wNome2)
                     Cab110ET(1,02,wEnder1)
                     Cab110ET(0,65,wEnder2)
                     Cab110ET(1,02,wBairro1)
                     Cab110ET(0,20,wCep1,"[@r 99999-999]")
                     Cab110ET(0,30,wCidade1)
                     Cab110ET(0,48,wEstado1)

                     Cab110ET(0,65,wBairro2)
                     Cab110ET(0,83,wCep2,"[@r 99999-999]")
                     Cab110ET(0,93,wCidade2)
                     Cab110ET(0,111,wEstado2)
                     Cab110ET(3,00,"")
                  ENDIF
                  DBSKIP()
               enddo
               Imp_Normal()
               SET DEVI TO SCREEN
*              Fim_TXT()
*              SAVESCREEN(0,0,24,79)
*              RUN nodosimp ap341.txt 80 pre
*              RESTSCREEN(0,0,24,79,0)
*              DELETE FILE AP341.TXT

               TiraMsgImp(cAviso)
               Mensagem("Fim de Impresso! Tecle algo...")
               INKEY(0)
               Mensagem()
            endif
         endif
      endif
   ENDIF
ENDDO
dbCloseAll()
Rest_Tela()
*ีออออออออออออออออออออออออออออออธ
*ณ Controle Tecla ESC           ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Cab110ET(nProw,nPcol,cTexto,cMascara)
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
   if Confirma("Faz Teste de Impressao").and.chkImpr()
      cAviso := MsgImp(.F.)
      Gera_TXT("TESTE.TXT")
      Imp_Compri()
      while .T.
         Cab110ET(1,02,replicate("*",50))
         Cab110ET(0,65,replicate("*",50))
         cab110ET(0,128,replicate("*",50))

         Cab110ET(1,02,replicate("*",50))
         Cab110ET(0,65,Replicate("*",50))
         Cab110ET(0,128,Replicate("*",50))

         Cab110ET(1,02,replicate("*",15))
         Cab110ET(0,20,"99999-999")
         Cab110ET(0,30,replicate("*",15))
         Cab110ET(0,48,"**")

         Cab110ET(0,65,replicate("*",15))
         Cab110ET(0,83,"99999-999")
         Cab110ET(0,93,replicate("*",15))
         Cab110ET(0,111,"**")

         Cab110ET(3,00,"")

         Fim_TXT()
         SAVESCREEN(0,0,24,79)
         RUN nodosimp teste.txt 80 pre
         RESTSCREEN(0,0,24,79,0)
         DELETE FILE TESTE.TXT

         TiraMsgImp(cAviso)
         if !Confirma("Continua o Teste")
            exit
         end
         Gera_TXT("TESTE.TXT")
         cAviso := MsgImp(.F.)
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
