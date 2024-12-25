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
	FINI	$0

.showUsage:
	SAY_L	.msg_usage(%rip), .len_usage(%rip), $1
	FINI	$0
