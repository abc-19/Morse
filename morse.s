#         _.---._    /\\
#      ./'       "--`\//	Morse - main
#    ./              o \	abc19
#   /./\  )______   \__ \	Dec 25 2024
#  ./  / /\ \   | \ \  \ \
#     / /  \ \  | |\ \  \7
#      "     "    "  "		VK

.section	.rodata
	hello_morse: .string "Hello World! Morse\n"
	hello_len:   .quad   19

.section	.text
.globl	_start

_start:	
	movq	$1, %rax
	movq	$1, %rdi
	leaq	hello_morse(%rip), %rsi
	movq	hello_len(%rip), %rdx
	syscall

	movq	$60, %rax
	movq	$0, %rdi
	syscall
