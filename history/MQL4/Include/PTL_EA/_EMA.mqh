//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*string VGT_EMA(int timeFrame, bool isCheckEMA34 = false, bool isCheckEMA987 = false, bool isSendTele = true)
  {
   string str_signal = "";
   int xuHuongEMA89 = GetTrendByEMA(_Symbol, timeFrame, 89, 89);
   double giaTriEMA89 = iMA(_Symbol,timeFrame,89,1,MODE_EMA,PRICE_CLOSE, 1);
   int xuHuongEMA34 = GetTrendByEMA(_Symbol, timeFrame, 34, 89);
   double giaTriEMA34 = iMA(_Symbol,timeFrame,34,1,MODE_EMA,PRICE_CLOSE, 1);

   double open = iOpen(_Symbol, timeFrame, 0);
   double close_prev = iClose(_Symbol,timeFrame, 1);
   double high_prev = iHigh(_Symbol,timeFrame, 1);
   double low_prev = iLow(_Symbol,timeFrame, 1);
   double close_prev_2 = iClose(_Symbol,timeFrame, 2);
   double high_prev_2 = iHigh(_Symbol,timeFrame, 2);
   double low_prev_2 = iLow(_Symbol,timeFrame, 2);
   int rsi_prev = (int)iRSI(_Symbol, timeFrame, 9, PRICE_CLOSE, 1);

   string tfStr = ConvertTimeFrametoString(timeFrame);
   double pips = TinhSoPips(giaTriEMA89, low_prev);//xu hướng tăng
   if(xuHuongEMA89 == -1)
     {
      pips = TinhSoPips(giaTriEMA89, high_prev);//Xu hướng giảm
     }

   string macro_trend = "";
   if(timeFrame <= 60)
     {
      if(timeFrame < 60)
        {
         macro_trend += "\n--------------------------------------------";
         int xuHuongEMA89_h1 = GetTrendByEMA(_Symbol, PERIOD_H1, 89, 89);
         double giaTriEMA89_h1 = iMA(_Symbol, PERIOD_H1, 89, 1, MODE_EMA, PRICE_CLOSE, 1);
         macro_trend += "\n- Xu hướng EMA89 H1: "+(xuHuongEMA89_h1 == -1?"GIẢM":(xuHuongEMA89_h1 == 1?"TĂNG":"Sideway"));
         macro_trend += "\n- Giá đang nằm " +(close_prev > giaTriEMA89_h1 ? "TRÊN" : "DƯỚI")+" EMA 89 H1";
        }
      macro_trend += "\n-----------------------------------------------";
      int xuHuongEMA89_h4 = GetTrendByEMA(_Symbol, PERIOD_H4, 89, 89);
      double giaTriEMA89_h4 = iMA(_Symbol, PERIOD_H4, 89, 1, MODE_EMA, PRICE_CLOSE, 1);
      macro_trend += "\n- Xu hướng EMA89 H4: "+(xuHuongEMA89_h4 == -1?"GIẢM":(xuHuongEMA89_h4 == 1?"TĂNG":"Sideway"));
      macro_trend += "\n- Giá đang nằm "+(close_prev> giaTriEMA89_h4 ? "TRÊN" : "DƯỚI")+" EMA 89 H4";
     }

   if((giaTriEMA89 < high_prev && giaTriEMA89 > low_prev) ) //Giá cắt đường EMA89 hoặc giá cách EMA 1 khoảng dưới 2 pips
     {
      //Nếu xu hướng tăng và giá đóng cửa trên EMA
      if(xuHuongEMA89 == 1 &&  close_prev > giaTriEMA89 && open > giaTriEMA89  && giaTriEMA89 < giaTriEMA34) //EMA34 nằm trên EMA89
        {

         string str_result = "_["+tfStr+" - " +Symbol()+"]_ - *VGT EMA89 - TĂNG* - (RSI: "+(string)rsi_prev+")";
         //str_result += "\n- Vùng giá trị với EMA89.\n- Giá trước đó chạm EMA và đóng nến trên EMA!";
         str_result += "\n- Giá trị RSI: " + (string)rsi_prev;
         str_result += macro_trend;
         if(isSendTele)
            Telegram_send(str_result, tele_EMA_id);

         DrawArrowAndText("VGT_EMA89", low_prev, true, 1, timeFrame,"VGT89");
         str_signal += "\n- ("+ConvertTimeFrametoString(timeFrame)+") - Vung gia tri voi EMA89 - TANG - (RSI: "+(string)rsi_prev+")";
        }
      //Nếu xu hướng giảm và giá đóng cửa dưới EMA
      else
         if(xuHuongEMA89 == -1 && close_prev < giaTriEMA89  && open < giaTriEMA89 && giaTriEMA89 > giaTriEMA34)//EMA34 nằm dưới EMA89
           {
            //Mail_send(timeFrame, "Vung gia tri EMA89 - GIAM-(RSI: "+(string)rsi_value+")", "Pair: " + _Symbol + "\n Vung gia tri voi EMA89, gia truoc do cham EMA va dong nen duoi EMA!");
            string str_result ="_["+tfStr+" - " +Symbol()+"]_ - *VGT EMA89 - GIẢM* - (RSI: "+(string)rsi_prev+")";
            //str_result += "\n- Vùng giá trị với EMA89.\n- Giá trước đó chạm EMA và đóng nến dưới EMA!";
            str_result += "\n- Giá trị RSI: " + (string)rsi_prev;
            str_result += macro_trend;
            if(isSendTele)
               Telegram_send(str_result, tele_EMA_id);
            DrawArrowAndText("VGT_EMA89", high_prev, false, 1, timeFrame,"VGT89");
            str_signal += "\n- ("+ConvertTimeFrametoString(timeFrame)+") - Vung gia tri voi EMA89 - GIAM -(RSI: "+(string)rsi_prev+")";
           }
     }
   if(isCheckEMA34 == true)
     {

      if(giaTriEMA34 < high_prev && giaTriEMA34 > low_prev) //Giá cắt đường EMA34
        {
         //Nếu xu hướng tăng và giá đóng cửa trên EMA
         if(xuHuongEMA34 == 1 && close_prev > giaTriEMA34 && open > giaTriEMA34)
           {
            //Mail_send(timeFrame, "Vung gia tri EMA34 - TANG-(RSI: "+(string)rsi_value+")", "Pair: " + _Symbol + "\n Vung gia tri voi EMA34, gia truoc do cham EMA va dong nen tren EMA!");
            string str_result ="_["+tfStr+" - " +Symbol()+"]_ - *VGT EMA34 - TĂNG* -(RSI: "+(string)rsi_prev+")";
            //str_result + ="\n- Vùng giá trị với EMA34.\n- Giá trước đó chạm EMA và đóng nến trên EMA!";
            str_result += "\n- Giá trị RSI: " + (string)rsi_prev;
            str_result += macro_trend;
            if(isSendTele)
               Telegram_send(str_result, tele_EMA_id);
            DrawArrowAndText("VGT_EMA34", low_prev, true, 1, timeFrame,"VGT34");
            str_signal += "\n("+ConvertTimeFrametoString(timeFrame)+") - VGT voi EMA34 - TANG -(RSI: "+(string)rsi_prev+")";
           }
         //Nếu xu hướng giảm và giá đóng cửa dưới EMA
         else
            if(xuHuongEMA34 == -1 && close_prev < giaTriEMA34 && open < giaTriEMA34)
              {
               //Mail_send(timeFrame, "Vung gia tri EMA34 - GIAM-(RSI: "+(string)rsi_value+")", "Pair: " + _Symbol + "\n Vung gia tri voi EMA34, gia truoc do cham EMA va dong nen duoi EMA!");
               string str_result ="_["+tfStr+" - " +Symbol()+"]_ - *VGT EMA34 - GIẢM* -(RSI: "+(string)rsi_prev+")";
               //str_result += "\n- Vùng giá trị với EMA34.\n- Giá trước đó chạm EMA và đóng nến dưới EMA!";
               str_result += "\n- Giá trị RSI: " + (string)rsi_prev;
               str_result += macro_trend;
               if(isSendTele)
                  Telegram_send(str_result, tele_EMA_id);
               DrawArrowAndText("VGT_EMA34", high_prev, false, 1, timeFrame,"VGT34");
               str_signal += "\n- ("+ConvertTimeFrametoString(timeFrame)+") - VGT EMA34 - GIAM -(RSI: "+(string)rsi_prev+")";
              }
        }
     }
   if(isCheckEMA987 == true)
     {
      int xuHuongEMA987 = GetTrendByEMA(_Symbol, timeFrame, 987, 89);
      double giaTriEMA987 = iMA(_Symbol,timeFrame,987,1,MODE_EMA,PRICE_CLOSE, 1);

      if(giaTriEMA987 < high_prev && giaTriEMA987 > low_prev) //Giá cắt đường EMA987
        {
         //Nếu xu hướng tăng và giá đóng cửa trên EMA
         if(xuHuongEMA987 == 1 && close_prev > giaTriEMA987 && open > giaTriEMA987)
           {
            //Mail_send(timeFrame, "Vung gia tri EMA987 - TANG-(RSI: "+(string)rsi_value+")", "Pair: " + _Symbol + "\n Vung gia tri voi EMA987, gia truoc do cham EMA va dong nen tren EMA!");
            string str_result ="_["+tfStr+" - " +Symbol()+"]_ - *VGT EMA987 - TĂNG* -(RSI: "+(string)rsi_prev+")";
            //str_result += "\n- Vùng giá trị với EMA34.\n- Giá trước đó chạm EMA và đóng nến dưới EMA!";
            str_result += "\n- Giá trị RSI: " + (string)rsi_prev;
            //str_result += macro_trend;
            if(isSendTele)
               Telegram_send(str_result, tele_EMA_id);
            DrawArrowAndText("VGT_EMA987", low_prev, true, 1, timeFrame,"VGT987");
            str_signal += "\n- ("+ConvertTimeFrametoString(timeFrame)+") - VGT EMA987 - TĂNG* -(RSI: "+(string)rsi_prev+")";
           }
         //Nếu xu hướng giảm và giá đóng cửa dưới EMA
         else
            if(xuHuongEMA987 == -1 && close_prev < giaTriEMA987  && open < giaTriEMA987)
              {
               //Mail_send(timeFrame, "Vung gia tri EMA987 - GIAM-(RSI: "+(string)rsi_value+")", "Pair: " + _Symbol + "\n Vung gia tri voi EMA987, gia truoc do cham EMA va dong nen duoi EMA!");

               string str_result ="_["+tfStr+" - " +Symbol()+"]_ - *VGT EMA987 - GIẢM* -(RSI: "+(string)rsi_prev+")";
               //str_result += "\n- Vùng giá trị với EMA987.\n- Giá trước đó chạm EMA và đóng nến dưới EMA!";
               str_result += "\n- Giá trị RSI: " + (string)rsi_prev;
               //str_result += macro_trend;
               if(isSendTele)
                  Telegram_send(str_result, tele_EMA_id);
               DrawArrowAndText("VGT_EMA987", high_prev, false, 1, timeFrame,"VGT987");
               str_signal += "\n- ("+ConvertTimeFrametoString(timeFrame)+") - VGT EMA987 - GIAM -(RSI: "+(string)rsi_prev+")";
              }
        }
     }
   return str_signal;
  }*/
