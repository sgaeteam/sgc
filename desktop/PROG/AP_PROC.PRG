*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_PROC                          vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Procedimentos Auxiliares                 ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 09/08/1994                               ณ
*ณ ATUALIZACAO    : 27/08/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

*ีออออออออออออออออออออออออออออออธ
*ณ Incluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Incluir(msg)
   LOCAL nReg_Ant := RECNO(), lInc := .F.

   SETCOLOR(YCOREDIT)
   cArea := ALIAS()
   IF cArea=="CATEG" .OR. cArea=="ATIVIDADE"
      Telas(16,2,20,60,c_nBorda,YCOREDIT,.T.," Incluso ")
      @ 17,3 SAY "Categoria  :"
      @ 18,3 SAY "Descrio  :"
      @ 19,3 SAY "Mensalidade:"
   ELSEIF cArea=="COBRANCA" .OR. cArea=="FUNC"
      Telas(16,2,19,60,c_nBorda,YCOREDIT,.T.," Incluso ")
      @ 17,3 SAY "Cขdigo   :"
      @ 18,3 SAY "Descrio:"
   ELSEIF cArea=="UNIDADE"
      Telas(16,2,18,40,c_nBorda,YCOREDIT,.T.," Incluso ")
      @ 17,3 SAY "Descrio:"
   ELSEIF cArea=="AREAC"
      Telas(16,2,19,45,c_nBorda,YCOREDIT,.T.," Incluso ")
      @ 17,3 SAY "Area     :"
      @ 18,3 SAY "Descrio:"
   ELSEIF cArea=="USER"
      Telas(16,2,20,39,c_nBorda,YCOREDIT,.T.," Incluso ")
      @ 17,3 SAY "Chave   :"
      @ 18,3 SAY "Usu rio :"
      @ 19,3 SAY "Senha   :"
   ENDIF

   SETCURSOR(1)
   GO BOTTOM
   WHILE .T.
      IF cArea=="CATEG"
         cMsg_Aux := "Categoria"
         cCod3    := 0
         Mensagem("Preencha com a Cขdigo da Categoria")
         @ 17,16 GET cCod3 PICT "99" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ELSEIF cArea=="ATIVIDADE"
         cMsg_Aux := "Atividade"
         cCod3    := 0
         Mensagem("Preencha com a Cขdigo da Atividade")
         @ 17,16 GET cCod3 PICT "99" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ELSEIF cArea=="COBRANCA"
         cMsg_Aux := "Cขdigo"
         cCod3    := 0
         Mensagem("Preencha com a Cขdigo do Local de Cobrana")
         @ 17,14 GET cCod3 PICT "99" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ELSEIF cArea=="FUNC"
         cMsg_Aux := "Cขdigo"
         cCod3    := 0
         Mensagem("Preencha com a Cขdigo da Funo")
         @ 17,14 GET cCod3 PICT "99" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ELSEIF cArea=="UNIDADE"
         cCod3    := SPACE(8)
         cMsg_Aux := "Unidade"
         Mensagem("Preencha com Descrio da Unidade")
         @ 17,14 GET cCod3 PICT "@!" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ELSEIF cArea=="AREAC"
         cCod3    := SPACE(2)
         cMsg_Aux := "Area"
         Mensagem("Preencha com Area de Competncia")
         @ 17,14 GET cCod3 PICT "@!" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ELSEIF cArea=="USER"
         cMsg_Aux := "Senha"
         cCod3    := SPACE(4)
         cSetor   := SPACE(30)
         cSenha   := ""
         Mensagem("Preencha com o Nฃmero da Chave")
         @ 17,13 GET cCod3 PICT "@!" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ENDIF
      READ

      SELECT (cArea)
      IF LASTKEY() == K_ESC
         GO nReg_Ant
         EXIT
      ENDIF

      IF !DBSEEK (cCod3)
         WHILE .T.
            IF cArea=="USER"
               Mensagem("Preencha com o Nome do Usu rio")
               cMsg_Aux := "Usu rio"
               @ 18,13 GET cSetor PICT "@!S25" VALID !EMPTY(cSetor) COLOR YCOREDIT
               READ

               SET ORDER TO 1
               IF LASTKEY() == K_ESC
                  GO nReg_Ant
                  Rest_Tela()
                  Mensagem(msg)
                  SETCURSOR(0)
                  RETURN(lInc)
               ENDIF

               LOCATE FOR ALLTRIM(USER->USUARIO) == ALLTRIM(cSetor)
               IF FOUND()
                  Aviso(cMsg_Aux+" j  Cadastrado",YCORAVISO,2)
                  LOOP
               ENDIF
            ENDIF
            EXIT
         ENDDO

         IF cArea=="CATEG"
            Mensagem("Informe a Descrio e Mensalidade da Categoria")
            cDescr := SPACE(50)
            nMensal:= 0.00
            @ 18,16 GET cDescr PICT "@!S44" VALID !EMPTY(cDescr) COLOR YCOREDIT
            @ 19,16 GET nMensal PICT "@E 999,999,999.99" COLOR YCOREDIT
            READ

            IF LASTKEY() = K_ESC
               Mensagem(msg)
               EXIT
            ELSE
               IF Confirma("Confirma Incluso ?")
                  IF NetApp()
                     lInc := .T.
                     REPLACE _FIELD->CODCAT   WITH STRZERO(cCod3,2),;
                             _FIELD->DESCR    WITH cDescr,;
                             _FIELD->MENSALID WITH nMensal
                     UNLOCK
                     ProcOk("Gravado")
                  ENDIF
                  EXIT
               ENDIF
            ENDIF
         ELSEIF cArea=="ATIVIDADE"
            Mensagem("Informe Descrio e Mensalidade da Atividade")
            cDescr := SPACE(50)
            nMensal:= 0.00
            @ 18,16 GET cDescr  PICT "@!S44" VALID !EMPTY(cDescr) COLOR YCOREDIT
            @ 19,16 GET nMensal PICT "@E 999,999,999.99" VALID nMensal > 0.00 COLOR YCOREDIT
            READ

            IF LASTKEY() = K_ESC
               Mensagem(msg)
               EXIT
            ELSE
               IF Confirma("Confirma Incluso ?")
                  IF NetApp()
                     lInc := .T.
                     REPLACE _FIELD->CODATIV  WITH STRZERO(cCod3,2),;
                             _FIELD->DESCR    WITH cDescr,;
                             _FIELD->MENSALID WITH nMensal
                     UNLOCK
                     ProcOk("Gravado")
                  ENDIF
                  EXIT
               ENDIF
            ENDIF
         ELSEIF cArea=="COBRANCA"
            Mensagem("Informe Descrio do Local de Cobrana")
            cDescr := SPACE(50)
            @ 18,14 GET cDescr  PICT "@!S44" VALID !EMPTY(cDescr) COLOR YCOREDIT
            READ

            IF LASTKEY() = K_ESC
               Mensagem(msg)
               EXIT
            ELSE
               IF Confirma("Confirma Incluso ?")
                  IF NetApp()
                     lInc := .T.
                     REPLACE _FIELD->CODLOCAL WITH STRZERO(cCod3,2),;
                             _FIELD->DESCR    WITH cDescr
                     UNLOCK
                     ProcOk("Gravado")
                  ENDIF
                  EXIT
               ENDIF
            ENDIF
         ELSEIF cArea=="FUNC"
            Mensagem("Informe Descrio da Funo")
            cDescr := SPACE(50)
            @ 18,14 GET cDescr  PICT "@!S44" VALID !EMPTY(cDescr) COLOR YCOREDIT
            READ

            IF LASTKEY() = K_ESC
               Mensagem(msg)
               EXIT
            ELSE
               IF Confirma("Confirma Incluso ?")
                  IF NetApp()
                     lInc := .T.
                     REPLACE _FIELD->CODFUNC WITH STRZERO(cCod3,2),;
                             _FIELD->DESCR   WITH cDescr
                     UNLOCK
                     ProcOk("Gravado")
                  ENDIF
                  EXIT
               ENDIF
            ENDIF
         ELSEIF cArea=="UNIDADE"
            IF Confirma("Confirma Incluso ?")
               IF NetApp()
                  lInc := .T.
                  REPLACE _FIELD->DESCR  WITH cCod3
                  UNLOCK
                  ProcOk("Gravado")
                  EXIT
               ENDIF
            ENDIF
         ELSEIF cArea=="AREAC"
            Mensagem("Informe Descrio da Area")
            cDescr := SPACE(30)
            @ 18,14 GET cDescr PICT "@!" VALID !EMPTY(cDescr) COLOR YCOREDIT
            READ

            IF LASTKEY() = K_ESC
               Mensagem(msg)
               EXIT
            ELSE
               IF Confirma("Confirma Incluso ?")
                  IF NetApp()
                     lInc := .T.
                     REPLACE _FIELD->AREACOMP WITH cCod3,;
                             _FIELD->DESCR    WITH cDescr
                     UNLOCK
                     ProcOk("Gravado")
                  ENDIF
                  EXIT
               ENDIF
            ENDIF
         ELSEIF cArea=="USER"
            Mensagem("Informe a Senha com 6 dกgitos")
            cSenha := Test_Entry(19,13,6,cSenha,"PW",YCOREDIT)
            IF LASTKEY()==K_ESC .OR. LASTKEY()==K_TAB
               Rest_Tela()
               Mensagem(msg)
               SETCURSOR(0)
               RETURN(.F.)
            ENDIF
            IF Confirma("Confirma Incluso ?")
               IF NetApp()
                  lInc := .T.
                  REPLACE _FIELD->CHAVE    WITH cCod3 ,;
                          _FIELD->USUARIO  WITH cSetor,;
                          _FIELD->SENHA    WITH Codifica(cSenha)
                  UNLOCK
                  ProcOk("Gravado")
               ENDIF
               EXIT
            ENDIF
         ENDIF
      ELSE
         Aviso(cMsg_Aux+" j  Existente",YCORAVISO,2)
         LOOP
      ENDIF
   ENDDO
   SET ORDER TO 1
   Rest_Tela()
   Mensagem(msg)
   SETCURSOR(0)
   RETURN(lInc)
