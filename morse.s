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

_start:	
	popq	%rax
	cmpq	$3, %rax
	jl	.showUsage
	popq	%rax
	popq	%rax
	popq	%r15										# XXX: Message's stored into r15
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rbx, -8(%rbp)									# NOTE: is it really necessary?
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
	call	isItTextable
	cmpl	$-1, %eax
	je	.mT_nontex
.mT_nontex:
	SAY_M	%r15, $1, $1
.mT_skip:
	incq	%r15
	jmp	.modeText
.modeMorse:
	jmp	.leaveAll

.leaveAll:
	FINI	$0


# -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-*
isItTextable:
	cmpl	$' ', %edi
	je	.1_isspace
	cmpl	$'A', %edi
	jl	.1_no
	cmpl	$'z', %edi
	jg	.1_no
	cmpl	$'Z', %edi
	jle	.1_is_upp
	cmpl	$'a', %edi
	jge	.1_is_low
.1_no:
	movl	$-1, %eax
	ret
.1_is_upp:
	addl	$32, %edi
.1_is_low:
	subl	$'a', %edi
	movl	%edi, %eax
	ret
.1_isspace:
	movl	$26, %eax
	ret
