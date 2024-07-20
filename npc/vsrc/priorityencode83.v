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

module priorityencode83(x, en, y, f, HEX0);

  input  [7:0] x;
  input  en;
  output f;
  output reg [2:0]y;
  output [6:0] HEX0;
  integer i;

// for 
//   always @(x or en) begin
//     if (en) begin
//         if (f == 1) begin
//             for(i=0; i<=7; i=i+1)
//                 if(x[i] == 1) y = i[2:0];
//         end
//     end
//     else  y = 0;
//   end

//casez 
//   always @(x or en) begin
//     if (en) begin
//         casez(x)
//             8'b1zzzzzzz: y = 3'b111;
//             8'b01zzzzzz: y = 3'b110;
//             8'b001zzzzz: y = 3'b101;
//             8'b0001zzzz: y = 3'b100;
//             8'b00001zzz: y = 3'b011;
//             8'b000001zz: y = 3'b010;
//             8'b0000001?: y = 3'b001;
//             8'b00000001: y = 3'b000;
//             default:     y = 3'b000;
//         endcase
//     end
//     else  y = 0;
//   end
//   always @(x or en) begin
//     if (en) begin
//         casex(x)
//             8'b1xxxxxxx: y = 3'b111;
//             8'b01xxxxxx: y = 3'b110;
//             8'b001xxxxx: y = 3'b101;
//             8'b0001xxxx: y = 3'b100;
//             8'b00001xxx: y = 3'b011;
//             8'b000001xx: y = 3'b010;
//             8'b0000001x: y = 3'b001;
//             8'b00000001: y = 3'b000;
//             default:     y = 3'b000;
//         endcase
//     end
//     else  y = 0;
//   end
//常数
  always @(x or en) begin
    if (en) begin
        case(1)
            x[7]: y = 3'b111;
            x[6]: y = 3'b110;
            x[5]: y = 3'b101;
            x[4]: y = 3'b100;
            x[3]: y = 3'b011;
            x[2]: y = 3'b010;
            x[1]: y = 3'b001;
            x[0]: y = 3'b000;
            default:     y = 3'b000;
        endcase
    end
    else  y = 0;
  end
  assign f = (8'b00000000 == x) ? 1'b0 : 1'b1;
  bcd7seg seg0 ({1'b0,y}, HEX0);
endmodule