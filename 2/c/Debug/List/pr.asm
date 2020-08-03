
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega64
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	MOVW R30,R0
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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
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
	MOVW R26,R28
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
	MOVW R26,R28
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R4
	.DEF _i_msb=R5
	.DEF _j=R6
	.DEF _j_msb=R7
	.DEF _D=R9
	.DEF _V=R8
	.DEF _C=R11
	.DEF _asm=R10
	.DEF __lcd_x=R13
	.DEF __lcd_y=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x0,0x0,0x0
	.DB  0x50,0x10,0x1,0x0

_0x3:
	.DB  0x6E,0x6E,0x6E,0x6E,0x6E,0x6E,0x6E,0x6E
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x08
	.DW  _data
	.DW  _0x3*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;//HOSSEIN___GHOLAMI 9321043
;
;//LIBRARIS
;#include <mega64.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;
;//DEFENITIONS
;#define ME1 PORTB.3   // EN OF MOTOR 1 (LEFT)
;#define ME2 PORTB.2   //EN OF MOTOR 2 (RIGHT)
;#define SR1 OCR1CL    //SPEED (PWM DUTY CYCLE) OF M1 ROTATING FORWARD
;#define SL1 OCR1BL    //SPEED (PWM DUTY CYCLE) OF M1 ROTATING BACKWARD
;#define SR2 OCR1AL    //SPEED (PWM DUTY CYCLE) OF M2 ROTATING FORWARD
;#define SL2 OCR0      //SPEED (PWM DUTY CYCLE) OF M2 ROTATING BACKWARD
;#define CB PORTB.0  //Config of bluetooth
;
; int i=1; // USE AS COUNTER
; int j=0;
;
; char data[]={'n','n','n','n','n','n','n','n'}; // USE AS BUFFER

	.DSEG
