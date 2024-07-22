module bcd7seg(
  input  [3:0] b,
  input en,
  output reg [6:0] h
);
// detailed implementation ...
  always @(*) begin
    if(en)begin
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
    else h = 7'b1111111; 
  end
endmodule

module scancodeToAscii(x, en, com_flag, seg0, seg1);
  input [7:0] x;
  input en;
  input com_flag;
  output [6:0] seg0;
  output [6:0] seg1;
  reg [7:0] y;
  wire [7:0] result;
  always @(x) begin
      case(x)
        8'h15: y = 8'h71;     //q
        8'h1d: y = 8'h77;     //w
        8'h24: y = 8'h65;     //e
        8'h2d: y = 8'h72;     //r
        8'h2c: y = 8'h74;     //t
        8'h35: y = 8'h79;     //y
        8'h3c: y = 8'h75;     //U
        8'h43: y = 8'h69;     //I
        8'h44: y = 8'h6f;     //O
        8'h4d: y = 8'h70;     //P
        8'h1c: y = 8'h61;     //A
        8'h1b: y = 8'h73;     //S
        8'h23: y = 8'h64;     //D
        8'h2b: y = 8'h66;     //F
        8'h34: y = 8'h67;     //G
        8'h33: y = 8'h68;     //H
        8'h3b: y = 8'h6a;     //J
        8'h42: y = 8'h6b;     //k
        8'h4b: y = 8'h6c;     //L
        8'h1a: y = 8'h7a;     //z
        8'h22: y = 8'h78;     //x
        8'h21: y = 8'h63;     //c
        8'h2a: y = 8'h76;     //v
        8'h32: y = 8'h62;     //b
        8'h31: y = 8'h6e;     //n
        8'h3a: y = 8'h6d;     //m
        8'h16: y = 8'h31;     //1
        8'h1e: y = 8'h32;     //2
        8'h26: y = 8'h33;     //3
        8'h25: y = 8'h34;     //4
        8'h2e: y = 8'h35;     //5
        8'h36: y = 8'h36;     //6
        8'h3d: y = 8'h37;     //7
        8'h3e: y = 8'h38;     //8
        8'h46: y = 8'h39;     //9
        8'h45: y = 8'h40;     //0
        default: y=8'h00;     //
      endcase
  end

  assign result = com_flag ? y-8'h20 : y;

  bcd7seg s0 (result[3:0], en, seg0);
  bcd7seg s1 (result[7:4], en, seg1);
endmodule

module ps2_keyboard(clk, rst, ps2_clk, ps2_data, ckey_flag, data,
                   seg0, seg1, seg2, seg3, seg4, seg5);
    input clk,rst,ps2_clk,ps2_data;
    output reg ckey_flag;
    output reg [7:0] data;
    output [6:0] seg0;
    output [6:0] seg1;
    output [6:0] seg2;
    output [6:0] seg3;
    output [6:0] seg4;
    output [6:0] seg5;
    
    // // internal signal, for test
    reg [9:0] buffer;        // ps2_data bits
    reg [7:0] last_data;
    reg pressed_flag;
    reg [3:0] count;  // count ps2_data bits
    reg [7:0] pressed_count;
    // detect falling edge of ps2_clk
    reg [2:0] ps2_clk_sync;
    reg enable_flag;
    always @(posedge clk) begin
        ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
    end

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    always @(posedge clk) begin
        if (rst) begin // reset
            count <= 0; last_data <= 8'b00000000; pressed_flag <= 0; pressed_count <= 0; ckey_flag <= 0; enable_flag <= 1;
        end
        else begin
            if (sampling) begin
              if (count == 4'd10) begin
                if ((buffer[0] == 0) &&  // start bit
                    (ps2_data)       &&  // stop bit
                    (^buffer[9:1])) begin      // odd  parity
                    $display("receive %x", buffer[8:1]);
                    $display("last %x", last_data);

                    //Determine if there is a button pressed
                    if (last_data == 8'hf0 && buffer[8:1] != 8'hf0) begin
                      pressed_flag <= 0;
                      pressed_count <= pressed_count + 1'b1;
                      ckey_flag <= 0;
                    end
                    else pressed_flag <= 1;

                    // if(ckey_flag && (last_data == buffer[8:1]))
                    //     enable_flag <= 0;
                    // else ckey_flag <= 0;
                    // Determine whether the combination key is pressed
                    // if(enable_flag)begin
                      if (last_data == 8'h12 && buffer[8:1] != 8'hf0) begin
                        ckey_flag <= 1;
                        // pressed_count <= pressed_count + 1'b1;
                      end
                      // else ckey_flag <= 0;
                    // end
                    // else enable_flag <= 1;
                    $display("ckey_flag %x", ckey_flag);
                    $display("enable_flag %x", enable_flag);
                    data <= buffer[8:1];
                    last_data <= buffer[8:1];
                end
                count <= 0;     // for next
              end else begin
                buffer[count] <= ps2_data;  // store ps2_data
                count <= count + 3'b1;
              end
            end
        end
        // if(ready == 0)
        //       temp_ptr <= 1'b0;
    end
    // assign data = fifo[r_ptr]; //always set output data
    bcd7seg s0 (data[3:0], pressed_flag, seg0);
    bcd7seg s1 (data[7:4], pressed_flag, seg1);
    bcd7seg s2 (pressed_count[3:0], 1, seg4);
    bcd7seg s3 (pressed_count[7:4], 1, seg5);
    scancodeToAscii cta (data, pressed_flag, ckey_flag, seg2, seg3);

endmodule