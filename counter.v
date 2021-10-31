/********************************************************************************************

Copyright 2018-2019 - Maven Silicon Softech Pvt Ltd. All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is considered a trade secret and is not to be divulged or used by parties who 
have not received written authorization from Maven Silicon Softech Pvt Ltd.

Maven Silicon Softech Pvt Ltd
Bangalore - 560076

Webpage: www.maven-silicon.com

Filename:	counter.v   

Description:	This is a functional description of Alarm clock
                counter unit .It generates the counting sequence for current time.

Date:		01/05/2018

Author:		Maven Silicon

Email:		online@maven-silicon.com

Version:	1.0

*********************************************************************************************/

module counter (clk,
	        reset,
		one_minute,
		load_new_c,
		new_current_time_ms_hr,
		new_current_time_ms_min,
		new_current_time_ls_hr,
		new_current_time_ls_min,
		current_time_ms_hr,
		current_time_ms_min,
		current_time_ls_hr,
		current_time_ls_min);
// Define input and output port directions
input clk, reset, one_minute, load_new_c;
input [3:0] new_current_time_ms_hr,
		new_current_time_ms_min,
		new_current_time_ls_hr,
		new_current_time_ls_min;
output reg [3:0] current_time_ms_hr,
		current_time_ms_min,
		current_time_ls_hr,
		current_time_ls_min;
// Define register to store current time
 
// Lodable Binary up synchronous Counter logic                                 /******************************

// Write an always block with asynchronous reset 
always@( posedge clk or posedge reset)                                         
 begin              
    // Check for reset signal and upon reset load the current_time register with default value (1'b0)                                                                                                       
    if(reset)
	begin
	current_time_ms_hr <= 4'd0;
	current_time_ms_min <= 4'd0;
	current_time_ls_hr <= 4'd0;
	current_time_ls_min <= 4'd0;
	end
    // Else if there is no reset, then check for load_new_c signal and load new_current_time to current_time register
     else if((!reset) && load_new_c)                                                                
	begin
	current_time_ms_hr <= new_current_time_ms_hr;
	current_time_ms_min <= new_current_time_ms_min;
	current_time_ls_hr <= new_current_time_ls_hr;
	current_time_ls_min <= new_current_time_ls_min;
	end
    // Else if there is no load_new_c signal, then check for one_minute signal and implement the counting algorithm //              0       0       0       9  -> 00:10
     else if(!(load_new_c) && one_minute) 
// first we will write for corner cases and then direct increment
	begin	
    // Check for the corner case
    // If the current_time is 23:59, then the next current_time will be 00:00
        if((current_time_ms_hr==4'd2) && (current_time_ls_hr==4'd3) && (current_time_ms_min==4'd5) && (current_time_ls_min==4'd9))
	begin 
	current_time_ms_hr <= 4'd0;
	current_time_ms_min <= 4'd0;  // 23:59 -> 00:00
	current_time_ls_hr <= 4'd0;
	current_time_ls_min <= 4'd0;	
	end 
    // Else check if the current_time is 09:59, then the next current_time will be 10:00
	else if( (current_time_ls_hr==4'd9) && (current_time_ms_min==4'd5) && (current_time_ls_min==4'd9))
	begin
	current_time_ms_hr <= current_time_ms_hr + 1'd1;
	current_time_ms_min <= 4'd0;     //09:59 -> 10:00  19:59 -> 20:00
 	current_time_ls_hr <= 4'd0;
	current_time_ls_min <= 4'd0;
	end     
    // Else check if the time represented by minutes is 59, Increment the LS_HR by 1 and set MS_MIN and LS_MIN to 1'b0
 	else if((current_time_ms_min==4'd5) && (current_time_ls_min==4'd9))
	begin
	current_time_ms_min <= 4'd0;
	current_time_ls_hr <= current_time_ls_hr + 1'd1;
	current_time_ls_min <= 4'd0;
	end
    // Else check if the LS_MIN is equal to 9, Increment the MS_MIN by 1 and set MS_MIN to 1'b0
	else if(current_time_ls_min==4'd9)
	begin
	current_time_ms_min <= current_time_ms_min + 1'd1;
	current_time_ls_min <= 4'd0;
	end
    // Else just increment the LS_MIN by 1
	else 
	current_time_ls_min <= current_time_ls_min + 1'd1;
     end
    end

endmodule

