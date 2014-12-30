*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_136                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Tabela de Areas de Competencia           ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 17/01/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

SELECT 2
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA8,DBISOCA9
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("AREAC")
   SET INDEX TO DBIAREA1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("GC136")
cOpHelp1 := "1"; cOpHelp2 := "30"

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
AP136_0()
SETKEY(K_F4,{|| Calculadora(calc_lin,calc_col,YCORMENU)})
SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
DBCLOSEALL(); RETURN
*ีอออออออออออออออออออออออออออออออออออออธ
*ณ Cadastrar Areas de Competencia      ณ
*ิอออออออออออออออออออออออออออออออออออออพ
PROCEDURE AP136_0()
   LOCAL tela := SAVESCREEN(2,0,24,79)
   LOCAL aCab[2], aCam[2], aPic[2]

   Area_Dados()
   LinhaMsg(4)

   aCab[1] := "Area"
   aCab[2] := "Descrio"
   *
   aCam[1] := "AREACOMP"
   aCam[2] := "DESCR"
   *
   aPic[1] := "@!"
   aPic[2] := "@!"
   msg     := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
   *
   Browser(1,1,6,3,16,75,aCab,aCam,aPic,.T.,.T.,"Areas de Competncia",msg)
   RESTSCREEN(2,0,24,79,tela)
   RETURN
