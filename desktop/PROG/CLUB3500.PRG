*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : CLUB3500                         vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Lista de Usuarios                        ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 11/01/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
SELECT 3
IF NetUse("ATIV")
   SET INDEX TO DBIATIV1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("USUARIOS")              /* Cadastro do Usuario */
   SET INDEX TO DBIUSU2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("USUATIV")              /* Atividades do Usuario */
   SET INDEX TO DBIUSAT3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SET KEY -1 TO Mostra()
Telas(18,3,20,19,1,YCOREDIT,.T.)
WHILE .T.
   SETCURSOR(1)
   SETCOLOR(YCOREDIT)

   wAtividade := SPACE(2) ; nQtdUsu := 0

   Mensagem("Informe Atividade")
   @ 19,05 SAY "Atividade:" GET wAtividade PICT "99" WHEN TeclaFuncao(.T.)
   READ

   TeclaFuncao()
   IF LASTKEY()==K_ESC .OR. EMPTY(wAtividade)
      Rest_Tela(); EXIT
   ENDIF
   wDescr := ATIV->DESCR

   SELECT USUATIV
   IF DBSEEK(wAtividade)
      IF ChkImpr()
         continua := .T.
         Imprimindo := MsgImp()
         Gera_TXT("CL3500.TXT")
         pg   := 0
         lCab := CabRel("LISTA DE USUARIOS")
         WHILE ATIVIDADE==wAtividade.AND.continua.AND.!EOF()
            IF !lCab
               lCab := CabRel("LISTA DE USUARIOS")
            ENDIF
            nQtdUsu++
            wMatricula:=MATRICULA
            Cab3500(01,000,MATRICULA)
            Cab3500(00,007,NOME,"[@S40]")
            SELECT USUARIOS
            DBSEEK(wMatricula)
            Cab3500(00,048,ENDERECO,"[@S40]")
            Cab3500(00,089,BAIRRO,"[@S20]")
            Cab3500(00,111,TEL,"[@R (999) 999-9999]")
*           Cab3500(01,058,CIDADE)
*           Cab3500(00,099,CEP,"[@R XX.XXX-XXX]")
*           Cab3500(00,121,ESTADO)
            Cab3500(01,000,"")
            SELECT USUATIV
            DBSKIP()
            IF PROW() > 58
               EJECT; lCab := .F.
            ENDIF
         ENDDO
         @ PROW()+02,000 SAY "TOTAL DE USUARIOS => "+STR(nQtdUsu,5)
         IF continua
            @ 62,00 SAY "** Fim de Relatorio **"
            EJECT
         ENDIF
         Imp_Normal()
         Fim_TXT()
         SAVESCREEN(0,0,24,79)
         RUN nodosimp cl3500.txt 80 pre
         RESTSCREEN(0,0,24,79,0)
         DELETE FILE CL3500.TXT

         TiraMsgImp(Imprimindo)
         Beep(2)
      ENDIF
   ELSE
      Aviso("No h  usu rio desta Atividade",,3)
   ENDIF
ENDDO
SETKEY(K_F2,NIL)
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Tecla de Cancelamento        ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Cab3500(nProw,nPcol,cTexto,cMascara)
  IF Continua
     Continua := EscPrint()
     IF (PROW() < 1 .OR. PROW() > 60) .AND. Continua
        pg++
        IF PROW() > 60
           EJECT
        ENDIF
     ENDIF
     IF VALTYPE( cMascara ) = "U"
        @ PROW()+nProw,nPcol SAY cTexto
     ELSE
        @ PROW()+nProw,nPcol SAY cTexto PICT &cMascara
     ENDIF
  ELSE
     Imp_Normal()
     DBGOBOTTOM()
     DBSKIP()
  ENDIF
  RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho do Relatorio       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION CabRel(cTitulo)
   pg++
   IMP_exp()
   @ PROW()   ,000 SAY "Clube 2004"
   IMP_Enor()
   @ PROW()+01,INT((130-LEN(TRIM(cTitulo)))/2) SAY cTitulo
   @ PROW()+02,000 SAY "Data: "+DTOC(DATE())
   @ PROW()   ,120 SAY "Pag.:"+STRZERO(pg,3)
   @ PROW()+01,000 SAY "Hora: "+TIME()
   @ PROW()+01,000 SAY wDescr
   Imp_Compri()
   @ PROW()+01,000 SAY REPLI("-",130)
   @ PROW()+01,000 SAY "MAT.   USUARIO                                  ENDERECO                                 BAIRRO                TEL"
*                       99999  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx XXXXXXXXXXxxxxxxxxxx  (999) 999-9999
*                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                                 1         2         3         4         5         6         7         8         9        10        11         12       13
*  @ PROW()+01,000 SAY "                                                          CIDADE                                   CEP                   UF"
   @ PROW()+01,000 SAY REPLI("-",130)
   RETURN .T.
