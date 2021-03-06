//+------------------------------------------------------------------+
//|                                                    InsideBar.mqh |
//|                                       Copyright 2019, Luan Pham. |
//|                                     http://www.phamthanhluan.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Luan Pham."
#property link      "http://www.phamthanhluan.com"
#property strict

int KiemTraInsideBar(int timeFrame, int maxBar = 3)//Giá trị trả về(n): n = -1: không có insidebar | n >= 0: Giá trị insidebar tại nến n  
{
   if(maxBar <=1) return -1;
   
   for (int i = 1; i < maxBar; i++)
   { 
       if (iLow(_Symbol,timeFrame,i) > iLow(_Symbol,timeFrame,i+1) && 
            iHigh(_Symbol,timeFrame,i) < iHigh(_Symbol,timeFrame,i+1) && 
            iHigh(_Symbol,timeFrame,i)-iLow(_Symbol,timeFrame,i)>_Point/2)
         {
            return i;
         }
      }  
   return -1;  
}


//Kiểm tra sự xuất hiện của nến Inside Bar của M15 -> H4
string KiemTraInsideBarAllTimeFrame(int barNum = 3)
{
   //M15
   string insidebar_signal = "";
   string str_Ema_Result = "";
   string str_Vgt_Result = "";
   //if(NewBar(PERIOD_M15))
   //{
      int ins_15 = KiemTraInsideBar(PERIOD_M15,barNum);
      if(ins_15 >= 0)//Xuất hiện nến Inside bar khung giờ này
      {
         insidebar_signal += "\n["+Symbol()+"] - Co tin hieu Inside Bar trong khung M15 tai vi tri nen thu " + (string)ins_15;
         string str_ema = KiemTraDuongGiaCatDuongEMA(PERIOD_M15,610,0,barNum);
         str_ema += KiemTraDuongGiaCatDuongEMA(PERIOD_M15,987,0,barNum);
         if(str_ema != "")
         {
            str_Ema_Result += insidebar_signal + str_ema;
         }
         string str_vtg = "";
         for(int i = 0; i <ArrayRange(vgt_M15,0); i++)
         {
            if(vgt_M15[i][0]!=0 && vgt_M15[i][2] != 0)//Có tín hiệu vùng giá trị EMA
            {
               str_vtg += "\n - Co tin hieu vung gia tri EMA "+ (string)vgt_M15[i][0] +" khung M15: " + (string)(vgt_M15[i][2] == 1?"TANG":"GIAM");
               str_vtg += "\n + Xu huong tai nen thu: " +(string)vgt_M15[i][1];
            }
         }
         if(str_vtg != "")
         {
            str_Vgt_Result+= insidebar_signal + str_vtg;
         }
      }

   //}
   //M30
   //if(NewBar(PERIOD_M30))
   //{
      int ins_30 = KiemTraInsideBar(PERIOD_M30,barNum);
      if(ins_30 >= 0)//Xuất hiện nến Inside bar khung giờ này
      {
         insidebar_signal+= "\n["+Symbol()+"] - Co tin hieu Inside Bar trong khung M30 tai vi tri nen thu " + (string)ins_30;
         string str_ema = KiemTraDuongGiaCatDuongEMA(PERIOD_M30,610,0,barNum);
         str_ema += KiemTraDuongGiaCatDuongEMA(PERIOD_M30,987,0,barNum);
         if(str_ema != "")
         {
            str_Ema_Result += insidebar_signal + str_ema;
         }
         string str_vtg = "";
         for(int i = 0; i <ArrayRange(vgt_M30,0); i++)
         {
            if(vgt_M30[i][0]!=0 && vgt_M30[i][2] != 0)//Có tín hiệu vùng giá trị EMA
            {
               str_vtg += "\n - Co tin hieu vung gia tri EMA "+ (string)vgt_M30[i][0] +" khung M30: " + (string)(vgt_M30[i][2] == 1?"TANG":"GIAM");
               str_vtg += "\n + Xu huong tai nen thu: " +(string)vgt_M30[i][1];
            }
         }
         if(str_vtg != "")
         {
            str_Vgt_Result+= insidebar_signal + str_vtg;
         }
      }
  // }   
   //H1
   //if(NewBar(PERIOD_H1))
   //{
      int ins_60 = KiemTraInsideBar(PERIOD_H1,barNum);
      if(ins_60 >= 0)//Xuất hiện nến Inside bar khung giờ này
      {
         insidebar_signal+= "\n["+Symbol()+"] - Co tin hieu Inside Bar trong khung H1 tai vi tri nen thu " + (string)ins_60;
         string str_ema = KiemTraDuongGiaCatDuongEMA(PERIOD_H1,610,0,barNum);
         str_ema += KiemTraDuongGiaCatDuongEMA(PERIOD_H1,987,0,barNum);
         if(str_ema != "")
         {
            str_Ema_Result += insidebar_signal + str_ema;
         }
         string str_vtg = "";
         for(int i = 0; i <ArrayRange(vgt_H1,0); i++)
         {
            if(vgt_H1[i][0]!=0 && vgt_H1[i][2] != 0)//Có tín hiệu vùng giá trị EMA
            {
               str_vtg += "\n - Co tin hieu vung gia tri EMA "+ (string)vgt_H1[i][0] +" khung M15: " + (string)(vgt_H1[i][2] == 1?"TANG":"GIAM");
               str_vtg += "\n + Xu huong tai nen thu: " +(string)vgt_H1[i][1];
            }
         }
         if(str_vtg != "")
         {
            str_Vgt_Result+= insidebar_signal + str_vtg;
         }
      }
   //}   
   //H4
   //if(NewBar(PERIOD_H4))
   //{
      int ins_240 = KiemTraInsideBar(PERIOD_H4,barNum);
      if(ins_240 >= 0)//Xuất hiện nến Inside bar khung giờ này
      {
         insidebar_signal+= "\n["+Symbol()+"] - Co tin hieu Inside Bar trong khung H4 tai vi tri nen thu " + (string)ins_240;
         string str_ema = KiemTraDuongGiaCatDuongEMA(PERIOD_H4,610,0,barNum);
         str_ema += KiemTraDuongGiaCatDuongEMA(PERIOD_H4,987,0,barNum);
         if(str_ema != "")
         {
            str_Ema_Result += insidebar_signal + str_ema;
         }
         string str_vtg = "";
         for(int i = 0; i <ArrayRange(vgt_H4,0); i++)
         {
            if(vgt_H4[i][0]!=0 && vgt_H4[i][2] != 0)//Có tín hiệu vùng giá trị EMA
            {
               str_vtg += "\n - Co tin hieu vung gia tri EMA "+ (string)vgt_H4[i][0] +" khung M15: " + (string)(vgt_H4[i][2] == 1?"TANG":"GIAM");
               str_vtg += "\n + Xu huong tai nen thu: " +(string)vgt_H4[i][1];
            }
         }
         if(str_vtg != "")
         {
            str_Vgt_Result+= insidebar_signal + str_vtg;
         }
      }      
   //}
   if(str_Ema_Result != "" && str_Ema_Result != ema610_987_InsideBar)
   {
      //ema610_987_InsideBar = str_Ema_Result;
   }
   if(str_Vgt_Result != "" && str_Vgt_Result != vgt_InsideBar)
   {
      vgt_InsideBar = str_Vgt_Result;
     // SendNotification(vgt_InsideBar);
   }
   return insidebar_signal;
   //Kiểm tra với vùng giá trị
   
}
string InsideBarKetHopVGT(int barNum = 2)
{
  //M15
   string insidebar_signal = "";
   string str_Vgt_Result = "";
   //if(NewBar(PERIOD_M15))
   //{
      int ins_15 = KiemTraInsideBar(PERIOD_M15,barNum);
      if(ins_15 >= 0)//Xuất hiện nến Inside bar khung giờ này
      {
         string str_vtg = "";
         for(int i = 0; i <ArrayRange(vgt_M15,0); i++)
         {
            if(vgt_M15[i][0]!=0 && vgt_M15[i][2] != 0)//Có tín hiệu vùng giá trị EMA
            {
               str_vtg += "\n["+Symbol()+"] - Co tin hieu Inside Bar trong khung M15 tai vi tri nen thu " + (string)ins_15;
               str_vtg += "\n - Co tin hieu vung gia tri EMA "+ (string)vgt_M15[i][0] +" khung M15: " + (string)(vgt_M15[i][2] == 1?"TANG":"GIAM");
               str_vtg += "\n + Xu huong tai nen thu: " +(string)vgt_M15[i][1];
            }
         }
         if(str_vtg != "")
         {
            str_Vgt_Result += str_vtg;
         }
      }
   //}
   //M30
   //if(NewBar(PERIOD_M30))
   //{
      int ins_30 = KiemTraInsideBar(PERIOD_M30,barNum);
      if(ins_30 >= 0)//Xuất hiện nến Inside bar khung giờ này
      {
         string str_vtg = "";
         for(int i = 0; i <ArrayRange(vgt_M30,0); i++)
         {
            if(vgt_M30[i][0]!=0 && vgt_M30[i][2] != 0)//Có tín hiệu vùng giá trị EMA
            {
               str_vtg += "\n["+Symbol()+"] - Co tin hieu Inside Bar trong khung M30 tai vi tri nen thu " + (string)ins_30;
               str_vtg += "\n - Co tin hieu vung gia tri EMA "+ (string)vgt_M30[i][0] +" khung M30: " + (string)(vgt_M30[i][2] == 1?"TANG":"GIAM");
               str_vtg += "\n + Xu huong tai nen thu: " +(string)vgt_M30[i][1];
            }
         }
         if(str_vtg != "")
         {
            str_Vgt_Result += str_vtg;
         }
      }
  // }   
   //H1
   //if(NewBar(PERIOD_H1))
   //{
      int ins_60 = KiemTraInsideBar(PERIOD_H1,barNum);
      if(ins_60 >= 0)//Xuất hiện nến Inside bar khung giờ này
      {
         string str_vtg = "";
         for(int i = 0; i <ArrayRange(vgt_H1,0); i++)
         {
            if(vgt_H1[i][0]!=0 && vgt_H1[i][2] != 0)//Có tín hiệu vùng giá trị EMA
            {
               str_vtg += "\n["+Symbol()+"] - Co tin hieu Inside Bar trong khung H1 tai vi tri nen thu " + (string)ins_60;
               str_vtg += "\n - Co tin hieu vung gia tri EMA "+ (string)vgt_H1[i][0] +" khung M15: " + (string)(vgt_H1[i][2] == 1?"TANG":"GIAM");
               str_vtg += "\n + Xu huong tai nen thu: " +(string)vgt_H1[i][1];
            }
         }
         if(str_vtg != "")
         {
            str_Vgt_Result += str_vtg;
         }
      }
   //}   
   //H4
   //if(NewBar(PERIOD_H4))
   //{
      int ins_240 = KiemTraInsideBar(PERIOD_H4,barNum);
      if(ins_240 >= 0)//Xuất hiện nến Inside bar khung giờ này
      {
         string str_vtg = "";
         for(int i = 0; i <ArrayRange(vgt_H4,0); i++)
         {
            if(vgt_H4[i][0]!=0 && vgt_H4[i][2] != 0)//Có tín hiệu vùng giá trị EMA
            {
               str_vtg += "\n["+Symbol()+"] - Co tin hieu Inside Bar trong khung H4 tai vi tri nen thu " + (string)ins_240;
               str_vtg += "\n - Co tin hieu vung gia tri EMA "+ (string)vgt_H4[i][0] +" khung M15: " + (string)(vgt_H4[i][2] == 1?"TANG":"GIAM");
               str_vtg += "\n + Xu huong tai nen thu: " +(string)vgt_H4[i][1];
            }
         }
         if(str_vtg != "")
         {
            str_Vgt_Result += str_vtg;
         }
      }
   return str_Vgt_Result;
}