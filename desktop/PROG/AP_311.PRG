*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_311                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Imprimir Cadastro Sขcios Estratificado   ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 17/10/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PROCEDURE AP_311(pOrdem)

LOCAL tela := SAVESCREEN(2,0,24,79), corant := SETCOLOR()
PUBLIC continua := .T., nPg := 0
PUBLIC wCliente, wTipo , wStatus, wCoord, wResp, wPEntr, wPApres, wDscr, wFuncao

SELECT 6
IF NetUse("UNIDADE")
   SET INDEX TO DBIUNID1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("COBRANCA")
   SET INDEX TO DBICOBR1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("CATEG")
   SET INDEX TO DBICATE1
ELSE
   DBCLOSEALL(); RETURN
ENDIF
 
SELECT 1
IF NetUse("SOCIOS")
   IF pOrdem==1
      SET INDEX TO DBISOCA2,DBISOCA1,DBISOCA3,DBISOCA4,DBISOCA5,DBISOCA6,DBISOCA7,DBISOCA8
   ELSE
      SET INDEX TO DBISOCA4,DBISOCA2,DBISOCA3,DBISOCA1,DBISOCA5,DBISOCA6,DBISOCA7,DBISOCA8
   ENDIF
ELSE
   DBCLOSEALL()
   RETURN
ENDIF

Area_Dados(); ProgName("GC311")

Quadro(7,15,18,62,1,YCOREDIT,.T.,"Relatขrio Sขcios ordem "+IF(pOrdem==1,"Nome","Matrกcula da Petrobras"),.T.)
wCat       := wCobranca := SPACE(2)
wLotacao   := SPACE(25)
wFuncao    := SPACE(20)
wBairro    := SPACE(15)
wUnidade   := SPACE(08)
wDtAdesIni := wDtAdesFim := CTOD("")
wNomeIni   := wNomeFim := SPACE(50)
wMatrIni   := wMatrFim := SPACE(8)

SET KEY -1 TO Mostra()
WHILE .T.
   SETCOLOR(YCOREDIT)
   SETCURSOR(1)
   Mensagem("Preencha os campos necess rios")
   IF pOrdem==2
      @ 08,17 SAY "Matric.Inic.:" GET wMatrIni PICT "99999999" WHEN TeclaFuncao(.T.)
      @ 09,17 SAY "Matric.Final:" GET wMatrFim PICT "99999999" WHEN TeclaFuncao(.T.)
   ELSE
      @ 08,17 SAY "Nome Inicial:" GET wNomeIni PICT "@!S30" WHEN TeclaFuncao(.T.)
      @ 09,17 SAY "Nome Final..:" GET wNomeFim PICT "@!S30" WHEN TeclaFuncao(.T.)
   ENDIF
   @ 10,17 SAY "Categoria...:" GET wCat       PICT "99" WHEN TeclaFuncao(.T.) VALID TCateg(10,35,wCat,"@!S10")
   @ 11,17 SAY "Unidade.....:" GET wUnidade   PICT "@!" WHEN TeclaFuncao(.T.) VALID TUnid(wUnidade)
   @ 12,17 SAY "Lotao.....:" GET wLotacao   PICT "@!" WHEN TeclaFuncao()
   @ 13,17 SAY "Funo......:" GET wFuncao    PICT "@!"
   @ 14,17 SAY "Bairro......:" GET wBairro    PICT "@!"
   @ 15,17 SAY "Adeso Inic.:" GET wDtAdesIni PICT "@D"
   @ 16,17 SAY "Adeso Final:" GET wDtAdesFim PICT "@D" WHEN TeclaFuncao() VALID wDtAdesFim >= wDtAdesIni
   @ 17,17 SAY "Cobrana....:" GET wCobranca  PICT "99" WHEN TeclaFuncao(.T.) VALID TCobra1(wCobranca)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC; EXIT; ENDIF

   SELECT SOCIOS
   cTCond:=xCond0:=xCond1:=xCond2:=xCond3:=xCond4:=xCond5:=xCond6:=xCond7:=xCond8:=xCond9:=""
   nSomaCond:=nPg:=0; ntotsele:=0

   // Filtrar os campos que foram preenchidos
   IF pOrdem==2
      IF !EMPTY(wMatrIni)
         xCond1 := "MATR2>=wMatrIni"
         nSomaCond++
      ENDIF
      IF !EMPTY(wMatrFim)
         xCond2 := "MATR2<=wMatrFim"
         nSomaCond++
      ENDIF
   ELSE
      IF !EMPTY(wNomeIni)
         xCond1 := "NOME>=wNomeIni"
         nSomaCond++
      ENDIF
      IF !EMPTY(wNomeFim)
         xCond2 := "NOME<=wNomeFim"
         nSomaCond++
      ENDIF
   ENDIF
   IF !EMPTY(wCat)
      xCond3 := "CATEGORIA==wCat"
      nSomaCond++
   ENDIF
   IF !EMPTY(wResp)
      xCond4 := "LOTACAO==wLotacao"
      nSomaCond++
   ELSE
      xCond4 := "ALLTRIM(LOTACAO)#[PETROS]"
      nSomaCond++
   ENDIF
   IF !EMPTY(wFuncao)
      xCond5 := "ALLTRIM(wFuncao) $ FUNCAO"
      nSomaCond++
   ENDIF
   IF !EMPTY(wBairro)
      xCond6 := "BAIRRO==wBairro"
      nSomaCond++
   ENDIF
   IF !EMPTY(wDtAdesIni)
      xCond7 := "DTADESAO>=wDtAdesIni"
      nSomaCond++
   ENDIF
   IF !EMPTY(wDtAdesFim)
      xCond8 := "DTADESAO<=wDtAdesFim"
      nSomaCond++
   ENDIF
   IF !EMPTY(wCobranca)
      xCond9 := "COBRANCA==wCobranca"
      nSomaCond++
   ENDIF
   IF !EMPTY(wUnidade)
      xCond0 := "UNIDADE==wUnidade"
      nSomaCond++
   ENDIF

   SETCURSOR(0)
   IF nSomaCond==0
      // Imprimir tudo
   ELSE
      // Gerar chave do Filtro
      FOR y = 0 TO 9
          nNum := STR(y,1)
          IF LEN(xCond&nNum.) > 0
             IF nSomaCond > 1
                cTCond += xCond&nNum. + " .AND. "
             ELSE
                cTCond += xCond&nNum.
             ENDIF
             nSomaCond--
          ENDIF
      NEXT
      Aguarde("Localizando os Registros...")
      SET FILTER TO &cTCond.
   ENDIF

   DBGOTOP()
   Aguarde()
   IF !EOF()
      IF ChkImpr()
         cAviso := MsgImp()
         ImpProv(pOrdem)
         TiraMsgImp(cAviso)
         WaitMsg("Fim de Impresso, tecle algo...")
      ENDIF
   ELSE
      Aviso("No h  dados para especifica”es acima, tecle algo...")
   ENDIF
   SET FILTER TO
   DBGOTOP()
