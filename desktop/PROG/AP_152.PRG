*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_152                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Cadastrar Niveis de Acesso               ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 27/08/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

SELECT 1
IF NetUse("USUARIO.SYS","USER")
   SET INDEX TO USUARIO
ELSE
   DBCLOSEALL()
   RETURN
ENDIF

cPrg := "AP152"
ProgName(cPrg)

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
AP152_0()
SETKEY(K_F4,{|| Calculadora(calc_lin,calc_col,YCORMENU)})
SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Acesso Usuarios "Masters"    ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE AP152_0()
   LOCAL tela := SAVESCREEN(2,0,24,79)
   LOCAL aCab[3], aCam[3], aPic[3]

   Area_Dados()
   LinhaMsg(4)

   aCab[1] := "Chave"
   aCab[2] := "Usu rio"
   aCab[3] := "Nกvel"
   *
   aCam[1] := "CHAVE"
   aCam[2] := "USUARIO"
   aCam[3] := "NIVEL"
   *
   aPic[1] := "@!"
   aPic[2] := "@!"
   aPic[3] := "9"
   msg     := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
   *
   Browser(1,1,6,3,16,75,aCab,aCam,aPic,.T.,.T.,"Nกveis de Acesso",msg)
   RESTSCREEN(2,0,24,79,tela)
   RETURN
