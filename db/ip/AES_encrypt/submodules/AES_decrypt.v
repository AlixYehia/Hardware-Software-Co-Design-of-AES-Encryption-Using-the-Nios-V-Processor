module AES_decrypt #(
    parameter key_length = 128
) (
    input  [0:127] cipher_d_txt,
    input  [0:key_length-1] key, 
    output [0:127] plain_txt
);
parameter Nk = key_length / 32;
parameter Nr = Nk + 6;

wire [0 : (128 * (Nr + 1)) - 1] expanded_key;
wire [0:127] round_states [0:Nr-1];
wire [0:127] sub_out_final, shift_out_final;

Key_Expansion #(.Nk(Nk)) key_exp_inst (
    .key(key),
    .expanded_key(expanded_key)
); 

AddRoundKey add_inst_init (
    .state(cipher_d_txt),
    .round_key(expanded_key[Nr*128+:128]),
    .new_state(round_states[Nr-1]) ///store in 9
);

genvar i;
generate
    for (i = Nr-1; i > 0; i = i - 1) begin : AES_DECR_0
        wire [0:127] sub_out, shift_out,after_add;

        ShiftRows #(.enc_dec(1)) shift_inst (
            .state(round_states[i]),
            .new_state(shift_out)
        );

        invSubByte sub_inst (
            .in(shift_out),
            .out(sub_out)
        );

        AddRoundKey add_inst_round (
        .state(sub_out),
        .round_key(expanded_key[i*128 +: 128]),
        .new_state(after_add) 
        );

        MixColumns #(.enc_dec(1)) mix_inst (
            .in(after_add),
            .out(round_states[i-1])        
        );


    end
endgenerate

ShiftRows #(.enc_dec(1)) shift_inst ( 
    .state(round_states[0]),
    .new_state(shift_out_final)
);

invSubByte sub_inst ( 
    .in(shift_out_final),
    .out(sub_out_final)
);

AddRoundKey add_inst_final (
    .state(sub_out_final),
    .round_key(expanded_key[0:127]),
    .new_state(plain_txt)        
);

endmodule
