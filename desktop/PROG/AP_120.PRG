*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_120                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cadastrar Usu rios das Atividades        ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 13/10/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PROCEDURE AP_120(pOper)

DBCLOSEALL()
SELECT 6
IF !NetUse("DBPARM")
   RETURN
ENDIF

// Gerar arquivo temporario
aDbf:={}
AADD( aDbf, { "CODATIV" ,"C", 02, 0 } )
AADD( aDbf, { "DESCR"   ,"C", 50, 0 } )
AADD( aDbf, { "DTADESAO","D", 08, 0 } )

WHILE .T.
   sHour:=TIME()
   cArq1:="TM"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE( cArq1, aDbf )
      RELEASE aDbf
      EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")
INDEX ON codativ TO (cArq1)

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2,DBISOCA1,DBISOCA3,DBISOCA4,DBISOCA5,DBISOCA6,DBISOCA7,DBISOCA8
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("COBRANCA")
   SET INDEX TO DBICOBR1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("USUARIOS")
   SET INDEX TO DBIUSU1,DBIUSU2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 4
IF NetUse("USUATIV")
   SET INDEX TO DBIUSAT1,DBIUSAT2,DBIUSAT3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 5
IF NetUse("ATIV")
   SET INDEX TO DBIATIV1
ELSE
   DelDbfNtx(); RETURN
ENDIF

