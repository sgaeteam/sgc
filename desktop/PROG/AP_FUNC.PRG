*уммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╦
*Ё PROGRAMA       : AP_FUNC                          vrs 001 Ё
*Ё VRS 001        : Implantacao                              Ё
*Ё FINALIDADE     : Funcoes Genericas do Sistema             Ё
*Ё PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            Ё
*Ё DATA CRIACAO   : 26/10/1993                               Ё
*Ё OBSERVACOES    : Compilar com os parametros /N /W /A /M   Ё
*тммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╬
#include "INKEY.CH"
#include "SETCURS.CH"
#include "COMMAND.CH"
#include "FILEIO.CH"

MEMVAR nCall, cPrg, vetor, indice, handle_gr, continuac, handle_ler, bloc
MEMVAR buffers, tam_arq, transf, bytes_lid, bytes_grav, marca_fim, cont_disco
MEMVAR handle_cab, nova_lin, arq_cab, str_cab, cbuffer, marc_fim
MEMVAR YCORBARRA, YCORGERAL, YCOREDIT, YCORMENU, YCORAVISO, tecla

*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                       AVISO SONORO DE PROCESSAMENTO                       Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Beep(modo)
   IF modo = 1          /* Processamento mal sucedido */
      TONE(87.3,1)
      TONE(87.3,4)
   ELSEIF modo = 2      /* Processamento bem sucedido */
      TONE(1612.6,.5)
      TONE(1323.4,7)
   ELSEIF modo = 3      /* Falha de acesso ao Sistema */
      TONE(1200,1)
      TONE(670,2)
   ENDIF
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё           ROTINA DE EXIBICAO DE MODULOS DE HELP DO SISTEMA                Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Help(op, mod, chamadas, msg1, msg2)
   LOCAL chave, tela, arq, cursor, cor

   IF chamadas == 1
      RETURN NIL
   ELSE
      cursor := SETCURSOR()
      chave  := op + mod
      cor    := SETCOLOR()
      arq    := SELECT()
      SETCURSOR(0)

      SELECT 20
      IF NetUse("HELP.HLP","HELP")
         SET INDEX TO HLP
      ELSE
         DBCLOSEAREA()
         RETURN NIL
      ENDIF
      IF DBSEEK(chave)
         nCall := 1
         tela  := SAVESCREEN(5,0,24,79)
         Quadro(5,10,19,70,1,YCORMENU,,"Help",.T.)
         SETCOLOR(YCORMENU)
         Mensagem("Use as teclas "+CHR(24)+","+CHR(25)+", PGUP, PGDN,"+;
                  "CTRL PGUP, CTRL PGDN para Movimentar","[Esc] Finaliza o Help")
         MEMOEDIT(_FIELD->descricao,6,11,18,69,.F.)
         IF LASTKEY()==K_ESC
            nCall := 0
         ENDIF
         RESTSCREEN(5,0,24,79,tela)
         Mensagem(msg1,msg2)
      ELSE
         Aviso("Help N▌O dispon║vel! Tecle algo...")
      ENDIF
      SELECT (arq)
      SETCOLOR(cor)
      SETCURSOR(cursor)
   ENDIF
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё            ROTINA DE CHECAGEM DE CONEXAO COM IMPRESSORA                   Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION ChkImpr()
   LOCAL var1 := var2 := var3 := .T.

   corant := SETCOLOR()
   tela   := SAVESCREEN(16,55,20,78)
   SETCURSOR(0)

   Quadro(16,57,19,76,1,"N/W",.T.)
   SETCOLOR("N/W")
   WHILE .T.
      tecla := INKEY()

      WHILE tecla # 0 .AND. tecla # K_ENTER .AND. tecla # K_ESC
         tecla := INKEY()
      ENDDO

      IF ISPRINTER()
         IF var1
            @ 17,58 SAY " <     > Imprime  "
            @ 18,58 SAY " <ESC>   Abandona "
            SETCOLOR("*N/W")
            @ 17,60 SAY "ENTER"
            SETCOLOR( "N/W" )
            var1 := .F.
            var2 := .T.
         ENDIF
         IF tecla = K_ENTER
            EXIT
         ENDIF
      ELSE
         IF var2
            @ 17,58 SAY " Impressora...    "
            SETCOLOR("*N/W")
            @ 18,58 SAY " N└o Conectada.   "
            SETCOLOR("N/W")
            var1 := .T.
            var2 := .F.
         ENDIF
      ENDIF
      IF tecla = K_ESC
         var3 := .F.
         EXIT
      ENDIF
   ENDDO
   SETCOLOR(corant)
   RESTSCREEN(16,55,20,78,tela)
   RETURN(var3)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё             ROTINA PARA INFORMAR IMPRESSAO DE RELATORIO                   Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION MsgImp(pInterv)
   DEFAULT pInterv TO .T.

   corant  := SETCOLOR()
   telaImp := SAVESCREEN(16,55,20,78)
   SETCOLOR("N/W")
   Quadro(16,57,19,76,1,"N/W",.T.)
   SETCOLOR("N*/W")
   @ 17,58 SAY " Imprimindo...    "
   SETCOLOR("N/W")
   IF pInterv
      @ 18,58 SAY " <ESC> Interrompe "
   ELSE
      @ 18,58 SAY " A g u a r d e !  "
   ENDIF
   SETCOLOR(corant)
   RETURN(telaImp)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё             ROTINA PARA RESTAURAR MENSAGEM IMPRIMINDO...                  Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION TiraMsgImp(tela)
   RESTSCREEN(16,55,20,78,tela)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                  ROTINA DE FORMATACAO DE IMPRESSAO                        Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Compr_Off()
   SET CONSOLE OFF
   SET PRINTER ON
   ?? &wCompr_Off.
   SET PRINTER OFF
   SET CONSOLE ON
   RETURN
*
PROCEDURE Compr_On()
   SET CONSOLE OFF
   SET PRINTER ON
   ?? &wCompr_On.
   SET PRINTER OFF
   SET CONSOLE ON
   RETURN
*
PROCEDURE Expand_On()
   SET CONSOLE OFF
   SET PRINTER ON
   ?? &wExpandOn.
   SET PRINTER OFF
   SET CONSOLE ON
   RETURN
*
PROCEDURE Expand_Off()
   SET CONSOLE OFF
   SET PRINTER ON
   ?? &wExpandOff.
   SET PRINTER OFF
   SET CONSOLE ON
   RETURN
*
PROCEDURE ExpMed_On()
   SET CONSOLE OFF
   SET PRINTER ON
   ?? wExpand_Med
   SET PRINTER OFF
   SET CONSOLE ON
   RETURN
*
PROCEDURE Imp_Graf()
   SET CONSOLE OFF
   SET PRINTER ON
   ?? CHR(6)
   SET PRINTER OFF
   SET CONSOLE ON

PROC IMP_NORMAL
   Set Console off
   Set Printer on
   ?? &wCompr_Off.
   Set Printer Off
   Set Console On
   Return

PROC IMP_COMPRI
   Set Console off
   Set Printer on
   ?? &wCompr_On.
   Set Printer Off
   Set Console On
   Return

PROC IMP_CR
   Set Console off
   Set Printer on
   ?? Chr(27)+'['+'5'
   Set Printer Off
   Set Console On
   Return

PROC IMP_exp
  Set Console off
  Set Printer on
  ?? &wExpandOn.
  Set Printer Off
  Set Console On
  Return

PROC IMP_Enor
  Set Console off
  Set Printer on
  ?? &wExpandOff.
  Set Printer Off
  Set Console On
  Return

