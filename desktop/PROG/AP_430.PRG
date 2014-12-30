*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_430                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Manuteno dos Arquivos do Sistema       ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 03/01/1994                               ณ
*ณ ATUALIZACAO    : 09/08/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

Telas(7,52,10,64,1,YCORMENU,.T.)
WHILE .T.
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "4"
   cOpHelp2 := "30"

   ProgName("GC430")

   @ 08,53 PROMPT " Organizar " MESSAGE Msg("Reorganizar Arquivos do Sistema")
   @ 09,53 PROMPT " Compactar " MESSAGE Msg("Eliminar Registros que foram Excluidos")
   MENU TO nMenu_5c

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)

   IF nMenu_5c = 0
      Rest_Tela()
      RETURN
   ELSEIF nMenu_5c = 1 .AND. Acesso(5)
      OrgArq()
   ELSEIF nMenu_5c = 2 .AND. Acesso(5)
      CompacArq()
   ENDIF
ENDDO
*ีออออออออออออออออออออออออออออออธ
*ณ Organizar Arquivos           ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE OrgArq()
   LOCAL nUser := 47, cTela := SAVESCREEN(2,0,24,79), cor := SETCOLOR()
   LOCAL narq:=1

   Area_Dados()
   Termom("Organizando os Bancos de Dados",0,nUser)
   Mensagem("Reconstruindo Arquivo de Help...")
   IF NetUse("HELP.HLP","HELP",,"E")
      INDEX ON codigo+subcodigo TO HLP
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo a Tabela de Atividades...")
   IF NetUse("ATIV",,"E")
      INDEX ON codativ TO DBIATIV1
      Termom("",narq++,nUser)
      INDEX ON descr TO DBIATIV2
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo a Tabela de Categorias...")
   IF NetUse("CATEG",,"E")
      INDEX ON codcat TO DBICATE1
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo a Tabela de Unidades...")
   IF NetUse("UNIDADE",,"E")
      INDEX ON descr TO DBIUNID1
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo a Tabela de Cobrana...")
   IF NetUse("COBRANCA",,"E")
      INDEX ON codlocal TO DBICOBR1
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo a Tabela de Areas...")
   IF NetUse("AREAC",,"E")
      INDEX ON areacomp TO DBIAREA1
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo a Tabela de Fun”es...")
   IF NetUse("FUNC",,"E")
      INDEX ON codfunc TO DBIFUNC1
      Termom("",narq++,nUser)
      INDEX ON descr TO DBIFUNC2
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo o Arquivo de Sขcios...")
   IF NetUse("SOCIOS",,"E")
      INDEX ON matricula      TO DBISOCA1
      Termom("",narq++,nUser)
      INDEX ON nome           TO DBISOCA2
      Termom("",narq++,nUser)
      INDEX ON categoria+nome TO DBISOCA3
      Termom("",narq++,nUser)
      INDEX ON matr2          TO DBISOCA4
      Termom("",narq++,nUser)
      INDEX ON unidade+nome   TO DBISOCA5
      Termom("",narq++,nUser)
      INDEX ON SUBS(DTOC(datnas),4,2)+SUBS(DTOC(datnas),1,2) TO DBISOCA6
      Termom("",narq++,nUser)
      INDEX ON funcao         TO DBISOCA7
      Termom("",narq++,nUser)
      INDEX ON area           TO DBISOCA8
      Termom("",narq++,nUser)
      INDEX ON area2          TO DBISOCA9
      Termom("",narq++,nUser)
   ENDIF
   IF NetUse("SOCIOSI",,"E")
      INDEX ON matricula TO DBISOCI1
      Termom("",narq++,nUser)
      INDEX ON nome      TO DBISOCI2
      Termom("",narq++,nUser)
      INDEX ON categoria TO DBISOCI3
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo o Arquivo Cadastro de Convidados...")
   IF NetUse("CCONV",,"E")
      INDEX ON matricula TO CCONV
      Termom("",narq++,nUser)
   ENDIF
   IF NetUse("CONVSOC",,"E")
      INDEX ON codsoc              TO CONVSOC1
      Termom("",narq++,nUser)
      INDEX ON codsoc+nomec        TO CONVSOC2
      Termom("",narq++,nUser)
      INDEX ON DTOS(dtaconv)+nomec TO CONVSOC3
      Termom("",narq++,nUser)
      INDEX ON codsoc+DTOS(dtaconv) TO CONVSOC4
      Termom("",narq++,nUser)
      INDEX ON rg+DTOS(dtaconv) TO CONVSOC5
      Termom("",narq++,nUser)
   ENDIF
   IF NetUse("CADCONVT",,"E")
      INDEX ON codsoc              TO CATCONV1
      Termom("",narq++,nUser)
      INDEX ON codsoc+nomec        TO CATCONV2
      Termom("",narq++,nUser)
      INDEX ON DTOS(dtaconv)+nomec TO CATCONV3
      Termom("",narq++,nUser)
   ENDIF

   IF NetUse("DBCLSF",,"E")
      INDEX ON DTOS(data) TO DBILSF1
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo o Arquivo de Dependentes...")
   IF NetUse("DEPEND",,"E")
      INDEX ON matricula+nome TO DBIDEPA1
      Termom("",narq++,nUser)
      INDEX ON nome TO DBIDEPA2
      Termom("",narq++,nUser)
      INDEX ON SUBS(DTOC(dtnas),4,2)+SUBS(DTOC(dtnas),1,2) TO DBIDEPA3
      Termom("",narq++,nUser)
   ENDIF
   IF NetUse("DEPENDI",,"E")
      INDEX ON matricula+nome TO DBIDEPI1
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo o Arquivo de Usu rios...")
   IF NetUse("USUARIOS",,"E")
      INDEX ON nome      TO DBIUSU1
      Termom("",narq++,nUser)
      INDEX ON matricula TO DBIUSU2
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo o Arquivo Pagamento de Sขcios...")
   IF NetUse("PGSOC",,"E")
      INDEX ON matricula+anomes TO DBIPGSO1
      Termom("",narq++,nUser)
      INDEX ON anomes           TO DBIPGSO2
      Termom("",narq++,nUser)
      INDEX ON categoria+matricula+anomes TO DBIPGSO3
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo o Arquivo Atividades de Usu rios...")
   IF NetUse("USUATIV",,"E")
      INDEX ON nome+atividade      TO DBIUSAT1
      Termom("",narq++,nUser)
      INDEX ON matricula+atividade TO DBIUSAT2
      Termom("",narq++,nUser)
      INDEX ON atividade+nome      TO DBIUSAT3
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo o Arquivo Pagamento de Usu rios...")
   IF NetUse("PGUSU",,"E")
      INDEX ON matricula+atividade+anomes TO DBIPGUS1
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo o Arquivo de Mudana de Mensalidades...")
   IF NetUse("MUDAPG",,"E")
      INDEX ON codcat+anomes TO DBIMUDA1
      Termom("",narq++,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Senhas...")
   IF NetUse("USUARIO.SYS","USER",,"E")
      INDEX ON chave TO USUARIO
      Termom("",narq++,nUser)
   ENDIF

   IF NetUse("DBCLSF2",,"E")
      INDEX ON DTOS(data) TO DBILSF21
      Termom("",narq++,nUser)
   ENDIF

   INKEY(.5)
   RESTSCREEN(2,0,24,79,cTela)
   SETCOLOR(cor)
   DBCLOSEALL()
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Compactar Arquivos           ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE CompacArq()
   LOCAL nUser := 20, cTela := SAVESCREEN(2,0,24,79), cor := SETCOLOR()

   Area_Dados()
   Termom("Compactando os Bancos de Dados",0,nUser)

   Mensagem("Compactando a Tabela de Atividades...")
   IF NetUse("ATIV",,"E")
      SET INDEX TO DBIATIV1, DBIATIV2
      PACK
      Termom("",1,nUser)
   ENDIF

   Mensagem("Compactando a Tabela de Categorias...")
   IF NetUse("CATEG",,"E")
      SET INDEX TO DBICATE1
      PACK
      Termom("",2,nUser)
   ENDIF

   Mensagem("Compactando a Tabela de Areas...")
   IF NetUse("AREAC",,"E")
      SET INDEX TO DBIAREA1
      PACK
      Termom("",3,nUser)
   ENDIF

   Mensagem("Compactando a Tabela de Unidades...")
   IF NetUse("UNIDADE",,"E")
      SET INDEX TO DBIUNID1
      PACK
      Termom("",4,nUser)
   ENDIF
   Mensagem("Compactando a Tabela de Cobrana...")
   IF NetUse("COBRANCA",,"E")
      SET INDEX TO DBICOBR1
      PACK
      Termom("",5,nUser)
   ENDIF

   Mensagem("Compactando a Tabela de Fun”es...")
   IF NetUse("FUNC",,"E")
      SET INDEX TO DBIFUNC1, DBIFUNC2
      PACK
      Termom("",6,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Sขcios...")
   IF NetUse("SOCIOS",,"E")
      SET INDEX TO DBISOCA1,DBISOCA2,DBISOCA3,DBISOCA4,DBISOCA5,DBISOCA6,DBISOCA7,DBISOCA8,DBISOCA9
      PACK
      Termom("",7,nUser)
   ENDIF
   IF NetUse("SOCIOSI",,"E")
      SET INDEX TO DBISOCI1, DBISOCI2, DBISOCI3
      PACK
      Termom("",8,nUser)
   ENDIF

   Mensagem("Reconstruindo o Arquivo Cadastro de Convidados...")
   IF NetUse("CCONV",,"E")
      SET INDEX TO CCONV
      PACK
      Termom("",9,nUser)
   ENDIF
   IF NetUse("CONVSOC",,"E")
      SET INDEX TO CONVSOC1, CONVSOC2, CONVSOC3, CONVSOC4, CONVSOC5
      PACK
      Termom("",10,nUser)
   ENDIF
   IF NetUse("CADCONVT",,"E")
      SET INDEX TO CATCONV1, CATCONV2, CATCONV3
      PACK
      Termom("",11,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Aluguel Salo...")
   IF NetUse("DBCLSF",,"E")
      SET INDEX TO DBILSF1
      PACK
      Termom("",12,nUser)
   ENDIF

   IF NetUse("DBCLSF2",,"E")
      SET INDEX TO DBILSF21
      PACK
      Termom("",13,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Dependentes...")
   IF NetUse("DEPEND",,"E")
      SET INDEX TO DBIDEPA1,DBIDEPA2,DBIDEPA3
      PACK
      Termom("",14,nUser)
   ENDIF
   IF NetUse("DEPENDI",,"E")
      SET INDEX TO DBIDEPI1
      PACK
      Termom("",15,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Usu rios...")
   IF NetUse("USUARIOS",,"E")
      SET INDEX TO DBIUSU1, DBIUSU2
      PACK
      Termom("",16,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo Pagamento de Sขcios...")
   IF NetUse("PGSOC",,"E")
      SET INDEX TO DBIPGSO1, DBIPGSO2, DBIPGSO3
      PACK
      Termom("",17,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo Atividades de Usu rios...")
   IF NetUse("USUATIV",,"E")
      SET INDEX TO DBIUSAT1, DBIUSAT2, DBIUSAT3
      PACK
      Termom("",18,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo Pagamento de Usu rios...")
   IF NetUse("PGUSU",,"E")
      SET INDEX TO DBIPGUS1
      PACK
      Termom("",19,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Senhas...")
   IF NetUse("USUARIO.SYS","USER","E")
      SET INDEX TO USUARIO
      PACK
      Termom("",20,nUser)
   ENDIF

   INKEY(.5)
   Mensagem()
   RESTSCREEN(2,0,24,79,cTela)
   SETCOLOR(cor)
   DBCLOSEALL()
   RETURN