ENDDO
SETCOLOR(corant)
RELEASE continua, nPg
RELEASE wCliente, wTipo , wStatus, wCoord, wResp, wPEntr, wPApres, wDscr
RESTSCREEN(2,0,24,79,tela)
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Ficha Cadastral     ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE ImpApl(pOrdem)
   Gera_TXT("AP311.TXT")
   SETPRC(0,0)
   lCabec := CabClube()
   WHILE !EOF() .AND. continua
      IF !lCabec
         lCabec := CabClube()
      ENDIF
      ChkInterv("CabClube",1,002,"NOME     :")
      ChkInterv("CabClube",0,013,NOME)
      ChkInterv("CabClube",0,065,"MATRICULA:")
      ChkInterv("CabClube",0,076,MATR2,"[99999999]")

      ChkInterv("CabClube",1,002,"CATEGORIA:")
      ChkInterv("CabClube",0,013,TCategoria(CATEGORIA),"[@!S20]")
      ChkInterv("CabClube",0,035,"LOTACAO :")
      ChkInterv("CabClube",0,045,LOTACAO,"[@!S20]")

      ChkInterv("CabClube",1,002,"FUNCAO   :")
      ChkInterv("CabClube",0,013,FUNCAO,"[@!]")
      ChkInterv("CabClube",0,035,"BAIRRO  :")
      ChkInterv("CabClube",0,045,BAIRRO,"[@!S15]")

      ChkInterv("CabClube",1,002,"ADESAO   :")
      ChkInterv("CabClube",0,013,DTADESAO,"[@D]")
      ChkInterv("CabClube",0,035,"COBRANCA:")
      ChkInterv("CabClube",0,045,TCobranca(COBRANCA),"[@!S20]")
      ChkInterv("CabClube",1,002,REPL("-",80))
      DBSKIP()
      IF PROW() >= 55
         lCabec := .F.
         EJECT
      ENDIF
   ENDDO
   IF continua
      @ 62,00 SAY "* * * Final de Relatorio * * *"
      EJECT
   ENDIF
   @ PROW()+1,05 SAY "SELECAO POR:"
   IF pOrdem==2
      @ PROW()+2,05 SAY "Matric.Inic.=> "  + wMatrIni
      @ PROW()  ,55 SAY "Matric.Final=> "  + wMatrFim
   ELSE
      @ PROW()+2,05 SAY "Nome Inicial=> "  + wNomeIni
      @ PROW()  ,55 SAY "Nome Final  => "  + wNomeFim
   ENDIF
   @ PROW()+1,05 SAY "Categoria   => "  + wCat
   @ PROW()  ,55 SAY "Unidade      => " + wUnidade
   @ PROW()  ,85 SAY "Lotacao  => "     + wLotacao
   @ PROW()+1,05 SAY "Funcao      => "  + wFuncao
   @ PROW()  ,55 SAY "Bairro       => " + wBairro
   @ PROW()+1,05 SAY "Adesao Inic.=> "  + DTOC(wDtAdesIni)
   @ PROW()  ,55 SAY "Adesao Final => " + DTOC(wDtAdesFim)
   @ PROW()  ,85 SAY "Cobranca => "     + wCobranca
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp ap311.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE AP311.TXT
   SET ORDER TO 0
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Ficha Cadastral     ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE ImpProv(pOrdem)
   Gera_TXT("AP311a.TXT")
   SETPRC(0,0)
   lCabec := CabClube()
   WHILE !EOF() .AND. continua
      IF !lCabec
         lCabec := CabClube()
      ENDIF
      ChkInterv("CabClube",1,02,STRZERO(++nTotSele,4))
      ChkInterv("CabClube",0,08,NOME,"[@S43]")
      ChkInterv("CabClube",0,52,MATR2,"[99999999]")
      ChkInterv("CabClube",0,63,LOTACAO,"[@S16]")

      DBSKIP()
      IF PROW() >= 58
         ChkInterv("CabClube",1,02,REPL("-",80))
         lCabec := .F.
         EJECT
      ENDIF
   ENDDO
   EJECT
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp ap311a.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE AP311a.TXT
   SET ORDER TO 0
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho do Relatorio       ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION CabClube()
   nPg++
   @ PROW()  ,001 SAY "CEPE-BA"
   @ PROW()+1,001 SAY "CLUBE DOS EMPREGADOS DA PETROBRAS"
   @ PROW()  ,064 SAY "Data:"+DTOC(DATE())
   @ PROW()+1,035 SAY "FICHA CADASTRAL"
   @ PROW()  ,064 SAY "Pag.:"+STRZERO(nPg,3)
   @ PROW()+1,001 SAY REPLICATE("=",79)
   @ PROW()+1,002 SAY "ORDEM NOME DO ASSOCIADO                           MATRICULA  LOTACAO"
