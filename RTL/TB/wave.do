onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ConvWrapper_tb/DUT/ACLK
add wave -noupdate /ConvWrapper_tb/DUT/ARESETN
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_AWADDR
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_AWVALID
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_AWREADY
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_WDATA
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_WSTRB
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_WVALID
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_WREADY
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_BRESP
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_BVALID
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_BREADY
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_ARADDR
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_ARVALID
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_ARREADY
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_RDATA
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_RRESP
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_RVALID
add wave -noupdate /ConvWrapper_tb/DUT/S_AXI_RREADY
add wave -noupdate /ConvWrapper_tb/DUT/key
add wave -noupdate /ConvWrapper_tb/DUT/plaintext
add wave -noupdate /ConvWrapper_tb/DUT/ciphertext
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1018 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1482 ns}
