module MixColumns #(parameter enc_dec=0)(
    input  [0 : 127] in,
    output [0 : 127] out
);

wire [0:31] matrix   [0:3];
wire [0:31] state    [0:127];   //state 4 columns and (width/4) rows

genvar i;
generate
    for (i = 0 ; i < 4 ; i = i + 1) begin : mix_column1
        assign state[i] = in[(i*32) +: 32];
    end
endgenerate

generate
    for (i = 0 ; i < 4 ; i = i + 1) begin : mix_column2
        assign out[(i*32) +: 32] = {
            mul(state[i][0:7] , matrix[0][0:7]) ^ mul(state[i][8:15] , matrix[0][8:15]) ^ mul(state[i][16:23] , matrix[0][16:23]) ^  mul(state[i][24:31] , matrix[0][24:31]),
            mul(state[i][0:7] , matrix[1][0:7]) ^ mul(state[i][8:15] , matrix[1][8:15]) ^ mul(state[i][16:23] , matrix[1][16:23]) ^  mul(state[i][24:31] , matrix[1][24:31]),
            mul(state[i][0:7] , matrix[2][0:7]) ^ mul(state[i][8:15] , matrix[2][8:15]) ^ mul(state[i][16:23] , matrix[2][16:23]) ^  mul(state[i][24:31] , matrix[2][24:31]),
            mul(state[i][0:7] , matrix[3][0:7]) ^ mul(state[i][8:15] , matrix[3][8:15]) ^ mul(state[i][16:23] , matrix[3][16:23]) ^  mul(state[i][24:31] , matrix[3][24:31])
        };
    end
    
endgenerate

generate
    if(!enc_dec)begin
        assign matrix[0] = 32'h02_03_01_01;
        assign matrix[1] = 32'h01_02_03_01;
        assign matrix[2] = 32'h01_01_02_03;
        assign matrix[3] = 32'h03_01_01_02;
        end
    else begin
        assign matrix[0] = 32'h0e_0b_0d_09;
        assign matrix[1] = 32'h09_0e_0b_0d;
        assign matrix[2] = 32'h0d_09_0e_0b;
        assign matrix[3] = 32'h0b_0d_09_0e;
    end
endgenerate

// --------------------------------------------------------------
function [7:0] mul (          
    input [7:0] op,
    input [7:0] m
);
 begin
    case (m)
        8'h01 :  mul = op;
        8'h02 :  mul = (mul_2(op));                                                 // op * 2  ===> op << 1
        8'h03 :  mul = (mul_2(op) ^ op);                                            // op * 3  ===> op << 1 + op 
        8'h09 :  mul = (mul_2(mul_2(mul_2(op))) ^ op);                              // op * 9  ===> op << 3 + op
        8'h0b :  mul = (mul_2(mul_2(mul_2(op))) ^ mul_2(op) ^ op);                  // op * 0b ===> op * 11 ===> op << 3 + op << 1 + op
        8'h0d :  mul = (mul_2(mul_2(mul_2(op))) ^ mul_2(mul_2(op)) ^ op);           // op * 0d ===> op * 13 ===> op << 3 + op << 2 + op
        8'h0e :  mul = (mul_2(mul_2(mul_2(op))) ^ mul_2(mul_2(op)) ^ mul_2(op));    // op * 0e ===> op * 14 ===> op << 3 + op << 2 + op << 1
        default: mul = (8'hx);
    endcase
 end    
endfunction

function [7:0] mul_2(   // mul_by_2
    input [7:0] op
    );
    begin
        if (op[7]) mul_2 = ((op << 1) ^ 8'h1b);
        else       mul_2 = (op << 1);
    end
endfunction

endmodule
