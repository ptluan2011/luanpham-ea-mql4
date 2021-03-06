//+------------------------------------------------------------------+
//|                                         _CandlestickPatterns.mqh |
//| Các mẫu hình nến cơ bản                                          |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property strict

//+------------------------------------------------------------------+
//| PHƯƠNG PHÁP GỘP NẾN:
//| Giá mở cửa của cây nến gộp = Giá mở cửa của cây nến thứ nhất.
//| Giá đóng cửa của cây nến gộp = Giá đóng cửa của cây nến cuối cùng.
//| Giá cao nhất của cây nến gộp = Giá cao nhất của các cây nến.
//| Giá thấp nhất của cây nến gộp = Giá thấp nhất của các cây nến.

//| Trong một thị trường sideway hay market test một vùng kháng cự hay hỗ trợ nào đó,
//| sử dụng phương pháp này sẽ giúp ích cho chúng ta dễ dàng xác định được đâu là cây
//| nến chuẩn - quyết định vùng chiến sự, các mức cản động (quan trọng) của thị trường
//+------------------------------------------------------------------+
void BlendingCandles(int timeFrame, int bar_begin, int bar_end, double &blending_low, double &blending_high, double &blending_open, double &blending_close)
  {
      blending_open = iOpen(_Symbol, timeFrame,bar_begin);
      blending_close = iClose(_Symbol, timeFrame,bar_end);
      blending_low = iLowest(_Symbol, timeFrame, MODE_LOW, bar_end - bar_begin, bar_begin);
      blending_high = iHighest(_Symbol, timeFrame, MODE_HIGH, bar_end - bar_begin, bar_begin);
  }
//+------------------------------------------------------------------+
//| Tính lực mua hay bán mạnh hơn trong 1 cây nến
//| Giá trị trả về: 1: Lực mua mạnh hơn | -1: Lực bán mạnh hơn | 0: mua bán bằng nhau
//+------------------------------------------------------------------+
int TinhLucBuySell(int timeFrame, int barIndex)
  {
   double high = iHigh(_Symbol, timeFrame, barIndex);
   double low = iLow(_Symbol, timeFrame, barIndex);
   double open = iOpen(_Symbol, timeFrame, barIndex);
   double close = iClose(_Symbol, timeFrame, barIndex);
   double strength_buy, strength_sell;
   if(open < close)// thân nến tăng
     {
      strength_buy = close - low;
      strength_sell = high - close;
     }
   else//thân nến giảm
     {
      strength_buy = open - low;
      strength_sell = high - open;
     }
   if(strength_buy > strength_sell)// lực mua lớn hơn lực bán
      return 1;
   if(strength_buy < strength_sell)// lực mua nhỏ hơn lực bán
      return -1;
   return 0;
  }

//+------------------------------------------------------------------+
//|Kiểm tra nến hợp lệ, nếu râu nến dài hơn thân nến thì bỏ qua
//+------------------------------------------------------------------+
bool CheckBarValid(int timeFrame, int barIndex, bool checkTail = false)
  {
   double high = iHigh(_Symbol, timeFrame, barIndex);
   double low = iLow(_Symbol, timeFrame, barIndex);
   double open = iOpen(_Symbol, timeFrame, barIndex);
   double close = iClose(_Symbol, timeFrame, barIndex);
   double body_lenght = MathAbs(open - close);
   double above_tail = 0;
   double below_tail = 0;
   if(open < close)//Nến tăng
     {
      above_tail = high - close;
      below_tail = open - low;
     }
   if(open > close)//Nến giảm
     {
      above_tail = high - open;
      below_tail = close - low;
     }
   if(checkTail)
     {
      if(above_tail > body_lenght || below_tail > body_lenght)
         return false;
     }
//double above_tail = iOpen(_Symbol, timeFrame, barIndex) > iClose(_Symbol, timeFrame, barIndex)?;
//double below_tail = ;
   return true;
  }
