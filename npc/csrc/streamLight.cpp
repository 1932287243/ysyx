#include "VstreamLight.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <nvboard.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

VstreamLight streamLight;

static void single_cycle() 
{
  streamLight.clk = 0; streamLight.eval();
  streamLight.clk = 1; streamLight.eval();
}

static void reset(int n) 
{
  streamLight.rst = 1;
  while (n-- > 0) single_cycle();
  streamLight.rst = 0;
}

int main(int argc, char** argv) 
{
    nvboard_bind_pin(&streamLight.led, 16, LD15, LD14, LD13, LD12, LD11, LD10, LD9, LD8, LD7, LD6, LD5, LD4, LD3, LD2, LD1, LD0);
  	nvboard_init();

    reset(10);

	while(1)
    {
        nvboard_update();
        single_cycle();
    }

    nvboard_quit();
	return 0;
}
