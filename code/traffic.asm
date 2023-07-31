
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;traffic.c,54 :: 		void interrupt() {
;traffic.c,55 :: 		if (intf_bit == 1) {
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt0
;traffic.c,56 :: 		intf_bit=0;
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;traffic.c,58 :: 		if (currentMode == 0) {
	MOVLW      0
	XORWF      _currentMode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt42
	MOVLW      0
	XORWF      _currentMode+0, 0
L__interrupt42:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;traffic.c,59 :: 		currentMode=1;
	MOVLW      1
	MOVWF      _currentMode+0
	MOVLW      0
	MOVWF      _currentMode+1
;traffic.c,60 :: 		} else {
	GOTO       L_interrupt2
L_interrupt1:
;traffic.c,61 :: 		currentMode=0;
	CLRF       _currentMode+0
	CLRF       _currentMode+1
;traffic.c,62 :: 		}
L_interrupt2:
;traffic.c,64 :: 		cancelFlag=1;
	MOVLW      1
	MOVWF      _cancelFlag+0
	MOVLW      0
	MOVWF      _cancelFlag+1
;traffic.c,65 :: 		}
L_interrupt0:
;traffic.c,66 :: 		}
L_end_interrupt:
L__interrupt41:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;traffic.c,71 :: 		void main() {
;traffic.c,73 :: 		trisb.b0=1; // Change mode pin
	BSF        TRISB+0, 0
;traffic.c,74 :: 		trisb.b1=1; // Manual: Change state pin
	BSF        TRISB+0, 1
;traffic.c,76 :: 		gie_bit=1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;traffic.c,77 :: 		inte_bit=1;
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;traffic.c,78 :: 		not_rbpu_bit=0;
	BCF        NOT_RBPU_bit+0, BitPos(NOT_RBPU_bit+0)
;traffic.c,80 :: 		trisc=0; // 7-segments port
	CLRF       TRISC+0
;traffic.c,81 :: 		trisd=0; // leds port
	CLRF       TRISD+0
;traffic.c,83 :: 		LEDS=0;
	CLRF       PORTD+0
;traffic.c,84 :: 		SEGMENTS=0;
	CLRF       PORTC+0
;traffic.c,86 :: 		while (1) {
L_main3:
;traffic.c,87 :: 		cancelFlag=0;
	CLRF       _cancelFlag+0
	CLRF       _cancelFlag+1
;traffic.c,89 :: 		SEGMENTS=0;
	CLRF       PORTC+0
;traffic.c,91 :: 		LEDS=0;
	CLRF       PORTD+0
;traffic.c,93 :: 		if (currentMode == 0) {
	MOVLW      0
	XORWF      _currentMode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main44
	MOVLW      0
	XORWF      _currentMode+0, 0
L__main44:
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;traffic.c,94 :: 		startAuto();
	CALL       _startAuto+0
;traffic.c,95 :: 		} else {
	GOTO       L_main6
L_main5:
;traffic.c,96 :: 		startManual();
	CALL       _startManual+0
;traffic.c,97 :: 		}
L_main6:
;traffic.c,98 :: 		}
	GOTO       L_main3
;traffic.c,99 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_turnOnLeds:

;traffic.c,104 :: 		void turnOnLeds() {
;traffic.c,105 :: 		LEDS=0;
	CLRF       PORTD+0
;traffic.c,106 :: 		if (currentState == 0) {
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__turnOnLeds46
	MOVLW      0
	XORWF      _currentState+0, 0
L__turnOnLeds46:
	BTFSS      STATUS+0, 2
	GOTO       L_turnOnLeds7
;traffic.c,107 :: 		WGLED=1;
	BSF        PORTD+0, 5
;traffic.c,108 :: 		SRLED=1;
	BSF        PORTD+0, 0
;traffic.c,109 :: 		} else if (currentState == 1) {
	GOTO       L_turnOnLeds8
L_turnOnLeds7:
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__turnOnLeds47
	MOVLW      1
	XORWF      _currentState+0, 0
L__turnOnLeds47:
	BTFSS      STATUS+0, 2
	GOTO       L_turnOnLeds9
;traffic.c,110 :: 		WYLED=1;
	BSF        PORTD+0, 4
;traffic.c,111 :: 		SRLED=1;
	BSF        PORTD+0, 0
;traffic.c,112 :: 		} else if (currentState == 2) {
	GOTO       L_turnOnLeds10
L_turnOnLeds9:
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__turnOnLeds48
	MOVLW      2
	XORWF      _currentState+0, 0
L__turnOnLeds48:
	BTFSS      STATUS+0, 2
	GOTO       L_turnOnLeds11
;traffic.c,113 :: 		WRLED=1;
	BSF        PORTD+0, 3
;traffic.c,114 :: 		SGLED=1;
	BSF        PORTD+0, 2
;traffic.c,115 :: 		} else if (currentState == 3) {
	GOTO       L_turnOnLeds12
L_turnOnLeds11:
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__turnOnLeds49
	MOVLW      3
	XORWF      _currentState+0, 0
L__turnOnLeds49:
	BTFSS      STATUS+0, 2
	GOTO       L_turnOnLeds13
;traffic.c,116 :: 		WRLED=1;
	BSF        PORTD+0, 3
;traffic.c,117 :: 		SYLED=1;
	BSF        PORTD+0, 1
;traffic.c,118 :: 		}
L_turnOnLeds13:
L_turnOnLeds12:
L_turnOnLeds10:
L_turnOnLeds8:
;traffic.c,119 :: 		}
L_end_turnOnLeds:
	RETURN
; end of _turnOnLeds

_startManual:

;traffic.c,124 :: 		void startManual() {
;traffic.c,126 :: 		turnOnLeds();
	CALL       _turnOnLeds+0
;traffic.c,128 :: 		while (1) {
L_startManual14:
;traffic.c,130 :: 		if (cancelFlag) return;
	MOVF       _cancelFlag+0, 0
	IORWF      _cancelFlag+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_startManual16
	GOTO       L_end_startManual
L_startManual16:
;traffic.c,132 :: 		if (SBTN == 0) continue;
	BTFSC      PORTB+0, 1
	GOTO       L_startManual17
	GOTO       L_startManual14
L_startManual17:
;traffic.c,134 :: 		if (currentState == 0) {
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__startManual51
	MOVLW      0
	XORWF      _currentState+0, 0
L__startManual51:
	BTFSS      STATUS+0, 2
	GOTO       L_startManual18
;traffic.c,135 :: 		count(3000);
	MOVLW      184
	MOVWF      FARG_count+0
	MOVLW      11
	MOVWF      FARG_count+1
	CALL       _count+0
;traffic.c,136 :: 		} else if (currentState == 2) {
	GOTO       L_startManual19
L_startManual18:
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__startManual52
	MOVLW      2
	XORWF      _currentState+0, 0
L__startManual52:
	BTFSS      STATUS+0, 2
	GOTO       L_startManual20
;traffic.c,137 :: 		count(3000);
	MOVLW      184
	MOVWF      FARG_count+0
	MOVLW      11
	MOVWF      FARG_count+1
	CALL       _count+0
;traffic.c,138 :: 		}
L_startManual20:
L_startManual19:
;traffic.c,140 :: 		goNextState();
	CALL       _goNextState+0
;traffic.c,142 :: 		turnOnLeds();
	CALL       _turnOnLeds+0
;traffic.c,143 :: 		}
	GOTO       L_startManual14
;traffic.c,144 :: 		}
L_end_startManual:
	RETURN
; end of _startManual

_waitCurrentState:

;traffic.c,149 :: 		void waitCurrentState() {
;traffic.c,150 :: 		if (currentState == 0) {
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__waitCurrentState54
	MOVLW      0
	XORWF      _currentState+0, 0
L__waitCurrentState54:
	BTFSS      STATUS+0, 2
	GOTO       L_waitCurrentState21
;traffic.c,152 :: 		count(23000);
	MOVLW      216
	MOVWF      FARG_count+0
	MOVLW      89
	MOVWF      FARG_count+1
	CALL       _count+0
;traffic.c,153 :: 		} else if (currentState == 2) {
	GOTO       L_waitCurrentState22
L_waitCurrentState21:
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__waitCurrentState55
	MOVLW      2
	XORWF      _currentState+0, 0
L__waitCurrentState55:
	BTFSS      STATUS+0, 2
	GOTO       L_waitCurrentState23
;traffic.c,155 :: 		count(15000);
	MOVLW      152
	MOVWF      FARG_count+0
	MOVLW      58
	MOVWF      FARG_count+1
	CALL       _count+0
;traffic.c,156 :: 		}
L_waitCurrentState23:
L_waitCurrentState22:
;traffic.c,157 :: 		}
L_end_waitCurrentState:
	RETURN
; end of _waitCurrentState

_goNextState:

;traffic.c,162 :: 		void goNextState() {
;traffic.c,164 :: 		currentState++;
	INCF       _currentState+0, 1
	BTFSC      STATUS+0, 2
	INCF       _currentState+1, 1
;traffic.c,166 :: 		if (currentState == 4) {
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__goNextState57
	MOVLW      4
	XORWF      _currentState+0, 0
L__goNextState57:
	BTFSS      STATUS+0, 2
	GOTO       L_goNextState24
;traffic.c,167 :: 		currentState=0;
	CLRF       _currentState+0
	CLRF       _currentState+1
;traffic.c,168 :: 		}
L_goNextState24:
;traffic.c,169 :: 		}
L_end_goNextState:
	RETURN
; end of _goNextState

_startAuto:

;traffic.c,171 :: 		void startAuto() {
;traffic.c,172 :: 		turnOnLeds();
	CALL       _turnOnLeds+0
;traffic.c,174 :: 		while (1) {
L_startAuto25:
;traffic.c,175 :: 		if (cancelFlag) break;
	MOVF       _cancelFlag+0, 0
	IORWF      _cancelFlag+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_startAuto27
	GOTO       L_startAuto26
L_startAuto27:
;traffic.c,177 :: 		waitCurrentState();
	CALL       _waitCurrentState+0
;traffic.c,179 :: 		if (!cancelFlag || currentState == 1 || currentState == 3) {
	MOVF       _cancelFlag+0, 0
	IORWF      _cancelFlag+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L__startAuto38
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__startAuto59
	MOVLW      1
	XORWF      _currentState+0, 0
L__startAuto59:
	BTFSC      STATUS+0, 2
	GOTO       L__startAuto38
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__startAuto60
	MOVLW      3
	XORWF      _currentState+0, 0
L__startAuto60:
	BTFSC      STATUS+0, 2
	GOTO       L__startAuto38
	GOTO       L_startAuto30
L__startAuto38:
;traffic.c,180 :: 		goNextState();
	CALL       _goNextState+0
;traffic.c,181 :: 		}
L_startAuto30:
;traffic.c,183 :: 		turnOnLeds();
	CALL       _turnOnLeds+0
;traffic.c,184 :: 		}
	GOTO       L_startAuto25
L_startAuto26:
;traffic.c,185 :: 		}
L_end_startAuto:
	RETURN
; end of _startAuto

_count:

;traffic.c,187 :: 		void count(int ms) {
;traffic.c,189 :: 		int sec = ms / 1000;
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       FARG_count_ms+0, 0
	MOVWF      R0+0
	MOVF       FARG_count_ms+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      count_sec_L0+0
	MOVF       R0+1, 0
	MOVWF      count_sec_L0+1
;traffic.c,191 :: 		while (1) {
L_count31:
;traffic.c,193 :: 		if (cancelFlag && currentState != 3 && currentState != 1) break;
	MOVF       _cancelFlag+0, 0
	IORWF      _cancelFlag+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_count35
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__count62
	MOVLW      3
	XORWF      _currentState+0, 0
L__count62:
	BTFSC      STATUS+0, 2
	GOTO       L_count35
	MOVLW      0
	XORWF      _currentState+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__count63
	MOVLW      1
	XORWF      _currentState+0, 0
L__count63:
	BTFSC      STATUS+0, 2
	GOTO       L_count35
L__count39:
	GOTO       L_count32
L_count35:
;traffic.c,195 :: 		SEGMENTS = dec2bcd(sec);
	MOVF       count_sec_L0+0, 0
	MOVWF      FARG_Dec2Bcd_decnum+0
	CALL       _Dec2Bcd+0
	MOVF       R0+0, 0
	MOVWF      PORTC+0
;traffic.c,197 :: 		if (sec == 0) {
	MOVLW      0
	XORWF      count_sec_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__count64
	MOVLW      0
	XORWF      count_sec_L0+0, 0
L__count64:
	BTFSS      STATUS+0, 2
	GOTO       L_count36
;traffic.c,198 :: 		break;
	GOTO       L_count32
;traffic.c,199 :: 		}
L_count36:
;traffic.c,201 :: 		if (sec == 3) {
	MOVLW      0
	XORWF      count_sec_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__count65
	MOVLW      3
	XORWF      count_sec_L0+0, 0
L__count65:
	BTFSS      STATUS+0, 2
	GOTO       L_count37
;traffic.c,203 :: 		goNextState();
	CALL       _goNextState+0
;traffic.c,204 :: 		turnOnLeds();
	CALL       _turnOnLeds+0
;traffic.c,205 :: 		}
L_count37:
;traffic.c,207 :: 		delay_1sec();
	CALL       _Delay_1sec+0
;traffic.c,208 :: 		sec--;
	MOVLW      1
	SUBWF      count_sec_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       count_sec_L0+1, 1
;traffic.c,209 :: 		}
	GOTO       L_count31
L_count32:
;traffic.c,210 :: 		}
L_end_count:
	RETURN
; end of _count
