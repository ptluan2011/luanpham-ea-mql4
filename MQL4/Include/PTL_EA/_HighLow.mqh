//+------------------------------------------------------------------+
//|                                                     _HighLow.mqh |
//|                                                        Luan Pham |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luan Pham"
#property link      ""
#property strict
//+------------------------------------------------------------------+
/*
void FindHighLow(int timeFrame,int &HL_bar[],bool &end_is_low, int maxBar = 200)
  {
   ArrayFree(HL_bar);
   ArrayResize(HL_bar, 1000);
//int HL_bar[1000];//Mảng để lưu vị trí nến cao nhất/ thấp nhất
   int HL_index = 0; //Lưu số lượng nến cao/thấp
   double high_tmp=0, low_tmp=0;

   int hl_pips_dis = 10;//khoảng cách tối thiểu giữa đỉnh và đáy gần nhất là 5 pips, nếu ở timeFrame lớn thì 10 pips/15 pips/20 pips
   if(timeFrame == 60)
      hl_pips_dis = 10;
   if(timeFrame >= 240)
      hl_pips_dis = 20;
   if(StringFind(_Symbol,"XAUUSD") != -1)
      hl_pips_dis = hl_pips_dis*3;

   bool is_Find_Low = false;
   int bar_high_first = iHighest(_Symbol, timeFrame, MODE_CLOSE, 10, maxBar - 10);//Lấy đỉnh đầu tiên
   int bar_low_first = iLowest(_Symbol, timeFrame, MODE_CLOSE, 10, maxBar - 10);//Lấy đáy đầu tiên
   if(bar_low_first > bar_high_first)//low xa hơn high => bắt đầu duyệt với vị trí đầu tiên là low
     {
      low_tmp = iClose(_Symbol, timeFrame, bar_low_first);
      high_tmp = low_tmp;// iClose(_Symbol, timeFrame, bar_high_first);
      HL_bar[HL_index++] = bar_low_first;
      maxBar = bar_low_first-1;//gán lại vị trí để tìm high tiếp theo
      is_Find_Low = false;
     }
   else
      if(bar_low_first < bar_high_first)//low xa hơn high => bắt đầu duyệt với vị trí đầu tiên là low
        {
         high_tmp = iClose(_Symbol, timeFrame, bar_high_first);
         low_tmp = high_tmp;// iClose(_Symbol, timeFrame, bar_low_first);

         HL_bar[HL_index++] = bar_high_first;
         maxBar = bar_high_first-1;//gán lại vị trí để tiếp tục tìm low tiếp theo
         is_Find_Low = true;
        }

   int high_idx_tmp = 0, low_idx_tmp = 0;
   while(maxBar > 0)
     {
      double open = iOpen(_Symbol, timeFrame, maxBar);
      double close = iClose(_Symbol, timeFrame, maxBar);
      double wick_high = iHigh(_Symbol, timeFrame, maxBar);//Lấy râu nến phía trên
      double wick_low = iLow(_Symbol, timeFrame, maxBar);//Lấy râu nến phía dưới
      double high =  close > open ? close : open;//Lấy giá cao
      double low =  close < open ? close : open;//Lấy giá thấp
      if(TinhSoPips(wick_high, high) <= 1)//Nếu râu nến dài không quá 1 pip thì lấy râu luôn
         high = wick_high;
      if(TinhSoPips(wick_low, low) <= 1)//Nếu râu nến dài không quá 1 pip thì lấy râu luôn
         low = wick_low;

      if(is_Find_Low == false)//Tìm high
        {
         //double pips_hl = TinhSoPips(low_prev, high);// Số pip giữa low và high đang tìm
         if(high > high_tmp)// nếu high lớn hơn high cũ thì gán bình thường vào các giá trị tạm thời
           {
            high_idx_tmp = maxBar;
            high_tmp = high;
            //idx = 0;
           }
         else
            if(TinhSoPips(high_tmp, low) >= hl_pips_dis)// khoảng cách pip tối thiểu của nến này với low thì giá trị high trước chính là high, cập nhật lại các giá trị low tạm thời
              {
               low_idx_tmp = maxBar;
               low_tmp = low;
               //high_prev = high;
               HL_bar[HL_index++] = high_idx_tmp;
               is_Find_Low = true;
              }
            else
               if(low < low_tmp)//tìm chưa ra high nhưng phát hiện low thấp hơn thì cập nhật lại low prev, nhảy high lại low này để tiếp tục tìm high
                 {
                  low_tmp = low;
                  high_tmp = low;
                  low_idx_tmp = maxBar;
                  high_idx_tmp = maxBar;
                  HL_bar[HL_index] = maxBar;
                 }
        }
      else //Tìm low
        {
         if(low < low_tmp)// nếu low nhỏ hơn low cũ thì gán bình thường
           {
            low_idx_tmp = maxBar;
            low_tmp = low;
           }
         else
            if(TinhSoPips(low_tmp, high) >= hl_pips_dis)// khoảng cách pip tối thiểu của nến này với high thì giá trị high trước chính là low
              {
               high_idx_tmp = maxBar;
               high_tmp = high;
               //high_prev = high;
               HL_bar[HL_index++] = low_idx_tmp;
               is_Find_Low = false;
              }
            else
               if(high > high_tmp)//tìm chưa ra low nhưng phát hiện high cao hơn thì cập nhật lại high prev, nhảy low lại high này để tiếp tục tìm low
                 {
                  low_tmp = high;
                  high_tmp = high;
                  low_idx_tmp = maxBar;
                  high_idx_tmp = maxBar;
                  HL_bar[HL_index] = maxBar;
                 }
        }
      maxBar--;
     }
   end_is_low = !is_Find_Low;
   ArrayResize(HL_bar, HL_index);

  }*/
