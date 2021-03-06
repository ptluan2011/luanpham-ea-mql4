
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
/*
int GetTrendByPriceVSTrendLine(int timeFrame, double trend_price, int barNum = 100, int barIndex = 1)
//Giá trị trả về: 1: ở trên trend | -1: ở dưới trend | 0: cắt trend
  {
   double nUp = 0;
   double nDow = 0;
   double nSideway = 0;

   for(int i = barIndex; i < barNum; i++)
     {
      //double high = iHigh(_Symbol, timeFrame, i);
      //double low = iLow(_Symbol, timeFrame, i);
      double open_i = iOpen(_Symbol, timeFrame, i);
      double close_i = iClose(_Symbol, timeFrame, i);
      double low_i = open_i < close_i ? open_i : close_i ;
      double high_i = open_i > close_i ? open_i : close_i ;
      if(trend_price > high_i)
        {
         nUp++;
        }
      else
         if(trend_price < low_i)
           {
            nDow ++;
           }
         else
           {
            nSideway++;
           }
     }
   double upPercent = GetPercentage(nUp, barNum);
   double downPercent = GetPercentage(nDow, barNum);
   double sidewayPercent = GetPercentage(nSideway, barNum);
   if(upPercent > 70)
     {
      return 1;
     }
   if(downPercent > 70)
     {
      return -1;
     }
   return 0;
  }
bool CheckPriceTestTrendLine(int timeFrame, double trend_price, int trend_main, int barNum = 100, int barIndex = 1)
  {
//Khi giá cắt qua trend, giá vòng lại ngược xu hướng chính và chạm trend, sau đó đóng cửa theo xu hướng chính của trend
   int idx = -1;
   int nUp = 0;
   int nDow = 0;
   for(int i = barIndex+1; i < barNum; i++)// tìm vị trí giá cắt qua trendline trước đó
     {
      double low_i = iOpen(_Symbol, timeFrame, i) < iClose(_Symbol, timeFrame, i) ? iOpen(_Symbol, timeFrame, i) : iClose(_Symbol, timeFrame, i) ;
      double high_i = iOpen(_Symbol, timeFrame, i) > iClose(_Symbol, timeFrame, i) ? iOpen(_Symbol, timeFrame, i) : iClose(_Symbol, timeFrame, i) ;
      if(trend_price >= low_i && trend_price <= high_i)//giá cắt trend line
        {
         idx = i;
         break;
        }
     }
   if(idx > barIndex && idx < barNum/2)// vị trí vượt trend không quá 1 nửa số lượng nến xác định xu hướng chính
     {
      for(int i = barIndex + 1; i < idx; i++)
        {
         double low_i = iOpen(_Symbol, timeFrame, i) < iClose(_Symbol, timeFrame, i) ? iOpen(_Symbol, timeFrame, i) : iClose(_Symbol, timeFrame, i) ;
         double high_i = iOpen(_Symbol, timeFrame, i) > iClose(_Symbol, timeFrame, i) ? iOpen(_Symbol, timeFrame, i) : iClose(_Symbol, timeFrame, i) ;
         if(trend_main == -1 && trend_price > high_i)// xu hướng chính giảm, nến đang ở dưới trend
           {
            nUp++;
           }
         else
            if(trend_main == 1 && trend_price < low_i)// xu hướng chính đang tăng, nến đang ở trên trend
              {
               nDow ++;
              }
        }
      if(trend_main == -1 && nUp > 1 && nUp >= (nDow*2))
         return true;
      if(trend_main == 1 && nDow > 1 && nDow >= (nUp*2))
         return true;
     }

   return false;
  }
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*string GetTrendOverviewByEMA()
  {
   int xuHuongEMA34_M5 = GetTrendByEMA(Symbol(), PERIOD_M5, 34, 89);
   int xuHuongEMA89_M5 = GetTrendByEMA(Symbol(), PERIOD_M5, 89, 89);

   int xuHuongEMA34_M15 = GetTrendByEMA(Symbol(), PERIOD_M15, 34, 89);
   int xuHuongEMA89_M15 = GetTrendByEMA(Symbol(), PERIOD_M15, 89, 89);

   int xuHuongEMA34_M30 = GetTrendByEMA(Symbol(), PERIOD_M30, 34, 89);
   int xuHuongEMA89_M30 = GetTrendByEMA(Symbol(), PERIOD_M30, 89, 89);

   int xuHuongEMA34_H1 = GetTrendByEMA(Symbol(), PERIOD_H1, 34, 89);
   int xuHuongEMA89_H1 = GetTrendByEMA(Symbol(), PERIOD_H1, 89, 89);

   int xuHuongEMA34_H4 = GetTrendByEMA(Symbol(), PERIOD_H4, 34, 89);
   int xuHuongEMA89_H4 = GetTrendByEMA(Symbol(), PERIOD_H4, 89, 89);

   int xuHuongEMA34_D1 = GetTrendByEMA(Symbol(), PERIOD_D1, 34, 89);
   int xuHuongEMA89_D1 = GetTrendByEMA(Symbol(), PERIOD_D1, 89, 89);
   string txtTrend = "";
   txtTrend += " M5 - EMA34: " +(xuHuongEMA34_M5 == -1?"DownTrend":(xuHuongEMA34_M5 == 1?"UpTrend":"Sideway")) + " / EMA89: " + (xuHuongEMA89_M5 == -1?"DownTrend":(xuHuongEMA89_M5 == 1?"UpTrend":"Sideway"));

   txtTrend += " <---> M15 - EMA34: " +(xuHuongEMA34_M15 == -1?"DownTrend":(xuHuongEMA34_M15 == 1?"UpTrend":"Sideway")) + " / EMA89: " + (xuHuongEMA89_M15 == -1?"DownTrend":(xuHuongEMA89_M15 == 1?"UpTrend":"Sideway"));
   txtTrend += " <---> M30 - EMA34: " +(xuHuongEMA34_M30 == -1?"DownTrend":(xuHuongEMA34_M30 == 1?"UpTrend":"Sideway")) + " / EMA89: " + (xuHuongEMA89_M30 == -1?"DownTrend":(xuHuongEMA89_M30 == 1?"UpTrend":"Sideway"));

   txtTrend += " <---> H1 - EMA34: " +(xuHuongEMA34_H1 == -1?"DownTrend":(xuHuongEMA34_H1 == 1?"UpTrend":"Sideway")) + " / EMA89: " + (xuHuongEMA89_H1 == -1?"DownTrend":(xuHuongEMA89_H1 == 1?"UpTrend":"Sideway"));
   txtTrend += " <---> H4 - EMA34: " +(xuHuongEMA34_H4 == -1?"DownTrend":(xuHuongEMA34_H4 == 1?"UpTrend":"Sideway")) + " / EMA89: " + (xuHuongEMA89_H4 == -1?"DownTrend":(xuHuongEMA89_H4 == 1?"UpTrend":"Sideway"));
   txtTrend += " <---> D1 - EMA34: " +(xuHuongEMA34_D1 == -1?"DownTrend":(xuHuongEMA34_D1 == 1?"UpTrend":"Sideway")) + " / EMA89: " + (xuHuongEMA89_D1 == -1?"DownTrend":(xuHuongEMA89_D1 == 1?"UpTrend":"Sideway"));

   return txtTrend;
  }
//+------------------------------------------------------------------+
*/