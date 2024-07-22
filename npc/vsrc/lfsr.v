module bcd7seg(
  input  [3:0] b,
  output reg [6:0] h
);
// detailed implementation ...
  always @(b) begin
    case (b)
        4'b0000 : h = 7'b1000000;
        4'b0001 : h = 7'b1111001;
        4'b0010 : h = 7'b0100100;
        4'b0011 : h = 7'b0110000;
        4'b0100 : h = 7'b0011001;
        4'b0101 : h = 7'b0010010;
        4'b0110 : h = 7'b0000010;
        4'b0111 : h = 7'b1111000;
        4'b1000 : h = 7'b0000000;
        4'b1001 : h = 7'b0010000;
        4'b1010 : h = 7'b0001000;
        4'b1011 : h = 7'b0000011;
        4'b1100 : h = 7'b1000110;
        4'b1101 : h = 7'b0100001;
        4'b1110 : h = 7'b0000110;
        4'b1111 : h = 7'b0001110;
    endcase
  end
endmodule

module lfsr(clk, rst, data_in, data_out, seg0, seg1);
    input clk;
    input rst;
    input [7:0] data_in;
    output reg [7:0] data_out;
    output  [6:0] seg0;
    output  [6:0] seg1;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            data_out <= 8'b00000000;
        end
        else begin
            if(data_out == 8'b00000000) begin
                data_out <= 8'b00000001;
            end
            else begin
                data_out <= {{data_out[8]^data_out[6]^data_out[5]^data_out[4]}, data_out[7:1]};
            end  
        end
    end
    bcd7seg s1 (data_out[7:4], seg1);
    bcd7seg s0 (data_out[3:0], seg0);

endmodule


module FSM_Moore(
    input wire clk,       // 时钟信号
    input wire rst_n,     // 复位信号（低有效）
    input wire [7:0] data,// 输入数据
    output reg flag       // 输出标志
);

    // 状态定义
    reg [1:0] c_state, n_state;
    localparam idle = 2'b00,
               aa   = 2'b01,
               bb   = 2'b10,
               cc   = 2'b11;

    // 状态转移条件 - 次态组合电路
    always @(*) begin
        n_state = c_state;  // 初始化为当前状态，避免latch
        case(c_state)
            idle: begin
                if (data == 8'hAA)
                    n_state = aa;
                else
                    n_state = idle;
            end
            aa: begin
                if (data == 8'hAA)
                    n_state = aa;
                else if (data == 8'hBB)
                    n_state = bb;
                else
                    n_state = idle;
            end
            bb: begin
                if (data == 8'hAA)
                    n_state = aa;
                else if (data == 8'hCC)
                    n_state = cc;
                else
                    n_state = idle;
            end
            cc: begin
                if (data == 8'hAA)
                    n_state = aa;
                else
                    n_state = idle;
            end
            default: n_state = idle;
        endcase
    end

    // 状态转移 - 时序部分
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            c_state <= idle;
        else
            c_state <= n_state;
    end

    // 输出部分 - 组合电路
    always @(*) begin
        if (c_state == cc)
            flag = 1'b1;
        else
            flag = 1'b0;
    end

endmodule