//+------------------------------------------------------------------+
//| Tìm cây Mother Bar tăng/giảm mạnh nhất
//| Giá trị trả về: > 0 vị trí của cây Mother Bar | < 0: không có Mother Bar
//+------------------------------------------------------------------+
int TimNenMotherBar(int timeFrame, int maxBar = 10)
  {
   double bar_lenght_1 = MathAbs(iOpen(_Symbol, timeFrame, 1) - iClose(_Symbol, timeFrame, 1));
   int mb_index = -1;
   for(int i = 2; i < maxBar; i++)
     {
      double bar_lenght_i = MathAbs(iOpen(_Symbol, timeFrame, i) - iClose(_Symbol, timeFrame, i));
      double pips_i = TinhSoPips(iOpen(_Symbol, timeFrame, i), iClose(_Symbol, timeFrame, i));
      if(bar_lenght_i > bar_lenght_1*2 && pips_i > 10)
        {
         bar_lenght_1 = bar_lenght_i;
         mb_index = i;
        }
     }
   return mb_index;
  }
//+--------------------------MÔ HÌNH NẾN----------------------------------------+



//+------------------------------------------------------------------+
//| MÔ HÌNH NẾN PIN BAR
//+------------------------------------------------------------------+
int Pinbar(int timeFrame, int maxBar = 5)
  {
   for(int i = 1; i<= maxBar; i++)
     {
      double high = iHigh(_Symbol, timeFrame, i);
      double low = iLow(_Symbol, timeFrame, i);
      double open = iOpen(_Symbol, timeFrame, i);
      double close = iClose(_Symbol, timeFrame, i);
      double pips_lower_shadow=0, pips_upper_shadow=0;
      double pips_body = TinhSoPips(open, close);
      if(open < close)//nến tăng
        {
         pips_upper_shadow = TinhSoPips(high, close);
         pips_lower_shadow = TinhSoPips(open, low);
        }
      else
         if(open > close)//nến giảm
           {
            pips_upper_shadow = TinhSoPips(high, open);
            pips_lower_shadow = TinhSoPips(close, low);
           }
      if(pips_lower_shadow > pips_upper_shadow && pips_body >pips_upper_shadow && pips_lower_shadow >= ((pips_body + pips_upper_shadow) * 2))//pin bar tăng giá
        {
         DrawTrendLine((string)timeFrame+"_Pinbar_high", false, iTime(_Symbol,timeFrame,i), iTime(_Symbol,timeFrame,i-1),high, high, Red, STYLE_SOLID, false, timeFrame, 2);
         DrawTrendLine((string)timeFrame+"_Pinbar_low", false, iTime(_Symbol,timeFrame,i), iTime(_Symbol,timeFrame,i-1),low, low, Red, STYLE_SOLID, false, timeFrame, 2);
         return i;
        }
      if(pips_lower_shadow < pips_upper_shadow && pips_body > pips_lower_shadow && pips_upper_shadow >= ((pips_body + pips_lower_shadow) * 2))  // pin bar giảm giá
        {
         DrawTrendLine((string)timeFrame+"_Pinbar_high", false, iTime(_Symbol,timeFrame,i), iTime(_Symbol,timeFrame,i-1),high, high, Red, STYLE_SOLID, false, timeFrame, 2);
         DrawTrendLine((string)timeFrame+"_Pinbar_low", false, iTime(_Symbol,timeFrame,i), iTime(_Symbol,timeFrame,i-1),low, low, Red, STYLE_SOLID, false, timeFrame, 2);
         return -i;
        }
     }
   return 0;
  }

