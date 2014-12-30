*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_11C                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Consultar Dependentes                    ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 24/09/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
#include "COMMAND.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD( aDbf, { "NOME"  ,"C", 50, 0 } )
AADD( aDbf, { "GRAU"  ,"C", 10, 0 } )

WHILE .T.
   sHour:=TIME()
   cArq1:="TM"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE(cArq1,aDbf); RELEASE aDbf; EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")
INDEX ON nome TO (cArq1)

SELECT 8
IF NetUse("DEPEND")
   SET INDEX TO DBIDEPA2,DBIDEPA1,DBIDEPA3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2,DBISOCA1,DBISOCA3,DBISOCA4,DBISOCA5,DBISOCA6,DBISOCA7,DBISOCA8
ELSE
   DelDbfNtx(); RETURN
ENDIF

ProgName("GC11C"); LinhaMsg(2)
SET KEY -1 TO Mostra()
WHILE .T.
   lNovo := lDeleta := lAchou := .F.
   wNomeSoc := SPACE(50)
    
   Telas(18,3,20,62,1,YCOREDIT,.T.); SETCOLOR(YCOREDIT)
   Mensagem("Informe Nome do Sขcio")
   @ 19,05 SAY "Nome:" GET wNomeSoc PICT "@!" WHEN TeclaFuncao(.T.)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao(); Rest_Tela()
   IF LASTKEY()==K_ESC .OR. EMPTY(wNomeSoc); EXIT; ENDIF

   SELECT SOCIOS
   SET ORDER TO 1
   IF NOME#wNomeSoc
      IF DBSEEK(wNomeSoc)
         /* Preencher arquivo temporario */
         vMatricula := MATRICULA
         SELECT DEPEND
         SET ORDER TO 2
         IF DBSEEK(vMatricula)
            WHILE MATRICULA==vMatricula.AND.!EOF()
               SELECT (cArq1); DBAPPEND()
               FIELD->NOME := DEPEND->NOME; FIELD->GRAU := DEPEND->GRAU
               SELECT DEPEND; DBSKIP()
            ENDDO
         ENDIF
         SET ORDER TO 1
         SELECT (cArq1); DBGOTOP()
         IF EOF()
            Aviso("Sขcio no tem Dependentes...")
         ELSE
            Consulta(10, 1, "Dependentes","Grau","NOME","GRAU",NIL )
         ENDIF
      ENDIF
   ELSE
      /* Preencher arquivo temporario */
      vMatricula := MATRICULA
      SELECT DEPEND
      SET ORDER TO 2
      IF DBSEEK(vMatricula)
         WHILE MATRICULA==vMatricula.AND.!EOF()
            SELECT (cArq1); DBAPPEND()
            FIELD->NOME := DEPEND->NOME; FIELD->GRAU := DEPEND->GRAU
            SELECT DEPEND; DBSKIP()
         ENDDO
      ENDIF
      SET ORDER TO 1
      SELECT (cArq1); DBGOTOP()
      IF EOF()
         Aviso("Sขcio no tem Dependentes...")
      ELSE
         Consulta(10, 1, "Dependentes","Grau","NOME","GRAU",NIL )
      ENDIF
   ENDIF
   (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
ENDDO
SETKEY(K_F2,NIL)
DelDbfNtx(); RETURN
