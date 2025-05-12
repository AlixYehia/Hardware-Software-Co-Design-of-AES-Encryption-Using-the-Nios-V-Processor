//module aes_axi_wrapper #(
module AES_AXI_wrapper #(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 32
)(

    input wire                      ACLK,
    input wire                      ARESETN,

// AXI4-Lite slave signals
    input wire [ADDR_WIDTH-1:0]     S_AXI_AWADDR,
    input wire                      S_AXI_AWVALID,
    output reg                      S_AXI_AWREADY,

    input wire [DATA_WIDTH-1:0]     S_AXI_WDATA,
    input wire [(DATA_WIDTH/8)-1:0] S_AXI_WSTRB,
    input wire                      S_AXI_WVALID,
    output reg                      S_AXI_WREADY,

    output reg [1:0]                S_AXI_BRESP,
    output reg                      S_AXI_BVALID,
    input wire                      S_AXI_BREADY,

    input wire [ADDR_WIDTH-1:0]     S_AXI_ARADDR,
    input wire                      S_AXI_ARVALID,
    output reg                      S_AXI_ARREADY,

    output reg [DATA_WIDTH-1:0]     S_AXI_RDATA,
    output reg [1:0]                S_AXI_RRESP,
    output reg                      S_AXI_RVALID,
    input wire                      S_AXI_RREADY
);

    // Internal AES control
    reg  [0:127] key;
    reg  [0:127] plaintext;
    wire [0:127] ciphertext;

    // Register logic
    // reg [31:0] control_reg;

    // Write state
    reg [ADDR_WIDTH-1:0] wr_addr;
    reg [ADDR_WIDTH-1:0] rd_addr;

    // Write FSM
    always @(posedge ACLK) begin
        if (!ARESETN) begin
            S_AXI_AWREADY <= 0;
            S_AXI_WREADY  <= 0;
            S_AXI_BVALID  <= 0;
            S_AXI_BRESP   <= 2'b00;
        end else begin
            // Accept address
            if (!S_AXI_AWREADY && S_AXI_AWVALID) begin
                S_AXI_AWREADY <= 1;
                wr_addr <= S_AXI_AWADDR;
            end else begin
                S_AXI_AWREADY <= 0;
            end

            // Accept write data
            if (!S_AXI_WREADY && S_AXI_WVALID) begin
                S_AXI_WREADY <= 1;

                case (wr_addr)
                    // 6'h00: control_reg  <= S_AXI_WDATA;
                    6'h00: plaintext[0:31]   <= S_AXI_WDATA;
                    6'h04: plaintext[32:63]  <= S_AXI_WDATA;
                    6'h08: plaintext[64:95]  <= S_AXI_WDATA;
                    6'h0c: plaintext[96:127] <= S_AXI_WDATA;
                    
                    6'h10: key[0:31]    <= S_AXI_WDATA;
                    6'h14: key[32:63]   <= S_AXI_WDATA;
                    6'h18: key[64:95]   <= S_AXI_WDATA;
                    6'h1c: key[96:127]  <= S_AXI_WDATA;
                    default:;
                endcase

                S_AXI_BVALID <= 1;
                S_AXI_BRESP <= 2'b00; // OKAY
            end else begin
                S_AXI_WREADY <= 0;
            end

            if (S_AXI_BVALID && S_AXI_BREADY)
                S_AXI_BVALID <= 0;
        end
    end

    // Read FSM
    always @(posedge ACLK) begin
        if (!ARESETN) begin
            S_AXI_ARREADY <= 0;
            S_AXI_RVALID  <= 0;
            S_AXI_RRESP   <= 2'b00;
            S_AXI_RDATA   <= 0;
        end else begin
            if (!S_AXI_ARREADY && S_AXI_ARVALID) begin
                S_AXI_ARREADY <= 1;
                rd_addr <= S_AXI_ARADDR;
            end else begin
                S_AXI_ARREADY <= 0;
            end

            if (S_AXI_ARVALID && !S_AXI_RVALID) begin
                S_AXI_RVALID <= 1;
                case (S_AXI_ARADDR)
                    // 6'h00: S_AXI_RDATA <= control_reg;
                    6'h20: S_AXI_RDATA <= ciphertext[0:31]  ;
                    6'h24: S_AXI_RDATA <= ciphertext[32:63] ;
                    6'h28: S_AXI_RDATA <= ciphertext[64:95] ;
                    6'h2c: S_AXI_RDATA <= ciphertext[96:127];                    default: S_AXI_RDATA <= 32'h0;
                endcase
                S_AXI_RRESP <= 2'b00; // OKAY
            end else if (S_AXI_RVALID && S_AXI_RREADY) begin
                S_AXI_RVALID <= 0;
            end
        end
    end

    // Instantiate AES core (no clk/rst/start/done)
    AES_top aes_inst (
        .key(key),
        .plain_txt(plaintext),
        .cipher_txt(ciphertext)
    );

endmodule
