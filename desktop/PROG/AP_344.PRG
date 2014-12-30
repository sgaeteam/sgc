*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_344                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Carta dos Aniversariantes do Mes         ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 30/11/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
PUBLIC wtexto

DBCLOSEALL()
SELECT 2
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA6
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF !NetUse("DBPARM")
   RETURN
ENDIF

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
Telas(7,9,20,70,1,YCOREDIT,.T.)
LinhaMsg(9); ProgName("GC344")
SETCOLOR(YCOREDIT)
SETCURSOR(1)
lIns := .F.
Mensagem(" "+CHR(24)+" "+CHR(25)+" PgUp PgDn ESC              Lin:      Col:    ")
WHILE .T.
   wtexto := MEMOEDIT(CARTA,8,10,19,69,.T.,"Editor1")
   IF LASTKEY()==K_F2
      SELECT DBPARM
      IF NetLReg()
         FIELD->CARTA := wtexto
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
RELEASE wtexto
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Controlar Editor Texto       ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Editor1(pModo,nlin,ncol)
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
              Imp344()
           ENDIF
      CASE pModo = 3
           READINSERT(.F.)
   ENDCASE
   RETURN lRet
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Carta               ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Imp344()
   LOCAL cCorAntes := SETCOLOR()

   Telas(18,03,20,22,1,YCOREDIT,.T.)
   WHILE .T.
      SETCURSOR(1)
      SETCOLOR(YCOREDIT)
      wDtAniv := SPACE(2)
      @ 19,05 SAY "Mes Aniv.:" GET wDtAniv PICT "99"
      READ
      IF LASTKEY()==K_ESC .OR. EMPTY(wDtAniv)
         EXIT
      ENDIF

      SELECT SOCIOS
      IF DBSEEK(wDtAniv)
         IF ChkImpr()
            cAviso := MsgImp(.F.)
            Gera_TXT("AP344.TXT")
            WHILE SUBS(DTOC(DATNAS),1,2)=wDtAniv.AND.!EOF()
               @ PROW()+5,11 SAY "Salvador, "+SUBS(DTOC(DATE()),1,2)+" de "+MesExt(DATE())+" de "+STR(YEAR(DATE()),4)
               @ PROW()+2,11 SAY "Sr(a). "
               @ PROW()  ,18 SAY NOME PICT "@!S49"
               @ PROW()+1,00 SAY ""
               SELECT DBPARM
               nLinha := MLCOUNT(CARTA,58)
               FOR n = 1 TO nLinha
                   cLinha := MEMOLINE(CARTA,58,N)
                   @ PROW()+01,11 SAY cLinha
               NEXT
               SELECT SOCIOS
               DBSKIP()
               EJECT
            ENDDO
            Fim_TXT()
            SAVESCREEN(0,0,24,79)
            RUN nodosimp ap344.txt 80 pre
            RESTSCREEN(0,0,24,79,0)
            DELETE FILE AP344.TXT

            TiraMsgImp(cAviso)
         ENDIF
      ELSE
         Aviso("No h  Sขcio Aniversariando neste mes",,3)
      ENDIF
   ENDDO
   Rest_Tela()
   SETCURSOR(1)
   SETCOLOR(cCorAntes)
   RETURN NIL
