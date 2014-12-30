*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_ARQ                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Gerar Arquivos do Sistema                ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 09/08/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
*ีออออออออออออออออออออออออออออออธ
*ณ Criao de Bancos de Dados   ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Cria_Arqs()
   LOCAL nFalta := nTermom := 0 , aDbf
   /* Informar data do Sistema */
   SETCOLOR(YCOREDIT)
   Telas(11,28,13,47,1,YCOREDIT,.T.)
   @ 12,30 SAY "Data:" GET cDtSys PICT "@D" VALID !EMPTY(cDtSys)
   SETCURSOR(1); READ; SETCURSOR(0); Rest_Tela()

   Mensagem("Criando os Arquivos de Dados...")

   // Arquivo HELP
   IF !FILE('HELP.HLP')
      aDbf := {}
      AADD(aDbf,{"CODIGO",   "C",    1,0})
      AADD(aDbf,{"SUBCODIGO","C",    2,0})
      AADD(aDbf,{"DESCRICAO","M",65535,0})
      DBCREATE("HELP.HLP",aDbf)
   ENDIF

   // Arquivo de Parametros
   IF !FILE('DBPARM.DBF')
      aDbf := {}
      AADD(aDbf,{"MATRICULA","C",   5,0})
      AADD(aDbf,{"MATUSU"   ,"C",   5,0})
      AADD(aDbf,{"MSGANIV"  ,"C",  50,0})
      AADD(aDbf,{"CARTA"    ,"M",  10,0})
      AADD(aDbf,{"MSGFUNC"  ,"C",  50,0})
      AADD(aDbf,{"CARTAF"   ,"M",  10,0})
      DBCREATE("DBPARM.DBF",aDbf)
   ENDIF

   // Arquivo Tabela de Cobrana
   IF !FILE('COBRANCA.DBF')
      aDbf := {}
      AADD(aDbf,{"CODLOCAL","C",    2,0})
      AADD(aDbf,{"DESCR"   ,"C",   50,0})
      DBCREATE("COBRANCA.DBF",aDbf)
   ENDIF

   // Arquivo Tabela de Area de Competencia
   IF !FILE('AREAC.DBF')
      aDbf := {}
      AADD(aDbf,{"AREACOMP","C",    2,0})
      AADD(aDbf,{"DESCR"   ,"C",   30,0})
      DBCREATE("AREAC.DBF",aDbf)
   ENDIF

   // Arquivo Tabela de Unidades
   IF !FILE('UNIDADE.DBF')
      aDbf := {}
      AADD(aDbf,{"DESCR" ,"C", 8,0})
      DBCREATE("UNIDADE.DBF",aDbf)
   ENDIF

   // Arquivo Tabela de Categorias
   IF !FILE('CATEG.DBF')
      aDbf := {}
      AADD(aDbf,{"CODCAT"   ,"C",    2,0})
      AADD(aDbf,{"DESCR"    ,"C",   50,0})
      AADD(aDbf,{"MENSALID" ,"N",   12,2})
      DBCREATE("CATEG.DBF",aDbf)
   ENDIF

   // Arquivo Tabela de Mudanca de Mensalidade
   IF !FILE('MUDAPG.DBF')
      aDbf := {}
      AADD(aDbf,{"CODCAT"   ,"C",    2,0})
      AADD(aDbf,{"ANOMES"   ,"C",    4,0})
      AADD(aDbf,{"MENSALID" ,"N",   12,2})
      DBCREATE("MUDAPG.DBF",aDbf)
   ENDIF

   // Arquivo Tabela de Pagamento de Categorias
   IF !FILE('PGCATG.DBF')
      aDbf := {}
      AADD(aDbf,{"CODCAT"   ,"C",  2,0})
      AADD(aDbf,{"ANOMES"   ,"C",  4,0})
      AADD(aDbf,{"RECIBO"   ,"C",  5,0})
      AADD(aDbf,{"DTPAG"    ,"D",  8,0})
      AADD(aDbf,{"VALOR"    ,"N", 12,2})
      AADD(aDbf,{"OBS"      ,"C", 60,0})
      AADD(aDbf,{"DOC"      ,"C",  6,0})
      AADD(aDbf,{"USUARIO"  ,"C", 15,0})
      DBCREATE("PGCATG.DBF",aDbf)
   ENDIF

   // Arquivo de Pagamento de Socios
   IF !FILE('PGSOC.DBF')
      aDbf := {}
      AADD(aDbf,{"MATRICULA"  ,"C",  5,0})
      AADD(aDbf,{"CATEGORIA"  ,"C",  2,0})
      AADD(aDbf,{"ANOMES"     ,"C",  4,0})
      AADD(aDbf,{"RECIBO"     ,"C",  5,0})
      AADD(aDbf,{"DTPAG"      ,"D",  8,0})
      AADD(aDbf,{"VALOR"      ,"N", 12,2})
      AADD(aDbf,{"OBS"        ,"C", 60,0})
      AADD(aDbf,{"DOC"        ,"C",  6,0})
      AADD(aDbf,{"USUARIO"    ,"C", 15,0})
      DBCREATE("PGSOC.DBF",aDbf)
   ENDIF

   // Arquivo de Pagamento de Usu rios
   IF !FILE('PGUSU.DBF')
      aDbf := {}
      AADD(aDbf,{"NOME"       ,"C", 50,0})
      AADD(aDbf,{"MATRICULA"  ,"C", 05,0})
      AADD(aDbf,{"ATIVIDADE"  ,"C",  2,0})
      AADD(aDbf,{"ANOMES"     ,"C",  4,0})
      AADD(aDbf,{"RECIBO"     ,"C",  5,0})
      AADD(aDbf,{"DTPAG"      ,"D",  8,0})
      AADD(aDbf,{"VALOR"      ,"N", 12,2})
      AADD(aDbf,{"OBS"        ,"C", 60,0})
      AADD(aDbf,{"DOC"        ,"C",  6,0})
      AADD(aDbf,{"USUARIO"    ,"C", 15,0})
      DBCREATE("PGUSU.DBF",aDbf)
   ENDIF

   // Arquivo Tabela de Atividades
   IF !FILE('ATIV.DBF')
      aDbf := {}
      AADD(aDbf,{"CODATIV"  ,"C",    2,0})
      AADD(aDbf,{"DESCR"    ,"C",   50,0})
      AADD(aDbf,{"MENSALID" ,"N",   12,2})
      DBCREATE("ATIV.DBF",aDbf)
   ENDIF

   // Arquivo Tabela de Funcao no Clube
   IF !FILE('FUNC.DBF')
      aDbf := {}
      AADD(aDbf,{"CODFUNC"  ,"C",    2,0})
      AADD(aDbf,{"DESCR"    ,"C",   50,0})
      DBCREATE("FUNC.DBF",aDbf)
   ENDIF

   // Arquivo Cadastro de Sขcios Ativos
   IF !FILE('SOCIOS.DBF')
      aDbf := {}
      AADD(aDbf,{"CATEGORIA"  ,"C",    2,0})
      AADD(aDbf,{"AREA"       ,"C",    2,0})
      AADD(aDbf,{"AREA2"      ,"C",    2,0})
      AADD(aDbf,{"MATRICULA"  ,"C",    5,0})
      AADD(aDbf,{"NOME"       ,"C",   50,0})
      AADD(aDbf,{"FUNCAO"     ,"C",   20,0})
      AADD(aDbf,{"FONE"       ,"C",   10,0})
      AADD(aDbf,{"RAMAL"      ,"C",    4,0})
      AADD(aDbf,{"SEXO"       ,"C",    1,0})
      AADD(aDbf,{"ESTCIVIL"   ,"C",    1,0})
      AADD(aDbf,{"MATR2"      ,"C",    8,0})
      AADD(aDbf,{"CPF"        ,"C",   11,0})
      AADD(aDbf,{"RG"         ,"C",   10,0})
      AADD(aDbf,{"LOTACAO"    ,"C",   25,0})
      AADD(aDbf,{"UNIDADE"    ,"C",    8,0})
      AADD(aDbf,{"NACIONAL"   ,"C",   15,0})
      AADD(aDbf,{"NATURAL"    ,"C",   15,0})
      AADD(aDbf,{"PROFISSAO"  ,"C",   20,0})
      AADD(aDbf,{"DATNAS"     ,"D",    8,0})
      AADD(aDbf,{"ENDERECO"   ,"C",   60,0})
      AADD(aDbf,{"BAIRRO"     ,"C",   15,0})
      AADD(aDbf,{"CIDADE"     ,"C",   15,0})
      AADD(aDbf,{"ESTADO"     ,"C",    2,0})
      AADD(aDbf,{"CEP"        ,"C",    8,0})
      AADD(aDbf,{"TEL"        ,"C",   10,0})
      AADD(aDbf,{"DTADESAO"   ,"D",    8,0})
      AADD(aDbf,{"OBS"        ,"C",   60,0})
      AADD(aDbf,{"COBRANCA"   ,"C",    2,0})
      AADD(aDbf,{"MOTIVO"     ,"C",   60,0})
      AADD(aDbf,{"USUARIO"    ,"C",   15,0})
      DBCREATE("SOCIOS.DBF",aDbf)
   ENDIF

   // Arquivo Cadastro de Sขcios Inativos
   IF !FILE('SOCIOSI.DBF')
      aDbf := {}
      AADD(aDbf,{"CATEGORIA"  ,"C",    2,0})
      AADD(aDbf,{"AREA"       ,"C",    2,0})
      AADD(aDbf,{"AREA2"      ,"C",    2,0})
      AADD(aDbf,{"MATRICULA"  ,"C",    5,0})
      AADD(aDbf,{"NOME"       ,"C",   50,0})
      AADD(aDbf,{"FUNCAO"     ,"C",   20,0})
      AADD(aDbf,{"FONE"       ,"C",   10,0})
      AADD(aDbf,{"RAMAL"      ,"C",    4,0})
      AADD(aDbf,{"SEXO"       ,"C",    1,0})
      AADD(aDbf,{"ESTCIVIL"   ,"C",    1,0})
      AADD(aDbf,{"MATR2"      ,"C",    8,0})
      AADD(aDbf,{"CPF"        ,"C",   11,0})
      AADD(aDbf,{"RG"         ,"C",   10,0})
      AADD(aDbf,{"LOTACAO"    ,"C",   25,0})
      AADD(aDbf,{"UNIDADE"    ,"C",    8,0})
      AADD(aDbf,{"NACIONAL"   ,"C",   15,0})
      AADD(aDbf,{"NATURAL"    ,"C",   15,0})
      AADD(aDbf,{"PROFISSAO"  ,"C",   20,0})
      AADD(aDbf,{"DATNAS"     ,"D",    8,0})
      AADD(aDbf,{"ENDERECO"   ,"C",   60,0})
      AADD(aDbf,{"BAIRRO"     ,"C",   15,0})
      AADD(aDbf,{"CIDADE"     ,"C",   15,0})
      AADD(aDbf,{"ESTADO"     ,"C",    2,0})
      AADD(aDbf,{"CEP"        ,"C",    8,0})
      AADD(aDbf,{"TEL"        ,"C",   10,0})
      AADD(aDbf,{"DTADESAO"   ,"D",    8,0})
      AADD(aDbf,{"OBS"        ,"C",   60,0})
      AADD(aDbf,{"COBRANCA"   ,"C",    2,0})
      AADD(aDbf,{"MOTIVO"     ,"C",   60,0})
      AADD(aDbf,{"USUARIO"    ,"C",   15,0})
      DBCREATE("SOCIOSI.DBF",aDbf)
   ENDIF

   // Arquivo Cadastro de Dependentes Ativos
   IF !FILE('DEPEND.DBF')
      aDbf := {}
      AADD(aDbf,{"CATEGORIA"  ,"C",    2,0})  /* Categoria do Titular */
      AADD(aDbf,{"MATRICULA"  ,"C",    5,0})  /* Matricula do Titular */
      AADD(aDbf,{"NOME"       ,"C",   50,0})  /* Nome do Dependente   */
      AADD(aDbf,{"SEXO"       ,"C",    1,0})
      AADD(aDbf,{"GRAU"       ,"C",   10,0})  /* Grau parentesco      */
      AADD(aDbf,{"DTNAS"      ,"D",    8,0})  /* Data de Nascimento   */
      AADD(aDbf,{"COBRANCA"   ,"C",    2,0})  /* Codigo de Cobranca   */
      DBCREATE("DEPEND.DBF",aDbf)
   ENDIF

   // Arquivo Cadastro de Dependentes Inativos
   IF !FILE('DEPENDI.DBF')
      aDbf := {}
      AADD(aDbf,{"CATEGORIA"  ,"C",    2,0})  /* Categoria do Titular */
      AADD(aDbf,{"MATRICULA"  ,"C",    5,0})  /* Matricula do Titular */
      AADD(aDbf,{"NOME"       ,"C",   50,0})  /* Nome do Dependente   */
      AADD(aDbf,{"SEXO"       ,"C",    1,0})
      AADD(aDbf,{"GRAU"       ,"C",   10,0})  /* Grau parentesco      */
      AADD(aDbf,{"DTNAS"      ,"D",    8,0})  /* Data de Nascimento   */
      AADD(aDbf,{"COBRANCA"   ,"C",    2,0})  /* Codigo de Cobranca   */
      DBCREATE("DEPENDI.DBF",aDbf)
   ENDIF

   // Arquivo Cadastro de Usuarios das Atividades do Clube
   IF !FILE('USUARIOS.DBF')
      aDbf := {}
      AADD(aDbf,{"MATRICULA"  ,"C",   05,0})  /* Matricula do Usuario */
      AADD(aDbf,{"NOME"       ,"C",   50,0})  /* Nome do Usuario      */
      AADD(aDbf,{"RESPON"     ,"C",   50,0})  /* Nome do Responsavel  */
      AADD(aDbf,{"RG"         ,"C",   10,0})
      AADD(aDbf,{"CPF"        ,"C",   11,0})
      AADD(aDbf,{"ENDERECO"   ,"C",   50,0})  /* Endereco do usuario */
      AADD(aDbf,{"BAIRRO"     ,"C",   15,0})
      AADD(aDbf,{"CIDADE"     ,"C",   15,0})
      AADD(aDbf,{"TEL"        ,"C",   10,0})
      AADD(aDbf,{"COBRANCA"   ,"C",    2,0})  /* Local de Cobranca    */
      AADD(aDbf,{"OBS"        ,"C",   50,0})  /* Observacoes          */
      DBCREATE("USUARIOS.DBF",aDbf)
   ENDIF
   IF !FILE('USUATIV.DBF')
      aDbf := {}
      AADD(aDbf,{"MATRICULA"  ,"C",   05,0})  /* Matricula do Usuario */
      AADD(aDbf,{"NOME"       ,"C",   50,0})  /* Nome do Usuario      */
      AADD(aDbf,{"ATIVIDADE"  ,"C",    2,0})  /* Atividade do Usuario */
      AADD(aDbf,{"DTINSCR"    ,"D",    8,0})  /* Data da Inscricao    */
      DBCREATE("USUATIV.DBF",aDbf)
   ENDIF

   // Convidados
   IF !FILE("CCONV.DBF")
      aDbf := {}
      AADD( aDbf, { "MATRICULA",  "C", 05, 00 } )
      AADD( aDbf, { "QCONMES",    "N", 02, 00 } ) // Quantidade Convite/Mes
      AADD( aDbf, { "QDISP",      "N", 02, 00 } ) // Quantidade Convite DISPONIVEL
      DBCREATE("CCONV.DBF",aDbf)
   ENDIF
   IF !FILE("CONVSOC.DBF")
      aDbf := {}
      AADD( aDbf, { "CODSOC",     "C", 05, 00 } ) && Codigo do SOCIO
      AADD( aDbf, { "RG",         "C", 10, 00 } ) && Identidade do Convidado
      AADD( aDbf, { "NOMEC",      "C", 50, 00 } ) && Nome do Convidado
      AADD( aDbf, { "RG"   ,      "C", 10, 00 } ) && Identidade
      AADD( aDbf, { "DTACONV",    "D", 08, 00 } ) && Data Conv
      AADD( aDbf, { "FLAGIMP",    "L", 01, 00 } ) && Flag Impressao
      DBCREATE("CONVSOC.DBF",aDbf)
   ENDIF
   IF !FILE("CADCONVT.DBF")
      aDbf := {}
      AADD( aDbf, { "CODSOC",   "C", 05, 00 } ) && Codigo do SOCIO
      AADD( aDbf, { "NOMEC",    "C", 50, 00 } ) && Nome do Convidado
      AADD( aDbf, { "ENDEC",    "C", 40, 00 } ) && Endereco Convidado
      AADD( aDbf, { "DTACONV",  "D", 08, 00 } ) && Data Conv
      AADD( aDbf, { "FLAGIMP",  "L", 01, 00 } ) && Flag Impressao
      DBCREATE("CADCONVT",aDbf)
   ENDIF
   IF !FILE("CLUB.CFG")
      aDbf := {}
      AADD( aDbf, { "DTRENOVA",   "D", 08, 00 } ) // Data da Renovacao das Disponibilidades
      AADD( aDbf, { "LIMITE",     "N", 02, 00 } ) // Limite de Convites no Mes
      DBCREATE("CLUB.CFG",aDbf)
   ENDIF

   // Criacao dos DBFS para utilizacao do Salao de Festas
   IF !FILE("DBCLSF.DBF")          // Salao de Festas Superior
      aDbf := {}
      AADD(aDbf,{"DATA",     "D", 08,00}) // Data da Solicitacao
      AADD(aDbf,{"CODIGO",   "C", 05,00}) // Matricula
      AADD(aDbf,{"RESPON",   "C", 50,00}) // responsavel pelo luguel
      AADD(aDbf,{"ENDERECO", "C", 60,00})
      AADD(aDbf,{"BAIRRO",   "C", 15,00})
      AADD(aDbf,{"CIDADE",   "C", 15,00})
      AADD(aDbf,{"ESTADO",   "C", 02,00})
      AADD(aDbf,{"CEP",      "C", 08,00})
      AADD(aDbf,{"TEL",      "C", 10,00})
      AADD(aDbf,{"RG",       "C", 11,00}) // RG
      AADD(aDbf,{"CPF",      "C", 11,00}) // CPF
      AADD(aDbf,{"USUARIO",  "C", 15,00}) // Usuario
      AADD(aDbf,{"HORAINI",  "C", 04,00}) // Horario Inicio
      AADD(aDbf,{"HORATER",  "C", 04,00}) // Horario Termino
      AADD(aDbf,{"EVENTO",   "C", 53,00}) // Evento
      AADD(aDbf,{"ALUGUEL",  "C", 01,00}) // se C-Cortesia, A-A Vista, R-Reserva
      AADD(aDbf,{"BEBIDA",   "C", 01,00}) // S-Sim, N-Nao
      AADD(aDbf,{"QTDREF",   "N", 04,00}) // Quantidade Refigerante
      AADD(aDbf,{"VALREF",   "N", 08,02}) // Valor Refrigerante Unitario
      AADD(aDbf,{"QTDCER",   "N", 04,00}) // Quantidade Cerveja
      AADD(aDbf,{"VALCER",   "N", 08,02}) // Valor da Cerveja Unitario
      AADD(aDbf,{"RECBEB",   "C", 06,00}) // Numero do Recibo da bebida
      AADD(aDbf,{"RECALU",   "C", 06,00}) // Numero do Recibo do Aluguel
      AADD(aDbf,{"VALALU",   "N", 13,02}) // Valor do Aluguel
      AADD(aDbf,{"DATPAG",   "D", 08,00}) // Data do pgto aluguel
      DBCREATE("DBCLSF",aDbf)
   ENDIF

   IF !FILE("DBCLSF2.DBF")   // Salao de Festas Inferior
      aDbf := {}
      AADD(aDbf,{"DATA",     "D", 08,00}) // Data da Solicitacao
      AADD(aDbf,{"CODIGO",   "C", 05,00}) // Matricula
      AADD(aDbf,{"RESPON",   "C", 50,00}) // responsavel pelo luguel
      AADD(aDbf,{"ENDERECO", "C", 60,00})
      AADD(aDbf,{"BAIRRO",   "C", 15,00})
      AADD(aDbf,{"CIDADE",   "C", 15,00})
      AADD(aDbf,{"ESTADO",   "C", 02,00})
      AADD(aDbf,{"CEP",      "C", 08,00})
      AADD(aDbf,{"TEL",      "C", 10,00})
      AADD(aDbf,{"RG",       "C", 11,00}) // RG
      AADD(aDbf,{"CPF",      "C", 11,00}) // CPF
      AADD(aDbf,{"USUARIO",  "C", 15,00}) // Usuario
      AADD(aDbf,{"HORAINI",  "C", 04,00}) // Horario Inicio
      AADD(aDbf,{"HORATER",  "C", 04,00}) // Horario Termino
      AADD(aDbf,{"EVENTO",   "C", 53,00}) // Evento
      AADD(aDbf,{"ALUGUEL",  "C", 01,00}) // se C-Cortesia, A-A Vista, R-Reserva
      AADD(aDbf,{"BEBIDA",   "C", 01,00}) // S-Sim, N-Nao
      AADD(aDbf,{"QTDREF",   "N", 04,00}) // Quantidade Refigerante
      AADD(aDbf,{"VALREF",   "N", 08,02}) // Valor Refrigerante Unitario
      AADD(aDbf,{"QTDCER",   "N", 04,00}) // Quantidade Cerveja
      AADD(aDbf,{"VALCER",   "N", 08,02}) // Valor da Cerveja Unitario
      AADD(aDbf,{"RECBEB",   "C", 06,00}) // Numero do Recibo da bebida
      AADD(aDbf,{"RECALU",   "C", 06,00}) // Numero do Recibo do Aluguel
      AADD(aDbf,{"VALALU",   "N", 13,02}) // Valor do Aluguel
      AADD(aDbf,{"DATPAG",   "D", 08,00}) // Data do pgto aluguel
      DBCREATE("DBCLSF2",aDbf)
   ENDIF
   Mensagem()
   
   // Arquivos Indices
   aArq_Ntx := { "HLP"     , "DBICOBR1", "DBICATE1", "DBIATIV1", "DBIATIV2",;
                 "DBISOCA1", "DBISOCA2", "DBISOCA3", "DBISOCA4", "DBISOCA5",;
                 "DBISOCA6", "DBISOCA7", "DBISOCA8", "DBIDEPA1", "DBIDEPA2",;
                 "DBIDEPA3", "DBIUSU1" , "DBIUSU2" , "DBIUSAT1", "DBIUSAT2",;
                 "DBIUSAT3", "DBIPGSO1", "DBIPGSO2", "DBIPGSO3", "DBIFUNC1", "DBIFUNC2",;
                 "DBIPGUS1", "DBISOCI1", "DBISOCI2", "DBISOCI3", "DBIDEPI1",;
                 "CCONV"   , "CONVSOC1", "DBIMUDA1", "DBIUNID1", "CONVSOC2",;
                 "CONVSOC3", "CONVSOC4", "CATCONV1", "CATCONV2", "CATCONV3",;
                 "CONVSOC5", "DBILSF1" , "DBIAREA1", "DBILSF21", "DBIPGCA1",;
                 "DBISOCA9"}

   FOR i = 1 TO LEN(aArq_Ntx)
       IF !FILE(aArq_Ntx[i]+".NTX")
          nFalta++
       ENDIF
   NEXT

   IF nFalta > 0
      tela2 := SAVESCREEN(2,0,22,79)
      Termom("Criando os Indices dos Arquivos",0,nFalta)

      IF !FILE("HLP.NTX")
         nTermom++
         USE HELP.HLP
         INDEX ON codigo+subcodigo TO HLP
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBIATIV1.NTX")
         nTermom++
         USE ATIV
         INDEX ON codativ TO DBIATIV1
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBIATIV2.NTX")
         nTermom++
         USE ATIV
         INDEX ON descr TO DBIATIV2
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBISOCA1.NTX")
         nTermom++
         USE SOCIOS
         INDEX ON matricula TO DBISOCA1
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBISOCA2.NTX")
         nTermom++
         USE SOCIOS
         INDEX ON nome TO DBISOCA2
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBISOCA3.NTX")
         nTermom++
         USE SOCIOS
         INDEX ON categoria+nome TO DBISOCA3
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBISOCA4.NTX")
         nTermom++
         USE SOCIOS
         INDEX ON matr2 TO DBISOCA4
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBISOCA5.NTX")
         nTermom++
         USE SOCIOS
         INDEX ON unidade+nome TO DBISOCA5
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBISOCA6.NTX")
         nTermom++
         USE SOCIOS
         INDEX ON SUBS(DTOC(datnas),4,2)+SUBS(DTOC(datnas),1,2) TO DBISOCA6
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBISOCA7.NTX")
         nTermom++
         USE SOCIOS
         INDEX ON funcao TO DBISOCA7
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBISOCA8.NTX")
         nTermom++
         USE SOCIOS
         INDEX ON area     TO DBISOCA8
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBISOCA9.NTX")
         nTermom++
         USE SOCIOS
         INDEX ON area2    TO DBISOCA9
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBISOCI1.NTX")
         nTermom++
         USE SOCIOSI
         INDEX ON matricula TO DBISOCI1
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBISOCI2.NTX")
         nTermom++
         USE SOCIOSI
         INDEX ON nome TO DBISOCI2
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBISOCI3.NTX")
         nTermom++
         USE SOCIOSI
         INDEX ON categoria TO DBISOCI3
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("CCONV.NTX")
         nTermom++
         USE CCONV
         INDEX ON matricula TO CCONV
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("CONVSOC1.NTX")
         nTermom++
         USE CONVSOC
         INDEX ON codsoc TO CONVSOC1
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("CONVSOC2.NTX")
         nTermom++
         USE CONVSOC
         INDEX ON nomec TO CONVSOC2
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("CONVSOC3.NTX")
         nTermom++
         USE CONVSOC
         INDEX ON DTOS(dtaconv)+nomec TO CONVSOC3
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("CONVSOC4.NTX")
         nTermom++
         USE CONVSOC
         INDEX ON codsoc+DTOS(dtaconv) TO CONVSOC4
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("CONVSOC5.NTX")
         nTermom++
         USE CONVSOC
         INDEX ON rg+DTOS(dtaconv) TO CONVSOC5
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("CATCONV1.NTX")
         nTermom++
         USE CADCONVT
         INDEX ON codsoc TO CATCONV1
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("CATCONV2.NTX")
         nTermom++
         USE CADCONVT
         INDEX ON codsoc+nomec TO CATCONV2
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("CATCONV3.NTX")
         nTermom++
         USE CADCONVT
         INDEX ON DTOS(dtaconv)+nomec TO CATCONV3
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBICATE1.NTX")
         nTermom++
         USE CATEG
         INDEX ON codcat  TO DBICATE1
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBICOBR1.NTX")
         nTermom++
         USE COBRANCA
         INDEX ON codlocal TO DBICOBR1
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBILSF1.NTX")
         nTermom++
         USE DBCLSF
         INDEX ON DTOS(data) TO DBILSF1
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBILSF21.NTX")
         nTermom++
         USE DBCLSF2
         INDEX ON DTOS(data) TO DBILSF21
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBIDEPA1.NTX")
         nTermom++
         USE DEPEND
         INDEX ON matricula+nome TO DBIDEPA1
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBIDEPA2.NTX")
         nTermom++
         USE DEPEND
         INDEX ON nome TO DBIDEPA2
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBIDEPA3.NTX")
         nTermom++
         USE DEPEND
         INDEX ON SUBS(DTOC(dtnas),4,2)+SUBS(DTOC(dtnas),1,2) TO DBIDEPA3
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBIDEPI1.NTX")
         nTermom++
         USE DEPENDI
         INDEX ON matricula+nome TO DBIDEPI1
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBIUSU1.NTX")
         nTermom++
         USE USUARIOS
         INDEX ON nome TO DBIUSU1
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBIUSU2.NTX")
         nTermom++
         USE USUARIOS
         INDEX ON matricula TO DBIUSU2
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBIUSAT1.NTX")
         nTermom++
         USE USUATIV
         INDEX ON nome+atividade TO DBIUSAT1
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBIUSAT2.NTX")
         nTermom++
         USE USUATIV
         INDEX ON matricula+atividade TO DBIUSAT2
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBIUSAT3.NTX")
         nTermom++
         USE USUATIV
         INDEX ON atividade+nome TO DBIUSAT3
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBIPGSO1.NTX")
         nTermom++
         USE PGSOC
         INDEX ON matricula+anomes TO DBIPGSO1
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBIPGSO2.NTX")
         nTermom++
         USE PGSOC
         INDEX ON anomes TO DBIPGSO2
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBIPGSO3.NTX")
         nTermom++
         USE PGSOC
         INDEX ON categoria+matricula+anomes TO DBIPGSO3
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBIPGUS1.NTX")
         nTermom++
         USE PGUSU
         INDEX ON matricula+atividade+anomes TO DBIPGUS1
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBIFUNC1.NTX")
         nTermom++
         USE FUNC
         INDEX ON codfunc TO DBIFUNC1
         Termom("",nTermom,nFalta)
      ENDIF
      IF !FILE("DBIFUNC2.NTX")
         nTermom++
         USE FUNC
         INDEX ON descr TO DBIFUNC2
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBIMUDA1.NTX")
         nTermom++
         USE MUDAPG
         INDEX ON codcat+anomes TO DBIMUDA1
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBIUNID1.NTX")
         nTermom++
         USE UNIDADE
         INDEX ON descr TO DBIUNID1
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBIAREA1.NTX")
         nTermom++
         USE AREAC
         INDEX ON areacomp TO DBIAREA1
         Termom("",nTermom,nFalta)
      ENDIF

      IF !FILE("DBIPGCA1.NTX")
         nTermom++
         USE PGCATG
         INDEX ON codcat+anomes TO DBIPGCA1
         Termom("",nTermom,nFalta)
      ENDIF

      INKEY(1); RESTSCREEN(2,0,22,79,tela2); DBCLOSEALL()
   ENDIF
   Mensagem()
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Criao Arq. de Sistema      ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE GeraSys()
   IF !FILE("USUARIO.SYS")
      aDbf := {}
      AADD(aDbf,{"USUARIO" , "C", 30,0 })
      AADD(aDbf,{"CHAVE"   , "C", 04,0 })
      AADD(aDbf,{"SENHA"   , "C", 06,0 })
      AADD(aDbf,{"NIVEL",    "N", 01,0 })
      AADD(aDbf,{"REG_DEL" , "N", 02,0 })
      AADD(aDbf,{"EM_USO"  , "L",  1,0 })
      DBCREATE("USUARIO.SYS",aDbf)
      IF NetUse("USUARIO.SYS","USER")
         IF NetApp()
            _FIELD->USUARIO := "NETWARE"
            _FIELD->CHAVE   := "NET4"
            _FIELD->SENHA   := Codifica("MASTER")
            _FIELD->NIVEL   := 9
            _FIELD->REG_DEL := 0
            _FIELD->EM_USO  := .F.
            UNLOCK
         ENDIF
      ENDIF
   ENDIF
   IF !FILE("USUARIO.NTX")
      IF NetUse("USUARIO.SYS","USER")
         INDEX ON chave TO USUARIO
      ENDIF
   ENDIF
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Criao Arq. de Configurao ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE GeraConfig()
   LOCAL aDbf := {}

   IF !FILE("APL.CFG")
      AADD( aDbf,{ "CORGERAL"  , "C", 40, 0 } )
      AADD( aDbf,{ "COREDIT"   , "C", 40, 0 } )
      AADD( aDbf,{ "CORMENU"   , "C", 40, 0 } )
      AADD( aDbf,{ "CORAVISO"  , "C", 40, 0 } )
      AADD( aDbf,{ "CORBARRA"  , "C", 40, 0 } )
      AADD( aDbf,{ "CORREALCE" , "C", 40, 0 } )
      AADD( aDbf,{ "CORTECLAS" , "C", 40, 0 } )
      AADD( aDbf,{ "IMPRESSORA", "C", 20, 0 } )
      AADD( aDbf,{ "EXPANDON"  , "C", 18, 0 } )
      AADD( aDbf,{ "EXPANDOFF" , "C", 18, 0 } )
      AADD( aDbf,{ "COMPR_ON"  , "C", 18, 0 } )
      AADD( aDbf,{ "COMPR_OFF" , "C", 18, 0 } )
      AADD( aDbf,{ "EXPAND_MED", "C", 30, 0 } )
      DBCREATE("APL.CFG",aDbf)
      IF NetUse("APL.CFG","APLCFG")
         IF NetApp()
            REPLACE _FIELD->CORGERAL   WITH "BG /B  ",;
                    _FIELD->COREDIT    WITH "N  /BG ,N  /W  ,,,N  /BG ",;
                    _FIELD->CORMENU    WITH "N  /BG ",;
                    _FIELD->CORAVISO   WITH "W  /R+ ,W  /N  ",;
                    _FIELD->CORBARRA   WITH "N  /W  ",;
                    _FIELD->CORREALCE  WITH "W+ /BG ",;
                    _FIELD->CORTECLAS  WITH "W+ /BG ",;
                    _FIELD->IMPRESSORA WITH "Epson FX/LX/LQ",;
                    _FIELD->EXPANDON   WITH "CHR(14)"    ,;
                    _FIELD->EXPANDOFF  WITH "CHR(20)"    ,;
                    _FIELD->COMPR_ON   WITH "CHR(15)"    ,;
                    _FIELD->COMPR_OFF  WITH "CHR(18)"    ,;
                    _FIELD->EXPAND_MED WITH "CHR(15)+CHR(14)"
            DBCLOSEAREA()
         ENDIF
         UNLOCK ALL
      ENDIF
   ENDIF
   IF NetUse("APL.CFG","APLCFG")
      YCORGERAL   := _FIELD->CORGERAL
      YCORMENU    := SUBSTR(_FIELD->CORMENU,1,7)+","+SUBSTR(_FIELD->CORBARRA,1,7)
      YCORBARRA   := _FIELD->CORBARRA
      YCORREALCE  := _FIELD->CORREALCE
      YCOREDIT    := _FIELD->COREDIT
      YCORAVISO   := _FIELD->CORAVISO
      YCORTECLAS  := _FIELD->CORTECLAS
      wImpressora := _FIELD->IMPRESSORA
      wExpandOn   := _FIELD->EXPANDON
      wExpandOff  := _FIELD->EXPANDOFF
      wCompr_On   := _FIELD->COMPR_ON
      wCompr_Off  := _FIELD->COMPR_OFF
      wExpand_Med := _FIELD->EXPAND_MED
      DBCLOSEAREA()
      UNLOCK ALL
   ENDIF
   RETURN
