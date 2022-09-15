
;CodeVisionAVR C Compiler V3.37 Evaluation
;(C) Copyright 1998-2019 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATtiny13
;Program type           : Application
;Clock frequency        : 4,800000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 18 byte(s)
;Heap size              : 8 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Automatic register allocation for global variables: On
;Smart register allocation: Off

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny13
	#pragma AVRPART MEMORY PROG_FLASH 1024
	#pragma AVRPART MEMORY EEPROM 64
	#pragma AVRPART MEMORY INT_SRAM SIZE 64
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x009F
	.EQU __DSTACK_SIZE=0x0012
	.EQU __HEAP_SIZE=0x0008
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _brightness_level_percent=R4
	.DEF _control_buttons_status=R5
	.DEF _control_buttons_update=R6
	.DEF _signal_polarity=R7
	.DEF _interrupt_flag_polarity=R8
	.DEF _width_percent=R9
	.DEF _pwm_sm=R10
	.DEF _inited_flag=R11

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _exterInt0
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _PWM_tim0_CompA
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x3C,0x0,0x0

;HEAP START MARKER INITIALIZATION
__HEAP_START_MARKER:
	.DW  0,0


__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x04
	.DW  0x98
	.DW  __HEAP_START_MARKER*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM
	ADIW R30,1
	MOV  R24,R0
	LPM
	ADIW R30,1
	MOV  R25,R0
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM
	ADIW R30,1
	MOV  R26,R0
	LPM
	ADIW R30,1
	MOV  R27,R0
	LPM
	ADIW R30,1
	MOV  R1,R0
	LPM
	ADIW R30,1
	MOV  R22,R30
	MOV  R23,R31
	MOV  R31,R0
	MOV  R30,R1
__GLOBAL_INI_LOOP:
	LPM
	ADIW R30,1
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOV  R30,R22
	MOV  R31,R23
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x72

	.CSEG
