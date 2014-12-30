*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_380                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Emissao de Carteirinhas                  ณ
*ณ PROGRAMADOR    :                                          ณ
*ณ DATA CRIACAO   : 18/10/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PUBLIC continua:=.T.
SET CENTURY ON
DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf, { "MATRIC","C", 07, 0 } )
AADD(aDbf, { "CONTR" ,"C", 02, 0 } )
AADD(aDbf, { "NOME"  ,"C", 50, 0 } )
AADD(aDbf, { "SEL"   ,"C", 01, 0 } )
AADD(aDbf, { "VALIDO","D", 08, 0 } )

WHILE .T.
   sHour:=TIME()
   cArq1:="TM"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE(cArq1,aDbf); RELEASE aDbf; EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")
INDEX ON RECNO() TO (cArq1)

SELECT 3
IF NetUse("DEPEND")
   SET INDEX TO DBIDEPA1,DBIDEPA3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("CATEG")
   SET INDEX TO DBICATE1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA1,DBISOCA2
ELSE
   DelDbfNtx(); RETURN
ENDIF
DBGOBOTTOM()
DECLARE aMatr[6]
wNumFim := SOCIOS->MATRICULA
wNumInic:= "00001"
wImpress:= "L"

ProgName("GC380"); LinhaMsg(2)
Telas(15,3,20,43,1,YCOREDIT,.T.)
SET KEY -1 TO Mostra()

