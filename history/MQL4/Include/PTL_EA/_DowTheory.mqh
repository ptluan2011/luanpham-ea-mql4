//+------------------------------------------------------------------+
//|                                                   _DowTheory.mqh |
//|                                                        Luan Pham |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luan Pham"
#property link      ""
#property strict
//| Bullish:
//| - Đáy 0 > đáy 2
//| - Đỉnh 1 > đáy 2
//| - Nến close trên đỉnh 1
//|
//| Bearish:
//| - Đỉnh 0 < Đỉnh 2
//| - Đáy 1 < Đỉnh 2
//| - Nến close trên đỉnh 1
//|
/*
void PA_Dow(int timeFrame, int maxBar = 200)
  {
   string tfStr=ConvertTimeFrametoString(timeFrame);
   int HL_bar[1000];
   bool end_is_low = false;
   FindHighLow(timeFrame, HL_bar, end_is_low, maxBar);

   double close_prev = iClose(_Symbol, timeFrame, 1);
   double high_prev = -1, low_prev = -1;
   Get_High_Low_Value(high_prev, low_prev, timeFrame, 1);

   double high_arr_1 = -1, low_arr_1 = -1;//giá trị của đỉnh/đáy vị trí thứ n - 2 trong mảng
   Get_High_Low_Value(high_arr_1, low_arr_1, timeFrame, HL_bar[ArraySize(HL_bar)-2]);

   if(end_is_low && close_prev > high_arr_1 && high_prev > high_arr_1 && low_prev < high_arr_1)//vị trí cuối cùng là đáy và nến đóng cửa trên đỉnh thứ n-2 trong mảng = > xác định có phải bullish tiếp diễn
     {
      double high_arr_0 = -1, low_arr_0 = -1;
      double high_arr_2 = -1, low_arr_2 = -1;
      Get_High_Low_Value(high_arr_0, low_arr_0, timeFrame, HL_bar[ArraySize(HL_bar)- 1]);
      Get_High_Low_Value(high_arr_2, low_arr_2, timeFrame, HL_bar[ArraySize(HL_bar)- 3]);
      if(low_arr_0 > low_arr_2 && high_arr_1 > low_arr_2)
        {
         Telegram_send("["+tfStr+" - "+_Symbol+"] - Lý thuyết DOW - TĂNG \n Giá đang phá vỡ xu hướng cấp 2 để hình thành xu thế cấp 1 tiếp diễn.", tele_PA_id);
        }
     }
   else
      if(end_is_low == false  && close_prev < low_arr_1  && high_prev > low_arr_1 && low_prev < low_arr_1)//vị trí cuối cùng là đỉnh và nến đóng cửa dưới đáy thứ n-2 trong mảng  = > xác định có phải bearish tiếp diễn
        {
         double high_arr_0 = -1, low_arr_0 = -1;
         double high_arr_2 = -1, low_arr_2 = -1;
         Get_High_Low_Value(high_arr_0, low_arr_0, timeFrame, HL_bar[ArraySize(HL_bar)- 1]);
         Get_High_Low_Value(high_arr_2, low_arr_2, timeFrame, HL_bar[ArraySize(HL_bar)- 3]);
         if(high_arr_0 < high_arr_2 && low_arr_1 < high_arr_2)
           {
            Telegram_send("["+tfStr+" - "+_Symbol+"] - Lý thuyết DOW - GIẢM \n Giá đang phá vỡ xu hướng cấp 2 để hình thành xu thế cấp 1 tiếp diễn.", tele_PA_id);
           }
        }
  }*/
//+------------------------------------------------------------------+
/*string PA_Dow(int timeFrame, int &HL_bar[], bool end_is_low)
  {
   string tfStr=ConvertTimeFrametoString(timeFrame);
   double close_prev = iClose(_Symbol, timeFrame, 1);
   double high_prev = -1, low_prev = -1;
   Get_High_Low_Value(high_prev, low_prev, timeFrame, 1);

   double high_arr_1 = -1, low_arr_1 = -1;//giá trị của đỉnh/đáy vị trí thứ n - 2 trong mảng
   Get_High_Low_Value(high_arr_1, low_arr_1, timeFrame, HL_bar[ArraySize(HL_bar)-2]);

   if(end_is_low && close_prev > high_arr_1 && high_prev > high_arr_1 && low_prev < high_arr_1)//vị trí cuối cùng là đáy và nến đóng cửa trên đỉnh thứ n-2 trong mảng = > xác định có phải bullish tiếp diễn
     {
      double high_arr_0 = -1, low_arr_0 = -1;
      double high_arr_2 = -1, low_arr_2 = -1;
      Get_High_Low_Value(high_arr_0, low_arr_0, timeFrame, HL_bar[ArraySize(HL_bar)- 1]);
      Get_High_Low_Value(high_arr_2, low_arr_2, timeFrame, HL_bar[ArraySize(HL_bar)- 3]);
      if(low_arr_0 > low_arr_2 && high_arr_1 > low_arr_2)
        {
         return "Lý thuyết DOW - TĂNG \n Giá đang phá vỡ xu hướng cấp 2 để hình thành xu thế cấp 1 tiếp diễn.";
         //Telegram_send("["+tfStr+" - "+_Symbol+"] - Lý thuyết DOW - TĂNG \n Giá đang phá vỡ xu hướng cấp 2 để hình thành xu thế cấp 1 tiếp diễn.", tele_PA_id);
        }
     }
   else
      if(end_is_low == false  && close_prev < low_arr_1  && high_prev > low_arr_1 && low_prev < low_arr_1)//vị trí cuối cùng là đỉnh và nến đóng cửa dưới đáy thứ n-2 trong mảng  = > xác định có phải bearish tiếp diễn
        {
         double high_arr_0 = -1, low_arr_0 = -1;
         double high_arr_2 = -1, low_arr_2 = -1;
         Get_High_Low_Value(high_arr_0, low_arr_0, timeFrame, HL_bar[ArraySize(HL_bar)- 1]);
         Get_High_Low_Value(high_arr_2, low_arr_2, timeFrame, HL_bar[ArraySize(HL_bar)- 3]);
         if(high_arr_0 < high_arr_2 && low_arr_1 < high_arr_2)
           {
            return "- Lý thuyết DOW - GIẢM \n Giá đang phá vỡ xu hướng cấp 2 để hình thành xu thế cấp 1 tiếp diễn.";
            //Telegram_send("["+tfStr+" - "+_Symbol+"] - Lý thuyết DOW - GIẢM \n Giá đang phá vỡ xu hướng cấp 2 để hình thành xu thế cấp 1 tiếp diễn.", tele_PA_id);
           }
        }
   return "";
  }
  */
//+------------------------------------------------------------------+