;//#define F_CPU 4800000UL
;//#define __AVR_ATtiny13__
;
;#include <PWM.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <AVR_gpio.h>
;
;
;uint8_t brightness_level_percent = 0;
;uint8_t control_buttons_status = 0; /* 0 - no used; 1 - brightnes up; 2 - brightnes down; 3 - pressing two buttons */
;uint8_t control_buttons_update = 0;
;
;
;void initializationDefolt(void);
;void EEPROM_write(unsigned int uiAddress, unsigned char ucData);
;unsigned char EEPROM_read(unsigned int uiAddress);
;void Brightnes_Poll(void);
;uint8_t Check_Button(void);
;
;void initializationDefolt(void)
; 0000 0014 {

	.CSEG
_initializationDefolt:
; .FSTART _initializationDefolt
; 0000 0015 	brightness_level_percent = EEPROM_read(0x00);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _EEPROM_read
	MOV  R4,R30
; 0000 0016      // Declare your local variables here
; 0000 0017 
; 0000 0018     // Crystal Oscillator division factor: 1
; 0000 0019     #pragma optsize-
; 0000 001A     CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 001B     CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 001C     #ifdef _OPTIMIZE_SIZE_
; 0000 001D     #pragma optsize+
; 0000 001E     #endif
; 0000 001F 
; 0000 0020     // Input/Output Ports initialization
; 0000 0021     // Port B initialization
; 0000 0022     // Function: Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0023     DDRB=(0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(1)
	OUT  0x17,R30
; 0000 0024     // State: Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0025     PORTB=(0<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(27)
	OUT  0x18,R30
; 0000 0026 
; 0000 0027     // External Interrupt(s) initialization
; 0000 0028     // INT0: On
; 0000 0029     // INT0 Mode: Falling Edge
; 0000 002A     // Interrupt on any change on pins PCINT0-5: Off
; 0000 002B     GIMSK=(1<<INT0) | (0<<PCIE);
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 002C     MCUCR=(1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 002D     GIFR=(1<<INTF0) | (0<<PCIF);
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 002E 
; 0000 002F     // Analog Comparator initialization
; 0000 0030     // Analog Comparator: Off
; 0000 0031     // The Analog Comparator's positive input is
; 0000 0032     // connected to the AIN0 pin
; 0000 0033     // The Analog Comparator's negative input is
; 0000 0034     // connected to the AIN1 pin
; 0000 0035     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0036     ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0037     // Digital input buffer on AIN0: On
; 0000 0038     // Digital input buffer on AIN1: On
; 0000 0039     DIDR0=(0<<AIN0D) | (0<<AIN1D);
	OUT  0x14,R30
; 0000 003A 
; 0000 003B     // ADC initialization
; 0000 003C     // ADC disabled
; 0000 003D     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 003E }
	RET
; .FEND
;
;void main()
; 0000 0041 {
_main:
; .FSTART _main
; 0000 0042     #asm("cli")
	CLI
; 0000 0043     initializationDefolt();
	RCALL _initializationDefolt
; 0000 0044 	PWM_Init();
	RCALL _PWM_Init
; 0000 0045     #asm("sei")
	SEI
; 0000 0046 
; 0000 0047     while (1)
_0x3:
; 0000 0048     {
; 0000 0049 		Brightnes_Poll();
	RCALL _Brightnes_Poll
; 0000 004A 		PWM_StateMachine();
	RCALL _PWM_StateMachine
; 0000 004B     }
	RJMP _0x3
; 0000 004C }
_0x6:
	RJMP _0x6
; .FEND
;
;void EEPROM_write(unsigned int uiAddress, unsigned char ucData)
; 0000 004F {
_EEPROM_write:
; .FSTART _EEPROM_write
; 0000 0050 	while(EECR & (1<<EEPE));
	RCALL __SAVELOCR3
	MOV  R16,R26
	__GETWRS 17,18,3
;	uiAddress -> R17,R18
;	ucData -> R16
_0x7:
	SBIC 0x1C,1
	RJMP _0x7
; 0000 0051 	EEAR = uiAddress;
	OUT  0x1E,R17
; 0000 0052 	EEDR = ucData;
	OUT  0x1D,R16
; 0000 0053 	EECR |= (1<<EEMPE);
	SBI  0x1C,2
; 0000 0054 	EECR |= (1<<EEPE);
	SBI  0x1C,1
; 0000 0055 }
	RCALL __LOADLOCR3
	ADIW R28,5
	RET
; .FEND
;
;unsigned char EEPROM_read(unsigned int uiAddress)
; 0000 0058 {
_EEPROM_read:
; .FSTART _EEPROM_read
; 0000 0059 	while(EECR & (1<<EEWE));
	RCALL __SAVELOCR2
	__PUTW2R 16,17
;	uiAddress -> R16,R17
_0xA:
	SBIC 0x1C,1
	RJMP _0xA
; 0000 005A 	EEAR = uiAddress;
	OUT  0x1E,R16
; 0000 005B 	EECR |= (1<<EERE);
	SBI  0x1C,0
; 0000 005C 	return EEDR;
	IN   R30,0x1D
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 005D }
; .FEND
;
;
;
;void Brightnes_Poll(void)
; 0000 0062 {
_Brightnes_Poll:
; .FSTART _Brightnes_Poll
; 0000 0063 	if(control_buttons_update)
	TST  R6
	BREQ _0xD
; 0000 0064 	{
; 0000 0065 		switch(control_buttons_status)
	MOV  R30,R5
	LDI  R31,0
; 0000 0066 		{
; 0000 0067 			case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x11
; 0000 0068 			{
; 0000 0069 				if(PWM_Get_PulseWidth() > 20)
	RCALL _PWM_Get_PulseWidth
	CPI  R30,LOW(0x15)
	BRLO _0x12
; 0000 006A 				{
; 0000 006B 					PWM_PulseWidth_Sub(20);
	LDI  R26,LOW(20)
	RCALL _PWM_PulseWidth_Sub
; 0000 006C 				}
; 0000 006D 				break;
_0x12:
	RJMP _0x10
; 0000 006E 			}
; 0000 006F 			case 2:
_0x11:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x13
; 0000 0070 			{
; 0000 0071 				if(PWM_Get_PulseWidth() < 100)
	RCALL _PWM_Get_PulseWidth
	CPI  R30,LOW(0x64)
	BRSH _0x14
; 0000 0072 				{
; 0000 0073 					PWM_PulseWidth_Add(20);
	LDI  R26,LOW(20)
	RCALL _PWM_PulseWidth_Add
; 0000 0074 				}
; 0000 0075 				break;
_0x14:
	RJMP _0x10
; 0000 0076 			}
; 0000 0077 			case 3:
_0x13:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x16
; 0000 0078 			{
; 0000 0079 				EEPROM_write(0x00, PWM_Get_PulseWidth());
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _PWM_Get_PulseWidth
	MOV  R26,R30
	RCALL _EEPROM_write
; 0000 007A 				break;
	RJMP _0x10
; 0000 007B 			}
; 0000 007C 			default:
_0x16:
; 0000 007D 			{
; 0000 007E 				control_buttons_status = 0;
	CLR  R5
; 0000 007F 				return;
	RET
; 0000 0080 			}
; 0000 0081 		}
_0x10:
; 0000 0082 		control_buttons_update = 0;
	CLR  R6
; 0000 0083 		control_buttons_status = 0;
	CLR  R5
; 0000 0084 
; 0000 0085 		//OCR0A = (brightness_level_percent * 0xFF) / 100;
; 0000 0086 	}
; 0000 0087 }
_0xD:
	RET
; .FEND
;
;uint8_t Check_Button(void)
; 0000 008A {
_Check_Button:
; .FSTART _Check_Button
; 0000 008B     if(((~PINB) & GPIO_Pin_3) && ((~PINB) & GPIO_Pin_4))
	RCALL SUBOPT_0x0
	ANDI R30,LOW(0x8)
	BREQ _0x18
	RCALL SUBOPT_0x0
	ANDI R30,LOW(0x10)
	BRNE _0x19
_0x18:
	RJMP _0x17
_0x19:
; 0000 008C     {
; 0000 008D         return 3;
	LDI  R30,LOW(3)
	RET
; 0000 008E     }
; 0000 008F     else
_0x17:
; 0000 0090     {
; 0000 0091         if((~PINB) & GPIO_Pin_3)
	RCALL SUBOPT_0x0
	ANDI R30,LOW(0x8)
	BREQ _0x1B
; 0000 0092         {
; 0000 0093             return 1;
	LDI  R30,LOW(1)
	RET
; 0000 0094         }
; 0000 0095         else
_0x1B:
; 0000 0096         {
; 0000 0097             if((~PINB) & GPIO_Pin_4)
	RCALL SUBOPT_0x0
	ANDI R30,LOW(0x10)
	BREQ _0x1D
; 0000 0098             {
; 0000 0099                 return 2;
	LDI  R30,LOW(2)
	RET
; 0000 009A             }
; 0000 009B         }
_0x1D:
; 0000 009C     }
; 0000 009D     return 0;
	LDI  R30,LOW(0)
	RET
; 0000 009E }
; .FEND
;
;interrupt [EXT_INT0] void exterInt0(void)
; 0000 00A1 {
_exterInt0:
; .FSTART _exterInt0
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A2 	control_buttons_status = Check_Button();
	RCALL _Check_Button
	MOV  R5,R30
; 0000 00A3 
; 0000 00A4 	control_buttons_update = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 00A5 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;
;#include "PWM.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "AVR_gpio.h"
;
;
;typedef enum
;{
;	DUTY_NORMAL = 0,
;	DUTY_100_PERCENT = 1,
;	DUTY_0_PERCENT = 2
;}PWM_STATE_MACHINE;
;
;
;uint8_t signal_polarity = 0;
;uint8_t interrupt_flag_polarity = 0;
;uint8_t width_percent = 60;
;//uint8_t pwm_pulse_width = 0;
;PWM_STATE_MACHINE pwm_sm = DUTY_NORMAL;
;uint8_t inited_flag = 0;
;
;void PWM_DeInit(void);
;
;void PWM_Init(void)
; 0002 0017 {

	.CSEG
_PWM_Init:
; .FSTART _PWM_Init
; 0002 0018 	if(inited_flag)
	TST  R11
	BREQ _0x40003
; 0002 0019 	{
; 0002 001A 		return;
	RET
; 0002 001B 	}
; 0002 001C 
; 0002 001D 	// Timer/Counter 0 initialization
; 0002 001E 	// Clock source: System Clock
; 0002 001F 	// Clock value: Timer 0 Stopped
; 0002 0020 	// Mode: Normal top=0xFF
; 0002 0021 	// OC0A output: Disconnected
; 0002 0022 	// OC0B output: Disconnected
; 0002 0023 	TCCR0A=(0<<COM0A1) | (1<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (0<<WGM00);
_0x40003:
	LDI  R30,LOW(66)
	OUT  0x2F,R30
; 0002 0024 	TCCR0B=(0<<WGM02) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0002 0025 	TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0002 0026 	OCR0B=0x00;
	OUT  0x29,R30
; 0002 0027 	if(width_percent == 0xFF)
	LDI  R30,LOW(255)
	CP   R30,R9
	BRNE _0x40004
; 0002 0028 	{
; 0002 0029 		width_percent = 60;
	LDI  R30,LOW(60)
	MOV  R9,R30
; 0002 002A 	}
; 0002 002B 	OCR0A = 74;
_0x40004:
	LDI  R30,LOW(74)
	OUT  0x36,R30
; 0002 002C 	signal_polarity = 0;
	CLR  R7
; 0002 002D 
; 0002 002E 	// Timer/Counter 0 Interrupt(s) initialization
; 0002 002F 	TIMSK0=(0<<OCIE0B) | (1<<OCIE0A) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0002 0030 
; 0002 0031 	inited_flag = 1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0002 0032 }
	RET
; .FEND
;
;void PWM_DeInit(void)
; 0002 0035 {
_PWM_DeInit:
; .FSTART _PWM_DeInit
; 0002 0036 	inited_flag = 0;
	CLR  R11
; 0002 0037 
; 0002 0038 	interrupt_flag_polarity = 0;
	CLR  R8
; 0002 0039 	signal_polarity = 0;
	CLR  R7
; 0002 003A 	TIMSK0 &= ~(1<<OCIE0A);
	IN   R30,0x39
	ANDI R30,0xFB
	OUT  0x39,R30
; 0002 003B 	TCCR0A &= ~(1<<WGM01);
	IN   R30,0x2F
	ANDI R30,0xFD
	OUT  0x2F,R30
; 0002 003C 	TCCR0A &= ~(1<<WGM00);
	IN   R30,0x2F
	ANDI R30,0xFE
	OUT  0x2F,R30
; 0002 003D 	TCCR0A &= ~(1<<COM0A1);
	IN   R30,0x2F
	ANDI R30,0x7F
	OUT  0x2F,R30
; 0002 003E 	TCCR0A &= ~(1<<COM0A0);
	IN   R30,0x2F
	ANDI R30,0xBF
	OUT  0x2F,R30
; 0002 003F 	TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0002 0040 }
	RET
; .FEND
;
;void PWM_StateMachine(void)
; 0002 0043 {
_PWM_StateMachine:
; .FSTART _PWM_StateMachine
; 0002 0044 	if(width_percent == 0)
	TST  R9
	BRNE _0x40005
; 0002 0045 	{
; 0002 0046 		pwm_sm = DUTY_0_PERCENT;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0002 0047 	}
; 0002 0048 	else
	RJMP _0x40006
_0x40005:
; 0002 0049 	{
; 0002 004A 		if(width_percent == 100)
	LDI  R30,LOW(100)
	CP   R30,R9
	BRNE _0x40007
; 0002 004B 		{
; 0002 004C 			pwm_sm = DUTY_100_PERCENT;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0002 004D 		}
; 0002 004E 		else
	RJMP _0x40008
_0x40007:
; 0002 004F 		{
; 0002 0050 			pwm_sm = DUTY_NORMAL;
	CLR  R10
; 0002 0051 		}
_0x40008:
; 0002 0052 	}
_0x40006:
; 0002 0053 
; 0002 0054 	switch(pwm_sm)
	MOV  R30,R10
	LDI  R31,0
; 0002 0055 	{
; 0002 0056 		case DUTY_NORMAL:
	SBIW R30,0
	BRNE _0x4000C
; 0002 0057 		{
; 0002 0058 			PWM_Init();
	RCALL _PWM_Init
; 0002 0059 
; 0002 005A 			if(interrupt_flag_polarity)
	TST  R8
	BREQ _0x4000D
; 0002 005B 			{
; 0002 005C 				if(signal_polarity == 1)
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x4000E
; 0002 005D 				{
; 0002 005E 					OCR0A = (width_percent * 74) / 100;
	MOV  R26,R9
	LDI  R27,0
	RJMP _0x40012
; 0002 005F 				}
; 0002 0060 				else
_0x4000E:
; 0002 0061 				{
; 0002 0062 					OCR0A = ((100 - width_percent) * 74) / 100;
	MOV  R30,R9
	LDI  R31,0
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	SUB  R26,R30
	SBC  R27,R31
_0x40012:
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	RCALL __MULW12
	MOV  R26,R30
	MOV  R27,R31
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	OUT  0x36,R30
; 0002 0063 				}
; 0002 0064 				interrupt_flag_polarity = 0;
	CLR  R8
; 0002 0065 			}
; 0002 0066 
; 0002 0067 			break;
_0x4000D:
	RJMP _0x4000B
; 0002 0068 		}
; 0002 0069 		case DUTY_0_PERCENT:
_0x4000C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x40010
; 0002 006A 		{
; 0002 006B 			PWM_DeInit();
	RCALL _PWM_DeInit
; 0002 006C 			PORTB &= ~GPIO_Pin_1;
	CBI  0x18,1
; 0002 006D 			break;
	RJMP _0x4000B
; 0002 006E 		}
; 0002 006F 		case DUTY_100_PERCENT:
_0x40010:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4000B
; 0002 0070 		{
; 0002 0071 			PWM_DeInit();
	RCALL _PWM_DeInit
; 0002 0072 			PORTB |= GPIO_Pin_1;
	SBI  0x18,1
; 0002 0073 			break;
; 0002 0074 		}
; 0002 0075 	}
_0x4000B:
; 0002 0076 
; 0002 0077 }
	RET
; .FEND
;
;void PWM_PulseWidth_Add(uint8_t value)
; 0002 007A {
_PWM_PulseWidth_Add:
; .FSTART _PWM_PulseWidth_Add
; 0002 007B 	width_percent += value;
	ST   -Y,R16
	MOV  R16,R26
;	value -> R16
	ADD  R9,R16
; 0002 007C }
	RJMP _0x2000001
; .FEND
;
;void PWM_PulseWidth_Sub(uint8_t value)
; 0002 007F {
_PWM_PulseWidth_Sub:
; .FSTART _PWM_PulseWidth_Sub
; 0002 0080 	width_percent -= value;
	ST   -Y,R16
	MOV  R16,R26
;	value -> R16
	SUB  R9,R16
; 0002 0081 }
_0x2000001:
	LD   R16,Y+
	RET
; .FEND
;
;void PWM_WidthPercent_Set(uint8_t new_value)
; 0002 0084 {
; 0002 0085 	width_percent = new_value;
;	new_value -> R16
; 0002 0086 }
;
;uint8_t PWM_Get_PulseWidth(void)
; 0002 0089 {
_PWM_Get_PulseWidth:
; .FSTART _PWM_Get_PulseWidth
; 0002 008A 	return width_percent;
	MOV  R30,R9
	RET
; 0002 008B }
; .FEND
;
;interrupt [TIM0_COMPA] void PWM_tim0_CompA(void)
; 0002 008E {
_PWM_tim0_CompA:
; .FSTART _PWM_tim0_CompA
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0002 008F 	signal_polarity ^= 0x01;
	LDI  R30,LOW(1)
	EOR  R7,R30
; 0002 0090 
; 0002 0091 	interrupt_flag_polarity = 1;
	MOV  R8,R30
; 0002 0092 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	IN   R30,0x16
	COM  R30
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	LDI  R24,17
	CLR  R0
	SUB  R1,R1
	RJMP __MULW12U1
__MULW12U3:
	BRCC __MULW12U2
	ADD  R0,R26
	ADC  R1,R27
__MULW12U2:
	LSR  R1
	ROR  R0
__MULW12U1:
	ROR  R31
	ROR  R30
	DEC  R24
	BRNE __MULW12U3
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOV  R30,R26
	MOV  R31,R27
	MOV  R26,R0
	MOV  R27,R1
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

;END OF CODE MARKER
__END_OF_CODE:
