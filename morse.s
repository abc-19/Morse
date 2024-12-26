#         _.---._    /\\
#      ./'       "--`\//	Morse - main
#    ./              o \	abc19
#   /./\  )______   \__ \	Dec 25 2024
#  ./  / /\ \   | \ \  \ \
#     / /  \ \  | |\ \  \7
#      "     "    "  "		VK

.section	.rodata
	.msg_usage: .string	"MrS [u]: MrS <mode> <message>\n"
	.len_usage: .quad	30

	.msg_unkmo: .string	"MrS [e]: Unknown mode given\n"
	.len_unkmo: .quad	28

	.msg_nofnd: .string	"<?>"
	.len_nofnd: .quad	3

.section	.text
.globl	_start

.macro	FINI, status
	movq	\status, %rdi
	movq	$60, %rax
	syscall
.endm

.macro	SAY_L, msg, len, to
	movq	\to, %rdi
	leaq	\msg, %rsi
	movq	\len, %rdx
	movq	$1, %rax
	syscall
.endm

.macro	SAY_M, msg, len, to
	movq	\to, %rdi
	movq	\msg, %rsi
	movq	\len, %rdx
	movq	$1, %rax
	syscall
.endm

.macro	SAY_EN, pos
	leaq	ALPHA_EN(%rip), %rax
	addq	\pos, %rax
	SAY_M	%rax, $1, $1
.endm

_start:
	popq	%rax									# Get number of arguments............................
	cmpq	$3, %rax								# Three arguments are needed.........................
	jl	.showUsage
	popq	%rax									# Gets executable's name.............................
	popq	%rax									# Gets mode to be used...............................
	popq	%r15									# Gets message (stored in r15 for ever)..............
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	$0, -8(%rbp)								# Only for 'm' mode (stores the code)................
	movzbl	(%rax), %eax
	cmpl	$'m', %eax
	je	.modeMorse
	cmpl	$'t', %eax
	je	.modeText
	jmp	.modeUnknown

.showUsage:
	SAY_L	.msg_usage(%rip), .len_usage(%rip), $1
	FINI	$0

.modeUnknown:
	SAY_L	.msg_unkmo(%rip), .len_unkmo(%rip), $2
	FINI	$1

.modeText:
	movzbl	(%r15), %edi
	testl	%edi, %edi
	jz	.leaveAll
	call	isItMorseable
	cmpl	$-1, %eax
	je	.mT_nontex
	cltq
	movq	%rax, %rbx
	leaq	MORSE(%rip), %rax							# Gets array of codes................................
	movq	(%rax, %rbx, 8), %rdi							# Gets the needed code...............................
	movq	%rdi, %rbx
	call	lenOf
	SAY_M	%rbx, %rax, $1
	jmp	.mT_next
.mT_nontex:
	SAY_M	%r15, $1, $1
.mT_next:
	SAY_EN	$36
	incq	%r15
	jmp	.modeText

.modeMorse:
	leaq	-8(%rbp), %r14								# r14 will store the current code....................
.mM_eating:
	movzbl	(%r15), %edi
	testl	%edi, %edi
	jz	.leaveAll
	cmpl	$'.', %edi
	je	.mM_store
	cmpl	$'-', %edi
	je	.mM_store
	cmpl	$'/', %edi
	je	.mM_space
	cmpl	$' ', %edi
	je	.mM_delimiter
	SAY_M	%r15, $1, $1								# Print non-morse character..........................
	jmp	.mM_next
.mM_store:
	leaq	-3(%rbp), %rax								# Address memory where last byte can be stored.......
	cmpq	%rax, %r14								# Making sure ain't code longer than 5 bytes.........
	je	.mM_delimiter
	movb	%dil, (%r14)								# Stores character as part of the code...............
	incq	%r14									# Getting ready for next character...................
	jmp	.mM_next
.mM_space:
	SAY_EN	$36
	jmp	.mM_next
.mM_delimiter:
	leaq	-8(%rbp), %rax								# Address where 0th byte is stored...................
	cmpq	%rax, %r14								# Making sure there's some code to be parsed.........
	jz	.mM_next
	leaq	MORSE(%rip), %r13							# Reads array of morse codes..........................
	movq	$0, %rcx								# Works as a counter aka `i`..........................
.mM_delimiter_quest:
	cmpq	$36, %rcx								# There are only 35 morse-codes.......................
	je	.mM_nofound
	movq	(%r13, %rcx, 8), %rdi							# Reads the i-th code.................................
	leaq	-8(%rbp), %rsi								# Code to compare with................................
	call	strCmp
	cmpl	$1, %eax
	je	.mM_found
	incq	%rcx									# i++.................................................
	jmp	.mM_delimiter_quest
.mM_nofound:
	SAY_L	.msg_nofnd(%rip), .len_nofnd(%rip), $1
	jmp	.mM_clean
.mM_found:
	SAY_EN	%rcx
.mM_clean:
	movq	$0, -8(%rbp)
	leaq	-8(%rbp), %r14
.mM_next:
	incq	%r15
	jmp	.mM_eating
.leaveAll:
	SAY_EN	$37
	FINI	$0

# -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-*
isItMorseable:
	cmpl	$' ', %edi
	je	.1_isspace
	cmpl	$'A', %edi
	jl	.1_may_num
	cmpl	$'z', %edi
	jg	.1_may_num
	cmpl	$'Z', %edi
	jle	.1_is_upp
	cmpl	$'a', %edi
	jge	.1_is_low
.1_is_upp:
	addl	$32, %edi
.1_is_low:
	subl	$'a', %edi
	movl	%edi, %eax
	ret
.1_isspace:
	movl	$36, %eax
	ret
.1_may_num:
	cmpl	$'0', %edi
	jl	.1_no
	cmpl	$'9', %edi
	jg	.1_no
	subl	$'0', %edi
	addl	$26, %edi
	movl	%edi, %eax
	ret
.1_no:
	movl	$-1, %eax
	ret
# -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-*
lenOf:
	xorq	%rcx, %rcx
.2_keep:
	movzbl	(%rdi), %eax
	testl	%eax, %eax
	jz	.2_fini
	incq	%rcx
	incq	%rdi
	jmp	.2_keep
.2_fini:
	movq	%rcx, %rax
	ret
# -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-*
strCmp:
.3_loop:
	movzbl	(%rdi), %eax
	cmpb	(%rsi), %al
	jne	.3_no
	cmpb	$0, %al
	je	.3_si
	incq	%rdi
	incq	%rsi
	jmp	.3_loop
.3_no:
	movl	$0, %eax
	ret
.3_si:
	movl	$1, %eax
	ret