PUBLIC Altera
cOpHelp1 := "1"; cOpHelp2 := "10"
LinhaMsg(2); ProgName("GC120")
SET KEY -1 TO Mostra()
WHILE .T.
   SETCOLOR(YCOREDIT)
   lNovo := lDeleta := lSocio := .F.
   wNomeSoc := SPACE(50)
   wNomeUsu := SPACE(50)
   IF pOper=1
      cVar := "wNomeSoc"
   ELSE
      cVar := "wNomeUsu"
   ENDIF
    
   Telas(18,3,20,62,1,YCOREDIT,.T.)
   Mensagem("Informe Nome do Usu rio")
   @ 19,05 SAY "Nome:" GET &cVar. PICT "@!" WHEN TeclaFuncao(.T.)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao(); Rest_Tela()
   IF LASTKEY()==K_ESC .OR. EMPTY(IF(pOper=1,wNomeSoc,wNomeUsu))
      EXIT
   ENDIF

   SELECT USUARIOS
   IF DBSEEK(IF(pOper=1,wNomeSoc,wNomeUsu))
      Altera    := .T.
      wMatricula:= MATRICULA
      IF pOper==1
         Aviso("Usu rio j  Cadastrado !")
         LOOP
      ENDIF
      IF (pOper==2.OR.pOper==3).AND.!NetLReg()
         LOOP
      ENDIF
   ELSE
      IF pOper>=2
         Aviso("Usu rio no Cadastrado !")
         LOOP
      ENDIF
   ENDIF
   FOR a = 1 TO FCOUNT()
       xVar  := "w"+FIELDNAME(a)
       &xVar := FIELDGET(a)
   NEXT

   SELECT SOCIOS
   IF DBSEEK(IF(pOper=1,wNomeSoc,wNomeUsu))
      wRG       := RG
      wCPF      := CPF
      wEndereco := ENDERECO
      wBairro   := BAIRRO
      wCidade   := CIDADE
      wTel      := TEL
      lSocio    := .T.
   ENDIF
   SELECT USUARIOS
   wNome := IF(pOper=1,wNomeSoc,wNomeUsu)
   wNomeAnt := IF(pOper=1,wNomeSoc,wNomeUsu)

   Telas(3,3,15,76,1,YCOREDIT,.T.,IF(pOper=1,"Incluso",IF(pOper=2,"Alterao",IF(pOper=3,"Excluso","Consulta")))+" de Usu rios")
   TCobra1(6,24,wCobranca)
   @ 04,05 SAY "       Nome:"  GET wNome      PICT "@!" WHEN IF(pOper==2,.T.,.F.)
   @ 05,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 12,38 SAY "   Matric.:"   GET wMatricula WHEN .F. COLOR YCORREALCE

   LimpaLinhaMsg()
   @ 06,05 SAY "    Cobrana:" GET wCobranca  PICT "99" WHEN TeclaFuncao(.T.) ;
               VALID !EMPTY(wCobranca).AND.TCobra1(6,24,wCobranca)
   @ 07,05 SAY " Respons vel:" GET wRespon    PICT "@!"
   @ 08,05 SAY "  Identidade:" GET wRG        WHEN !lSocio
   @ 08,38 SAY "       CPF:"   GET wCPF       PICT "@R 999.999.999-99" WHEN !lSocio VALID EMPTY(wCPF).OR.ChkCPF(wCPF)
   @ 09,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 10,05 SAY "    Endereo:" GET wEndereco  PICT "@!S50" WHEN !lSocio
   @ 11,05 SAY "      Bairro:" GET wBairro    PICT "@!"    WHEN !lSocio
   @ 11,38 SAY "    Cidade:"   GET wCidade    PICT "@!"    WHEN !lSocio
   @ 12,05 SAY "        Fone:" GET wTel       PICT "@R (999) 999-9999" WHEN !lSocio
   @ 13,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 14,05 SAY "  Observao:" GET wObs       PICT "@!"

   SELECT USUARIOS
   IF EOF()
      SETCURSOR(1); READ; SETCURSOR(0)
      msg   := "Confirma os Dados ? "
      lNovo := .T.
      IF LASTKEY()==K_ESC
         Rest_Tela(); LOOP
      ENDIF
   ELSE
      IF nNivel==1
         Mensagem("Tecle algo para continuar..."); INKEY(0)
         CLEAR GETS
         Rest_Tela()
         LOOP
      ENDIF
      IF pOper==2
         msg := "Confirma Alterao ? "
         SETCURSOR(1); READ; SETCURSOR(0)
         IF LASTKEY()==K_ESC
            UNLOCK; Rest_Tela(); LOOP
         ENDIF

         SELECT USUATIV
         IF DBSEEK(wNomeAnt)
            /* Gravar no Arquivo temporario os dados encontrados */
            WHILE NOME==wNomeAnt.AND.!EOF()
               SELECT (cArq1)
               NetApp()
               FIELD->CODATIV  := USUATIV->ATIVIDADE
               FIELD->DTADESAO := USUATIV->DTINSCR
               SELECT USUATIV
               IF NetLReg()
                  FIELD->NOME := wNome; UNLOCK
               ENDIF
               DBSKIP()
            ENDDO
         ENDIF
         wNomeUsu:=wNome
      ELSEIF pOper==3
         CLEAR GETS
         IF Confirma("Confirma a Excluso ? ")
            /* Eliminar Dados de USUARIOS e USUATIV */
            SELECT USUARIOS
            DBDELETE()
            SELECT USUATIV; SET ORDER TO 2
            DBSEEK(wMatricula)
            WHILE MATRICULA==wMatricula .AND. !EOF()
               WHILE !NetLReg(); ENDDO
               DBDELETE(); UNLOCK
               DBSKIP()
            ENDDO
            SET ORDER TO 1
         ENDIF
         SELECT USUARIOS; UNLOCK
         Rest_Tela()
         LOOP
      ELSEIF pOper==4
         CLEAR GETS
         SELECT USUATIV
         IF DBSEEK(IF(pOper=1,wNomeSoc,wNomeUsu))
            /* Gravar no Arquivo temporario os dados encontrados */
            WHILE NOME==IF(pOper=1,wNomeSoc,wNomeUsu) .AND. !EOF()
               SELECT (cArq1)
               NetApp()
               FIELD->CODATIV  := USUATIV->ATIVIDADE
               FIELD->DTADESAO := USUATIV->DTINSCR
               SELECT USUATIV
               DBSKIP()
            ENDDO
         ENDIF
      ENDIF
   ENDIF
   SELECT USUARIOS
   UNLOCK

   IF LASTKEY()==K_ESC
      Rest_Tela(); EXIT
   ENDIF
   RotAtiv(pOper)      /* Rotina de Digitacao das Atividades */
   SELECT (cArq1)
   ZAP                 /* Limpa arquivo temporario */
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL)
DelDbfNtx(); RETURN
*ีอออออออออออออออออออออออออออออออออธ
*ณ Digitar Servios da Guia        ณ
*ิอออออออออออออออออออออออออออออออออพ
STATIC FUNCTION RotAtiv(pOper)
   LOCAL aCab[3], aCam[3], aPic[3]

   IF pOper#4
      SCROLL(24,00,24,79)
      @ 24,02 SAY "Op”es:   Inclui     Altera     Exclui         Confirma Atividade"
