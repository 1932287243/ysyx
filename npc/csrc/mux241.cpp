#include "verilated.h"
#include "Vmux241.h"
#include <nvboard.h>
#include <stdio.h>
static Vmux241* top;

void sim_init(){
  top = new Vmux241;
  nvboard_bind_pin(&top->a, 8, SW9, SW8, SW7, SW6, SW5, SW4, SW3, SW2);
	nvboard_bind_pin(&top->s, 2, SW1, SW0);
	nvboard_bind_pin(&top->y, 2, LD0, LD1);
  nvboard_init();
}

int main() {
  sim_init();
  while (1)
  {
    nvboard_update();
    printf("a=%b\n", top->a);
    printf("s=%b\n", top->s);
    top->eval();
  }
  return 0;
}