module stopwatch00(input btn,
             input clk,
             input save,
             input outres,
             output reg led,
             output reg ledr,
             output reg ledg,
             output reg ledb,
             output reg [8:0] leds,  // to be off
             output reg [11:0]ledsindicates,
             output reg [7:0] cs,
             output reg [7:0] ds,
             output reg [7:0] s,
             output reg [7:0] ss,
             output reg [7:0] m,
             output reg [7:0] mm);
reg btn_f = 0;
reg save_f = 0;
reg btn_is_stop = 0;
integer i = 0;
integer ledind = 0;
integer step = 1;
reg [10:0] index = 0;
reg [10:0] showindex = 0;
reg [31:0] ticks;
reg [7:0] csecs = 0;
reg [7:0] secs = 0;
reg [7:0] mins = 0;
reg [7:0] numbers [9:0];
reg [7:0] numbersdot [9:0];
reg [7:0] results [9:0][5:0];

initial begin
  numbers[0] = 8'b11000000;
  numbers[1] = 8'b11111001;
  numbers[2] = 8'b10100100;
  numbers[3] = 8'b10110000;
  numbers[4] = 8'b10011001;
  numbers[5] = 8'b10010010;
  numbers[6] = 8'b10000010;
  numbers[7] = 8'b11111000;
  numbers[8] = 8'b10000000;
  numbers[9] = 8'b10010000;
  numbersdot[0] = 8'b01000000;
  numbersdot[1] = 8'b01111001;
  numbersdot[2] = 8'b00100100;
  numbersdot[3] = 8'b00110000;
  numbersdot[4] = 8'b00011001;
  numbersdot[5] = 8'b00010010;
  numbersdot[6] = 8'b00000010;
  numbersdot[7] = 8'b01111000;
  numbersdot[8] = 8'b00000000;
  numbersdot[9] = 8'b00010000;
  for (i = 0;i < 9;i = i + 1)
      leds[i] = 0;
  ledr = 0;
  ledg = 0;
  ledb = 0;
  btn_f = 0;
  save_f = 0;
  led = 1;
  btn_is_stop = 0;
  cs = numbers[0];
  ds = numbers[0];
  s = numbersdot[0] ;
  ss = numbers[0];
  m = numbersdot[0];
  mm = numbers[0];
end
always@(posedge clk)
  begin
    if (btn_is_stop == 0)
      begin
        if (outres == 0)
          begin
            ledg = 0;
            ledr = 1;
            ledb = 0;
          end
        else
          begin
            ledg = 0;
            ledr = 0;
            ledb = 1;
          end
      end
    if (btn_is_stop == 1)
      begin
    if (ticks == 500000)
       begin
       ledg = 1;
       ledr = 0;
       ledb = 0;
          ticks = 0;
          if (csecs == 99)
            begin
              csecs = 0;
              if (secs == 59)
                begin
                  secs = 0;
                  mins = mins + 1;
                end
              else
                secs = secs + 1;
            end
          else
            csecs = csecs + 1;
           if (csecs == 0 || csecs == 5)
                led = ~led;
			  if ((csecs % 9 == 0) && (csecs != 99))
					begin
						integer j = 0;
						for (j = 0; j < 12; j = j + 1)
							ledsindicates[j] = 0;
					ledsindicates[ledind] = 1;
					ledind = ledind + step;
					if (ledind == -1 || ledind == 12)
						begin
							if (step == 1)
								step = -1;
							else
								step = 1;
							ledind = ledind + 2 * step;
						end
					end
        end
		  
    else
      ticks = ticks + 1;
    cs = numbers[csecs % 10];
    ds = numbers[csecs / 10];
    s = numbersdot[secs % 10] ;
    ss = numbers[secs / 10];
    m = numbersdot[mins % 10];
    mm = numbers[mins / 10];
    end
    if (btn == 0 &&  btn_f == 0)
    begin
      btn_f = 1;
      if (btn_is_stop == 0)
        begin
          btn_is_stop = 1;
          showindex = 0;
        end
      else
        btn_is_stop = 0;
    end
    else if (btn == 1 && btn_f == 1)
      btn_f = 0;
    if (save == 0 && save_f == 0)
      begin
        save_f = 1;
        if (outres == 0)
          begin
            if (btn_is_stop == 0)
              begin
                for(i = 0;i < 12;i = i + 1)
                  ledsindicates[i] = 0;
                led = 1;
                csecs = 0;
                secs = 0;
					 mins = 0;
                index = 0;
                showindex = 0;
                cs = numbers[csecs % 10];
                ds = numbers[csecs / 10];
                s = numbersdot[secs % 10] ;
                ss = numbers[secs / 10];
                m = numbersdot[mins % 10];
                mm = numbers[mins / 10];
              end
            else
              begin
                results[index][0] = cs;
                results[index][1] = ds;
                results[index][2] = s;
                results[index][3] = ss;
                results[index][4] = m;
                results[index][5] = mm;
                index = index + 1;
              end
          end
        else
          begin
            if (btn_is_stop == 0)
              begin
                cs = results[showindex%index][0];
                ds = results[showindex%index][1];
                s = results[showindex%index][2];
                ss = results[showindex%index][3];
                m = results[showindex%index][4];
                mm = results[showindex%index][5];
                showindex = showindex + 1;
              end
          end
      end
    else if (save == 1 && save_f == 1)
      save_f = 0;
  end
endmodule
