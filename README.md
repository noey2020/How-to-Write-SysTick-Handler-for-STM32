# How-to-Write-SysTick-Handler-for-STM32
Another way to learn &amp; understand interrupts and interrupt service routines! 

Interrupts Review:

Interrupts represent another way to change program execution from the normal. Upon power-on reset, the electronics of an ARM processor directs the program counter PC to memory location 0x00000000. That initializes the main stack pointer to address contained in that 0x00 memory. The PC moves next to the reset handler
and next into the interrrupt vector table. The interrupt vector table holds the addresses of the various interrupt handlers so they can jump to them when that particular interrupt is requested. The system timer interrupt is in that vector table which points to the SysTick handler.

After pouring over & devouring these manuals which are: 1) Cortex-M3 Revision r2p0 Technical Reference Manual, 2) Cortex-M3 Devices Generic User Guide, 3) RM0038 Reference manual, 4) PM0056 Programming manual, and 5) AN179 Cortex-M3 Embedded Software Development, one must learn which
chapters to read selectively. They are over a thousand pages in total. Reviewed the memory map where the system region resides from 0xE0000000 to the top 0xFFFFFFFF. Refer to these manuals for further details.

Writing the SysTick handler (ISR)

Given the plethora of semiconductor silicon vendors for ARM, the complexity of software & hardware has increased to the point where standards are needed. CMSIS is that standard which aims to promote, portability, ease, reduce duplication and reduce coding effort.
The standardized areas are memory map assignments, device header files, APIs, and defines. For example, we have:

#define SCS_BASE            (0xE000E000UL)
core_cm3.h
#define __CM3_REV
__IOM
#include "stm32l1xx.h"
void 
NVIC_EnableIRQ (IRQn_Type IRQn)
etc...

From the standardized memory map and CMSIS stm32l1xx header file, we can define a data structure to the 4 System timer registers. Doing it this way allows us an easy way to operate on the struct members.

typedef struct						/* patterned after stm32l1xx.h structs & defines */
{
  __IO uint32_t CTRL;
  __IO uint32_t LOAD;
  __IO uint32_t VAL;
  __I uint32_t CALIB;
} Sys_Tick_Type;

Once we have this, we can write our SysTick service handler.

/* pointer address to SysTick struct */
#define SysTick		((SysTick_Type *) SysTick_BASE)

static volatile uint32_t ticks = 0;	/* Variable to store millisecond ticks */

// volatile unsigned int TimingDelay;
volatile uint32_t TimingDelay;

void SysTick_Handler(void){	// SysTick interrupt service routine
	if(TimingDelay > 0)				// prevent it from becoming negative
		TimingDelay--;
	printf("----- SysTick Interrupt -----");
}


TBC