*ีออออออออออออออออออออออออออออออธ
*ณ Alterar Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Alterar(msg)
   LOCAL nReg_Ant := RECNO(), lAlt := .F.

   DBGOTOP()
   IF EOF()
      Aviso("No h  registro a ser alterado !",YCORAVISO,2)
      Mensagem(msg)
      RETURN(lAlt)
   ENDIF
   GO nReg_Ant

   cArea := ALIAS()
   SETCOLOR(YCOREDIT)
   IF cArea=="CATEG"
      Telas(16,2,20,60,c_nBorda,YCOREDIT,.T.," Alterao ")
      cCod3  := _FIELD->CODCAT
      cDescr := _FIELD->DESCR
      cMensal:= _FIELD->MENSALID
      cSetor := ""
      @ 17,3 SAY "Categoria  :"
      @ 18,3 SAY "Descrio  :"
      @ 19,3 SAY "Mensalidade:"
   ELSEIF cArea=="ATIVIDADE"
      Telas(16,2,20,60,c_nBorda,YCOREDIT,.T.," Alterao ")
      cCod3  := _FIELD->CODATIV
      cDescr := _FIELD->DESCR
      cMensal:= _FIELD->MENSALID
      cSetor := ""
      @ 17,3 SAY "Cขdigo     :"
      @ 18,3 SAY "Descrio  :"
      @ 19,3 SAY "Mensalidade:"
   ELSEIF cArea=="COBRANCA"
      Telas(16,2,19,60,c_nBorda,YCOREDIT,.T.," Alterao ")
      cCod3  := _FIELD->CODLOCAL
      cDescr := _FIELD->DESCR
      cSetor := ""
      @ 17,3 SAY "Categoria:"
      @ 18,3 SAY "Descrio:"
   ELSEIF cArea=="FUNC"
      Telas(16,2,19,60,c_nBorda,YCOREDIT,.T.," Alterao ")
      cCod3  := _FIELD->CODFUNC
      cDescr := _FIELD->DESCR
      cSetor := ""
      @ 17,3 SAY "Categoria:"
      @ 18,3 SAY "Descrio:"
   ELSEIF cArea=="UNIDADE"
      Telas(16,2,18,40,c_nBorda,YCOREDIT,.T.," Alterao ")
      cCod3  := _FIELD->DESCR
      cSetor := ""
      @ 17,3 SAY "Descrio:"
   ELSEIF cArea=="AREAC"
      Telas(16,2,19,45,c_nBorda,YCOREDIT,.T.," Alterao ")
      cCod3  := _FIELD->AREACOMP
      cDescr := _FIELD->DESCR
      cSetor := ""
      @ 17,3 SAY "Area     :"
      @ 18,3 SAY "Descrio:"
   ELSEIF cArea=="USER"
      IF cPrg=="AP152"
         IF CHAVE=="NET4"
            Aviso("Acesso Negado...",,1.5)
            Mensagem(msg)
            RETURN(lAlt)
         ENDIF
         cCod3  := _FIELD->NIVEL
         cSetor := ""

         IF nNivel==5
            IF cCod3 >= nNivel
               Aviso("Alterao no Autorizada...",,1.5)
               Mensagem(msg)
               RETURN(lAlt)
            ENDIF
         ENDIF

         Telas(16,2,18,39,c_nBorda,YCOREDIT,.T.," Alterao ")
         @ 17,3 SAY "Nกvel   :"
      ELSE
         // Tentativa de alteracao de chave de outro usuario
         IF cChave # CHAVE
            Aviso("Acesso Negado...",,1.5)
            Mensagem(msg)
            RETURN(lAlt)
         ENDIF

         cCod3 := _FIELD->CHAVE
         IF cCod3=="NET4"
            Aviso("Este registro NO pode ser alterado!. Tecle algo...")
            Mensagem(msg)
            RETURN(lAlt)
         ENDIF

         Telas(16,2,20,39,c_nBorda,YCOREDIT,.T.," Alterao ")
         cSetor := _FIELD->USUARIO
         cSenha := ""
         @ 17,3 SAY "Chave   :"
         @ 18,3 SAY "Usu rio :"
         @ 19,3 SAY "Senha   :"
      ENDIF
   ENDIF

   cCod3_Ant  := cCod3
   cSetor_Ant := cSetor
   lMudou     := .F.

   SETCURSOR(1)
   WHILE .T.
      IF cArea=="CATEG"
         cMsg_Aux := "Categoria"
         @ 17,16 GET cCod3
         @ 18,16 GET cDescr  PICT "@S42"
         @ 19,16 GET cMensal PICT "@E 999,999,999.99"
         CLEAR GETS
         Mensagem("Preencha o Cขdigo da Categoria")
         @ 17,16 GET cCod3 PICT "99" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ELSEIF cArea=="ATIVIDADE"
         cMsg_Aux := "Atividade"
         @ 17,16 GET cCod3
         @ 18,16 GET cDescr  PICT "@S44"
         @ 19,16 GET cMensal PICT "@E 999,999,999.99"
         CLEAR GETS
         Mensagem("Preencha o Cขdigo da Atividade")
         @ 17,16 GET cCod3 PICT "99" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ELSEIF cArea=="COBRANCA"
         cMsg_Aux := "Cขdigo"
         @ 17,14 GET cCod3
         @ 18,14 GET cDescr  PICT "@S44"
         CLEAR GETS
         Mensagem("Preencha o Cขdigo do Local da Cobrana")
         @ 17,14 GET cCod3 PICT "99" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ELSEIF cArea=="FUNC"
         cMsg_Aux := "Cขdigo"
         @ 17,14 GET cCod3
         @ 18,14 GET cDescr  PICT "@S44"
         CLEAR GETS
         Mensagem("Preencha o Cขdigo da Funo")
         @ 17,14 GET cCod3 PICT "99" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ELSEIF cArea=="UNIDADE"
         cMsg_Aux := "Unidade"
         @ 17,14 GET cCod3
         CLEAR GETS
         Mensagem("Preencha a Descrio da Unidade")
         @ 17,14 GET cCod3 PICT "@!" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ELSEIF cArea=="AREAC"
         cMsg_Aux := "Area"
         @ 17,14 GET cCod3
         @ 18,14 GET cDescr PICT "@!"
         CLEAR GETS
         Mensagem("Preencha a Area de Competncia")
         @ 17,14 GET cCod3 PICT "@!" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ELSEIF cArea=="USER"
         IF cPrg=="AP152"
            Mensagem("Informe o Nกvel de Acesso do Usu rio")
            @ 17,13 GET cCod3 PICT "9" COLOR YCOREDIT VALID TNivel(cCod3)
         ELSE
            cMsg_Aux := "Chave"
            @ 17,13 GET cCod3  PICT "@!"
            @ 18,13 GET cSetor PICT "@!S25"
            CLEAR GETS
            Mensagem("Preencha com a Nova Chave do Usu rio")
            @ 17,13 GET cCod3 PICT "@!" VALID !EMPTY(cCod3) COLOR YCOREDIT
         ENDIF
      ENDIF
      READ
      SELECT (cArea)

      IF LASTKEY() == K_ESC
         EXIT
      ENDIF

      IF cCod3 # cCod3_Ant
         // Testar se existe algum Sขcio nesta categoria
         IF cArea=="CATEG"
            SELECT SOCIOS
            IF DBSEEK(cCod3)
               Aviso("Categoria no pode ser Alterada. Existe(m) Sขcio(s) cadastrado(s)!")
               SELECT (cArea)
               cCod3 := cCod3_Ant
               LOOP
            ENDIF
            SELECT (cArea)
         ELSEIF cArea=="UNIDADE"
            SELECT SOCIOS
            IF DBSEEK(cCod3)
               Aviso("Unidade no pode ser Alterada. Existe(m) Sขcio(s) cadastrado(s)!")
               SELECT (cArea)
               cCod3 := cCod3_Ant
               LOOP
            ENDIF
            SELECT (cArea)
         ELSEIF cArea=="AREAC"
            SELECT SOCIOS
            IF DBSEEK(cCod3)
               Aviso("Area no pode ser Alterada. Existe(m) Sขcio(s) cadastrado(s)!")
               SELECT (cArea)
               cCod3 := cCod3_Ant
               LOOP
            ENDIF
            SELECT (cArea)
         ENDIF

         IF DBSEEK (cCod3)
            Aviso(cMsg_Aux+" j  Cadastrado.",YCORAVISO,2)
            GO nReg_Ant
            cCod3  := cCod3_Ant
            lMudou := .F.
            LOOP
         ELSE
            GO nReg_Ant
            lMudou := .T.
         ENDIF
      ENDIF

      WHILE .T.
        IF cArea=="USER"
           IF cPrg=="AP152"
              EXIT
           ENDIF
           Mensagem("Preencha com o Nome do Usu rio")
           cMsg_Aux := "Usu rio"
           @ 18,13 GET cSetor PICT "@!S25" VALID !EMPTY(cSetor) COLOR YCOREDIT
           READ

           IF LASTKEY() == K_ESC
              SET ORDER TO 1
              Rest_Tela()
              Mensagem(msg)
              SETCURSOR(0)
              GO nReg_Ant
              RETURN(lAlt)
           ENDIF

           IF cSetor # cSetor_Ant
              SET ORDER TO 1
              LOCATE FOR ALLTRIM(USER->USUARIO)==ALLTRIM(cSetor)
              IF FOUND()
                 Aviso(cMsg_Aux+" j  Cadastrado",YCORAVISO,2)
                 GO nReg_Ant
                 LOOP
              ELSE
                 GO nReg_Ant
                 lMudou := .T.
              ENDIF
           ENDIF
         ENDIF
         EXIT
      ENDDO

      IF cArea=="CATEG"
         Mensagem("Informe a Descrio e Mensalidade da Categoria")
         @ 18,16 GET cDescr  PICT "@!S44" VALID !EMPTY(cDescr) COLOR YCOREDIT
         @ 19,16 GET cMensal PICT "@E 999,999,999.99" COLOR YCOREDIT
         READ

         IF LASTKEY() == K_ESC
            EXIT
         ELSEIF UPDATED() .OR. lMudou
            IF Confirma("Confirma Alterao ?")
               IF NetLReg()
                  lAlt := .T.
                  REPLACE _FIELD->CODCAT   WITH STRZERO(VAL(cCod3),2),;
                          _FIELD->DESCR    WITH cDescr,;
                          _FIELD->MENSALID WITH cMensal
                  UNLOCK

                  /* Gravar mensalidade se for Socio tipo A ou APOSENTADO */
                  IF CODCAT=="01" .OR. CODCAT=="03"
                     SELECT MUDAPG
                     IF NetApp()
                        FIELD->CODCAT   := STRZERO(VAL(cCod3),2)
                        FIELD->ANOMES   := SUBS(DTOC(DATE()),7,2)+SUBS(DTOC(DATE()),4,2)
                        FIELD->MENSALID := cMensal
                     ENDIF
                     SELECT CATEG
                  ENDIF
                  ProcOk("Alterado")
               ENDIF
               EXIT
            ENDIF
         ELSEIF !UPDATED() .AND. !lMudou
            EXIT
         ENDIF
      ELSEIF cArea=="ATIVIDADE"
         Mensagem("Informe a Descrio e a Mensalidade da Atividade")
         @ 18,16 GET cDescr  PICT "@!S44" VALID !EMPTY(cDescr) COLOR YCOREDIT
         @ 19,16 GET cMensal PICT "@E 999,999,999.99" COLOR YCOREDIT
         READ

         IF LASTKEY() == K_ESC
            EXIT
         ELSEIF UPDATED() .OR. lMudou
            IF Confirma("Confirma Alterao ?")
               IF NetLReg()
                  lAlt := .T.
                  REPLACE _FIELD->CODATIV  WITH STRZERO(VAL(cCod3),2),;
                          _FIELD->DESCR    WITH cDescr,;
                          _FIELD->MENSALID WITH cMensal
                  UNLOCK
                  ProcOk("Alterado")
               ENDIF
               EXIT
            ENDIF
         ELSEIF !UPDATED() .AND. !lMudou
            EXIT
         ENDIF
      ELSEIF cArea=="COBRANCA"
         Mensagem("Informe a Descrio do Local da Cobrana")
         @ 18,14 GET cDescr  PICT "@!S44" VALID !EMPTY(cDescr) COLOR YCOREDIT
         READ

         IF LASTKEY() == K_ESC
            EXIT
         ELSEIF UPDATED() .OR. lMudou
            IF Confirma("Confirma Alterao ?")
               IF NetLReg()
                  lAlt := .T.
                  REPLACE _FIELD->CODLOCAL WITH STRZERO(VAL(cCod3),2),;
                          _FIELD->DESCR    WITH cDescr
                  UNLOCK
                  ProcOk("Alterado")
               ENDIF
               EXIT
            ENDIF
         ELSEIF !UPDATED() .AND. !lMudou
            EXIT
         ENDIF
      ELSEIF cArea=="FUNC"
         Mensagem("Informe a Descrio da Funo")
         @ 18,14 GET cDescr  PICT "@!S44" VALID !EMPTY(cDescr) COLOR YCOREDIT
         READ

         IF LASTKEY() == K_ESC
            EXIT
         ELSEIF UPDATED() .OR. lMudou
            IF Confirma("Confirma Alterao ?")
               IF NetLReg()
                  lAlt := .T.
                  REPLACE _FIELD->CODFUNC WITH STRZERO(VAL(cCod3),2),;
                          _FIELD->DESCR   WITH cDescr
                  UNLOCK
                  ProcOk("Alterado")
               ENDIF
               EXIT
            ENDIF
         ELSEIF !UPDATED() .AND. !lMudou
            EXIT
         ENDIF
      ELSEIF cArea=="UNIDADE"
         IF UPDATED() .OR. lMudou
            IF Confirma("Confirma Alterao ?")
               IF NetLReg()
                  lAlt := .T.
                  REPLACE _FIELD->DESCR WITH cCod3
                  UNLOCK
                  ProcOk("Alterado")
               ENDIF
               EXIT
            ENDIF
         ELSEIF !UPDATED() .AND. !lMudou
            EXIT
         ENDIF
      ELSEIF cArea=="AREAC"
         Mensagem("Informe a Descrio da Area")
         @ 18,14 GET cDescr PICT "@!" VALID !EMPTY(cDescr) COLOR YCOREDIT
         READ

         IF LASTKEY() == K_ESC
            EXIT
         ELSEIF UPDATED() .OR. lMudou
            IF Confirma("Confirma Alterao ?")
               IF NetLReg()
                  lAlt := .T.
                  REPLACE _FIELD->AREACOMP WITH cCod3,;
                          _FIELD->DESCR    WITH cDescr
                  UNLOCK
                  ProcOk("Alterado")
               ENDIF
               EXIT
            ENDIF
         ELSEIF !UPDATED() .AND. !lMudou
            EXIT
         ENDIF
      ELSEIF cArea=="USER"
         IF cPrg=="AP152"
            IF UPDATED() .OR. lMudou
               IF Confirma("Confirma Alterao ?")
                  IF NetLReg()
                     lAlt := .T.
                     REPLACE _FIELD->NIVEL WITH cCod3
                     UNLOCK
                     ProcOk("Alterado")
                  ENDIF
                  EXIT
               ENDIF
            ELSEIF !UPDATED() .AND. !lMudou
               EXIT
            ENDIF
         ELSE
            Mensagem("Informe a Senha com 6 dกgitos")
            cPassAnt := Codifica(_FIELD->SENHA)
            cSenha   := Test_Entry(19,13,6,cSenha,"PW",YCOREDIT)
            IF LASTKEY()==K_ESC .OR. LASTKEY()==K_TAB
               Rest_Tela()
               Mensagem(msg)
               SETCURSOR(0)
               RETURN(.F.)
            ENDIF
            IF cSenha # cPassAnt ; lMudou := .T. ; ENDIF
            IF UPDATED() .OR. lMudou
               IF Confirma("Confirma Alterao ?")
                  IF NetLReg()
                     lAlt := .T.
                     REPLACE _FIELD->CHAVE    WITH cCod3 ,;
                             _FIELD->USUARIO  WITH cSetor,;
                             _FIELD->SENHA    WITH Codifica(cSenha)
                     UNLOCK
                     ProcOk("Alterado")
                  ENDIF
                  EXIT
               ENDIF
            ELSEIF !UPDATED() .AND. !lMudou
               EXIT
            ENDIF
         ENDIF
      ENDIF
   ENDDO
   SET ORDER TO 1
   Rest_Tela()
   Mensagem(msg)
   GO nReg_Ant
   SETCURSOR(0)
   RETURN(lAlt)
