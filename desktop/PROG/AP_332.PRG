*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_332                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Imprimir Relatorio Financ.Usuarios NPG/PGณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 08/11/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PROCEDURE AP_332(wOp)
PUBLIC continua := .T., nPg := 0

DBCLOSEALL()
SELECT 1
IF NetUse("PGUSU")
   SET INDEX TO DBIPGUS1
ELSE
   RETURN
ENDIF

SELECT 3
IF NetUse("USUATIV")
   SET INDEX TO DBIUSAT3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("ATIV")
   SET INDEX TO DBIATIV1,DBIATIV2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SET KEY -1 TO Mostra()
ProgName("GC332")
Telas(17,03,21,46,1,YCOREDIT,.T.)
WHILE .T.
   SETCOLOR(YCOREDIT)
   SCROLL(19,21,20,45)
   wAnoRef := SPACE(4); wAtiv := SPACE(2) ; nPg := 0 ; wRef := SPACE(1) ; wMesAno := SPACE(6)
   @ 18,05 SAY "Mes/Ano (M/A)?:" GET wRef   PICT "!"  WHEN TeclaFuncao()    VALID wRef $ "MA"
   @ 19,05 SAY "     Atividade:" GET wAtiv  PICT "99" WHEN TeclaFuncao(.T.) VALID TAtiv1(wAtiv)
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   IF wRef=="M"
      @ 20,05 SAY "Mes/Ano Refer.:" GET wMesAno PICT "@R 99/9999" WHEN TeclaFuncao() VALID !EMPTY(wMesAno)
   ELSE
      @ 20,05 SAY "Ano Referncia:" GET wAnoRef PICT "9999" WHEN TeclaFuncao() VALID !EMPTY(wAnoRef)
   ENDIF
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   SELECT ATIV
   IF MENSALID>0.00
      SELECT USUATIV
      IF DBSEEK(wAtiv)
         IF ChkImpr()
            cAviso := MsgImp()
            SELECT PGUSU
            DBGOTOP()
            SELECT USUATIV
            ImpPgSoc(wOp,wRef)
            TiraMsgImp(cAviso)
            Beep(2)
            Mensagem("Fim de Impresso! Tecle algo...")
            INKEY(0)
            Mensagem()
         ENDIF
      ELSE
         Aviso("No existe Usu rio desta Atividade")
      ENDIF
   ELSE
      Aviso("Atividade Isenta de Mensalidade...",,3)
   ENDIF