*                  234567890123456789012345678901234567890123456789012345678901234567890123456789
*                          1         2         3         4         5         6         7
      @ 24,10 SAY "I-"  COLOR YCORREALCE
      @ 24,21 SAY "A-"  COLOR YCORREALCE
      @ 24,32 SAY "E-"  COLOR YCORREALCE
      @ 24,43 SAY "ENTER-" COLOR YCORREALCE
   ENDIF

   aCab[1] := "Cขd.Ativ."
   aCab[2] := "Descrio da Atividade"
   aCab[3] := "Dt.Inscr"
   *
   aPic[1] := "99"
   aPic[2] := "@!"
   aPic[3] := "@D"
   *
   aCam[1] := "CODATIV"
   aCam[2] := "TAtiv(CODATIV)"
   aCam[3] := "DTADESAO"
   *
   VisualDBF(10,1,16,4,20,75,aCab,aCam,aPic,IF(pOper==4,.F.,.T.),.T.)
   Mensagem()
   LinhaMsg(2)
   RETURN .T.
*ีอออออออออออออออออออออออออออออออออธ
*ณ Visualizar DBF                  ณ
*ิอออออออออออออออออออออออออออออออออพ
FUNCTION VisualDBF(area,ordem,t,l,b,r,cabec,campo,pic,ativa,sombra)
   LOCAL corant := SETCOLOR(), cursor := SETCURSOR(), tela:=SAVESCREEN(0,0,24,79)
   PUBLIC lAtivo

   aRegDel:={}
   lAtivo := ativa          /* Permitir edicao ou nao do Banco de Dados */
   IF VALTYPE(area) # "U"
      DBSELECTAREA(area)
   ENDIF
   IF VALTYPE(ordem) # "U"
      SET ORDER TO ordem
   ELSE
      SET ORDER TO 0
   ENDIF
   DBGOTOP()
   SETCOLOR(YCOREDIT)
   SETCURSOR(0)

   Telas(t-1,l-1,b+1,r+1,1,YCOREDIT,sombra)
   DBEDIT(t,l,b,r,campo,"ProcTecl",pic,cabec,"ฤ","ณ")
   SETCOLOR(corant)
   SETCURSOR(cursor)
   RELEASE lAtivo
   Rest_Tela()
   RESTSCREEN(0,0,24,79,tela)
   RETURN .T.
*ีอออออออออออออออออออออออออออออออออธ
*ณ Processa Tecla Digitada         ณ
*ิอออออออออออออออออออออออออออออออออพ
FUNCTION ProcTecl(modo)
   IF modo == 1 .OR. modo == 2
      TONE(125,0)
   ELSEIF modo == 4
      IF ( LASTKEY() == K_ESC )
         DBGOTOP()
         RETURN(0)
      ELSEIF ( LASTKEY()==105.OR.LASTKEY()==73)  /* Incluir Atividade */
         IF lAtivo
            IF PegaAtiv("I")
               SELECT (cArq1)
               RETURN(2)
            ENDIF
         ENDIF
      ELSEIF ( LASTKEY()==97.OR.LASTKEY()==65 )  /* Alterar Atividade */
         IF lAtivo
            IF CODATIV#SPACE(2)
               IF PegaAtiv("A")
                  SELECT (cArq1)
                  RETURN(2)
               ENDIF
            ELSE
               Aviso("No h  dado a ser Alterado")
            ENDIF
         ENDIF
      ELSEIF ( LASTKEY()==101.OR.LASTKEY()==69 )  /* Excluir Atividade */
         IF lAtivo
            IF CODATIV#SPACE(2)
               IF Confirma("Confirma Excluso da Atividade ?")
                  SELECT (cArq1)
                  AADD(aRegDel,{IF(!EMPTY(wNomeSoc),wNomeSoc,wNomeUsu),CODATIV})
                  DBDELETE()
                  RETURN(2)
               ENDIF
            ELSE
               Aviso("No h  Atividade a ser Excluida")
            ENDIF
         ENDIF
      ELSEIF ( LASTKEY()== K_ENTER )    /* Confirmar Digitao da Atividade */
         IF lAtivo
            DBGOTOP()
            IF EOF()
               Aviso("No h  Atividade(s) informada(s)")
               RETURN(1)
            ELSE
               IF LASTKEY() <> K_ESC
                  IF Confirma(msg)
                     SELECT USUARIOS
                     IF lNovo
                        IF !NetApp()
                           RETURN(1)
                        ENDIF
                     ENDIF
                     SELECT DBPARM
                     DBGOTOP()
                     IF EOF() ; NetApp() ; ENDIF
                     IF NetLReg()
                        IF lNovo
                           wMatricula := STRZERO(VAL(MATUSU)+1,5)
                           FIELD->MATUSU := wMatricula
                        ENDIF
                        UNLOCK
                        SELECT USUARIOS
                        IF NetLReg()
                           FOR a = 1 TO FCOUNT()
                               xVar  := "w"+FIELDNAME(a)
                               FIELDPUT(a,&xVar)
                           NEXT
                           UNLOCK
                        ENDIF

                        /* Eliminar as atividades excluidas */
                        IF LEN(aRegDel) > 0
                           SELECT USUATIV
                           FOR u = 1 TO LEN(aRegDel)
                               DBSEEK(aRegDel[u,1]+aRegDel[u,2])
                               IF NetLReg()
                                  DBDELETE()
                               ENDIF
                           NEXT
                        ENDIF
                        IF lNovo
                           @ 12,50 SAY wMatricula COLOR YCORREALCE
                           Mensagem("Tecle algo para continuar...")
                           INKEY(0)
                        ENDIF

                        /* Gravar em USUATIV as atividades confirmadas */
                        SELECT (cArq1)
                        WHILE !EOF()
                           SELECT USUATIV
                           IF !Altera
                              IF !NetApp()
                                 RETURN(1)
                              ENDIF
                           ELSE
                              IF !DBSEEK(IF(!EMPTY(wNomeSoc),wNomeSoc,wNomeUsu)+(cArq1)->CODATIV)
                                 IF !NetApp()
                                    RETURN(1)
                                 ENDIF
                              ELSE
                                 IF !NetLReg()
                                    RETURN(1)
                                 ENDIF
                              ENDIF
                           ENDIF
                           FIELD->MATRICULA := wMatricula
                           FIELD->NOME      := IF(!EMPTY(wNomeSoc),wNomeSoc,wNomeUsu)
                           FIELD->ATIVIDADE := (cArq1)->CODATIV
                           FIELD->DTINSCR   := (cArq1)->DTADESAO
                           UNLOCK
                           SELECT (cArq1)
                           DBSKIP()
                        ENDDO
                        DBCOMMITALL()
                     ELSE
                        UNLOCK
                        CLEAR GETS
                        RETURN(0)
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
            RETURN(0)
         ENDIF
      ELSE
         RETURN(1)
      ENDIF
   ENDIF
   RETURN(1)
