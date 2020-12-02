module half_adder(A, B, S, C);
    //what are the input ports.
    input A;
    input B;
    //What are the output ports.
    output S;
    output C;
    //reg S,C; NOT NEEDED will cause error
     //Implement the Sum and Carry equations using Structural verilog
     xor x1(S,A,B); //XOR operation (S is output not a input)
     and a1(C,A,B); //AND operation 
 endmodule

//Declare the ports for the full adder module
module full_adder( A, B, Cin, S, Cout); // (Port names)

    //what are the input ports.
    input A;
    input B;
    input Cin;

    //What are the output ports.
    output S;
    output Cout;
    //reg  A,B,Cin; //(Doesn't need to be reg, it will cause an error
    wire Sa1, Ca1, Ca2;    
     //Two instances of half adders used to make a full adder
     half_adder a1(.A(A),.B(B),.S(Sa1),.C(Ca1)); //S to Sa1 to match diagram
     half_adder a2(.A(Sa1),.B(Cin),.S(S),.C(Ca2));
     or  o1(Cout,Ca1,Ca2);
 endmodule

module my32bitadder(output [31:0] O, output c, input [31:0] A, B, input S);
//wires for connecting output to input
	wire Cout0in1, Cout1in2, Cout2in3, Cout3in4, Cout4in5, Cout5in6, Cout6in7, Cout7in8,
 	Cout8in9, Cout9in10, Cout10in11, Cout11in12, Cout12in13, Cout13in14, Cout14in15;
	wire Cout15in16, Cout16in17, Cout17in18, Cout18in19, Cout19in20, Cout20in21, Cout21in22,
	Cout22in23, Cout23in24, Cout24in25, Cout25in26, Cout26in27, Cout27in28, Cout28in29, Cout29in30, Cout30in31;

	full_adder Add0 ( A[0], B[0], S, O[0], Cout0in1); 
	full_adder Add1 ( A[1], B[1], Cout0in1, O[1], Cout1in2); 
	full_adder Add2 ( A[2], B[2], Cout1in2, O[2], Cout2in3); 
	full_adder Add3 ( A[3], B[3], Cout2in3, O[3], Cout3in4); 
	full_adder Add4 ( A[4], B[4], Cout3in4, O[4], Cout4in5); 
	full_adder Add5 ( A[5], B[5], Cout4in5, O[5], Cout5in6); 
	full_adder Add6 ( A[6], B[6], Cout5in6, O[6], Cout6in7); 
	full_adder Add7 ( A[7], B[7], Cout6in7, O[7], Cout7in8); 
	full_adder Add8 ( A[8], B[8], Cout7in8, O[8], Cout8in9); 
	full_adder Add9 ( A[9], B[9], Cout8in9, O[9], Cout9in10); 
	full_adder Add10 ( A[10], B[10], Cout9in10, O[10], Cout10in11); 
	full_adder Add11 ( A[11], B[11], Cout10in11, O[11], Cout11in12);
	full_adder Add12 ( A[12], B[12], Cout11in12, O[12], Cout12in13); 
	full_adder Add13 ( A[13], B[13], Cout12in13, O[13], Cout13in14); 
	full_adder Add14 ( A[14], B[14], Cout13in14, O[14], Cout14in15);  
	full_adder Add15 ( A[15], B[15], Cout14in15, O[15], Cout15in16);  
	full_adder Add16 ( A[16], B[16], Cout15in16, O[16], Cout16in17);  
	full_adder Add17 ( A[17], B[17], Cout16in17, O[17], Cout17in18);  
	full_adder Add18 ( A[18], B[18], Cout17in18, O[18], Cout18in19);  
	full_adder Add19 ( A[19], B[19], Cout18in19, O[19], Cout19in20);  
	full_adder Add20 ( A[20], B[20], Cout19in20, O[20], Cout20in21);  
	full_adder Add21 ( A[21], B[21], Cout20in21, O[21], Cout21in22);
	full_adder Add22 ( A[22], B[22], Cout21in22, O[22], Cout22in23);
	full_adder Add23 ( A[23], B[23], Cout22in23, O[23], Cout23in24);
	full_adder Add24 ( A[24], B[24], Cout23in24, O[24], Cout24in25);
	full_adder Add25 ( A[25], B[25], Cout24in25, O[25], Cout25in26);
	full_adder Add26 ( A[26], B[26], Cout25in26, O[26], Cout26in27);
	full_adder Add27 ( A[27], B[27], Cout26in27, O[27], Cout27in28);
	full_adder Add28 ( A[28], B[28], Cout27in28, O[28], Cout28in29);
	full_adder Add29 ( A[29], B[29], Cout28in29, O[29], Cout29in30);
	full_adder Add30 ( A[30], B[30], Cout29in30, O[30], Cout30in31);
	full_adder Add31 ( A[31], B[31], Cout30in31, O[31], c);
endmodule

module myexp(output reg[31:0] O, output reg Done, output Cout, input [15:0] A, B, input Load,Clk,Reset,Cin);
reg[1:0] state;
reg[31:0] A_reg, B_reg, A_temp, O_reg, B_temp,C_reg;
wire[31:0] O_temp;

my32bitadder dut1(O_temp, Cout, A_temp, B_temp, Cin);

