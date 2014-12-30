*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_COR                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Configurar Cores de todo o Sistema       ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 21/01/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

FUNCTION ConfigCores(arq,prg)
   LOCAL cTela := SAVESCREEN(2,0,24,79), cCorant := SETCOLOR()
   PUBLIC zcoredit, zcorbarra, zcorgeral, zcormenu, zcoredit2
   PUBLIC aCorVert[16], aCorHoriz[16], aTab_Cores
   PUBLIC lAlt_Edit := lAlt_Menu := .F.

   aTab_Cores := {"N  ","B  ","G  ","BG ","R  ","RB ","GR ","W  ",;
                  "N+ ","B+ ","G+ ","BG+","R+ ","RB+","GR+","W+ " }

   USE (arq) NEW

   zcormenu  := RTRIM(_FIELD->CORMENU)
   zcorgeral := RTRIM(_FIELD->CORGERAL)
   zcoredit  := RTRIM(_FIELD->COREDIT)
   zcoredit2 := SUBSTR(_FIELD->COREDIT,9,7)
   zcorbarra := RTRIM(_FIELD->CORBARRA)

   IF prg # NIL
      ProgName(prg)
   ENDIF
   Area_Dados()

   Quadro(3,11,16,75,1,YCOREDIT,,"Verificando Cores",.T.)
   Q_Geral()
   Q_Edic()
   C_Edic()
   Q_Menu()
   Q_Barra()
   SETCOLOR("")
   FOR x = 4 TO 19
       cCor := STR(x-4,2)
       @ x,5 SAY "ÛÛÛ" COLOR "&cCor./&cCor."
       aCorVert[x-3] := "&cCor."
   NEXT
   nCor := 0
   FOR x := 20 TO 66 STEP 3
       cCor := STR(nCor,2)
       @ 20,x SAY "ÛÛÛ" COLOR "&cCor./&cCor."
       nCor++
       aCorHoriz[nCor] := "&cCor."
   NEXT

   PRIVATE aLin[5], aCol[5]
   aCol[1] := aCol[3] := 11
   aCol[2] := 12
   aCol[4] := 19
   aCol[5] := 40
   *
   aLin[1] := aLin[2] := 4
   aLin[3] := 7
   aLin[4] := aLin[5] := 9
   nPos    := 1
   WHILE .T.
      LinhaMsg(3)
      cTela1 := SAVESCREEN(aLin[nPos],aCol[nPos],aLin[nPos],aCol[nPos]+1)
      @ aLin[nPos],aCol[nPos] SAY CHR(26) COLOR "W+/N*"
      Pesq_Msg(nPos)
      tecla := INKEY(0)
      WHILE tecla # K_ENTER
         IF tecla == K_UP
            RESTSCREEN(aLin[nPos],aCol[nPos],aLin[nPos],aCol[nPos]+1,cTela1)
            IF(nPos==1,nPos:=5,nPos--)
            cTela1 := SAVESCREEN(aLin[nPos],aCol[nPos],aLin[nPos],aCol[nPos]+1)
            @ aLin[nPos],aCol[nPos] SAY CHR(26) COLOR "W+/N*"
            Pesq_Msg(nPos)
         ELSEIF tecla == K_DOWN
            RESTSCREEN(aLin[nPos],aCol[nPos],aLin[nPos],aCol[nPos]+1,cTela1)
            IF(nPos==5,nPos:=1,nPos++)
            cTela1 := SAVESCREEN(aLin[nPos],aCol[nPos],aLin[nPos],aCol[nPos]+1)
            @ aLin[nPos],aCol[nPos] SAY CHR(26) COLOR "W+/N*"
            Pesq_Msg(nPos)
         ELSEIF tecla == K_ESC
            IF Confirma("Grava Altera”es ?",.T.)
               lAlt_Cor := .T.
               IF lAlt_Edit
                  zcoredit := SUBSTR(zcoredit,1,7)+","+;
                              SUBSTR(zcoredit2,1,7)+",,,"+;
                              SUBSTR(zcoredit2,1,3)+"/"+;
                              SUBSTR(zcoredit,5,3)
               ELSE
                  nTamedit := LEN(zcoredit)
                  zcoredit := SUBSTR(zcoredit,1,15)+",,,"+;
                              SUBSTR(zcoredit,19,3)+"/"+;
                              SUBSTR(zcoredit,23,3)
               ENDIF
               IF lAlt_Menu
                  zcormenu := SUBSTR(zcormenu,1,7)+","+SUBSTR(zcorbarra,1,7)
               ELSE
                  zcormenu := SUBSTR(zcormenu,1,7)+","+SUBSTR(YCORMENU,9,7)
               ENDIF
               IF NetLReg()
                  REPLACE _FIELD->CORMENU   WITH zcormenu,;
                          _FIELD->CORBARRA  WITH zcorbarra,;
                          _FIELD->CORGERAL  WITH zcorgeral,;
                          _FIELD->COREDIT   WITH zcoredit,;
                          _FIELD->CORTECLAS WITH SUBSTR(YCORTECLAS,1,4)+SUBSTR(zcormenu,5,3),;
                          _FIELD->CORREALCE WITH SUBSTR(YCORREALCE,1,4)+SUBSTR(zcoredit,5,3)
                  DBCOMMITALL()
                  YCORMENU   := zcormenu
                  YCORBARRA  := zcorbarra
                  YCOREDIT   := zcoredit
                  YCORGERAL  := zcorgeral
                  YCORTECLAS := _FIELD->CORTECLAS
                  YCORREALCE := _FIELD->CORREALCE
               ENDIF
            ELSE
               lAlt_Cor := .F.
               SETCOLOR(cCorant)
               RESTSCREEN(2,0,24,79,cTela)
            ENDIF
            RELEASE zcoredit,zcoredit2,zcorbarra,zcorgeral,zcormenu,aTab_Cores,;
                    aCorHoriz,aCorVert, lAlt_Edit, lAlt_Menu
            DBCLOSEALL()
            RETURN(lAlt_Cor)
         ENDIF
         tecla := INKEY(0)
      ENDDO
      RESTSCREEN(aLin[nPos],aCol[nPos],aLin[nPos],aCol[nPos]+1,cTela1)
      DO CASE
         CASE nPos == 1
              Pesq_Cor(nPos,zcormenu)
         CASE nPos == 2
              zCor_Ant := zcorbarra
              Pesq_Cor(nPos,zcorbarra)
              IF zcorbarra # zCor_Ant ; lAlt_Menu := .T. ; ENDIF
         CASE nPos == 3
              Pesq_Cor(nPos,zcorgeral)
         CASE nPos == 4
              Pesq_Cor(nPos,zcoredit)
         CASE nPos == 5
              zCor_Ant := zcoredit2
              Pesq_Cor(nPos,zcoredit2)
              IF zcorbarra # zCor_Ant ; lAlt_Edit := .T. ; ENDIF
      ENDCASE
   ENDDO
   RELEASE zcoredit, zcoredit2, zcorbarra, zcorgeral, zcormenu, aTab_Cores,;
           aCorHoriz, aCorVert, lAlt_Edit, lAlt_Menu
   SETCOLOR(cCorant)
   RESTSCREEN(2,0,24,79,cTela)
   DBCLOSEALL()
   RETURN(lAlt_Cor)
