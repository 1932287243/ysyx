#include "verilated.h"
#include "VgrayCode.h"
#include <nvboard.h>
#include <stdio.h>
static VgrayCode* top;

void sim_init(){
    top = new VgrayCode;
    nvboard_bind_pin(&top->x, 5, SW4, SW3, SW2, SW1, SW0);

    nvboard_bind_pin(&top->y, 5, SW4, LD3, LD2, LD1, LD0);
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