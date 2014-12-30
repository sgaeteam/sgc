*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AP_113                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Desativar S¢cios e seus Dependentes      ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ³
*³ DATA CRIACAO   : 08/10/1994                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

DBCLOSEALL()
SELECT 6
IF NetUse("DEPENDI")
   SET INDEX TO DBIDEPI1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 5
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

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2,DBISOCA1,DBISOCA3,DBISOCA4,DBISOCA5,DBISOCA6,DBISOCA7,DBISOCA8
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "10"
LinhaMsg(2); ProgName("GC113")
SET KEY -1 TO Mostra
WHILE .T.
   Telas(18,3,20,62,1,YCOREDIT,.T.)
   
   SETCOLOR(YCOREDIT)
   wNomeSoc := SPACE(50)

   Mensagem("Informe Nome do S¢cio a Desativar")
   @ 19,05 SAY "Nome:" GET wNomeSoc PICT "@!" WHEN TeclaFuncao(.T.) VALID;
     PTab(wNomeSoc,1,1,"S¢cio n„o Cadastrado")
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao(); LimpaLinhaMsg(); Rest_Tela()
   IF LASTKEY()==K_ESC .OR. EMPTY(wNomeSoc); EXIT; ENDIF

   IF FOUND().AND.!NetLReg()
      LOOP
   ENDIF
   FOR a = 1 TO FCOUNT()
       xVar  := "w"+FIELDNAME(a)
       &xVar := FIELDGET(a)
   NEXT
   wMatr  := SOCIOS->MATRICULA
   wCateg := SOCIOS->CATEGORIA

   Telas(3,3,21,76,1,YCOREDIT,.T.,"Desativa‡„o de S¢cios")
   @ 04,05 SAY "         Nome:"  GET wNome PICT "@!"
   @ 07,38 SAY "Mat. Clube: " GET wMatr COLOR YCORREALCE
   TCateg(5,24,wCateg)
   @ 05,05 SAY "    Categoria:" GET wCateg     PICT "99" WHEN TeclaFuncao(.T.) VALID !EMPTY(wCateg).AND.TCateg(5,24,wCateg)
   @ 06,03 SAY "Ã"+REPL("Ä",72)+"´"
   @ 07,05 SAY "Mat.Petrobr s:" GET wMatr2     PICT "99999999"
   @ 07,38 SAY "Mat. Clube: "
   @ 07,58 SAY "Unidade:"       GET wUnidade   PICT "@!"
   @ 08,05 SAY "      Lota‡„o:" GET wLotacao   PICT "@!S20"
   @ 09,05 SAY " Fun‡„o Clube:" GET wFuncao    PICT "@!"  WHEN TeclaFuncao(.T.)
   @ 08,38 SAY "      Fone:"    GET wFone      PICT "@R (999) 999-9999"
   @ 09,38 SAY "     Ramal:"    GET wRamal     PICT "9999"
   @ 10,03 SAY "Ã"+REPL("Ä",72)+"´"
   @ 11,05 SAY "Dt.Nascimento:" GET wDatNas    PICT "@D"
   @ 12,05 SAY "Nacionalidade:" GET wNacional  PICT "@!"
   @ 13,05 SAY " Naturalidade:" GET wNatural   PICT "@!"
   @ 14,05 SAY "         Sexo:" GET wSexo      PICT "!" VALID wSexo $ "MF"
   @ 15,05 SAY " Estado Civil:" GET wEstCivil  PICT "!" VALID TEstCivil(wEstCivil)
   @ 16,05 SAY "          CPF:" GET wCPF       PICT "@R 999 999 999-99" VALID EMPTY(wCPF).OR.ChkCPF(wCPF)
   @ 17,05 SAY "   Identidade:" GET wRG
   @ 18,05 SAY "    Profiss„o:" GET wProfissao PICT "@!"
   @ 11,38 SAY "  Endere‡o:"    GET wEndereco  PICT "@!S25"
   @ 12,38 SAY "    Bairro:"    GET wBairro    PICT "@!"
   @ 13,38 SAY "    Cidade:"    GET wCidade    PICT "@!"
   @ 14,38 SAY "    Estado:"    GET wEstado    PICT "!!" VALID ChkUF(wEstado)
   @ 15,38 SAY "       CEP:"    GET wCEP       PICT "@R 99.999-999"
   @ 16,38 SAY "      Fone:"    GET wTel       PICT "@R (999) 999-9999"
   @ 17,38 SAY " Dt.Ades„o:"    GET wDtAdesao  PICT "@D"
   @ 19,03 SAY "Ã"+REPL("Ä",72)+"´"
   @ 20,05 SAY "   Observa‡„o:" GET wObs       PICT "@!S50"
   CLEAR GETS

   IF nNivel<5
      Mensagem("Tecle algo para continuar..."); INKEY(0)
      CLEAR GETS
      Rest_Tela()
      LOOP
   ENDIF

   IF Confirma("Confirma Desativa‡„o de S¢cio ?")
      /* Registrar o Motivo da Desativacao */
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

      aDep     := {}
      aDepReg  := {}
      aDepAfim := {}
      aDepAfReg:= {}

      /* Procura dependentes */
      SELECT DEPEND
      IF DBSEEK(wMatr)
         WHILE MATRICULA==wMatr .AND. !EOF()
            WHILE !NetLReg(); ENDDO
            AADD(aDepReg,RECNO())
            AADD(aDep,{CATEGORIA,MATRICULA,NOME,SEXO,GRAU,DTNAS,COBRANCA})
            /* Elimina dependente cadastro Ativo */
            DBDELETE(); DBCOMMIT()
            DBSKIP()
         ENDDO
      ENDIF

      /* Verificar existencia de socios afim */
      SELECT SOCIOS
      nRegAnt := RECNO()   // Marca o ponteiro no socio titular
      IF wMatr2#SPACE(8)
         SET ORDER TO 4
         IF DBSEEK(wMatr2)
            WHILE MATR2==wMatr2 .AND. !EOF()
               IF RECNO()#nRegAnt
                  WHILE !NetLReg(); ENDDO
                  AADD(aDepAfReg,RECNO())
                  AADD(aDepAfim,{CATEGORIA,MATRICULA,NOME,SEXO,ESTCIVIL,MATR2 ,;
                          CPF,RG,LOTACAO,UNIDADE,NACIONAL,NATURAL,PROFISSAO,;
                          DATNAS,ENDERECO,BAIRRO,CIDADE,ESTADO,CEP,TEL     ,;
                          DTADESAO,OBS,COBRANCA})
                  /* Elimina provisoriamente socio afim do cadastro Ativo */
                  DBDELETE(); DBCOMMIT()
               ENDIF
               DBSKIP()
            ENDDO
         ENDIF
         SET ORDER TO 1
      ENDIF

      IF LEN(aDep)>0
         /* Gravar dependentes no arquivo inativo */
         SELECT DEPENDI
         FOR p = 1 TO LEN(aDep)
            WHILE !NetApp(); ENDDO
            FIELD->CATEGORIA := aDep[p,1]
            FIELD->MATRICULA := aDep[p,2]
            FIELD->NOME      := aDep[p,3]
            FIELD->SEXO      := aDep[p,4]
            FIELD->GRAU      := aDep[p,5]
            FIELD->DTNAS     := aDep[p,6]
            FIELD->COBRANCA  := aDep[p,7]
         NEXT
      ENDIF

      /* Gravar dados do socio titular no arquivo inativo */
      wUsuario = cUsuario
      SELECT SOCIOSI
      WHILE !NetApp(); ENDDO
      FOR a = 1 TO FCOUNT()
          xVar  := "w"+FIELDNAME(a)
          FIELDPUT(a,&xVar)
      NEXT

      /* Gravar dados dos socios afim no arquivo inativo */
      FOR p = 1 TO LEN(aDepAfim)
          IF NetApp()
             FIELD->CATEGORIA := aDepAfim[p,1]
             FIELD->MATRICULA := aDepAfim[p,2]
             FIELD->NOME      := aDepAfim[p,3]
             FIELD->SEXO      := aDepAfim[p,4]
             FIELD->ESTCIVIL  := aDepAfim[p,5]
             FIELD->MATR2     := aDepAfim[p,6]
             FIELD->CPF       := aDepAfim[p,7]
             FIELD->RG        := aDepAfim[p,8]
             FIELD->LOTACAO   := aDepAfim[p,9]
             FIELD->UNIDADE   := aDepAfim[p,10]
             FIELD->NACIONAL  := aDepAfim[p,11]
             FIELD->NATURAL   := aDepAfim[p,12]
             FIELD->PROFISSAO := aDepAfim[p,13]
             FIELD->DATNAS    := aDepAfim[p,14]
             FIELD->ENDERECO  := aDepAfim[p,15]
             FIELD->BAIRRO    := aDepAfim[p,16]
             FIELD->CIDADE    := aDepAfim[p,17]
             FIELD->ESTADO    := aDepAfim[p,18]
             FIELD->CEP       := aDepAfim[p,19]
             FIELD->TEL       := aDepAfim[p,20]
             FIELD->DTADESAO  := aDepAfim[p,21]
             FIELD->OBS       := aDepAfim[p,22]
             FIELD->COBRANCA  := aDepAfim[p,23]
          ENDIF
      NEXT

      SELECT SOCIOS
      /* Voltar para socio titular e forcar travamento */
      GO nRegAnt
      WHILE !NetLReg(); ENDDO
      DBDELETE()          /* Elimina socio do cadastro Ativo */
      UNLOCK ALL
      DBCOMMITALL()
   ENDIF
   SELECT SOCIOS
   UNLOCK ALL
   DBCOMMITALL()
   Rest_Tela()
ENDDO
SETCURSOR(0)
SETKEY(K_F2,NIL)
DBCLOSEALL()
RETURN
