*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : GP_ERRO                          vrs 001 ³
*³ VRS 001        : Desenvolvimento                          ³
*³ FINALIDADE     : Gerenciador de Erros                     ³
*³ AUTOR          : Nantucket Corp. 1990                     ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE (IT)                ³
*³ DATA CRIACAO   : 21/02/1994                               ³
*³ OBSERVA€O     : Compilar com /N /A /M                    ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "ERROR.CH"

// Define os comandos para enviar mensagens a tela
#command ? <list,...>   =>  ?? CHR(13) + CHR(10) ; ?? <list>
#command ?? <list,...>  =>  OutErr(<list>)

// Define uma pseudofuncao a ser utilizada nas rotinas
# define NTRIM(n)  (LTRIM(STR(n)))

PROCEDURE ErrorSys()
   ERRORBLOCK( {|e| DefError(e)} )
   RETURN
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³                       DEFINI€O DE ERROS PADRO                           ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
STATIC FUNCTION DefError(e)
   LOCAL i, cMessage, aOptions, nChoice

   // Por definicao, divisao por zero retorna zero
   IF (e:genCode == EG_ZERODIV)
      RETURN(0)
   ENDIF

   /* Em ambiente de rede local, um erro de abertura de arquivo
      estabelece o valor de retorno da funcao NETERR() e o subsistema
      padrao. */
   IF (e:genCode == EG_OPEN .AND. e:osCode == 32 .AND. e:canDefault)
      NETERR(.T.)
      RETURN(.F.)
   ENDIF

   /* Quando ocorrer um erro de bloqueio ao ser adicionado um novo
      registro num arquivo (APPEND BLANK), esabelece a funcao NETERR()
      e o subsistema para os padroes normais */
   IF (e:genCode == EG_APPENDLOCK .AND. e:canDefault)
      NETERR(.T.)
      RETURN(.F.)
   ENDIF

   // Construcao da mensagem de erro
   cMessage := ErrorMessage(e)

   // Construcao de um vetor de opcoes para o usuario
   // aOptions := {"Break","Quit"}

   aOptions := {"Quit"}          // Finaliza

   IF (e:canRetry)
      AADD(aOptions,"Default")   // Assume padrao
   ENDIF

   // Constroi uma janela de solicitacao
   nChoice := 0
   WHILE (nChoice == 0)
      IF (EMPTY(e:osCode))
         nChoice := Alert(cMessage,aOptions)
      ELSE
         nChoice := Alert(cMessage+"Erros DOS "+NTRIM(e:osCode)+")",aOptions)
      ENDIF
      IF (nChoice == NIL)
         EXIT
      ENDIF
   ENDDO

   IF (!EMPTY(nChoice))
      // Executa de acordo com a opcao do usuario
      IF (aOptions[nChoice] == "Break")
         // Interrompe a execucao
         Break(e)
      ELSEIF (aOptions[nChoice] == "Retry")
         // Tenta novamente a operacao
         RETURN(.T.)
      ELSEIF (aOptions[nChoice] == "Default")
         // Assume o resultado padrao para a operacao
         RETURN(.F.)
      ENDIF
   ENDIF

   /* Apresenta a mensagem de erro e a lista de rotinas executadas
      ate o momento */
   Autor(.T.,.F.)
   IF (!EMPTY(e:osCode))
      cMessage += "Erro DOS "+NTRIM(e:osCode)+")"
   ENDIF
   ? cMessage
   i := 2
   WHILE (!EMPTY(PROCNAME(i)))
      ? "Chamada por ",TRIM(PROCNAME(i))+"("+NTRIM(PROCLINE(i))+")"
      i++
   ENDDO

   // Define o codigo de erro do DOS para 1
   ERRORLEVEL(1)

   // Cancela a execucao do programa
   ? "Programa Cancelado..."
   ?
   // Retorna o Status do Usuario Ativo
   IF NetUse("USUARIO.SYS","USER")
      SET INDEX TO USUARIO
      IF NetLReg()
         USER->EM_USO := .F.
      ENDIF
   ENDIF
   QUIT
   RETURN(.F.)
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³                       CONTRU€O DE MENSAGENS DE ERRO                      ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
STATIC FUNCTION ErrorMessage(e)
   LOCAL cMessage

   // Inicio da construcao da mensagem de erro (Testa grau do erro)
   cMessage := IF(e:severity > ES_WARNING, "Erro ", "Advertencia " )

   // Se disponivel, apresenta o nome do subsistema no qual ocorreu o erro
   IF (VALTYPE(e:subsystem) == "C" )
      cMessage += e:subsystem()
   ELSE
      cMessage += "???"
   ENDIF

   // Se disponivel, apresenta o codigo de erro ocorrido
   IF (VALTYPE(e:subCode) == "N" )
      cMessage += ("/" + NTRIM(e:subCode))
   ELSE
      cMessage += "/???"
   ENDIF

   // Se disponivel, apresenta a descricao do erro ocorrido
   IF (VALTYPE(e:description) == "C" )
      cMessage += ("  " + e:description)
   ENDIF

   /* Se disponivel, apresenta o nome do arquivo que causou o erro
      ou a operacao que falhou */
   IF (!EMPTY(e:filename) )
      cMessage += (": " + e:filename)
   ELSEIF (!EMPTY(e:operation) )
      cMessage += (": " + e:operation)
   ENDIF
   RETURN (cMessage)
