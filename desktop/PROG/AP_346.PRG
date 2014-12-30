*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_346                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Carta dos Funcionarios                   ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 13/12/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

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
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA7,DBISOCA8
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF !NetUse("DBPARM")
   DBCLOSEALL(); RETURN
ENDIF

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
Telas(7,9,20,70,1,YCOREDIT,.T.)
LinhaMsg(9); ProgName("GC346")
SETCOLOR(YCOREDIT)
SETCURSOR(1)
lIns   := .F.
Mensagem(" "+CHR(24)+" "+CHR(25)+" PgUp PgDn ESC              Lin:      Col:    ")
WHILE .T.
   wtexto := MEMOEDIT(CARTAF,8,10,19,69,.T.,"Editor2")
   IF LASTKEY()==K_F2
      SELECT DBPARM
      IF NetLReg()
         FIELD->CARTAF := wtexto
         ProcOk("Gravado")
      ENDIF
   ELSEIF LASTKEY()==K_ESC
      EXIT
   ENDIF
ENDDO
Rest_Tela()
SETCURSOR(0)
DBCLOSEALL()
SETKEY(K_F4,{|| Calculadora(@calc_lin,@calc_col,YCORMENU)})
SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Controlar Editor Texto       ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Editor2(pModo,nlin,ncol)
   lRet := 0
   DO CASE
      CASE pModo = 0
           cCorAnterior := SETCOLOR()
           @ 23,52 SAY TRIM(STR(nLin,IF(nLin<100,2,4),0)) COLOR YCORREALCE
           @ 23,62 SAY TRIM(STR(nCol,2,0))                COLOR YCORREALCE
           SETCOLOR(cCorAnterior)
      CASE pModo = 1 .OR. pModo = 2
           IF LASTKEY()==K_F2
              lRet := 23
           ENDIF
           IF LASTKEY()==K_INS
              cCorAnterior := SETCOLOR()
              SETCOLOR("*N/W")
              @ 23,34 SAY IF(lIns,"       ","Inserir")
              lIns := IF(lIns,.F.,.T.)
              SETCOLOR(cCorAnterior)
           ENDIF
           IF LASTKEY()==K_F3
              Imp346()
           ENDIF
      CASE pModo = 3
           READINSERT(.F.)
   ENDCASE
   RETURN lRet
*ีออออออออออออออออออออออออออออออธ
*ณ Controlar Editor Texto       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Imp346()
   LOCAL cCorAntes := SETCOLOR(), lAchou := .F.

   Telas(17,03,20,34,1,YCOREDIT,.T.)
   SET KEY -1 TO Mostra()
   WHILE .T.
      SETCURSOR(1)
      SETCOLOR(YCOREDIT)
      wFuncao := SPACE(20) ; wArea := SPACE(2) ; lAchou := .F.
      @ 18,05 SAY "  Area:" GET wArea   PICT "@!"    WHEN TeclaFuncao(.T.)
      @ 19,05 SAY "Funo:" GET wFuncao PICT "@!S20" WHEN TeclaFuncao(.T.)
      READ
      TeclaFuncao()
      IF LASTKEY()==K_ESC ; EXIT ; ENDIF

      SELECT SOCIOS
      IF (!EMPTY(wArea).AND.EMPTY(wFuncao)).OR.(!EMPTY(wArea).AND.!EMPTY(wFuncao))
         SET ORDER TO 2
         IF DBSEEK(wArea)
            lAchou := .T.
         ENDIF
         IF !EMPTY(wArea).AND.!EMPTY(wFuncao)
            lCond := "AREA==wArea.AND.ALLTRIM(FUNCAO)==ALLTRIM(wFuncao)"
         ELSE
            lCond := "AREA==wArea"
         ENDIF
      ELSEIF EMPTY(wArea).AND.!EMPTY(wFuncao)
         SET ORDER TO 1
         IF DBSEEK(wFuncao)
            lAchou := .T.
         ENDIF
         lCond := "ALLTRIM(FUNCAO)==ALLTRIM(wFuncao)"
      ELSEIF EMPTY(wArea).AND.EMPTY(wFuncao)
         EXIT
      ENDIF

      IF lAchou
         IF ChkImpr()
            cAviso := MsgImp(.F.)
            Gera_TXT("AP346.TXT")
            WHILE &lCond..AND.!EOF()
               @ PROW()+5,11 SAY "Salvador, "+SUBS(DTOC(DATE()),1,2)+" de "+MesExt(DATE())+" de "+STR(YEAR(DATE()),4)
               @ PROW()+2,11 SAY "ILMo(a). Sr(a). "
               @ PROW()  ,27 SAY NOME PICT "@!S40"
               @ PROW()+1,00 SAY ""
               SELECT DBPARM
               nLinha := MLCOUNT(CARTAF,58)
               FOR n = 1 TO nLinha
                   cLinha := MEMOLINE(CARTAF,58,N)
                   @ PROW()+1,11 SAY cLinha
               NEXT
               SELECT SOCIOS
               DBSKIP()
               EJECT
            ENDDO
            Fim_TXT()
            SAVESCREEN(0,0,24,79)
            RUN nodosimp ap346.txt 80 pre
            RESTSCREEN(0,0,24,79,0)
            DELETE FILE AP346.TXT

            TiraMsgImp(cAviso)
         ENDIF
      ELSE
         Aviso("No existem funcionarios com estas especifica”es",,3)
      ENDIF
   ENDDO
   Rest_Tela()
   SETCURSOR(1)
   SETCOLOR(cCorAntes)
   SETKEY(K_F2,NIL)
   RETURN NIL