PROC IMP_ExpMed
  Set Console off
  Set Printer on
  ?? wExpand_Med
  Set Printer Off
  Set Console On
  Return
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё            ROTINA DE CANCELAMENTO DE IMPRESSAO PELO USUARIO               Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Escprint(Tam_Form)
   PRIVATE tecla
   tecla := INKEY()
   WHILE tecla # 0 .AND. tecla # K_ESC
      tecla := INKEY()
   ENDDO
   IF tecla == K_ESC
      corantiga := SETCOLOR()
      SET DEVICE TO SCREEN
      SET CONSOLE ON
      TONE(500,5)
      SET CONSOLE OFF
      SETCOLOR("N*/W")
      @ 17,58 SAY " Pausa...       "
      INKEY(0)
      IF LASTKEY() == K_ESC
         SET DEVICE TO PRINT
         Compr_On()
         Imp_Cancel(Tam_Form)
         Compr_Off()
         SET CONSOLE ON
         SETCOLOR(corantiga)
         RETURN .F.
      ENDIF
      @ 17,58 SAY " Imprimindo...  "
      SETCOLOR(corantiga)
   ENDIF
   SET DEVICE TO PRINT
   RETURN .T.
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё         ROTINA DE IMPRESSAO DE RELATORIO E CHECAGEM DE INTERRUP─AO        Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE ChkInterv(cRotina,nProw,nPcol,cTexto,cMascara,nTam_Form)
   IF Continua
      IF Continua := Escprint(nTam_Form)
         IF PROW()+nProw > 61 .OR. PROW() < 1
            IF cRotina # NIL
               &cRotina.()
            ENDIF
         ENDIF
         IF VALTYPE( cMascara ) = "U"
            @ PROW()+nPROW,nPcol SAY cTexto
         ELSE
            @ PROW()+nPROW,nPcol SAY cTexto PICT &cMascara.
         ENDIF
      ENDIF
   ELSE
      GO BOTTOM
      DBSKIP()
   ENDIF
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                  ROTINA DE MENSAGEM DE CANCELAMENTO DE IMPRESSAO          Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Imp_Cancel(Tam_Form)
   DEFAULT Tam_Form TO 80
   @ PROW()+1,00 SAY REPLICATE("*",Tam_Form)
   Centro(PROW()+1,"I M P R E S S A O   I N T E R R O M P I D A   P E L O   U S U A R I O",0,Tam_Form)
   @ PROW()+1,00 SAY REPLICATE("*",Tam_Form)
   EJECT
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                CENTRALIZAR MENSAGENS NA TELA OU IMPRESSORA                Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Centro(linha,texto,l,r)
   IF (PCOUNT() < 3)
      tam := 80
      @ linha,INT((tam - LEN(texto))/2) SAY texto
   ELSE
      tam := ((r-l)/2) + l
      @ linha,INT(tam - (LEN(texto)/2)) SAY texto
   ENDIF
   RETURN(texto)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                      EXIBIR MENSAGEM NA LINHA 23                          Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Mensagem(texto,cor)
   LOCAL corant := SETCOLOR()
   DEFAULT cor TO SETCOLOR(YCORMENU)
   @ 23,00 CLEAR TO 23,79
   IF texto # NIL
      Centro(23,texto)
   ENDIF
   SETCOLOR(corant)
   RETURN(texto)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                       PEDIR CONFIRMACAO DE OPCOES                         Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Confirma(texto,default)
   LOCAL les,ces,largjan,telavelha

   DEFAULT default TO .F.

   confirm := .F.
   IF LASTKEY() = K_DEL
      Opcao := 2
   ENDIF

   largjan := LEN(texto)+2
   IF largjan < 16
      largjan := 16
   ENDIF

   ces       := (80-largjan)/2
   les       := 19
   telavelha := SAVESCREEN(les,0,les+4,79)
   corant    := SETCOLOR()
   cornova   := "N/W,W+/N"

   Sombra( les, ces, les+3, ces+LargJan, c_nLado )
   SETCOLOR(cornova)
   @ les,ces CLEAR TO les+3,ces+largjan
   @ les,ces TO les+3,ces+largjan DOUBLE
   @ les+1,ces+2 SAY texto
   coluna := (largjan-9)/2

   IF default
      @ les+2,ces+coluna   PROMPT " N└o "
      @ les+2,ces+coluna+6 PROMPT " Sim "
      MENU TO Opcao
      IF Opcao == 2
         confirm := .T.
      ENDIF
   ELSE
      @ les+2,ces+coluna   PROMPT " Sim "
      @ les+2,ces+coluna+6 PROMPT " N└o "
      MENU TO Opcao
      IF Opcao == 1
         confirm := .T.
      ENDIF
   ENDIF
   SETCOLOR(corant)
   RESTSCREEN(les,0,les+4,79,telavelha)
   RETURN(confirm)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                       ENVIAR MENSAGEM DE ERRO (AVISO)                     Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Aviso(texto,cor,tempo)
   LOCAL corant := SETCOLOR(), cursor := SETCURSOR(), Regiao:=SAVESCREEN(23,00,23,79)
   DEFAULT cor   TO YCORAVISO
   DEFAULT tempo TO 0
   SETCOLOR(cor)
   SETCURSOR(0)
   @ 23,00 CLEAR TO 23,79
   Beep(1)
   Centro(23,texto)
   INKEY(tempo)
   Mensagem()
   SETCURSOR(cursor)
   SETCOLOR(corant)
   RESTSCREEN(23,00,23,79,Regiao)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё          ROTINA DE MOSTRAGEM EM TELA OU IMPRESSORA DE CAMPOS MEMO         Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Prdevice(pVar,pTam,pTab)
   LOCAL tela := SAVESCREEN(2,0,24,79), cCorAntes := SETCOLOR()
   SETCOLOR(YCORGERAL)
   SETCURSOR(3)
   IF LEN(pVar) > 64000
      Aviso("Relat╒rio muito grande para ser listado em tela.",,3)
   ELSE
      @ 2,0,22,79 BOX "         "
      Mensagem("["+CHR(24)+CHR(25)+" PgUp PgDn] Movimentar  [Home] Esquerda  [End] Direita [Esc] Finaliza",YCORAVISO)
      MEMOEDIT(pVar,2,0,22,79,.F.,"",pTam,pTab)
      SETCOLOR(cCorAntes)
      @ 02,00,22,79 BOX "╟╟╟╟╟╟╟╟╟" COLOR YCORGERAL
   ENDIF
   RESTSCREEN(2,0,24,79,tela)
   SETCOLOR(cCorAntes)
   SETCURSOR(0)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                    ROTINA DE CONSULTA DE DBF (BROWSE)                     Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Consulta(nDbf,nInd,Cab1,Cab2,Camp1,Camp2,Retorno,sombra)
   LOCAL nLinhas, nN, Coluna
   LOCAL Tab, lSup, lInf, cEsq, cDir, v1, v2, tela := SAVESCREEN(2,0,24,79)
   LOCAL corAnterior  := SETCOLOR()
   LOCAL nSelectAntes := SELECT()
   LOCAL nOrderAntes  := INDEXORD()

   PRIVATE cBuffer := ""
   PRIVATE tecla

   DBSELECTAREA( nDbf )
   DBSETORDER( nInd )
   DEFAULT sombra TO .F.

   v1 := &Camp1
   IF Camp2 #  NIL
      v2 := &Camp2
   ELSE
      v2 := ""
   ENDIF

   lSup    := 03
   cDir    := 74
   cEsq    := 74 - (IF(VALTYPE(v1)=="D",8,LEN(v1))+IF(VALTYPE(v2)=="D",8,LEN(v2))+3)
   nLinhas := 0
     
   GO TOP
   FOR nn := 1 TO 20
     IF !(BOF() .AND. EOF())
        nLinhas++
     ENDIF
     SKIP
     IF EOF() .OR. nLinhas > 9
        EXIT
     ENDIF
   NEXT

   IF nLinhas <> 0
      IF nLinhas > 9
         lInf := 18
      ELSE
         lInf := lSup + 03 + nLinhas
      ENDIF
      Tab := TBROWSEDB(lSup+1, cEsq+1, lInf-1, (cDir-1)+3)
      Quadro(lSup,cEsq,lInf,cDir+3,,YCOREDIT)
      Quadro(lInf,cEsq,lInf+2,cDir+3,,YCOREDIT,.T.)

      Tab:HEADSEP   := CHR(194)+CHR(196)
      Tab:COLORSPEC := (YCOREDIT)

      Coluna := TBCOLUMNNEW(CAB1,FIELDBLOCK(CAMP1))
      IF TYPE(CAMP1)=="N"
         Coluna:COLORBLOCK := {|CAMPO| IF(CAMPO>=0,{3,4},{5,6})}
      ENDIF
      Coluna:COLSEP := CHR(179)
      Tab:ADDCOLUMN(Coluna)

      IF CAB2 <> NIL
         Coluna := TBCOLUMNNEW(CAB2,FIELDBLOCK(CAMP2))
         IF TYPE(CAMP2)=="N"
            Coluna:COLORBLOCK := {|CAMPO| IF(CAMPO>=0,{3,4},{5,6})}
         ENDIF
         Coluna:COLSEP := CHR(179)
         Tab:ADDCOLUMN(Coluna)
      ENDIF
   ELSE
      Aviso("Banco de Dados Vazio",YCORAVISO,2)
      SETCURSOR(1)
      DBSELECTAREA(nSelectAntes)
      SET ORDER TO nOrderAntes
      SETCOLOR(CorAnterior)
      RETURN .T.
   ENDIF

   IF sombra
      Sombra(lSup,cEsq,lInf+3,cDir+3,1)
   ENDIF

   Tab:FREEZE := 1
   GO TOP
   WHILE .T.
      SETCURSOR(0)
      WHILE !Tab:STABILIZE();ENDDO
      tecla := INKEY(0)
      IF tecla == K_UP
         Tab:up()
      ELSEIF tecla == K_DOWN
         Tab:down()
      ELSEIF tecla == K_CTRL_PGUP
         Tab:gotop()
      ELSEIF tecla == K_CTRL_PGDN
         Tab:gobottom()
      ELSEIF tecla == K_RIGHT
         Tab:right()
      ELSEIF tecla == K_LEFT
         Tab:left()
      ELSEIF tecla == K_PGUP
         Tab:pageup()
      ELSEIF tecla == K_PGDN
         Tab:pagedown()
      ELSEIF tecla == K_ESC .OR. tecla == K_ENTER
         RESTSCREEN(2,0,24,79,tela)
         SETCURSOR(1)
         IF tecla == K_ENTER
            /*
            IF VALTYPE(&Retorno) == "D"
               KEYBOARD DTOC(&Retorno.)+CHR(13)
            ELSE
               KEYBOARD &Retorno.+CHR(13)
            ENDIF
            */
            IF Retorno#NIL
               cNomeVar   := READVAR()
               &cNomeVar. := &Retorno.
               KEYBOARD &Retorno. + CHR(13)
            ENDIF
         ENDIF
         DBSELECTAREA(nSelectAntes)
         SET ORDER TO nOrderAntes
         SETCOLOR(CorAnterior)
         RETURN .T.
      ELSEIF tecla >= 32 .AND. tecla <= 127 .OR. tecla == K_BS .OR. tecla == K_CTRL_L
         SmartSeek(UPPER(CHR(tecla)),lInf+1,cEsq,cDir-cEsq-1)
         Tab:refreshall()
      ENDIF
   ENDDO
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                ROTINA DE AUXILIO DA CONSULTA DE DBF (BROWSE)              Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION SmartSeek(c,nLinha,nColuna,Masc)
   LOCAL Reg_Atual := RECNO()
   IF tecla == K_CTRL_L
      cBuffer := ""
      @ nLinha,nColuna+1 SAY SPACE(Masc)
      RETURN NIL
   ENDIF
   IF ASC(c) == K_BS
      cBuffer := LEFT(cBuffer,LEN(cBuffer)-1)
   ELSE
      IF VALTYPE(c) == "N"
         c := STR(c,1)
      ENDIF
      cBuffer += c
      IF !DBSEEK(cBuffer)
         DBGOTO(Reg_Atual)
      ENDIF
   ENDIF
   IF LEN(cBuffer)<Masc
      @ nLinha,nColuna+1 SAY cBuffer+SPACE(1)
   ENDIF
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё         ROTINA DE MOSTRAGEM DE % ARQUIVO ORGANIZADO (TERMOMETRO)          Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Termom(cTitulo, Lidos, Final)
   LOCAL nCentro, cTermvazio
   LOCAL nProporcao := ROUND(100.00/final,2)
   LOCAL nPercent   := ROUND(lidos/final*100,2)
   LOCAL cCor       := SETCOLOR()
   LOCAL lStat_Cons := SET(_SET_CONSOLE,.T.)
   LOCAL lStat_Dev  := SET(_SET_DEVICE,"SCREEN")

   cTitulo    := "╢ "+cTitulo+" ц"

   IF nPercent < nProporcao
      nCentro    = (40-LEN(cTitulo))/2+20
      cTermvazio = REPLICATE("╠",40)
      Quadro(15,18,17,61,1,YCOREDIT,,,.T.)
      SETCOLOR(YCOREDIT)
      @ 15,nCentro SAY cTitulo
      @ 17,28 SAY "╢"+SPACE(20)+"ц"
      @ 16,19 CLEAR TO 16,60
      @ 17,29 CLEAR TO 17,48
      @ 16,20 SAY cTermvazio
      @ 17,38 SAY "Executados"
   ENDIF

   @ 16,20 SAY REPLICATE("ш",nPercent/2.50) COLOR "W/W"
   @ 17,30 SAY nPercent PICTURE "@E 999.9%" COLOR YCOREDIT

   SETCOLOR(cCor)
   SET(_SET_CONSOLE,lStat_Cons)
   SET(_SET_DEVICE,lStat_Dev)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                 ROTINA DE CALCULO DO ULTIMO DIA DO MES                    Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION FimMes(data)
   LOCAL dia, mes, ano, final
   ano = YEAR(data)
   mes = MONTH(data) + 1
   dia = '01'
   IF mes = 13
      ano++
      mes = 1
   ENDIF
   ano   = STR(ano-1900,2)
   mes   = STR(mes,2)
   final = CTOD(dia+"/"+mes+"/"+ano)
   RETURN(final-1)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                        ROTINA DE EXPANSAO DE JANELA                       Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION JanelaExp(nLinSup, nColSup, nLinInf, nColInf, nTipo, nSombra)
   LOCAL Tela_Ant := SAVESCREEN(nLinSup, nColSup, nLinInf, nColInf)
   LOCAL odd, tlsct
   PRIVATE t,l,b,r

   nLinSup := INT(nLinSup)
   nLinInf := INT(nLinInf)
   nColSup := INT(nColSup)
   nColInf := INT(nColInf)
   
   tlsct   := 0
   t       := (nLinSup+nLinInf)/2-1
   l       := (nColSup+nColInf)/2-1
   odd     := .F.
   b       := t + 1
   r       := l + 1

   WHILE .T.
      odd = !odd
      IF odd
         IF t > nLinSup
            t--
            IF t < nLinSup
               t := nLinSup
            ENDIF
         ENDIF
         IF b < nLinInf
            b++
            IF b > nLinInf
               b := nLinInf
            ENDIF
         ENDIF
      ENDIF
      IF l > nColSup
         l--
         IF l < nColSup
            l := nColSup
         ENDIF
      ENDIF
      IF r < nColInf
         r++
         IF r > nColInf
            r := nColInf
         ENDIF
      ENDIF
      SCROLL(t,l,b,r,0)
      @ t,l,b,r BOX nTipo
      IF t = nLinSup .AND. l = nColSup .AND. b = nLinInf .AND. r = nColInf
         EXIT
      ENDIF
   ENDDO
   IF nSombra <> NIL
      Sombra(t,l,b,r,1)
   ENDIF
   RETURN Tela_Ant
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                        ROTINA DE SOMBREAMENTO                             Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Sombra(ls,cs,li,ci,lado)
   LOCAL sombra1, sombra2, lsombra
   DEFAULT lado TO 1
   IF lado = 2
      sombra1 := SAVESCREEN(ls+1, cs-2, li+1, cs-1)
      sombra2 := SAVESCREEN(li  , cs  , li+1, ci-2)
   ELSE
      sombra1 := SAVESCREEN(ls+1, ci+1, li+1, ci+2)
      sombra2 := SAVESCREEN(li,   cS+2, li+1, ci)
   ENDIF
   sombra1 := TRANSFORM(sombra1,REPLICATE("X"+CHR(1),(li-ls+1)*2))
   lsombra := (ci-cs-1)
   sombra2 := LEFT(sombra2,lsombra*2)+TRANSFORM(SUBSTR(sombra2,lsombra*2+1,lsombra*2),;
              REPLICATE("X"+CHR(1),lsombra))
   RESTSCREEN(ls+1,IF(lado==2,cs-2,ci+1),li+1,IF(lado==2,cs-1,ci+2),sombra1)
   RESTSCREEN(li,IF(lado==2,cs,cs+2), li+1,IF(lado==2,ci-2,ci),sombra2)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     LOGOTIPO EMPRESA - DIREITOS AUTORAIS                  Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