//+------------------------------------------------------------------+
//| Nến Inside:
//| - Nến sau đóng cửa ngược với nến trước và nằm trong lòng nến trước
//| Giá trị trả về : x < 0: Inside giảm | x = 0: không xuất hiện Inside | x > 0 Inside Tăng
//| x là vị trí nến xuất hiện
//+------------------------------------------------------------------+
int Insidebar(int timeFrame, int maxBar = 5)
  {
   for(int i = 1; i<= maxBar; i++)
     {
      double high_1 = iHigh(_Symbol, timeFrame, i);
      double low_1 = iLow(_Symbol, timeFrame, i);
      double open_1 = iOpen(_Symbol, timeFrame, i);
      double close_1 = iClose(_Symbol, timeFrame, i);
      double high_2 = iHigh(_Symbol, timeFrame, i+1);
      double low_2 = iLow(_Symbol, timeFrame, i+1);
      double open_2 = iOpen(_Symbol, timeFrame, i+1);
      double close_2 = iClose(_Symbol, timeFrame, i+1);
      //Inside Tăng
      double pips_lower_shadow=0, pips_upper_shadow=0;
      double pips_body = TinhSoPips(open_2, close_2);
      if(open_2 < close_2)//nến tăng
        {
         pips_upper_shadow = TinhSoPips(high_2, close_2);
         pips_lower_shadow = TinhSoPips(open_2, low_2);
        }
      else
         if(open_2 > close_2)//nến giảm
           {
            pips_upper_shadow = TinhSoPips(high_2, open_2);
            pips_lower_shadow = TinhSoPips(close_2, low_2);
           }
      if(pips_body < pips_upper_shadow || pips_body < pips_lower_shadow)
         return 0;
      if(open_1 < close_1 && open_2 > close_2 && open_1 >= close_2 && close_1 <= open_2 && high_1 < high_2 && low_1 > low_2)// nến số 1 tăng, nến số 2 giảm,
        {
         //DrawTrendLine((string)timeFrame+"_Insidebar_high", false, iTime(_Symbol,timeFrame,i+1), iTime(_Symbol,timeFrame,i),high_2, high_2, Red, STYLE_SOLID, false, timeFrame, 2);
         //DrawTrendLine((string)timeFrame+"_Insidebar_low", false, iTime(_Symbol,timeFrame,i+1), iTime(_Symbol,timeFrame,i),low_2, low_2, Red, STYLE_SOLID, false, timeFrame, 2);
         return i+1;
        }
      //Inside Giảm
      else
         if(open_1 > close_1 && open_2 < close_2 && open_1 <= close_2 && close_1 >= open_2  && high_1 < high_2 && low_1 > low_2)// nến số 1 giảm, nến số 2 tăng,
           {
            //DrawTrendLine((string)timeFrame+"_Insidebar_high", false, iTime(_Symbol,timeFrame,i+1), iTime(_Symbol,timeFrame,i),high_2, high_2, Red, STYLE_SOLID, false, timeFrame, 2);
            //DrawTrendLine((string)timeFrame+"_Insidebar_low", false, iTime(_Symbol,timeFrame,i+1), iTime(_Symbol,timeFrame,i),low_2, low_2, Red, STYLE_SOLID, false, timeFrame, 2);
            return -(i+1);
           }
     }
   return 0;
  }

//+------------------------------------------------------------------+
//| Nến break mô hình inside bar
//+------------------------------------------------------------------+
int Insidebar_broke(int timeFrame, int maxBar = 5)
  {
//Tìm mô hình inside bar
   int ib_idx = Insidebar(timeFrame, maxBar);
   if(ib_idx != 0)// có xuất hiện mô hình ib
     {
      ib_idx = MathAbs(ib_idx);
      double high_ib = iOpen(_Symbol, timeFrame, ib_idx) > iClose(_Symbol, timeFrame, ib_idx)? iOpen(_Symbol, timeFrame, ib_idx): iClose(_Symbol, timeFrame, ib_idx);
      double low_ib = iOpen(_Symbol, timeFrame, ib_idx) < iClose(_Symbol, timeFrame, ib_idx)? iOpen(_Symbol, timeFrame, ib_idx): iClose(_Symbol, timeFrame, ib_idx);
      for(int i = ib_idx; i > 0; i--)//Xác định vị trí nến break mô hình inside bar, break mô hình khi nến close trên hoặc dưới nến mẹ của mô hình
        {
         double open_i = iOpen(_Symbol, timeFrame, i);
         double close_i = iClose(_Symbol, timeFrame, i);
         if(close_i > high_ib)//Nến phá mô hình inside bar tăng
           {
            DrawTrendLine((string)timeFrame+"_Ib_break_high", false, iTime(_Symbol,timeFrame,ib_idx), iTime(_Symbol,timeFrame,i),iHigh(_Symbol, timeFrame, ib_idx), iHigh(_Symbol, timeFrame, ib_idx), Red, STYLE_SOLID, false, timeFrame, 2);
            DrawTrendLine((string)timeFrame+"_Ib_break_low", false, iTime(_Symbol,timeFrame,ib_idx), iTime(_Symbol,timeFrame,i), iLow(_Symbol, timeFrame, ib_idx), iLow(_Symbol, timeFrame, ib_idx), Red, STYLE_SOLID, false, timeFrame, 2);
            return i;
           }
         if(close_i < low_ib) // Nến phá mô hình inside bar giảm
           {
            DrawTrendLine((string)timeFrame+"_Ib_break_high", false, iTime(_Symbol,timeFrame,ib_idx), iTime(_Symbol,timeFrame,i),iHigh(_Symbol, timeFrame, ib_idx), iHigh(_Symbol, timeFrame, ib_idx), Red, STYLE_SOLID, false, timeFrame, 2);
            DrawTrendLine((string)timeFrame+"_Ib_break_low", false, iTime(_Symbol,timeFrame,ib_idx), iTime(_Symbol,timeFrame,i), iLow(_Symbol, timeFrame, ib_idx), iLow(_Symbol, timeFrame, ib_idx), Red, STYLE_SOLID, false, timeFrame, 2);
            return -i;
           }
        }
     }
   return 0;
  }

