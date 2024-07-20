#include "verilated.h"
#include "Vpriorityencode83.h"
#include <nvboard.h>
#include <stdio.h>
static Vpriorityencode83* top;

void sim_init(){
    top = new Vpriorityencode83;
    nvboard_bind_pin(&top->x, 8, SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0);
    nvboard_bind_pin(&top->en, 1, SW8);
    nvboard_bind_pin(&top->y, 3, LD2, LD1, LD0);
    nvboard_bind_pin(&top->f, 1, LD4);
    nvboard_bind_pin(&top->HEX0, 7, SEG0G, SEG0F, SEG0E, SEG0D, SEG0C, SEG0B, SEG0A);
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