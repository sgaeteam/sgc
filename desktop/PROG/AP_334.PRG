*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_334                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Historico de Pagamentos de Socios        ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 20/04/1999                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PUBLIC nPg := 0

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"NOME"       ,"C",  5,0})
AADD(aDbf,{"MATRICULA"  ,"C",  5,0})
AADD(aDbf,{"ATIVIDADE"  ,"C", 50,0})
AADD(aDbf,{"RECIBO"     ,"C",  5,0})
AADD(aDbf,{"MES"        ,"C",  2,0})
AADD(aDbf,{"ANO"        ,"C",  2,0})
AADD(aDbf,{"DTPAG"      ,"D",  8,0})
AADD(aDbf,{"VALOR"      ,"N", 12,2})
AADD(aDbf,{"OBS"        ,"C", 60,0})
AADD(aDbf,{"DOC"        ,"C",  6,0})
AADD(aDbf,{"USUARIO"    ,"C", 15,0})
WHILE .T.
   sHour:=TIME()
   cArq1:="TM"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE(cArq1,aDbf); RELEASE aDbf; EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")
INDEX ON DTOS(DTPAG) TO (cArq1)

SELECT 3
IF NetUse("USUARIOS")
   SET INDEX TO DBIUSU1,DBIUSU2   //nome , matricula
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("ATIV")
   SET INDEX TO DBIATIV1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("PGUSU")
   SET INDEX TO DBIPGUS1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SET KEY -1 TO Mostra()
ProgName("GC334")
SETCOLOR(YCOREDIT)
Telas(18,3,20,65,1,YCOREDIT,.T.)
WHILE .T.
   wNomeUsu:=SPACE(50)
   @ 19,05 SAY "Usu rio:" GET wNomeUsu PICT "@!" WHEN TeclaFuncao(.T.) VALID PTab(wNomeUsu,3,1,"Usu rio No Cadastrado")
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF

   wMatr:= USUARIOS->MATRICULA
   IF !PGUSU->(DBSEEK(wMatr))
      Aviso("Nao foi encontrado pagamento deste usu rio...")
   ELSE
      Aguarde("Selecionando Registros...")
      WHILE PGUSU->MATRICULA==wMatr.AND.!PGUSU->(EOF())
         ATIV->(DBSEEK(PGUSU->ATIVIDADE))
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->NOME      WITH USUARIOS->NOME      ,;
                 (cArq1)->ATIVIDADE WITH ATIV->DESCR         ,;
                 (cArq1)->MATRICULA WITH PGUSU->MATRICULA    ,;
                 (cArq1)->RECIBO    WITH PGUSU->RECIBO       ,;
                 (cArq1)->MES       WITH SUBS(PGUSU->ANOMES,3),;
                 (cArq1)->ANO       WITH SUBS(PGUSU->ANOMES,1,2),;
                 (cArq1)->DTPAG     WITH PGUSU->DTPAG        ,;
                 (cArq1)->VALOR     WITH PGUSU->VALOR        ,;
                 (cArq1)->OBS       WITH PGUSU->OBS          ,;
                 (cArq1)->DOC       WITH PGUSU->DOC          ,;
                 (cArq1)->USUARIO   WITH PGUSU->USUARIO
         PGUSU->(DBSKIP())
      ENDDO
      Aguarde()
      BrowLista()
   ENDIF
   (cArq1)->(__DBZAP())
