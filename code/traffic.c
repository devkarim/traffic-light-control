/*
  Project: Traffic Lights with Manual & Automatic Control
  Student name: Karim Wael
  Department: Communications & Electronics - 2nd Year
  Date: 2023/7/24
  Shoubra Faculty of Engineering
*/

#define SEGMENTS portc
#define LEDS portd

#define SRLED portd.B0    // South Red LED
#define SYLED portd.B1    // South Yellow LED
#define SGLED portd.B2   // South Green LED

#define WRLED portd.B3   // West Red LED
#define WYLED portd.B4  // West Yellow LED
#define WGLED portd.B5 // West Green LED

#define SBTN portb.B1  // Change state button

/*
  State 0: West is Green, South is Red
  State 1: West is Yellow, South is Red
  State 2: West is Red, South is Green
  State 3: West is Red, South is Yellow
*/
int currentState = 0;

/*
  Mode 0: Automatic
  Mode 1: Manual
*/
int currentMode = 0;

/*
  Cancel flag: Cancels current task
*/
int cancelFlag = 0;

/*
  Function prototypes
*/
void turnOnLeds();
void count(int);
void goNextState();
void waitCurrentState();
void startAuto();
void startManual();

/*
  External interrupt is for switching between auto and manual modes.
*/
void interrupt() {
     if (intf_bit == 1) {
        intf_bit=0;
        // Switch auto/manual modes
        if (currentMode == 0) {
          currentMode=1;
        } else {
          currentMode=0;
        }
        // Set cancel flag to true so it cancels all current tasks
        cancelFlag=1;
     }
}

/*
  Entry point
*/
void main() {
     // Inputs
     trisb.b0=1; // Change mode pin
     trisb.b1=1; // Manual: Change state pin
     // Interrupt flags
     gie_bit=1;
     inte_bit=1;
     not_rbpu_bit=0;
     // Outputs
     trisc=0; // 7-segments port
     trisd=0; // leds port
     // Set all ports to zero
     LEDS=0;
     SEGMENTS=0;
     // Event loop
     while (1) {
           cancelFlag=0;
           // Reset 7-segments pins
           SEGMENTS=0;
           // Reset leds pins
           LEDS=0;
           // Check if automatic/manual mode
           if (currentMode == 0) {
              startAuto();
           } else {
              startManual();
           }
     }
}

/*
  Turn on leds based on current state
*/
void turnOnLeds() {
     LEDS=0;
     if (currentState == 0) {
        WGLED=1;
        SRLED=1;
     } else if (currentState == 1) {
        WYLED=1;
        SRLED=1;
     } else if (currentState == 2) {
        WRLED=1;
        SGLED=1;
     } else if (currentState == 3) {
        WRLED=1;
        SYLED=1;
     }
}

/*
  Manual mode
*/
void startManual() {
     // Start with first state
     turnOnLeds();
     // Event loop for manual mode
     while (1) {
       // If switched to automatic mode, stop
       if (cancelFlag) return;
       // If state button is not pressed, do nothing
       if (SBTN == 0) continue;
       // Change states based on current state
       if (currentState == 0) {
         count(3000);
       } else if (currentState == 2) {
         count(3000);
       }
       // Go next state
       goNextState();
       // Once yellow is gone, turn on next state's leds
       turnOnLeds();
     }
}

/*
  Wait current state seconds
*/
void waitCurrentState() {
  if (currentState == 0) {
     // Wait 23s for south being red along with 20s + 3s for west being green and yellow
     count(23000);
  } else if (currentState == 2) {
     // Wait 15s for west being red along with 12s + 5s for south being green and yellow
     count(15000);
  }
}

/*
  Go next state based on current state
*/
void goNextState() {
  // Increment current state
  currentState++;
  // If exceeded maximum state, reset to 0
  if (currentState == 4) {
     currentState=0;
  }
}

void startAuto() {
  turnOnLeds();
  // Event loop for auto mode
  while (1) {
    if (cancelFlag) break;
    // Wait current state period
    waitCurrentState();
    // Go next state if not cancelled or yellow state
    if (!cancelFlag || currentState == 1 || currentState == 3) {
       goNextState();
    }
    // Turn on next state's leds
    turnOnLeds();
  }
}

void count(int ms) {
  // Convert milliseconds to seconds for displaying
  int sec = ms / 1000;
  // Decrement from time given to 0
  while (1) {
        // If switched to manual mode, stop only if current state is not yellow
        if (cancelFlag && currentState != 3 && currentState != 1) break;
        // Display seconds on 7-segments by converting second as decimal to BCD
        SEGMENTS = dec2bcd(sec);
        // When it becomes zero, stop
        if (sec == 0) {
           break;
        }
        // When it becomes 3 seconds, prepare for turning on yellow
        if (sec == 3) {
           // Turn on yellow based on current state
           goNextState();
           turnOnLeds();
        }
        // Delay one second and decrement
        delay_1sec();
        sec--;
  }
}