#include "VshiftReg.h"
#include "verilated.h"
#include <nvboard.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

VshiftReg shiftReg;

static void single_cycle() 
{
  shiftReg.clk = 0; shiftReg.eval();
  shiftReg.clk = 1; shiftReg.eval();
}

static void reset(int n) 
{
  shiftReg.rst = 1;
  while (n-- > 0) single_cycle();
  shiftReg.rst = 0;
}

int main(int argc, char** argv) 
{
    nvboard_bind_pin(&shiftReg.data_in, 8, SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0);
    nvboard_bind_pin(&shiftReg.data_out, 8, LD7, LD6, LD5, LD4, LD3, LD2, LD1, LD0);
    nvboard_bind_pin(&shiftReg.ctrl, 3, SW15, SW14, SW13);
    nvboard_bind_pin(&shiftReg.serial_in, 1, SW8);
    nvboard_bind_pin(&shiftReg.clk, 1, BTNL);
  	nvboard_init();

    reset(10);

	while(1)
    {
        nvboard_update();
        // single_cycle();
        shiftReg.eval();
    }

    nvboard_quit();
	return 0;
}
