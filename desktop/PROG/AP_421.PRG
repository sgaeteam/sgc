*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AP_421                           vrs 001 ³
*³ VRS 001        : Desenvolvimento                          ³
*³ FINALIDADE     : Copiar Arquivos do Sistema               ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ³
*³ DATA CRIACAO   : 03/03/1994                               ³
*³ ATUALIZACAO    : 25/02/1994                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

LOCAL  tela := SAVESCREEN(2,0,24,79), cor := SETCOLOR()

PUBLIC nTamDisk, nTamanho, nArqVazio
PUBLIC aFormato := { {"  360Kb ", 360000},;
                     {"  720Kb ", 720000},;
                     {"  1.2Kb ",1200000},;
                     {" 1.44Kb ",1400000} }

Area_Dados()
Quadro(4,10,20,70,1,YCOREDIT,.T.,"C¢pias de Seguran‡a",.T.)
ProgName("AP421")

SETCOLOR(YCOREDIT)
DiskInfo("Destino")   /* Tela de Apresenta‡„o */
nNumDrv := NumDrive()
IF nNumDrv > 2
   nNumDrv := 2
ENDIF

WHILE .T.
   IF nNumDrv = 2
      Mensagem("Selecione a unidade destino")
      @ 08,13 PROMPT " A: " MESSAGE Msg("Copia para Unidade A:")
      @ 08,17 PROMPT " B: " MESSAGE Msg("Copia para Unidade B:")
      MENU TO nMenu_5c

      IF nMenu_5c = 0
         RESTSCREEN(2,0,24,79,tela)
         RELEASE nTamDisk, nTamanho, aFormato, nArqVazio
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

   Mensagem("Informe o tamanho da Unidade "+IF(nMenu_5c=1,"A:","B:")+" Selecionada")
   @ 13,13 PROMPT aFormato[1,1] MESSAGE Msg("2F-HD")
   @ 14,13 PROMPT aFormato[2,1] MESSAGE Msg("MD2-HD,DS/DD")
   @ 15,13 PROMPT aFormato[3,1] MESSAGE Msg("2F-DD")
   @ 16,13 PROMPT aFormato[4,1] MESSAGE Msg("MD2-D,2F-2D")
   MENU TO nMenu_5d

   IF nMenu_5d = 0
      RESTSCREEN(2,0,24,79,tela)
      RELEASE nTamDisk, nTamanho, aFormato, nArqVazio
      RETURN
   ENDIF
   @ 09,67 SAY "C"                COLOR YCORREALCE
   @ 13,67 SAY SUBSTR(cDrive,1,1) COLOR YCORREALCE

   DO CASE
      CASE nMenu_5d = 4                                      /* 1.44K (1.423K)*/
           @ 16,13 SAY " 1.44Kb " COLOR YCORREALCE
           nSpaceTotDisk := 1457664  /* Espa‡o total do disco formatado */
           nSpaceUsoDisk := 1433600  /* Espa‡o que ser  utilizado */
           nQtdeArqs     := Estatistica(nSpaceUsoDisk,nSpaceTotDisk)
           IF VerTamDisk(cDrive,nSpaceTotDisk) ; EXIT ; ENDIF
           @ 16,13 SAY " 1.44Kb " COLOR YCOREDIT

      CASE nMenu_5d = 3                                      /* 1.2K (1.18K)*/
           @ 15,13 SAY "  1.2Kb " COLOR YCORREALCE
           nSpaceTotDisk := 1208320
           nSpaceUsoDisk := 1126400
           nQtdeArqs     := Estatistica(nSpaceUsoDisk,nSpaceTotDisk)
           IF VerTamDisk(cDrive,nSpaceTotDisk) ; EXIT ; ENDIF
           @ 15,13 SAY "  1.2Kb " COLOR YCOREDIT

      CASE nMenu_5d = 2                                      /* 720K (713K)*/
           @ 14,13 SAY "  720Kb " COLOR YCORREALCE
           nSpaceTotDisk := 730112
           nSpaceUsoDisk := 716800
           nQtdeArqs     := Estatistica(nSpaceUsoDisk,nSpaceTotDisk)
           IF VerTamDisk(cDrive,nSpaceTotDisk) ; EXIT ; ENDIF
           @ 14,13 SAY "  720Kb " COLOR YCOREDIT

      CASE nMenu_5d = 1                                      /* 360K (354K)*/
           @ 13,13 SAY "  360Kb " COLOR YCORREALCE
           nSpaceTotDisk := 362496
           nSpaceUsoDisk := 353280
           nQtdeArqs     := Estatistica(nSpaceUsoDisk,nSpaceTotDisk)
           IF VerTamDisk(cDrive,nSpaceTotDisk) ; EXIT ; ENDIF
           @ 13,13 SAY "  360Kb " COLOR YCOREDIT
   ENDCASE