*ีออออออออออออออออออออออออออออออธ
*ณ Pesquisa de Mensagem         ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Pesq_Msg(pPos)
   SETCOLOR(zcormenu)
   IF pPos == 1
      Mensagem("Cor do Menu")
   ELSEIF pPos == 2
      Mensagem("Cor da Barra de Seleo")
   ELSEIF pPos == 3
      Mensagem("Cor do Quadro Geral")
   ELSEIF pPos == 4
      Mensagem("Cor do Quadro de Edio")
   ELSEIF pPos == 5
      Mensagem("Cor dos Campos de Edio")
   ENDIF
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Localiza Vetor das Cores     ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Pesq_Cor(pPos,pCor)
   LOCAL nPosV, nPosH, tecla
   PRIVATE aLinV[16], aColH[16]

   FOR x = 4 TO 19
       aLinV[x-3] := x
   NEXT
   nElem := 1
   FOR x = 20 TO 66 STEP 3
       aColH[nElem] := x + 1
       nElem++
   NEXT

   nPosV  := ASCAN(aTab_Cores,SUBSTR(pCor,1,3))
   nPosH  := ASCAN(aTab_Cores,SUBSTR(pCor,5,3))

   cTela1 := SAVESCREEN(aLinV[nPosV],6,aLinV[nPosV],7)
   cTela2 := SAVESCREEN(20,aColH[nPosH],20,aColH[nPosH]+1)

   LinhaMsg(5)

   @ aLinV[nPosV],6  SAY CHR(254) COLOR "W+/"+aCorVert[nPosV]
   @ 20,aColH[nPosH] SAY CHR(254) COLOR "W+/"+aCorHoriz[nPosH]
   tecla := INKEY(0)
   WHILE tecla # K_ENTER
      IF tecla == K_UP
         RESTSCREEN(aLinV[nPosV],6,aLinV[nPosV],7,cTela1)
         IF(nPosV==1,nPosV:=16,nPosV--)
         cTela1 := SAVESCREEN(aLinV[nPosV],6,aLinV[nPosV],7)
         @ aLinV[nPosV],6 SAY CHR(254) COLOR "W+/"+aCorVert[nPosV]
         Muda_Cor(nPosV,nPosH,pPos,pCor)
      ELSEIF tecla == K_DOWN
         RESTSCREEN(aLinV[nPosV],6,aLinV[nPosV],7,cTela1)
          IF(nPosV==16,nPosV:=1,nPosV++)
         cTela1 := SAVESCREEN(aLinV[nPosV],6,aLinV[nPosV],7)
         @ aLinV[nPosV],6 SAY CHR(254) COLOR "W+/"+aCorVert[nPosV]
         Muda_Cor(nPosV,nPosH,pPos,pCor)
      ELSEIF tecla == K_LEFT
         RESTSCREEN(20,aColH[nPosH],20,aColH[nPosH]+1,cTela2)
         IF(nPosH==1,nPosH:=16,nPosH--)
         cTela2 := SAVESCREEN(20,aColH[nPosH],20,aColH[nPosH]+1)
         @ 20,aColH[nPosH] SAY CHR(254) COLOR "W+/"+aCorHoriz[nPosH]
         Muda_Cor(nPosV,nPosH,pPos,pCor)
      ELSEIF tecla == K_RIGHT
         RESTSCREEN(20,aColH[nPosH],20,aColH[nPosH]+1,cTela2)
         IF(nPosH==16,nPosH:=1,nPosH++)
         cTela2 := SAVESCREEN(20,aColH[nPosH],20,aColH[nPosH]+1)
         @ 20,aColH[nPosH] SAY CHR(254) COLOR "W+/"+aCorHoriz[nPosH]
         Muda_Cor(nPosV,nPosH,pPos,pCor)
      ELSEIF tecla == K_ESC
         RESTSCREEN(aLinV[nPosV],6,aLinV[nPosV],7,cTela1)
         RESTSCREEN(20,aColH[nPosH],20,aColH[nPosH]+1,cTela2)
         RETURN NIL
      ENDIF
      tecla := INKEY(0)
   ENDDO
   RESTSCREEN(aLinV[nPosV],6,aLinV[nPosV],7,cTela1)
   RESTSCREEN(20,aColH[nPosH],20,aColH[nPosH]+1,cTela2)
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Mudar Cores - Letra e Fundo  ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Muda_Cor(nPosV,nPosH,pPos,pCor)
   IF pPos == 1
      zcormenu := Converte_Cor(aCorVert[nPosV])+"/"+;
                  Converte_Cor(aCorHoriz[nPosH])
      Q_Menu()
   ELSEIF pPos == 2
      zcorbarra := Converte_Cor(aCorVert[nPosV])+"/"+;
                   Converte_Cor(aCorHoriz[nPosH])
      Q_Barra()
   ELSEIF pPos == 3
      zcorgeral := Converte_Cor(aCorVert[nPosV])+"/"+;
                   Converte_Cor(aCorHoriz[nPosH])
      Q_Geral()
   ELSEIF pPos == 4
      zcoredit := Converte_Cor(aCorVert[nPosV])+"/"+;
                  Converte_Cor(aCorHoriz[nPosH])
      Q_Edic()
      zcoredit := zcoredit+","+zcoredit2
   ELSEIF pPos == 5
      zcoredit2 := Converte_Cor(aCorVert[nPosV])+"/"+;
                   Converte_Cor(aCorHoriz[nPosH])
      C_Edic()
   ENDIF
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Converter Numero da Cor      ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Converte_Cor(nCor)
   IF nCor == " 0"
      cCor := "N  "
   ELSEIF nCor == " 1"
      cCor := "B  "
   ELSEIF nCor == " 2"
      cCor := "G  "
   ELSEIF nCor == " 3"
      cCor := "BG "
   ELSEIF nCor == " 4"
      cCor := "R  "
   ELSEIF nCor == " 5"
      cCor := "RB "
   ELSEIF nCor == " 6"
      cCor := "GR "
   ELSEIF nCor == " 7"
      cCor := "W  "
   ELSEIF nCor == " 8"
      cCor := "N+ "
   ELSEIF nCor == " 9"
      cCor := "B+ "
   ELSEIF nCor == "10"
      cCor := "G+ "
   ELSEIF nCor == "11"
      cCor := "BG+"
   ELSEIF nCor == "12"
      cCor := "R+ "
   ELSEIF nCor == "13"
      cCor := "RB+"
   ELSEIF nCor == "14"
      cCor := "GR+"
   ELSEIF nCor == "15"
      cCor := "W+ "
   ENDIF
   RETURN(cCor)