STATIC FUNCTION Logotipo()
   LOCAL cRazao := "Clube 2004"
   CLEAR SCREEN
   SETCOLOR("G+/N")
   @ 0,0 SAY cRazao + SPACE(80 - LEN(cRazao))
   SETCOLOR(YCORMENU)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     SETUP DO AMBIENTE DE TRABALHO                         Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Abertura()
   Logotipo()
   Area_Menu()
   Area_Dados()
   SETCURSOR(0)
   SET DATE BRITISH
   SET MESSAGE TO 23
   SET( 4, IF(__SETCENTURY(), "dd/mm/yyyy", "dd/mm/yyyy") )
   SET( _SET_EPOCH, 1920 )
   SET(_SET_WRAP,.T.)
   SET(_SET_DELETED,.T.)
   SET(_SET_BELL,.F.)
   SET(_SET_SCOREBOARD,.F.)
   SET(_SET_CONFIRM,.T.)
   SET(_SET_ESCAPE,.T.)
   SET(_SET_EXCLUSIVE,.F.)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     PREENCHIMENTO DA AREA DE DADOS                        Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Area_Dados()
   @ 02,00,22,79 BOX "╟╟╟╟╟╟╟╟╟" COLOR YCORGERAL
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     PREENCHIMENTO DA AREA DE MENU                         Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Area_Menu()
   @ 01,00 SAY SPACE(80) COLOR YCORMENU
   @ 23,00 SAY SPACE(80) COLOR YCORMENU
   @ 24,00 SAY SPACE(80) COLOR YCORMENU
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                       NAVEGAR ENTRE OPCOES                                Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE cEsquerda()
   KEYBOARD CHR(27)+CHR(19)+CHR(13)
   RETURN
