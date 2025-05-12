//module aes_axi_wrapper #(
module AES_DEC_AXI_wrapper #(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 32
)(
// AXI Clock and Reset
    input wire                      ACLK,
    input wire                      ARESETN,

// Write Address Channel
    input wire [ADDR_WIDTH-1:0]     S_AXI_AWADDR,
    input wire                      S_AXI_AWVALID,
    output reg                      S_AXI_AWREADY,
// Write Data Channel
    input wire [0:DATA_WIDTH-1]     S_AXI_WDATA,
    input wire [(DATA_WIDTH/8)-1:0] S_AXI_WSTRB,  
    input wire                      S_AXI_WVALID,
    output reg                      S_AXI_WREADY,
// Write Response Channel
    output wire [1:0]               S_AXI_BRESP,
    output reg                      S_AXI_BVALID,
    input wire                      S_AXI_BREADY,
// Read Address Channel
    input wire [ADDR_WIDTH-1:0]     S_AXI_ARADDR,
    input wire                      S_AXI_ARVALID,
    output reg                      S_AXI_ARREADY,
// Read Data Channe
    output reg [0:DATA_WIDTH-1]     S_AXI_RDATA,
    output wire[1:0]                S_AXI_RRESP,
    output reg                      S_AXI_RVALID,
    input  wire                     S_AXI_RREADY
);

    assign {S_AXI_BRESP,S_AXI_RRESP} = 0;   // OK
    // Internal AES control
    reg  [0:127] key;
    wire  [0:127] plaintext;
    reg  [0:127] ciphertext;

  
    // Write state
    reg [ADDR_WIDTH-1:0] wr_addr;
    reg [ADDR_WIDTH-1:0] rd_addr;

    integer i;


    // Write address channel
	always @(posedge ACLK) begin
        if (!ARESETN) begin
            S_AXI_AWREADY <= 1'b0;
            wr_addr <= 0;
        end else if (S_AXI_AWVALID && !S_AXI_AWREADY) begin
            S_AXI_AWREADY <= 1'b1;
            wr_addr <= S_AXI_AWADDR;
        end else begin
            S_AXI_AWREADY	 <= 1'b0;
        end
        end

    // Write data channel
	always @(posedge ACLK) begin
		if (!ARESETN) begin
			S_AXI_WREADY <= 1'b0;
		end else if (S_AXI_WVALID && !S_AXI_WREADY) begin
			S_AXI_WREADY    <= 1'b1;
		end else begin
			S_AXI_WREADY	 <= 1'b0;
		end
	end

    // Write data register
	always @(posedge ACLK) begin
		if (!ARESETN) begin
			ciphertext <= 128'd0;
			key <= 128'd0;
		end else begin
            if (S_AXI_WVALID && S_AXI_WREADY) begin
                if (wr_addr <= 'h0c) begin
                    for (i = 0; i<4 ; i=i+1) begin
                        if (S_AXI_WSTRB[i])
                        ciphertext[(wr_addr*8 + i*8) +: 8] <= S_AXI_WDATA[8*i +: 8];
                    end    
         
                end else if (wr_addr <= 'h1c) begin
                    for (i = 0; i<4 ; i=i+1 ) begin
                        if (S_AXI_WSTRB[i])
                            key[(((wr_addr-16)*8) + i*8) +: 8] <= S_AXI_WDATA[8*i +: 8];
                    end  
                end              
            end 
            
        end
			// case (wr_addr)  // [(wr_addr*8 + i*8) +: 8] 
            //         6'h00: ciphertext[0:31]   <= S_AXI_WDATA;
            //         6'h04: ciphertext[32:63]  <= S_AXI_WDATA;
            //         6'h08: ciphertext[64:95]  <= S_AXI_WDATA;
            //         6'h0c: ciphertext[96:127] <= S_AXI_WDATA;
            //         6'h10: key[0:31]    <= S_AXI_WDATA;
            //         6'h14: key[32:63]   <= S_AXI_WDATA;
            //         6'h18: key[64:95]   <= S_AXI_WDATA;
            //         6'h1c: key[96:127]  <= S_AXI_WDATA;
            //         default:;
            //     endcase
		end

    // Write Response Channel
    always @(posedge ACLK) begin
        if (!ARESETN) begin
            S_AXI_BVALID <= 1'b0;
        end else if (S_AXI_AWVALID && S_AXI_AWREADY && S_AXI_WVALID && S_AXI_WREADY) begin
            S_AXI_BVALID <= 1'b1;
        end else if (S_AXI_BVALID && S_AXI_BREADY) begin
            S_AXI_BVALID <= 1'b0;
        end
    end

    
       
// Read Address Channel
    always @(posedge ACLK) begin
        if (!ARESETN) begin
            S_AXI_ARREADY <= 1'b0;
            rd_addr <= 6'b0;
        end else if (S_AXI_ARVALID && !S_AXI_ARREADY) begin
            S_AXI_ARREADY <= 1'b1;
            rd_addr <= S_AXI_ARADDR;
        end else begin
            S_AXI_ARREADY <= 1'b0;
        end
    end


    // Read Data Channel
    always @(posedge ACLK) begin
        if (!ARESETN) begin
            S_AXI_RDATA    <= 32'b0;
            S_AXI_RVALID   <= 1'b0;
        end else if (S_AXI_ARVALID && S_AXI_ARREADY) begin
            S_AXI_RVALID <= 1'b1;
            case (S_AXI_ARADDR)
                6'h00: S_AXI_RDATA <= ciphertext[0:31]  ;
                6'h04: S_AXI_RDATA <= ciphertext[32:63] ;
                6'h08: S_AXI_RDATA <= ciphertext[64:95] ;
                6'h0c: S_AXI_RDATA <= ciphertext[96:127];
                6'h10: S_AXI_RDATA <= key[0:31]   ; 
                6'h14: S_AXI_RDATA <= key[32:63]  ; 
                6'h18: S_AXI_RDATA <= key[64:95]  ; 
                6'h1c: S_AXI_RDATA <= key[96:127] ; 
                6'h20: S_AXI_RDATA <= plaintext[0:31]  ;
                6'h24: S_AXI_RDATA <= plaintext[32:63] ;
                6'h28: S_AXI_RDATA <= plaintext[64:95] ;
                6'h2c: S_AXI_RDATA <= plaintext[96:127];                    default: S_AXI_RDATA <= 32'h0;
            endcase

        end else if (S_AXI_RVALID && S_AXI_RREADY) begin
            S_AXI_RVALID <= 1'b0;
        end
    end

           

    AES_decrypt aes_dec_inst (
        .key(key),
        .plain_txt(plaintext),
        .cipher_d_txt(ciphertext)
    );

endmodule