*ีออออออออออออออออออออออออออออออธ
*ณ Quadro de Edio             ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Q_Edic()
   Quadro(8,20,10,62,1,zcoredit,,"Quadro de Edio")
   Quadro(3,4,20,8,1,zcoredit,,,.T.)
   Quadro(19,19,21,68,1,zcoredit,,,.T.)
   @ 09,21 SAY "  Teste de Edio   "   COLOR zcoredit
*ีออออออออออออออออออออออออออออออธ
*ณ Campos de Edio             ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE C_Edic()
   @ 09,41 SAY "   Teste de Letra    " COLOR zcoredit2
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cor do Menu                  ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Q_Menu()
   @ 04,12 SAY " " COLOR zcormenu
   @ 04,22 SAY "     Opo B      Opo C      Opo D      Opo E  " COLOR zcormenu
   @ 15,12 SAY "             Espao reservado para mensagens                   " COLOR zcormenu
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cor da Barra de Seleo      ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Q_Barra()
   @ 04,13 SAY " Opo A " COLOR zcorbarra
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cor do Fundo - Box           ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Q_Geral()
   @ 05,12,7,74  BOX "ฐฐฐฐฐฐฐฐฐ" COLOR zcorgeral
   @ 08,12,10,19 BOX "ฐฐฐฐฐฐฐฐฐ" COLOR zcorgeral
   @ 08,63,10,74 BOX "ฐฐฐฐฐฐฐฐฐ" COLOR zcorgeral
   @ 11,12,14,74 BOX "ฐฐฐฐฐฐฐฐฐ" COLOR zcorgeral
   RETURN
