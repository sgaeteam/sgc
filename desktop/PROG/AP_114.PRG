*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AP_114                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Reativar S¢cios e seus Dependentes       ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ³
*³ DATA CRIACAO   : 08/10/1994                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

DBCLOSEALL()
SELECT 6
IF NetUse("DEPENDI")
   SET INDEX TO DBIDEPI1
ELSE
   DBCLOSEALL()
   RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOSI")
   SET INDEX TO DBISOCI2,DBISOCI1,DBISOCI3
ELSE
   DBCLOSEALL()
   RETURN
ENDIF

SELECT 4
IF NetUse("CATEG")
   SET INDEX TO DBICATE1
ELSE
   DBCLOSEALL()
   RETURN
ENDIF

SELECT 3
IF NetUse("DEPEND")
   SET INDEX TO DBIDEPA1,DBIDEPA2,DBIDEPA3
ELSE
   DBCLOSEALL()
   RETURN
ENDIF

SELECT 2
IF NetUse("COBRANCA")
   SET INDEX TO DBICOBR1
ELSE
   DBCLOSEALL()
   RETURN
ENDIF

SELECT 5
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2,DBISOCA1,DBISOCA3,DBISOCA4,DBISOCA5,DBISOCA6,DBISOCA7,DBISOCA8,DBISOCA9
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "10"
LinhaMsg(2); ProgName("GC114")
SET KEY -1 TO Mostra()
WHILE .T.
   SELECT SOCIOSI
   Telas(18,3,20,62,1,YCOREDIT,.T.)
   
   SETCOLOR(YCOREDIT)
   wNomeSoc := SPACE(50)

   Mensagem("Informe Nome do S¢cio a Reativar")
   @ 19,05 SAY "Nome:" GET wNomeSoc PICT "@!" WHEN TeclaFuncao(.T.) VALID;
     PTab(wNomeSoc,1,1,"S¢cio Inativo n„o Encontrado")
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao(); LimpaLinhaMsg(); Rest_Tela()
   IF LASTKEY()==K_ESC .OR. EMPTY(wNomeSoc)
      EXIT
   ENDIF

   IF FOUND().AND.!NetLReg()
      LOOP
   ENDIF
   FOR a = 1 TO FCOUNT()
       xVar  := "w"+FIELDNAME(a)
       &xVar := FIELDGET(a)
   NEXT
   wMatr  := SOCIOSI->MATRICULA
   wCateg := SOCIOSI->CATEGORIA

   Telas(3,3,21,76,1,YCOREDIT,.T.,"Reativa‡„o de S¢cios")
   @ 04,05 SAY "         Nome:" GET wNome PICT "@!"
   @ 07,38 SAY "Mat. Clube: "   GET wMatr COLOR YCORREALCE
   TCateg(5,24,wCateg)
   @ 05,05 SAY "    Categoria:" GET wCateg     PICT "99" WHEN TeclaFuncao(.T.) VALID !EMPTY(wCateg).AND.TCateg(5,24,wCateg)
   @ 06,03 SAY "Ã"+REPL("Ä",72)+"´"
   @ 07,05 SAY "Mat.Petrobr s:" GET wMatr2     PICT "99999999"
   @ 07,38 SAY "Mat. Clube: "
   @ 07,58 SAY "Unidade:"       GET wUnidade   PICT "@!"
   @ 08,05 SAY "      Lota‡„o:" GET wLotacao   PICT "@!S25"
   @ 09,03 SAY "Ã"+REPL("Ä",72)+"´"
   @ 10,05 SAY "Dt.Nascimento:" GET wDatNas    PICT "@D"
   @ 11,05 SAY "Nacionalidade:" GET wNacional  PICT "@!"
   @ 12,05 SAY " Naturalidade:" GET wNatural   PICT "@!"
   @ 13,05 SAY "         Sexo:" GET wSexo      PICT "!" VALID wSexo $ "MF"
   @ 14,05 SAY " Estado Civil:" GET wEstCivil  PICT "!" VALID TEstCivil(wEstCivil)
   @ 15,05 SAY "          CPF:" GET wCPF       PICT "@R 999 999 999-99"
   @ 16,05 SAY "   Identidade:" GET wRG
   @ 17,05 SAY "    Profiss„o:" GET wProfissao PICT "@!"
   @ 10,38 SAY "  Endere‡o:"    GET wEndereco  PICT "@!S25"
   @ 11,38 SAY "    Bairro:"    GET wBairro    PICT "@!"
   @ 12,38 SAY "    Cidade:"    GET wCidade    PICT "@!"
   @ 13,38 SAY "    Estado:"    GET wEstado    PICT "!!" VALID ChkUF(wEstado)
   @ 14,38 SAY "       CEP:"    GET wCEP       PICT "@R 99.999-999"
   @ 15,38 SAY "      Fone:"    GET wTel       PICT "@R (999) 999-9999"
   @ 16,38 SAY " Dt.Ades„o:"    GET wDtAdesao  PICT "@D"
   @ 18,03 SAY "Ã"+REPL("Ä",72)+"´"
   @ 19,05 SAY "   Observa‡„o:" GET wObs       PICT "@!S50"
   @ 20,05 SAY "Motivo Desat.:" GET wMotivo    PICT "@!S30"
   @ 20,52 SAY "Usuario:"       GET wUsuario
   CLEAR GETS

   IF nNivel<5
      Mensagem("Tecle algo para continuar..."); INKEY(0)
      CLEAR GETS
      Rest_Tela()
      LOOP
   ENDIF

   IF Confirma("Confirma Reativa‡„o de S¢cio ?")
      /* Registrar o Motivo da Reativacao */
      wMotivo := SPACE(60)
      Telas(14,8,16,74,1,YCOREDIT,.T.)
      MsgTela(14,10," Motivo ")
      SETCURSOR(1)
      @ 15,21 GET wMotivo PICT "@!S50" VALID !EMPTY(wMotivo)
      READ
      Rest_Tela()
      SETCURSOR(0)
      IF LASTKEY()==K_ESC
         Rest_Tela()
         EXIT
      ENDIF

      /* Gravar no arquivo de Socios Ativos e seus Dependentes */
      wUsuario = cUsuario
      SELECT SOCIOS
      WHILE !NetApp(); ENDDO
      FOR a = 1 TO FCOUNT()
          xVar  := "w"+FIELDNAME(a)
          FIELDPUT(a,&xVar)
      NEXT
      IF wCategoria=="07"
         FIELD->OBS       := SPACE(60)
         FIELD->CATEGORIA := "02"
         FIELD->MATR2     := SPACE(8)
         FIELD->UNIDADE   := SPACE(8)
         FIELD->LOTACAO   := SPACE(25)
         FIELD->FUNCAO    := SPACE(20)
      ENDIF
      SELECT DEPENDI
      IF DBSEEK(wMatr)
         WHILE MATRICULA==wMatr .AND. !EOF()
            SELECT DEPEND
            WHILE !NetApp(); ENDDO
            FIELD->CATEGORIA := DEPENDI->CATEGORIA
            FIELD->MATRICULA := DEPENDI->MATRICULA
            FIELD->NOME      := DEPENDI->NOME
            FIELD->SEXO      := DEPENDI->SEXO
            FIELD->GRAU      := DEPENDI->GRAU
            FIELD->DTNAS     := DEPENDI->DTNAS
            FIELD->COBRANCA  := DEPENDI->COBRANCA
            DBUNLOCK(); DBCOMMIT()
            SELECT DEPENDI
            WHILE !NetLReg(); ENDDO
            DBDELETE()     /* Elimina dependente do cadastro Inativo */
            DBCOMMIT()
            DBSKIP()
         ENDDO
      ENDIF

      SELECT SOCIOSI
      WHILE !NetLReg(); ENDDO
      DBDELETE()           /* Elimina do socio do cadastro Inativo */
      UNLOCK ALL
      DBCOMMITALL()
   ENDIF
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL)
DBCLOSEALL(); RETURN