always@(posedge Clk)
begin
if(Reset)
state <= 0;
else
case(state)
	0: if(Load)begin
		A_reg <= A; 
		B_reg <= A; 
		C_reg <= B;
		O_reg <= A; 
		A_temp <= A;
		state <= 1;
                Done <= 0;
                O <= 0;
		end
	1: begin
		//A_temp <= A_reg; 
		B_temp <= O_reg; 
		B_reg <= B_reg - 1; 
		state <= 2;
		end
	2: begin
		O_reg <= O_temp;
		if(B_reg>1) state <= 1;
		else begin
			state <= 3; 
			//Done <= 1;
			O <= O_temp;
			C_reg <= C_reg - 1;
			end
		end
	3: begin
		O_reg <= O_temp; //RELOAD
		if(C_reg>1)  
			begin
			B_reg <= A;
			A_temp <= O_temp;
			state <= 1;
			end
		else begin
			state <= 4; 
			Done <= 1;
			O <= O_temp;
			end
		end
	4: begin
		Done <= 0; 
		state <= 0;
		end

endcase
end
endmodule


module myexp_tb;
reg clk, reset, load, cin;
reg [15:0] a, b;
wire done, cout;
wire[31:0] out;

myexp dut(out, done, cout, a, b, load, clk, reset, cin);

always #5 clk = ~clk;
initial
begin
clk = 0;
cin = 0;
reset = 1;
load = 1;
a = 16'd9; 
b = 16'd3;
#10 reset = 0;
#10 load = 0;
#400 $display (" A = %d, B = %d, O = %d", a, b, out);

#10 $finish;
end
endmodule

module fullsubtractor (output [15:0] O, input [15:0] x, y );
 
assign O = x - y;
 
endmodule


module mymodfunc(output reg[15:0] O, output reg Done, input [15:0] A, B, input Load,Clk,Reset);
reg[1:0] state;
reg[15:0]  A_temp, O_reg, B_temp;
wire[15:0] O_temp;

fullsubtractor dut1(O_temp,  A_temp, B_temp);

always@(posedge Clk)
begin
if(Reset)
state <= 0;
else
case(state)
	0: if(Load)begin
		A_temp <= A; 
		B_temp <= B; 
		O_reg <= A; 
		state <= 1;
                Done <= 0;
                O <= 0;
		end
	1: begin
		A_temp <= O_reg;  
		state <= 2;
		end
	2: begin
		O_reg <= O_temp;
		if(A_temp>B) state <= 1;
		else begin
			state <= 3; 
			Done <= 1;
			O <= A_temp;
			end
		end
	3: begin
		Done <= 0; 
		state <= 0;
		end

endcase
end
endmodule

module mymodfunc_tb;
reg clk, reset, load;
reg [15:0] a, b;
wire done;
wire[15:0] out;

mymodfunc mod1(out, done, a, b, load, clk, reset);

always #5 clk = ~clk;
initial
begin
clk = 0;
reset = 1;
load = 1;
a = 16'd1456; 
b = 16'd9;
#10 reset = 0;
#10 load = 0;
#3400 $display (" %d module %d = %d", a, b, out);

#10 $finish;
end
endmodule

module proj2 (output reg[15:0] Cal_val, output reg Cal_done, input [15:0] private_key, 
public_key, message_val, input clk,Start,Rst);
reg [15:0] pvt,pub,msg,part1;
reg load,reload, cin=0;
wire [31:0] expout;
wire [15:0] modout;
wire expdone, cout,moddone;
reg [3:0] state;

myexp ex1(expout, expdone, cout, msg, pvt, load, clk, Rst, cin);
mymodfunc dut(modout, moddone, part1, pub, reload, clk, Rst);

always@(posedge clk)
begin
if(Rst)
	state <= 0;
else
case(state)

0: if (Start) begin
	Cal_val <=0;
	Cal_done <=0;
	pvt <= private_key;
	pub <= public_key;
 	msg <= message_val;
	state <= 1;
	end
1: begin 
	load <=1; 
	state <=2;
	end

2: begin 
	load <=0; 
	state <=3;
	end
3: begin 
	if (expdone) begin 
		state <= 4; 
		part1 <= expout;
			end
	else state <=3; 
	end
4: begin
	reload <=1;
	state <=5;
	end
5: begin
	reload <=0;
	state <=6;
	end
6: begin
	if (moddone) state <= 7;
	else state <=6;
	end
7: begin
	Cal_val <=modout;
	Cal_done <=1;
	state <=0;
	end
endcase 
end
endmodule


module proj2_tb;
reg clock, rst, start;
reg [15:0] msg,prv,pub;
wire done;
wire[15:0] out;

proj2 dut(out, done, prv, pub, msg, clock, start, rst);

always #5 clock = ~clock;

always @(proj2_tb.dut.state)
case (proj2_tb.dut.state)
0: $display($time," Capture_state");
1: $display($time," Exponent_state1");
2: $display($time," Exponent_state2");
3: $display($time," Exponent_state3");
4: $display($time," Mod_state1");
5: $display($time," Mod_state2");
6: $display($time," Mod_state3");
7: $display($time," Cal_done");
endcase

initial begin
clock = 0;
rst = 1;
start = 1;
prv = 16'd3; 
pub = 16'd33;
msg = 16'd9;
#10 rst = 0;
#10 start = 0;
#970 $display ("INPUTS: \nMessage    %d \nPrivate Key%d \nPublic Key  %d \n-----------------\nOUTPUT:    %d\n", msg, prv, pub, out);
#10 $finish;
end
endmodule

