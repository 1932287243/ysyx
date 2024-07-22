module shiftReg(clk, rst, ctrl, data_in, serial_in, data_out);
    input               clk;
    input               rst;
    input       [2:0]   ctrl;
    input       [7:0]   data_in;
    input               serial_in;
    output reg  [7:0]   data_out;

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            data_out <= 0'b00000000;                                //异步复位，清零
        end
        else begin
            case(ctrl)
                3'b000: data_out <= 8'b00000000;                    //清零
                3'b001: data_out <= data_in;                        //置数
                3'b010: data_out <= data_out >> 1;                  //逻辑右移
                3'b011: data_out <= data_out << 1;                  //逻辑左移
                3'b100: data_out <= {data_out[7], data_out[7:1]};   //算术右移
                3'b101: data_out <= {data_out[6:0], serial_in};     //左端串行输入1位值，并行输出8位值
                3'b110: data_out <= {data_out[0], data_out[7:1]};   //循环右移
                3'b111: data_out <= {data_out[6:0], data_out[7]};   //循环左移
                default:data_out <= data_out;
            endcase
        end
    end
endmodule