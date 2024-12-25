#         _.---._    /\\
#      ./'       "--`\//	Morse - Makefile
#    ./              o \	abc19
#   /./\  )______   \__ \	Dec 25 2024
#  ./  / /\ \   | \ \  \ \
#     / /  \ \  | |\ \  \7
#      "     "    "  "		VK

OBJS = morse.o
EXEC = MrS

all: $(EXEC)

$(EXEC): $(OBJS)
	ld	-o $(EXEC) $(OBJS)
%.o: %.s
	as	$< -o $@
clean:
	rm	-rf $(OBJS) $(EXEC)
