*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : GP_CALC                          vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Ativar Calculadora Retornando Resultado  ณ
*ณ                  para GET pendente.                       ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE (IT)                ณ
*ณ DATA CRIACAO   : 03/02/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
#include "COMMAND.CH"

* Adicionar estas linhas no programa principal do sistema
*
* PUBLIC calc_lin, calc_col, cale_lin, cale_col, corrente, atual, m_date
* STORE 0      TO calc_lin, calc_col
* STORE -1     TO cale_lin, cale_col
* STORE 0.0000 TO corrente, atual
* STORE DATE() TO m_date
* SETKEY(K_F4,{|| Calculad(@calc_lin,@calc_col,YCORMENU)})
* SETKEY(K_F5,{|| Calendario(@cale_lin,@cale_col,@m_date)})

*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
*ณ                ROTINA DE EXIBICAO DE CALCULADORA ELEMENTAR                ณ
*ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FUNCTION Calculadora(calc_lin, calc_col, calc_cor)
   LOCAL cursor := SETCURSOR()
   SETCURSOR(0)
   DEFAULT calc_lin TO 0
   DEFAULT calc_col TO 53

   IF calc_lin > 8
      calc_lin := 8
   ENDIF
   IF calc_col > 53
      calc_col := 53
   ENDIF

   // Definiao das Constantes
   corvisor       := YCORREALCE  && cores default para o visor
   corcalc        := YCOREDIT    &&   "      "    para a calculadora
   corteccalc     := YCOREDIT    &&   "      "    para as teclas
   cor_calc       := corcalc
   cor_tecla_calc := corteccalc
   cor_visor_calc := corvisor
   igual          := 61
   move_teclas    := CHR(K_RIGHT) + CHR(K_LEFT) + CHR(K_UP) + CHR(K_DOWN)
   tam_max_num    := 16
   clin           := 0
   c_cor_ant      := SETCOLOR(cor_calc)
   tl_ant         := SAVESCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23)

   // Desenho da Calculadora
   @ calc_lin, calc_col TO calc_lin + 15, calc_col + 23
   clin++
   @ calc_lin+clin, calc_col+1 TO calc_lin+clin+3, calc_col+22
   clin++
   SETCOLOR(cor_visor_calc)
   @ calc_lin+clin, calc_col+2 SAY SPACE(20)
   clin++
   @ calc_lin+clin, calc_col+2 SAY SPACE(20)
   clin += 2
   SETCOLOR(cor_calc)
   @ calc_lin+clin, calc_col+1 SAY "  C    cE   S" + CHR(251)+"     " + CHR(246) + "/ "
   SETCOLOR(cor_tecla_calc)
   @ calc_lin+clin, calc_col+05 SAY "ณ"
   @ calc_lin+clin, calc_col+10 SAY "ณ"
   @ calc_lin+clin, calc_col+15 SAY "ณ"
   @ calc_lin+clin, calc_col+22 SAY "ณ"
   clin++
   @ calc_lin+clin, calc_col+1  SAY  " อออพ อออพ อออพ   อออพ"
   SETCOLOR(cor_calc)
   clin++
   @ calc_lin+clin, calc_col+1  SAY  "  7    8    9      *  "
   SETCOLOR(cor_tecla_calc)
   @ calc_lin+clin, calc_col+05 SAY "ณ"
   @ calc_lin+clin, calc_col+10 SAY "ณ"
   @ calc_lin+clin, calc_col+15 SAY "ณ"
   @ calc_lin+clin, calc_col+22 SAY "ณ"
   clin++
   @ calc_lin+clin, calc_col+1  SAY  " อออพ อออพ อออพ   อออพ"
   SETCOLOR(cor_calc)
   clin++
   @ calc_lin+clin, calc_col+1  SAY  "  4    5    6      +  "

   SETCOLOR(cor_tecla_calc)
   @ calc_lin+clin, calc_col+05 SAY "ณ"
   @ calc_lin+clin, calc_col+10 SAY "ณ"
   @ calc_lin+clin, calc_col+15 SAY "ณ"
   @ calc_lin+clin, calc_col+22 SAY "ณ"
   clin++
   @ calc_lin+clin, calc_col+1  SAY  " อออพ อออพ อออพ   อออพ"
   SETCOLOR(cor_calc)
   clin++
   @ calc_lin+clin, calc_col+1  SAY  "  1    2    3      -  "
   SETCOLOR(cor_tecla_calc)
   @ calc_lin+clin, calc_col+05 SAY "ณ"
   @ calc_lin+clin, calc_col+10 SAY "ณ"
   @ calc_lin+clin, calc_col+15 SAY "ณ"
   @ calc_lin+clin, calc_col+22 SAY "ณ"
   clin++
   @ calc_lin+clin, calc_col+1  SAY  " อออพ อออพ อออพ   อออพ"
   SETCOLOR(cor_calc)
   clin++
   @ calc_lin+clin, calc_col+1  SAY  "  0    .    ^" + CHR(252) + "     =  "
   SETCOLOR(cor_tecla_calc)
   @ calc_lin+clin, calc_col+05 SAY "ณ"
   @ calc_lin+clin, calc_col+10 SAY "ณ"
   @ calc_lin+clin, calc_col+15 SAY "ณ"
   @ calc_lin+clin, calc_col+22 SAY "ณ"
   clin++
   @ calc_lin+clin, calc_col+1  SAY  " อออพ อออพ อออพ   อออพ"

   // Salva calculadora para movimentacao posterior.
   tl_calc := SAVESCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23)

   // Inicializaao das variaveis

   tecla_press   := dp := cont_operador := 0
   operador      := " "
   ult_char      := "C"
   decimal       := .F.
   primeiro      := .T.
   algarismo     := .F.

   WHILE tecla_press # K_ESC .AND. tecla_press # K_PGDN
      IF corrente < 0
         @ calc_lin+2,calc_col+2  SAY SPACE(20) COLOR YCORAVISO
         @ calc_lin+3,calc_col+2  SAY corrente PICT "@ER 99,999,999,999.9999" COLOR YCORAVISO
         @ calc_lin+3,calc_col+21 SAY " " COLOR YCORAVISO
      ELSEIF corrente>99999999999.9999
         BEEP(1)
         @ calc_lin+2,calc_col+2  SAY SPACE(20) COLOR YCORAVISO
         @ calc_lin+3,calc_col+2  SAY "      E R R O      " COLOR YCORAVISO
         @ calc_lin+3,calc_col+21 SAY " "       COLOR YCORAVISO
         corrente := 0.00
      ELSE
         SETCOLOR(cor_visor_calc)
         @ calc_lin+2,calc_col+2  SAY SPACE(20)
         @ calc_lin+3,calc_col+2  SAY corrente PICT "@ER 99,999,999,999.9999"
         @ calc_lin+3,calc_col+21 SAY " "
      ENDIF
      
      tecla_press := 0
      tecla_press := INKEY(0)
      IF tecla_press == K_ENTER
         tecla_press := igual
      ENDIF
      calc_char := UPPER(CHR(tecla_press))

      IF calc_char $ "+-/*^"
         algarismo := .F.
         IF cont_operador == 0
            cont_operador := 1
         ELSE
            operador := calc_char
            LOOP
         ENDIF
      ELSE
         cont_operador := 0
      ENDIF

      DO CASE
         CASE calc_char $ move_teclas
              IF tecla_press == K_RIGHT
                 RESTSCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23,tl_ant)
                 calc_col += 3
                 IF calc_col + 23 > 79
                    calc_col := 56
                 ENDIF
                 tl_ant := SAVESCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23)
                 RESTSCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23,tl_calc)
              ELSEIF tecla_press == K_LEFT
                 RESTSCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23,tl_ant)
                 calc_col -= 3
                 IF calc_col < 0
                    calc_col := 0
                 ENDIF
                 tl_ant := SAVESCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23)
                 RESTSCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23,tl_calc)
              ELSEIF tecla_press == K_UP
                 RESTSCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23,tl_ant)
                 calc_lin--
                 IF calc_lin < 0
                    calc_lin := 0
                 ENDIF
                 tl_ant := SAVESCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23)
                 RESTSCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23,tl_calc)
              ELSEIF tecla_press == K_DOWN
                 RESTSCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23,tl_ant)
                 calc_lin++
                 IF calc_lin + 15 > 24
                    calc_lin := 9
                 ENDIF
                 tl_ant := SAVESCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23)
                 RESTSCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23,tl_calc)
              ENDIF

              IF !algarismo
                 cont_operador := 1
              ENDIF
         CASE tecla_press == K_BS
              IF dp > 0
                 tam_corr := AT(".",LTRIM(STR(corrente,16,dp))) + dp
                 dp--
                 corrente := VAL(STUFF(LTRIM(STR(corrente,16,dp)),tam_corr,1,""))
              ELSE
                 tam_corr := AT(".",LTRIM(STR(corrente,16,4))) - 1
                 IF tam_corr >= 1
                    IF tam_corr == 1
                       IF SUBSTR(LTRIM(STR(corrente,16,dp)),tam_corr,1) == "0"
                          LOOP
                       ENDIF
                    ENDIF
                    corrente := VAL(STUFF(LTRIM(STR(corrente,16,dp)),tam_corr,1,""))
                 ENDIF
              ENDIF
         CASE calc_char == "E"
              corrente := 0.0000
              dp       := 0
         CASE calc_char == "C"
              ult_char := calc_char
              corrente := 0.0000
              atual    := 0.0000
              dp       := 0
         CASE calc_char == "="
              IF atual == 0.0000 .AND. operador # "^"
                 atual    := corrente
                 operador := " "
              ENDIF
              Calc_Mat()
              ult_char    := "="
         CASE calc_char == "S"
              IF ult_char == "="
                 corrente := atual := SQRT(corrente)
              ELSE
                 corrente := SQRT(corrente)
              ENDIF
         CASE calc_char $ "+-/*^"
              IF ult_char $ "=C"      // "igual" ou Clear
                 IF ult_char == "C"   // Clear
                    atual := corrente
                 ENDIF
                 ult_char := " "
                 primeiro := .T.
              ELSE
                 Calc_Mat()
              ENDIF
              operador := ult_char := calc_char
              dp := 0
         CASE calc_char == "." .OR. calc_char == ","
              decimal := .T.
         CASE calc_char $ "0123456789"
              algarismo := .T.
              Get_Corrente()
      ENDCASE
   ENDDO
   RESTSCREEN(calc_lin,calc_col,calc_lin+15,calc_col+23,tl_ant)
   SETCOLOR(c_cor_ant)

   IF tecla_press == K_PGDN
      num_saida := LTRIM(STR(corrente,16,2))
      num_saida := STRTRAN(Num_Saida,".",",")
      KEYBOARD num_saida
   ENDIF
   SETCURSOR(cursor)
   RETURN(corrente)
