//+------------------------------------------------------------------+
//|                                                 _PriceAction.mqh |
//|                                                        Luan Pham |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luan Pham"
#property link      ""
#property strict

//+------------------------------------------------------------------+
//| Kiểm tra sự biến động của nến, nếu bất ngờ có chuyển động lớn thì báo để theo dõi |
//+------------------------------------------------------------------+
string CheckBarBigMove(int timeFrame)
  {
   double low=iLow(_Symbol,timeFrame,0);
   double high = iHigh(_Symbol, timeFrame, 0);
   double open = iOpen(_Symbol, timeFrame, 0);
   double close= iClose(_Symbol,timeFrame,0);
   double pips = TinhSoPips(low,high);
   if(pips>=19 && StringFind(_Symbol,"XAU")==-1)
     {
      string tfStr=ConvertTimeFrametoString(timeFrame);
      if(close > open)
        {
         return "["+tfStr+" - "+_Symbol+"] - Giá đang biến động mạnh - TĂNG \n Giá đang dao động mạnh với số pips: "+(string)NormPrice(pips);
        }
      else
        {
         return "["+tfStr+" - "+_Symbol+"] - Giá đang biến động mạnh - GIẢM \n Giá đang dao động mạnh với số pips: "+(string)NormPrice(pips);
        }
     }
   return "";
  }
