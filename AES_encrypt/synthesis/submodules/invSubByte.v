module invSubByte(
input 	wire	[0:127] in,
output 	wire	[0:127] out);

genvar i;
generate 
for(i=0;i<128;i=i+8) begin : invSub_byte
	invSbox s(in[i +:8],out[i +:8]);
	end
endgenerate


endmodule 