*ีออออออออออออออออออออออออออออออธ
*ณÿEntrada com digitos Numericosณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Get_Corrente()
   IF decimal
      IF primeiro   //  Nenhum numero `a esquerda do ponto decimal...
         primeiro := .F.
         corrente := VAL("0." + calc_char)
      ELSE
         corrente := VAL(LTRIM(STR(corrente,tam_max_num,0)) + "." + calc_char)
      ENDIF
      decimal := .F.
      dp      := 1
   ELSE
      IF primeiro   // corrente vale 0
         primeiro := .F.
         corrente := VAL(calc_char)
      ELSE
         corrente := VAL(LTRIM(STR(corrente,tam_max_num,dp)) + calc_char)
         IF dp > 0
            dp++
         ENDIF
      ENDIF
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณÿProcessa Calculos Matematicosณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Calc_Mat()
   DO CASE
      CASE operador == "+"
           atual += corrente
      CASE operador == "-"
           atual -= corrente
      CASE operador == "*"
           atual *= corrente
      CASE operador == "/"
           IF corrente == 0   // Divisao por ZERO! ERRO!!!
              atual    := 0
              corrente := 0
              @ calc_lin+2,calc_col+2 SAY "******* ERRO *******" COLOR YCORAVISO
              @ calc_lin+3,calc_col+2 SAY "  Diviso por ZERO! " COLOR YCORAVISO
              INKEY(0)
              CLEAR TYPEAHEAD
              KEYBOARD "C"
           ELSE
              atual /= corrente
           ENDIF
      CASE operador == "^"  // Exponencial
           atual ^= corrente
   ENDCASE
   corrente := atual
   primeiro := .T.
   dp       := 0
   RETURN .T.
