#include "stm32l1xx.h"		/* Standard STM32L1xxx driver headers */

/* IO Type Qualifiers are used to specify the access to peripheral variables. */
#define __I		volatile const	// define for read only
#define __O		volatile				// define for write only
#define __IO	volatile				// define for both read & write
/* #define volatile	*/

typedef struct						/* patterned after stm32l1xx.h structs & defines */
{
  __IO uint32_t CTRL;
  __IO uint32_t LOAD;
  __IO uint32_t VAL;
  __I uint32_t CALIB;
} Sys_Tick_Type;

/* For illustration purpose only. Otherwise, warning: */
// C:/Users/notor/AppData/Local/Arm/Packs/ARM/CMSIS/5.7.0/CMSIS/Core/Include\core_cm3.h(1380): note: previous definition is here
// #define SCS_BASE            (0xE000E000UL)                            /*!< System Control Space Base Address */
#define SCS_BASE			0xE000E000
#define SysTick_BASE	(SCS_BASE +  0x0010)

/* pointer address to SysTick struct */
#define SysTick		((SysTick_Type *) SysTick_BASE)

static volatile uint32_t ticks = 0;	/* Variable to store millisecond ticks */

// volatile unsigned int TimingDelay;
volatile uint32_t TimingDelay;

void SysTick_Initialize(uint32_t ticks){		// ticks = number of ticks between two interrupts
	// Disable SysTick IRQ and SysTick counter
	SysTick->CTRL = 0;

	// Set reload register
	SysTick->LOAD - ticks - 1;

	// Set priority
	NVIC_SetPriority(SysTick_IRQn, (1<<__NVIC_PRIO_BITS) - 1);
	
	// Reset the SysTick counter value
	SysTick->VAL = 0;
	
	// Select processor clock. 1 = processor clock, 0 = external clock
	SysTick->CTRL |= SysTick_CTRL_CLKSOURCE;
	
	// Enable SysTick IRQ and SysTick timer
	SysTick->CTRL |= SysTick_CTRL_ENABLE;
	
	SysTick->CTRL |= SysTick_CTRL_TICKINT;
}

void SysTick_Handler(void){	// SysTick interrupt service routine
	if(TimingDelay > 0)				// prevent it from becoming negative
		TimingDelay--;
	printf("----- SysTick Interrupt -----");
}

void Delay(uint32_t nTime){
	// nTime: specifies the delay time length
	TimingDelay = nTime;
	while(TimingDelay != 0);	// busy wait
}

int main(void){
		SysTick_Initialize(1000);		// Interrupt period = 1000 cycles
		Delay(100);	// Delay 100 ticks
	while(1){
	}
	return 0;
}