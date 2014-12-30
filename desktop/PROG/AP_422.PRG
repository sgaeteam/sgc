*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AP_422                           vrs 001 ³
*³ VRS 001        : Desenvolvimento                          ³
*³ FINALIDADE     : Restaurar Arquivos do Disquete           ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ³
*³ DATA CRIACAO   : 07/03/1994                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

LOCAL tela := SAVESCREEN(2,0,24,79), cor := SETCOLOR()

Area_Dados()
Quadro(4,10,20,70,1,YCOREDIT,.T.,"Restaura‡„o de Arquivos",.T.)
ProgName("AP422")

// Tela de Apresenta‡„o
SETCOLOR(YCOREDIT)
DiskInfo("Origem")

nNumDrv := NumDrive()
IF nNumDrv > 2
   nNumDrv := 2
ENDIF

WHILE .T.
   IF nNumDrv = 2
      Mensagem("Selecione a unidade Origem")
      @ 08,13 PROMPT " A: " MESSAGE Msg("Restaura … partir da Unidade A:")
      @ 08,17 PROMPT " B: " MESSAGE Msg("Restaura … partir da Unidade B:")
      MENU TO nMenu_5c

      IF nMenu_5c = 0
         RESTSCREEN(2,0,24,79,tela)
         SETCOLOR(cor)
         RETURN
      ENDIF
      
      DO CASE
         CASE nMenu_5c = 1
              @ 08,13 SAY " A: " COLOR YCORREALCE
              cDrive := "A:"
         CASE nMenu_5c = 2
              @ 08,17 SAY " B: " COLOR YCORREALCE
              cDrive := "B:"
      ENDCASE
   ELSE
      @ 08,13 SAY " A: " COLOR YCORREALCE
      cDrive   := "A:"
      nMenu_5c := 1
   ENDIF
   @ 09,67 SAY SUBSTR(cDrive,1,1) COLOR YCORREALCE
   @ 13,67 SAY "C"                COLOR YCORREALCE

   // Identificar diretorio fonte
*  cDirFonte := CURDIR()+"\"

   // Calcular o tamanho da unidade de leitura
   xTamUnid := VerFormDisk(cDrive)
   IF VALTYPE(xTamUnid) == "L"
      INKEY(0)
      IF LASTKEY()==K_ESC
         DBCLOSEALL()
         RESTSCREEN(2,0,24,79,tela)
         SETCOLOR(cor)
         RETURN
      ENDIF
   ELSE
      @ VAL(SUBSTR(xTamUnid,1,2)),13 SAY SUBSTR(xTamUnid,3) COLOR YCORREALCE
      EXIT
   ENDIF
ENDDO
Mensagem("Preparando arquivos para para Estat¡stica...")
DBCLOSEALL()

// Flag para testar restaura‡„o realizada ou bem sucedida
lOk := .F.

// Verificar se existem arquivos DBF no disquete origem
nQtdeArqs := ADIR(cDrive+"*.DBF")

IF nQtdeArqs > 0
   // Calcular espa‡o livre no winchester
   nSpaceTotDisk := nTamDisk := DISKSPACE(3)
   nSpaceUsoDisk := (INT(nSpaceTotDisk/1024)-50) * 1024

   // Calcular espa‡o utilizado pelos arqs DBF encontrados no disquete origem
   DECLARE aNomeArq[nQtdeArqs]
   DECLARE aTamArq[nQtdeArqs]
   DECLARE aDataArq[nQtdeArqs]
   ADIR(cDrive+"*.DBF",aNomeArq,aTamArq,aDataArq)

   nArqCopiados  := nTamRest := nArqVazio := 0
   nDiskCopiados := 1
   dUltData      := CTOD(SPACE(8))
   nIndiceUsoArq := 300/nSpaceUsoDisk

   FOR i = 1 TO nQtdeArqs
       nTamRest       += aTamArq[i]
       nIndiceUsoArq  += aTamArq[i]/nSpaceUsoDisk + 40/nSpaceUsoDisk
       dUltData       := MAX(aDataArq[i],dUltdata)
       IF nIndiceUsoArq > 1
          aMacroAux   := aNomeArq[i]
          USE (cDrive+aMacroAux)
          WHILE nIndiceUsoArq > 1
             nIndiceUsoArq := nIndiceUsoArq - 1 + HEADER()/nSpaceUsoDisk + 300/nSpaceUsoDisk
          ENDDO
       ENDIF
   NEXT
   nArqsLidos := ALLTRIM(STR(nQtdeArqs,2))
   nSpacPrev  := TRANSFORM(nTamRest,"@E 99,999,999")
   dUltData   := DTOC(dUltData)

   @ 08,59 SAY nArqsLidos COLOR YCORREALCE
   @ 09,50 SAY nSpacPrev  COLOR YCORREALCE
   @ 10,50 SAY dUltData   COLOR YCORREALCE

   IF Confirma("ATEN€ŽO! Ser„o substitu¡dos TODOS os dados do destino. Continua ?")
      WHILE .T.
         Mensagem("Insira o disquete no drive "+cDrive+" e tecle Í¾ quando pronto.")
         INKEY(0)

         IF LASTKEY() == K_ESC
            Beep(1)
            Mensagem("Restaura‡„o cancelada pelo Usu rio! Tecle algo...")
            INKEY(0)
            DBCLOSEALL()
            RESTSCREEN(2,0,24,79,tela)
            RETURN
         ENDIF

         lPronto := CheckDrive(cDrive)
         IF lPronto
            LinhaMsg(6)
            @ 12,59 SAY ALLTRIM(STR(nArqCopiados,2))   COLOR YCORREALCE
            @ 13,49 SAY nTamDisk PICT "@E 999,999,999" COLOR YCORREALCE
            @ 14,58 SAY STRZERO(nDiskCopiados,2)       COLOR YCORREALCE
            @ 16,26 SAY "Lendo Arquivo        "
            @ 18,12 SAY "Percentual : "
            @ 19,12 SAY "Ocorrˆncias: "
            FOR i = 1 TO nQtdeArqs
                aMacroAux := aNomeArq[i]
                SELECT 1
                USE (cDrive+aMacroAux)
                @ 16,52 SAY SPACE(12)
                @ 16,52 SAY aMacroAux COLOR YCORREALCE

