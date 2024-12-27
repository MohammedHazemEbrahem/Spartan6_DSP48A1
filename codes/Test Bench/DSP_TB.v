module DSP_tb();
	reg clk,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,
	RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,CARRYIN;
	reg [7:0] opmode ;
	reg [17:0]A,B,D,BCIN ;
	reg [47:0] C, PCIN ;
	wire CARRYOUT,CARRYOUTF,CARRYOUT_2,CARRYOUTF_2 ;
	wire [17:0] BCOUT,BCOUT_2 ;
	wire [35:0] M,M2;
	wire [47:0] P,P_2 ,PCOUT,PCOUT_2 ;

	DSPP dut(A,B,C,D,CARRYIN,clk,opmode,BCIN,
	CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,
	RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,
	BCOUT,PCIN,PCOUT,M,P,CARRYOUT,CARRYOUTF);


	DSPP #(.CARRYINSEL("CARRYIN"),.B_INPUT("CASCADE"),.RSTTYPE("ASYNC")) dut_2(A,B,C,D,CARRYIN,clk,opmode,BCIN,
	CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,
	RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,
	BCOUT_2,PCIN,PCOUT_2,M2,P_2,CARRYOUT_2,CARRYOUTF_2);


	initial begin
		clk=1;
		forever #2 clk=~clk;
	end
	integer i ;

	initial begin
		RSTA=1;RSTB=1;RSTC=1;RSTCARRYIN=1;
		RSTD=1;RSTM=1;RSTOPMODE=1;RSTP=1;
		for(i=0 ; i<10;i=i+1) begin
			@(negedge clk);
			A=$random; B=$random; C=$random; D=$random;BCIN=$random ; PCIN=$random; opmode=$random;
			CARRYIN=$random; CEA=$random; CEB=$random; CEC=$random; CECARRYIN=$random;
			CED=$random; CEM=$random; CEP=$random; CEOPMODE=$random;
			#5;
			//TESTING INTERNAL SYNCH RESET 
			if(dut.B1!=0||dut.A1!=0||dut.D_mux!=0||dut.C_mux!=0||
				dut.opmode_mux!=0||dut.M!=0||dut.CIN!=0||dut.CARRYOUT!=0||dut.P!=0) begin
				$display("Error in SYNCH RESET functionality ") ;
				$stop;
			end
			
			if(dut_2.B1!=0||dut_2.A1!=0||dut_2.D_mux!=0||dut_2.C_mux!=0||
				dut_2.opmode_mux!=0||dut_2.M!=0||dut_2.CIN!=0||dut_2.CARRYOUT!=0||dut_2.P!=0) begin
				$display("Error in ASYNCH RESET functionality ") ;
				$stop;
			end
		end
		$display("RESET TEST PASSED") ;



		RSTA=0;RSTB=0;RSTC=0;RSTCARRYIN=0;
		RSTD=0;RSTM=0;RSTOPMODE=0;RSTP=0;
		CEA=0;CEB=0;CEC=0;CECARRYIN=0;CED=0;CEM=0;CEOPMODE=0;CEP=0;
		for(i=0 ; i<10;i=i+1) begin
			@(negedge clk);
			A=$random; B=$random; C=$random; D=$random;BCIN=$random ; PCIN=$random; opmode=$random;
			CARRYIN=$random; 
			#5;
		
			if(dut.B1!=0||dut.A1!=0||dut.D_mux!=0||dut.C_mux!=0||
				dut.opmode_mux!=0||dut.M!=0||dut.CIN!=0||dut.CARRYOUT!=0||dut.P!=0) begin
				$display("Error in CLOCK ENABLE functionality ") ;
				$stop;
			end
		
			if(dut_2.B1!=0||dut_2.A1!=0||dut_2.D_mux!=0||dut_2.C_mux!=0||
				dut_2.opmode_mux!=0||dut_2.M!=0||dut_2.CIN!=0||dut_2.CARRYOUT!=0||dut_2.P!=0) begin
				$display("Error in CLOCK ENABLE functionality ") ;
				$stop;
			end
		end
		$display("CLOCK ENABLE TEST PASSED") ;


		@(negedge clk) ;
		CEA=1;CEB=1;CEC=1;CECARRYIN=1;CED=1;CEM=1;CEOPMODE=1;CEP=1;
		A=1;B=2;C=3;D=4; opmode='b00111101 ; BCIN =5; CARRYIN =0;
	
		repeat(5) @(negedge clk) ;


		opmode='b00000011 ; BCIN =10; CARRYIN =1;
	
		repeat(5) @(negedge clk) ;

		opmode='b10011010 ; BCIN =5; CARRYIN =0;

		repeat(5) @(negedge clk) ;

		opmode='b10100101 ; BCIN =10; CARRYIN =0; PCIN =100;

		repeat(10) @(negedge clk) ;

		$stop ;
	end	
endmodule		
