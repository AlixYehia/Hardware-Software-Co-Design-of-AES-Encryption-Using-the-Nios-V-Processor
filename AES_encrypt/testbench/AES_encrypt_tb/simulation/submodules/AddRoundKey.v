module AddRoundKey(
    input [0:127] state,
    input [0:127] round_key,
    output [0:127] new_state
);
    assign new_state = state ^ round_key; 
endmodule