WHILE .T.
   (cArq1)->(__dbzap())
   SETCOLOR(YCOREDIT)
   cEscolha:=cTipo:=" "
   @ 16,04 SAY "Titular/Dependente (T/D)?:" GET cTipo PICT "!" VALID !EMPTY(cTipo).AND.cTipo$"TD"
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   IF cTipo=="T"
      @ 17,04 SAY "Faixa ou Seleo (F/S)?:" GET cEscolha PICT "!" VALID !EMPTY(cEscolha).AND.cEscolha$"FS"
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()==K_ESC; EXIT; ENDIF

      SELECT SOCIOS
      IF cEscolha=="F"
         @ 18,04 SAY "Nง Inicial:" GET wNumInic PICT "9999999" VALID !EMPTY(wNumInic)
         @ 19,04 SAY "  Nง Final:" GET wNumFim  PICT "9999999" VALID VAL(wNumFim)>=VAL(wNumInic)
         SETCURSOR(1); READ; SETCURSOR(0)
         IF LASTKEY()==K_ESC; EXIT; ENDIF

         DBSEEK(wNumInic,.T.)
         IF !EOF()
            IF TImp380().AND.ChkImpr()
               cAviso := MsgImp(.F.); nCopy:=1
               Gera_TXT("AP380.TXT"); SETPRC(0,0)
               WHILE continua.AND.MATRICULA<=wNumFim.AND.!EOF()
                  CATEG->(DBSEEK(SOCIOS->CATEGORIA))

                  wNome1:=SPACE(50)
                  
		  wNome1 := SUBS(NOME,1,50)
		  wCateg1:=RTRIM(CATEG->DESCR)
		  wMatric1:=MATRICULA
                  wNome2:=SPACE(50)
                  wCateg2:=SPACE(8)
		  wMatric2:=SPACE(7)
                  DBSKIP()

                  IF MATRICULA<=wNumFim.AND.!EOF()
                     CATEG->(DBSEEK(SOCIOS->CATEGORIA))
                     wNome2:=SPACE(50)
		     
		     wNome2 := SUBS(NOME,1,50)
                     wCateg2:=RTRIM(CATEG->DESCR)
		     wMatric2:=MATRICULA
                  ENDIF
                  
                  IF nCopy==3     
	             Cab380(8,00,"")
	          Else	   
	             Cab380(9,00,"")	  
	          ENDIF
	        	 
                  Compr_Off()
	          Cab380(1,20,wMatric1,"[@R 999.999-9]")
	          Cab380(0,60,wMatric2,"[@R 999.999-9]")

	          Cab380(3,20,wCateg1)
	          Cab380(0,60,wCateg2)

	          Cab380(0,20,wCateg1)
	          Cab380(0,60,wCateg2)
		  
                  Compr_On()
                  Cab380(3,009,wNome1)
                  Cab380(0,074,wNome2)

                  Cab380(0,009,wNome1)
                  Cab380(0,074,wNome2)
		  
                  Cab380(6,00," ")
		  
                  Compr_Off()
		  
                  IF nCopy==3
                     EJECT; EXIT
                  ENDIF
                  DBSKIP(); nCopy++

               ENDDO
               Compr_Off()
               SET DEVI TO SCREEN
               TiraMsgImp(cAviso)
               WaitMsg("Fim de Impresso! Tecle algo...")
            ENDIF
         ENDIF
      ELSE
         AFILL(aMatr,"")
         Telas(16,33,20,50,1,YCOREDIT,.T.)
         FOR i = 1 TO 6
             wMatric:=SPACE(7)
             @ 18,04 SAY "Matrกcula:" GET wMatric PICT "9999999" WHEN TeclaFuncao(.T.) VALID !EMPTY(wMatric)
             SETCURSOR(1); READ; SETCURSOR(0)
             IF LASTKEY()==K_ESC; EXIT; ENDIF
             aMatr[i]:=wMatric
             @ IF(i<=3,i+16,i+13),IF(i<=3,35,43) SAY aMatr[i]
         NEXT
         IF LASTKEY()#K_ESC.AND.TImp380().AND.ChkImpr()
            cAviso := MsgImp(.F.); nCopy:=1
            SET DEVI TO PRINT; SETPRC(0,0)
	    IMP_18()

            FOR a = 1 TO 7
               SOCIOS->(DBSEEK(aMatr[a]))
               CATEG->(DBSEEK(SOCIOS->CATEGORIA))
               wNome1:=SPACE(50)

	       wNome1 := SUBS(NOME,1,50)
               wCateg1:=RTRIM(CATEG->DESCR)
	       wMatric1:=MATRICULA

               wNome2:=SPACE(50)
               wCateg2:=SPACE(15)
	       wMatric2:=SPACE(7)
               DBSKIP()

               SOCIOS->(DBSEEK(aMatr[a+1]))
               CATEG->(DBSEEK(SOCIOS->CATEGORIA))
               wNome2:=SPACE(50)
               
	       wNome2 := SUBS(NOME,1,50)
               wCateg2:=RTRIM(CATEG->DESCR)
	       wMatric2:=MATRICULA

	       IF nCopy==1     
	          Cab380(10,00,"")
	       ENDIF
               
	       IF nCopy==2     
	          Cab380(5,00,"")
	       ENDIF

	       IF nCopy==3     
	          Cab380(5,00,"")
	       ENDIF
	        	 
               Compr_Off()
	       Cab380(1,23,wMatric1,"[@R 99999]")
	       Cab380(0,62,wMatric2,"[@R 99999]")
               
	       IF nCopy==1     
       	          Cab380(3,23,wCateg1)
	          Cab380(0,62,wCateg2)
               Else
	          Cab380(2,23,wCateg1)
	          Cab380(0,62,wCateg2)
	       ENDIF
               


	       Cab380(0,23,wCateg1)
	       Cab380(0,62,wCateg2)
		  
               Compr_On()
               Cab380(2,011,wNome1)
               Cab380(0,074,wNome2)

               Cab380(0,011,wNome1)
               Cab380(0,074,wNome2)
		  
               Cab380(6,00," ")
		  
               Compr_Off()
		  
              IF nCopy==3
                 EJECT; EXIT
              ENDIF
              a++; nCopy++
            NEXT
	    IMP_16()
            SET DEVI TO SCREEN
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impresso! Tecle algo...")
         ENDIF
         Rest_Tela()
      ENDIF
   ELSE
      WHILE .T.
         wMatric:=SPACE(7)
         @ 18,04 SAY "Matrกcula:" GET wMatric PICT "9999999" WHEN TeclaFuncao(.T.);
           VALID !EMPTY(wMatric).AND.Pesquisa(3,1,wMatric,"Sขcio nฦo possue Dependentes!")
         SETCURSOR(1); READ; SETCURSOR(0)
         TeclaFuncao()
         IF LASTKEY()==K_ESC; EXIT; ENDIF
         WHILE DEPEND->MATRICULA==wMatric
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->NOME   WITH DEPEND->NOME,;
                    (cArq1)->VALIDO WITH CalcValid(DEPEND->DTNAS),;
                    (cArq1)->MATRIC WITH wMatric,;
		    (cArq1)->CONTR WITH DEPEND->CONTR
            DEPEND->(DBSKIP())
         ENDDO
         BrowCart()
      ENDDO
   ENDIF
   SETCOLOR(YCOREDIT)
