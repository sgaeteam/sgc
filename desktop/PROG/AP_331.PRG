*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_331                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Imprimir Relatorio Financeiro Pg Socios  ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 05/11/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PROCEDURE AP_331(wOp)
PUBLIC continua := .T., nPg := 0

DBCLOSEALL()
SELECT 1
IF NetUse("PGSOC")
   SET INDEX TO DBIPGSO1,DBIPGSO2
ELSE
   RETURN
ENDIF

SELECT 2
IF NetUse("CATEG")
   SET INDEX TO DBICATE1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SET KEY -1 TO Mostra()
ProgName("GC331")
Telas(17,03,21,49,1,YCOREDIT,.T.)
WHILE .T.
   SETCURSOR(1)
   SETCOLOR(YCOREDIT)
   SCROLL(19,21,20,45)
   wAnoRef := SPACE(4); wCat := SPACE(2) ; nPg := 0 ; wRef := SPACE(1) ; wMesAno := SPACE(6)
   @ 18,05 SAY "Mes/Ano (M/A)?:" GET wRef PICT "!"  WHEN TeclaFuncao()    VALID wRef $ "MA"
   @ 19,05 SAY "     Categoria:" GET wCat PICT "99" WHEN TeclaFuncao(.T.) VALID !EMPTY(wCat).AND.TCateg(19,24,wCat,"@S20")
   READ
   IF LASTKEY()==K_ESC
      EXIT
   ENDIF

   IF wRef=="M"
      @ 20,05 SAY "Mes/Ano Refer.:" GET wMesAno PICT "@R 99/9999" WHEN TeclaFuncao() VALID !EMPTY(wMesAno)
   ELSE
      @ 20,05 SAY "Ano Referncia:" GET wAnoRef PICT "9999" WHEN TeclaFuncao() VALID !EMPTY(wAnoRef)
   ENDIF
   READ
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   SELECT CATEG
   IF MENSALID>0.00
      SELECT SOCIOS
      IF DBSEEK(wCat)
         IF ChkImpr()
            cAviso := MsgImp()
            SELECT PGSOC
            DBGOTOP()
            SELECT SOCIOS
            ImpPgSoc(wOp,wRef)
            TiraMsgImp(cAviso)
            Beep(2)
            Mensagem("Fim de Impresso! Tecle algo...")
            INKEY(0)
            Mensagem()
         ENDIF
      ELSE
         Aviso("No existe Sขcio com esta categoria",,3)
      ENDIF
   ELSE
      Aviso("Categoria no Paga Mensalidade...",,3)
   ENDIF
ENDDO
Rest_Tela()
SETKEY(K_F2,NIL)
SETCURSOR(0)
RELEASE continua, nPg
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Listagem            ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE ImpPgSoc(wOp,pRef)
   LOCAL aMes[12], aAno[12]

   IF pRef=="A"
      AFILL(aAno,STRZERO(VAL(wAnoRef),4))
      pAno := SUBS(DTOC(DATE()),7,4)
      pMes := SUBS(DTOC(DATE()),4,2)
      sData := DATE()
   ELSE
      AFILL(aAno,STRZERO(VAL(RIGHT(wMesAno,4)),4))
      aMes[1] := STRZERO(VAL(LEFT(wMesAno,2)),2)
      sData := CTOD("01/"+aMes[1]+"/"+aAno[1])
   ENDIF

   Gera_TXT("AP331.TXT")
   SETPRC(0,0)
   lCabec := CabPag(wOp,pRef,sData)
   nQtdPg := 0
   nSoma  := 0.00
   WHILE CATEGORIA==wCat.AND.continua.AND.!EOF()
      cIns       := SUBS(DTOC(SOCIOS->DTADESAO),7,4)+SUBS(DTOC(SOCIOS->DTADESAO),4,2)
      wMatricula := SOCIOS->MATRICULA
      lPagouUma  := .F.
      IF !lCabec
         lCabec := CabPag(wOp,pRef,sData)
      ENDIF

      SELECT PGSOC
      IF pRef=="A"
         /* Verificar se houve algum pagamento durante o ano */
         nRegAnt := RECNO()
         FOR pg = 1 TO 12
             aMes[pg] := STRZERO(pg,2)
             IF wCat=="01"           /* Socios A */
                wSit := IF(cIns>(aAno[pg]+aMes[pg]),SPACE(1),;
                        IF(VAL(aAno[pg]) < VAL(pAno),"Pago",;
                        IF(VAL(aAno[pg]) = VAL(pAno),IF(VAL(pMes)<VAL(aMes[pg]),"NPG","Pago"),"NPG")))
                IF wSit="Pago"
                   lPagouUma:=.T.
                ENDIF
             ELSE                    /* Outras Categorias */
                IF DBSEEK(wMatricula+aAno[pg]+aMes[pg])
