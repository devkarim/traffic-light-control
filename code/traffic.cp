#line 1 "C:/College/Year 2 - Communications/Training/CS/Traffic light project/code/traffic.c"
#line 28 "C:/College/Year 2 - Communications/Training/CS/Traffic light project/code/traffic.c"
int currentState = 0;
#line 34 "C:/College/Year 2 - Communications/Training/CS/Traffic light project/code/traffic.c"
int currentMode = 0;
#line 39 "C:/College/Year 2 - Communications/Training/CS/Traffic light project/code/traffic.c"
int cancelFlag = 0;
#line 44 "C:/College/Year 2 - Communications/Training/CS/Traffic light project/code/traffic.c"
void turnOnLeds();
void count(int);
void goNextState();
void waitCurrentState();
void startAuto();
void startManual();
#line 54 "C:/College/Year 2 - Communications/Training/CS/Traffic light project/code/traffic.c"
void interrupt() {
 if (intf_bit == 1) {
 intf_bit=0;

 if (currentMode == 0) {
 currentMode=1;
 } else {
 currentMode=0;
 }

 cancelFlag=1;
 }
}
#line 71 "C:/College/Year 2 - Communications/Training/CS/Traffic light project/code/traffic.c"
void main() {

 trisb.b0=1;
 trisb.b1=1;

 gie_bit=1;
 inte_bit=1;
 not_rbpu_bit=0;

 trisc=0;
 trisd=0;

  portd =0;
  portc =0;

 while (1) {
 cancelFlag=0;

  portc =0;

  portd =0;

 if (currentMode == 0) {
 startAuto();
 } else {
 startManual();
 }
 }
}
#line 104 "C:/College/Year 2 - Communications/Training/CS/Traffic light project/code/traffic.c"
void turnOnLeds() {
  portd =0;
 if (currentState == 0) {
  portd.B5 =1;
  portd.B0 =1;
 } else if (currentState == 1) {
  portd.B4 =1;
  portd.B0 =1;
 } else if (currentState == 2) {
  portd.B3 =1;
  portd.B2 =1;
 } else if (currentState == 3) {
  portd.B3 =1;
  portd.B1 =1;
 }
}
#line 124 "C:/College/Year 2 - Communications/Training/CS/Traffic light project/code/traffic.c"
void startManual() {

 turnOnLeds();

 while (1) {

 if (cancelFlag) return;

 if ( portb.B1  == 0) continue;

 if (currentState == 0) {
 count(3000);
 } else if (currentState == 2) {
 count(3000);
 }

 goNextState();

 turnOnLeds();
 }
}
#line 149 "C:/College/Year 2 - Communications/Training/CS/Traffic light project/code/traffic.c"
void waitCurrentState() {
 if (currentState == 0) {

 count(23000);
 } else if (currentState == 2) {

 count(15000);
 }
}
#line 162 "C:/College/Year 2 - Communications/Training/CS/Traffic light project/code/traffic.c"
void goNextState() {

 currentState++;

 if (currentState == 4) {
 currentState=0;
 }
}

void startAuto() {
 turnOnLeds();

 while (1) {
 if (cancelFlag) break;

 waitCurrentState();

 if (!cancelFlag || currentState == 1 || currentState == 3) {
 goNextState();
 }

 turnOnLeds();
 }
}

void count(int ms) {

 int sec = ms / 1000;

 while (1) {

 if (cancelFlag && currentState != 3 && currentState != 1) break;

  portc  = dec2bcd(sec);

 if (sec == 0) {
 break;
 }

 if (sec == 3) {

 goNextState();
 turnOnLeds();
 }

 delay_1sec();
 sec--;
 }
}