ENDDO
SETKEY(K_F2,NIL)
Rest_Tela()
RELEASE continua, nPg
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Listagem            ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE ImpPgSoc(wOp,pRef)
   LOCAL aMes[12], aAno[12], aTotal[12]

   IF pRef=="A"
      AFILL(aAno,STRZERO(VAL(wAnoRef),4))
      sData := DATE()
   ELSE
      AFILL(aAno,STRZERO(VAL(RIGHT(wMesAno,4)),4))
      aMes[1] := STRZERO(VAL(LEFT(wMesAno,2)),2)
      sData := CTOD("01/"+aMes[1]+"/"+aAno[1])
   ENDIF
   AFILL(aTotal,0.00)

   Gera_TXT("AP332.TXT")
   SETPRC(0,0)
   lCabec := Cab332(wOp,pRef,sData)
   nQtdPg := 0
   WHILE ATIVIDADE==wAtiv.AND.continua.AND.!EOF()
      wMatricula := USUATIV->MATRICULA
      lPagouUma  := .F.
      IF !lCabec
         lCabec := Cab332(wOp,pRef,sData)
      ENDIF

      SELECT PGUSU
      IF pRef=="A"
         nRegAnt := RECNO()
         FOR pg = 1 TO 12
             aMes[pg]  := STRZERO(pg,2)
             DBSEEK(wMatricula+wAtiv+aAno[pg]+aMes[pg])
             IF VALOR>0.00
                lPagouUma:=.T.
             ENDIF
         NEXT

         GO nRegAnt
         IF wOp=3.AND.lPagouUma
            @ PROW()+1,001 SAY USUATIV->NOME PICT "@!S30"
            nCol := 43
            FOR pg = 1 TO 12
                aMes[pg]  := STRZERO(pg,2)
                DBSEEK(wMatricula+wAtiv+aAno[pg]+aMes[pg])
                aTotal[pg] += VALOR
                ChkInterv("Cab332",0,nCol,IF(VALOR>0.00,"Pago","NPG"))
                nCol+=7
            NEXT
         ELSEIF wOp=4.AND.!lPagouUma
            @ PROW()+1,001 SAY USUATIV->NOME PICT "@!S30"
            nCol := 43
            FOR pg = 1 TO 12
                aMes[pg]  := STRZERO(pg,2)
                DBSEEK(wMatricula+wAtiv+aAno[pg]+aMes[pg])
                ChkInterv("Cab332",0,nCol,"NPG")
                nCol+=7
            NEXT
         ENDIF
      ELSE
         DBSEEK(wMatricula+wAtiv+aAno[1]+aMes[1])
         IF VALOR>0.00
            lPagouUma:=.T.
         ENDIF
         IF wOp=3.AND.lPagouUma
            @ PROW()+1,001 SAY USUATIV->NOME    PICT "@!"
            @ PROW()  ,054 SAY USUATIV->DTINSCR PICT "@D"
            @ PROW()  ,064 SAY RECIBO           PICT "@!"
            @ PROW()  ,073 SAY DTPAG            PICT "@D"
            @ PROW()  ,085 SAY DOC              PICT "@!"
            @ PROW()  ,096 SAY VALOR            PICT "@E 999,999,999.99"
            aTotal[1] += VALOR
            nQtdPg++
         ELSEIF wOp=4.AND.!lPagouUma
            @ PROW()+1,001 SAY USUATIV->NOME    PICT "@!"
            @ PROW()  ,054 SAY USUATIV->DTINSCR PICT "@D"
            nQtdPg++
         ELSEIF wOp=5.AND.lPagouUma
            IF STRZERO(MONTH(DTPAG),2)==aMes[1]
               @ PROW()+1,001 SAY USUATIV->NOME    PICT "@!"
               @ PROW()  ,054 SAY USUATIV->DTINSCR PICT "@D"
               @ PROW()  ,064 SAY RECIBO           PICT "@!"
               @ PROW()  ,073 SAY DTPAG            PICT "@D"
               @ PROW()  ,085 SAY DOC              PICT "@!"
               @ PROW()  ,096 SAY VALOR            PICT "@E 999,999,999.99"
               aTotal[1] += VALOR
               nQtdPg++
            ENDIF
         ENDIF
      ENDIF

      SELECT USUATIV
      DBSKIP()
      IF PROW() > 57
         @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
         lCabec := .F.
         EJECT
      ENDIF
   ENDDO
   @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
   IF wOp==3.OR.wOp==5
      EJECT
      @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
      @ PROW()+1,001 SAY "RESUMO DE PAGAMENTOS:"
      @ PROW()+1,001 SAY ""
      IF pRef=="A"
         FOR p = 1 TO 12
             sData:=CTOD("01/"+STRZERO(p,2)+"/"+wAnoRef)
             ChkInterv("Cab332",1,01,UPPER(MesExt(sData)))
             ChkInterv("Cab332",0,12,"=")
             ChkInterv("Cab332",0,14,aTotal[p],"[@E 99,999,999,999.99]")
         NEXT
      ELSE
         sData:=CTOD("01/"+aMes[1]+"/"+aAno[1])
         ChkInterv("Cab332",1,01,UPPER(MesExt(sData)))
         ChkInterv("Cab332",0,14,aTotal[1],"[@E 99,999,999,999.99]")
         @ PROW()+1,001 SAY "TOTAL DE PAGANTES ="
         @ PROW()  ,022 SAY nQtdPg PICT "@E 999,999"
      ENDIF
   ELSEIF wOp==4 .AND. pRef=="M"
      @ PROW()+1,001 SAY "TOTAL DE NAO PAGANTES ="
      @ PROW()  ,025 SAY nQtdPg PICT "@E 999,999"
   ENDIF
   Compr_Off()
   @ PROW()+1,001 SAY " "
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp ap332.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE AP332.TXT

   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho do Relatorio       ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Cab332(wOp,pRef,pData)
   nPg++
   @ PROW()  ,001 SAY "Clube 2004"
   Compr_On()
   @ PROW()+1,110 SAY "Data:"+DTOC(DATE())
   @ PROW()+1,110 SAY "Pag.:"+STRZERO(nPg,3)
   IF wOp=3
      @ PROW()+1,049 SAY "POSICAO DE PAGAMENTO MENSAL"
   ELSEIF wOp=5
      @ PROW()+1,047 SAY "RELACAO DE PAGAMENTOS DE USUARIOS NO MES"
   ELSE
      @ PROW()+1,047 SAY "RELACAO DE USUARIOS NAO PAGANTES"
   ENDIF
   @ PROW()+1,047 SAY "           ANO-"+IF(pRef=="A",wAnoRef,RIGHT(wMesAno,4))
   @ PROW()+1,001 SAY "Atividade: "+ATIV->DESCR
   IF pRef=="A"
      @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
      @ PROW()+1,001 SAY "                                        |                    P A G A M E N T O S         E F E T U A D O S                     "
      @ PROW()+1,001 SAY "           NOME DO USUARIO              |--------------------------------------------------------------------------------------"
      @ PROW()+1,001 SAY "                                        | JAN    FEV    MAR    ABR    MAI    JUN    JUL    AGO    SET    OUT    NOV    DEZ     "
   ELSE
      @ PROW()+1,001 SAY "PAGAMENTOS "+IF(wOp==4,"NAO ","")+"REFERENTES MES "+UPPER(MesExt(pData))
      @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
      @ PROW()+1,001 SAY "NOME DO USUARIO                                      INSCR.    RECIBO   DT.PGTO     DOC                 VALOR"
*                         XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX   99/99/99  99999    99/99/99    999999     999,999,999.99
*                         1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
*                                  1         2         3         4         5         6         7         8         9        10        11        12
   ENDIF
   @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Validar Atividade            ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TAtiv1(pAtiv)
   IF !EMPTY(pAtiv)
      SELECT ATIV
      IF DBSEEK(pAtiv)
         @ 19,24 SAY DESCR PICT "@!S20" COLOR YCORREALCE
         RETURN .T.
      ELSE
         Aviso("Atividade no Cadastrada")
      ENDIF
   ENDIF
   RETURN .F.
