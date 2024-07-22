#include "verilated.h"
#include "Valu.h"
#include <nvboard.h>
#include <stdio.h>
static Valu* top;

void sim_init(){
    top = new Valu;
    nvboard_bind_pin(&top->a, 4, SW3, SW2, SW1, SW0);
    nvboard_bind_pin(&top->b, 4, SW7, SW6, SW5, SW4);
    nvboard_bind_pin(&top->select, 3, SW15, SW14, SW13);
    nvboard_bind_pin(&top->result, 4, LD3, LD2, LD1, LD0);
    nvboard_bind_pin(&top->carry, 1, LD4);
    nvboard_bind_pin(&top->overflow, 1, LD5);
    nvboard_bind_pin(&top->zero, 1, LD6);
    nvboard_init();
}

int main() {
    sim_init();
    while (1)
    {
        nvboard_update();
        top->eval();
    }
    return 0;
}