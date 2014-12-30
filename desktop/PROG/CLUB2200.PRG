*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : CLUB2200                         vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Imprimir Convite                         ณ
*ณ PROGRAMADOR    : VITOR FREIRE/WILSON CAMPOS               ณ
*ณ DATA CRIACAO   : 24/09/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA1,DBISOCA2,DBISOCA3,DBISOCA4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("CONVSOC")
   SET INDEX TO CONVSOC3,CONVSOC2,CONVSOC1,CONVSOC4,CONVSOC5
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("CADCONVT",,"E")
   SET INDEX TO CATCONV3, CATCONV2, CATCONV1
   SET RELATION TO CODSOC INTO SOCIOS
   REINDEX
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 4
IF NetUse("CCONV",,"E")
   SET INDEX TO CCONV
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT CADCONVT
IF EOF()
   Aviso("No h  convites pendentes"); DBCLOSEALL(); RETURN
ENDIF

continua:=.T.; pg:=0
IF ChkImpr()
   Imprimindo := MsgImp()
   lSaida     := .F. ; wCont := 0
   Gera_TXT("CL2200.TXT")
   WHILE !EOF()
      IF !FlagImp
         CAB22(01,08,"+"+REPL("-",60)+"+")
         CAB22(01,08,"|")
         CAB22(00,69,"|")
         Imp_Exp()
         CAB22(00,11,"Clube 2004")
         CAB22(00,11,"Clube 2004")
         Imp_Enor()
         Imp_Normal()
         FOR i= 1 TO 2
             CAB22(01,08,"|")
             CAB22(00,69,"|")
         NEXT
         CAB22(01,08,"|")
         CAB22(00,34,"CONVITE")
         CAB22(00,34,"CONVITE")
         CAB22(00,69,"|")
         FOR i= 1 TO 2
             CAB22(01,08,"|")
             CAB22(00,69,"|")
         NEXT
         CAB22(00,11,"SOCIO: "+SOCIOS->NOME)
         CAB22(00,11,"SOCIO: "+SOCIOS->NOME)
         CAB22(01,08,"|")
         CAB22(00,69,"|")
         CAB22(01,08,"|  Convidamos o(a) Sr(a). ")
         CAB22(00,34,SUBSTR(NOMEC,1,35))
         CAB22(00,34,SUBSTR(NOMEC,1,35))
         CAB22(00,69,"|")
         CAB22(01,08,"|  para frequentar as instalacoes  do  CLUBE 2004  no  dia   |")
         CAB22(01,08,"|  "+DTOC(DTACONV)+", sendo o associado responsavel pela conduta do   |")
         CAB22(01,08,"|  convidado.                                                |")
         FOR i= 1 TO 2
             CAB22(01,08,"|")
             CAB22(00,69,"|")
         NEXT
         CAB22(01,08,"|  -------------------------    --------------------------   |")
         CAB22(01,08,"|           SOCIO                       DIRETOR              |")
         CAB22(01,08,"|")
         CAB22(00,69,"|")
         CAB22(01,08,"+"+REPL("-",60)+"+")

         SELECT CCONV
         DBSEEK(CADCONVT->CODSOC)
         IF _FIELD->QDISP > 0
            CAB22(01,08,"Voce tem direito a trazer "+STR(_FIELD->QDISP,2)+" convidados ainda este mes")
         ENDIF

         CAB22(01,08,"")
         SELECT CADCONVT
         wCont++
         IF !lSaida
            lSaida:=.T.
         ENDIF
         IF wCont==3
            wCont := 0; EJECT
         ENDIF
      ENDIF
      DBSKIP()
   ENDDO
   EJECT
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp cl2200.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE CL2200.TXT

   TiraMsgImp(Imprimindo)
*   IF lSaida.AND.Confirma("Impresso OK ? ")
      SELECT CADCONVT
      DBGOTOP()
      WHILE !EOF()
         FOR a = 1 TO FCOUNT()
             Var  := "w"+FIELDNAME(a)
             &Var := FIELDGET(a)
         NEXT
         SELECT CONVSOC
         IF NetApp()
            FOR a = 1 TO FCOUNT()
                Var := "w"+FIELDNAME(a)
                FIELDPUT(a,&Var)
            NEXT
         ENDIF
         SELECT CADCONVT
         DBSKIP()
      ENDDO
      ZAP
*   ENDIF
ENDIF
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Tecla de Cancelamento        ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Cab22(nProw,nPcol,cTexto,cMascara)
   IF Continua
      Continua := EscPrint()
      IF Continua
         IF VALTYPE(cMascara)=="U"
            @ PROW()+nProw,nPcol SAY cTexto
         ELSE
            @ PROW()+nProw,nPcol SAY cTexto PICT &cMascara
         ENDIF
      ENDIF
   ELSE
      GO BOTTOM
      DBSKIP()
   ENDIF
   RETURN NIL
