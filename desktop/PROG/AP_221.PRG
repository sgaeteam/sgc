*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_221                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Agenda de Salao de Festas                ณ
*ณ PROGRAMADOR    : VITOR SMITH FREIRE - VIRTUAL             ณ
*ณ DATA CRIACAO   : 04/10/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PROCEDURE AP_221(pOp)
PUBLIC pOper:=pOp

DBCLOSEALL()
SELECT 3
IF !NetUse("DBPARM")
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF pOper==1
   IF NetUse("DBCLSF","SALAO")
      SET INDEX TO DBILSF1
      SET RELATION TO CODIGO INTO SOCIOS
   ELSE
      DBCLOSEALL(); RETURN
   ENDIF
ELSE
   IF NetUse("DBCLSF2","SALAO")
      SET INDEX TO DBILSF21
      SET RELATION TO CODIGO INTO SOCIOS
   ELSE
      DBCLOSEALL(); RETURN
   ENDIF
ENDIF
cOpHelp1 := "1"; cOpHelp2 := "10"
LinhaMsg(2); ProgName("GC221")
SET KEY -1 TO Mostra()
WHILE .T.
   lNovo := lDeleta := lAchou := .F. ; nPg:=1
   wMesAno := SPACE(6)
   aVetAgenda:={}
    
   Telas(18,3,20,36,1,YCOREDIT,.T.)
   SETCOLOR(YCOREDIT)
   Mensagem("Informe o Mes/Ano para Agendar")
   SETCURSOR(1)
   @ 19,05 SAY "Mes/Ano para Agendar:" GET wMesAno PICT "@r 99/9999" valid;
    EMPTY(wMesAno).or.LEN(ALLTRIM(wMesAno))==6
   READ

   SETCURSOR(0)
   Rest_Tela()
   IF EMPTY(wMesAno)
      EXIT
   ENDIF

   sData:=ctod("01/"+left(wMesAno,2)+"/"+right(wMesAno,4))
   sMesExt:=MesExt(sData)+"/"+str(year(sData),4)
   nMes:=month(sData)
   FOR nDiaMes:=1 TO 31
       dbSeek(dtos(sData))
       wEvento:=EVENTO
       AADD(aVetAgenda,strzero(nDiaMes,2)+" "+SiglaDia(sData)+" "+wEvento)
       sData++
       if nMes<>Month(sData)
          exit
       endif
   NEXT
   vlin=1
   vpos=0
   vachoice=1
   setcolor(sCorNova:="gr+/n+,w+/rb+")
   LimpaLinhaMsg()
   Telas(06,05,20,74,1,sCorNova,.T.)
   @ 07,06 say "Data   Eventos para "+sMesExt
   @ 08,05 say "ร"+replicate("ฤ",68)+"ด"
   DO WHILE vachoice#0
      @ 23,00 SAY SPACE(80) COLOR YCORMENU
      @ 23,00 say " -Alt   -Exc   -Inc   -Imp       -Consultar   -Programao   -Contrato" COLOR YCORMENU
*                  01234567890123456789012345678901234567890123456789012345678901234567890123456789
*                            1         2         3         4         5         6         7
      @ 23,00 say "A" COLOR YCORREALCE
      @ 23,07 say "E" COLOR YCORREALCE
      @ 23,14 say "I" COLOR YCORREALCE
      @ 23,21 say "P" COLOR YCORREALCE
      @ 23,28 say "ENTER" COLOR YCORREALCE
      @ 23,45 say "L" COLOR YCORREALCE
      @ 23,60 say "C" COLOR YCORREALCE
      vachoice=ACHOICE(09,06,19,73,aVetAgenda,.T.,"CADASTRO",vlin,vpos)
   ENDDO
   Rest_Tela()
   KEYBOARD CHR(0)
ENDDO
SETCURSOR(0)
DBCLOSEALL()
SETKEY(K_F2,NIL)
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Sigla do Dia na Data         ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION SiglaDia(dData)
   local aDia:={"Dom","Seg","Ter","Qua","Qui","Sex","Sab"}
   nDia:=dow(dData)
   return aDia[nDia]
*ีออออออออออออออออออออออออออออออธ
*ณ Cadastrar Evento             ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION CADASTRO(mens,lin,pos)
vcontrole:=""
vpos=pos
vlin=lin

