#include "Vlfsr.h"
#include "verilated.h"
#include <nvboard.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

Vlfsr lfsr;

static void single_cycle() 
{
  lfsr.clk = 0; lfsr.eval();
  lfsr.clk = 1; lfsr.eval();
}

static void reset(int n) 
{
  lfsr.rst = 1;
  while (n-- > 0) single_cycle();
  lfsr.rst = 0;
}

int main(int argc, char** argv) 
{
    nvboard_bind_pin(&lfsr.data_in, 8, SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0);
    nvboard_bind_pin(&lfsr.data_out, 8, LD7, LD6, LD5, LD4, LD3, LD2, LD1, LD0);
    nvboard_bind_pin(&lfsr.seg0, 7, SEG0G, SEG0F, SEG0E, SEG0D, SEG0C, SEG0B, SEG0A);
    nvboard_bind_pin(&lfsr.seg1, 7, SEG1G, SEG1F, SEG1E, SEG1D, SEG1C, SEG1B, SEG1A);
    nvboard_bind_pin(&lfsr.clk, 1, BTNL);
  	nvboard_init();

    reset(10);

	while(1)
    {
        nvboard_update();
        // single_cycle();
        lfsr.eval();
    }

    nvboard_quit();
	return 0;
}
