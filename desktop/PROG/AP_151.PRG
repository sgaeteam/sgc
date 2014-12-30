*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_151                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Cadastrar Senhas de Acesso               ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 09/08/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

SELECT 1
IF NetUse("USUARIO.SYS","USER")
   SET INDEX TO USUARIO
ELSE
   DBCLOSEALL()
   RETURN
ENDIF

cPrg := "AP151"
ProgName(cPrg)

SETKEY(K_F4,NIL)
SETKEY(K_F5,NIL)
AP151_0()
SETKEY(K_F4,{|| Calculadora(calc_lin,calc_col,YCORMENU)})
SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Senhas Usuario Comum         ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE AP151_0()
   LOCAL tela := SAVESCREEN(2,0,24,79)
   LOCAL aCab[2], aCam[2], aPic[2]

   Area_Dados()
   LinhaMsg(4)

   aCab[1] := "Chave"
   aCab[2] := "Usu rio"
   *
   aCam[1] := "CHAVE"
   aCam[2] := "USUARIO"
   *
   aPic[1] := "@!"
   aPic[2] := "@!"
   msg     := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
   *
   IF nNivel==1
      Browser(1,1,6,3,16,75,aCab,aCam,aPic,.F.,.T.,"Usu rios/Senhas",msg)
   ELSE
      Browser(1,1,6,3,16,75,aCab,aCam,aPic,.T.,.T.,"Usu rios/Senhas",msg)
   ENDIF
   RESTSCREEN(2,0,24,79,tela)
   RETURN