ENDDO

IF !Confirma("Continua Opera‡„o ?")
   RESTSCREEN(2,0,24,79,tela)
   RELEASE nTamDisk, nTamanho, aFormato, aNomeArq, nArqVazio
   RETURN
ENDIF

Mensagem("Insira o disquete no drive "+cDrive+" e tecle Í¾ quando pronto.")
INKEY(0)

lPronto := CheckDrive(cDrive)

FOR lin = 12 to 14
    @ lin,58 SAY "0" COLOR YCORREALCE
NEXT

IF lPronto
   nArqCopiados  := 0
   nDiskCopiados := 1
   LinhaMsg(6)

   @ 12,58 SAY ALLTRIM(STR(nArqCopiados,2)) COLOR YCORREALCE
   @ 13,51 SAY nTamDisk PICT "@E 9,999,999" COLOR YCORREALCE
   @ 14,58 SAY STRZERO(nDiskCopiados,2)     COLOR YCORREALCE

   DECLARE aNomeArq[nQtdeArqs]
   ADIR("*.DBF",aNomeArq)
   @ 16,26 SAY "Lendo Arquivo        "
   @ 18,12 SAY "Percentual : "
   @ 19,12 SAY "Ocorrˆncias: "
   FOR u = 1 TO nQtdeArqs
       aMacroAux := aNomeArq[u]
       SELECT 1
       USE (aMacroAux)
       @ 16,52 SAY SPACE(12)
       @ 16,52 SAY aMacroAux COLOR YCORREALCE

       nNivelErro := CopyFile(aMacroAux,aMacroAux,cDrive)

       IF nNivelErro = 0       /* Arquivo vazio */
          nArqVazio++
       ELSEIF nNivelErro = 1   /* Copia normal */
          Percentual(u,nQtdeArqs)
          nTamDisk -= nTamanho
          @ 13,51 SAY nTamDisk PICT "@E 9,999,999" COLOR YCORREALCE
          Mensagem()
          nArqCopiados++
          @ 12,58 SAY ALLTRIM(STR(nArqCopiados,2)) COLOR YCORREALCE
       ELSEIF nNivelErro = 2   /* Mudan‡a de disco */
          VerTamDisk(cDrive,nSpaceTotDisk)
          nDiskCopiados++
          u--
       ELSEIF nNivelErro = 3   /* Erro na leitura/grava‡„o */
          u--
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
         Mensagem("C¢pia cancelada pelo Usu rio! Tecle algo...")
      ELSE
         Beep(2)
         Mensagem("C¢pia conclu¡da com Sucesso. Tecle algo...")
      ENDIF
   ENDIF
   @ 14,58 SAY STRZERO(nDiskCopiados,2) COLOR YCORREALCE
ELSE
   Aviso("Drive NŽO est  pronto. Tecle algo...")
   Mensagem("Nenhum Arquivo copiado. Tecle algo...")
