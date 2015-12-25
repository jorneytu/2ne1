#!/bin/gvim

$ IT(if-then) instruction is not supported

$ 31 64-bit registers	(X0 ~ X30)
   ----	---- ---- ----
  | S0 | S1 | S2 | S3 | ---> Wn
   --------- ---------
  |   D0    |   D1    | ==> ....
   -------------------
  |        Q0         | --->Xn
   -------------------

$ Has core condition flags NZCV

$ one-way barriers instruction: LDAR & STLR

$ IFU (instruction Fetch Unit): instruction cache controller

$ SCU (Snoop Control Unit): connect the cores to external memory system

$ CPSR J&T bit encoding (instruction set supported)
   --- --- --------
  |	J | T |  state |
   --- --- --------
  | 0 | 0 |   A32  |
   --- --- --------
  |	0 | 1 |   T32  |
   --- --- --------

$ Exception level

	low
 	|-- EL0: Applications.
 	|-- EL1: OS kernel and associated functions that are typically described as privileged.
 	|-- EL2: Hypervisor.
 	|-- EL3: Secure monitor.
	high

	• Taking an exception to a higher exception level.
	• Returning from an exception to a lower exception level. ==> ERET

$(XXOO) L1 & L2 Data Cache can not disable independently. They are controled by the same enable.

$  • ARMv8-A does not support an operation to invalidate the entire data cache.
   • Must execute a series of instruction to invalidate the entire cache.
   • Processor can automatically invalidate the entire cache on reset.

$ Registers
	ctr_el0: info about the architecture of caches;
	dczid_el0:  ;
	cntfrq_el0: system count clock frequency;
	cntpct_el0: physical timer count ;
	cntvct_el0: virtual timer count ;
	esr_elx: exception state register ;

	(RVBAR_ELx) : execution start address when reset(RO)
	(ESR_ELx)  	: hold the information for exceptions taken to

$ ARMv8
  * 31 general-purpose registers(W0-W30/X0-X30);
  * 32 SIMD & floating-point registers (Q0-Q31/D0-D31/...);
  * ==> X30 used as procedure link registers;
  * 64-bit PC, SP, ELR(Exception link);
  * SP alignment to a 16-byte boundary is configurable at EL1;
  * Reading the zero register XZR

              NZCV: msr <Xt>, nzcv              -- ^
                                                   |
              DAIF: msr <Xt>, daif              -- ^
                                                   |==>|--> PSTATE;
              CurrentEL: msr <Xt>, CurrentEL    -- ^
                                                   |
              SPSel: Msr <Xt>, SPSel            -- ^

  * PoU (Point of Unification):The point at which the instruction cache, data cache, and translation table walks of a particular PE
     						 are guaranteed to see the same copy of a memory
							 location; { eg. L2 Cache }

  * PoC (Point of Coherency)  : The point at which all agents that can access memory are guaranteed to see the same copy of a
							  memory location; { eg. main memory }

  * A misaligned < PC > is when bits[1:0] of the PC are not 0b00;
  * A misaligned < SP > is when bits[3:0] of the SP are not 0b0000;
  * Warm Reset: mov wx, #3; msr RMR_ELx, wx;

$  When an exception is taken from an Exception level using AArch32 to an Exception
   level using AArch64, the top 32 bits of the modified ELR_ELx are 0.

$ The Exception state (AArch64 & AArch32)
  • The PE can change Execution states only either:
  => At reset.(register RMR_ELx.AA64)
  => On a change of Exception level.

$ (Security state)
  Secure state When 'in' this state, the PE can access both the Secure physical address space and the
  Non-secure physical address space.
  Non-secure state When 'in' this state, the PE:
  • Can access only the Non-secure physical address space.
  • Cannot access the Secure system control resources.

$ EL0 & EL1 must, EL2 & EL3 are optional.
	* When the highest level is configured to be AArch64 state, 'then' after a Cold reset execution starts
	  at the reset vector 'in' that Exception level.
	* (On a reset), the PE enters the (highest) implemented Exception level.
	* The t and h suffixes are based on the terminology of thread and handler, introduced 'in' ARMv7-M.

$ The selected stack pointer can be indicated by a suffix to the Exception level:
	t -  Indicates use of the SP_EL0 stack pointer.
	h -  Indicates use of the SP_ELx stack pointer.

$ Information about the Exception level that the exception came from, combined with information about the
  stack pointer 'in' use, and the state of the register file.