ENDDO
SET CENTURY OFF
Rest_Tela(); RELEASE continua
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse dos Dependentes         ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowCart()
   LOCAL corant:=SETCOLOR(), oBr, oCol

   SELECT (cArq1); DBGOTOP()
   LinhaMsg(16); SETCOLOR(YCOREDIT)
   Telas(6,0,22,79,1,YCOREDIT,.F.)
   oBr:=TBROWSEDB(7,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "

   oCol:=TBCOLUMNNEW("Sel.",{|| SEL})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Nome",{|| TRANSFORM(NOME,"@S40")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Validade",{|| VALIDO})
   oBr:addColumn(oCol)

   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_ENTER ) /* Selecionar */
         REPLACE (cArq1)->SEL WITH IF((cArq1)->SEL==" ","X"," ")
         (cArq1)->(dbcommit())
         oBr:refreshall()
      ELSEIF ( tecla == K_F9 ) /* Imprimir */
         IF TImp380().AND.ChkImpr()
            lImp:=.F.
            cAviso := MsgImp(.F.); nCopy:=1; (cArq1)->(DBGOTOP())
            SET DEVI TO PRINT; SETPRC(0,0)
	    IMP_18()
            FOR a = 1 TO 3
               WHILE !EOF()
                  IF (cArq1)->SEL=="X"
                     wNome1:=SPACE(50)

		     wNome1 := SUBS(NOME,1,50)
                     wCateg1:=(cArq1)->VALIDO; wMatric1:=MATRIC
                     wContr1 :=(cArq1)->contr
		     
                     wNome2:=SPACE(50)
                     wCateg2:=SPACE(8)
		     wMatric2:=SPACE(7)
		     
                     WHILE !EOF()
                        DBSKIP()
                        IF (cArq1)->SEL=="X"; EXIT; ENDIF
                     ENDDO

                     wNome2:=SPACE(50)
		     wNome2 := SUBS(NOME,1,50)
                     wCateg2:=(cArq1)->VALIDO
		     wMatric2:=MATRIC
		     wContr2 :=(cArq1)->contr

                     IF nCopy==3     
	                Cab380(8,00,"")
	             Else	   
	                Cab380(9,00,"")	  
	             ENDIF
	       
		     Compr_OFF()
                    
		     Cab380(1,20,wMatric1+"-"+wcontr1)
		     Cab380(0,60,wMatric2+"-"+wcontr2)
		    
		     Cab380(3,20,"DEPENDENTE")
		    
	             Cab380(0,58,"DEPENDENTE")
		    
		     Compr_On()
                     Cab380(3,009,wNome1)
                     Cab380(0,074,wNome2)

                     Cab380(0,009,wNome1)
                     Cab380(0,074,wNome2)
		  
                     Cab380(6,00," ")
		  
                    Compr_Off()
                    /*
		     Cab380(0,23,subs(DTOC(wCateg1),1,2))
                     Cab380(0,27,subs(DTOC(wCateg1),4,2))
                     Cab380(0,32,subs(DTOC(wCateg1),7,4))
                     

                     Cab380(0,61,subs(DTOC(wCateg2),1,2))
                     Cab380(0,65,subs(DTOC(wCateg2),4,2))
                     Cab380(0,70,subs(DTOC(wCateg2),7,4))
		     
                    */
		     IF nCopy==3
                        EJECT; lImp:=.T.; EXIT
                     ENDIF
                     nCopy++
                  ENDIF
                  DBSKIP()
               ENDDO
               IF lImp; EXIT; ENDIF
            NEXT
	    IMP_16() 
            SET DEVI TO SCREEN
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impresso! Tecle algo...")
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela()
  RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Controle Tecla ESC           ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Cab380(nProw,nPcol,cTexto,cMascara)
   IF continua .AND. (continua := EscPrint())
      IF VALTYPE( cMascara ) = "U"
         @ PROW()+nProw,nPcol SAY cTexto
      ELSE
         @ PROW()+nProw,nPcol SAY cTexto PICT &cMascara.
      ENDIF
   ELSE
      DBGOBOTTOM()
      DBSKIP()
   ENDIF
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Impressao Etiqueta    ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TImp380()
   IF Confirma("Faz teste de Impresso ?").AND.ChkImpr()
      cAviso := MsgImp(.F.)
      SET DEVI TO PRINT
      WHILE .T.
         Cab380(6,00,"")
         Compr_OFF()
         Cab380(1,020,REPL("*",7))
         Cab380(0,060,REPL("*",7))
         Cab380(2,020,REPL("*",8))
         Cab380(0,060,REPL("*",8))
         Compr_ON()
         Cab380(3,008,REPL("*",50))
         Cab380(0,073,REPL("N",50))
         Cab380(4,00,"")
         Fim_TXT()
         SAVESCREEN(0,0,24,79)
         RUN nodosimp ap380.txt 80 pre
         RESTSCREEN(0,0,24,79,0)
         DELETE FILE AP380.TXT

         TiraMsgImp(cAviso)
         IF !Confirma("Continua o Teste ?"); EXIT; ENDIF
         cAviso := MsgImp(.F.)
         Gera_TXT("AP380.TXT")
      ENDDO
      Compr_Off()
      Fim_TXT()
      SAVESCREEN(0,0,24,79)
      RUN nodosimp ap380.txt 80 pre
      RESTSCREEN(0,0,24,79,0)
      DELETE FILE AP380.TXT

      TiraMsgImp(cAviso)
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Calcular Validade da Carteiraณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION CalcValid(pNasc)
   LOCAL pValid:=CTOD("")
   IF SUBS(DEPEND->GRAU,1,3)=="FIL" .OR. SUBS(DEPEND->GRAU,1,3)=="ENT"
      pValid:= CTOD(SUBS(DTOC(pNasc),1,6)+LTRIM(STR(YEAR(pNasc)+21)))
   ENDIF
   RETURN(pValid)


STATIC FUNC Imp_18()      /* Impressao 1/8 POL */
   SET CONSOLE OFF
   SET PRINTER ON
   ?? CHR(27)+"0"
   SET PRINTER OFF
   SET CONSOLE ON

STATIC FUNC Imp_16()      /* Impressao 1/8 POL */
   SET CONSOLE OFF
   SET PRINTER ON
   ?? CHR(27)+"1"
   SET PRINTER OFF
   SET CONSOLE ON