*
PROCEDURE cDireita()
   KEYBOARD CHR(27)+CHR(4)+CHR(13)
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     USUARIO E VERSAO DO SISTEMA                           Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION QuadroGeral(titulo)
   LOCAL tam, corant := SETCOLOR()
   SETCOLOR("W+/N")
   IF titulo = NIL
      @ 0,60 SAY SPACE(19)
   ELSE
      tam = LEN(TRIM(titulo))
      @ 0,80-tam SAY titulo
   ENDIF
   SETCOLOR(corant)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                        MONTAR QUADRO DE OPCOES                            Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Telas(t,l,b,r,tipo,cor,sombra,titulo)
   DEFAULT tipo   TO 1
   DEFAULT sombra TO .F.

   IF TYPE("TELAS") # "A"   //SE .T. ,NAO EXISTE A MATRIZ
      PUBLIC TELAS := {}    //CRIA UMA MATRIZ "TELAS" VAZIA
   ENDIF
   AADD(TELAS,{t,l-2,b+1,r+2,SAVESCREEN(t,l-2,b+1,r+2)})

   cStilo := aBorda[tipo]

   IF sombra
      Sombra(t,l,b,r,c_nLado)
   ENDIF
   IF cor # NIL
      corant := SETCOLOR()
      SETCOLOR(cor)
      SCROLL(t,l,b,r,0)
      @ t,l,b,r BOX cStilo
      SETCOLOR(corant)
   ELSE
      SCROLL(t,l,b,r,0)
      @ t,l,b,r BOX aBorda[tipo]
   ENDIF
   IF titulo # NIL
      Centro(t,titulo,l,r)
   ENDIF
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                RESTAURAR QUADROS MONTADOS NA FUNCAO TELAS                 Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Rest_Tela()
   LOCAL ult := LEN(TELAS)
   RESTSCREEN(TELAS[ult,1],TELAS[ult,2],TELAS[ult,3],TELAS[ult,4],TELAS[ult,5])
   ASIZE(TELAS,ult-1)
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                        ROTINA AVISO DE PROCESSAMENTO                      Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE ProcOk(texto)
   LOCAL corant := SETCOLOR(), cursor := SETCURSOR()
   LOCAL tela := SAVESCREEN(2,0,24,79)
   SETCURSOR(0)
   nCol := 76 - LEN(texto)
   Quadro(19,nCol,21,77,1,YCOREDIT,.T.,,.T.)
   @ 20,nCol+01 SAY texto
   TONE(1300,1.5)
   INKEY(1.5)
   RESTSCREEN(2,0,24,79,tela)
   SETCURSOR(cursor)
   SETCOLOR(corant)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                       AVISO PARA AGUARDAR PROCESSAMENTO                   Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Aguarde(texto)
   LOCAL corant := SETCOLOR(), cursor := SETCURSOR()
   SETCURSOR(0)
   IF texto==NIL
      ImplodBox()
   ELSE
      nCol := 76 - LEN(texto)
      ExplodBox(19,nCol,21,77)
      @ 20,nCol+01 SAY texto COLOR STUFF(YCOREDIT,3,1,"*")
      TONE(1300,1.5)
   ENDIF
   SETCURSOR(cursor)
   SETCOLOR(corant)
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё               ROTINA DE DESENHAR QUADROS COM MOLDURAS                     Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Quadro(t,l,b,r,tipo,cor,cheio,texto,sombra)
   DEFAULT tipo   TO 1
   DEFAULT sombra TO .F.
   DEFAULT cheio  TO .F.
   DEFAULT cor    TO "N/W"

   corant := SETCOLOR()
   cStilo := aBorda[tipo]

   IF cheio    /* Limpa o fundo do Box */
      cStilo += CHR(32)
   ENDIF

   IF cor # "N/W"
      DISPBOX(t,l,b,r,cStilo,cor)
   ELSE
      DISPBOX(t,l,b,r,aBorda[tipo],cor)
   ENDIF

   IF sombra
      Sombra(t,l,b,r,c_nLado)
   ENDIF

   IF texto # NIL
      SETCOLOR(cor)
      titulo = " "+texto+" "
      Centro(t,titulo,l,r)
   ENDIF
   SETCOLOR(corant)
   RETURN .T.
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                   ROTINA DE FINALIZACAO DO SISTEMA                        Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Saida()
   LOCAL cResSim, cResNao, LinhaMem := SAVESCREEN(23,00,24,79)
   LOCAL lVarSai := .T.

   TelaAntes := SAVESCREEN(13,13,22,66)

   cCorNova := "N  /"+SUBS(YCORMENU,5)
   SETCOLOR(YCORMENU)
   JanelaExp(13,15,21,64,c_nBorda,.T.)

   @ 15,35 SAY "Aten┤└o!" COLOR STUFF(YCORMENU,3,1,"*")
   @ 17,18 SAY "Voce solicitou a Sa║da do Sistema SGC V1.0 "
   cResSim := CHR(16)+" Sim "+CHR(17)
   cResNao := CHR(16)+" N└o "+CHR(17)
   SETCOLOR(cCorNova)
   @ 19,31 SAY "  Sim  "
   @ 19,41 SAY "  N└o  "
   @ 19,38 SAY "э"         COLOR cCorNova
   @ 20,32 SAY REPL("ъ",7) COLOR cCorNova
   @ 19,48 SAY "э"         COLOR cCorNova
   @ 20,42 SAY REPL("ъ",7) COLOR cCorNova
   TelaSim := SAVESCREEN(19,31,19,37)
   TelaNao := SAVESCREEN(19,41,19,47)
   escolha := .T.

   WHILE .T.
      IF escolha
         @ 19,31 GET cResSim
      ELSE
         @ 19,41 GET cResNao
      ENDIF
      CLEAR GETS
      INKEY(0)
      IF (LASTKEY()==K_ENTER .AND. escolha) .OR. (LASTKEY()== 83 .OR. LASTKEY()== 115)
         lVarSai := .T.
         EXIT
      ELSEIF LASTKEY()== K_ESC .OR. LASTKEY()== 78 .OR. ;
             LASTKEY()== 110 .OR. LASTKEY()== K_ENTER
         lVarSai := .F.
         EXIT
      ELSEIF LASTKEY()== 19 .OR. LASTKEY()== 4
         IF escolha
            RESTSCREEN(19,31,19,37,TelaSim)
            escolha := .F.
         ELSE
            RESTSCREEN(19,41,19,47,TelaNao)
            escolha := .T.
         ENDIF
      ENDIF
   ENDDO
   SETCOLOR(YCORMENU)
   RESTSCREEN(13,13,22,66,TelaAntes)
   RESTSCREEN(23,00,24,79,LinhaMem)
   RETURN(lVarSai)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё               ROTINA EXIBI─AO DE MENSAGENS OP─OES DOS MENUS               Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Msg(texto)
   texto += SPACE(80 - LEN(texto))
   RETURN(texto)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                  VISUALIZAR BANCO DE DADOS ESTILO BROWSE                  Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Browser(area,ordem,t,l,b,r,cabec,campo,pic,ativa,sombra,titulo,msg)
   LOCAL corant := SETCOLOR()
   PUBLIC Bmsg, Bativa

   DEFAULT ativa TO .F.

   Bmsg   := msg
   Bativa := ativa

   IF VALTYPE(area) # "U"
      SELECT(area)
   ENDIF

   Quadro(t-1,l-1,b+1,r+1,1,YCOREDIT,,titulo,sombra)

   IF VALTYPE(ordem) # "U"
      SET ORDER TO ordem
   ELSE
      SET ORDER TO 0
   ENDIF

   SETCOLOR(YCOREDIT)
   SETCURSOR(0)
   DBEDIT(t,l,b,r,campo,"Processa",pic,cabec,"д","Ё")
   SETCOLOR(corant)
   RELEASE Bmsg, Bativa
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                        PROCESSAR TECLA PRESSIONADA                        Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Processa(modo)
   IF modo == 1 .OR. modo == 2
      TONE(125,0)
   ELSEIF modo == 4
      IF ( LASTKEY() == K_F2 )
         Ajuda()
      ELSEIF ( LASTKEY()==105.OR.LASTKEY()==73)
         IF Bativa
            SETKEY(K_INS,{||SETCURSOR(IF(READINSERT(!Insere()),1,3))})
            IF Incluir(IF(Bmsg==NIL,NIL,Bmsg))
               SETKEY(K_INS,NIL)
               RETURN(2)
            ENDIF
            SETKEY(K_INS,NIL)
         ENDIF
      ELSEIF ( LASTKEY()==101.OR.LASTKEY()==69 )
         IF Bativa
            IF Excluir(IF(Bmsg==NIL,NIL,Bmsg))
               RETURN(2)
            ENDIF
         ENDIF
      ELSEIF ( LASTKEY()==97.OR.LASTKEY()==65 )
         IF Bativa
            SETKEY(K_INS,{||SETCURSOR(IF(READINSERT(!Insere()),1,2))})
            IF Alterar(IF(Bmsg==NIL,NIL,Bmsg))
               SETKEY(K_INS,NIL)
               RETURN(2)
            ENDIF
            SETKEY(K_INS,NIL)
         ENDIF
      ELSEIF ( LASTKEY() == K_ESC )
         GO TOP
         RETURN(0)
      ELSE
         RETURN(1)
      ENDIF
   ENDIF
   RETURN(1)