*ีออออออออออออออออออออออออออออออธ
*ณ Excluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Excluir(msg)
   LOCAL nReg_Ant := RECNO(), lExcl := .F.

   GO TOP
   IF EOF()
      Aviso("No h  registro a ser eliminado !",YCORAVISO,2)
      Mensagem(msg)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   cArea := ALIAS()
   IF cArea=="CATEG"
      cCod := _FIELD->CODCAT
      cSet := _FIELD->DESCR
      SELECT SOCIOS
      SET ORDER TO 3
      IF DBSEEK(cCod)
         Aviso("Existe Sขcio tipo "+ALLTRIM(cSet)+" cadastrado!",YCORAVISO,4)
      ELSE
         lExcl := .T.
         SELECT CATEG
         WHILE !NetLReg(); ENDDO
         DBDELETE(); DBCOMMIT()
      ENDIF
      SELECT CATEG
   ELSEIF cArea=="ATIVIDADE"
      cCod := _FIELD->CODATIV
      cSet := _FIELD->DESCR
      SELECT USUATIV
      IF DBSEEK(cCod)
         Aviso("Existe Usu rio de "+ALLTRIM(cSet)+" cadastrado!",YCORAVISO,4)
      ELSE
         lExcl := .T.
         SELECT ATIVIDADE
         WHILE !NetLReg(); ENDDO
         DBDELETE(); DBCOMMIT()
      ENDIF
      SELECT ATIVIDADE
   ELSEIF cArea=="COBRANCA"
      cCod := _FIELD->CODLOCAL
      cSet := _FIELD->DESCR
      SELECT SOCIOS
      LOCATE FOR COBRANCA==cCod
      IF FOUND()
         Aviso("Existe Cliente com pagamento neste local",YCORAVISO,4)
      ELSE
         lExcl := .T.
         SELECT COBRANCA
         WHILE !NetLReg(); ENDDO
         DBDELETE(); DBCOMMIT()
      ENDIF
      SELECT COBRANCA
   ELSEIF cArea=="FUNC"
      cCod := _FIELD->CODFUNC
      cSet := _FIELD->DESCR
      SELECT SOCIOS
      LOCATE FOR FUNCAO==cSet
      IF FOUND()
         Aviso("Existe Sขcio com esta funo cadastrado",YCORAVISO,4)
      ELSE
         lExcl := .T.
         SELECT FUNC
         WHILE !NetLReg(); ENDDO
         DBDELETE(); DBCOMMIT()
      ENDIF
      SELECT FUNC
   ELSEIF cArea=="UNIDADE"
      cCod := _FIELD->DESCR
      SELECT SOCIOS
      IF DBSEEK(cCod)
         Aviso("Existe Sขcio Lotado nesta Unidade!",YCORAVISO,4)
      ELSE
         lExcl := .T.
         SELECT UNIDADE
         WHILE !NetLReg(); ENDDO
         DBDELETE(); DBCOMMIT()
      ENDIF
      SELECT UNIDADE
   ELSEIF cArea=="AREAC"
      cCod := _FIELD->AREACOMP
      SELECT SOCIOS
      IF DBSEEK(cCod)
         Aviso("Existe Sขcio cadastrado nesta area",YCORAVISO,4)
      ELSE
         lExcl := .T.
         SELECT AREAC
         WHILE !NetLReg(); ENDDO
         DBDELETE(); DBCOMMIT()
      ENDIF
      SELECT AREAC
   ELSEIF cArea=="USER"
      wChave := _FIELD->CHAVE
      IF nNivel < 5
         IF cChave==wChave
            Aviso("Usu rio est  ativo! Registro Mantido.",YCORAVISO,3)
         ELSE
            Aviso("Usu rio no Autorizado! Tecle algo...")
         ENDIF
      ELSEIF nNivel >= 5
         IF cChave==wChave
            Aviso("Usu rio est  ativo! Registro Mantido.",YCORAVISO,3)
         ELSEIF cChave # wChave .AND. NIVEL > nNivel
            Aviso("Acesso Negado...",,1.5)
         ELSEIF cChave # wChave .AND. NIVEL == nNivel
            Aviso("Excluso Negada...",,1.5)
         ELSEIF cChave # wChave .AND. NIVEL < nNivel
            IF wChave=="NET4"
               Aviso("Usu rio NO pode ser Excluกdo! Tecle algo...")
            ELSE
               IF NetLReg()
                  lExcl := .T.
                  FIELD->SENHA := SPACE(6)
                  DBDELETE()
                  UNLOCK
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ELSE
      WHILE !NetLReg(); ENDDO
      lExcl := .T.
      DBDELETE(); DBCOMMIT()
   ENDIF
   IF lExcl ; ProcOk("Eliminado") ; ENDIF
   Mensagem(msg)
   RETURN(lExcl)
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Niveis de Acesso      ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TNivel(pNivel)
   LOCAL tela := SAVESCREEN(2,0,24,79)
   IF VALTYPE(pNivel)=="N"
      pNivel := STR(pNivel,1)
   ENDIF
   IF !(pNivel $ "01359")
      Quadro(8,14,14,37,1,YCOREDIT,.T.,,.T.)
      @ 09,16 SAY "Sem Acesso......: 0"
      @ 10,16 SAY "Consulta........: 1"
      @ 11,16 SAY "Alt/Incluso....: 3"
      @ 12,16 SAY "Excluso........: 5"
      @ 13,16 SAY "Geral...........: 9"
      Aviso("Valores Permitidos: 0, 1, 3, 5 ou 9. Tecle algo...")
      RESTSCREEN(2,0,24,79,tela)
      RETURN .F.
   ENDIF
   RESTSCREEN(2,0,24,79,tela)
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Auxilio de Entrada de Dados  ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION HTela(nPar)
     SetCursor(0)
     if nPar==1
        Telas(06,53,10,76,1,YCORAVISO,.T.)
        @ 07,54 say "A - A Vista" COLOR YCORAVISO
        @ 08,54 say "C - Cortesia" COLOR YCORAVISO
        @ 09,54 say "R - Reserva Provisขria" COLOR YCORAVISO
     elseif nPar==2
        Telas(11,15,14,23,1,YCORAVISO,.T.)
        @ 12,16 say "S - Sim" COLOR YCORAVISO
        @ 13,16 say "N - No" COLOR YCORAVISO
     elseif nPar==3
        Telas(10,15,13,28,1,YCORAVISO,.T.)
        @ 11,16 say "D - Dinheiro" COLOR YCORAVISO
        @ 12,16 say "C - Cheque" COLOR YCORAVISO
     elseif nPar==4
        Telas(13,15,16,31,1,YCORAVISO,.T.)
        @ 14,16 say "R - Residencial" COLOR YCORAVISO
        @ 15,16 say "C - Comercial"   COLOR YCORAVISO
     elseif nPar==5
        Telas(13,15,16,31,1,YCORAVISO,.T.)
        @ 14,16 say "T - Tela"        COLOR YCORAVISO
        @ 15,16 say "I - Impressora"  COLOR YCORAVISO
     elseif nPar==6
        Telas(13,15,16,31,1,YCORAVISO,.T.)
        @ 14,16 say "L - Laser"     COLOR YCORAVISO
        @ 15,16 say "M - Matricial" COLOR YCORAVISO
        SetCursor(1)
     elseif nPar==7
        Telas(06,53,10,76,1,YCORAVISO,.T.)
        @ 07,54 say "A - Sขcio A"       COLOR YCORAVISO
        @ 08,54 say "B - Sขcio B/Afim"  COLOR YCORAVISO
        @ 09,54 say "C - Familia/Menor" COLOR YCORAVISO
     endif
     SETCURSOR(1)