//+------------------------------------------------------------------+
//|
//+------------------------------------------------------------------+
int Fakeybar(int timeFrame, int maxBar = 5)
  {

   return 0;
  }

//+------------------------------------------------------------------+
//| Nến Engulfing:
//| - Nến sau đóng cửa ngược với nến trước và bao trùm nến trước
//| - Nến Engulfing mạnh và sử dụng tốt nhất là cắt đường ema và thân nến ở cả 2 đầu đều có gap với nến trước
//| Giá trị trả về : x < 0: Engulfing giảm | x = 0: không xuất hiện Engulfing | x > 0 Engulfing Tăng
//| x là vị trí nến xuất hiện
//+------------------------------------------------------------------+
int Engulfingbar(int timeFrame, int maxBar = 5)
  {
//string str_singal = "";
   for(int i = 1; i<= maxBar; i++)
     {
      double high_1 = iHigh(_Symbol, timeFrame, i);
      double low_1 = iLow(_Symbol, timeFrame, i);
      double open_1 = iOpen(_Symbol, timeFrame, i);
      double close_1 = iClose(_Symbol, timeFrame, i);

      double high_2 = iHigh(_Symbol, timeFrame, i+1);
      double low_2 = iLow(_Symbol, timeFrame, i+1);
      double open_2 = iOpen(_Symbol, timeFrame, i+1);
      double close_2 = iClose(_Symbol, timeFrame, i+1);

      double lower_shadow_1, upper_shadow_1, body_1; // lower_shadow là râu phía dưới, upper_shadow là râu phía trên
      double pips = TinhSoPips(open_1, close_1);
      if(CheckBarValid(timeFrame,i) == false)
         return 0;
      //Engulfing Tăng
      if(pips > 1)// thân nến đủ lớn để xác định tín hiệu
        {
         if(open_1 < close_1 && open_2 > close_2 && open_1 <= close_2 && close_1 >= open_2  && high_1 > high_2 /*&& low_1 < low_2*/)// nến số 1 tăng, nến số 2 giảm,
           {
            lower_shadow_1 = open_1 - low_1;
            body_1 = close_1 - open_1;
            upper_shadow_1 = high_1 - close_1;
            if(body_1 > upper_shadow_1 && body_1 > lower_shadow_1)// thân nến phải lớn hơn râu nến
              {
               DrawTrendLine((string)timeFrame+"_Engulfingbar_high", false, iTime(_Symbol,timeFrame,i), iTime(_Symbol,timeFrame,i+1),high_1, high_1, Red, STYLE_SOLID, false, timeFrame, 2);
               DrawTrendLine((string)timeFrame+"_Engulfingbar_low", false, iTime(_Symbol,timeFrame,i), iTime(_Symbol,timeFrame,i+1),low_1, low_1, Red, STYLE_SOLID, false, timeFrame, 2);

               return i;
              }
            // str_singal = "\n- ("+ConvertTimeFrametoString(timeFrame)+") Xuat hien nen Engulfing Tang tai nen thu "+(string)i;
           }
         //Engulfing Giảm
         else
            if(open_1 > close_1 && open_2 < close_2 && open_1 >= close_2 && close_1 <= open_2 && /*high_1 > high_2 &&*/ low_1 < low_2)// nến số 1 giảm, nến số 2 tăng,
              {
               lower_shadow_1 = close_1 - low_1;
               body_1 = open_1 - close_1;
               upper_shadow_1 = high_1 - open_1;
               if(body_1 > upper_shadow_1 && body_1 > lower_shadow_1)// thân nến phải lớn hơn râu nến
                 {
                  DrawTrendLine((string)timeFrame+"_Engulfingbar_high", false, iTime(_Symbol,timeFrame,i), iTime(_Symbol,timeFrame,i+1),high_1, high_1, Red, STYLE_SOLID, false, timeFrame, 2);
                  DrawTrendLine((string)timeFrame+"_Engulfingbar_low", false, iTime(_Symbol,timeFrame,i), iTime(_Symbol,timeFrame,i+1),low_1, low_1, Red, STYLE_SOLID, false, timeFrame, 2);

                  return -i;
                 }
               //str_singal = "\n- ("+ConvertTimeFrametoString(timeFrame)+") Xuat hien nen Engulfing Giam tai nen thu "+(string)i;
              }
        }
     }
   return 0;
  }