*
*
PROCEDURE Ajuda()
   LOCAL tela := SAVESCREEN(5,0,20,31)
   LOCAL corant := SETCOLOR()

   SETCOLOR(YCOREDIT)
   @ 5,0 CLEAR TO 19,29
   Quadro(5,0,19,29,1,YCOREDIT,,"Ajuda",.T.)

   @ 06,01 SAY "      sobe uma linha"
   @ 07,01 SAY "      desce uma linha"
   @ 08,01 SAY "PgDn   avanca uma pagina"
   @ 09,01 SAY "PgUp   retorna uma pagina"
   @ 10,01 SAY "^PgDn  final do arquivo"
   @ 11,01 SAY "^PgUp  inicio do arquivo"
   @ 12,01 SAY CHR(26)+"      avanca coluna"
   @ 13,01 SAY CHR(27)+"      retorna coluna"
   @ 14,01 SAY "Home   prim. coluna na tela"
   @ 15,01 SAY "End    ultima coluna na tela"
   @ 16,01 SAY "^Home  coluna inicial"
   @ 17,01 SAY "^End   coluna final"
   @ 18,01 SAY "Esc    encerra"
   INKEY(0)
   SETCOLOR(corant)
   RESTSCREEN(5,0,20,31,tela)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё               ROTINA INSER─AO NA LEITURA DE DADOS DIGITADOS               Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Insere(lNovo)
