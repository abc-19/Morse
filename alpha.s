#         _.---._    /\\
#      ./'       "--`\//	Xorse - Xorse
#    ./              o \	abc19
#   /./\  )______   \__ \	Dec 25 2024
#  ./  / /\ \   | \ \  \ \
#     / /  \ \  | |\ \  \7
#      "     "    "  "		VK
.section	.rodata

	.Xa: .string ".-"
	.Xb: .string "-..."
    	.Xc: .string "-.-."
    	.Xd: .string "-.."
    	.Xe: .string "."
    	.Xf: .string "..-."
    	.Xg: .string "--."
    	.Xh: .string "...."
    	.Xi: .string ".."
    	.Xj: .string ".---"
    	.Xk: .string "-.-"
    	.Xl: .string ".-.."
    	.XX: .string "--"
    	.Xn: .string "-."
    	.Xo: .string "---"
    	.Xp: .string ".--."
    	.Xq: .string "--.-"
    	.Xr: .string ".-."
    	.Xs: .string "..."
    	.Xt: .string "-"
    	.Xu: .string "..-"
    	.Xv: .string "...-"
    	.Xw: .string ".--"
    	.Xx: .string "-..-"
    	.Xy: .string "-.--"
    	.Xz: .string "--.."
	.X_: .string "/ "

	.section    .data.rel.local, "aw"
    	.align      32
    	.size       .MORSE, 208
    	.MORSE:
	.quad   .Xa
    	.quad   .Xb
    	.quad   .Xc
    	.quad   .Xd
    	.quad   .Xe
    	.quad   .Xf
    	.quad   .Xg
    	.quad   .Xh
    	.quad   .Xi
    	.quad   .Xj
    	.quad   .Xk
    	.quad   .Xl
    	.quad   .XX
    	.quad   .Xn
    	.quad   .Xo
    	.quad   .Xp
    	.quad   .Xq
    	.quad   .Xr
    	.quad   .Xs
    	.quad   .Xt
    	.quad   .Xu
    	.quad   .Xv
    	.quad   .Xw
    	.quad   .Xx
    	.quad   .Xy
    	.quad   .Xz

	.globl	MORSE
