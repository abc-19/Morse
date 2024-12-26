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

.macro	SAY_EN, pos
	leaq	ALPHA_EN(%rip), %rax
	addq	\pos, %rax
	SAY_M	%rax, $1, $1
.endm

_start:	
	popq	%rax
	cmpq	$3, %rax
	jl	.showUsage
	popq	%rax
	popq	%rax
	popq	%r15
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movq	$0, -8(%rbp)
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
	leaq	MORSE(%rip), %rax
	movq	(%rax, %rbx, 8), %rdi
	movq	%rdi, %rbx
	call	lenOf
	SAY_M	%rbx, %rax, $1
	jmp	.mT_next
.mT_nontex:
	SAY_M	%r15, $1, $1
.mT_next:
	SAY_EN	$26
	incq	%r15
	jmp	.modeText

.modeMorse:
	leaq	-8(%rbp), %r14
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
	SAY_M	%r15, $1, $1
	jmp	.mM_next
.mM_store:
	leaq	-3(%rbp), %rax
	cmpq	%rax, %r14
	je	.mM_delimiter
	movb	%dil, (%r14)
	incq	%r14
	jmp	.mM_next
.mM_space:
	jmp	.mM_next
.mM_delimiter:
	SAY_L	-8(%rbp), $5, $1
	FINI	$69
	jmp	.mM_next
.mM_next:
	incq	%r15
	jmp	.mM_eating
.leaveAll:
	SAY_EN	$27
	FINI	$0

# -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-* -*-*-*-*-*-*-*-*-*-*-*-*-*-*
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