RETURN(SET(_SET_INSERT, lNovo))
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                ENCRIPTAR/DECRIPTAR SENHAS DE ACESSO                       Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Codifica(senha)
   LOCAL wSenha  := SPACE(0)
   LOCAL cLetra1 := "ABCDEFGHIJKLMNOPQRSTUVXYWZ0123456789"
   LOCAL cLetra2 := CHR(1)  +CHR(2)  +CHR(3)  +CHR(4)  +CHR(5)  +CHR(11) +CHR(9) +CHR(8)+;
                    CHR(7)  +CHR(6)  +CHR(12) +CHR(14) +CHR(15) +CHR(16) +CHR(17)+;
                    CHR(18) +CHR(19) +CHR(25) +CHR(24) +CHR(23) +CHR(22) +CHR(21)+;
                    CHR(20) +CHR(26) +CHR(27) +CHR(28) +CHR(29) +CHR(30) +CHR(31)+;
                    CHR(240)+CHR(238)+CHR(232)+CHR(135)+CHR(287)+CHR(145)+CHR(146)

   FOR x = 1 TO LEN(senha)
       cTecla1 := AT(SUBSTR(senha,x,1),cLetra1)
       cTecla2 := AT(SUBSTR(senha,x,1),cLetra2)
       IF cTecla1 = 00 .AND. cTecla2 = 00
          wSenha += SUBSTR(wSenha,x,1)
       ELSE
          IF cTecla1 # 00
             wSenha += SUBSTR(cLetra2,cTecla1,1)
          ELSE
             wSenha += SUBSTR(cLetra1,cTecla2,1)
          ENDIF
       ENDIF
   NEXT
   RETURN(wSenha)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё             PESQUISA DE CHAVE DE INDICE EM GET PENDENTE                   Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Pesq_Get(area,ordem,chave)
   IF VALTYPE(area) # "U"
      SELECT(area)
   ENDIF
   IF VALTYPE(ordem) # "U"
      SET ORDER TO ordem
   ELSE
      SET ORDER TO 0
   ENDIF

   SEEK chave
   IF FOUND()
      cNomeVar   := READVAR()
      &cNomeVar. := chave
      RETURN(.T.)
   ELSE
      Aviso("Informa┤└o n└o Cadastrada",YCORAVISO,2)
      RETURN .F.
   ENDIF
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     PESQUISA DE CHAVE DE INDICE                           Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Pesquisa(area,ordem,chave,msg1,msg2)
   LOCAL nAreaAntes:=SELECT();nOrdemAntes:=INDEXORD()

   IF VALTYPE(area) # "U"
      SELECT(area)
   ENDIF
   IF VALTYPE(ordem) # "U"
      SET ORDER TO ordem
   ELSE
      SET ORDER TO 0
   ENDIF

   IF DBSEEK(chave)
      IF msg2#NIL; Aviso(msg2,,3); ENDIF
      SELECT(nAreaAntes);DBSETORDER(nOrdemAntes)
      RETURN(.T.)
   ELSE
      IF msg1#NIL; Aviso(msg1,,3); ENDIF
      SELECT(nAreaAntes);DBSETORDER(nOrdemAntes)
      RETURN(.F.)
   ENDIF
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё             ROTINA DE VERIFICA─AO DE CORROMPIMENTO DO SISTEMA             Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Autor(lAbend,lQuit)
   DEFAULT lQuit TO .T.
   SET(_SET_DEVICE,"SCREEN")

   IF !lAbend
      DELETE FILE ABEND.TES
      SETCOLOR("")
      CLS
      SETCOLOR("N/W")
      JanelaExp(0,0,6,79,1)
      @ 01,02 SAY "SGC.EXE Copyright(c) 1994. Virtual System - Vers└o 1.0"
      @ 02,02 SAY "Data               "+DTOC(DATE())
      @ 03,02 SAY "Hora               "+TIME()
      @ 04,02 SAY "Tempo de Execu┤└o  "+ELAPTIME(cTempo,TIME())
      @ 05,02 SAY "Status             T┌rmino Normal"
      SETCOLOR("")
      @ 07,00 SAY ""
   ELSE
      SETCURSOR(1)
      SETCOLOR("")
      CLS
      SET(_SET_DEVICE,"PRINTER")
      QOUT("SGC.EXE Copyright(c) 1994. Virtual System - Vers└o 1.0")
      QOUT("ATEN─▌O => T┌rmino com ABEND  (Favor reportar erro ocorrido)")
      QOUT("")
      SET(_SET_DEVICE,"SCREEN")
   ENDIF
   IF lQuit
      QUIT
   ENDIF
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                         LIMPAR LINHA DE MENSAGENS                         Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION LimpaLinhaMsg()
   CorAntiga := SETCOLOR()
   SETCOLOR(YCORMENU)
   @ 23,00 SAY SPACE(80)
   SETCOLOR(CorAntiga)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     DISPLAY DA TECLA F2 DE PESQUISA                       Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION TeclaFuncao( TEXTO )
   CorAntes := SETCOLOR()
   SETCOLOR(YCORMENU)
   IF TEXTO <> Nil
      @ 23,64 SAY "<  > - Pesquisa"
      SETCOLOR(YCORREALCE)
      @ 23,65 SAY "F2"
   ELSE
      @ 23,64 SAY "               "
   ENDIF
   SETCOLOR(CorAntes)
   RETURN .T.
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     CONTROLE DA TECLA F2 DE PESQUISA                      Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Mostra(cProg, nLin, cVar)
   IF cProg == "consulta" .OR. cProg == "__XHELP"
      RETURN
   ENDIF
   SAVE SCREEN
   IF cProg="AP_111" .AND. LASTKEY()==K_F7
      Consulta(10, 1, "Dependentes","Grau","NOME","GRAU",NIL )
 ELSE
   IF (cProg="AP_111" .OR. cProg="AP_311" .OR. cProg="AP_331".OR.;
       cProg=="AP_341" .OR. cProg=="AP_333".OR. cProg="AP_215" .OR. cProg="CLUB3100" .OR. cProg="CLUB3111" .OR. cProg="CLUB31DD".OR.cProg="CLUB3101") .AND. cVar="WCAT"
      Consulta( 2, 1, "Categoria","Descri┤└o","CODCAT","DESCR","CODCAT" )
   ELSEIF (cProg="AP_111" .OR. cProg="AP_11A" .OR. cProg="AP_112" .OR. cProg="AP_113" .OR. ;
           cProg="AP_114" .OR. cProg="AP_120" .OR. cProg="AP_211" .OR. ;
           cProg="AP_213" .OR. cProg="AP_333" .OR. cProg="AP_347" .OR. cProg="AP_11C").AND.cVar="WNOMESOC"
      Consulta( 1, 1, "Nome","Matr║cula","NOME","MATRICULA","NOME" )
   ELSEIF (cProg="AP_213".OR.cProg="AP_333").AND.cVar="WSOCI"
      Consulta( 5, 1, "Nome","Matr║cula","NOME","MATRICULA","NOME" )
   ELSEIF (cProg="AP_111".OR.cProg="AP_345".OR.cProg="IMP346".OR.;
           cProg="CLUB3100" .OR. cProg="CLUB31DD") .AND. cVar="WFUNCAO"
      Consulta( 3, 1, "C╒digo","Descri┤└o","CODFUNC","DESCR","DESCR" )
   ELSEIF cProg="AP_111" .AND. cVar="WCOBRANCA"
      Consulta( 5, 1, "Local","Descri┤└o","CODLOCAL","DESCR","CODLOCAL" )
   ELSEIF (cProg="AP_111".OR.cProg="CLUB3100" .OR. cProg="CLUB31DD" .OR.cProg="AP_345".OR.;
           cProg="IMP346") .AND. cVar="WAREA"
      Consulta( 7, 1, "Area","Descri┤└o","AREACOMP","DESCR","AREACOMP" )
   ELSEIF cProg="AP_112" .AND. cVar="WNOMEDEP"
      Consulta( 3, 1, "Nome","Nascimento","NOME","DTNAS","NOME" )
   ELSEIF cProg="AP_112" .AND. cVar="WNOME"
      Consulta(10, 1, "Nome","Parentesco","NOME","GRAU","NOME" )
   ELSEIF (cProg="AP_112" .OR. cProg="AP_120") .AND. cVar="WCOBRANCA"
      Consulta( 2, 1, "Local","Descri┤└o","CODLOCAL","DESCR","CODLOCAL" )
   ELSEIF (cProg="AP_120".OR.cProg="AP_334".OR.cProg="AP_348").AND.cVar="WNOMEUSU"
      Consulta( 3, 1, "Nome","Matricula","NOME","MATRICULA","NOME" )
   ELSEIF cProg="PEGAATIV" .AND. cVar="WATIVIDADE"
      Consulta( 5, 1, "C╒d.Ativ.","Descri┤└o","CODATIV","DESCR","CODATIV" )
   ELSEIF cProg="AP_140" .AND. cVar="WCOD"
      Consulta( 1, 2, "CLIENTE","CODIGO","NOMEC","CODCLI","CODCLI" )
   ELSEIF (cProg="ENTRATELA".OR.cProg="MOSTRATELA") .AND. cVar="WRESPON"
      Consulta( 2, 1, "Nome","Matricula","NOME","MATRICULA","NOME" )
   ELSEIF (cProg="AP_212".OR.cProg="AP_214").AND. cVar="WNOMEUSU"
      Consulta( 4, 2, "Nome","Matr║cula","NOME","MATRICULA","NOME" )
   ELSEIF (cProg="AP_212".OR.cProg="AP_214".OR.cProg="AP_332") .AND. cVar="WATIV"
      Consulta( 2, 1, "C╒d.Ativ.","Descri┤└o","CODATIV","DESCR","CODATIV" )
   ELSEIF cProg="AP_311".AND. (cVar="WNOMEINI" .OR. cVar="WNOMEFIM")
      Consulta( 1, 1, "Nome","Matr║cula","NOME","MATRICULA","NOME" )
   ELSEIF cProg="AP_311".AND. (cVar="WMATRINI" .OR. cVar="WMATRFIM")
      Consulta( 1, 2, "Nome","Matr║cula","NOME","MATRICULA","NOME" )
   ELSEIF cProg="AP_311" .AND. cVar="WCOBRANCA"
      Consulta( 3, 1, "Local","Descri┤└o","CODLOCAL","DESCR","CODLOCAL" )
   ELSEIF (cProg="AP_311".OR.cProg="AP_111".OR.cProg="AP_342".OR.;
           cProg="CLUB3100".or. cProg="CLUB31DD".OR.cProg="CLUB3101").AND.cVar="WUNIDADE"
      Consulta( 6, 1, "Descri┤└o",,"DESCR",,"DESCR")
   ELSEIF cProg="CLUB1100".and.cVar=="NMATRICULA"
      Consulta( 1, 1,"Codigo","Socio","MATRICULA","NOME","MATRICULA")
   ELSEIF cProg="CLUB1200" .and. cVar="WNOMEC"
      Consulta( 1, 1, "Convidado",,"NOMEC",,"NOMEC" )
   ELSEIF cProg="CLUB2100" .and. cVar="CNOMESOC"
      Consulta( 1, 1, "Codigo", "Socio", "MATRICULA", "NOME", "NOME" )
   ELSEIF cProg="CLUB2100" .and. cVar="CNOMEC"
      Consulta( 2, 1, "Convidado", ,"NOMEC", , "NOMEC" )
   ELSEIF cProg="CLUB3200" .and. cVar="CNOMECONV"
      Consulta( 3, 1, "Convidado", ,"NOME", , "NOME" )
   ELSEIF cProg="CLUB3500" .and. cVar="WATIVIDADE"
      Consulta( 3, 1, "C╒d.Ativ.","Descri┤└o","CODATIV","DESCR","CODATIV" )
   ELSEIF cProg="CLUB3310".AND. cVar="CCODSOC"
      Consulta( 2, 2, "Nome","Matr║cula","NOME","MATRICULA","MATRICULA" )
   ELSEIF cProg="AP_380".AND. cVar="WMATRIC"
      Consulta( 1, 2, "Nome","Matr║cula","NOME","MATRICULA","MATRICULA" )
   ENDIF
 ENDIF
   RESTORE SCREEN
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                 CONTROLE DE OPERACAOES DELECAO E ALTERACAO                Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION DeleAltera()
   CorAntes := SETCOLOR()
   TelAntes := SAVESCREEN(22,00,23,79)
   SETCOLOR(YCOREDIT)
   SETCURSOR(0)
   @ 23,01 SAY "Informe a Opera┤└o.   (     ) Altera   (   ) Exclui       "
   SETCOLOR(YCORREALCE)
   @ 23,24 SAY "ENTER"
   @ 23,41 SAY "DEL"
   WHILE .T.
      INKEY(0)
      IF LASTKEY()==K_ESC .OR. LASTKEY()==K_ENTER .OR. LASTKEY()==K_DEL
         EXIT
      ENDIF
   ENDDO
   SETCOLOR(CorAntes )
   RESTSCREEN(22,00,23,79,TelAntes)
   SETCURSOR(1)
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                   DISPLAY DE MENSAGEM AGUARDANDO PROCESSAMENTO            Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Aguardar(Par1)
   CorAntes := SETCOLOR()
   ModAnTes := SETCURSOR()

   SETCURSOR( 0 )
   SETCOLOR( "" )
   IF Par1 == Nil
      ImplodBox()
   ELSE
      nCol := 76 - LEN(Par1)
      ExplodBox( 21, nCol, 23, 77 )
      //SETCOLOR("W+*/N")
      SETCOLOR(YCORAVISO)
      @ 22,nCol+01 SAY Par1
      SETCOLOR("")
   ENDIF
   SETCURSOR( ModAntes )
   SETCOLOR( CorAntes )
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё               ROTINA DE CALCULO DE DIGITO VERIFICADOR DE CPF              Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION ChkCPF(NumCpf)
   Resultado := .T.
   IF (INKEY()=K_ESC) .OR. (NumCpf = SPACE(11))
      Aviso("Campo Obrigat╒rio...",,1)
      Resultado := .F.
   ELSE
      Total=0
      FOR K=2 to 10
          Total := VAL(SUBSTR(NumCpf,11-K,1))*K + ToTal
      NEXT
      Quoc  := INT(Total/11)
      Resto := Total-(Quoc*11)
      Resto := 11-Resto
      IF Resto > 9
         R1 := 0
      ELSE
         R1 := Resto
      ENDIF
      Total := 0
      FOR K = 2 TO 11
          Total := VAL(SUBSTR(NumCpf,12-K,1))*K + ToTal
      NEXT
      Quoc  := INT(Total/11)
      Resto := Total-(Quoc*11)
      Resto := 11 - Resto
      IF Resto > 9
         R2 := 0
      ELSE
         R2 := Resto
      ENDIF

      DV := STR(R1,1) + STR(R2,1)
      IF DV<>SUBSTR(NumCpf,10,2)
         Aviso("Digito verificador do CPF Inv═lido",,3)
         Resultado := .F.
      ENDIF
   ENDIF
   RETURN(Resultado)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                  ROTINA DE CHECAGEM DE ESTADO VALIDO                      Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION ChkUF(WUFC)
   LOCAL aArray := ARRAY(1)
   aArray := {"PA","CE","RN","SP","ES","BA","RS","MG","PR","MS","GO",;
              "RJ","SE","AL","SC","PE","RO","MA","PR","DF","MT","PB",;
              "PI","AM","TO","AC","AP"}
   IF ASCAN(aArray,WUFC) <> 0
      RETURN .T.
   ENDIF
   Aviso("Estado Inv═lido",,3)
   RETURN .F.
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                          ABERTURA DE ARQUIVO EM REDE                      Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION NetUse( Arquivo, Apelido, Modo )
   LOCAL msg, nSeconds
   Msg     := "N└o Foi Possivel Iniciar. Continua Tentando ?"
   Modo    := IF( Modo = NIL, "C", Modo )
   Apelido := IF( Apelido = NIL, Arquivo, Apelido )
   WHILE .T.
      nSeconds := 3
      WHILE nSeconds > 0
         IF Modo == "E"
            USE ( Arquivo ) ALIAS ( Apelido ) EXCLUSIVE
         ELSE
            USE ( Arquivo ) ALIAS ( Apelido ) SHARED
         ENDIF
         IF ! NETERR()
            RETURN .T.
         ENDIF
         INKEY(0.5)
         nSeconds -= 0.5
      ENDDO
      IF !Confirma(msg)
         RETURN .F.
      ENDIF
   ENDDO
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                             INCLUIR REGISTRO EM REDE                      Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION NetApp ( Arquivo )
   LOCAL msg, nSeconds, SeleAnt := SELECT()
   Msg := "N└o Foi Possivel Atualizar. Continua Tentando ?"
   IF Arquivo != NIL
      SELECT (Arquivo)
   ENDIF
   WHILE .T.
      nSeconds := 3
      WHILE nSeconds > 0
         DBAPPEND()
         IF !NETERR()
            RETURN .T.
         ENDIF
         INKEY(0.5)
         nSeconds -= 0.5
      ENDDO
      IF !Confirma(Msg)
         RETURN .F.
      ENDIF
   ENDDO
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                             BLOQUEAR ARQUIVO                              Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION NetLArq()
   LOCAL msg, nSeconds
   Msg := "N└o Foi Possivel Atualizar. Continua Tentando ?"
   WHILE .T.
      nSeconds := 3
      WHILE nSeconds > 0
         IF FLOCK()
            RETURN .T.
         ENDIF
         INKEY(0.5)
         nSeconds -= 0.5
      ENDDO
      IF !Confirma(msg)
         Return .F.
      ENDIF
   ENDDO
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                             BLOQUEAR REGISTRO                             Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION NetLReg()
   LOCAL nSeconds
   WHILE .T.
      nSeconds := 2
      WHILE nSeconds > 0
         IF RLOCK()
            RETURN .T.
         ENDIF
         INKEY(0.5)
         nSeconds -= 0.5
      ENDDO
      Aviso("N└o Foi Possivel Acessar. Tecle algo...")
      RETURN .F.
   ENDDO
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                             ENCONTRAR REGISTRO                            Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Ptab(cSeek,nSelect,nOrder,cTexto,lEncontre)
   IF lEncontre = Nil
      lEncontre := .T.
   ENDIF
   lTab := .T.
   nSelectAntes := SELECT()
   nOrderAntes  := INDEXORD()
   DBSELECTAREA( nSelect )
   DBSETORDER( nOrder )
   DBSEEK( cSeek )
   IF lEncontre
      IF EOF()
         Aviso( cTexto )
         lTab := .F.
      ENDIF
   ELSE
      IF !EOF()
         Aviso( cTexto )
         lTab := .F.
      ENDIF
   ENDIF
   DBSELECTAREA( nSelectAntes )
   SET ORDER TO nOrderAntes
   RETURN lTab
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                          DESENHAR MENSAGEM DE QUADRO                      Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION MsgTela(nLin,nCol,sTexto,lModo)
   LOCAL nTamStr:=LEN(sTexto)
   lModo:=IF(lModo==NIL,.F.,.T.)
   @ nLin,nCol         SAY sTexto            COLOR YCORAVISO
   @ nLin,nCol+nTamStr SAY "э"               COLOR YCOREDIT
   @ nLin+1,nCol+1     SAY REPL("ъ",nTamStr) COLOR YCOREDIT
   RETURN NIL