ENDDO
SETKEY(K_F2,NIL)
RELEASE nPg
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse dos Registros           ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowLista()
   LOCAL corant:=SETCOLOR(), oBr, oCol

   SELECT (cArq1); DBGOTOP()
   LinhaMsg(15); SETCOLOR(YCOREDIT)
   Telas(3,0,22,79,1,YCOREDIT,.F.,"Historico de Pagamentos")
   @ 04,02 SAY "Nome: "+wNomeUsu
   @ 05,02 SAY "Mat.: "+wMatr
   oBr:=TBROWSEDB(6,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "

   oCol:=TBCOLUMNNEW("Recebido por"   ,{|| USUARIO})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Recibo"         ,{|| RECIBO})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Mes/Ano"        ,{|| MES+"/"+ANO})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Dt.Pagto."      ,{|| DTPAG})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Doc."           ,{|| DOC})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Valor R$"       ,{|| TRANSFORM(VALOR,"@E 99,999.99")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Atividade"      ,{|| ATIVIDADE})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Observacoes"    ,{|| OBS})
   oBr:addColumn(oCol)

   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_F9 ) /* Imprimir */
         IF ChkImpr()
            lImp:=.F.
            cAviso := MsgImp(.F.)
            ImpPGUSU()
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impresso! Tecle algo...")
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela()
  RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Listagem            ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE ImpPGUSU()
   LOCAL xTotal:=0.00
   SELECT (cArq1); DBGOTOP()
   Gera_TXT("AP334.TXT"); SETPRC(0,0)
   Cabec()
   Compr_On(); xAtivAnt:=ATIVIDADE
   @ PROW()+1,01 SAY "ATIVIDADE =>" +ATIVIDADE
   WHILE !EOF()
      Compr_On()
      IF xAtivAnt#ATIVIDADE
         @ PROW()+1,01 SAY "-------------------------------------------------------------------------------------------------------------------------------"
         @ PROW()+1,01 SAY " TOTAL PAGO PELO USUARIO (R$)      ===>"
         @ PROW()  ,55 SAY xTotal PICT "@E 9,999,999.99"
         xTotal:=0.00; xAtivAnt:=ATIVIDADE
         @ PROW()+2,01 SAY "ATIVIDADE =>" +ATIVIDADE
      ENDIF
      @ PROW()+1,01 SAY USUARIO
      @ PROW()  ,18 SAY RECIBO
      @ PROW()  ,28 SAY MES+"/"+ANO
      @ PROW()  ,39 SAY DTPAG    PICT "@D"
      @ PROW()  ,49 SAY DOC      PICT "@!"
      @ PROW()  ,57 SAY VALOR    PICT "@E 999,999.99"
      @ PROW()  ,68 SAY OBS      PICT "@!S60"
      xTotal += VALOR
      DBSKIP()
      IF PROW() > 57
         @ PROW()+1,01 SAY "-------------------------------------------------------------------------------------------------------------------------------"
         EJECT; Cabec()
      ENDIF
   ENDDO
   @ PROW()+1,01 SAY "-------------------------------------------------------------------------------------------------------------------------------"
   @ PROW()+1,01 SAY " TOTAL PAGO PELO USUARIO (R$)      ===>"
   @ PROW()  ,55 SAY xTotal PICT "@E 9,999,999.99"
   @ PROW()+1,01 SAY " "
   Compr_Off()
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp ap334.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE AP334.TXT
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho do Relatorio       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Cabec()
   nPg++
   @ PROW()  ,001 SAY "Clube 2004"
   Compr_On()
   @ PROW()+1,110 SAY "Data:"+DTOC(DATE())
   @ PROW()+1,110 SAY "Pag.:"+STRZERO(nPg,2)
   @ PROW()+1,045 SAY "RELACAO DE PAGAMENTOS DE USUARIOS"
   @ PROW()+1,001 SAY "USUARIO: "+wNomeUsu
   @ PROW()+1,001 SAY "MATR.: "+wMatr
   @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
   @ PROW()+1,001 SAY "RECEBIDO POR     RECIBO MES/ANO REF.  DT.PGTO   DOC     VALOR R$   OBSERVACOES"
   @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
*                      XXXXXXXXXXxxxxx  99999     99/99      99/99/99  999999  999,999.99 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxx
*                      123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                               1         2         3         4         5         6         7         8         9        10        11        12        13
   RETURN
