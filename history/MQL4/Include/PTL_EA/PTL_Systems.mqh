//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int pin_bar = 0;
int engulfing_bar = 0;
int doji_bar = 0;
int inside_bar = 0;
int c7cb = 0;
int c7cc = 0;
int c7pt = 0;
int c75n = 0;
int c7tt = 0;
int c74b = 0;
int trend_ema_21 = 0;
int trend_ema_34 = 0;
int trend_ema_89 = 0;
int trend_price_tf = 0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string PTL_System(int timeFrame)
  {
   string str_result = "";
   text_arr_i = 0;
   ArrayFree(text_arr);
   ArrayResize(text_arr,100);
   string tfStr = ConvertTimeFrametoString(timeFrame);
   ObjectsDeleteAll(0, tfStr+"_txt_system_*");
   ObjectsDeleteAll(0, "EMA_" + tfStr+"*");
   Get_Trend_CandlePattern(timeFrame);//Lấy xu hướng, mô hình nến
//GetTrendPrice(timeFrame);
   System_Candles_Pattern(timeFrame);
   string str_ema = System_EMA_Candle_Pattern(timeFrame);//System_Candlestick_EMA(timeFrame);
   string str_rs = System_ResistanceSupport(timeFrame, 500);//Vẽ Kháng cự hỗ trợ
   if((str_ema != "" || str_rs != "") && timeFrame > PERIOD_M5)
     {
      str_result =  "\n*["+_Symbol+" - "+tfStr+"]*" + str_ema + str_rs;
     }
   if(text_arr_i > 0 && text_arr[0] !="")
     {
      ArrayResize(text_arr, text_arr_i);
      TextONchart(timeFrame, tfStr+"_txt_system_");
     }
   return str_result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Get_Trend_CandlePattern(int timeFrame)
  {
   pin_bar =  Pinbar(timeFrame, 3);
   engulfing_bar = Engulfingbar(timeFrame, 3);
   doji_bar = Dojibar(timeFrame, 3);
   inside_bar = Insidebar_broke(timeFrame, 5);
   c7cb = C7CB(timeFrame);
   c7cc = C7CC(timeFrame);
   c7pt = C7PT(timeFrame);
   c75n = C75N(timeFrame);
   c7tt = C7TT(timeFrame);
   c74b = C4Block(timeFrame);
   trend_ema_21 = GetTrendByEMA(_Symbol, timeFrame, 21, 21);
   trend_ema_34 = GetTrendByEMA(_Symbol, timeFrame, 34, 34);
   trend_ema_89 = GetTrendByEMA(_Symbol, timeFrame, 89, 89);
   trend_price_tf = 0;
  }
//+------------------------------------------------------------------+
//Hệ thống nến + trend
//Hệ thống nến + ema
//Hệ thống theo phương pháp đánh theo trend dựa vào ema kết hợp mô hình nến để xác định xu hướng tiếp diễn
//+------------------------------------------------------------------+
int Candle_Pattern(int timeFrame, string &str_candlestick)
  {
   int c_result = 0;
   if(pin_bar != 0)//Xuất hiện nến pin bar
     {
      c_result = pin_bar;
      if(pin_bar > 0)//nến pin bar tăng, kiểm tra giá trị ema
        {
         str_candlestick += "\n- Xuất hiện nến Pin bar TĂNG tại vị trí nến thứ " + (string)MathAbs(pin_bar);
         //text_arr[text_arr_i] = "Pin bar TANG (nen " + (string)MathAbs(pin_bar) +  ")";
         //text_arr_i++;
        }
      if(pin_bar < 0)//nến pin bar giảm, kiểm tra giá trị ema
        {
         str_candlestick += "\n- Xuất hiện nến Pin bar GIẢM tại vị trí nến thứ " + (string)MathAbs(pin_bar);
         //text_arr[text_arr_i] = "Pin bar GIAM (nen " + (string)MathAbs(pin_bar) +  ")";
         //text_arr_i++;
        }
     }
   if(engulfing_bar != 0)//Xuất hiện nến pin bar
     {
      c_result = engulfing_bar;
      //bool is_up = engulfing_bar > 0 ? True : False;
      if(engulfing_bar > 0)//nến Engulfing bar tăng, kiểm tra giá trị ema
        {
         str_candlestick += "\n- Xuất hiện nến Engulfing bar TĂNG tại vị trí nến thứ " + (string)MathAbs(engulfing_bar);
         //text_arr[text_arr_i] = "Eng bar TANG (nen " + (string)MathAbs(engulfing_bar) +  ")";
         //text_arr_i++;
        }
      if(engulfing_bar < 0)//nến Engulfing bar tăng, kiểm tra giá trị ema
        {
         str_candlestick += "\n- Xuất hiện nến Engulfing bar GIẢM tại vị trí nến thứ " + (string)MathAbs(engulfing_bar);
         //text_arr[text_arr_i] = "Eng bar GIAM (nen " + (string)MathAbs(engulfing_bar) +  ")";
         //text_arr_i++;
        }
     }
   if(doji_bar != 0)//Xuất hiện nến pin bar
     {
      c_result = doji_bar;
      if(doji_bar > 0)//nến Doji bar tăng, kiểm tra giá trị ema
        {
         str_candlestick += "\n- Xuất hiện nến Doji bar TĂNG tại vị trí nến thứ " + (string)MathAbs(doji_bar);
         //text_arr[text_arr_i] = "Doji bar TANG (nen " + (string)MathAbs(doji_bar) +  ")";
         //text_arr_i++;
        }
      if(doji_bar < 0)//nến Doji bar tăng, kiểm tra giá trị ema
        {
         str_candlestick += "\n- Xuất hiện nến Doji bar GIẢM tại vị trí nến thứ " + (string)MathAbs(doji_bar);
         //text_arr[text_arr_i] = "Doji bar GIAM (nen " + (string)MathAbs(doji_bar) +  ")";
         //text_arr_i++;
        }
     }
   if(inside_bar != 0)//Xuất hiện nến inside bar
     {
      c_result = inside_bar;
      if(inside_bar > 0)//nến inside bar tăng, kiểm tra giá trị ema
        {
         str_candlestick += "\n- Xuất hiện mô hình Inside bar Break TĂNG tại vị trí nến thứ " + (string)MathAbs(inside_bar);
         //text_arr[text_arr_i] = "Inside break TANG (nen " + (string)MathAbs(inside_bar) +  ")";
         //text_arr_i++;
        }
      if(inside_bar < 0)//nến inside bar giảm, kiểm tra giá trị ema
        {
         str_candlestick += "\n- Xuất hiện nến Inside bar Break GIẢM tại vị trí nến thứ " + (string)MathAbs(inside_bar);
         //text_arr[text_arr_i] = "Inside break GIAM (nen " + (string)MathAbs(inside_bar) +  ")";
         //text_arr_i++;
        }
     }
   return c_result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string System_EMA_Candle_Pattern(int timeFrame)
  {
   string tfStr = ConvertTimeFrametoString(timeFrame);
   int bar_index = -1;
   string str_result = "";
   string str_candlestick = "";
   string str_ema = "";
   double price = 0;
   int ema_bullish = 0;
   int ema_21 = EMA_Vs_Price(timeFrame, bar_index, 21, 21, 3);
   int ema_34 = EMA_Vs_Price(timeFrame, bar_index, 34, 34, 3);
   int ema_89 = EMA_Vs_Price(timeFrame, bar_index, 89, 34, 3);
   if(ema_34 != 0)
     {
      ema_bullish = ema_34;
      price = ema_34 > 0? iLow(_Symbol, timeFrame, bar_index):iHigh(_Symbol, timeFrame, bar_index);
      str_ema += "\n- EMA 34: Giá Close " +(ema_34 > 0? "trên đường EMA 34 xu thế TĂNG": "dưới đường EMA 34 xu thế GIẢM")+ " tại vị trí nến thứ " + (string)bar_index;
      text_arr[text_arr_i] = "EMA 34 "+ (ema_34 > 0? "TANG": "GIAM")+ " (nen " + (string)bar_index + ")";
      text_arr_i++;
     }
   if(ema_89 != 0)
     {
      ema_bullish = ema_89;
      price = ema_89 > 0? iLow(_Symbol, timeFrame, bar_index):iHigh(_Symbol, timeFrame, bar_index);
      str_ema += "\n- EMA 89: Giá Close " +(ema_89 > 0? "trên đường EMA 89 xu thế TĂNG": "dưới đường EMA 89 xu thế GIẢM")+ " tại vị trí nến thứ " + (string)bar_index;
      text_arr[text_arr_i] = "EMA 89 "+ (ema_89 > 0? "TANG": "GIAM") + " (nen " + (string)bar_index + ")";
      text_arr_i++;
     }
   if(str_ema == "" && ema_21 != 0)// giá không chạm ema 34 và ema 89 thì xét thêm ema 21
     {
      ema_bullish = ema_21;
      price = ema_21 > 0? iLow(_Symbol, timeFrame, bar_index):iHigh(_Symbol, timeFrame, bar_index);
      str_ema += "\n- EMA 21: Giá Close " +(ema_21 > 0? "trên đường EMA 21 xu thế TĂNG": "dưới đường EMA 21 xu thế GIẢM")+ " tại vị trí nến thứ " + (string)bar_index;
      text_arr[text_arr_i] = "EMA 21 "+ (ema_21 > 0? "TANG": "GIAM") + " (nen " + (string)bar_index +  ")";
      text_arr_i++;
     }
   int can_result = Candle_Pattern(timeFrame, str_candlestick);
   if(str_ema != "" && str_candlestick != "")//Có tín hiệu EMA và tín hiệu mô hình nến, kiểm tra có cùng hướng hay không
     {
      //DrawArrow("EMA_" + tfStr, price, iTime(_Symbol, timeFrame, bar_index), is_bullish, bar_index, timeFrame);
      if(TelegramNotification == true)
        {
         if((ema_bullish > 0 && can_result > 0) || (ema_bullish < 0 && can_result < 0))
            str_result+= "\n---*TÍN HIỆU EMA + MÔ HÌNH NẾN ["+(ema_bullish > 0? "TĂNG": "GIẢM")+"]*---" + str_ema + str_candlestick;
        }
     }
   return str_result;
  }

//+------------------------------------------------------------------+
//| Giá phá cản
//| Giá quay về test cản
//| Lý thuyết DOW
//| Market structure
//+------------------------------------------------------------------+
string System_ResistanceSupport(int timeFrame, int maxBar = 400, bool onlyDraw = false)
  {
   string tfStr = ConvertTimeFrametoString(timeFrame);
   string str_result = "";
   double R_bar[1000][2] = {};
   double S_bar[1000][2] = {};
   Get_ResistanceSupport(timeFrame, R_bar, S_bar, maxBar);//Lấy danh sách kháng cự hỗ trợ
   int R_index = ArraySize(R_bar)/2;
   int S_index = ArraySize(S_bar)/2;
   ResistanceSupportGraph(timeFrame, R_bar, S_bar);//Vẽ kháng cự hỗ trợ lên chart
   if(onlyDraw == false)//Vẽ xong và kiểm tra kháng cự hỗ trợ theo system
     {
      int rs_result = PA_Price_RS(timeFrame, R_bar, S_bar);//Giá chạm cản và phản ứng với cản
      int dow_result = PA_Dow(timeFrame, R_bar, S_bar);//Giá đi theo lý thuyết DOW
      int ms_result = PA_MarketStructure(timeFrame, R_bar, S_bar);//Giá đi theo mô hình Market Structure
      string str_candlestick = "";
      int can_result = Candle_Pattern(timeFrame, str_candlestick);
      if(rs_result != 0)
        {
         text_arr[text_arr_i] = rs_result > 0 ? "Gia test Ho Tro" : "Gia test Khang Cu";
         text_arr_i++;
         if(rs_result < 0 && can_result < 0)
            str_result += "\n---*TÍN HIỆU KHÁNG CỰ HỖ TRỢ*---\nGiá chạm kháng cự và đóng cửa dưới đường kháng cự (Nến "+(string)MathAbs(rs_result)+")." + str_candlestick;
         if(rs_result > 0 && can_result > 0)
            str_result += "\n---*TÍN HIỆU KHÁNG CỰ HỖ TRỢ*---\nGiá chạm hỗ trợ và đóng cửa trên đường hỗ trợ (Nến "+(string)MathAbs(rs_result)+")." + str_candlestick;
        }
      if(dow_result != 0 && str_candlestick != "")
        {

         text_arr[text_arr_i] = dow_result > 0 ? "LT DOW gia TANG" : "LT DOW gia GIAM";
         text_arr_i++;
         if(dow_result > 0 && can_result > 0)
            str_result+="\n---*TÍN HIỆU DOW*--- \nMô hình lý thuyết DOW dự đoán giá TĂNG (Nến "+(string)MathAbs(dow_result)+")."+ str_candlestick;
         if(dow_result < 0 && can_result < 0)
            str_result+="\n---*TÍN HIỆU DOW*--- \nMô hình lý thuyết DOW dự đoán giá GIẢM (Nến "+(string)MathAbs(dow_result)+")." + str_candlestick;
        }
      if(ms_result != 0)
        {
         text_arr[text_arr_i] = ms_result > 0 ? "Market Structure gia TANG." : "Market Structure gia GIAM.";
         text_arr_i++;
         if(ms_result > 0 && can_result > 0)
            str_result+="\n---*TÍN HIỆU MARKET STRUCTURE*---\nMô hình Market Structure dự đoán giá TĂNG (Nến "+(string)MathAbs(ms_result)+")." + str_candlestick;
         if(ms_result < 0 && can_result < 0)
            str_result+="\n---*TÍN HIỆU MARKET STRUCTURE*---\nMô hình Market Structure dự đoán giá GIẢM (Nến "+(string)MathAbs(ms_result)+")." + str_candlestick;
        }
     }
   return str_result;
  }
//+------------------------------------------------------------------+
//| Mô hình nến
//+------------------------------------------------------------------+
string System_Candles_Pattern(int timeFrame/*, string &text_arr[], int &text_arr_i*/)
  {
   string str_singal = "";
   if(c7cb != 0)
     {
      str_singal += (c7cb > 0 ? "C7CB gia TANG" : "C7CB gia GIAM");
      text_arr[text_arr_i] = (c7cb > 0 ? "C7CB gia TANG" : "C7CB gia GIAM");
      text_arr_i++;
     }
   if(c74b != 0)
     {
      str_singal += (c74b > 0 ? "4Block Tang Dan" : "4Block Giam Dan");
      text_arr[text_arr_i] = (c74b > 0 ? "4Block Tang Dan" : "4Block Giam Dan");
      text_arr_i++;
     }
   if(c7cc != 0)
     {
      str_singal += (c7cc > 0 ? "C7CC gia TANG" : "C7CC gia GIAM");
      text_arr[text_arr_i] = (c7cc > 0 ? "C7CC gia TANG" : "C7CC gia GIAM");
      text_arr_i++;
     }
   if(c7pt != 0)
     {
      str_singal += (c7pt > 0 ? "C7PT gia TANG": "C7PT gia GIAM");
      text_arr[text_arr_i] = (c7pt > 0 ? "C7PT gia TANG": "C7PT gia GIAM");
      text_arr_i++;
     }
   if(c75n != 0)
     {
      str_singal += (c75n > 0 ? "C7CB gia TANG" : "C7CB gia GIAM");
      text_arr[text_arr_i] = (c75n > 0 ? "C7CB gia TANG" : "C7CB gia GIAM");
      text_arr_i++;
     }
   if(c7tt != 0)
     {
      str_singal += (c7tt > 0 ? "C7TT 3 nen TANG" : "C7TT 3 nen GIAM");
      text_arr[text_arr_i] = (c7tt > 0 ? "C7TT 3 nen TANG" : "C7TT 3 nen GIAM");
      text_arr_i++;
     }
//str_singal += Engulfingbar(timeFrame, 2);
   if(str_singal != "")
     {
      //Telegram_send("["+ConvertTimeFrametoString(timeFrame)+" - "+_Symbol+"] - *TÍN HIỆU MÔ HÌNH NẾN*\n" + str_singal, tele_PA_id);
     }
   return str_singal;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetTrendPrice(int timeFrame = 0)
  {
   string str_trend_0 = "EMA21: ";
   int trend_ema21_m15 = GetTrendByEMA(_Symbol, PERIOD_M15, 21, 15);
   int trend_ema21_m30 = GetTrendByEMA(_Symbol, PERIOD_M30, 21, 15);
   int trend_ema21_h1 = GetTrendByEMA(_Symbol, PERIOD_H1, 21, 15);
   int trend_ema21_h4 = GetTrendByEMA(_Symbol, PERIOD_H4, 21, 15);
   str_trend_0 += (trend_ema21_m15 > 0  ? "M15 TANG":(trend_ema21_m15 == 0 ? "M15  SW  " : "M15 GIAM"));
   str_trend_0 += (trend_ema21_m30 > 0  ? " |- M30 TANG":(trend_ema21_m30 == 0 ? " |- M30  SW  " : " |- M30 GIAM"));
   str_trend_0 += (trend_ema21_h1  > 0  ? " |- H1 TANG" :(trend_ema21_h1 == 0  ? " |- H1  SW  "  : " |- H1 GIAM"));
   str_trend_0 += (trend_ema21_h4  > 0  ? " |- H4 TANG" :(trend_ema21_h4 == 0  ? " |- H4  SW  "  : " |- H4 GIAM"));

   string str_trend_1 = "EMA34: ";
   int trend_ema34_m15 = GetTrendByEMA(_Symbol, PERIOD_M15, 34, 21);
   int trend_ema34_m30 = GetTrendByEMA(_Symbol, PERIOD_M30, 34, 21);
   int trend_ema34_h1 = GetTrendByEMA(_Symbol, PERIOD_H1, 34, 21);
   int trend_ema34_h4 = GetTrendByEMA(_Symbol, PERIOD_H4, 34, 21);
   str_trend_1 += (trend_ema34_m15 > 0  ? "M15 TANG":(trend_ema34_m15 == 0 ? "M15  SW  " : "M15 GIAM"));
   str_trend_1 += (trend_ema34_m30 > 0  ? " |- M30 TANG":(trend_ema34_m30 == 0 ? " |- M30  SW  " : " |- M30 GIAM"));
   str_trend_1 += (trend_ema34_h1  > 0  ? " |- H1 TANG" :(trend_ema34_h1 == 0  ? " |- H1  SW  "  : " |- H1 GIAM"));
   str_trend_1 += (trend_ema34_h4  > 0  ? " |- H4 TANG" :(trend_ema34_h4 == 0  ? " |- H4  SW  "  : " |- H4 GIAM"));

   string str_trend_2 = "EMA89: ";
   int trend_ema89_m15 = GetTrendByEMA(_Symbol, PERIOD_M15, 89, 50);
   int trend_ema89_m30 = GetTrendByEMA(_Symbol, PERIOD_M30, 89, 50);
   int trend_ema89_h1  = GetTrendByEMA(_Symbol, PERIOD_H1, 89, 50);
   int trend_ema89_h4  = GetTrendByEMA(_Symbol, PERIOD_H4, 89, 50);
   str_trend_2 += (trend_ema89_m15 > 0  ? "M15 TANG":(trend_ema89_m15 == 0 ? "M15  SW  " : "M15 GIAM"));
   str_trend_2 += (trend_ema89_m30 > 0 ? " |- M30 TANG":(trend_ema89_m30 == 0 ? " |- M30  SW  " : " |- M30 GIAM"));
   str_trend_2 += (trend_ema89_h1 > 0  ? " |- H1 TANG" :(trend_ema89_h1 == 0  ? " |- H1  SW  "  : " |- H1 GIAM"));
   str_trend_2 += (trend_ema89_h4 > 0  ? " |- H4 TANG" :(trend_ema89_h4 == 0  ? " |- H4  SW  "  : " |- H4 GIAM"));
   DrawTrendPrice(str_trend_0, str_trend_1, str_trend_2);
  }
//+------------------------------------------------------------------+