/* Consulta com ate tres campos
Func Consulta1(nDbf,nInd,Cab1,Cab2,Cab3,Camp1,Camp2,Camp3,Retorno,Masc1,Masc2,Masc3)
     LOCAL Tabela,lSup,lInf,cEsq,cDir,v1,v2,nCursor:=SetCursor()

     BUFFER:=""
     corAnterior := SetColor( )
     nSelectAntes := Select()
     nOrderAntes := Indexord()

     dbSelectArea( nDbf )
     dbSetOrder( nInd )
     aDbStru:=DBSTRUCT()

     v1 := aDbStru[ascan(aDbStru,{|aVetAux|aVetAux[1]==Camp1})][3]
     v2 := if(Camp2 # NIL,aDbStru[ascan(aDbStru,{|aVetAux|aVetAux[1]==Camp2})][3],0)
     v3 := if(Camp3 # NIL,aDbStru[ascan(aDbStru,{|aVetAux|aVetAux[1]==Camp3})][3],0)
     v4 := len(Cab1)
     v5 := if(cab2#nil,len(cab2)+2,0)
     v6 := if(cab3#nil,len(cab3)+3,0)
     v7 := if(Masc1#nil,len(Masc1),2)
     v8 := if(Masc2#nil,len(Masc2),2)
     v9 := if(Masc3#nil,len(Masc2),2)

     nTamCamp := v1+v2+v3
     nTamCab  := v4+v5+v6
     nTamMasc := v7+v8+v9
     nTam:=Max(nTamCamp,nTamCab)
     nTam:=Max(nTam,nTamMasc)

     lSup    := 03
     cDir    := 76
     cEsq    := 77-nTam
     nLinhas := 0
     
     go top
     for nn := 1 to 20
         if ! (bof() .and. eof())
            nLinhas++
         endif
         dbSkip()
         if eof() .or. nLinhas > 9
            exit
         Endif
     next

     if nLinhas <> 0
        if nLinhas > 9
           lInf := 18
        else
           lInf := lSup + 03 + nLinhas
        Endif
        Tabela:=TBROWSEDB(lSup+1, cEsq+1, lInf-1, cDir-1)

        Telas(lSup,cEsq,lInf+2,cDir, c_nBorda, c_cCorHelp, .T. )
        Telas(lInf,cEsq,lInf+2,cDir, c_nBorda, c_cCorHelp, .T. )

        @ lInf,cEsq+1 to lInf,cDir-1 COLOR c_cCorHelp

        TABELA:HEADSEP:=chr(194)+chr(196)
        TABELA:COLORSPEC:=c_cCorHelp

        @ lInf+1,cEsq+1 say ""
        COLUNA:=TBCOLUMNNEW(CAB1,FIELDBLOCK(CAMP1))
        IF TYPE(CAMP1)=="N"
           COLUNA:COLORBLOCK:={|CAMPO| IF (CAMPO>=0,{3,4},{5,6})}
        ENDIF
        COLUNA:COLSEP:=CHR(179)
        TABELA:ADDCOLUMN(COLUNA)
        if Masc1#nil
           COLUNA:picture:=Masc1
        endif

        IF CAB2 <> NIL
           COLUNA:=TBCOLUMNNEW(CAB2,FIELDBLOCK(CAMP2))
           IF TYPE(CAMP2)=="N"
              COLUNA:COLORBLOCK:={|CAMPO| IF (CAMPO>=0,{3,4},{5,6})}
           ENDIF
           COLUNA:COLSEP:=CHR(179)
           TABELA:ADDCOLUMN(COLUNA)
           if Masc2#nil
              COLUNA:picture:=Masc2
           endif
        ENDIF

        IF CAB3 <> NIL
           COLUNA:=TBCOLUMNNEW(CAB3,FIELDBLOCK(CAMP3))
           IF TYPE(CAMP3)=="N"
              COLUNA:COLORBLOCK:={|CAMPO| IF (CAMPO>=0,{3,4},{5,6})}
           ENDIF
           COLUNA:COLSEP:=CHR(179)
           TABELA:ADDCOLUMN(COLUNA)
           if Masc3#nil
              COLUNA:picture:=Masc3
           endif
        ENDIF
     else
        Aviso("Banco de Dados Vazio",,3)
        SetCursor(1)
        dbSelectArea( nSelectAntes )
        Set Order to nOrderAntes
        SetColor( CorAnterior )
        RETURN .T.
     endif

     TABELA:FREEZE:=1
     go top
     BUFFER:=""
     While .T.
        SetCursor( 0 )
        While ! TABELA:STABILIZE();Enddo
           A:=Inkey(0)
           IF A==K_UP
              TABELA:UP()
           ELSEIF A==K_DOWN
              TABELA:DOWN()
           ELSEIF A==K_RIGHT
              TABELA:RIGHT()
           ELSEIF A==K_LEFT
              TABELA:LEFT()
           ELSEIF A==K_PGUP
              TABELA:PAGEUP()
           ELSEIF A==K_PGDN
              TABELA:PAGEDOWN()
           Elseif A==K_ESC .or. A==K_ENTER
              REST_TELA()
              REST_TELA()
              SetCursor( 1 )
              if A==K_ENTER
                 if valtype(&RETORNO) == "D"
                    keyb DTOC(&RETORNO)+CHR(13)
                 else
                    Keyb &RETORNO+CHR(13)
                 ENDIF
              Endif
              dbSelectArea( nSelectAntes )
              Set Order to nOrderAntes
              SetColor( CorAnterior )
              RETURN .T.
           ELSEIF A>=32 .AND. A<=127 .OR. A==K_BS .OR. A==K_CTRL_L
              SMARTSEEK(UPPER(CHR(A)))
              TABELA:REFRESHALL()
        ENDIF
     ENDDO */
