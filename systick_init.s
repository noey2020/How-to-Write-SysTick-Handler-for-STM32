		INCLUDE stm32l1xx_constants.s       ; Load Constant Definitions
		INCLUDE stm32l1xx_tim_constants.s   ; TIM Constants
		AREA myData, DATA, READWRITE
		AREA myCode, CODE, READONLY
		EXPORT __main						; __main and not _main as defined 
		ALIGN								; startup_stm32l1xx_md.s. lines 192,
		ENTRY								; 217, and 36
__main	PROC
		ENDP
SysTick_Init	PROC
		; Set SysTick_CTRL  to disable SysTick IRQ and SysTick timer
		LDR  r1, =SysTick_BASE
		
		LDR	 r2, [r1, #SysTick_CTRL]
		BIC  r2, r2, #1					; Clear ENABLE
		STR  r2, [r1, #SysTick_CTRL]
		
		LDR	 r2, [r1, #SysTick_CTRL]
		BIC  r2, r2, #1<<1				; Disable SysTick interrupt
		STR  r2, [r1, #SysTick_CTRL]
		
		; Select clock source
		LDR	 r2, [r1, #SysTick_CTRL]
		BIC  r2, r2, #1<<2				; Select external clock
		STR  r2, [r1, #SysTick_CTRL]
		
		; Select SysTick_LOAD and specify the number of clock cycles
		; between two interrupts
		LDR  r3, =262					; Change based on interval
		STR  r3, [r1, #SysTick_LOAD]
		
		; Clear SysTick current value register (SysTick_VAL)
		MOV  r2, #0
		STR  r2, [r1, #SysTick_VAL]
		
		; Set interrupt priority for SysTick
		LDR  r3, =NVIC_BASE
		LDR	 r4, [r3, #NVIC_IPR0]
		BIC  r4, r4, #0xFF	
		STR  r4, [r3, #NVIC_IPR0]
		
		; Set SysTick_CTRL to start SysTick timer and enable SysTick interrupt
		LDR	 r2, [r1, #SysTick_CTRL]
		ORR  r2, r2, #1					; Start SysTick counter timer
		STR  r2, [r1, #SysTick_CTRL]
		
		LDR	 r2, [r1, #SysTick_CTRL]
		ORR  r2, r2, #1<<1				; Enable SysTick interrupt
		STR  r2, [r1, #SysTick_CTRL]
		BX   LR
		ENDP
SysTick_Handler  PROC
		EXPORT SysTick_Handler
		; Auto-stacking eight registers r0-r3, r12, LR, PSR, and PC
		SUB  r10, r10, #1				; Decrement TimingDelay
		BX   LR							; Exit and trigger auto-unstacking
		ENDP
delay	PROC
		; r0 is the TimingDelay input
		MOV  r10, r0					; Make a copy of TimingDelay
loop	CMP  r10, #0					; Wait for TimingDelay = 0
		BNE  loop						; r0 is decremented periodically by SysTick handler
		BX   LR							; Exit
		ENDP
		END
