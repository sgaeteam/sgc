*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_134                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Tabela de Fun”es do Clube               ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 15/10/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

*SELECT 2
*IF !NetUse("SOCIOS")
*   DBCLOSEALL(); RETURN
*ENDIF

SELECT 1
IF NetUse("FUNC")
   SET INDEX TO DBIFUNC1,DBIFUNC2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("GC134")
cOpHelp1 := "1"; cOpHelp2 := "30"

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
AP134_0()
SETKEY(K_F4,{|| Calculadora(calc_lin,calc_col,YCORMENU)})
SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
DBCLOSEALL(); RETURN
*ีอออออออออออออออออออออออออออออออออออออธ
*ณ Cadastrar Funo existente no clube ณ
*ิอออออออออออออออออออออออออออออออออออออพ
PROCEDURE AP134_0()
   LOCAL tela := SAVESCREEN(2,0,24,79)
   LOCAL aCab[2], aCam[2], aPic[2]

   Area_Dados()
   LinhaMsg(4)

   aCab[1] := "Cขdigo"
   aCab[2] := "Descrio"
   *
   aCam[1] := "CODFUNC"
   aCam[2] := "DESCR"
   *
   aPic[1] := "99"
   aPic[2] := "@!"
   msg     := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
   *
   Browser(1,1,6,3,16,75,aCab,aCam,aPic,.T.,.T.,"Fun”es",msg)
   RESTSCREEN(2,0,24,79,tela)
   RETURN