ENDIF
INKEY(0)
DBCLOSEALL()
RESTSCREEN(2,0,24,79,tela)
RELEASE nTamDisk, nTamanho, aFormato, nArqVazio
SETCOLOR(cor)
RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Tela Apresenta‡„o do Disco   ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
PROCEDURE DiskInfo(pFonte)
   @ 06,12 SAY pFonte
   Quadro(7,12,9,21,1,YCOREDIT)
   @ 11,12 SAY "Formato"
   Quadro(12,12,17,21,1,YCOREDIT)
   @ 13,13 SAY "  360Kb "
   @ 14,13 SAY "  720Kb "
   @ 15,13 SAY "  1.2Kb "
   @ 16,13 SAY " 1.44Kb "
   Quadro(7,24,17,68,1,YCOREDIT)
   @ 06,24 SAY "Estat¡sticas"
   @ 07,66 SAY "Â"
   @ 08,26 SAY "Arquivos Existentes  "
   @ 08,66 SAY "³"
   @ 09,26 SAY "Espa‡o Ocupado       "
   @ 09,66 SAY "³"
   IF pFonte=="Destino"
      @ 10,26 SAY "Disquetes Previstos  "
   ELSE
      @ 10,26 SAY "Ultima Atualiza‡„o   "
   ENDIF
   @ 10,66 SAY "³"
   @ 11,24 SAY "Ã"+REPL("Ä",43)+"´"
   @ 11,66 SAY "Å"
   @ 12,26 SAY "Arquivos Copiados    "
   @ 12,66 SAY "³"
   @ 13,26 SAY "Espa‡o Livre Destino "
   @ 13,66 SAY "³"
   IF pFonte=="Destino"
      @ 14,26 SAY "Disquetes Utilizados "
   ELSE
      @ 14,26 SAY "Disquetes Lidos      "
   ENDIF
   @ 14,66 SAY "³"
   @ 15,24 SAY "Ã"+REPL("Ä",43)+"´"
   @ 15,66 SAY "Á"
   RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Quant. arqs para Backup      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION Estatistica(nSpaceUsoDisk,nSpaceTotDisk)
   Mensagem("Preparando arquivos para para Estat¡stica...")
   DBCLOSEALL()

   nQtdeArqs := ADIR("*.DBF")
   DECLARE aNomeArq[nQtdeArqs]
   DECLARE aTamArq[nQtdeArqs]
   DECLARE aQtdeDiskArq[nQtdeArqs]
   ADIR("*.DBF",aNomeArq,aTamArq)

   nTamBack   := nArqVazio := 0
   nQuantDisk := nQuantAnt := 1

   /* Espaco livre para seguranca do disco */
   nSpaceFree    := nSpaceTotDisk - nSpaceUsoDisk
   nIndiceUsoArq := 300/nSpaceUsoDisk

   FOR i = 1 TO nQtdeArqs
       nTamBack       += aTamArq[i]
       nIndiceUsoArq  += aTamArq[i]/nSpaceUsoDisk + 40/nSpaceUsoDisk
       IF nIndiceUsoArq > 1
          aMacroAux := aNomeArq[i]
          USE (aMacroAux)
          WHILE nIndiceUsoArq > 1
             nQuantDisk++
             nIndiceUsoArq := nIndiceUsoArq - 1 + HEADER()/nSpaceUsoDisk + 300/nSpaceUsoDisk
          ENDDO
       ENDIF
       aQtdeDiskArq[i] := nQuantDisk - nQuantAnt + 1
       nQuantAnt       := nQuantDisk
   NEXT
   nSpacPrev     := TRANSFORM(nTamBack,"@E 99,999,999")
   nQtdeDiskPrev := STRZERO(nQuantDisk,2)
   nArqsLidos    := ALLTRIM(STR(nQtdeArqs,2))

   @ 08,58 SAY nArqsLidos    COLOR YCORREALCE
   @ 09,50 SAY nSpacPrev     COLOR YCORREALCE
   @ 10,58 SAY nQtdeDiskPrev COLOR YCORREALCE
   RETURN(nQtdeArqs)
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Verificar Tamanho do Disco   ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION VerTamDisk(pDrive,pFormato)
   lPronto := CheckDrive(pDrive)
   IF lPronto
      nQtdeArq := ADIR(pDrive+"*.*")
      IF nQtdeArq > 0
         IF Confirma("Disco contem dados, Apaga ?")
            DECLARE aNomeArqs[nQtdeArq]
            ADIR(pDrive+"*.*",aNomeArqs)
            FOR y = 1 TO nQtdeArq
                cNomeFile := pDrive+"\"+aNomeArqs[y]
                DELETE FILE (cNomeFile)
            NEXT
         ELSE
            RETURN .F.
         ENDIF
      ENDIF
      nTamDisk := DISKSPACE(IF(pDrive="A:",1,2))

      FOR n = 1 TO 4
          IF nTamDisk > aFormato[n,2]
             cTam := aFormato[n,1]
          ENDIF
      NEXT

      IF nTamDisk < pFormato .OR. nTamDisk > pFormato
         FOR p = 1 TO 3
             IF (nTamDisk > aFormato[p,2] .AND. nTamDisk < aFormato[p+1,2])
                Aviso("Disco ‚ "+aFormato[p+1,1]+", por‚m o espa‡o encontrado foi diferente. Tecle algo...")
                EXIT
             ENDIF
         NEXT
      ENDIF
      @ 13,51 SAY nTamDisk PICT "@E 9,999,999" COLOR YCORREALCE
   ELSE
      Aviso("Drive NŽO est  pronto. Tecle algo...")
      RETURN .F.
   ENDIF
   RETURN .T.
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Copiar Arquivo p/Disquete    ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION CopyFile(pFonte,pDestino,pDrive)
   LOCAL nSize, cInFile, cOutFile, nCopiados, nBytes, nPercentual
   LOCAL nHandle, nBuffer

   DBCLOSEAREA()
   nHandle := FOPEN(pFonte,0)
   IF (FERROR() # 0) .AND. nHandle == -1
      CodErro(FERROR())
      Aviso("Erro de abertura do arquivo! Tecle algo...")
      RETURN(3)
   ENDIF

   nTamanho := FSEEK(nHandle,0,2)
   FCLOSE(nHandle)
   IF (FERROR() # 0)
      CodErro(FERROR())
      Aviso("Erro de fechamento do arquivo! Tecle algo...")
      RETURN(3)
   ENDIF

   IF (nTamanho == 0)
      Aviso("Arquivo est  Vazio!",YCORAVISO,2)
      RETURN(0)
   ENDIF

   IF pDrive == "A:"
      pCodDrive := 1
   ELSEIF pDrive == "B:"
      pCodDrive := 2
   ELSEIF pDrive == "C:"
      pCodDrive := 3
   ENDIF

   IF pDrive # NIL
      IF (DISKSPACE(pCodDrive) < nTamanho)
         Aviso("Espa‡o Insuficiente no Disco! Troque-o para continuar...")
         RETURN(2)
      ENDIF
   ENDIF

   nSize   := 16384
   nBuffer := SPACE(nSize)

   cInFile := FOPEN(pFonte,0)
   IF (FERROR() # 0)
      CodErro(FERROR())
      Aviso("Erro de abertura do arquivo! Tecle algo...")
      RETURN(3)
   ENDIF

   IF pDrive # NIL
      cOutFile := FCREATE(pDrive+"\"+pDestino)
   ELSE
      cOutFile := FCREATE(pDestino)
   ENDIF
   IF (FERROR() # 0)
      CodErro(FERROR())
      Aviso("Erro de cria‡„o do arquivo DESTINO. Tecle algo...")
      RETURN(3)
   ENDIF

   Mensagem("Copiando de "+pFonte+" para "+IF(pDrive#NIL,pDrive,"")+"\"+pDestino+"...")

   nBytes    := FREAD(cInFile,@nBuffer,nSize)
   IF (FERROR() # 0)
      CodErro(FERROR())
      Aviso("Erro de leitura do arquivo! Tecle algo...")
      RETURN(3)
   ENDIF

   nCopiados := nBytes

   WHILE (nBytes == nSize)
      FWRITE(cOutFile,nBuffer,nSize)
      IF (FERROR() # 0)
         CodErro(FERROR())
         Aviso("Erro de grava‡„o do arquivo! Tecle algo...")
         RETURN(3)
      ENDIF

      nBytes := FREAD(cInfile,@nBuffer,nSize)
      IF (FERROR() # 0)
         CodErro(FERROR())
         Aviso("Erro de leitura do arquivo! Tecle algo...")
         RETURN(3)
      ENDIF
      nCopiados += nBytes

      tecla := INKEY()
      IF tecla==K_ESC
         RETURN(4)
      ENDIF
   ENDDO

   FWRITE(cOutFile,nBuffer,nBytes)  /* Ultimos dados gravados */
   IF (FERROR() # 0)
      CodErro(FERROR())
      Aviso("Erro de grava‡„o do arquivo! Tecle algo...")
      RETURN(3)
   ENDIF

   FCLOSE(cInFile)
   IF (FERROR() # 0)
      CodErro(FERROR())
      Aviso("Erro de fechamento do arquivo ORIGEM. Tecle algo...")
      RETURN(3)
   ENDIF

   FCLOSE(cOutFile)
   IF (FERROR() # 0)
      CodErro(FERROR())
      Aviso("Erro no fechamento do arquivo DESTINO. Tecle algo...")
      RETURN(3)
   ENDIF

   tecla := INKEY()
   IF tecla==K_ESC
      RETURN(4)
   ENDIF
   RETURN(1)
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ C¢digos de Erro do DOS       ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
PROCEDURE CodErro(pErro)
   DO CASE
      CASE pErro = 2
           pDescr := "Arquivo n„o encontrado"
      CASE pErro = 3
           pDescr := "Diret¢rio n„o encontrado"
      CASE pErro = 4
           pDescr := "Muitos arquivos abertos"
      CASE pErro = 5
           pDescr := "Imposs¡vel acessar arquivo"
      CASE pErro = 6
           pDescr := "N£mero de manipula‡„o de arquivo inv lido"
      CASE pErro = 8
           pDescr := "Mem¢ria insuficiente"
      CASE pErro = 15
           pDescr := "Acionador de disco inv lido"
      CASE pErro = 19
           pDescr := "Tentativa de gravar sobre disco protegido"
      CASE pErro = 21
           pDescr := "Acionador de disco inoperante"
      CASE pErro = 23
           pDescr := "Erro de dados no disco"
      CASE pErro = 29
           pDescr := "Erro de grava‡„o no disco"
      CASE pErro = 30
           pDescr := "Erro de leitura no disco"
      CASE pErro = 32
           pDescr := "Viola‡„o de compartilhamento"
      CASE pErro = 33
           pDescr := "Viola‡„o de bloqueio"
   ENDCASE
   @ 19,25 SAY SPACE(41)
   @ 19,25 SAY pDescr COLOR YCORREALCE
   RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Mostrar Percentual Executado ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
PROCEDURE Percentual(pLidos,pFinal)
   LOCAL nProporcao := ROUND(100/pFinal,2)
   LOCAL nPercent   := ROUND(pLidos/pFinal*100,2)
   LOCAL cCor       := SETCOLOR()

   IF nPercent = nProporcao
      @ 18,29 SAY REPLICATE("±",40)
   ENDIF
   @ 18,29 SAY REPLICATE("Û",nPercent/2.5) COLOR "W/W"
   @ 18,25 SAY nPercent PICTURE "@E 999%"  COLOR YCOREDIT
   SETCOLOR(cCor)
   RETURN