DO CASE
   CASE LASTKEY()=97.or.LASTKEY()==65      /* Alterar Evento */
        IF Acesso(3)
           vcontrole:="A"
           MOSTRATELA()
           vvalor=1
        ELSE
           vvalor=0
        ENDIF
   CASE LASTKEY()=101.or.LASTKEY()==69     /* Excluir Evento */
        IF Acesso(5)
           vcontrole:="E"
           MOSTRATELA()
           vvalor=1
        ELSE
           vvalor=0
        ENDIF
   CASE LASTKEY()=105.or.LASTKEY()==73     /* Incluir Evento */
        IF Acesso(3)
           vcontrole:="I"
           ENTRATELA()
           vvalor=1
        ELSE
           vvalor=0
        ENDIF
   CASE LASTKEY()=67.or.LASTKEY()==99      /* Editar Contrato */
        IF Acesso(9)
           EditaContrato()
           vvalor=1
        ELSE
           vvalor=0
        ENDIF
   CASE LASTKEY()=80.or.LASTKEY()==112    /* Imprimir Contrato */
        IF Acesso(3)
           vcontrole:="P"
           wData:=ctod(strzero(vlin,2)+"/"+left(wMesAno,2)+"/"+right(wMesAno,4))
           SELECT SALAO
           if dbSeek(dTos(wData))
              CorAntes:=SetColor()
              For a=1 to fCount()
                  Var := "w"+FieldName(a)
                  &Var := FieldGet(a)
              Next
              if Confirma("Imprimir Contrato ? ")
                 ImprimeContrato()
              endif
              SetColor(CorAntes)
           endif
           vvalor=1
        ELSE
           vvalor=0
        ENDIF
   CASE LASTKEY()=76.or.LASTKEY()==108    /* Imprimir Programacao */
        IF Acesso(3)
           if Confirma("Imprimir Programao ? ").and.ChkImpr()
              CorAntes:=SetColor()
              cAviso := MsgImp(.F.)
              Gera_TXT("AP221.TXT")
              SETPRC(0,0)
              vcontrole:="L"
              sData   := CTOD("01/"+left(wMesAno,2)+"/"+right(wMesAno,4))
              sMesExt := MesExt(sData)+"/"+str(year(sData),4)
              nMes    := MONTH(sData)
              lCab    := CabProg(sData)
              FOR nDiaMes:=1 TO 31
                  IF !lCab
                     lCab:=CabProg(sData)
                  ENDIF
                  dbSeek(dtos(sData))
                  wData:=ctod(strzero(nDiaMes,2)+"/"+strzero(nMes,2)+"/"+str(year(sData),4))
                  SELECT SALAO
                  dbSeek(dTos(wData))
                  For a=1 to fCount()
                      Var := "w"+FieldName(a)
                      &Var := FieldGet(a)
                  Next
                  ImpProg(sData,nDiaMes)
                  IF PROW()>57
                     lCab:=.F.
                     EJECT
                  ENDIF
                  sData++
                  if nMes<>Month(sData)
                     exit
                  endif
              NEXT
              Fim_TXT()
              SAVESCREEN(0,0,24,79)
              RUN nodosimp ap221.txt 80 pre
              RESTSCREEN(0,0,24,79,0)
              DELETE FILE AP221.TXT
              TiraMsgImp(cAviso)
              Mensagem("Fim de Impresso! Tecle algo...")
              INKEY(0)
              Mensagem()
              SetColor(CorAntes)
           endif
           vvalor=1
        ELSE
           vvalor=0
        ENDIF
   CASE LASTKEY()==13    /* Consulta */
        MostraTela()
        vvalor=1
   CASE LASTKEY()=27
        vvalor=0
   OTHE
        vvalor=2