//+------------------------------------------------------------------+
//| Giá trị trả về:
//| -1: Giá cắt đường EMA và giảm
//| 1: Giá cắt đường EMA và tăng
//| 0: EMA không có giá trị
//+------------------------------------------------------------------+
int EMA_Vs_Price(int timeFrame, int &bar_index, int ema_value = 89,int bar_num=34, int max_bar = 2)
  {
   string str_signal = "";
   int xuHuongEMA = GetTrendByEMA(_Symbol, timeFrame, ema_value, bar_num);
   double close_1 = iClose(_Symbol,timeFrame, 1);
   for(int i = 1; i <= max_bar; i++)
     {
      double giaTriEMA = iMA(_Symbol,timeFrame, ema_value, i, MODE_EMA, PRICE_CLOSE, i);
      //double open = iOpen(_Symbol, timeFrame, 0);
      double close_i = iClose(_Symbol,timeFrame, i);
      double high_i = iHigh(_Symbol,timeFrame, i);
      double low_i = iLow(_Symbol,timeFrame, i);

      if((giaTriEMA <= high_i && giaTriEMA >= low_i) /*|| pips < 2*/) //Giá cắt đường EMA89 hoặc giá cách EMA 1 khoảng dưới 2 pips
        {
         //Nếu xu hướng tăng và giá đóng cửa trên EMA
         if(xuHuongEMA == i &&  close_i > giaTriEMA && close_1 > giaTriEMA /*&& open > giaTriEMA  && xuHuongEMA34 == 1 && giaTriEMA89 < giaTriEMA34*/) //EMA34 nằm trên EMA89
           {
            bar_index = i;
            return 1;
           }
         //Nếu xu hướng giảm và giá đóng cửa dưới EMA
         else
            if(xuHuongEMA == -1 && close_i < giaTriEMA && close_1 < giaTriEMA  /*&& open < giaTriEMA && xuHuongEMA34 == -1 && giaTriEMA89 > giaTriEMA34*/)//EMA34 nằm dưới EMA89
              {
               bar_index = i;
               return -1;
              }
        }
     }
   return 0;
  }