*ีออออออออออออออออออออออออออออออธ
*ณ Registrar Atividade          ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION PegaAtiv(wOper)
   PUBLIC wExiste
   SELECT (cArq1)
   IF wOper=="I"
      wDtinscr  := CTOD("")
      wAtividade:= SPACE(2)
      wExiste   := .F.
   ELSE
      wDtinscr  := DTADESAO
      wAtividade:= CODATIV
      wExiste   := .T.
   ENDIF

   Telas(14,35,17,70,1,YCOREDIT,.T.)
   MsgTela(14,37," Atividade ")
   SETCURSOR(1)
   @ 15,50 SAY "Cขdigo:" GET wAtividade PICT "99" WHEN !wExiste;
     VALID !EMPTY(wAtividade).AND.Ptab(wAtividade,5,1,"Atividade no Cadastrada");
     .AND. TCadAtiv(wAtividade)
   @ 16,38 SAY " Data de Inscrio:" GET wDtinscr PICT "@D" VALID !EMPTY(wDtinscr)
   READ

   Rest_Tela()
   SETCURSOR(0)
   IF LASTKEY()==K_ESC
      SELECT (cArq1)
      RETURN .F.
   ENDIF

   SELECT (cArq1)               /* Gravar em Arquivo temporario */
   IF wOper=="I"
      NetApp()
   ENDIF
   FIELD->CODATIV  := wAtividade
   FIELD->DESCR    := ATIV->DESCR
   FIELD->DTADESAO := wDtinscr
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Excluir Arquivo Temporario   ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION DelDbfNtx()
   DBCLOSEALL()
   fDbf1:=cArq1+".DBF"
   fNtx1:=cArq1+".NTX"
   ERASE (fDbf1)
   ERASE (fNtx1)
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Validar Atividade            ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TAtiv(pAtiv)
   LOCAL cArq:=SELECT()
   IF !EMPTY(pAtiv)
      SELECT ATIV
      IF DBSEEK(pAtiv)
         pAtiv := DESCR
         SELECT(cArq)
         RETURN(pAtiv)
      ELSE
         Aviso("Atividade no Cadastrada")
         SELECT(cArq)
         RETURN .F.
      ENDIF
   ENDIF
   RETURN(SPACE(50))
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Atividade Cadastrada  ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TCadAtiv(pAtiv)
   LOCAL cArq:=SELECT()
   SELECT (cArq1)
   IF DBSEEK(pAtiv)
      Aviso("Atividade j  Informada")
      SELECT(cArq)
      RETURN .F.
   ENDIF
   RETURN .T.
