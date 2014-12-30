*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AP_380                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Emissao de Carteirinhas                  ณ
*ณ PROGRAMADOR    : VITOR FREIRE         - NETCOM            ณ
*ณ DATA CRIACAO   : 18/10/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PUBLIC continua:=.T.
SET CENTURY ON
DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf, { "MATRIC","C", 05, 0 } )
AADD(aDbf, { "RESP"  ,"C", 50, 0 } )
AADD(aDbf, { "NOME"  ,"C", 50, 0 } )
AADD(aDbf, { "GRAU"  ,"C", 11, 0 } )
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
INDEX ON nome TO (cArq1)

SELECT 4
IF NetUse("PGSOC")
   SET INDEX TO DBIPGSO1
ELSE
   DelDbfNtx(); RETURN
ENDIF

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
   SET INDEX TO DBISOCA1,DBISOCA2,DBISOCA4
ELSE
   DelDbfNtx(); RETURN
ENDIF
DBGOBOTTOM()
DECLARE aMatr[6],aResp[6],aMatr2[6]
wNumFim := SOCIOS->MATRICULA
wNumInic:= "00001"

ProgName("GC380"); LinhaMsg(2)
Telas(15,3,20,43,1,YCOREDIT,.T.)
SET KEY -1 TO Mostra()
WHILE .T.
   (cArq1)->(__dbzap())
   SETCOLOR(YCOREDIT)
   cEscolha:=cClass:=" "
   @ 16,04 SAY "Classificao:" GET cClass PICT "!" WHEN HTela(7) VALID VTela(7)
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF

   IF cClass=="A"    /* Socio A */
      @ 17,04 SAY "Faixa ou Seleo (F/S)?:" GET cEscolha PICT "!" VALID !EMPTY(cEscolha).AND.cEscolha$"FS"
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()==K_ESC; EXIT; ENDIF

      SELECT SOCIOS
      IF cEscolha=="F"
         @ 18,04 SAY "Nง Inicial:" GET wNumInic PICT "99999" VALID !EMPTY(wNumInic)
         @ 19,04 SAY "  Nง Final:" GET wNumFim  PICT "99999" VALID VAL(wNumFim)>=VAL(wNumInic)
         SETCURSOR(1); READ; SETCURSOR(0)
         IF LASTKEY()==K_ESC; EXIT; ENDIF

         DBSEEK(wNumInic,.T.)
         IF !EOF()
            IF TImp380().AND.ChkImpr()
               cAviso := MsgImp(.F.); nCopy:=1
               SET DEVI TO PRINT; SETPRC(0,0)
               WHILE continua.AND.MATRICULA<=wNumFim.AND.!EOF()
                  IF SOCIOS->CATEGORIA=="01".OR.SOCIOS->CATEGORIA=="03"
                     wNome1 := SUBS(SOCIOS->NOME,1,AT(" ",SOCIOS->NOME)-1)
                     wNome1a:=wNome2a:=""
                     FOR b= 1 TO 20
                         wNome1a := RIGHT(RTRIM(SOCIOS->NOME),b)
                         IF " " $ RIGHT(RTRIM(SOCIOS->NOME),b)
                            EXIT
                         ENDIF
                     NEXT
                     wMatric1:=SOCIOS->MATRICULA

                     WHILE continua.AND.MATRICULA<=wNumFim.AND.!EOF()
                        SOCIOS->(DBSKIP())
                        IF SOCIOS->CATEGORIA=="01".OR.SOCIOS->CATEGORIA=="03"
                           wNome2 := SUBS(SOCIOS->NOME,1,AT(" ",SOCIOS->NOME)-1)
                           FOR b= 1 TO 20
                               wNome2a := RIGHT(RTRIM(SOCIOS->NOME),b)
                               IF " " $ RIGHT(RTRIM(SOCIOS->NOME),b)
                                  EXIT
                               ENDIF
                           NEXT
                           wMatric2:=SOCIOS->MATRICULA
                           EXIT
                        ENDIF
                     ENDDO
                     Cab380(4,00,"")
                     Cab380(1,18,wNome1+wNome1a)
                     Cab380(0,54,wNome2+wNome2a)
                     Cab380(2,19,wMatric1)
                     Cab380(0,28,SUBS(DTOC(DATE()),1,2)+"/"+SUBS(DTOC(DATE()),4,2)+"/"+SUBS(DTOC(DATE()),9,2))
                     Cab380(0,55,wMatric2)
                     Cab380(0,64,SUBS(DTOC(DATE()),1,2)+"/"+SUBS(DTOC(DATE()),4,2)+"/"+SUBS(DTOC(DATE()),9,2))
                     Cab380(11,00,"")
                  ENDIF
                  SOCIOS->(DBSKIP())
               ENDDO
               SET DEVI TO SCREEN
               TiraMsgImp(cAviso)
               WaitMsg("Fim de Impresso! Tecle algo...")
            ENDIF
         ENDIF
      ELSE
         AFILL(aMatr,"")
         Telas(16,33,20,50,1,YCOREDIT,.T.)
         FOR i = 1 TO 6
             wMatric:=SPACE(5)
             @ 18,04 SAY "Matrกcula:" GET wMatric PICT "99999" WHEN TeclaFuncao(.T.);
               VALID !EMPTY(wMatric).AND.Pesquisa(1,1,wMatric,"Sขcio No Cadastrado")
             SETCURSOR(1); READ; SETCURSOR(0)
             IF LASTKEY()==K_ESC; EXIT; ENDIF
             IF SOCIOS->CATEGORIA=="01".OR.SOCIOS->CATEGORIA=="03"
                aMatr[i]:=wMatric
                @ IF(i<=3,i+16,i+13),IF(i<=3,35,43) SAY aMatr[i]
             ELSE
                Aviso("Sขcio No pertence a categoria A !",,3)
                i--
             ENDIF
         NEXT
         IF LASTKEY()#K_ESC.AND.TImp380().AND.ChkImpr()
            cAviso := MsgImp(.F.); nCopy:=1
            SET DEVI TO PRINT; SETPRC(0,0)
            FOR a = 1 TO 6
               SOCIOS->(DBSEEK(aMatr[a]))
               wNome1 := SUBS(SOCIOS->NOME,1,AT(" ",SOCIOS->NOME)-1)
               wNome1a:=wNome2a:=""
               FOR b= 1 TO 20
                   wNome1a := RIGHT(RTRIM(SOCIOS->NOME),b)
                   IF " " $ RIGHT(RTRIM(SOCIOS->NOME),b)
                      EXIT
                   ENDIF
               NEXT
               wMatric1:=SOCIOS->MATRICULA

               SOCIOS->(DBSEEK(aMatr[a+1]))
               wNome2 := SUBS(SOCIOS->NOME,1,AT(" ",SOCIOS->NOME)-1)
               FOR b= 1 TO 20
                   wNome2a := RIGHT(RTRIM(SOCIOS->NOME),b)
                   IF " " $ RIGHT(RTRIM(SOCIOS->NOME),b)
                      EXIT
                   ENDIF
               NEXT
               wMatric2:=SOCIOS->MATRICULA
               Cab380(4,00,"")
               Cab380(1,18,wNome1+wNome1a)
               Cab380(0,54,wNome2+wNome2a)
               Cab380(2,19,aMatr[a])
               Cab380(0,28,SUBS(DTOC(DATE()),1,2)+"/"+SUBS(DTOC(DATE()),4,2)+"/"+SUBS(DTOC(DATE()),9,2))
               Cab380(0,55,aMatr[a+1])
               Cab380(0,64,SUBS(DTOC(DATE()),1,2)+"/"+SUBS(DTOC(DATE()),4,2)+"/"+SUBS(DTOC(DATE()),9,2))
               Cab380(11,00,"")
               a++
            NEXT
            EJECT
            SET DEVI TO SCREEN
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impresso! Tecle algo...")
         ENDIF
         Rest_Tela()
      ENDIF
   ELSEIF cClass=="B"   /* Socio B */
      @ 17,04 SAY "Faixa ou Seleo (F/S)?:" GET cEscolha PICT "!" VALID !EMPTY(cEscolha).AND.cEscolha$"FS"
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()==K_ESC; EXIT; ENDIF

      SELECT SOCIOS
      IF cEscolha=="F"
         @ 18,04 SAY "Nง Inicial:" GET wNumInic PICT "99999" VALID !EMPTY(wNumInic)
         @ 19,04 SAY "  Nง Final:" GET wNumFim  PICT "99999" VALID VAL(wNumFim)>=VAL(wNumInic)
         SETCURSOR(1); READ; SETCURSOR(0)
         IF LASTKEY()==K_ESC; EXIT; ENDIF

         DBSEEK(wNumInic,.T.)
         IF !EOF()
            IF TImp380().AND.ChkImpr()
               cAviso := MsgImp(.F.); nCopy:=1
               SET DEVI TO PRINT; SETPRC(0,0)
               WHILE continua.AND.SOCIOS->MATRICULA<=wNumFim.AND.!EOF()
                  IF SOCIOS->CATEGORIA=="02".AND.ChkDeb(SOCIOS->MATRICULA,.F.)
                     wNome1 := SUBS(SOCIOS->NOME,1,AT(" ",SOCIOS->NOME)-1)
                     wNome1a:=wNome2a:=""
                     FOR b= 1 TO 20
                         wNome1a := RIGHT(RTRIM(SOCIOS->NOME),b)
                         IF " " $ RIGHT(RTRIM(SOCIOS->NOME),b)
                            EXIT
                         ENDIF
                     NEXT
                     wMatric1:=SOCIOS->MATRICULA

                     WHILE continua.AND.MATRICULA<=wNumFim.AND.!EOF()
                        SOCIOS->(DBSKIP())
                        IF SOCIOS->CATEGORIA=="02".AND.ChkDeb(SOCIOS->MATRICULA,.F.)
                           wNome2 := SUBS(SOCIOS->NOME,1,AT(" ",SOCIOS->NOME)-1)
                           FOR b= 1 TO 20
                               wNome2a := RIGHT(RTRIM(SOCIOS->NOME),b)
                               IF " " $ RIGHT(RTRIM(SOCIOS->NOME),b)
                                  EXIT
                               ENDIF
                           NEXT
                           wMatric2:=SOCIOS->MATRICULA
                           EXIT
                        ENDIF
                     ENDDO
                     Cab380(4,00,"")
                     Cab380(1,18,wNome1+wNome1a)
                     Cab380(0,54,wNome2+wNome2a)
                     Cab380(2,19,wMatric1)
                     Cab380(0,28,SUBS(DTOC(DATE()),1,2)+"/"+SUBS(DTOC(DATE()),4,2)+"/"+SUBS(DTOC(DATE()),9,2))
                     Cab380(0,55,wMatric2)
                     Cab380(0,64,SUBS(DTOC(DATE()),1,2)+"/"+SUBS(DTOC(DATE()),4,2)+"/"+SUBS(DTOC(DATE()),9,2))
                     Cab380(11,00,"")
                  ENDIF
                  SOCIOS->(DBSKIP())
               ENDDO
               SET DEVI TO SCREEN
               TiraMsgImp(cAviso)
               WaitMsg("Fim de Impresso! Tecle algo...")
            ENDIF
         ENDIF
      ELSE
         AFILL(aMatr,""); AFILL(aMatr2,""); AFILL(aResp,"")
         Telas(16,33,20,50,1,YCOREDIT,.T.)
         FOR i = 1 TO 6
             wMatric:=SPACE(5)
             @ 18,04 SAY "Matrกcula:" GET wMatric PICT "99999" WHEN TeclaFuncao(.T.);
               VALID !EMPTY(wMatric).AND.Pesquisa(1,1,wMatric,"Sขcio No Cadastrado")
             SETCURSOR(1); READ; SETCURSOR(0)
             IF LASTKEY()==K_ESC; EXIT; ENDIF
             IF SOCIOS->CATEGORIA=="02".OR.SOCIOS->CATEGORIA=="07"
                /* Checar se socio esta em debito */
                IF SOCIOS->CATEGORIA=="02"
                   IF ChkDeb(wMatric,.T.)
                      aMatr[i] :=wMatric
                      aMatr2[i]:=wMatric
                      @ IF(i<=3,i+16,i+13),IF(i<=3,35,43) SAY aMatr[i]
                   ELSE
                      i--
                   ENDIF
                ELSE
                   aMatr2[i]:=SOCIOS->MATR2
                   SOCIOS->(DBSETORDER(3))
                   SOCIOS->(DBSEEK(aMatr2[i]))
                   aResp[i] :=SOCIOS->NOME
                   aMatr[i] :=wMatric
                   SOCIOS->(DBSETORDER(1))
                   @ IF(i<=3,i+16,i+13),IF(i<=3,35,43) SAY aMatr[i]
                ENDIF
             ELSE
                Aviso("Sขcio No pertence a categoria B ou Afim!",,3)
                i--
             ENDIF
         NEXT
         IF LASTKEY()#K_ESC.AND.TImp380().AND.ChkImpr()
            cAviso := MsgImp(.F.)
            SET DEVI TO PRINT; SETPRC(0,0)
            FOR a = 1 TO 6
               SOCIOS->(DBSEEK(aMatr[a]))
               wNome1 := SUBS(SOCIOS->NOME,1,AT(" ",SOCIOS->NOME)-1)
               wNome1a:=wNome2a:=""
               FOR b= 1 TO 20
                   wNome1a := RIGHT(RTRIM(SOCIOS->NOME),b)
                   IF " " $ RIGHT(RTRIM(SOCIOS->NOME),b)
                      EXIT
                   ENDIF
               NEXT
               wMatric1:=SOCIOS->MATRICULA

               SOCIOS->(DBSEEK(aMatr[a+1]))
               wNome2 := SUBS(SOCIOS->NOME,1,AT(" ",SOCIOS->NOME)-1)
               FOR b= 1 TO 20
                   wNome2a := RIGHT(RTRIM(SOCIOS->NOME),b)
                   IF " " $ RIGHT(RTRIM(SOCIOS->NOME),b)
                      EXIT
                   ENDIF
               NEXT
               wMatric2:=SOCIOS->MATRICULA
               Cab380(4,00,"")
               Cab380(1,18,wNome1+wNome1a)
               Cab380(0,54,wNome2+wNome2a)
               Cab380(2,19,aMatr[a])
               Cab380(0,28,SUBS(DTOC(DATE()),1,2)+"/"+SUBS(DTOC(DATE()),4,2)+"/"+SUBS(DTOC(DATE()),9,2))
               Cab380(0,55,aMatr[a+1])
               Cab380(0,64,SUBS(DTOC(DATE()),1,2)+"/"+SUBS(DTOC(DATE()),4,2)+"/"+SUBS(DTOC(DATE()),9,2))
               Cab380(11,00,"")
               a++
            NEXT
            EJECT

            /* Fundo */
            SET DEVI TO SCREEN
            TiraMsgImp(cAviso)
            Aviso("Insira o lado inverso do papel e tecle ENTER...")
            IF ChkImpr()
               FOR a = 1 TO 6
                  wNome1 := SUBS(aResp[a],1,AT(" ",aResp[a])-1)
                  wNome1a:=wNome2a:=""
                  FOR b= 1 TO 20
                      wNome1a := RIGHT(RTRIM(aResp[a]),b)
                      IF " " $ RIGHT(RTRIM(aResp[a]),b)
                         EXIT
                      ENDIF
                  NEXT
                  wNome2 := SUBS(aResp[a+1],1,AT(" ",aResp[a+1])-1)
                  FOR b= 1 TO 20
                      wNome2a := RIGHT(RTRIM(aResp[a+1]),b)
                      IF " " $ RIGHT(RTRIM(aResp[a+1]),b)
                         EXIT
                      ENDIF
                  NEXT

                  Cab380(1,00,"")
                  Cab380(1,10,wNome2+wNome2a)
                  Cab380(0,48,wNome1+wNome1a)
                  Cab380(3,10,aMatr2[a+1])
                  Cab380(0,48,aMatr2[a])
                  Cab380(13,00,"")
                  a++
               NEXT
            ENDIF
            EJECT
            SET DEVI TO SCREEN
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impresso! Tecle algo...")
         ENDIF
         Rest_Tela()
      ENDIF
   ELSEIF cClass=="C"   /* Familia e Menor */
      WHILE .T.
         wMatric:=SPACE(5)
         @ 18,04 SAY "Matrกcula:" GET wMatric PICT "99999" WHEN TeclaFuncao(.T.);
           VALID !EMPTY(wMatric).AND.Pesquisa(3,1,wMatric,"Sขcio no possue Dependentes!")
         SETCURSOR(1); READ; SETCURSOR(0)
         TeclaFuncao()
         IF LASTKEY()==K_ESC; EXIT; ENDIF
         SOCIOS->(DBSEEK(wMatric))
         WHILE DEPEND->MATRICULA==wMatric
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->RESP   WITH SOCIOS->NOME,;
                    (cArq1)->NOME   WITH DEPEND->NOME,;
                    (cArq1)->VALIDO WITH CalcValid(DEPEND->DTNAS),;
                    (cArq1)->MATRIC WITH wMatric,;
                    (cArq1)->GRAU   WITH DEPEND->GRAU
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
   oCol:=TBCOLUMNNEW("Respons vel",{|| TRANSFORM(RESP,"@S40")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Parentesco",{|| GRAU})
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
            /* Frente */
            FOR a = 1 TO 3
               WHILE !(cArq1)->(EOF())
                  IF (cArq1)->SEL=="X"
                     i:=1; wNome1a:=" "
                     WHILE .T.
                        IF .NOT. " " $ RIGHT(RTRIM((cArq1)->NOME),i)
                           wNome1a := RIGHT(RTRIM((cArq1)->NOME),i)
                        ELSE
                           EXIT
                        ENDIF
                        i++
                     ENDDO
                     wNome1 := LEFT((cArq1)->NOME,AT(" ",(cArq1)->NOME))+wNome1a
                     wCateg1:=(cArq1)->VALIDO; wMatric1:=(cArq1)->MATRIC

                     wNome2:=SPACE(20); wNome2a:=SPACE(30)
                     wCateg2:=SPACE(8); wMatric2:=SPACE(5)
                     WHILE !EOF()
                        (cArq1)->(DBSKIP())
                        IF (cArq1)->SEL=="X"; EXIT; ENDIF
                     ENDDO
                     
                     i:=1; wNome2a:=" "
                     WHILE .T.
                        IF .NOT. " " $ RIGHT(RTRIM((cArq1)->NOME),i)
                           wNome2a := RIGHT(RTRIM((cArq1)->NOME),i)
                        ELSE
                           EXIT
                        ENDIF
                        i++
                     ENDDO
                     wNome2 := LEFT((cArq1)->NOME,AT(" ",(cArq1)->NOME))+wNome2a
                     wCateg2:=(cArq1)->VALIDO; wMatric2:=(cArq1)->MATRIC

                     Cab380(4,00,"")
                     Cab380(1,18,wNome1)
                     Cab380(0,54,wNome2)
                     Cab380(2,19,wMatric1)
                     IF EMPTY(wCateg1)
                        *Cab380(0,28,SUBS(DTOC(DATE()),4,2)+"/"+SUBS(DTOC(DATE()),7,4))
                     ELSE
                        Cab380(0,28,SUBS(DTOC(wCateg1),4,2)+"/"+SUBS(DTOC(wCateg1),7,4))
                     ENDIF
                     Cab380(0,55,wMatric2)
                     IF EMPTY(wCateg2)
                        *Cab380(0,64,SUBS(DTOC(DATE()),1,2)+"/"+SUBS(DTOC(DATE()),4,2)+"/"+SUBS(DTOC(DATE()),7,4))
                     ELSE
                        Cab380(0,64,SUBS(DTOC(wCateg2),4,2)+"/"+SUBS(DTOC(wCateg2),7,4))
                     ENDIF
                     Cab380(11,00,"")
                     IF nCopy==3
                        lImp:=.T.; EJECT; EXIT
                     ENDIF
                     nCopy++
                  ENDIF
                  (cArq1)->(DBSKIP())
               ENDDO
               IF lImp; EXIT; ENDIF
            NEXT

            SET DEVI TO SCREEN
            TiraMsgImp(cAviso)
            Aviso("Insira o lado inverso do papel e tecle ENTER...")
            IF ChkImpr()
               lImp:=.F.
               cAviso := MsgImp(.F.); nCopy:=1; (cArq1)->(DBGOTOP())
               SET DEVI TO PRINT; SETPRC(0,0)

               /* Fundo */
               FOR f = 1 TO 3
                  WHILE !(cArq1)->(EOF())
                     IF (cArq1)->SEL=="X"
                        i:=1; wNome1a:=" "
                        WHILE .T.
                           IF .NOT. " " $ RIGHT(RTRIM((cArq1)->RESP),i)
                              wNome1a := RIGHT(RTRIM((cArq1)->RESP),i)
                           ELSE
                              EXIT
                           ENDIF
                           i++
                        ENDDO
                        wNome1 := LEFT((cArq1)->RESP,AT(" ",(cArq1)->RESP))+wNome1a
                        wGrau1 := (cArq1)->GRAU

                        WHILE !EOF()
                           (cArq1)->(DBSKIP())
                           IF (cArq1)->SEL=="X"; EXIT; ENDIF
                        ENDDO

                        i:=1; wNome2a:=" "
                        WHILE .T.
                           IF .NOT. " " $ RIGHT(RTRIM((cArq1)->RESP),i)
                              wNome2a := RIGHT(RTRIM((cArq1)->RESP),i)
                           ELSE
                              EXIT
                           ENDIF
                           i++
                        ENDDO
                        wNome2 := LEFT((cArq1)->RESP,AT(" ",(cArq1)->RESP))+wNome2a
                        wGrau2 := (cArq1)->GRAU

                        Cab380(1,00,"")
                        Cab380(1,10,wNome2)
                        Cab380(0,48,wNome1)
                        Cab380(3,10,wGrau2)
                        Cab380(0,48,wGrau1)
                        Cab380(13,00,"")
                        IF nCopy==3
                           lImp:=.T.; EJECT; EXIT
                        ENDIF
                        nCopy++
                     ENDIF
                     (cArq1)->(DBSKIP())
                  ENDDO
                  IF lImp; EJECT; EXIT; ENDIF
               NEXT
            ENDIF
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
      SET DEVI TO PRINT; SETPRC(0,0)
      WHILE .T.
         Cab380(4,00,"")
         Cab380(1,18,REPL("*",26))
         Cab380(0,54,REPL("*",26))
         Cab380(2,19,REPL("*",05))
         Cab380(0,28,REPL("*",11))
         Cab380(0,55,REPL("*",05))
         Cab380(0,64,REPL("*",11))
         Cab380(11,00,"")
         SET DEVICE TO SCREEN
         TiraMsgImp(cAviso)
         IF !Confirma("Continua o Teste ?"); EXIT; ENDIF
         cAviso := MsgImp(.F.)
         SET DEVICE TO PRINT
      ENDDO
      SET DEVICE TO SCREEN
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
*ีออออออออออออออออออออออออออออออธ
*ณ Checar Debito do Socio       ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION ChkDeb(pMatr,pMsg)
   IF !PGSOC->(DBSEEK(pMatr+SUBS(DTOC(DATE()),9,2)+SUBS(DTOC(DATE()),4,2)))
      IF pMsg; Aviso("Sขcio em Dbito...",,3); ENDIF
      RETURN .F.
   ENDIF
   RETURN .T.