*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
*ณ                ROTINA DE EXIBICAO DE CALENDARIO GREGORIANO                ณ
*ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FUNCTION Calendary(cale_lin, cale_col, m_date)
   LOCAL corant := SETCOLOR(), cursor := SETCURSOR()
   PUBLIC st_col, no_days
   DEFAULT cale_lin TO 0
   DEFAULT cale_col TO 0
   SETCURSOR(0)

   SAVE SCREEN TO telaant
   m_day   := DAY(m_date)
   m_month := MONTH(m_date)
   m_year  := YEAR(m_date)
   cMes    := MONTH(DATE())
   cAno    := YEAR(DATE())

   Disp_Cal()                   // Display do Calendario
   Disp_Hdate(m_date)           // Display da Data Atual
   Find_Col(CTOD("01/"+STR(m_month,2)+"/"+STR(m_year,4)))
   Disp_Days(DATE())            // Display dos dias

   WHILE .T.
      key := INKEY(0)
      IF key == K_ESC
         m_date := DATE()
         SETCOLOR(corant)
         SETCURSOR(cursor)
         REST SCREEN FROM telaant
         RETURN .T.
      ENDIF
      DO CASE
         CASE key == K_PGDN
              m_year--
         CASE key == K_PGUP
              m_year++
         CASE key == K_END
              m_month--
              IF m_month < 1
                 m_month := 12
                 m_year--
              ENDIF
         CASE key == K_HOME
              m_month++
              IF m_month > 12
                 m_month := 1
                 m_year++
              ENDIF
         CASE key == K_RIGHT
              REST SCREEN FROM telaant
              cale_col += 5
              IF(cale_col > 50,cale_col := 50,cale_col)
         CASE key == K_LEFT
              REST SCREEN FROM telaant
              cale_col -= 5
              IF(cale_col < -1,cale_col := -1,cale_col)
         CASE key == K_UP
              REST SCREEN FROM telaant
              cale_lin--
              IF(cale_lin < -1,cale_lin := -1,cale_lin)
         CASE key == K_DOWN
              REST SCREEN FROM telaant
              cale_lin++
              IF(cale_lin > 5,cale_lin := 5,cale_lin)
      ENDCASE

      IF m_day >= 28 .AND. m_day <= 31
         Last_Day(m_month,m_year)
         m_day := no_days
      ENDIF
      m_date := CTOD(STR(m_day,2)+"/"+STR(m_month,2)+"/"+STR(m_year,4))

      IF key == K_RIGHT .OR. key == K_LEFT .OR. key == K_UP .OR. key == K_DOWN
         Disp_Cal()
      ENDIF

      Find_Col(CTOD("01/"+STR(m_month,2)+"/"+STR(m_year,4)))
      IF m_month == cMes .AND. m_year == cAno
         m_date := DATE()
      ENDIF
      Disp_Hdate(m_date)
      Clear_Date(cale_col+2)
      Disp_Days(m_date)
      LOOP
   ENDDO
