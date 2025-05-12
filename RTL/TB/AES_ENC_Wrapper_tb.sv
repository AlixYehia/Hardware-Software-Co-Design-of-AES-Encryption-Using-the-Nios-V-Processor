module AES_ENC_Wrapper_tb;
    

    parameter clk_period = 20;

    bit                             ACLK;
    bit                             ARESETn;
    reg         [5:0]               AWADDR;
    reg                             AWVALID;
    reg         [2:0]               AWPROT;
    wire                            AWREADY;
    reg         [0:31]              WDATA;
    reg         [5:0]               WSTRB;
    reg                             WVALID;
    wire                            WREADY;
    reg                             BREADY;
    reg                             BVALID;
    wire        [1:0]               BRESP; 
    reg         [5:0]               ARADDR;
    reg                             ARVALID;
    reg         [2:0]               ARPROT;
    wire                            ARREADY;
    reg                             RREADY;
    wire        [0:31]              RDATA;
    wire        [1:0]               RRESP;    
    reg                             RVALID;



always #(clk_period/2) ACLK = ~ACLK;


AES_AXI_wrapper DUT (
    .ACLK(ACLK),
    .ARESETN(ARESETn),
    .S_AXI_AWADDR(AWADDR),
    .S_AXI_AWVALID(AWVALID),
    .S_AXI_AWREADY(AWREADY),
    .S_AXI_WDATA(WDATA),
    .S_AXI_WSTRB(WSTRB), 
    .S_AXI_WVALID(WVALID),
    .S_AXI_WREADY(WREADY),
    .S_AXI_BRESP(BRESP),
    .S_AXI_BVALID(BVALID),
    .S_AXI_BREADY(BREADY),
    .S_AXI_ARADDR(ARADDR),
    .S_AXI_ARVALID(ARVALID),
    .S_AXI_ARREADY(ARREADY),
    .S_AXI_RDATA(RDATA),
    .S_AXI_RRESP(RRESP),
    .S_AXI_RVALID(RVALID),
    .S_AXI_RREADY(RREADY)
);




initial begin
    
    #(2*clk_period);
    ARESETn = 1;

// Data 10
    AWADDR = 'h10;
    AWVALID = 1'b1;
    @ (AWREADY)
    @ (posedge ACLK)
    AWVALID = 0;
    WDATA = 32'h00010203;
    WVALID = 1'b1;
    WSTRB = 4'b1111;
    
    @(WREADY);
    @ (posedge ACLK)
    WVALID = 0;
    
// Data 14
        AWADDR = 'h14;
        AWVALID = 1'b1;
        @ (AWREADY)
        @ (posedge ACLK)
        AWVALID = 0;
        WDATA = 32'h04050607;
        WVALID = 1'b1;
        WSTRB = 4'b1111;
        
        @(WREADY);
        @ (posedge ACLK)
        WVALID = 0;
// Data 18
    AWADDR = 'h18;
    AWVALID = 1'b1;
    @ (AWREADY)
    @ (posedge ACLK)

    AWVALID = 0;
    WDATA = 32'h08090a0b;
    WVALID = 1'b1;
    WSTRB = 4'b1111;
    
    @(WREADY);
    @ (posedge ACLK)

    WVALID = 0;

// Data 1c
    AWADDR = 'h1c;
    AWVALID = 1'b1;
    @ (AWREADY)
    @ (posedge ACLK)
    AWVALID = 0;
    WDATA = 32'h0c0d0e0f;
    WVALID = 1'b1;
    WSTRB = 4'b1111;
    
    @(WREADY);
    @ (posedge ACLK)
    WVALID = 0;


///**********************************************************************
///*************************** PLAIN TEXT ******************************
// Data 0
    AWADDR = 'd0;
    AWVALID = 1'b1;
    @ (AWREADY)
    @ (posedge ACLK)
    AWVALID = 0;
    WDATA = 32'h00112233;
    WVALID = 1'b1;
    WSTRB = 4'b1111;
    
    @(WREADY);
    @ (posedge ACLK)
    WVALID = 0;
// Data 4
AWADDR = 'd4;
AWVALID = 1'b1;
@ (AWREADY)
@ (posedge ACLK)

AWVALID = 0;
WDATA = 32'h44556677;
WVALID = 1'b1;
WSTRB = 4'b1111;

@(WREADY);
@ (posedge ACLK)

WVALID = 0;

// Data 8
AWADDR = 'd8;
AWVALID = 1'b1;
@ (AWREADY)
@ (posedge ACLK)
AWVALID = 0;
WDATA = 32'h8899aabb;
WVALID = 1'b1;
WSTRB = 4'b1111;

@(WREADY);
@ (posedge ACLK)
WVALID = 0;

// Data c
AWADDR = 'hc;
AWVALID = 1'b1;
@ (AWREADY)
@ (posedge ACLK)
AWVALID = 0;
WDATA = 32'hccddeeff;
WVALID = 1'b1;
WSTRB = 4'b1111;

@(WREADY);
@ (posedge ACLK)
WVALID = 0;

// ---------------------- READ ------------------------
    ARADDR = 'h20;
    ARVALID = 1;
    @(ARREADY)
    @(posedge ACLK)
    ARVALID = 0;

    RREADY = 1;
    @(RVALID) 
    RREADY = 0;
  //------------------------  
    ARADDR = 'h24;
    ARVALID = 1;
    @(ARREADY)
    @(posedge ACLK)
    
    ARVALID = 1;
    @(posedge ACLK)
    
    ARVALID = 0;

    RREADY = 1;
    @(RVALID) 
    RREADY = 0;

  //------------------------  
    ARADDR = 'h28;
    ARVALID = 1;
    @(ARREADY)
    @(posedge ACLK)
    
    ARVALID = 1;
    @(posedge ACLK)
    
    ARVALID = 0;

    RREADY = 1;
    @(RVALID) 
    RREADY = 0;

  //------------------------  
    ARADDR = 'h2c;
    ARVALID = 1;
    @(ARREADY)
    @(posedge ACLK)
    
    ARVALID = 1;
    @(posedge ACLK)
    
    ARVALID = 0;

    RREADY = 1;
    @(RVALID) 
    RREADY = 0;

  //------------------------  
    

    #(50*clk_period);
      $stop;
end


endmodule