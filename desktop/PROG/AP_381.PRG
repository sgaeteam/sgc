*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_381                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Emissao de Codigos de Barras             ณ
*ณ PROGRAMADOR    : ณ DATA CRIACAO   : 28/10/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol
DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf, { "MATRIC","C", 07, 0 } )
AADD(aDbf, { "NOME"  ,"C", 50, 0 } )
WHILE .T.
   sHour:=TIME()
   cArq1:="TM"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE(cArq1,aDbf); RELEASE aDbf; EXIT
   ENDIF
ENDDO

SELECT 10
NetUse(cArq1,,"E")
INDEX ON nome TO (cArq1)

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA1
ELSE
   DelDbfNtx(); RETURN
ENDIF

wImpress:= "M"
wItautec:="824985030"

ProgName("GC381"); LinhaMsg(2)
LinhaMsg(17); SETCOLOR(YCOREDIT)
SELECT (cArq1)
Telas(4,0,22,79,1,YCOREDIT,.F.)
oBr:=TBROWSEDB(5,1,21,78)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "

oCol:=TBCOLUMNNEW("Nome",{|| TRANSFORM(NOME,"@S40")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Matricula",{|| MATRIC})
oBr:addColumn(oCol)

WHILE .T.
   WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
   tecla := INKEY()
   IF ( tecla == K_ESC )
      EXIT
   ELSEIF ( tecla == K_ENTER ) /* Incluir */
      Telas(16,0,18,19,1,YCOREDIT,.F.); wMatr:=SPACE(7)
      WHILE .T.
         @ 17,01 SAY "Matricula:" GET wMatr PICT "@K 9999999" VALID Pesquisa(1,1,wMatr,"Sขcio no Cadastrado")
         SETCURSOR(1); READ; SETCURSOR(0)
         IF LASTKEY()==K_ESC; EXIT; ENDIF
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->MATRIC WITH wMatr,;
                 (cArq1)->NOME   WITH SOCIOS->NOME
         ProcOk("Incluido")
      ENDDO
      Rest_Tela()
      oBr:refreshall()
   ELSEIF ( tecla == K_DEL ) /* Excluir */
      (cArq1)->(DBDELETE())
      oBr:refreshall()
   ELSEIF ( tecla == K_F9 ) /* Imprimir */
      (cArq1)->(DBGOTOP())
      IF !(cArq1)->(EOF())
         Telas(16,0,18,19,1,YCOREDIT,.F.)
         @ 17,01 SAY "Impressora:" GET wImpress PICT "!" WHEN HTela(6) VALID VTela(6)
         SETCURSOR(1); READ; SETCURSOR(0)
         IF LASTKEY()==K_ESC
            IF LEN(Telas)==3
               Rest_Tela()
            ELSEIF LEN(Telas)==5
               Rest_Tela(); Rest_Tela()
            ENDIF
         ELSE
            Rest_Tela()
            IF ChkImpr()
              * (cArq1)->(DBCLEARINDEX())
               lImp:=.F.
               cAviso := MsgImp(.F.); nCopy:=1; (cArq1)->(DBGOTOP())
               Gera_TXT("AP381.TXT"); SETPRC(0,0)
               TWINIC()
               IF wImpress=="L"
                  TWDEFPRINT(2) && LASER
               ELSEIF wImpress=="M"
                  TWDEFPRINT(1) && MATRICIAL
               ENDIF
               TWDEFCODE(TWC25)
               TWDEFLBARS(2,6)
               IF wImpress=="L"
                  TWDEFALT(54)
                  TWDEFSALTO(54)
               ELSE
                  TWDEFALT(4)    && ESPESSURA (QUANTO MENOR MAIS ESTREITA)
                  TWDEFSALTO(4)  && ESPESSURA DEVEMOS UTILIZAR OS DOIS COM A MESMA
               ENDIF
               @ PROW()+3,0 SAY ''
               nContAux := 1
               nCol:=4

               lPrimVez:=.T.

               WHILE !EOF()
                  lMat2:=lMat3:=lMat4:=.F.
                  wMatr1:=MATRIC
                  DBSKIP()
                  IF !EOF()
                     wMatr2:=MATRIC
                     lMat2:=.T.
                     DBSKIP()
                     IF !EOF()
                        wMatr3:=MATRIC
                        lMat3:=.T.
                     ENDIF
                     DBSKIP()
                     IF !EOF()
                        wMatr4:=MATRIC
                        lMat4:=.T.
                     ENDIF
                  ENDIF

                  nContador:=1

                  IF wImpress=="L".AND.lPrimVez
		     @ PROW()+2,0 SAY ''
		     lPrimVez:=.F.
		  ENDIF

                  WHILE nContador <= IF(wImpress=="M",5,2)
                     nContador++

		     @ PROW(),5 SAY ''
		     	
		     TWIMPCOD(wMatr1) && IMPRIME O CODIGO ATRIBUIDO A VARIAVEL ->CODBAR
                  
		     IF lMat2
                        @ PROW(),23 SAY ''
                        TWIMPCOD(wMatr2)
                        IF lMat3
                           @ PROW(),43 SAY ''
                           TWIMPCOD(wMatr3)
                           IF lMat4
                              @ PROW(),61 SAY ''
                              TWIMPCOD(wMatr4)
                           ENDIF
                        ENDIF
                     ENDIF
                     @ PROW()+1,0 SAY ''
                  ENDDO

                  IF wImpress=="M"
                     Compr_On()
                     @ PROW(),16 SAY wMatr1
                     IF lMat2
                        @ PROW(),IF(wImpress=="M",46,22) SAY wMatr2
                        IF lMat3
                           @ PROW(),IF(wImpress=="M",79,44) SAY wMatr3
                           IF lMat4
                              @ PROW(),IF(wImpress=="M",115,64) SAY wMatr4
                           ENDIF
                        ENDIF
                     ENDIF
                     @ PROW()+3,5 SAY ''
                     Compr_Off()
                  ELSE
                     @ PROW()+2,4 SAY ''
                  ENDIF
                  DBSKIP()
               ENDDO
               TWDEFSALTO(12) && define um salto padrao para encerramento
               Fim_TXT()
               SAVESCREEN(0,0,24,79)
               RUN nodosimp ap381.txt 80 pre
               RESTSCREEN(0,0,24,79,0)
               DELETE FILE AP381.TXT

               TiraMsgImp(cAviso)
               WaitMsg("Fim de Impresso! Tecle algo...")
               INDEX ON nome TO (cArq1)
            ENDIF
         ENDIF
      ELSE
         Aviso("No h  sขcios selecionados...",,3)
      ENDIF
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela()
DelDbfNtx(); RETURN
