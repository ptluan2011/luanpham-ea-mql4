//+------------------------------------------------------------------+
//|                                             _MarketStructure.mqh |
//|                                                        Luan Pham |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luan Pham"
#property link      ""
#property strict

//+------------------------------------------------------------------+
//| Xác định market structure
//| Vẽ MS line
//| Thông báo tín hiệu khi giá phản ứng với MS line
//+------------------------------------------------------------------+

//| Bullish:
//| - Đáy 1 > đáy 3
//| - Đỉnh 0 > đỉnh 2
//| - Nến close trên đỉnh 2
//|
//| Bearish:
//| - Đỉnh 3 > Đỉnh 1
//| - Đáy 2 > Đáy 0
//| - Nến close dưới đáy 2
//|
void MS_Signal(int timeFrame, int &HL_bar[], bool end_is_low)
  {
   string tfStr=ConvertTimeFrametoString(timeFrame);
   double close_prev = iClose(_Symbol, timeFrame, 1);
   double high_prev = -1, low_prev = -1;
   Get_High_Low_Value(high_prev, low_prev, timeFrame, 1);

   double high_arr_0 = -1, low_arr_0 = -1;
   double high_arr_1 = -1, low_arr_1 = -1;//giá trị của đỉnh/đáy vị trí thứ n - 2 trong mảng
   double high_arr_2 = -1, low_arr_2 = -1;
   double high_arr_3 = -1, low_arr_3 = -1;
   Get_High_Low_Value(high_arr_0, low_arr_0, timeFrame, HL_bar[ArraySize(HL_bar)- 1]);
   Get_High_Low_Value(high_arr_1, low_arr_1, timeFrame, HL_bar[ArraySize(HL_bar)- 2]);
   Get_High_Low_Value(high_arr_2, low_arr_2, timeFrame, HL_bar[ArraySize(HL_bar)- 3]);
   Get_High_Low_Value(high_arr_3, low_arr_3, timeFrame, HL_bar[ArraySize(HL_bar)- 4]);

// Kết thúc trong mảng là low thì kiểm tra nến trước đó có về chạm low thứ 2 và close dưới low thứ 2 để tạo bearish không
   if(end_is_low == false && close_prev > high_arr_2 && high_prev > high_arr_2 && low_prev < high_arr_2)//bullish
     {
      if(low_arr_1 > low_arr_3 && high_arr_0 > high_arr_0)
        {
         Telegram_send("["+tfStr+" - "+_Symbol+"] - Market Structure - TĂNG \n Giá đã chạm và close trên đỉnh thứ 2.", tele_PA_id);
        }
     }
   else
      if(end_is_low  && close_prev < low_arr_2  && high_prev > low_arr_2 && low_prev < low_arr_2)//bearish
        {
         if(high_arr_3 > high_arr_1 && low_arr_2 > low_arr_0)
           {
            Telegram_send("["+tfStr+" - "+_Symbol+"] - Market Structure - GIẢM \n Giá đã chạm và close dưới đáy thứ 2.", tele_PA_id);
           }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Get_High_Low_Value(double &high_result, double & low_result, int timeFrame, int bar_index)
  {
   double open = iOpen(_Symbol, timeFrame, bar_index);
   double close = iClose(_Symbol, timeFrame, bar_index);
   double wick_high = iHigh(_Symbol, timeFrame, bar_index);//Lấy râu nến phía trên
   double wick_low = iLow(_Symbol, timeFrame, bar_index);//Lấy râu nến phía dưới
   high_result =  close > open ? close : open;//Lấy giá cao
   low_result =  close < open ? close : open;//Lấy giá thấp
   if(TinhSoPips(wick_high, high_result) <= 1)//Nếu râu nến dài không quá 1 pip thì lấy râu luôn
      high_result = wick_high;
   if(TinhSoPips(wick_low, low_result) <= 1)//Nếu râu nến dài không quá 1 pip thì lấy râu luôn
      low_result = wick_low;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MarketStructure(int timeFrame, int maxBar = 500)
  {
//   if(StringFind(_Symbol,"XAUUSD") == -1)
//     {
   int HL_bar[1000]={};
   bool end_is_low = false;
   //FindHighLow(timeFrame, HL_bar, end_is_low, maxBar);

   int idx = 0;
//Vẽ MS line ở nến thứ (n - 2)
   Draw_MS_Line(timeFrame, HL_bar[ArraySize(HL_bar)-1], end_is_low,"MS_Line_0 "+(string)timeFrame, HL_bar[ArraySize(HL_bar)-1] >= 3 ? 3 : 1);
   Draw_MS_Line(timeFrame, HL_bar[ArraySize(HL_bar)-2], !end_is_low,"MS_Line_1 "+(string)timeFrame, HL_bar[ArraySize(HL_bar)-1] >= 3 ? 3 : 1/*HL_bar[ArraySize(HL_bar)-1]*/);
   Draw_MS_Line(timeFrame, HL_bar[ArraySize(HL_bar)-3], end_is_low,"MS_Line_2 "+(string)timeFrame);
   Draw_MS_Line(timeFrame, HL_bar[ArraySize(HL_bar)-4], !end_is_low,"MS_Line_3 "+(string)timeFrame,5);
//Draw_MS_Line(timeFrame, HL_bar[ArraySize(HL_bar)-5], end_is_low,"MS_Line_4 "+(string)timeFrame,5);
//Draw_MS_Line(timeFrame, HL_bar[ArraySize(HL_bar)-6], !end_is_low,"MS_Line_5 "+(string)timeFrame,5);
//Draw_MS_Line(timeFrame, HL_bar[ArraySize(HL_bar)-7], end_is_low,"MS_Line_6 "+(string)timeFrame,5);
   bool is_low_tmp = end_is_low;
   int arr_size = ArraySize(HL_bar);
   for(int i = 5; i < 10; i++)
     {
      Draw_MS_Line(timeFrame, HL_bar[arr_size - i], is_low_tmp,"MS_Line_ "+(string)i+(string)timeFrame, 7);
      is_low_tmp = !is_low_tmp;
     }
//MS_Signal(timeFrame, HL_bar, end_is_low);

//    }
  }
//+------------------------------------------------------------------+
void Draw_MS_Line(int timeFrame, int bar_index, bool is_low, string trendName, int trend_lenght = 0)
  {
   ObjectDelete(trendName);

   double high = -1, low = -1;
   Get_High_Low_Value(high, low, timeFrame, bar_index);
   datetime open_t = iTime(_Symbol,timeFrame, bar_index);
   string nextDay = (string)Year() + "." + (string)Month() + "." + (string)(Day()+1);
   datetime end_t = iTime(_Symbol,timeFrame, trend_lenght > 0 ? (bar_index - trend_lenght) : 0);//StringToTime(nextDay);
   if(is_low) // là đáy thì vẽ theo giá low
     {
      DrawTrendLine(trendName, false, open_t, end_t, low, low, Teal, STYLE_SOLID, false, timeFrame, 2, true);
     }
   else // là đỉnh thì vẽ theo giá đỉnh
     {
      DrawTrendLine(trendName, false, open_t, end_t, high, high, Magenta, STYLE_SOLID, false, timeFrame, 2, true);
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//Giá tăng phá 2 đỉnh gần nhất thì coi như chuyển từ bearish sang bullish và ngược lại với giảm phá 2 đáy gần nhất