//+------------------------------------------------------------------+
//Xu hướng giảm, giá tăng chạm và close dưới kháng cự => xem xét có phải tăng hồi phục để tiếp tục xu hướng giảm không.
//Xu hướng tăng, giá giảm chạm và close trên hỗ trợ => xem xét có phải giảm hồi phục để tiếp tục xu hướng tăng không.
//+------------------------------------------------------------------+
int PA_Dow(int timeFrame, double &R_bar[][2], double &S_bar[][2])
  {
   string rs_result = "";
   int r_index = ArraySize(R_bar)/2;
   int s_index = ArraySize(S_bar)/2;
   int trend_ema34 = GetTrendByEMA(_Symbol, timeFrame, 21, 34);
   double close_1 = iClose(_Symbol, timeFrame, 1);
   double low_1 = iLow(_Symbol, timeFrame, 1);
   double high_1 = iHigh(_Symbol, timeFrame, 1);
   if(r_index >= 2 && s_index >= 2)
     {
      double r_price_0 = R_bar[0][1];
      int r_index_0    = (int)R_bar[0][0];//Đỉnh 0
      double r_price_1 = R_bar[1][1];
      int r_index_1    = (int)R_bar[1][0];//Đỉnh 1
      double s_price_0 = S_bar[0][1];
      int s_index_0    = (int)S_bar[0][0];//Đáy 0
      double s_price_1 = S_bar[1][1];
      int s_index_1    = (int)S_bar[1][0];//Đáy 1

      if(r_price_0 > low_1 && r_price_0 < high_1 && r_price_0 < close_1)//Giá cắt kháng cự và close trên đường kháng cự
        {
         if(s_price_0 > s_price_1 && s_price_0 < r_price_0)// đáy sau cao hơn đáy trước, đáy sau thấp hơn đỉnh
           {
            if(s_index_0 < r_index_0 && r_index_0 < s_index_1 && trend_ema34 > 0)//đỉnh nằm giữa 2 đáy
              {
               //rs_result += "\nMô hình lý thuyết DOW dự đoán giá TĂNG. \nĐường EMA cho xu hướng Tăng.";//check thêm điều kiện để tuân thủ theo lý thuyết DOW
               return 1;
              }
           }
        }

      if(s_price_0 > low_1 && s_price_0 < high_1 && s_price_0 > close_1)//Giá cắt hỗ trợ và close dưới đường hỗ trợ
        {
         if(r_price_0 < r_price_1 && s_price_0 < r_price_0)// đỉnh sau thấp hơn đỉnh trước, đáy thấp hơn đỉnh sau
           {
            if(r_index_0 < s_index_0 && s_index_0 < r_index_1 && trend_ema34 < 0)//đáy nằm giữa 2 đỉnh
              {
               //rs_result += "\nMô hình lý thuyết DOW dự đoán giá GIẢM.\nĐường EMA cho xu hướng Giảm.";
               return -1;
              }
           }
        }
     }
   return 0;//rs_result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int PA_MarketStructure(int timeFrame, double &R_bar[][2], double &S_bar[][2])
  {
   string rs_result = "";
   int r_index = ArraySize(R_bar)/2;
   int s_index = ArraySize(S_bar)/2;
   int trend_ema34 = GetTrendByEMA(_Symbol, timeFrame, 34, 34);
   double close = iClose(_Symbol, timeFrame, 1);
   double low = iLow(_Symbol, timeFrame, 1);
   double high = iHigh(_Symbol, timeFrame, 1);
   if(r_index > 2 && s_index >= 2)//Kiểm tra Dow tăng
     {
      double high_0    = R_bar[0][1];
      int high_index_0 = (int)R_bar[0][0];//Đỉnh 0
      double high_1    = R_bar[1][1];
      int high_index_1 = (int)R_bar[1][0];//Đỉnh 1
      double low_0     = S_bar[0][1];
      int low_index_0  = (int)S_bar[0][0];//Đáy 0
      double low_1     = S_bar[1][1];
      int low_index_1   = (int)S_bar[1][0];//Đáy 1

      if(high_0 > high_1 && low_0 > low_1 && high_1 > low_0 && low < high_1 && high > high_1 && close > high_1 && close < high_0)//Đỉnh cao hơn đáy và giá close trên đỉnh 1
        {
         if(high_index_0 < low_index_0 && low_index_0 < high_index_1 && high_index_1 < low_index_1)
           {
            //rs_result += "\nMô hình Market Structure dự đoán giá TĂNG.";
            return 1;
           }
        }
      if(high_0 < high_1 && low_0 < low_1 && high_0 > low_1 && low < low_1 && high > low_1 && close < low_1 && close > low_0)
        {
         if(low_index_0 < high_index_0 && high_index_0 < low_index_1 && low_index_1 < high_index_1)
           {
            //rs_result += "\nMô hình Market Structure dự đoán giá GIẢM.";
            return -1;
           }
        }
     }
   return 0;//rs_result;
  }
//+------------------------------------------------------------------+
//| Giá trị trả về:
//| 0: Không có gì
//| >0: Giá test hỗ trợ
//| <0: Giá test kháng cự
//+------------------------------------------------------------------+
int PA_Price_RS(int timeFrame, double &R_bar[][2], double &S_bar[][2])
  {
   string rs_result = "";
   int r_index = ArraySize(R_bar)/2;
   int s_index = ArraySize(S_bar)/2;
   int trend_ema34 = GetTrendByEMA(_Symbol, timeFrame, 34, 34);
   double close_1 = iClose(_Symbol, timeFrame, 1);
   double low_1 = iLow(_Symbol, timeFrame, 1);
   double high_1 = iHigh(_Symbol, timeFrame, 1);

   for(int i = 0; i < r_index; i++)
     {
      double r_price = R_bar[i][1];
      if(r_price > low_1 && r_price < high_1  && R_bar[i][0] > 2)//Giá cắt kháng cự, vị trí cản cách vị trí đang xét từ 3 cây nến trở lên
        {
         int bar_cross_prev = GetBarCrossRS(timeFrame, (double)R_bar[i][1], 2,(int)R_bar[i][0]);//Lấy số lần đường giá cắt qua cản
         if(r_price > close_1 && bar_cross_prev == 0 && R_bar[i][0] >= 5)//Giá Close dưới kháng cự và Giá chưa cắt kháng cự lần nào, vị trí cản cách vị trí đang xét từ 5 cây nến trở lên
           {
            //rs_result += "\nGiá chạm kháng cự và đóng cửa dưới đường kháng cự.";

            return -i;
           }
        }
     }
   for(int i = 0; i < s_index; i++)
     {
      double s_price = S_bar[i][1];
      if(s_price > low_1 && s_price < high_1  && S_bar[i][0] > 2)//Giá cắt hỗ trợ, vị trí cản cách vị trí đang xét từ 3 cây nến trở lên
        {
         int bar_cross_prev = GetBarCrossRS(timeFrame, (double)S_bar[i][1], 2,(int)S_bar[i][0]);//Lấy số lần đường giá cắt qua cản
         if(s_price < close_1 && bar_cross_prev == 0 && S_bar[i][0] >= 5)//Giá Close trên hỗ trợ và Giá chưa cắt hỗ trợ lần nào, vị trí cản cách vị trí đang xét từ 5 cây nến trở lên
           {
            //rs_result += "\nGiá chạm hỗ trợ và đóng cửa trên đường hỗ trợ.";
            return i;
           }
        }
     }
   return 0;//rs_result;
  }

//+------------------------------------------------------------------+
//| Phân tích đường giá theo kháng cự hỗ trợ, hành  vi giá
//+------------------------------------------------------------------+
void PA_TrendLine(int timeFrame, int maxBar = 50)// Hành vi giá với trendline
  {
   string tfStr = ConvertTimeFrametoString(timeFrame);
   double high_prev = iHigh(_Symbol, timeFrame, 1);
   double low_prev = iLow(_Symbol, timeFrame, 1);
   double open_prev = iOpen(_Symbol, timeFrame, 1);
   double close_prev = iClose(_Symbol, timeFrame, 1);
//int localTrend =  GetTrendByEMA(_Symbol,timeFrame,89,34);
//if(localTrend == 0)
//   localTrend =  GetTrendByEMA(_Symbol,timeFrame,89,89);

   for(int i=0; i<ObjectsTotal(); i++)
     {
      double trend_price;
      string name=ObjectName(i);
      //Trendline
      if(((ObjectType(name)==OBJ_TREND) || (ObjectType(name)== OBJ_HLINE)) && StringFind(name, "Open") == -1 && StringFind(name,"Monday") == -1 && StringFind(name,"MS") == -1)
        {
         if(ObjectType(name)==OBJ_TREND)
           {
            trend_price = ObjectGetValueByShift(name, 0);
           }
         else
           {
            trend_price=ObjectGet(name, OBJPROP_PRICE1);
           }
         if(trend_price >= low_prev && trend_price <= high_prev && StringFind(name,"Equillibrium") < 0)//nến trước đó cắt trendline
           {
            if(StringFind(name,"Trendline") != -1 || StringFind(name,"Horizontal") != -1)
               name = "TRENDLINE";
            //RS_PriceTrend_Analysis(timeFrame, close_prev, trend_price, name);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PA_Orderblock(int timeFrame, int maxBar = 50)// Hành vi giá với OrderBlock
  {
   string tfStr = ConvertTimeFrametoString(timeFrame);
   double high_prev = iHigh(_Symbol, timeFrame, 1);
   double low_prev = iLow(_Symbol, timeFrame, 1);
   double open_prev = iOpen(_Symbol, timeFrame, 1);
   double close_prev = iClose(_Symbol, timeFrame, 1);

   for(int i=0; i<ObjectsTotal(); i++)
     {
      string name=ObjectName(i);
      if(ObjectType(name)==OBJ_RECTANGLE)
        {
         double p_top=ObjectGet(name, OBJPROP_PRICE1);
         double p_bottom =ObjectGet(name, OBJPROP_PRICE2);
         double p_medium = (p_bottom + p_top)/2;
         //int price_vs_trend = RS_Price_Trend(timeFrame, p_medium, 2, 10);
         if((low_prev > p_bottom && low_prev < p_top) || (high_prev > p_bottom && high_prev < p_top)) //nến trước đó cắt ob
           {
            /*
                        if(close_prev > p_medium  && price_vs_trend == -1)// nến close trên trendline và xu hướng tăng
                          {
                           Telegram_send("_[" +tfStr +" - " +_Symbol+ "]_ - *ORDER BLOCK - TĂNG* \n- Giá đang test Order Block tại: " + (string)NormPrice(p_top), tele_SR_id);

                          }
                        else
                           if(close_prev < p_medium && price_vs_trend == 1)// nến close dưới trendline và xu hướng giảm
                             {
                              //Mail_send("Duong gia cat Order Block - GIAM", "Pair: " + _Symbol + "\n Gia dang test Order Block tai " + (string)NormalizeDouble(p_bottom,5));
                              Telegram_send("_[" +tfStr +" - " +_Symbol+ "]_ - *ORDER BLOCK - GIẢM* \n- Giá đang test Order Block tại: " + (string)NormPrice(p_top), tele_SR_id);

                             }
                             */
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Swing Failure Pattern: săn stop loss để di chuyển lên/xuống
//| Kiểm tra nến vừa đóng có thuộc swing high hay swing low không
//| Kích thước cây nến phải khoảng 10 pips trở lên
//+------------------------------------------------------------------+
void SwingFailurePattern(int timeFrame)
  {
   string tfStr = ConvertTimeFrametoString(timeFrame);
   int highest_idx = iHighest(_Symbol, timeFrame,MODE_HIGH, 5, 1);
   int lowest_idx = iLowest(_Symbol, timeFrame,MODE_LOW, 5, 1);
   if(highest_idx == 1)// nến số 1 có high cao nhất
     {
      //Kiểm tra râu của nến này có dài không để xác định giá vừa stop hunt
      double low = iLow(_Symbol, timeFrame,highest_idx);
      double high = iHigh(_Symbol, timeFrame,highest_idx);
      double open = iOpen(_Symbol, timeFrame,highest_idx);
      double close = iClose(_Symbol, timeFrame,highest_idx);
      double pips_bar = TinhSoPips(low, high);
      double pips_h = TinhSoPips(high, open > close?open:close);
      if(pips_bar >=15 && pips_h >= 5)
        {
         int highest_idx_prev = iHighest(_Symbol, timeFrame, MODE_HIGH, 10, 2);
         if(highest_idx_prev > 0 && highest_idx_prev <= 5)
           {
            double high_prev = iHigh(_Symbol, timeFrame,highest_idx_prev);
            if(high_prev > close)
              {
               Telegram_send("_[" +tfStr +" - " +_Symbol+ "]_ - *SWING FAILURE PATTERN - DOWNSIDE* \n Giá đã tạo SFP Swing High tại vị trí nến: " + (string)highest_idx + " và nến số: " +(string)highest_idx_prev, tele_PA_id);
              }
           }
        }
     }
   else
      if(lowest_idx == 1)
        {
         //Kiểm tra râu của nến này có dài không để xác định giá vừa stop hunt
         double low = iLow(_Symbol, timeFrame,lowest_idx);
         double high = iHigh(_Symbol, timeFrame,lowest_idx);
         double open = iOpen(_Symbol, timeFrame,lowest_idx);
         double close = iClose(_Symbol, timeFrame,lowest_idx);
         double pips_l = TinhSoPips(low, open < close?open:close);
         double pips_bar = TinhSoPips(low, high);
         if(pips_bar >= 15 && pips_l >= 5)
           {

            int lowest_idx_prev = iLowest(_Symbol, timeFrame, MODE_LOW, 10, 2);
            if(lowest_idx_prev > 0 && lowest_idx_prev <= 5)
              {
               double low_prev = iLow(_Symbol, timeFrame,lowest_idx_prev);
               if(low_prev < close)
                 {
                  Telegram_send("_[" +tfStr +" - " +_Symbol+ "]_ - *SWING FAILURE PATTERN - UPSIDE* \n Giá đã tạo SFP Swing Low tại vị trí nến: " + (string)lowest_idx + " và nến số: " +(string)lowest_idx_prev, tele_PA_id);
                 }
              }
           }
        }
  }
//+------------------------------------------------------------------+