*               nNivelErro := CopyFile(cDrive+aMacroAux,cDirFonte+aMacroAux,"C:")
                nNivelErro := CopyFile(cDrive+aMacroAux,aMacroAux)
                Percentual(i,nQtdeArqs)

                nTamDisk := DISKSPACE(3)
                @ 13,49 SAY nTamDisk PICT "@E 999,999,999" COLOR YCORREALCE
                Mensagem()

                IF nNivelErro = 0       /* Arquivo vazio */
                   nArqVazio++
                ELSEIF nNivelErro = 1   /* Copia normal */
                   nArqCopiados++
                   @ 12,59 SAY ALLTRIM(STR(nArqCopiados,2)) COLOR YCORREALCE
                ELSEIF nNivelErro = 2   /* Mudan‡a de disco */
                   nDiskCopiados++
                   @ 14,58 SAY STRZERO(nDiskCopiados,2) COLOR YCORREALCE
                ELSEIF nNivelErro = 3   /* Erro na leitura/grava‡„o */
                   i--
                ELSEIF nNivelErro = 4   /* Tecla ESC pressionada */
                   CLEAR TYPEAHEAD
                   lPronto := .F.
                   EXIT
                ENDIF
            NEXT
            IF nArqVazio = nQtdeArqs
               nDiskCopiados := 0
               Beep(1)
               Mensagem("Nenhum Arquivo copiado. Tecle algo...")
            ELSE
               IF !lPronto
                  Beep(1)
                  Mensagem("Restaura‡„o cancelada pelo Usu rio! Tecle algo...")
               ELSE
                  lOk := .T.
                  Beep(2)
                  Mensagem("C¢pia conclu¡da com Sucesso. Tecle algo...")
               ENDIF
            ENDIF
            INKEY(0)
            EXIT
         ELSE
            Aviso("Drive NŽO est  pronto. Tecle algo...")
         ENDIF
      ENDDO
   ENDIF
ELSE
   Aviso("Nenhum arquivo Banco de Dados encontrado! Tecle algo...")
ENDIF
DBCLOSEALL()
RESTSCREEN(2,0,24,79,tela)
IF lOk ; OrgArq() ; ENDIF    /* Recriar Indices */
SETCOLOR(cor)
RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Verificar Formato do Disco   ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION VerFormDisk(pDrive)
   lPronto := CheckDrive(pDrive)
   IF lPronto
      nQtdeArqs := ADIR(pDrive+"*.*")
      nSomaArqs := 0
      IF nQtdeArqs > 0
         DECLARE aTamArq[nQtdeArqs]
         ADIR(pDrive+"*.*",,aTamArq)
         FOR i = 1 TO nQtdeArqs
             nSomaArqs += aTamArq[i]
         NEXT
      ENDIF
      nTamDisk := DISKSPACE(IF(pDrive="A:",1,2)) + nSomaArqs

      IF nTamDisk < 370000  ; cTam := "13  360Kb "  ; ENDIF
      IF nTamDisk > 370000  ; cTam := "14  720Kb "  ; ENDIF
      IF nTamDisk > 7400000 ; cTam := "15  1.2Kb "  ; ENDIF
      IF nTamDisk > 1220000 ; cTam := "16 1.44Kb "  ; ENDIF

      RETURN(cTam)
   ELSE
      Aviso("Drive NŽO est  pronto, verificar. Tecle algo...")
      RETURN .F.
   ENDIF
