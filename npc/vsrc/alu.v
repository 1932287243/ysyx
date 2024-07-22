module oneBitAdder(a, b, c0, s, c1);
    input a;
    input b;
    input c0;
    output s;
    output c1;

    assign s = a ^ b ^ c0;
    assign c1 = (a & c0) | (b & c0)| (a & b);
    //(a&b) | ((a|b)&c0)
endmodule

//串行进位加法器
module serialAdder #(DATA_LEN = 4) (a, b, y, c);
    input[DATA_LEN - 1:0] a;
    input[DATA_LEN - 1:0] b;
    output [DATA_LEN - 1:0] y;
    output c;
    wire [DATA_LEN - 1:0]cin;
    genvar i;
    oneBitAdder add1 (a[0], b[0], 0,  y[0], cin[0]);
    generate
    for(i=0; i<DATA_LEN-1; i=i+1) 
        oneBitAdder add2 (a[i+1], b[i+1], cin[i], y[i+1], cin[i+1]);
    endgenerate
    assign c = cin[DATA_LEN - 1];
endmodule

//先行进位加法器
module cla(a, b, c0, y, c);
    input [3:0] a;
    input [3:0] b;
    input c0;
    output [3:0] y;
    output c;

    wire [3:0] cin;
    wire [3:0] cout;
    assign cin[0] = (a[0]&b[0]) | ((a[0]|b[0])&c0);
    assign cin[1] = (a[1]&b[1]) | ((a[1]|b[1])&(a[0]&b[0])) | ((a[1]|b[1])&(a[0]|b[0])&c0);
    assign cin[2] = (a[2]&b[2]) | ((a[2]|b[2])&(a[1]&b[1])) | ((a[2]|b[2])&(a[1]|b[1])&(a[0]&b[0])) | ((a[2]|b[2])&(a[1]|b[1])&(a[0]|b[0])&c0);
    assign cin[3] = (a[3]&b[3]) | ((a[3]|b[3])&(a[2]&b[2])) | ((a[3]|b[3])&(a[2]|b[2])&(a[1]&b[1])) | ((a[3]|b[3])&(a[2]|b[2])&(a[1]|b[1])&(a[0]&b[0])) | ((a[3]|b[3])&(a[2]|b[2])&(a[1]|b[1])&(a[0]|b[0])&c0);

    oneBitAdder add1 (a[0], b[0], c0, y[0], cout[0]);
    oneBitAdder add2 (a[1], b[1], cin[0], y[1], cout[1]);
    oneBitAdder add3 (a[2], b[2], cin[1], y[2], cout[2]);
    oneBitAdder add4 (a[3], b[3], cin[2], y[3], cout[3]);

    assign c = cin[3];
endmodule

// 先行进位加法器（改进版）
//p0 = a0 + b0
//g0 = a0 . b0
// c1 = g0 + (p0.c0)
// c2 = g1 + (p1.c1)
// c3 = g2 + (p2.c2)
// c4 = g3 + (p3.c3)
module carry_lookahead_adder #(parameter WIDTH = 4) (
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire cin,
    output wire [WIDTH-1:0] sum,
    output wire cout
);
    wire [WIDTH-1:0] p; // propagate signals
    wire [WIDTH-1:0] g; // generate signals
    wire [WIDTH:0] c;   // carry signals

    wire temp;
    assign c[0] = cin;  // initial carry is the input carry
    assign temp = cin;
    // Generate propagate and generate signals
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : generate_signals
            assign p[i] = a[i] | b[i]; // propagate
            assign g[i] = a[i] & b[i]; // generate
        end
    endgenerate

    // Compute carry signals
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin);

    // Compute sum and final carry out
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : compute_sum
            assign sum[i] = a[i] ^ b[i] ^ c[i];
        end
    endgenerate

    assign cout = c[WIDTH];

endmodule

