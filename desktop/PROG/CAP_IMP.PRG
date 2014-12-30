*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : CAP_IMP                                  ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Capturar Impressoras em Rede             ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "CAPTURE.CH"

DECLARE aFila[N_B_SCAN('*',3)]
N_B_SCAN('*',3,aFila)
SETCOLOR(YCOREDIT)
Telas(08,10,12,40,1,YCOREDIT,.T.)
IF (nCho:=ACHOICE(09,11,11,39, aFila))<>0
   x:= Capture("q="+aFila[nCho]+" /AU /NFF /NB")
ENDIF
Rest_Tela()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Identificar Qtde.Parametros  ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION LineParm(cstring1, cstring2, cstring3, cstring4, cstring5,  ;
                  cstring6, cstring7, cstring8, cstring9, cstring10, ;
                  cstring11, cstring12, cstring13, cstring14, cstring15)

#define MAXPARM 15            && sets maximum allowable command line
                              && parameters.
LOCAL cstring

IF PCOUNT() > MAXPARM
   RETURN .F.
ENDIF

cstring = IF(cstring1  = NIL, '', cstring1 + ' ') + ;  && build space delimted
          IF(cstring2  = NIL, '', cstring2 + ' ') + ;  && string
          IF(cstring3  = NIL, '', cstring3 + ' ') + ;
          IF(cstring4  = NIL, '', cstring4 + ' ') + ;
          IF(cstring5  = NIL, '', cstring5 + ' ') + ;
          IF(cstring6  = NIL, '', cstring6 + ' ') + ;
          IF(cstring7  = NIL, '', cstring7 + ' ') + ;
          IF(cstring8  = NIL, '', cstring8 + ' ') + ;
          IF(cstring9  = NIL, '', cstring9 + ' ') + ;
          IF(cstring10 = NIL, '', cstring10 + ' ') + ;
          IF(cstring11 = NIL, '', cstring11 + ' ') + ;
          IF(cstring12 = NIL, '', cstring12 + ' ') + ;
          IF(cstring13 = NIL, '', cstring13 + ' ') + ;
          IF(cstring14 = NIL, '', cstring14 + ' ') + ;
          IF(cstring15 = NIL, '', cstring15 + ' ')

RETURN Capture(cstring)                 && and call capture with it
*ีออออออออออออออออออออออออออออออธ
*ณ Capturar Inf.da Fila Impress.ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Capture(cstring, disp)

LOCAL parray := {}, ;   && parray is filled with the command line parms
      ret               && ret is the return value from psearray
                          
n_Ready()

IF PCOUNT() < 2
   disp = .T.
ENDIF

IF EMPTY(cstring)
   AADD(parray, "HELP")
ELSE
   BldArray(cstring, parray)
ENDIF

ret = Psearray(parray)    && parse/process the array

RETURN (ret = 0)

***************************************************************************
* move all commands into parray.  I can't just parse them as I go along
* because order is important (L must come before anything and S must
* come before Q)
PROCEDURE BldArray(cstring, parray)

LOCAL s1, ;             && S1 is the command,
      s2, ;             && S2 is the parameter to S1,
      lpt, lptx, ;      && look for "L" on command line
      srv, srvx         && look for "S" on command line