ENDCASE
RETURN vvalor
*ีออออออออออออออออออออออออออออออธ
*ณ Atualizar Tela de Eventos    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION MostraTela()
   local CorAnt:=SetColor()
   lSocio:=.F.
   wData:=ctod(strzero(vlin,2)+"/"+left(wMesAno,2)+"/"+right(wMesAno,4))
   SELECT SALAO
   if dbSeek(dTos(wData))
      if (vcontrole="A".OR.vcontrole="E").AND.!NetLReg()
         clear gets
         SETCOLOR(CorAnt)
         return nil
      endif
      For a=1 to fCount()
          Var := "w"+FieldName(a)
          &Var := FieldGet(a)
      Next
      nTotRef:=QTDREF*VALREF
      nTotCer:=QTDCER*VALCER
      nTotCons:=nTotRef+nTotCer
      mTelaGet()
      IF vcontrole=="E" &&.and.NetLReg()
         CLEAR GETS
         IF Confirma("Excluir Evento ? ")
            dbDelete()
            aVetAgenda[vlin]:=strzero(vlin,2)+" "+SiglaDia(wData)+" "+space(53)
         ENDIF
         if len(Telas)>4;Rest_Tela();endif
      ELSEIF vcontrole=="A" &&.and.NetLReg()
         SETCURSOR(1); READ; SETCURSOR(0)
         IF UPDATED().AND.LASTKEY()<>27.AND.Confirma("Confirma Alteracao ? ")
            gTelaGet()
            aVetAgenda[vlin]:=strzero(vlin,2)+" "+SiglaDia(wData)+" "+wEvento
         ENDIF
         if len(Telas)>4;Rest_Tela();endif
      ELSEIF vcontrole==""
         CLEAR GETS
         INKEY(0)
         if len(Telas)>4;Rest_Tela();endif
      ENDIF
      UNLOCK
      DBCOMMITALL()
   ENDIF
   SETCOLOR(CorAnt)
Return nil
*ีออออออออออออออออออออออออออออออธ
*ณ Entrada de Dados dos Eventos ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION EntraTela()
   local CorAnt:=SetColor()
   lSocio:=.F.
   wData:=ctod(strzero(vlin,2)+"/"+left(wMesAno,2)+"/"+right(wMesAno,4))
   SELECT SALAO
   if !dbSeek(dTos(wData))
      For a=1 to fCount()
          Var := "w"+FieldName(a)
          &Var := FieldGet(a)
      Next
      nTotCer:=nTotRef:=nTotCons:=0.00
      wData:=ctod(strzero(vlin,2)+"/"+left(wMesAno,2)+"/"+right(wMesAno,4))
      mTelaGet()
      SetCursor(1); read; SetCursor(0)

      IF LASTKEY()<>27.AND.Confirma("Confirma os Dados ? ")
         IF NetApp()
            gTelaGet()
            aVetAgenda[vlin]:=strzero(vlin,2)+" "+SiglaDia(wData)+" "+wEvento
            UNLOCK
         ENDIF
      ENDIF
      if len(Telas)==6
         Rest_Tela(); Rest_Tela()
      elseif len(telas)<6.and.len(telas)>=4
         Rest_Tela()
      endif
   endif
   SETCOLOR(CorAnt)