*умммммммммммммммммммммммммммммммм╦
*Ё Mensagem de Espera             Ё
*тмммммммммммммммммммммммммммммммм╬
FUNCTION WaitMsg(pTexto,pBeep)
   LOCAL tecla:=INKEY(.09), nCursor:=SETCURSOR(); cCorAntes:=SETCOLOR()
   DEFAULT pTexto TO "Pressione qualquer tecla para continuar..."
   DEFAULT pBeep  TO .T.

   Mensagem()
   IF pBeep; Beep(2); ENDIF
   SETCOLOR(YCORMENU); SETCURSOR(0)
   pTexto := SPACE(5) + pTexto + SPACE(5)
   WHILE tecla # K_ENTER
      FOR i = 1 TO 400; NEXT
      pTexto := SUBSTR(pTexto,2,LEN(pTexto)) + SUBSTR(pTexto,1,1)
      @ 23,00 SAY PADC(pTexto,80)
      tecla := INKEY(.09)
      IF tecla # 0
         tecla := K_ENTER
      ENDIF
   ENDDO
   Mensagem()
   SETCURSOR(nCursor); SETCOLOR(cCorAntes)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                  ROTINA DE IMPRESSAO DO ARQUIVO TEXTO GERADO              Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Fim_TXT(pArq)
   SET PRINT OFF
   SET PRINTER TO
   SET DEVICE TO SCREEN
*   SAVESCREEN(0,0,24,79)
*   RUN nodosimp Arq 80 pre
*   RESTSCREEN(0,0,24,79,0)
   RETURN
