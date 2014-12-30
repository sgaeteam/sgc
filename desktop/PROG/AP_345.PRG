*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_345                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Etiqueta de Funcionarios                 ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 13/12/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PUBLIC continua := .T., nPg := 0

DBCLOSEALL()
SELECT 7
IF NetUse("AREAC")
   SET INDEX TO DBIAREA1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("FUNC")
   SET INDEX TO DBIFUNC1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF !NetUse("DBPARM")
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA7,DBISOCA8,DBISOCA9
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("GC345")
SET KEY -1 TO Mostra()
Telas(16,03,20,70,1,YCOREDIT,.T.)
WHILE .T.
   SETCURSOR(1)
   SETCOLOR(YCOREDIT)
   wFuncao := SPACE(20) ; wMsgFunc := DBPARM->MSGFUNC ; wArea := SPACE(2) ; lAchou := .F.
   @ 17,05 SAY "    Area:" GET wArea    PICT "@!"    WHEN TeclaFuncao(.T.)
   @ 18,05 SAY "  Funo:" GET wFuncao  PICT "@!"    WHEN TeclaFuncao(.T.)
   @ 19,05 SAY "Mensagem:" GET wMsgFunc PICT "@!S50" WHEN TeclaFuncao()
   READ
   TeclaFuncao()
   IF LASTKEY()==K_ESC ; EXIT ; ENDIF

   wModo:=0
   SELECT SOCIOS
   IF (!EMPTY(wArea).AND.EMPTY(wFuncao)).OR.(!EMPTY(wArea).AND.!EMPTY(wFuncao))
      SET ORDER TO 2
      IF DBSEEK(wArea)
         lAchou := .T.
      ELSE
         SET ORDER TO 3
         IF DBSEEK(wArea)
            lAchou := .T.
         ENDIF
      ENDIF
      IF !EMPTY(wArea).AND.!EMPTY(wFuncao)
         lCond := "AREA==wArea.AND.ALLTRIM(FUNCAO)==ALLTRIM(wFuncao).AND.!EOF()"
      ELSE
         wModo := 1
         lCond := "!EOF()"
      ENDIF
   ELSEIF EMPTY(wArea).AND.!EMPTY(wFuncao)
      SET ORDER TO 1
      IF DBSEEK(wFuncao)
         lAchou := .T.
      ENDIF
      lCond := "ALLTRIM(FUNCAO)==ALLTRIM(wFuncao).AND.!EOF()"
   ELSEIF EMPTY(wArea).AND.EMPTY(wFuncao)
      EXIT
   ENDIF

   IF lAchou
      IF Confirma("Imprimir Mala Direta ? ")
         IF ChkImpr()
            cAviso := MsgImp()
            Imp345(wModo)
            TiraMsgImp(cAviso)
            Beep(2)
            Mensagem("Fim de Impresso! Tecle algo...")
            INKEY(0)
            Mensagem()
            SELECT DBPARM
            IF NetLReg()
               FIELD->MSGFUNC := wMsgFunc
            ENDIF
         ENDIF
      ENDIF
   ELSE
      Aviso("No existem funcionarios com estas especifica”es",,3)
   ENDIF
ENDDO
Rest_Tela()
SETKEY(K_F2,NIL)
SETCURSOR(0)
RELEASE continua, nPg
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Mala Direta         ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Imp345(pMod)
   Gera_TXT("AP345.TXT")
   SETPRC(0,0)
   Imp_Compri()
   WHILE (&lCond.).AND.continua
      IF &lCond.
         IF pMod==1
            SET ORDER TO 2
            DBSEEK(wArea)
            WHILE AREA==wArea.AND.!EOF()
               wNome1 := NOME     ; wNome2 := SPACE(50)
               wFunc1 := FUNCAO   ; wFunc2 := SPACE(20)
               wBair1 := BAIRRO   ; wBair2 := SPACE(15)
               wEnd1  := ENDERECO ; wEnd2  := SPACE(50)
               wMsg1  := wMsgFunc ; wMsg2  := SPACE(50)
               DBSKIP()
               IF AREA==wArea
                  wNome2 := NOME
                  wFunc2 := FUNCAO
                  wEnd2  := ENDERECO
                  wBair2 := BAIRRO
                  wMsg2  := wMsgFunc
                  DBSKIP()
               ENDIF
               Cab110ET(0,002,wNome1)
               Cab110ET(0,065,wNome2)
               Cab110ET(1,002,wEnd1)
               Cab110ET(0,065,wEnd2)
               Cab110ET(1,002,wBair1)
               Cab110ET(0,018,wFunc1)
               Cab110ET(0,065,wBair2)
               Cab110ET(0,083,wFunc2)
               Cab110ET(1,002,wMsg1)
               Cab110ET(0,065,wMsg2)
               @ PROW()+3,000 SAY ""
            ENDDO
            DBGOTOP(); SET ORDER TO 3; DBSEEK(wArea)
            WHILE AREA2==wArea.AND.!EOF()
               wNome1 := NOME     ; wNome2 := SPACE(50)
               wFunc1 := FUNCAO   ; wFunc2 := SPACE(20)
               wBair1 := BAIRRO   ; wBair2 := SPACE(15)
               wEnd1  := ENDERECO ; wEnd2  := SPACE(50)
               wMsg1  := wMsgFunc ; wMsg2  := SPACE(50)
               DBSKIP()
               IF AREA2==wArea
                  wNome2 := NOME
                  wFunc2 := FUNCAO
                  wEnd2  := ENDERECO
                  wBair2 := BAIRRO
                  wMsg2  := wMsgFunc
                  DBSKIP()
               ENDIF
               Cab110ET(0,002,wNome1)
               Cab110ET(0,065,wNome2)
               Cab110ET(1,002,wEnd1)
               Cab110ET(0,065,wEnd2)
               Cab110ET(1,002,wBair1)
               Cab110ET(0,018,wFunc1)
               Cab110ET(0,065,wBair2)
               Cab110ET(0,083,wFunc2)
               Cab110ET(1,002,wMsg1)
               Cab110ET(0,065,wMsg2)
               @ PROW()+3,000 SAY ""
            ENDDO
            EXIT
         ELSE
            wNome1 := NOME     ; wNome2 := SPACE(50)
            wFunc1 := FUNCAO   ; wFunc2 := SPACE(20)
            wBair1 := BAIRRO   ; wBair2 := SPACE(15)
            wEnd1  := ENDERECO ; wEnd2  := SPACE(50)
            wMsg1  := wMsgFunc ; wMsg2  := SPACE(50)
            DBSKIP()
            IF &lCond.
               wNome2 := NOME
               wFunc2 := FUNCAO
               wEnd2  := ENDERECO
               wBair2 := BAIRRO
               wMsg2  := wMsgFunc
               DBSKIP()
            ENDIF
            Cab110ET(0,002,wNome1)
            Cab110ET(0,065,wNome2)
            Cab110ET(1,002,wEnd1)
            Cab110ET(0,065,wEnd2)

            Cab110ET(1,002,wBair1)
            Cab110ET(0,018,wFunc1)
            Cab110ET(0,065,wBair2)
            Cab110ET(0,083,wFunc2)
            Cab110ET(1,002,wMsg1)
            Cab110ET(0,065,wMsg2)

            @ PROW()+3,000 SAY ""
         ENDIF
      ELSE
         DBSKIP()
      ENDIF
   ENDDO
   Imp_Normal()
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp ap345.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE AP345.TXT

   RETURN