WHILE !EMPTY(cstring)   && cstring gets shortened as each command is parsed

   Trimit(@cstring)     && drop leading space, /, \
   s1 = Getword(@cstring, ":= ") && get upper until =, :, (sp)
   s2 = ""
   
   DO CASE
      * These have no second parameter
      CASE s1 = "SH" .or. s1 = "NT" .or. s1 = "NB" .or. s1 = "FF" .or. ;
           s1 = "NFF" .or. s1 = "AU" .or. s1 = "NOA" .or. s1 = "NOTI" ;
           .or. s1 = "NNOTI" .or. s1 = "DU" .or. s1 = "NOB" .or. ;
           s1="FORMF" .or. s1 = "NOTA"
         AADD(parray, s1)

      * These do
      CASE s1 = "B" .or. s1 = "NA" .or. s1 = "T" .or. s1 = "C" .or. ;
           s1 = "F" .or. s1 = "J"  .or. s1 = "Q" .or. s1 = "S" .or. ;
           s1 = "L" .or. s1 = "TI"
         Trimit(@cstring)
         s2 = Getword(@cstring, ":= ")
         AADD(parray, {s1, s2})

      * Commands that begin with the word "NO" translated to 1 word
      CASE s1 == "NO"
         Trimit(@cstring)
         s2 = Getword(@cstring, ":= ")
         DO CASE
            CASE s2 = "B"
               AADD(parray, "NB")
            CASE s2 = "F"
               AADD(parray, "NFF")
            CASE s2 = "N"
               AADD(parray, "NNOTI")
            CASE s2 = "T"
               AADD(parray, "NT")
            CASE s2 = "A"
               AADD(parray, "NA")
            OTHERWISE
               RETURN
         ENDCASE
      OTHERWISE
         RETURN
   ENDCASE
ENDDO

