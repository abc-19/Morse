#! /bin/sh
#         _.---._    /\\
#      ./'       "--`\//	Morse - test cases
#    ./              o \	abc19
#   /./\  )______   \__ \	Dec 26 2024
#  ./  / /\ \   | \ \  \ \
#     / /  \ \  | |\ \  \7
#      "     "    "  "		VK

test_m_mode () {
	assertEquals "$(./MrS t "hola")" ".... --- .-.. .- "
  assertEquals "$(./MrS t "july")" ".--- ..- .-.. -.-- "
	assertEquals "$(./MrS t "bEtWeEn DAYs")" "-... . - .-- . . -. / -.. .- -.-- ... "
	assertEquals "$(./MrS t "house music!!!")" ".... --- ..- ... . / -- ..- ... .. -.-. ! ! ! "
	assertEquals "$(./MrS t "39bermuda")" "...-- ----. -... . .-. -- ..- -.. .- "
}

test_t_mode () {
	assertEquals "$(./MrS m "--- .... / -.. --- ...- . !!!")" "oh dove!!!"
	assertEquals "$(./MrS m "... --- -- . - .... .. -. --. / ..--- / - .-. .- -. ... .-.. .- - . ")" "something 2 translate"
	assertEquals "$(./MrS m ".- -... -.-. -.. . ..-. --. .... .. .--- -.- .-.. -- -. --- .--. --.- .-. ... - ..- ...- .-- -..- -.-- --.. ----- ----. ---.. --... -.... ..... ....- ...-- ..--- .---- ")" "abcdefghijklmnopqrstuvwxyz0987654321"
	assertEquals "$(./MrS m "-.-- ..- -. --. .--. --- .-.. .- .-. ")" "yungpolar"
	assertEquals "$(./MrS m "-..- ---.. -.... ")" "x86"
}

# Load shUnit2.
. shunit2