//+------------------------------------------------------------------+
//| MÔ HÌNH NẾN DOJI
//+------------------------------------------------------------------+
int Dojibar(int timeFrame, int maxBar = 5)
  {
   for(int i = 1; i<= maxBar; i++)
     {
      double high = iHigh(_Symbol, timeFrame, i);
      double low = iLow(_Symbol, timeFrame, i);
      double open = iOpen(_Symbol, timeFrame, i);
      double close = iClose(_Symbol, timeFrame, i);
      double pips_candle = TinhSoPips(high, low);
      double pips_body = TinhSoPips(open, close);
      if(pips_body < 0.5 && pips_candle >= 5)
        {
         DrawTrendLine((string)timeFrame+"_Doji_high", false, iTime(_Symbol,timeFrame,i), iTime(_Symbol,timeFrame,i-1),high, high, Red, STYLE_SOLID, false, timeFrame, 2);
         DrawTrendLine((string)timeFrame+"_Doji_low", false, iTime(_Symbol,timeFrame,i), iTime(_Symbol,timeFrame,i-1),low, low, Red, STYLE_SOLID, false, timeFrame, 2);
         return i;
        }
     }
   return 0;
  }

//+------------------------------------------------------------------+
//| Mô hình C7 cơ bản
//| Đặc điểm: 3 nến có chiều dài thân nến giảm dần
//| Ứng dụng: Buy(sell) tại nến số 3, kỳ vọng giá phục hồi (điều chỉnh) về lại 50%-70% chiều dài nến số 2
//| (Nếu kết hợp thêm C1 nữa thì nến số 3 có thể là đáy (đỉnh) của chu kỳ đó)
//| Nến số 3 là nến số 1 trên chart
//+------------------------------------------------------------------+
int C7CB(int timeFrame)
  {
   string str_signal= "";
   double high_1 = iHigh(_Symbol, timeFrame, 1);
   double low_1 = iLow(_Symbol, timeFrame, 1);
   double open_1 = iOpen(_Symbol, timeFrame, 1);
   double close_1 = iClose(_Symbol, timeFrame, 1);
   double bar_lenght_1 = MathAbs(open_1 - close_1);

   double high_2 = iHigh(_Symbol, timeFrame, 2);
   double low_2 = iLow(_Symbol, timeFrame, 2);
   double open_2 = iOpen(_Symbol, timeFrame, 2);
   double close_2 = iClose(_Symbol, timeFrame, 2);
   double bar_lenght_2 = MathAbs(open_2 - close_2);

   double high_3 = iHigh(_Symbol, timeFrame, 3);
   double low_3 = iLow(_Symbol, timeFrame, 3);
   double open_3 = iOpen(_Symbol, timeFrame, 3);
   double close_3 = iClose(_Symbol, timeFrame, 3);
   double bar_lenght_3 = MathAbs(open_3 - close_3);
   datetime time = iTime(_Symbol, timeFrame, 1);
   string mAlert = "";
//Kiểm  tra 3 nến cùng tăng hay cùng giảm
   if(bar_lenght_1 < bar_lenght_2 && bar_lenght_2 < bar_lenght_3)// chiều dài 3 nến giảm dần
     {
      //3 nến cùng Tăng với thân nến giảm dần
      if(/*open_1 < close_1 &&*/ open_2 < close_2 && open_3 < close_3)
        {
         //DrawArrowAndText("C7CB", high_1, false, 1, timeFrame,"C7_CB");
         //str_signal += "Mo hinh C7CB du doan gia GIAM";
         return 1;
        }
      //3 nến cùng giảm với thân nến giảm dần
      if(/*open_1 > close_1 &&*/ open_2 > close_2 && open_3 > close_3)
        {
         //DrawArrowAndText("C7CB", low_1, true, 1, timeFrame,"C7_CB");
         //str_signal += "Mo hinh C7CB du doan gia TANG";
         return -1;
        }
     }

   return 0;
  }