//+------------------------------------------------------------------+
int GetTrendByEMA(string symb, int timeFrame, int ma_period, int barNum, int barIndex = 0)
//Giá trị trả về: 1: Uptrend | 0: Sideway | -1: Downtrend
  {
   double nUp = 0;
   double nDow = 0;
   double nSideway = 0;
   for(int i = barIndex; i < barNum; i++)
     {
      double ema = iMA(symb, timeFrame, ma_period, i, MODE_EMA, PRICE_CLOSE, i);
      double priceClose = iClose(symb, timeFrame,i);
      double priceOpen = iOpen(symb, timeFrame,i);
      double priceLow = iLow(symb, timeFrame,i);
      double priceHigh = iHigh(symb, timeFrame,i);
      if(ema > priceClose)
        {
         nDow++;
        }
      else
         if(ema < priceClose)
           {
            nUp++;
           }
         else
            if(ema >= priceLow && ema <= priceHigh)
              {
               nSideway++;
              }
     }
   double upPercent = GetPercentage(nUp, barNum);
   double downPercent = GetPercentage(nDow, barNum);
   double sidewayPercent = GetPercentage(nSideway, barNum);
   if(upPercent>70)
     {
      return 1;
     }
   if(downPercent > 70)
     {
      return -1;
     }
   return 0;
  }
//+------------------------------------------------------------------+