return .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Testar tecla digitada Auxilioณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION VTela(nPar)
  local lOk:=.F.
  if nPar==1
     lOk:=if(wAluguel $ "ACR",.T.,.F.)
     if wAluguel=="C"
        IF nNivel<9
           Aviso("Usu rio no pode conceder Cortesia")
           return .f.
        ENDIF
        wDatPag:=ctod("")
        wValAlu:=0.00
        wRecAlu:=space(6)
     elseif wAluguel=="R"
        IF nNivel<9
           Aviso("Usu rio no autorizado para Reservar")
           return .f.
        ENDIF
        wDatPag:=ctod("")
        wValAlu:=0.00
        wRecAlu:=space(6)
     endif
  elseif nPar==2
     lOk:=if(wBebida $ "SN",.T.,.F.)
     if wBebida=="N"
        wValRef:=wValCer:=0.00
        wQtdRef:=wQtdCer:=0
        wRecBeb:=space(6)
     endif
  elseif nPar==3
     lOk:=if(wTipoPg $ "DC",.T.,.F.)
     IF wTipoPg="D"
        wDoc:=SPACE(6)
     ENDIF
  elseif nPar==4
     lOk:=if(wLocal $ "RC",.T.,.F.)
  elseif nPar==5
     lOk:=if(wDevice $ "TI",.T.,.F.)
  elseif nPar==6
     lOk:=if(wImpress $ "LM",.T.,.F.)
  elseif nPar==7
     lOk:=if(cClass $ "ABC",.T.,.F.)
  endif
  if lOk;Rest_Tela();endif
  return lOk
*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
*ณ                  ROTINA DE GERACAO DE ARQUIVO TEXTO PARA IMPRESSAO        ณ
*ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PROCEDURE Gera_TXT(pArq)
   SET PRINT TO (pArq+".TXT")
   SET DEVI TO PRINT
   RETURN
