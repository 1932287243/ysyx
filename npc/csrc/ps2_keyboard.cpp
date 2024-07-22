#include "verilated.h"
#include "Vps2_keyboard.h"
#include <nvboard.h>
#include <stdio.h>
static Vps2_keyboard* top;

void sim_init(){
    top = new Vps2_keyboard;
    nvboard_bind_pin(&top->ps2_clk, 1, PS2_CLK);
	nvboard_bind_pin(&top->ps2_data, 1, PS2_DAT);
    nvboard_bind_pin(&top->ckey_flag, 1, LD15);
    nvboard_bind_pin(&top->data, 8, LD7, LD6, LD5, LD4, LD3, LD2, LD1, LD0);
    nvboard_bind_pin(&top->seg0, 7, SEG0G, SEG0F, SEG0E, SEG0D, SEG0C, SEG0B, SEG0A);
    nvboard_bind_pin(&top->seg1, 7, SEG1G, SEG1F, SEG1E, SEG1D, SEG1C, SEG1B, SEG1A);
    nvboard_bind_pin(&top->seg2, 7, SEG2G, SEG2F, SEG2E, SEG2D, SEG2C, SEG2B, SEG2A);
    nvboard_bind_pin(&top->seg3, 7, SEG3G, SEG3F, SEG3E, SEG3D, SEG3C, SEG3B, SEG3A);
    nvboard_bind_pin(&top->seg4, 7, SEG4G, SEG4F, SEG4E, SEG4D, SEG4C, SEG4B, SEG4A);
    nvboard_bind_pin(&top->seg5, 7, SEG5G, SEG5F, SEG5E, SEG5D, SEG5C, SEG5B, SEG5A);
    // nvboard_bind_pin(&top->nextdata_n, 1, SW0);
    nvboard_init();
} 

static void single_cycle() {
  top->clk = 0; top->eval();
  top->clk = 1; top->eval();
}

static void reset(int n) {
  top->rst = 1;
  while (n -- > 0) single_cycle();
  top->rst = 0;
}

int main() {
  sim_init();
  reset(10);

  while(1) {
    nvboard_update();
    // printf("ps2_data = %b \t ps2_clk = %b \n", top->ps2_data, top->ps2_clk);
    //  printf("ready = %d \n", top->ready);
    single_cycle();
  }
}