*ีออออออออออออออออออออออออออออออธ
*ณÿDisplay do Calendario        ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Disp_Cal()
   SETCOLOR(YCOREDIT)
   @ cale_lin+1 ,cale_col+1,cale_lin+19,cale_col+29 BOX "ฺฤฟณูฤภณ "
   @ cale_lin+3 ,cale_col+1  SAY "ร"
   @ cale_lin+3 ,cale_col+29 SAY "ด"
   @ cale_lin+5 ,cale_col+1  SAY "ร"
   @ cale_lin+5 ,cale_col+29 SAY "ด"
   @ cale_lin+7 ,cale_col+1  SAY "ร"
   @ cale_lin+7 ,cale_col+29 SAY "ด"
   @ cale_lin+9 ,cale_col+1  SAY "ร"
   @ cale_lin+9 ,cale_col+29 SAY "ด"
   @ cale_lin+11,cale_col+1  SAY "ร"
   @ cale_lin+11,cale_col+29 SAY "ด"
   @ cale_lin+13,cale_col+1  SAY "ร"
   @ cale_lin+13,cale_col+29 SAY "ด"
   @ cale_lin+15,cale_col+1  SAY "ร"
   @ cale_lin+15,cale_col+29 SAY "ด"
   @ cale_lin+17,cale_col+1  SAY "ร"
   @ cale_lin+17,cale_col+29 SAY "ด"
   @ cale_lin+3 ,cale_col+2  SAY "ฤฤฤยฤฤฤยฤฤฤยฤฤฤยฤฤฤยฤฤฤยฤฤฤ"
   @ cale_lin+4 ,cale_col+5  SAY "ณ   ณ   ณ   ณ   ณ   ณ"
   @ cale_lin+5 ,cale_col+2  SAY "ฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤ"
   @ cale_lin+6 ,cale_col+5  SAY "ณ   ณ   ณ   ณ   ณ   ณ"
   @ cale_lin+7 ,cale_col+2  SAY "ฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤ"
   @ cale_lin+8 ,cale_col+5  SAY "ณ   ณ   ณ   ณ   ณ   ณ"
   @ cale_lin+9 ,cale_col+2  SAY "ฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤ"
   @ cale_lin+10,cale_col+5  SAY "ณ   ณ   ณ   ณ   ณ   ณ"
   @ cale_lin+11,cale_col+2  SAY "ฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤ"
   @ cale_lin+12,cale_col+5  SAY "ณ   ณ   ณ   ณ   ณ   ณ"
   @ cale_lin+13,cale_col+2  SAY "ฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤ"
   @ cale_lin+14,cale_col+5  SAY "ณ   ณ   ณ   ณ   ณ   ณ"
   @ cale_lin+15,cale_col+2  SAY "ฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤลฤฤฤ"
   @ cale_lin+16,cale_col+5  SAY "ณ   ณ   ณ   ณ   ณ   ณ"
   @ cale_lin+17,cale_col+2  SAY "ฤฤฤมฤฤฤมฤฤฤมฤฤฤมฤฤฤมฤฤฤมฤฤฤ"
   SETCOLOR(YCOREDIT)
   @ cale_lin+2 ,cale_col+2  SAY ""+SPACE(27)+""
   SETCOLOR(YCORREALCE)
   @ cale_lin+4 ,cale_col+2  SAY "Dom"
   @ cale_lin+4 ,cale_col+6  SAY "Seg"
   @ cale_lin+4 ,cale_col+10 SAY "Ter"
   @ cale_lin+4 ,cale_col+14 SAY "Qua"
   @ cale_lin+4 ,cale_col+18 SAY "Qui"
   @ cale_lin+4 ,cale_col+22 SAY "Sex"
   @ cale_lin+4 ,cale_col+26 SAY "S b"
   SETCOLOR(YCOREDIT)
   @ cale_lin+18,cale_col+2  SAY "HomeEnd    PgUpPgDn   "
   @ cale_lin+18,cale_col+11 SAY "MES" COLOR YCORTECLAS
   @ cale_lin+18,cale_col+25 SAY "ANO" COLOR YCORTECLAS
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณÿDisplay da Data Atual        ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Disp_Hdate(m_date)
   SETCOLOR(YCOREDIT)
   @ cale_lin+2,cale_col+3 SAY SPACE(25)
   @ cale_lin+2,cale_col+5 SAY SUBSTR("Janeiro  FevereiroMaro    Abril    "+;
                    "Maio     Junho    Julho    Agosto   Setembro Outubro  "+;
                    "Novembro Dezembro",MONTH(m_date)*9-8,9)
   @ Cale_Lin+2,col()+2    SAY DAY(m_date)
   @ Cale_Lin+2,col()+2    SAY YEAR(m_date)
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณÿDisplay dos Dias do Mes      ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Disp_Days(m_date)
   st_row := cale_lin + 6
   Last_Day(MONTH(m_date), YEAR(m_date))
   FOR x = 1 TO no_days
       SETCOLOR(YCOREDIT)
       IF x = DAY(m_date)
          SETCOLOR(YCORTECLAS)
       ENDIF
       @ st_row,st_col SAY STR(x,2)
       st_col += 4
       st_col := IF(st_col > cale_col+27,cale_col+2,st_col)
       st_row := IF(st_col = cale_col+2 ,st_row+2  ,st_row)
   NEXT
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณÿLimpar Areas sem Data        ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Clear_Date(st_col)
   st_row  := cale_lin+6
   no_days := 42
   SETCOLOR(YCOREDIT)
   FOR x = 1 TO no_days
       @ st_row,st_col SAY "  "
       st_col += 4
       st_col := IF(st_col > cale_col+27,cale_col+2,st_col)
       st_row := IF(st_col = cale_col+2 ,st_row+2  ,st_row)
   NEXT
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณÿLocalizar Area com 1ง dia    ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Find_Col(m_date)
   fst_day := DOW(m_date)
   c       := cale_col+2
   FOR x = 1 TO 7
       IF fst_day = x
          st_col := c
          EXIT
       ENDIF
       c += 4
   NEXT
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณÿCalcular Ultimo dia do Mes   ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Last_Day(m_month,m_year)
   IF m_month = 2
      no_days := IF(INT(m_year/4) = m_year/4,29,28)  // Ano Bissexto
      RETURN
   ENDIF
   no_days := IF(STR(m_month,2)$" 1 3 5 7 8 10 12",31,30)
   RETURN