//+------------------------------------------------------------------+
//| Mô hình C7 thân tăng
//| Đặc điểm: 3 nến có chiều dài thân nến tăng dần và phản lại nến chủ (nến trước đó - nến số 4)
//+------------------------------------------------------------------+
int C7TT(int timeFrame)
  {
   string str_signal="";
   double high_1 = iHigh(_Symbol, timeFrame, 1);
   double low_1 = iLow(_Symbol, timeFrame, 1);
   double open_1 = iOpen(_Symbol, timeFrame, 1);
   double close_1 = iClose(_Symbol, timeFrame, 1);
   double bar_lenght_1 = MathAbs(open_1 - close_1);

   double high_2 = iHigh(_Symbol, timeFrame, 2);
   double low_2 = iLow(_Symbol, timeFrame, 2);
   double open_2 = iOpen(_Symbol, timeFrame, 2);
   double close_2 = iClose(_Symbol, timeFrame, 2);
   double bar_lenght_2 = MathAbs(open_2 - close_2);

   double high_3 = iHigh(_Symbol, timeFrame, 3);
   double low_3 = iLow(_Symbol, timeFrame, 3);
   double open_3 = iOpen(_Symbol, timeFrame, 3);
   double close_3 = iClose(_Symbol, timeFrame, 3);
   double bar_lenght_3 = MathAbs(open_3 - close_3);

   int lucmuaban_4 = TinhLucBuySell(timeFrame,4);
   datetime time = iTime(_Symbol, timeFrame, 1);
   if(bar_lenght_1 > bar_lenght_2 && bar_lenght_2 > bar_lenght_3)// chiều dài body 3 nến tăng dần
     {
      //2 nến sau cùng màu tăng
      if(open_2 < close_2 && open_3 < close_3 && lucmuaban_4 == -1) // 3 nến tăng dần, nến chủ lực bán lớn hơn lực mua
        {
         //DrawArrowAndText("C7TT", high_1, false, 1, timeFrame,"C7_TT");
         //str_signal += "Mo hinh C7TT 3 nen TANG";
         return 1;
        }
      //2 nến sau cùng màu giảm
      if(open_1 > close_1 && open_2 > close_2 && open_3 > close_3  && lucmuaban_4 == 1)
        {
         //DrawArrowAndText("C7TT", low_1, true, 1, timeFrame,"C7_TT");
         //str_signal += "Mo hinh C7TT 3 nen GIAM";
         return -1;
        }
     }
   return 0;
  }
//+------------------------------------------------------------------+
//| Mô hình 4 Block
//| Đặc điểm: 4 nến có chiều dài thân nến tăng dần
//+------------------------------------------------------------------+
int C4Block(int timeFrame)
  {
   string str_signal="";
   double high_1 = iHigh(_Symbol, timeFrame, 1);
   double low_1 = iLow(_Symbol, timeFrame, 1);
   double open_1 = iOpen(_Symbol, timeFrame, 1);
   double close_1 = iClose(_Symbol, timeFrame, 1);
   double bar_lenght_1 = MathAbs(open_1 - close_1);

   double high_2 = iHigh(_Symbol, timeFrame, 2);
   double low_2 = iLow(_Symbol, timeFrame, 2);
   double open_2 = iOpen(_Symbol, timeFrame, 2);
   double close_2 = iClose(_Symbol, timeFrame, 2);
   double bar_lenght_2 = MathAbs(open_2 - close_2);

   double high_3 = iHigh(_Symbol, timeFrame, 3);
   double low_3 = iLow(_Symbol, timeFrame, 3);
   double open_3 = iOpen(_Symbol, timeFrame, 3);
   double close_3 = iClose(_Symbol, timeFrame, 3);
   double bar_lenght_3 = MathAbs(open_3 - close_3);

   double high_4 = iHigh(_Symbol, timeFrame, 4);
   double low_4 = iLow(_Symbol, timeFrame, 4);
   double open_4 = iOpen(_Symbol, timeFrame, 4);
   double close_4 = iClose(_Symbol, timeFrame, 4);
   double bar_lenght_4 = MathAbs(open_4 - close_4);

   datetime time = iTime(_Symbol, timeFrame, 1);

   if(bar_lenght_1 > bar_lenght_2 && bar_lenght_2 > bar_lenght_3 && bar_lenght_3 > bar_lenght_4)// chiều dài body 4 nến tăng dần
     {
      //2 nến sau cùng màu tăng
      if(open_1 < close_1 && open_2 < close_2 && open_3 < close_3 && open_4 < close_4) // 3 nến tăng dần, nến chủ lực bán lớn hơn lực mua
        {
         //DrawArrowAndText("C74B", high_1, false, 1, timeFrame,"C7_TT");
         //str_signal += "Mo hinh 4Block nen Tang Dan";
         return 1;
        }
      //2 nến sau cùng màu giảm
      if(open_1 > close_1 && open_2 > close_2 && open_3 > close_3 && open_4 > close_4)
        {
         //DrawArrowAndText("C74B", low_1, true, 1, timeFrame,"C7_TT");
         //str_signal += "Mo hinh 4Block nen Giam Dan";
         return -1;
        }
     }
   return 0;
  }