;  unsigned char D = 0x10;
;  unsigned char V = 0x50;
;  unsigned char C = 0;
;  unsigned char asm = 1;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 001D {  lcd_gotoxy(0,0);

	.CSEG
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
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
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 001E    data[i]=UDR0;    //daryaft data
	MOVW R26,R4
	SUBI R26,LOW(-_data)
	SBCI R27,HIGH(-_data)
	IN   R30,0xC
	ST   X,R30
; 0000 001F   i++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0020   if(data[i]==data[i-1]){         //etminan az nabood data tekrari
	LDI  R26,LOW(_data)
	LDI  R27,HIGH(_data)
	ADD  R26,R4
	ADC  R27,R5
	LD   R26,X
	SBIW R30,1
	SUBI R30,LOW(-_data)
	SBCI R31,HIGH(-_data)
	LD   R30,Z
	CP   R30,R26
	BRNE _0x4
; 0000 0021     i--;}
	MOVW R30,R4
	SBIW R30,1
	MOVW R4,R30
; 0000 0022 
; 0000 0023 
; 0000 0024  if (C==0){
_0x4:
	TST  R11
	BREQ PC+2
	RJMP _0x5
; 0000 0025         CB=1;
	SBI  0x18,0
; 0000 0026     if(data[1]=='O'&&data[2]=='K'){
	__GETB2MN _data,1
	CPI  R26,LOW(0x4F)
	BRNE _0x9
	__GETB2MN _data,2
	CPI  R26,LOW(0x4B)
	BREQ _0xA
_0x9:
	RJMP _0x8
_0xA:
; 0000 0027          j++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0028         lcd_putchar('O');
	LDI  R26,LOW(79)
	CALL SUBOPT_0x0
; 0000 0029 
; 0000 002A          if(j==1){
	CP   R30,R6
	CPC  R31,R7
	BRNE _0xB
; 0000 002B          putchar('A');
	CALL SUBOPT_0x1
; 0000 002C          putchar('T');
; 0000 002D          putchar('+');
; 0000 002E          putchar('N');
	LDI  R26,LOW(78)
	CALL _putchar
; 0000 002F          putchar('A');
	LDI  R26,LOW(65)
	CALL _putchar
; 0000 0030          putchar('M');
	LDI  R26,LOW(77)
	CALL _putchar
; 0000 0031          putchar('E');
	LDI  R26,LOW(69)
	CALL _putchar
; 0000 0032          putchar('=');
	LDI  R26,LOW(61)
	CALL _putchar
; 0000 0033          putchar('H');
	LDI  R26,LOW(72)
	CALL _putchar
; 0000 0034          putchar('G');
	LDI  R26,LOW(71)
	CALL _putchar
; 0000 0035          putchar('H');
	LDI  R26,LOW(72)
	CALL SUBOPT_0x2
; 0000 0036          putchar('\r');
; 0000 0037          putchar('\n');
; 0000 0038            }
; 0000 0039        if(j==2){
_0xB:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0xC
; 0000 003A          putchar('A');
	CALL SUBOPT_0x1
; 0000 003B          putchar('T');
; 0000 003C          putchar('+');
; 0000 003D          putchar('P');
	LDI  R26,LOW(80)
	CALL _putchar
; 0000 003E          putchar('S');
	LDI  R26,LOW(83)
	CALL _putchar
; 0000 003F          putchar('W');
	LDI  R26,LOW(87)
	CALL _putchar
; 0000 0040          putchar('D');
	LDI  R26,LOW(68)
	CALL _putchar
; 0000 0041          putchar('=');
	LDI  R26,LOW(61)
	CALL _putchar
; 0000 0042          putchar('1');
	LDI  R26,LOW(49)
	CALL _putchar
; 0000 0043          putchar('2');
	LDI  R26,LOW(50)
	CALL _putchar
; 0000 0044          putchar('3');
	LDI  R26,LOW(51)
	CALL SUBOPT_0x2
; 0000 0045          putchar('\r');
; 0000 0046          putchar('\n');
; 0000 0047 
; 0000 0048          C=1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0049          }
; 0000 004A 
; 0000 004B 
; 0000 004C     i=1;}
_0xC:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 004D 
; 0000 004E     if(data[1]=='E'||data[1]=='F'){
_0x8:
	__GETB2MN _data,1
	CPI  R26,LOW(0x45)
	BREQ _0xE
	__GETB2MN _data,1
	CPI  R26,LOW(0x46)
	BRNE _0xD
_0xE:
; 0000 004F          C=0;
	CLR  R11
; 0000 0050          j=0;
	CLR  R6
	CLR  R7
; 0000 0051     lcd_putchar('R');
	LDI  R26,LOW(82)
	CALL SUBOPT_0x0
; 0000 0052 
; 0000 0053     i=1;}
	MOVW R4,R30
; 0000 0054 
; 0000 0055       }
_0xD:
; 0000 0056 
; 0000 0057  if (C==1){
_0x5:
	LDI  R30,LOW(1)
	CP   R30,R11
	BREQ PC+2
	RJMP _0x10
; 0000 0058       CB=0;
	CBI  0x18,0
; 0000 0059   if(data[1]=='*'){
	__GETB2MN _data,1
	CPI  R26,LOW(0x2A)
	BRNE _0x13
; 0000 005A     i=1;}
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 005B 
; 0000 005C   //daryaft kilid 1-9
; 0000 005D    switch(data[1]) {
_0x13:
	__GETB1MN _data,1
	LDI  R31,0
; 0000 005E                 case '1':
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x17
; 0000 005F                     lcd_putchar('1');
	LDI  R26,LOW(49)
	CALL SUBOPT_0x0
; 0000 0060                     i=1;
	CALL SUBOPT_0x3
; 0000 0061                   ME1=0; ME2=1;
; 0000 0062                   SR1=0x00;SL1=0x00;
; 0000 0063                   SR2=V+D;SL2=0x00;
	MOV  R30,R9
	ADD  R30,R8
	OUT  0x2A,R30
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 0064                 break;
	RJMP _0x16
; 0000 0065                 case '2':
_0x17:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x1C
; 0000 0066                     lcd_putchar('2');
	LDI  R26,LOW(50)
	CALL SUBOPT_0x0
; 0000 0067                     i=1;
	CALL SUBOPT_0x4
; 0000 0068                   ME1=1; ME2=1;
; 0000 0069                   SR1=V;SL1=0;
; 0000 006A                   SR2=V;SL2=0;
	OUT  0x2A,R8
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 006B                 break;
	RJMP _0x16
; 0000 006C                 case '3':
_0x1C:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x21
; 0000 006D                     lcd_putchar('3');
	LDI  R26,LOW(51)
	CALL SUBOPT_0x0
; 0000 006E                     i=1;
	MOVW R4,R30
; 0000 006F                    ME1=1; ME2=0;
	SBI  0x18,3
	CBI  0x18,2
; 0000 0070                   SR1=V+D;SL1=0x00;
	MOV  R30,R9
	ADD  R30,R8
	STS  120,R30
	LDI  R30,LOW(0)
	OUT  0x28,R30
; 0000 0071                   SR2=0x00;SL2=0x00;
	OUT  0x2A,R30
	OUT  0x31,R30
; 0000 0072                break;
	RJMP _0x16
; 0000 0073                 case '4':
_0x21:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0x26
; 0000 0074                     lcd_putchar('4');
	LDI  R26,LOW(52)
	CALL SUBOPT_0x0
; 0000 0075                     i=1;
	CALL SUBOPT_0x4
; 0000 0076                   ME1=1; ME2=1;
; 0000 0077                   SR1=V;SL1=0;
; 0000 0078                   SR2=0;SL2=V;
	LDI  R30,LOW(0)
	OUT  0x2A,R30
	OUT  0x31,R8
; 0000 0079                break;
	RJMP _0x16
; 0000 007A                 case '5':
_0x26:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0x2B
; 0000 007B                     lcd_putchar('5');
	LDI  R26,LOW(53)
	CALL SUBOPT_0x0
; 0000 007C                     i=1;
	MOVW R4,R30
; 0000 007D                 break;
	RJMP _0x16
; 0000 007E                case '6':
_0x2B:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0x2C
; 0000 007F                     lcd_putchar('6');
	LDI  R26,LOW(54)
	CALL SUBOPT_0x0
; 0000 0080                     i=1;
	CALL SUBOPT_0x5
; 0000 0081                    ME1=1; ME2=1;
; 0000 0082                   SR1=0;SL1=V;
; 0000 0083                   SR2=V;SL2=0;
	OUT  0x2A,R8
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 0084                break;
	RJMP _0x16
; 0000 0085                case '7':
_0x2C:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0x31
; 0000 0086                     lcd_putchar('7');
	LDI  R26,LOW(55)
	CALL SUBOPT_0x0
; 0000 0087                     i=1;
	CALL SUBOPT_0x3
; 0000 0088                    ME1=0; ME2=1;
; 0000 0089                   SR1=0x00;SL1=0x00;
; 0000 008A                   SR2=0x00;SL2=V+D;
	LDI  R30,LOW(0)
	OUT  0x2A,R30
	MOV  R30,R9
	ADD  R30,R8
	OUT  0x31,R30
; 0000 008B                break;
	RJMP _0x16
; 0000 008C                case '8':
_0x31:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0x36
; 0000 008D                     lcd_putchar('8');
	LDI  R26,LOW(56)
	CALL SUBOPT_0x0
; 0000 008E                     i=1;
	CALL SUBOPT_0x5
; 0000 008F                  ME1=1; ME2=1;
; 0000 0090                   SR1=0;SL1=V;
; 0000 0091                   SR2=0;SL2=V;
	LDI  R30,LOW(0)
	OUT  0x2A,R30
	OUT  0x31,R8
; 0000 0092                 break;
	RJMP _0x16
; 0000 0093                case '9':
_0x36:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0x40
; 0000 0094                     lcd_putchar('9');
	LDI  R26,LOW(57)
	CALL SUBOPT_0x0
; 0000 0095                     i=1;
	MOVW R4,R30
; 0000 0096                  ME1=1; ME2=0;
	SBI  0x18,3
	CBI  0x18,2
; 0000 0097                   SR1=0x00;SL1=V+D;
	LDI  R30,LOW(0)
	STS  120,R30
	MOV  R30,R9
	ADD  R30,R8
	OUT  0x28,R30
; 0000 0098                   SR2=0x00;SL2=0x00;
	LDI  R30,LOW(0)
	OUT  0x2A,R30
	OUT  0x31,R30
; 0000 0099                break;
; 0000 009A               default:
_0x40:
; 0000 009B                 break;  }
_0x16:
; 0000 009C 
; 0000 009D    switch(data[3]) {                                             //daryaft clid channel
	__GETB1MN _data,3
	LDI  R31,0
; 0000 009E                 case '+':
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0x44
; 0000 009F                     lcd_putchar('D');
	LDI  R26,LOW(68)
	CALL _lcd_putchar
; 0000 00A0                     lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL SUBOPT_0x0
; 0000 00A1                     i=1;data[3]='n' ;
	MOVW R4,R30
	LDI  R30,LOW(110)
	__PUTB1MN _data,3
; 0000 00A2                     D++;
	INC  R9
; 0000 00A3                    if(D==255)D=254;
	LDI  R30,LOW(255)
	CP   R30,R9
	BRNE _0x45
	LDI  R30,LOW(254)
	MOV  R9,R30
; 0000 00A4                 break;
_0x45:
	RJMP _0x43
; 0000 00A5                 case '-':
_0x44:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0x48
; 0000 00A6                     lcd_putchar('c');
	LDI  R26,LOW(99)
	RCALL _lcd_putchar
; 0000 00A7                     lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL SUBOPT_0x0
; 0000 00A8                     i=1;data[3]='n';
	MOVW R4,R30
	LDI  R30,LOW(110)
	__PUTB1MN _data,3
; 0000 00A9                     D--;
	DEC  R9
; 0000 00AA                     if(D==0) D=1;
	TST  R9
	BRNE _0x47
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 00AB                 break;
_0x47:
; 0000 00AC               default:
_0x48:
; 0000 00AD                 break;  }
_0x43:
; 0000 00AE 
; 0000 00AF    switch(data[4]) {                                                     // daryaft clid volom
	__GETB1MN _data,4
	LDI  R31,0
; 0000 00B0                 case '+':
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0x4C
; 0000 00B1                     lcd_putchar('v');
	LDI  R26,LOW(118)
	RCALL _lcd_putchar
; 0000 00B2                     lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL SUBOPT_0x0
; 0000 00B3                     i=1;data[4]='n';data[3]='n';
	CALL SUBOPT_0x6
; 0000 00B4                     V++;
	INC  R8
; 0000 00B5                    if(V==255)V=254;
	LDI  R30,LOW(255)
	CP   R30,R8
	BRNE _0x4D
	LDI  R30,LOW(254)
	MOV  R8,R30
; 0000 00B6                 break;
_0x4D:
	RJMP _0x4B
; 0000 00B7                 case '-':
_0x4C:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0x50
; 0000 00B8                     lcd_putchar('v');
	LDI  R26,LOW(118)
	RCALL _lcd_putchar
; 0000 00B9                     lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL SUBOPT_0x0
; 0000 00BA                    i=1;data[4]='n';data[3]='n';
	CALL SUBOPT_0x6
; 0000 00BB                    V--;
	DEC  R8
; 0000 00BC                    if(V==0)V=1;
	TST  R8
	BRNE _0x4F
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 00BD               default:
_0x4F:
_0x50:
; 0000 00BE                 break;  }
_0x4B:
; 0000 00BF 
; 0000 00C0 
; 0000 00C1     if(data[1]!='*'||data[4]!='+'||data[4]!='-'||data[3]!='+'||data[3]!='-') delay_ms(100);  //andaki vaghfe baraye nabo ...
	__GETB2MN _data,1
	CPI  R26,LOW(0x2A)
	BRNE _0x52
	__GETB2MN _data,4
	CPI  R26,LOW(0x2B)
	BRNE _0x52
	__GETB2MN _data,4
	CPI  R26,LOW(0x2D)
	BRNE _0x52
	__GETB2MN _data,3
	CPI  R26,LOW(0x2B)
	BRNE _0x52
	__GETB2MN _data,3
	CPI  R26,LOW(0x2D)
	BREQ _0x51
_0x52:
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 00C2 
; 0000 00C3   SR1=0;SR2=0;SL1=0;SL2=0;
_0x51:
	LDI  R30,LOW(0)
	STS  120,R30
	OUT  0x2A,R30
	OUT  0x28,R30
	OUT  0x31,R30
; 0000 00C4   ME1=0;ME2=0;
	CBI  0x18,3
	CBI  0x18,2
; 0000 00C5  }
; 0000 00C6 
; 0000 00C7 }
_0x10:
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
;void main(void)
; 0000 00C9 {
_main:
; .FSTART _main
; 0000 00CA C=0;
	CLR  R11
; 0000 00CB // Port A initialization
; 0000 00CC DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00CD PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 00CE // Port B initialization
; 0000 00CF DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 00D0 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00D1 // Port C initialization
; 0000 00D2 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 00D3 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 00D4 // Port D initialization
; 0000 00D5 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 00D6 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 00D7 // Port E initialization
; 0000 00D8 DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	OUT  0x2,R30
; 0000 00D9 PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x3,R30
; 0000 00DA // Port F initialization
; 0000 00DB DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 00DC PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 00DD // Port G initialization
; 0000 00DE DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 00DF PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 00E0 
; 0000 00E1 // Timer/Counter 0 initialization
; 0000 00E2 // Clock source: System Clock
; 0000 00E3 // Clock value: 1000.000 kHz
; 0000 00E4 // Mode: Fast PWM top=0xFF
; 0000 00E5 // OC0 output: Non-Inverted PWM
; 0000 00E6 // Timer Period: 0.256 ms
; 0000 00E7 // Output Pulse(s):
; 0000 00E8 // OC0 Period: 0.256 ms Width: 0.080314 ms
; 0000 00E9 ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 00EA TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(106)
	OUT  0x33,R30
; 0000 00EB TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00EC OCR0=0x00;
	OUT  0x31,R30
; 0000 00ED 
; 0000 00EE // Timer/Counter 1 initialization
; 0000 00EF // Clock source: System Clock
; 0000 00F0 // Clock value: 1000.000 kHz
; 0000 00F1 // Mode: Fast PWM top=0x00FF
; 0000 00F2 // OC1A output: Non-Inverted PWM
; 0000 00F3 // OC1B output: Non-Inverted PWM
; 0000 00F4 // OC1C output: Non-Inverted PWM
; 0000 00F5 // Noise Canceler: Off
; 0000 00F6 // Input Capture on Falling Edge
; 0000 00F7 // Timer Period: 0.256 ms
; 0000 00F8 // Output Pulse(s):
; 0000 00F9 // OC1A Period: 0.256 ms Width: 0.080314 ms// OC1B Period: 0.256 ms Width: 0.080314 ms// OC1C Period: 0.256 ms Width:  ...
; 0000 00FA // Timer1 Overflow Interrupt: Off
; 0000 00FB // Input Capture Interrupt: Off
; 0000 00FC // Compare A Match Interrupt: Off
; 0000 00FD // Compare B Match Interrupt: Off
; 0000 00FE // Compare C Match Interrupt: Off
; 0000 00FF TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (1<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(169)
	OUT  0x2F,R30
; 0000 0100 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(10)
	OUT  0x2E,R30
; 0000 0101 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0102 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0103 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0104 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0105 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0106 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0107 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0108 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0109 OCR1CH=0x00;
	STS  121,R30
; 0000 010A OCR1CL=0x00;
	STS  120,R30
; 0000 010B 
; 0000 010C // Timer/Counter 2 initialization
; 0000 010D // Clock source: System Clock
; 0000 010E // Clock value: Timer2 Stopped
; 0000 010F // Mode: Normal top=0xFF
; 0000 0110 // OC2 output: Disconnected
; 0000 0111 TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0112 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0113 OCR2=0x00;
	OUT  0x23,R30
; 0000 0114 
; 0000 0115 // Timer/Counter 3 initialization
; 0000 0116 // Clock source: System Clock
; 0000 0117 // Clock value: Timer3 Stopped
; 0000 0118 // Mode: Normal top=0xFFFF
; 0000 0119 // OC3A output: Disconnected
; 0000 011A // OC3B output: Disconnected
; 0000 011B // OC3C output: Disconnected
; 0000 011C // Noise Canceler: Off
; 0000 011D // Input Capture on Falling Edge
; 0000 011E // Timer3 Overflow Interrupt: Off
; 0000 011F // Input Capture Interrupt: Off
; 0000 0120 // Compare A Match Interrupt: Off
; 0000 0121 // Compare B Match Interrupt: Off
; 0000 0122 // Compare C Match Interrupt: Off
; 0000 0123 TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 0124 TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 0125 TCNT3H=0x00;
	STS  137,R30
; 0000 0126 TCNT3L=0x00;
	STS  136,R30
; 0000 0127 ICR3H=0x00;
	STS  129,R30
; 0000 0128 ICR3L=0x00;
	STS  128,R30
; 0000 0129 OCR3AH=0x00;
	STS  135,R30
; 0000 012A OCR3AL=0x00;
	STS  134,R30
; 0000 012B OCR3BH=0x00;
	STS  133,R30
; 0000 012C OCR3BL=0x00;
	STS  132,R30
; 0000 012D OCR3CH=0x00;
	STS  131,R30
; 0000 012E OCR3CL=0x00;
	STS  130,R30
; 0000 012F 
; 0000 0130 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0131 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x37,R30
; 0000 0132 ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	STS  125,R30
; 0000 0133 
; 0000 0134 // External Interrupt(s) initialization
; 0000 0135 // INT0: Off
; 0000 0136 // INT1: Off
; 0000 0137 // INT2: Off
; 0000 0138 // INT3: Off
; 0000 0139 // INT4: Off
; 0000 013A // INT5: Off
; 0000 013B // INT6: Off
; 0000 013C // INT7: Off
; 0000 013D EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 013E EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 013F EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 0140 
; 0000 0141 // USART0 initialization
; 0000 0142 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0143 // USART0 Receiver: On
; 0000 0144 // USART0 Transmitter: On
; 0000 0145 // USART0 Mode: Asynchronous
; 0000 0146 // USART0 Baud Rate: 9600
; 0000 0147 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 0148 UCSR0B=(1<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0149 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 014A UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 014B UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 014C 
; 0000 014D // USART1 initialization
; 0000 014E // USART1 disabled
; 0000 014F UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 0150 
; 0000 0151 // Analog Comparator initialization
; 0000 0152 // Analog Comparator: Off
; 0000 0153 // The Analog Comparator's positive input is
; 0000 0154 // connected to the AIN0 pin
; 0000 0155 // The Analog Comparator's negative input is
; 0000 0156 // connected to the AIN1 pin
; 0000 0157 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0158 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0159 
; 0000 015A // ADC initialization
; 0000 015B // ADC disabled
; 0000 015C ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 015D 
; 0000 015E // SPI initialization
; 0000 015F // SPI disabled
; 0000 0160 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0161 
; 0000 0162 // TWI initialization
; 0000 0163 // TWI disabled
; 0000 0164 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 0165 
; 0000 0166 // Alphanumeric LCD initialization
; 0000 0167 // Connections are specified in the
; 0000 0168 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0169 // RS - PORTA Bit 0
; 0000 016A // RD - PORTA Bit 1
; 0000 016B // EN - PORTA Bit 2
; 0000 016C // D4 - PORTA Bit 4
; 0000 016D // D5 - PORTA Bit 5
; 0000 016E // D6 - PORTA Bit 6
; 0000 016F // D7 - PORTA Bit 7
; 0000 0170 // Characters/line: 20
; 0000 0171 lcd_init(20);
	LDI  R26,LOW(20)
	RCALL _lcd_init
; 0000 0172 
; 0000 0173 // Global enable interrupts
; 0000 0174 
; 0000 0175 while (1)
_0x58:
; 0000 0176       {
; 0000 0177         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0178 
; 0000 0179 
; 0000 017A        if(C==0){
	TST  R11
	BRNE _0x5B
; 0000 017B 
; 0000 017C 
; 0000 017D            if(asm==1){
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x5C
; 0000 017E             delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 017F             #asm("sei")
	sei
; 0000 0180             delay_ms(400);
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL _delay_ms
; 0000 0181             asm--;}
	DEC  R10
; 0000 0182 
; 0000 0183          putchar('A');
_0x5C:
	LDI  R26,LOW(65)
	CALL _putchar
; 0000 0184          putchar('T');
	LDI  R26,LOW(84)
	CALL SUBOPT_0x2
; 0000 0185          putchar('\r');
; 0000 0186          putchar('\n');
; 0000 0187          }
; 0000 0188 
; 0000 0189       }
_0x5B:
	RJMP _0x58
; 0000 018A }
_0x5D:
	RJMP _0x5D
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	JMP  _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R13,Y+1
	LDD  R12,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x7
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x7
	LDI  R30,LOW(0)
	MOV  R12,R30
	MOV  R13,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	CP   R13,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R12
	MOV  R26,R12
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2080001
_0x2000007:
_0x2000004:
	INC  R13
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x8
	CALL SUBOPT_0x8
	CALL SUBOPT_0x8
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	RJMP _0x2080001
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2080001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_data:
	.BYTE 0x8
__base_y_G100:
	.BYTE 0x4
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x0:
	CALL _lcd_putchar
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(65)
	CALL _putchar
	LDI  R26,LOW(84)
	CALL _putchar
	LDI  R26,LOW(43)
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	CALL _putchar
	LDI  R26,LOW(13)
	CALL _putchar
	LDI  R26,LOW(10)
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	MOVW R4,R30
	CBI  0x18,3
	SBI  0x18,2
	LDI  R30,LOW(0)
	STS  120,R30
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	MOVW R4,R30
	SBI  0x18,3
	SBI  0x18,2
	STS  120,R8
	LDI  R30,LOW(0)
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	MOVW R4,R30
	SBI  0x18,3
	SBI  0x18,2
	LDI  R30,LOW(0)
	STS  120,R30
	OUT  0x28,R8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	MOVW R4,R30
	LDI  R30,LOW(110)
	__PUTB1MN _data,4
	__PUTB1MN _data,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
