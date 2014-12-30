*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_333                           vrs 001 ณ
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

SELECT 5
IF NetUse("SOCIOSI")
   SET INDEX TO DBISOCI2,DBISOCI1,DBISOCI3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2,DBISOCA1,DBISOCA3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("CATEG")
   SET INDEX TO DBICATE1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("PGSOC")
   SET INDEX TO DBIPGSO1, DBIPGSO3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SET KEY -1 TO Mostra()
ProgName("GC333")
SETCOLOR(YCOREDIT)
wAtIn:="A"
Telas(17,3,20,62,1,YCOREDIT,.T.)
WHILE .T.
   wNomeSoc:=wSoci:=SPACE(50)
   @ 18,05 SAY "Ativo, Inativo, Inexistente (A/I/X)" GET wAtIn PICT "!"  VALID wAtIn $ "AIX"
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; TeclaFuncao(); Rest_Tela(); EXIT; ENDIF

   IF wAtIn=="A"
      @ 19,05 SAY "Nome:" GET wNomeSoc PICT "@!" WHEN TeclaFuncao(.T.) VALID PTab(wNomeSoc,1,1,"Sขcio No Cadastrado")
   ELSEIF wAtIn=="I"
      @ 19,05 SAY "Nome:" GET wSoci    PICT "@!" WHEN TeclaFuncao(.T.) VALID PTab(wSoci,5,1,"Sขcio No Cadastrado")
   ELSEIF wAtIn=="X"
      @ 19,05 SAY "Nome:" GET wNomeSoc PICT "@!" WHEN .F.
   ENDIF
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF

   IF wAtIn=="X"
      Aguarde("Aguarde! Pesquisando...")
      /* Registros com socios inexistentes */
      SOCIOS->(DBSETORDER(2))
      SOCIOSI->(DBSETORDER(2))
      PGSOC->(DBGOTOP())
      wDtAdesao:=" "
      WHILE !PGSOC->(EOF())
         IF !SOCIOS->(DBSEEK(PGSOC->MATRICULA)).AND.!SOCIOSI->(DBSEEK(PGSOC->MATRICULA))
            /* Nao achou nem no ativo nem no inativo = inexistente */
            /* Ler matricula e gravar os pagamentos efetuados */
            wMatr:=PGSOC->MATRICULA
            Aguarde(); Aguarde("Gravando Registros...")
            WHILE PGSOC->MATRICULA==wMatr.AND.!PGSOC->(EOF())
               (cArq1)->(DBAPPEND())
               REPLACE (cArq1)->NOME      WITH "SOCIOS INEXISTENTES",;
                       (cArq1)->MATRICULA WITH PGSOC->MATRICULA     ,;
                       (cArq1)->RECIBO    WITH PGSOC->RECIBO        ,;
                       (cArq1)->MES       WITH SUBS(PGSOC->ANOMES,3),;
                       (cArq1)->ANO       WITH SUBS(PGSOC->ANOMES,1,2),;
                       (cArq1)->DTPAG     WITH PGSOC->DTPAG         ,;
                       (cArq1)->VALOR     WITH PGSOC->VALOR         ,;
                       (cArq1)->OBS       WITH PGSOC->OBS           ,;
                       (cArq1)->DOC       WITH PGSOC->DOC           ,;
                       (cArq1)->USUARIO   WITH PGSOC->USUARIO
               PGSOC->(DBSKIP())
            ENDDO
            Aguarde(); Aguarde("Aguarde! Pesquisando...")
         ENDIF
         PGSOC->(DBSKIP())
      ENDDO
      Aguarde()
      BrowLista()
   ELSE
      wMatr    := IF(wAtIn=="A",SOCIOS->MATRICULA,SOCIOSI->MATRICULA)
      wDtAdesao:= DTOC(IF(wAtIn=="A",SOCIOS->DTADESAO,SOCIOSI->DTADESAO))
      /* Montar arquivo temporario */
      IF !PGSOC->(DBSEEK(wMatr))
         Aviso("Nao foi encontrado pagamento deste socio...")
      ELSE
         Aguarde("Selecionando Registros...")
         WHILE PGSOC->MATRICULA==wMatr.AND.!PGSOC->(EOF())
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->NOME      WITH SOCIOS->NOME        ,;
                    (cArq1)->MATRICULA WITH PGSOC->MATRICULA    ,;
                    (cArq1)->RECIBO    WITH PGSOC->RECIBO       ,;
                    (cArq1)->MES       WITH SUBS(PGSOC->ANOMES,3),;
                    (cArq1)->ANO       WITH SUBS(PGSOC->ANOMES,1,2),;
                    (cArq1)->DTPAG     WITH PGSOC->DTPAG        ,;
                    (cArq1)->VALOR     WITH PGSOC->VALOR        ,;
                    (cArq1)->OBS       WITH PGSOC->OBS          ,;
                    (cArq1)->DOC       WITH PGSOC->DOC          ,;
                    (cArq1)->USUARIO   WITH PGSOC->USUARIO
            PGSOC->(DBSKIP())
         ENDDO
         Aguarde()
         BrowLista()
      ENDIF
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
   @ 04,02 SAY "Nome: "+IF(wAtIn=="A",wNomeSoc,wSoci)
   @ 05,02 SAY "Mat.: "+wMatr
   @ 05,30 SAY "Data Adesao: "+wDtAdesao
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
            ImpPgSoc()
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
STATIC PROCEDURE ImpPgSoc()
   LOCAL xTotal:=0.00
   SELECT (cArq1); DBGOTOP()
   Gera_TXT("AP333.TXT"); SETPRC(0,0)
   Cabec()
   WHILE !EOF()
      Compr_On()
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
   @ PROW()+1,01 SAY " TOTAL PAGO PELO SOCIO (R$)      ===>"
   @ PROW()  ,55 SAY xTotal PICT "@E 9,999,999.99"
   @ PROW()+1,00 SAY " "
   Compr_Off()
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp ap333.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE AP333.TXT

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
   @ PROW()+1,045 SAY "RELACAO DE PAGAMENTOS DE SOCIOS"
   @ PROW()+1,001 SAY "SOCIO: "+IF(wAtIn=="A",wNomeSoc,wSoci)
   @ PROW()+1,001 SAY "MATR.: "+wMatr
   @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
   @ PROW()+1,001 SAY "RECEBIDO POR     RECIBO MES/ANO REF.  DT.PGTO   DOC     VALOR R$   OBSERVACOES"
   @ PROW()+1,001 SAY "-------------------------------------------------------------------------------------------------------------------------------"
*                      XXXXXXXXXXxxxxx  99999     99/99      99/99/99  999999  999,999.99 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxx
*                      123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                               1         2         3         4         5         6         7         8         9        10        11        12        13
   RETURN
