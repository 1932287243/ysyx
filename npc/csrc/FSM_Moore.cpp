#include "verilated.h"
#include "VFSM_Moore.h"
#include <nvboard.h>
#include <stdio.h>
static VFSM_Moore* top;

void sim_init(){
    top = new VFSM_Moore;
    nvboard_bind_pin(&top->z, 1, LD0);
    nvboard_bind_pin(&top->clk, 1, BTNL);
    nvboard_bind_pin(&top->rst, 1, BTNR);
    nvboard_bind_pin(&top->w, 1, SW0);
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