*                      9999  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXX 99999999   XXXXXXXXXXXXXXXX
*                      2345678901234567890123456789012345678901234567890123456789012345678901234567890
*                              1         2         3         4         5         6         7         8
   @ PROW()+1,001 SAY REPLICATE("=",79)
   RETURN .T.

/* Lay-Out do Relatorio

   NOME     : XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX  MATRICULA: 9999999
   CATEGORIA: XXXXXXXXXXxxxxxxxxxx  LOTACAO : XXXXXXXXXXxxxxxxxxxxXXXXX
   FUNCAO   : XXXXXXXXXXxxxxxxxxxx  BAIRRO  : XXXXXxxxxxxxxxx
   ADESAO   : 99/99/99              COBRANCA: XXXXXXXXXXxxxxxxxxxx"
*  2345678901234567890123456789012345678901234567890123456789012345678901234567890
*          1         2         3         4         5         6         7         8
*/
*ีออออออออออออออออออออออออออออออธ
*ณ Validar Categoria            ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TCategoria(wCat)
   LOCAL cArq:=SELECT()
   SELECT CATEG
   IF !DBSEEK(wCat)
      SELECT(cArq)
      RETURN ""
   ELSE
      SELECT(cArq)
      RETURN(CATEG->DESCR)
   ENDIF
*ีออออออออออออออออออออออออออออออธ
*ณ Validar Cobrana             ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TCobranca(wCobra)
   LOCAL cArq:=SELECT()
   SELECT COBRANCA
   IF !DBSEEK(wCobra)
      SELECT(cArq)
      RETURN ""
   ELSE
      SELECT(cArq)
      RETURN(COBRANCA->DESCR)
   ENDIF
