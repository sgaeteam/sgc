*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_133                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Tabela de Cobrana                       ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 04/10/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

*SELECT 2
*IF !NetUse("SOCIOS")
*   DBCLOSEALL(); RETURN
*ENDIF

SELECT 1
IF NetUse("COBRANCA")
   SET INDEX TO DBICOBR1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("GC133")
cOpHelp1 := "1"
cOpHelp2 := "30"

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
AP133_0()
SETKEY(K_F4,{|| Calculadora(calc_lin,calc_col,YCORMENU)})
SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cadastrar Locais de Cobrana ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE AP133_0()
   LOCAL tela := SAVESCREEN(2,0,24,79)
   LOCAL aCab[2], aCam[2], aPic[2]

   Area_Dados()
   LinhaMsg(4)

   aCab[1] := "Cขdigo"
   aCab[2] := "Local de Cobrana"
   *
   aCam[1] := "CODLOCAL"
   aCam[2] := "DESCR"
   *
   aPic[1] := "99"
   aPic[2] := "@!"
   msg     := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
   *
   Browser(1,1,6,3,16,75,aCab,aCam,aPic,.T.,.T.,"Cobrana",msg)
   RESTSCREEN(2,0,24,79,tela)
   RETURN
