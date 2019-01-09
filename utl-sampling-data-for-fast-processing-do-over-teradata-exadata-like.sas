Sampling data for fast processing do over teradata exadata like;

Problem Sum expeditures for all 50 states.

I realize there are other ways to do this
Know your data!!.

Benchmarks (Identical results)

    Frequency Ordering      Seconds
    ------------------      -------
            Sample Data      0.06
            Frequecy         0.06
            50 Sums          7.42

    Blind Ordering
    --------------          -----

    50 Sums                 33.82

Teradata and exadata take advantage of sampling to both partion and
gebnerate fast code. You can do the same and even more effectively.

Keep in mind that the compiler is your friend and repeticious
code can often be faster than loops. Also keep in mind
threads are just mutiple instruction streams.

I generate 50 when clauses.


INPUT
=====

* put these in your autoexec so you do not need to add these statements to your program, I also have numbers and letters in my autoexec;

%let states50= %sysfunc(compbl(AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT
NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY)) ;

%let states50q="AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT",
"NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY";

data have ;
  do rec=1 to 10000;
   do states=&states50q;
        state=states;
        val=uniform(1234);
        output;
        if states in ("CA","NY") then do;
           do idx=1 to 5000;
              val=uniform(1234)/10;
              output;
           end;
     end;
   end;
 end;
 keep state val;
run;quit;


WORK.HAVE total obs=100,500,000

      Obs    STATE      VAL

        1     AL      0.24381
        2     AK      0.08948
        3     AZ      0.38319
        4     AR      0.09793
        5     CA      0.25758
        6     CA      0.00882
     ...
100999999     WY      0.25758
100500000     WY      0.00882


* sample to obtain frequency;

data havSmp;
   if _n_=0 then set have nobs=obs;
   do smp=1 to 1000;
      pnt=int((obs+1)*uniform(2143));
      set have point=pnt;
      keep state;
      output;
   end;
   stop;
run;quit;

proc freq data=havSmp order=freq;
tables state;
run;quit;

SAMPLING FREQUENCY
==================

STATE    Frequency     Percent
------------------------------
CA            538       51.88
NY            495       47.73
AZ              1        0.10
IN              1        0.10
OK              1        0.10
WI              1        0.10


EXAMPLE OUTPUT
--------------

Middle Observation(1 ) of Last dataset = WORK.WANT - Total Obs 1

Variable  Type   Total

AL          N8   6662
AK          N8   6640
AZ          N8   6658
AR          N8   6679
CA          N8   1054
CO          N8   6714
CT          N8   6672
DE          N8   6668
FL          N8   6677
GA          N8   6681
HI          N8   6642
ID          N8   6690
IL          N8   6627
IN          N8   6602
IA          N8   6634
KS          N8   6673
KY          N8   6652
LA          N8   6633
ME          N8   6708
MD          N8   6662
MA          N8   6668
MI          N8   6656
MN          N8   6710
MS          N8   6673
MO          N8   6699
MT          N8   6657
NE          N8   6677
NV          N8   6716
NH          N8   6642
NJ          N8   6700
NM          N8   6688
NY          N8   1054
NC          N8   6675
ND          N8   6631
OH          N8   6643
OK          N8   6712
OR          N8   6661
PA          N8   6636
RI          N8   6649
SC          N8   6677
SD          N8   6695
TN          N8   6643
TX          N8   6726
UT          N8   6688
VT          N8   6625
VA          N8   6641
WA          N8   6666
WV          N8   6662
WI          N8   6691
WY          N8   6646


PROCESS
=======


* extract strings 'CA' and 'NY' from list of 50 states;

data _null_;
  minus2=compbl(tranwrd("&states50",'CA',''));
  minus2=compbl(tranwrd(minus2,'NY',''));
  call symputx('states_less_CA_NY',minus2);
run;quit;

* you have to manually chose the high frequency states;

%array(statesOrd,values=CA NY &states_less_CA_NY);
%array(statesRev,values=&states_less_CA_NY CA NY);

data want;
  retain &states50 0;
  set have end=dne;

    select (state);
       %do_over(statesOrd,phrase=%str(when ("?" ) ?=sum(?,sqrt(val));) )
       otherwise;
    end;
    drop state val;
    if dne then output;

run;quit;

* If you submit using 'debug' command macro can copy and paste the code mactxt.sas or
  include the code;

* Generated Code;

options mfile mprint source2;
data want;
retain AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM
NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY 0;
set have end=dne;

select (state);

when ("CA" ) CA=sum(CA,sqrt(val));  * high frequency states first;
when ("NY" ) NY=sum(NY,sqrt(val));

when ("AL") AL=sum(AL,sqrt(val));
when ("AK") AK=sum(AK,sqrt(val));
when ("AZ") AZ=sum(AZ,sqrt(val));
when ("AR") AR=sum(AR,sqrt(val));
when ("CO") CO=sum(CO,sqrt(val));
when ("CT") CT=sum(CT,sqrt(val));
when ("DE") DE=sum(DE,sqrt(val));
when ("FL") FL=sum(FL,sqrt(val));
when ("GA") GA=sum(GA,sqrt(val));
when ("HI") HI=sum(HI,sqrt(val));
when ("ID") ID=sum(ID,sqrt(val));
when ("IL") IL=sum(IL,sqrt(val));
when ("IN") IN=sum(IN,sqrt(val));
when ("IA") IA=sum(IA,sqrt(val));
when ("KS") KS=sum(KS,sqrt(val));
when ("KY") KY=sum(KY,sqrt(val));
when ("LA") LA=sum(LA,sqrt(val));
when ("ME") ME=sum(ME,sqrt(val));
when ("MD") MD=sum(MD,sqrt(val));
when ("MA") MA=sum(MA,sqrt(val));
when ("MI") MI=sum(MI,sqrt(val));
when ("MN") MN=sum(MN,sqrt(val));
when ("MS") MS=sum(MS,sqrt(val));
when ("MO") MO=sum(MO,sqrt(val));
when ("MT") MT=sum(MT,sqrt(val));
when ("NE") NE=sum(NE,sqrt(val));
when ("NV") NV=sum(NV,sqrt(val));
when ("NH") NH=sum(NH,sqrt(val));
when ("NJ") NJ=sum(NJ,sqrt(val));
when ("NM") NM=sum(NM,sqrt(val));
when ("NC") NC=sum(NC,sqrt(val));
when ("ND") ND=sum(ND,sqrt(val));
when ("OH") OH=sum(OH,sqrt(val));
when ("OK") OK=sum(OK,sqrt(val));
when ("OR") OR=sum(OR,sqrt(val));
when ("PA") PA=sum(PA,sqrt(val));
when ("RI") RI=sum(RI,sqrt(val));
when ("SC") SC=sum(SC,sqrt(val));
when ("SD") SD=sum(SD,sqrt(val));
when ("TN") TN=sum(TN,sqrt(val));
when ("TX") TX=sum(TX,sqrt(val));
when ("UT") UT=sum(UT,sqrt(val));
when ("VT") VT=sum(VT,sqrt(val));
when ("VA") VA=sum(VA,sqrt(val));
when ("WA") WA=sum(WA,sqrt(val));
when ("WV") WV=sum(WV,sqrt(val));
when ("WI") WI=sum(WI,sqrt(val));
when ("WY") WY=sum(WY,sqrt(val));
otherwise;
end;
drop state val;
if dne then output;
run;
quit;
run;
quit;

* The slow process put CA and NY last;

OUTPUT;
see above