Return nil
*ีออออออออออออออออออออออออออออออธ
*ณ Extenso do Mes               ณ
*ิออออออออออออออออออออออออออออออพ
Func MesExt(sDat)
    local aMes:={"Janeiro","Fevereiro","Marco","Abril","Maio","Junho",;
                 "Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
return aMes[Month(sDat)]
*ีออออออออออออออออออออออออออออออธ
*ณ Verificar Responsavel        ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION lChkSeSocio(sResp,lSoc)
       local dbAntes:=Select()
       Select SOCIOS
       if (lSoc:=dbSeek(sResp))
          wCpf:=CPF
          wRG:=RG
          wEndereco:=ENDERECO
          wBairro:=BAIRRO
          wCidade:=CIDADE
          wEstado:=ESTADO
          wTel:=TEL
          wCodigo:=MATRICULA
       endif
       TeclaFuncao()
       dbSelectArea(dbAntes)
return .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Digitao dos Dados do Eventoณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE mTelaGet()
     SETCOLOR(YCOREDIT)
     Telas(03,04,20,74,1,YCOREDIT,.T.,"Aluguel Salo de Festas "+IF(pOper==1,"Superior","Inferior"))
     Mensagem()
     @ 04,06 say "Respons vel:"  get wRespon   pict[@!@s29] when TeclaFuncao(.T.) valid !empty(wRespon).and.lChkSeSocio(wRespon,@lSocio)
     @ 04,49 say "Data:"         get wData     when .F.
     @ 05,06 say " Identidade:"  get wRG       pict[@9] when !lSocio 
     @ 05,45 say "     CPF:"     get wCpf      pict[@r 999.999.999-99] when !lSocio valid UmDosDois().or.empty(wCpf).or.ChkCpf(wCpf)
     @ 06,06 say "   Endereo:"  get wEndereco pict[@!@k@S55] when !lSocio
     @ 07,06 say "     Bairro:"  get wBairro   pict[@!] when !lSocio
     @ 07,45 say "  Cidade:"     get wCidade   pict[@!@s10] when !lSocio
     @ 07,67 say "UF:"           get wEstado   pict[!!] when !lSocio
     @ 08,06 say "       Fone:"  get wTel      pict[@r (999) 999-9999] when !lSocio
     @ 08,45 say " Matric.:"
     @ 08,55 get wCodigo when .F. pict[@!] COLOR YCORREALCE
     @ 09,04 say "ร"+replicate("ฤ",69)+"ด"

     @ 10,06 say "     Evento:"  get wEvento   pict[@!@k@s53] valid !empty(wEvento)
     @ 11,04 say "ร"+replicate("ฤ",69)+"ด"
     @ 11,07 say "Hor rio"
     @ 12,06 say "     Inicio:"  get wHoraIni  pict[@r 99:99] valid !empty(wHoraini)
     @ 12,30 say " Trmino:"     get wHoraTer  pict[@r 99:99] valid !empty(wHoraTer)
     @ 12,51 say "   Tipo:"      get wAluguel  pict[!] when HTela(1) valid VTela(1)
     @ 13,04 say "ร"+replicate("ฤ",69)+"ด"
     @ 14,06 say "  Nง Recibo:"  get wRecAlu   pict[999999] when (wAluguel$"A") valid !empty(wRecAlu)
     @ 14,30 say "    Pgto:"     get wDatPag   when (wAluguel$"A") valid !empty(wDatPag)
     @ 14,51 say "  Valor:"      get wValAlu   pict[@e 999,999,999.99] when (wAluguel$"A") valid wValAlu<>0.00
     @ 15,04 say "ร"+replicate("ฤ",69)+"ด"

     @ 16,06 say "    Bebidas:"  get wBebida   pict[!] when HTela(2) valid VTela(2)
     @ 17,06 say "   Cervejas:"  get wQtdCer   pict[9999] when wBebida=="S"
     @ 17,27 say "Preo Unit.:"  get wValCer   pict[@e 999.99] when !empty(wQtdCer)
     @ 17,51 say "  Total:"      get nTotCer   pict[@e 999,999.99] when CalcVal(wQtdCer,wValCer,@nTotCer)
     @ 18,06 say "   Refrigs.:"  get wQtdRef   pict[9999] when wBebida=="S"
     @ 18,27 say "Preo Unit.:"  get wValRef   pict[@e 999.99] when !empty(wQtdRef)
     @ 18,51 say "  Total:"      get nTotRef   pict[@e 999,999.99] when CalcVal(wQtdRef,wValRef,@nTotRef)
     @ 19,06 say "  Nง Recibo:"  get wRecBeb   pict[999999] when wBebida=="S" valid !empty(wRecbeb)
     @ 19,51 say "Consumo:"      get nTotCons  pict[@e 999,999.99] when CalcConsumo(nTotCer,nTotRef,@nTotCons)
return
*ีออออออออออออออออออออออออออออออธ
*ณ Gravao dos Dados do Evento ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE gTelaGet()
     FIELD->DATA    := wData;     FIELD->CODIGO   := wCodigo
     FIELD->RESPON  := wRespon;   FIELD->ENDERECO := wEndereco
     FIELD->BAIRRO  := wBairro;   FIELD->CIDADE   := wCidade
     FIELD->ESTADO  := wEstado;   FIELD->CEP      := wCep
     FIELD->TEL     := wTel;      FIELD->RG       := wRg
     FIELD->CPF     := wCpf;      FIELD->USUARIO  := cUsuario
     FIELD->HORAINI := wHoraIni;  FIELD->HORATER  := wHoraTer
     FIELD->EVENTO  := wEvento;   FIELD->ALUGUEL  := wAluguel
     FIELD->BEBIDA  := wBebida;   FIELD->QTDREF   := wQtdRef
     FIELD->VALREF  := wValRef;   FIELD->QTDCER   := wQtdCer
     FIELD->VALCER  := wValCer;   FIELD->RECBEB   := wRecBeb
     FIELD->RECALU  := wRecAlu;   FIELD->DATPAG   := wDatPag
     FIELD->VALALU  := wValAlu
return nil
*ีออออออออออออออออออออออออออออออธ
*ณ Calcular Vlr.total de produtoณ
*ิออออออออออออออออออออออออออออออพ
STATIC func CalcVal(nQtd,nVal,nRet)
     nRet:=nQtd*nVal
return .F.
*ีออออออออออออออออออออออออออออออธ
*ณ Calcular Vlr.total Consumo   ณ
*ิออออออออออออออออออออออออออออออพ
STATIC func CalcConsumo(nCer,nRef,nRet)
     nRet:=nCer+nRef
return .F.
*ีออออออออออออออออออออออออออออออธ
*ณ Testar digitao de CPF/RG   ณ
*ิออออออออออออออออออออออออออออออพ
STATIC func UmDosDois()
   lok:=if(empty(wcpf).and.empty(wRg),.F.,.T.)
   if !lOk
      Aviso("CPF ou Identidade Obrigatorio",,3)
   endif
return lOk
*ีออออออออออออออออออออออออออออออออธ
*ณ Imprimir Cabecalho Programacao ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC func CabProg(pDat)
  @ PROW()   ,00 SAY "Clube 2004"
  @ PROW()   ,73 SAY DTOC(DATE()) PICT "@D"
  @ PROW()+02,18 SAY "LISTAGEM DA PROGRAMACAO DO MES DE "+UPPER(MesExt(pDat))+" "+str(year(pDat),4)
  @ PROW()+01,00 SAY REPLICATE("-",79)
  @ PROW()+01,00 SAY "Data/Dia Horario Evento/Responsavel                              Fone/Aluguel"
  @ PROW()+01,00 SAY REPLICATE("-",79)
  RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Programacao         ณ
*ิออออออออออออออออออออออออออออออพ
STATIC proc ImpProg(pDat,pDia)
  @ PROW()+01,02 SAY STRZERO(pDia,2)
  @ PROW()   ,04 SAY "/"+SiglaDia(pDat)
  @ PROW()   ,09 SAY wHoraIni PICT "@R 99:99"
  @ PROW()   ,17 SAY wEvento  PICT "@S47"
  @ PROW()   ,65 SAY wTel     PICT "@R (999) 999-9999"
  @ PROW()+01,09 SAY wHoraTer PICT "@R 99:99"
  @ PROW()   ,17 SAY wRespon  PICT "@S47"
  @ PROW()   ,65 SAY IF(wAluguel="A","A vista",IF(wAluguel="C","Cortesia",IF(wAluguel="R","Reserva","")))
  @ PROW()+01,00 SAY ""
  RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Editar Contrato              ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION EditaContrato()
   LOCAL nCursor := SETCURSOR() ; cArea := SELECT() ; cCorAntes := SETCOLOR()
   SETKEY(K_F4,NIL)
   SETKEY(K_F2,NIL)
   SETKEY(K_F5,NIL)
   Telas(7,9,20,70,1,YCOREDIT,.T.)
   LinhaMsg(9)
   SETCOLOR(YCOREDIT)
   SETCURSOR(1)
   lIns := .F.
   Mensagem(" "+CHR(24)+" "+CHR(25)+" PgUp PgDn ESC     P g:     Lin:      Col:    ")
   SELECT DBPARM
   WHILE .T.
      wtexto := MEMOEDIT(CONTRATO,8,10,19,69,.T.,"Editor5")
      IF LASTKEY()==K_F2
         SELECT DBPARM
         IF NetLReg()
            FIELD->CONTRATO := wtexto
            ProcOk("Gravado")
            nPg:=1
         ENDIF
      ELSEIF LASTKEY()==K_ESC
         EXIT
      ENDIF
   ENDDO
   Rest_Tela()
   SETCURSOR(nCursor)
   SETKEY(K_F4,{|| Calculadora(@calc_lin,@calc_col,YCORMENU)})
   SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
   SET KEY -1 TO Mostra()
   RELEASE wtexto
   SELECT(cArea)
   SETCOLOR(cCorAntes)
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Controlar Editor Texto       ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Editor5(pModo,nlin,ncol)
   lRet := 0
   DO CASE
      CASE pModo = 0
           cCorAnterior := SETCOLOR()
           nPg:= INT(nLin/41)+1
           @ 23,43 SAY TRIM(STRZERO(nPg,2))  COLOR YCORREALCE
           @ 23,52 SAY TRIM(STRZERO(nLin,4)) COLOR YCORREALCE
           @ 23,62 SAY TRIM(STRZERO(nCol,2)) COLOR YCORREALCE
           SETCOLOR(cCorAnterior)
      CASE pModo = 1 .OR. pModo = 2
           IF LASTKEY()==K_F2
              lRet := 23
           ENDIF
           IF LASTKEY()==K_INS
              cCorAnterior := SETCOLOR()
              SETCOLOR("*N/W")
              @ 23,34 SAY IF(lIns,"       ","Inserir")
              lIns := IF(lIns,.F.,.T.)
              SETCOLOR(cCorAnterior)
           ENDIF
           IF LASTKEY()==K_F3
              wData:=ctod(strzero(vlin,2)+"/"+left(wMesAno,2)+"/"+right(wMesAno,4))
              SELECT SALAO
              if dbSeek(dTos(wData))
                 CorAntes:=SetColor()
                 For a=1 to fCount()
                     Var := "w"+FieldName(a)
                     &Var := FieldGet(a)
                 Next
                 IF Confirma("Imprime Contrato ?")
                    ImprimeContrato()
                    Mensagem()
                 ENDIF
              else
                 Aviso("Contrato sข imprime com evento",,3)
              endif
           ENDIF
      CASE pModo = 3
           READINSERT(.F.)
   ENDCASE
   RETURN lRet
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Contrato            ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE InicContrato()
 IMP_graf()
 IMP_exp()
 @ PROW()+04,00 SAY "CONTRATO PARA ALUGUEL - SALAO DE FESTAS"
 IMP_Enor()
 @ PROW()+03,00 SAY "Responsavel Evento: "+wRespon
 @ PROW()+01,00 SAY "Endereco..........: "+wEndereco
 @ PROW()+01,00 SAY "C.I...............: "+wRg
 @ PROW()+00,33 SAY "Data do Evento.: "+DTOC(wData)
 @ PROW()+01,00 SAY "Pagamento.........: "
 @ PROW()+00,33 SAY "Data.: "+DTOC(wDatPag)
 @ PROW()+00,53 SAY "Valor.: "
 @ PROW()+00,61 SAY wValAlu PICT[@E 999,999,999.99]
 @ PROW()+02,00 SAY ""
 RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Contrato            ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImprimeContrato()
   LOCAL cCorAntes := SETCOLOR(), cArea := SELECT(), nCursor := SETCURSOR()

   IF ChkImpr()
      cAviso := MsgImp(.F.)
      Gera_TXT("AP221a.TXT")
      SETPRC(0,0)
      InicContrato()
      SELECT DBPARM
      nLinha := MLCOUNT(CONTRATO,60)
      FOR n = 1 TO nLinha
          cLinha := MEMOLINE(CONTRATO,60,N)
          @ PROW()+01,00 SAY cLinha
          IF PROW()>=52
             EJECT
             @ PROW()+03,00 SAY ""
          ENDIF
      NEXT
      IF PROW()>=46; EJECT; ENDIF
      @ PROW()+3,00 say DatExtenso(date())
      @ PROW()+4,00 say "_____________________        ____________________"
      @ PROW()+1,00 say "   Assinatura do              Clube 2004 da Bahia"
      @ PROW()+1,00 say "    Responsavel"
      Fim_TXT()
      SAVESCREEN(0,0,24,79)
      RUN nodosimp ap221a.txt 80 pre
      RESTSCREEN(0,0,24,79,0)
      DELETE FILE AP221a.TXT
      TiraMsgImp(cAviso)
      Mensagem("Fim de Impresso! Tecle algo...")
      INKEY(0)
   ENDIF
   SETCOLOR(cCorAntes)
   SELECT(cArea)
   SETCURSOR(nCursor)
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Extenso da Data     ณ
*ิออออออออออออออออออออออออออออออพ
STATIC func DatExtenso(dData)
  local Extenso:="Salvador, "+strzero(day(dData),2)+" de "+;
                  MesExt(dData)+" de "+str(year(dData),4)
  return Extenso
