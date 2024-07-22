module barrelShifter(din, shamt, lr, al, dout);
    input       [7:0]   din;
    input       [2:0]   shamt;
    input               lr;
    input               al;
    output  reg [7:0]   dout;

    always @(*) begin
        if(lr) begin  //左移
            if(al) begin     //算数移位
                dout = din <<< shamt;
            end
            else begin      //逻辑移位
                dout = din << shamt;
            end
        end
        else begin //右移
            if(al) begin     //算数移位
                dout = $signed(din) >>> shamt;
            end
            else begin       //逻辑移位
                dout = din >> shamt;;
            end
        end
    end
endmodule