module grayCodeBCDConvert #(DATA_LEN = 4)(
    input [DATA_LEN-1:0] x,
    output reg [DATA_LEN-1:0] y
); 
    integer i;
    always @(x) begin
        y[DATA_LEN-1] = x[DATA_LEN-1];
        for(i=0; i<DATA_LEN-1; i=i+1)
            y[DATA_LEN-i-2] = x[DATA_LEN-1-i]^x[DATA_LEN-i-2];
    end
endmodule

module grayCode(x, y);
    input [4:0] x;
    output [4:0] y;
    grayCodeBCDConvert #(5) gtbc (x, y);
endmodule