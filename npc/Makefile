CC = verilator
CFLAGS = --cc --exe --build -j 0 -Wall --trace

all:sim
	@echo "Write this Makefile by your self."

sim:
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "Write this Makefile by your self."
	$(CC) $(CFLAGS) ./csrc/sim_main.cpp ./vsrc/top.v

.PHONY:clean ALL

clean:
	rm -rf ./obj_dir *.vcd

include ../Makefile