//+------------------------------------------------------------------+
//| Mô hình C7 cao cấp
//| Đặc điểm: Ngay sau khi xuất hiện 1 nến dài tăng hoặc giảm giá mạnh, xuất hiện 3 nến tiếp theo hình thành nên C7CB
//| Ứng dụng: Buy(sell) khối lượng lớn ngay khi xuất hiện C7CB, stoploss tại mức thấp nhất(cao nhất) của cây nến trước cây nến tăng(giảm) mạnh
//+------------------------------------------------------------------+
int C7CC(int timeFrame)
  {
   string str_signal= "";
//int c7cb = C7CB(timeFrame);
   if(c7cb != 0)
     {
      double high_3 = iHigh(_Symbol, timeFrame, 3);
      double low_3 = iLow(_Symbol, timeFrame, 3);
      double open_3 = iOpen(_Symbol, timeFrame, 3);
      double close_3 = iClose(_Symbol, timeFrame, 3);
      double bar_lenght_3 = MathAbs(open_3 - close_3);

      double high_4 = iHigh(_Symbol, timeFrame, 4);
      double low_4 = iLow(_Symbol, timeFrame, 4);
      double open_4 = iOpen(_Symbol, timeFrame, 4);
      double close_4 = iClose(_Symbol, timeFrame, 4);
      double bar_lenght_4 = MathAbs(open_4 - close_4);
      if(bar_lenght_3 < bar_lenght_4)// body của nến 4 lớn hơn nến 3
        {
         if(open_4  < close_4 && open_3  > close_3) // nến thứ 4 là nến tăng và nến thứ 3 là nến giảm
           {
            //DrawArrowAndText("C7CC", low_3, false, 1, timeFrame,"C7_CC");
            //str_signal += "Mo hinh C7CC du doan gia TANG";
            return 1;
           }
         else
            if(open_4 > close_4 && open_3  < close_3)  // nến thứ 4 là nến giảm và nến thứ 3 là nến tăng
              {
               //DrawArrowAndText("C7CC", high_3, true, 1, timeFrame,"C7_CC");
               //str_signal += "Mo hinh C7CC du doan gia GIAM";
               return -1;
              }
        }
     }
   return 0;
  }

