module AES_top #(
    parameter key_length = 128
) (
    input  [0:127] plain_txt,
    input  [0:key_length-1] key,
    output [0:127] cipher_txt
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
    .state(plain_txt),
    .round_key(expanded_key[0:127]),
    .new_state(round_states[0])
);

genvar i;
generate
    for (i = 1; i < Nr; i = i + 1) begin : AES_encr
        wire [0:127] sub_out, shift_out, mix_out;

        subByte sub_inst (
            .in(round_states[i-1]),
            .out(sub_out)
        );

        ShiftRows #(.enc_dec(0)) shift_inst (
            .state(sub_out),
            .new_state(shift_out)
        );

        MixColumns #(.enc_dec(0)) mix_inst (
            .in(shift_out),
            .out(mix_out)        
        );

        AddRoundKey add_inst_round (
            .state(mix_out),
            .round_key(expanded_key[i*128 +: 128]),
            .new_state(round_states[i])
        );
    end
endgenerate

subByte sub_inst_final (
    .in(round_states[Nr-1]),
    .out(sub_out_final)
);

ShiftRows #(.enc_dec(0)) shift_inst_final (
    .state(sub_out_final),
    .new_state(shift_out_final)
);

AddRoundKey add_inst_final (
    .state(shift_out_final),
    .round_key(expanded_key[Nr*128+:128]),
    .new_state(cipher_txt)        
);

endmodule