// module adderSub(a, b, select, carry, zero, overflow, result);
module adderSub(a, b, carry, result);
    input [3:0] a;
    input [3:0] b;
    output carry;
    // output zero;
    // output overflow;
    output reg [3:0] result;
    reg [3:0] a_complement;
    reg [3:0] b_complement;
    wire [3:0] result_complement;
    always @ (a,b,result_complement) begin
        if(a[3] == 0) begin
            a_complement = a;
        end
        else begin
            a_complement = ~a + 1'b1;
        end
        if(b[3] == 0) begin
            b_complement = b;
        end
        else begin
            b_complement = ~b + 1'b1;
        end
        if(result_complement[3] == 0) begin
            result = result_complement;
        end
        else begin
            result = {b[3],~(b[2:0]-3'b001)};
        end
    end

    carry_lookahead_adder #(4) cla1 (a_complement, b_complement, 0, result_complement, carry);
    // assign overflow = (a_complement[3] == b_complement[3]) && (result_complement[3] != a_complement[3])
endmodule

module adder_subtractor #(parameter WIDTH = 8) (
    input [WIDTH-1:0] a,      // 第一个操作数
    input [WIDTH-1:0] b,      // 第二个操作数
    input sub,                // 加减选择信号，0：加法，1：减法
    output [WIDTH-1:0] result, // 结果
    output carry_out          // 进位输出
);
    wire [WIDTH-1:0] b_complement; // 存储补码
    wire [WIDTH-1:0] b_effective;  // 实际操作的第二个数
    wire carry_in;                 // 输入进位信号

    // 根据sub信号决定是否取补码
    assign b_complement = ~b + 1;
    assign b_effective = sub ? b_complement : b;

    // 输入进位信号，对于加法为0，对于减法为1
    assign carry_in = sub;

    // 执行加法运算
    assign {carry_out, result} = a + b_effective;
endmodule

// module (a, b, sele);
// endmodule

// module alu(a, b, y, c);
//     parameter DATA_LEN = 4;
//     input       [DATA_LEN - 1:0]       a;
//     input       [DATA_LEN - 1:0]       b;
//     output      [DATA_LEN - 1:0]       y;
//     output                             c;
//     // serialAdder #(DATA_LEN) ad (a, b, y, c);
//     // cla cla1 (a, b, 0, y, c);
//     // carry_lookahead_adder #(4) cla1 (a, b, 0, y, c);
//     // adderSub as (a, b, c, y);
//     adder_subtractor #(4) as (a, b, 1, y, c);
// endmodule

module alu(a, b, select, result, overflow, zero, carry);
    input [3:0] a;
    input [3:0] b;
    input [2:0] select;
    output reg [3:0] result;
    output reg overflow;
    output reg zero;
    output reg carry;

    reg [3:0] temp;
    always @(*)begin
        result = 4'b0000;
        zero = 0;
        overflow = 0;
        carry = 0;
        temp = 4'b0000;
        case(select)
            3'b000:begin   //加法
                {carry,result} = a + b;
                overflow = (a[3] == b[3]) && (result[3] != a[3]);
                zero = ~(|result);
            end
            3'b001:begin   //减法
                {carry,result} = {1'b0 , a} + {1'b0 ,  (~b + 4'b0001)};
                overflow = (a[3] != b[3]) && (result[3] != a[3]);
                zero = ~(|result);
            end
            3'b010:begin   //取反
                result = ~a;
            end
            3'b011:begin   //与
                result = a & b;
            end
            3'b100:begin   //或
                result = a | b;
            end
            3'b101:begin   //异或
                result = a ^ b;
            end
            3'b110:begin   //比较大小
                temp =  a + (~b + 4'b0001);
                overflow = (a[3] != b[3]) && (temp[3] != a[3]);
                if(overflow == 0)begin
                    if(temp[3] == 1)begin
                        result = 4'b0001;
                    end
                    else result = 4'b0000;
                end
                else begin
                    if(temp[3] == 0) begin
                        result = 4'b0001;
                    end
                    else result = 4'b0000;
                end
            end
            3'b111:begin   //判断相等
                result = (a == b) ? 4'b0001 :4'b0000;
            end
        endcase
    end
endmodule