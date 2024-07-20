#include "VonOffSwitch.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <nvboard.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int main(int argc, char** argv) {

	VerilatedContext* contextp = new VerilatedContext;
	contextp->commandArgs(argc, argv);
	VonOffSwitch* onOffSwitch = new VonOffSwitch{contextp};

	nvboard_bind_pin(&onOffSwitch->a, 1, SW0);
	nvboard_bind_pin(&onOffSwitch->b, 1, SW1);
	nvboard_bind_pin(&onOffSwitch->f, 1, LD0);
  	nvboard_init();

	// VerilatedVcdC* tfp = new VerilatedVcdC;   //初始化VCD指针对象
	// contextp->traceEverOn(true);
	// top->trace(tfp, 0);
	// tfp->open("wave.vcd");   //设置输出的文件

	// while (!contextp->gotFinish())
 	// {
	// 	int a = rand() & 1;
	// 	int b = rand() & 1;
	// 	top->a = a;
	// 	top->b = b;
	//  	top->eval();
	// 	printf("a = %d, b = %d, f = %d\n", a, b, top->f);
	// 	nvboard_update();
	// 	tfp->dump(contextp->time());
	// 	contextp->timeInc(1);
	// 	assert(top->f == (a ^ b));
 	// }
	while(1)
  {
    nvboard_update();
    onOffSwitch->eval();
    // printf("a = %d, b = %d, f = %d\n", top->a, top->b, top->f);
  }
  nvboard_quit();
	delete onOffSwitch;
	// tfp->close();
	delete contextp;
	return 0;
}