/*
//+------------------------------------------------------------------+
//| So nến 1 với nến 2, nếu nến 1 thỏa điều kiện cao hơn hoặc thấp hơn thì trả về true, ngược lại nến 1 không thỏa điều kiện thì trả về false
//+------------------------------------------------------------------+
bool RS_CheckBar(int bar_1, int bar_2, bool &isReplaceBar,int timeFrame, bool isHigher = true)
  {
   double open_1 = iOpen(_Symbol, timeFrame, bar_1);
   double close_1 = iClose(_Symbol, timeFrame, bar_1);
   double wick_high_1 = iHigh(_Symbol, timeFrame, bar_1);//Lấy râu nến phía trên
   double wick_low_1 = iLow(_Symbol, timeFrame, bar_1);//Lấy râu nến phía dưới
   double high_1 =  close_1 > open_1 ? close_1 : open_1;//Lấy giá cao
   double low_1 =  close_1 < open_1 ? close_1 : open_1;//Lấy giá thấp

   double open_2 = iOpen(_Symbol, timeFrame, bar_2);
   double close_2 = iClose(_Symbol, timeFrame, bar_2);
   double wick_high_2 = iHigh(_Symbol, timeFrame, bar_2);//Lấy râu nến phía trên
   double wick_low_2 = iLow(_Symbol, timeFrame, bar_2);//Lấy râu nến phía dưới
   double high_2 =  close_2 > open_2 ? close_2 : open_2;//Lấy giá cao
   double low_2 =  close_2 < open_2 ? close_2 : open_2;//Lấy giá thấp

   if(isHigher == true)// Lấy nến cao hơn
     {
      double pips = TinhSoPips(high_1, high_2);
      if(pips <= 10 && high_1 > high_2)
         isReplaceBar = true;
      return true;
     }
   if(isHigher == false)// Lấy nến thấp hơn
     {
      double pips = TinhSoPips(low_1, low_2);
      if(pips<=10 && low_1 < low_2)
         isReplaceBar = true;
      return true;
     }
   return false;
  }
  */
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
