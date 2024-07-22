module FSM_Moore(
    input   wire    clk,         // 时钟信号
    input   wire    rst,         // 复位信号
    input   wire    w,           // 输入数据
    output  reg     z            // 输出标志
);

    // 状态定义
    reg [3:0] c_state, n_state;
    localparam A    = 4'b0000,
               B    = 4'b0001,
               C    = 4'b0010,
               D    = 4'b0011,
               E    = 4'b0100,
               F    = 4'b0101,
               G    = 4'b0110,
               H    = 4'b0111,
               I    = 4'b1000;

    // 状态转移条件 - 次态组合电路
    always @(*) begin
        n_state = c_state;  // 初始化为当前状态，避免latch
        case(c_state)
            A: begin
                if (w)
                    n_state = F;
                else
                    n_state = B;
            end
            B: begin
                if (w)
                    n_state = F;
                else
                    n_state = C;
            end
            C: begin
                if (w)
                    n_state = F;
                else
                    n_state = D;
            end
            D: begin
                if (w)
                    n_state = F;
                else
                    n_state = E;
            end
            E: begin
                if (w)
                    n_state = F;
                else
                    n_state = E;
            end
            F: begin
                if (w)
                    n_state = G;
                else
                    n_state = B;
            end
            G: begin
                if (w)
                    n_state = H;
                else
                    n_state = B;
            end
            H: begin
                if (w)
                    n_state = I;
                else
                    n_state = B;
            end
            I: begin
                if (w)
                    n_state = I;
                else
                    n_state = B;
            end
            default: n_state = A;
        endcase
    end

    // 状态转移 - 时序部分
    always @(posedge clk or negedge rst) begin
        if (rst)
            c_state <= A;
        else
            c_state <= n_state;
    end

    // 输出部分 - 组合电路
    always @(posedge clk or posedge rst) begin
        if (c_state == E || c_state == I)
            z = 1'b1;
        else
            z = 1'b0;
    end

endmodule