*               IF VALOR#0.00
                   lPagouUma:=.T.
                ENDIF
             ENDIF
         NEXT

         IF wOp==1.AND.lPagouUma
            GO nRegAnt
            @ PROW()+1,001 SAY SOCIOS->NOME PICT "@!S40"
            nCol := 43
            nQtdPg++
            FOR pg = 1 TO 12
                aMes[pg] := STRZERO(pg,2)
                IF wCat=="01"           /* Socios A */
                   wSit := IF(cIns>(aAno[pg]+aMes[pg]),SPACE(1),;
                           IF(VAL(aAno[pg]) < VAL(pAno),"Pago",;
                           IF(VAL(aAno[pg]) = VAL(pAno),IF(VAL(pMes)<VAL(aMes[pg]),"NPG","Pago"),"NPG")))
                   ChkInterv("CabPag",0,nCol,wSit)
                ELSE                    /* Outras Categorias */
                   IF DBSEEK(wMatricula+aAno[pg]+aMes[pg])
                      wSit:=IF(cIns>(aAno[pg]+aMes[pg])," ","Pago")
                   ELSE
                      wSit:=IF(cIns>(aAno[pg]+aMes[pg])," ","NPG")
                   ENDIF
*                  wSit := IF(cIns>(aAno[pg]+aMes[pg]),SPACE(1),;
*                          IF(VAL(aAno[pg]) < VAL(pAno),"Pago",;
*                          IF(VAL(aAno[pg]) = VAL(pAno),IF(VAL(pMes)<VAL(aMes[pg]),"NPG","Pago"),"NPG")))
                   ChkInterv("CabPag",0,nCol,wSit)
                ENDIF
                nCol+=7
            NEXT
         ELSEIF wOp==2.AND.!lPagouUma
            nQtdPg++
            GO nRegAnt
            @ PROW()+1,001 SAY SOCIOS->NOME     PICT "@!"
            @ PROW()  ,054 SAY SOCIOS->DTADESAO PICT "@D"
         ENDIF
      ELSE
         DBSEEK(wMatricula+aAno[1]+aMes[1])
         IF VALOR#0.00
            lPagouUma:=.T.
         ENDIF
         IF wOp==1.AND.lPagouUma
            @ PROW()+1,001 SAY SOCIOS->NOME     PICT "@!"
            @ PROW()  ,054 SAY SOCIOS->DTADESAO PICT "@D"
            @ PROW()  ,064 SAY RECIBO           PICT "@!"
            @ PROW()  ,073 SAY DTPAG            PICT "@D"
            @ PROW()  ,085 SAY DOC              PICT "@!"
            @ PROW()  ,096 SAY VALOR            PICT "@E 999,999,999.99"
            nSoma += VALOR
            nQtdPg++
         ELSEIF wOp==2.AND.!lPagouUma
            @ PROW()+1,001 SAY SOCIOS->NOME     PICT "@!"
            @ PROW()  ,054 SAY SOCIOS->DTADESAO PICT "@D"
            nQtdPg++
         ENDIF
      ENDIF

      SELECT SOCIOS
      DBSKIP()
      IF PROW() > 57
         @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
         lCabec := .F.
         EJECT
      ENDIF
   ENDDO
   @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
   @ PROW()+1,001 SAY " TOTAL "+IF(wOp==1,"PAGANTES =","NAO PAGANTES=")
   @ PROW()  ,022 SAY nQtdPg PICT "@E 999,999"
   IF pRef#"A"
      @ PROW()  ,096 SAY nSoma  PICT "@E 999,999,999.99"
   ENDIF
   Compr_Off()
   @ PROW()+1,002 SAY " "
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp ap331.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE AP331.TXT

   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho do Relatorio       ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION CabPag(wOp,pRef,pData)
   nPg++
   @ PROW()  ,001 SAY "Clube 2004"
   Compr_On()
   @ PROW()+1,110 SAY "Data:"+DTOC(DATE())
   @ PROW()+1,110 SAY "Pag.:"+STRZERO(nPg,3)
   IF wOp=1
      @ PROW()+1,045 SAY "RELACAO DE PAGAMENTO "+ALLTRIM(CATEG->DESCR)
      @ PROW()+1,059 SAY "ANO-"+IF(pRef=="A",wAnoRef,RIGHT(wMesAno,4))
      IF pRef=="A"
         @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
         @ PROW()+1,001 SAY "                                        |                    P A G A M E N T O S         E F E T U A D O S                     "
         @ PROW()+1,001 SAY "           NOME DO SOCIO                |--------------------------------------------------------------------------------------"
         @ PROW()+1,001 SAY "                                        | JAN    FEV    MAR    ABR    MAI    JUN    JUL    AGO    SET    OUT    NOV    DEZ     "
      ELSE
         @ PROW()+1,001 SAY "PAGAMENTOS EFETUADOS EM "+UPPER(MesExt(pData))
         @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
         @ PROW()+1,001 SAY "NOME DO SOCIO                                        ADESAO    RECIBO   DT.PGTO     DOC                 VALOR"
*                            XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX   99/99/99  99999    99/99/99    999999     999,999,999.99
*                            1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
*                                     1         2         3         4         5         6         7         8         9        10        11        12
      ENDIF
   ELSE
      IF pRef=="A"
         @ PROW()+1,045 SAY "RELACAO DE "+ALLTRIM(CATEG->DESCR)+" NAO PAGANTES"
         @ PROW()+1,059 SAY "ANO-"+IF(pRef=="A",wAnoRef,RIGHT(wMesAno,4))
         @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
         @ PROW()+1,001 SAY "NOME DO SOCIO                                        ADESAO"
      ELSE
         @ PROW()+1,001 SAY "PAGAMENTOS NAO EFETUADOS EM "+UPPER(MesExt(pData))
         @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
         @ PROW()+1,001 SAY "NOME DO SOCIO                                        ADESAO"
      ENDIF
   ENDIF
   @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
   RETURN .T.