//+------------------------------------------------------------------+
//| Mô hình C7 phát triển
//| Đặc điểm: Sau khi hình thành 1 nến tăng hoặc giảm mạnh, giá sẽ có thiên hướng điều chỉnh hoặc phục hồi về lại trước khi tiếp diễn theo trend chủ vừa hình thành
//| Ứng dụng: Chờ đợi giá điều chỉnh/phục hồi về lại 50% - 70% cây nến mother bar, sau đó buy/sell, stoploss tại mức giá trước cây nến hình thành mother bar.
//+------------------------------------------------------------------+
int C7PT(int timeFrame)
  {
   string str_signal= "";
   int motherBar_index = TimNenMotherBar(timeFrame, 10);
   if(motherBar_index > 0)// Có nến mother bar
     {
      double high_mb = iHigh(_Symbol, timeFrame, motherBar_index);
      double low_mb = iLow(_Symbol, timeFrame, motherBar_index);
      double open_mb = iOpen(_Symbol, timeFrame, motherBar_index);
      double close_mb = iClose(_Symbol, timeFrame, motherBar_index);
      double bar_lenght_mb = MathAbs(open_mb - close_mb);

      double high_1 = iHigh(_Symbol, timeFrame, 1);
      double low_1 = iLow(_Symbol, timeFrame, 1);
      double open_1 = iOpen(_Symbol, timeFrame, 1);
      double close_1 = iClose(_Symbol, timeFrame, 1);
      double bar_lenght_1 = MathAbs(open_1 - close_1);
      datetime time = iTime(_Symbol, timeFrame, 1);
      if(open_mb < close_mb && close_mb  > close_1 && close_mb >= open_1  && open_1 > close_1 && bar_lenght_1 >= bar_lenght_mb/2)//nến mother bar tăng, kiểm tra nến sau có phải nến giảm 50%-70% không
        {
         DrawArrowAndText("C7PT", low_1, false, 1, timeFrame,"C7_PT");
         str_signal += "Mo hinh C7PT du doan gia TANG";
         return 1;
        }
      else
         if(open_mb > close_mb && close_mb < close_1 && close_mb <= open_1 && open_1 < close_1 && bar_lenght_1 >= bar_lenght_mb/2)//nến mother bar giảm , kiểm tra nến sau có phải nến tăng 50%-70% không
           {
            //DrawArrowAndText("C7PT", high_1, true, 1, timeFrame,"C7_PT");
            //str_signal += "Mo hinh C7PT du doan gia GIAM";
            return -1;
           }
     }
   return 0;
  }

//+------------------------------------------------------------------+
//| Mô hình C7 Bát tú
//| Đặc điểm: Sau khi hình thành 1 cây nến dài Tăng/Giảm giá, giá có thiên hướng điều chỉnh/phục hồi trở lại trước khi tiếp diễn xu hướng trước đó. Nến số 8 là nến quyết định xu hướng
//| Ứng dụng: Chờ đến khi hình thành xong nến số 8, nếu cùng chiều với mother bar thì buy/sell, stoploss tại nến trước cây nến hình thành mother bar
//+------------------------------------------------------------------+
int C7BT(int timeFrame)
  {
   string str_signal= "";
   int motherBar_index = TimNenMotherBar(timeFrame, 10);
   if(motherBar_index > 7)// Có nến mother bar
     {
      double high_mb = iHigh(_Symbol, timeFrame, motherBar_index);
      double low_mb = iLow(_Symbol, timeFrame, motherBar_index);
      double open_mb = iOpen(_Symbol, timeFrame, motherBar_index);
      double close_mb = iClose(_Symbol, timeFrame, motherBar_index);
      double bar_lenght_mb = MathAbs(open_mb - close_mb);

      double high_1 = iHigh(_Symbol, timeFrame, 1);
      double low_1 = iLow(_Symbol, timeFrame, 1);
      double open_1 = iOpen(_Symbol, timeFrame, 1);
      double close_1 = iClose(_Symbol, timeFrame, 1);
      double bar_lenght_1 = MathAbs(open_1 - close_1);

      datetime time = iTime(_Symbol, timeFrame, 1);
      if(open_mb < close_mb && open_1 < close_1 && open_mb < open_1) // nến số 1 cùng chiều TĂNG với mother bar
        {
         //DrawArrowAndText("C7BT", low_1, true, 1, timeFrame,"C7_BT");
         //str_signal += "Mo hinh nen C7BT du doan gia TANG";
         return 1;
        }
      if(open_mb > close_mb && open_1 > close_1 && open_mb < open_1) // nến số 1 cùng chiều GIẢM với mother bar
        {
         //DrawArrowAndText("C7BT", high_1, false, 1, timeFrame,"C7_BT");
         //str_signal += "Mo hinh nen C7BT du doan gia GIAM";
         return -1;
        }
     }
   return 0;
  }

//+------------------------------------------------------------------+
//| Mô hình C7 5 nến
//| Đặc điểm: Thị trường đi theo từng cụm nến gồm có 5 nến với xác suất nến số 5 cùng chiều với nến số 1
//| Ứng dụng: Buy/sell sau khi hình thành xong nến số 4 với kỳ vọng nến số 5 cùng chiều nến số 1.
//+------------------------------------------------------------------+
int C75N(int timeFrame)
  {
   string str_signal= "";
   return 0;
  }
//+------------------------------------------------------------------+