$ Thread & Handler mode;
  * Running unprivileged means the processor is 'in' Thread mode.
  * Thread mode is the fundamental mode 'for' application execution 'in' ARMv7-M and is selected on reset. Thread mode
  execution can be unprivileged or privileged. Thread mode can raise a supervisor call using the SVC instruction,
  generating a Supervisor Call (SVCall) exception that the processor takes 'in' Handler mode. Alternatively, Thread
  mode can handle system access and control directly.

  * All exceptions execute 'in' Handler mode. SVCall handlers manage resources, such as interaction with peripherals,
  memory allocation and management of software stacks, on behalf of the application.

$ SCTLR_ELx.SA0 control whether SP must be aligned when used as a base register .

$ In EL0, the stack pointer, (SP), (maps) to the (SP_EL0) stack pointer register.
  * Taking an exception selects the default stack pointer 'for' the target exception level, meaning SP maps to the SP_ELx
  stack pointer register, where x is the exception level.

$ Cortex-A53 supports EL0 ~ EL3, so , on powerup and on reset, the processor enters EL3, the highest exception level.

$ (MOESI) Cortex-A53 processor uses the MOESI protocol to maintain data coherency between multiple cores.
	The DCU stores the MOESI state of the cache line 'in' the tag and dirty RAMs.

$ The local monitor is 'in' the Exclusive Access state after the exclusive load, remains 'in' the Exclusive Access
	state after the store, and returns to the Open Access state only after the exclusive store, a CLREX instruction,
	or an exception return.(ldx & stx used for spinlock).

$ If the DC ZVA instruction misses 'in' the cache, it clears main memory, without causing an L1 or L2 cache allocation.

$ TBL
	4KB:  section [ 2M ]; page [ 4K ] ; entry [ 512 ]
	16KB: section [ 34M ]; page [ 16K ]; entry [ 2K ]
	64KB: section [ 512M ]; page [ 64K ]; entry [ 8K ]

	level x: 可以存放level x+1 的table地址或者是output address;
	所以层次结构是:( 4KB )
		(----------------------) -------------------------------------> level 0 ( 512G - max )
     	|  level-1-0 tab_addr  | ------^
     	^                      ^       |
     	|  level-1-1 tab_addr  | ----------^
     	^                      ^       |   |
     	|  level-1-2 tab_addr  |       |   |
     	^                      ^       |   |
     	|         ...          |       |   |
     	(----------------------) <-----^   | --------------------------> level 1 ( 1G - 512G )
     	|  level-2-0 tab_addr  |           |
     	^                      ^           |
     	|  level-2-1 tab_addr  |           |
     	^					   ^           |
     	|  level-2-2 tab_addr  |           |
     	^                      ^           |
     	|  level-2-3 tab_addr  |           |
     	^     	  ...		   ^           |
     	|         ...          |           |
     	^----------------------^ <---------^
     	|         ...          |
		|         ...          |
		|         ...          |
     	(----------------------) -------------------------------------> level 2( 2M - 1G )
     	|         ...          |
     	(----------------------) -------------------------------------> level 3( 4K - 2M )
     	|         ...          |
     	(----------------------) -------------------------------------> end

		(ATTR)
		PMD_TYPE_TABLE: next level table address;
		PMD_TYPE_SECT : output address;

		MT_DEVICE_NGNRNE: not application; Non-cacheable;
		MT_NORMAL: for memory; cacheable...;

$(instruction)
SMC
	Generate exception targeting Exception level 3 (SCR_EL3.SMD = 0)
SVC
	Generate exception targeting Exception level 1
HVC
	Generate exception targeting Exception level 2 (SCR_EL3.HCE = 1)


$ EL0 can execute Cache instruction by higher exception enable. #page-1701

$ ARMv8-A allow non-cacheable access to held 'in' (instruction cache. #page-73)

$ EL0, EL1 & EL2 ==> support only non-secure state
  EL0, EL1 & EL3 ==> virtualization not supported (EL2 control virtualization support)
  EL0, EL1       ==> either secure state or non-secure supported #page-1620

$ I-Cache invalidate all
  (IC IALLU  ) for uniprocessor
  (IC IALLUIS) for multiprocessor

$(General Interrupt Control - GIC )
	Group 0: 			expect at EL3, is always as an FIQ.
	Secure Group 1:		expect at Secure EL1                   -->
	Non-sec Group 1:	expect at Non-sec EL2 or Non-sec EL1   -->  FIQ or IRQ

	$(GICD_CTRL.DS) indicates whether a GIC is configured to support the ARMv8-A
	Security mode #page-58

	$(GICD_IROUTER<n>): provide routing information for SPI with INTID (when
	affinity is enable) #page-436

$ If, on taking or returning from an exception, the Exception level remains the
	same, the Execution state cannot change.

https://github.com/ARM-software/arm-trusted-firmware/blob/master/docs/firmware-design.md