* "L", if specified, must come first (else capset(0,...) won't work)
lpt = ASCAN(parray, {|x| IF(VALTYPE(x) != "A", .F., x[1] == "L")})
DO CASE
   CASE lpt > 1
        lptx = parray[lpt]
        ADEL(parray, lpt)
        AINS(parray, 1)
        parray[1] = lptx
   CASE lpt = 0
        ASIZE(parray, len(parray) + 1)
        AINS(parray, 1)
        parray[1] = {"L", "1"}
   CASE lpt = 1
ENDCASE

* "S", if specified, must come before "Q" (else looks on wrong server)
srv = ASCAN(parray, {|x| IF(VALTYPE(x) != "A", .F., x[1] == "S")})
IF srv > 2
   srvx = parray[srv]
   ADEL(parray, srv)
   AINS(parray, 2)
   parray[2] = srvx
ENDIF

IF ASCAN(parray, "H") > 0
   parray := {"HELP"}
ENDIF

IF ASCAN(parray, "SH") > 0
   parray := {"SHOW"}
ENDIF

IF ASCAN(parray, "DU") > 0
   parray := {"DUMP"}
ENDIF
RETURN

***************************************************************************
FUNCTION Psearray(parray)

LOCAL s1, ;             && S1 is the command,
      s2, ;             && S2 is the parameter to S1,
      ret := 0          && ret is the return value from n_capset()

WHILE parray[1] <> NIL

   IF VALTYPE(parray[1]) = "A"
      s1 = parray[1,1]
      s2 = parray[1,2]
   ELSE
      s1 = parray[1]
      s2 = ""
   ENDIF
   ADEL(parray, 1)

* Note that order *is* important is this case statement
   DO CASE
      CASE s1 = "TI"                            && Timeout
           ret = n_Capset(0, CAP_TIMEOUT, VAL(s2))
      CASE s1 = "T"                             && tabs
           ret = n_Capset(0, CAP_TABS, VAL(s2))
      CASE s1 = "SH"    && show
           Show(.f.)
           ret = -1
           EXIT
      CASE s1 = "S"                             && Server that contains queue
           ret = n_Capset(0, CAP_SERVER, s2)
      CASE s1 = "Q"                             && Queue name
           ret = n_Capset(0, CAP_QUEUE, s2)
      CASE s1 = "NT"                            && no tabs
           ret = n_Capset(0, CAP_TABS, .F.)
      CASE s1 = "NOTI"                          && notify
           ret = n_Capset(0, CAP_NOTIFY, .T.)
      CASE s1 = "NOTA"                          && no tabs
           ret = n_Capset(0, CAP_TABS, .F.)
      CASE s1 = "NOB"
           ret = n_Capset(0, CAP_BANNER, "")
      CASE s1 = "NNOTI"                         && no notify
           ret = n_Capset(0, CAP_NOTIFY, .F.)
      CASE s1 = "NFF"                           && no form feed
           ret = n_Capset(0, CAP_NOFF, .T.)
      CASE s1 = "NB"
           ret = n_Capset(0, CAP_BANNER, "")
      CASE s1 = "NAM"                           && name
           ret = n_Capset(0, CAP_USER, s2)
      CASE s1 = "NA" .or. s1 = "NOA"            && noautoendcap
           ret = n_Capset(0, CAP_AUTOEND, .F.)
      CASE s1 = "LP"                            && Lines per page
           ret = n_Capset(0, CAP_LPP, VAL(s2))
      CASE s1 = "L"                             && LPT port
           n_Capdflt(VAL(s2))
      CASE s1 = "J"                             && Job Name (from printcon)
           ret = n_Capset(0, CAP_JNAME, s2)
      CASE s1 = "H"
           Help()
           parray := {NIL}
           ret = -1
      CASE s1 = "FORMF" .OR. s1 = "FF"          && formfeed
           ret = n_Capset(0, CAP_NOFF, .F.)
      CASE s1 = "F"                             && Form # or Name
           IF VAL(s2) > 0
              ret = n_Capset(0, CAP_FORMNO, VAL(s2))
           ELSE
              ret = n_Capset(0, CAP_FNAME, s2)
           ENDIF
      CASE s1 = "DU"    && dump (like show, but more info)
           Show(.t.)
           ret = -1
           EXIT
      CASE s1 = "CP"                            && Characters per line
           ret = n_Capset(0, CAP_CPL, VAL(s2))
      CASE s1 = "C"                             && Copies
           ret = n_Capset(0, CAP_COPIES, VAL(s2))
      CASE s1 = "B"                             && banner
           ret = n_Capset(0, CAP_BANNER, s2)
      CASE s1 = "AU"                            && autoendcap
           ret = n_Capset(0, CAP_AUTOEND, .T.)

* The following options have no netlib equivalent (notice that CR
* can easily be simulated by using either SET ALTERNATE or SET DEVICE and
* KEEP no longer does anything under 3.x and that Domain only applies to 
* Unix.

      CASE s1 = "CR"                            && Create (NYI)
           ret = 1
      CASE s1 = "K"                             && Keep (NYI)
           ret = 1
      CASE s1 = "DO"                            && domain (NYI)
           ret = 1
      OTHERWISE
           ret = 1
   ENDCASE

   IF ret > 0
      parray := {NIL}
   ENDIF
ENDDO

IF ret = 0
   ret = n_Capset(0, CAP_COMMAND, CAP_START)
ENDIF
RETURN ret

***************************************************************************
* drop leading (sp), /, \, :, and =
*
PROCEDURE Trimit(lstring)

DO WHILE SUBSTR(lstring, 1, 1) $ " /\:=" .AND. !EMPTY(lstring)
   lstring = SUBSTR(lstring, 2)
ENDDO
RETURN

***************************************************************************
* get characters until sstring
*
FUNCTION Getword(lstring, sstring)

LOCAL y := "", x

DO WHILE !(x:=SUBSTR(lstring, 1, 1)) $ sstring .AND. !empty(lstring)
   lstring = substr(lstring,2)
   y = y + x
enddo
return upper(y)

***************************************************************************
* Show capture status for all 3 ports.  If 'dump' is .t., show addtl info
*
proc show(dump)

local x

for x = 1 to 3
   show1(x, dump)
next x
return

***************************************************************************
* Show info about lpt port #port.  If 'dump' is .t., show addtl info
proc show1(port, dump)

local y, ban, tabs, timeout

if n_capget(port, CAP_STATUS) != CAP_ACTIVE
   return
endif

ban = n_capget(port, CAP_BANNER)

tabs = n_capget(port, CAP_TABS)

timeout = n_capget(port, CAP_TIMEOUT)

if !dump
   return
endif
return

***************************************************************************
* Show syntax
*
*proc help
*return
