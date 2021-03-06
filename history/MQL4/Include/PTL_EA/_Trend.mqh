//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

double prevbid=0;

bool flag_d = false,flag_w = false,flag_mn = false;
bool flag_Trend = false, flag_OB = false;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrendAnalysis()
  {
   flag_d = false;
   flag_w = false;
   flag_mn = false;
   flag_Trend = false;
   flag_OB = false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

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
bool CheckPriceTestTrendLine(int timeFrame, double trend_price, int trend_main, int barNum = 100,/*int barTestTrend = 10,*/ int barIndex = 1)
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

/*
int ViTriGiaVsTrendline(int timeFrame,double price_trend, int shift = 1)
  {
// Xét giá đóng cửa và mở cửa. Giá trị trả về: 1: Giá nằm trên trendline | -1: Giá nằm dưới trendline | 0: Giá cắt trendline
   double price_h = iHigh(_Symbol, timeFrame, shift);
   double price_l = iLow(_Symbol, timeFrame, shift);
   double price_o = iOpen(_Symbol, timeFrame, shift);
   double price_c = iClose(_Symbol, timeFrame, shift);
//if(price_trend > price_h) return 1;
//if(price_trend < price_l) return -1;
   if(price_o > price_c) //nến tăng
     {
      if(price_trend > price_o)
         return 1;
      if(price_trend < price_c)
         return -1;
     }
   if(price_o < price_c) //nến giảm
     {
      if(price_trend > price_c)
         return 1;
      if(price_trend < price_o)
         return -1;
     }
   return 0;
  }
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GiaVsOderBlock()
  {
//Khi giá chạm hoặc nến kế trước chạm, kiểm tra 4 nến kề trước có chạm không, nến close trên hay dưới trend line
//Xác định xu hướng chính
//Xác định đang là sóng hồi chạm hay sóng chính chạm
//Kết hợp với đường EMA 34 và EMA 89
   string data_result = "";

   return data_result;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetTrendOverviewByEMA()
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
