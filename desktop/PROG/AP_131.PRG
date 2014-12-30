*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_131                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Tabela de Categorias                     ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 24/09/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
DBCLOSEALL()

SELECT 3
IF NetUse("MUDAPG")
   SET INDEX TO DBIMUDA1
ELSE
   DBCLOSEALL()
   RETURN
ENDIF

SELECT 2
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA1,DBISOCA2,DBISOCA3,DBISOCA4,DBISOCA5,DBISOCA6,DBISOCA7,DBISOCA8
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("CATEG")
   SET INDEX TO DBICATE1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("GC131")
cOpHelp1 := "1"; cOpHelp2 := "30"

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
AP131_0()
SETKEY(K_F4,{|| Calculadora(calc_lin,calc_col,YCORMENU)})
SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cadastrar Prazos de Eventos  ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE AP131_0()
   LOCAL tela := SAVESCREEN(2,0,24,79)
   LOCAL aCab[3], aCam[3], aPic[3]

   Area_Dados()
   LinhaMsg(4)

   aCab[1] := "Categ."
   aCab[2] := "Descrio"
   aCab[3] := "Mensalidade"
   *
   aCam[1] := "CODCAT"
   aCam[2] := "DESCR"
   aCam[3] := "MENSALID"
   *
   aPic[1] := "99"
   aPic[2] := "@!"
   aPic[3] := "@E 999,999,999.99"
   msg     := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
   *
   Browser(1,1,6,3,16,75,aCab,aCam,aPic,.T.,.T.,"Categorias",msg)
   RESTSCREEN(2,0,24,79,tela)
   RETURN
