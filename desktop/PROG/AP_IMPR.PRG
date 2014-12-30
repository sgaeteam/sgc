*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : GP_IMPR                          vrs 003 ณ
*ณ VRS 003        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Configurar Impressoras                   ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE (IT)                ณ
*ณ DATA CRIACAO   : 04/01/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
#include "COMMAND.CH"

FUNCTION ConfigImpr(arq,prg,t,l,b,r,moldura)
   DEFAULT t       TO 8
   DEFAULT l       TO 28
   DEFAULT b       TO 15
   DEFAULT r       TO 47
   DEFAULT moldura TO 1

   aPrint := { {"Epson LX/FX/LQ","CHR(14)","CHR(20)","CHR(15)","CHR(18)","CHR(15)+CHR(14)"},;
               {"Rima Padro","CHR(27)+'W'+CHR(1)","CHR(27)+'W'+CHR(0)","CHR(15)","CHR(18)","CHR(15)+CHR(14)"},;
               {"Rima Itautec","CHR(14)","CHR(20)","CHR(30)+CHR(52)","CHR(18)","CHR(30)+'O'"},;
               {"Elgin","CHR(27)+'[Ow'","CHR(27)+'[3w'","CHR(27)+'[7w'","CHR(27)+'[3w'","CHR(27)+'[7w'+CHR(27)+'[Ow'"},;
               {"Laser/JT","CHR(27)+CHR(40)+CHR(115)+CHR(35)+CHR(54)", "CHR(27)+CHR(38)+CHR(107)+CHR(48)+CHR(83)","CHR(27)+CHR(38)+CHR(107)+CHR(50)+CHR(83)","CHR(27)+CHR(38)+CHR(107)+CHR(48)+CHR(83)","CHR(27)+CHR(40)+CHR(115)+CHR(35)+CHR(54)" } }

   USE (arq) NEW
   IF prg # NIL
      ProgName(prg)
   ENDIF
   
   Telas(t,l,b,r,moldura,YCORMENU,.T.)
   WHILE .T.
      SETCURSOR(0)
      SETCOLOR(YCORMENU)
      @ t+1,l+1 PROMPT "   Epson          " MESSAGE Msg("Padr”es: LX, FX e LQ")
      @ t+2,l+1 PROMPT "   Rima Padro    " MESSAGE Msg("Okidata, XT180, XT250 ,XT300...")
      @ t+3,l+1 PROMPT "   Rima Itautec   " MESSAGE Msg("XT180, ML391...")
      @ t+4,l+1 PROMPT "   Elgin          " MESSAGE Msg("Amlia 250, EEnnn, Lady 90...")
      @ t+5,l+1 PROMPT "   Laser/JT       " MESSAGE Msg("Laser")
      @ t+6,l+1 PROMPT "   Outras         " MESSAGE Msg("Lasers, Jato de Tinta, LED ou Fuso Trmica (fabricantes diversos)")
      MENU TO nMenu_56

      IF nMenu_56 = 0
         Rest_Tela()
         DBCLOSEALL()
         RETURN
      ENDIF

      IF nMenu_56 > 0 .AND. nMenu_56 < 6
         Grv_Imp(nMenu_56)
      ELSEIF nMenu_56 = 6
         tela := SAVESCREEN(2,0,24,79)
         Area_Dados()
         Quadro(8,10,17,65,1,YCOREDIT,.T.,"Impressora do Usu rio",.T.)
         SETCOLOR(YCOREDIT)
         Atrib_Var()

         SETCURSOR(1)
         @ 09,12 SAY "Consulte o manual do fabricante e informe:"
         @ 11,12 SAY "Impressora.........: "GET wImpressora VALID !EMPTY(wImpressora)
         @ 12,12 SAY "Ativa Expandido....: "GET wExpandOn   PICT "@S25"
         @ 13,12 SAY "Desativa Expandido.: "GET wExpandOff  PICT "@S25"
         @ 14,12 SAY "Ativa Condensado...: "GET wCompr_On   PICT "@S25"
         @ 15,12 SAY "Desativa Condensado: "GET wCompr_Off  PICT "@S25"
         @ 16,12 SAY "Impr.Meio Expandida: "GET wExpand_Med PICT "@S25"
         READ
         SETCURSOR(0)

         IF LASTKEY() # 27
            IF NetLReg()
               REPLACE _FIELD->IMPRESSORA WITH wImpressora,;
                       _FIELD->EXPANDON   WITH wExpandOn  ,;
                       _FIELD->EXPANDOFF  WITH wExpandOff ,;
                       _FIELD->COMPR_ON   WITH wCompr_On  ,;
                       _FIELD->COMPR_OFF  WITH wCompr_Off ,;
                       _FIELD->EXPAND_MED WITH wExpand_Med
               ProcOk("Configurado")
            ENDIF
         ENDIF
         RESTSCREEN(2,0,24,79,tela)
      ENDIF
   ENDDO
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Gravao da Configurao     ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE Grv_Imp(vetor)
   IF NetLReg()
      REPLACE _FIELD->IMPRESSORA WITH aPrint[vetor,1],;
              _FIELD->EXPANDON   WITH aPrint[vetor,2],;
              _FIELD->EXPANDOFF  WITH aPrint[vetor,3],;
              _FIELD->COMPR_ON   WITH aPrint[vetor,4],;
              _FIELD->COMPR_OFF  WITH aPrint[vetor,5],;
              _FIELD->EXPAND_MED WITH aPrint[vetor,6]
      Atrib_Var()
      ProcOk("Configurado")
   ENDIF
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Atribuio das Vari veis     ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE Atrib_Var()
  wImpressora := _FIELD->IMPRESSORA
  wExpandOn   := _FIELD->EXPANDON
  wExpandOff  := _FIELD->EXPANDOFF
  wCompr_On   := _FIELD->COMPR_ON
  wCompr_Off  := _FIELD->COMPR_OFF
  wExpand_Med := _FIELD->EXPAND_MED
  RETURN
