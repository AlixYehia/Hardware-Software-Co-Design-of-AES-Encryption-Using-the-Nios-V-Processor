module ShiftRows #(parameter enc_dec = 0)(
    input [0:127] state,
    output [0:127] new_state
);
    wire [7:0] s [0:15];

    assign {s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7],
            s[8], s[9], s[10], s[11], s[12], s[13], s[14], s[15]} = state;

    generate
        if (enc_dec == 0) begin : ENCRYPTION
            assign new_state = {s[0], s[5], s[10], s[15],  
                                s[4], s[9], s[14], s[3],  
                                s[8], s[13], s[2], s[7], 
                                s[12], s[1], s[6], s[11]};
        end else begin : DECRYPTION
            assign new_state = {s[0], s[13], s[10], s[7],  
                                s[4], s[1], s[14], s[11],  
                                s[8], s[5], s[2], s[15], 
                                s[12], s[9], s[6], s[3]};

        end
    endgenerate

endmodule 
