
module ReadImage(o_XLK, o_to_RAM, o_RAM_Adress, o_RAM_Write_Enable, i_D, i_PLK, i_Clk, i_VS, i_HS, i_EnableCameraRead);

input [7:0]i_D;
output o_XLK;
output reg [7:0]o_to_RAM = 0;
output reg [14:0]o_RAM_Adress = 0;
output reg [0:0]o_RAM_Write_Enable;
input i_PLK, i_Clk, i_VS, i_HS, i_EnableCameraRead;

reg [2:0]s_Clock_Count = 0;
reg s_Clock_Value = 1;
reg PLK_Current_Value = 1'b0;
reg PLK_Previous_Value = 1'b0;


assign o_XLK = s_Clock_Value;
assign PLK_Posedge = PLK_Current_Value & (~PLK_Previous_Value);

    always @(posedge i_Clk) begin

      PLK_Current_Value <=  i_PLK;
      PLK_Previous_Value <=  PLK_Current_Value;

      if (s_Clock_Count <4) begin
        s_Clock_Count <= s_Clock_Count +1;
      end
      else begin
        s_Clock_Count <=0;
        s_Clock_Value <= ~s_Clock_Value;
      end

      o_to_RAM <= i_D;
      //o_to_RAM <= o_RAM_Adress[12:5] + 1;//////////Esto nos lo sacamos del ojete

      if (PLK_Posedge == 1'b1) begin
        if((i_VS == 1'b0) && (i_EnableCameraRead == 1'b1)) begin
          if (i_HS == 1'b1) begin
            o_RAM_Write_Enable <= 1'b1;
            o_RAM_Adress <= o_RAM_Adress+1;
          end
          else begin
            o_RAM_Write_Enable <= 1'b0;
            o_RAM_Adress <= o_RAM_Adress;
          end
        end
        else begin
          o_RAM_Write_Enable <= 1'b0;
          o_RAM_Adress <= 0;
        end
      end

      else begin
        o_RAM_Write_Enable <= 1'b0;
        o_RAM_Adress <= o_RAM_Adress;
      end
    end


endmodule
