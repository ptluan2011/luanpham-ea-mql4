//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawTrendLine(string labelName, bool isHLine,
                   datetime startTime, datetime endTime, double price1,
                   double price2, color lineColor, double style = STYLE_SOLID, bool isRay = false, int timeFrame = PERIOD_CURRENT, int width = 1,bool obj_backgound = false)
  {
//if(isDelete)
   ObjectDelete(labelName);
//if(ObjectFind(labelName)==-1)
//  {
   ObjectCreate(labelName, isHLine? OBJ_HLINE : OBJ_TREND, 0, startTime, price1, endTime, price2, 0, 0);
   ObjectSet(labelName, OBJPROP_RAY_RIGHT, isRay);
   ObjectSet(labelName, OBJPROP_COLOR, lineColor);
   ObjectSet(labelName, OBJPROP_STYLE, style);
   ObjectSet(labelName, OBJPROP_WIDTH, width);
   ObjectSet(labelName, OBJPROP_BACK,obj_backgound);
   ObjectSet(labelName, OBJPROP_TIMEFRAMES, ConvertTFtoObj_Period(timeFrame));
// }
  }
/*
void DrawLine(string labelName, bool isHLine, datetime startTime, datetime endTime, double price1,
                   double price2, color lineColor, double style, bool isRay = false, int timeFrame = PERIOD_CURRENT, int width = 1)
  {
   ObjectDelete(labelName);
//if(ObjectFind(labelName)==-1)
//  {
   ObjectCreate(labelName, isHLine? OBJ_HLINE : OBJ_TREND, 0, startTime, price1, endTime, price2, 0, 0);
   ObjectSet(labelName, OBJPROP_RAY_RIGHT, isRay);
   ObjectSet(labelName, OBJPROP_COLOR, lineColor);
   ObjectSet(labelName, OBJPROP_STYLE, style);
   ObjectSet(labelName, OBJPROP_WIDTH, width);
  // ObjectSet(labelName, OBJPROP_BACK,obj_backgound);
   ObjectSet(labelName, OBJPROP_TIMEFRAMES, ConvertTFtoObj_Period(timeFrame));
// }
  }*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawRectangle(string labelName, datetime startTime, datetime endTime, double price1, double price2, color lineColor, double style, int width = 1, int timeFrame = PERIOD_CURRENT)
  {
   /*    ObjectDelete(labelName);
    //if(ObjectFind(labelName)==-1)
    //  {
       ObjectCreate(labelName, OBJ_RECTANGLE, 0, x1, y1, x2, y2, 0, 0);
       ObjectSet(labelName, OBJPROP_COLOR, lineColor);
       ObjectSet(labelName, OBJPROP_STYLE, style);
       ObjectSet(labelName, OBJPROP_WIDTH, width);
       ObjectSet(labelName, OBJPROP_TIMEFRAMES, ConvertTFtoObj_Period(timeFrame));*/
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawRange(string labelName, datetime startTime, datetime endTime, double low, double high, color lineColor, double style)
  {
   double m_mid = (high + low)/2;
   DrawTrendLine(labelName +"_High", false, startTime, endTime, high, high, lineColor, style,false,0,1,true);
   DrawTrendLine(labelName + "_Equillibrium", false, startTime, endTime, m_mid, m_mid, lineColor, STYLE_DASHDOT,false,0,1,true);
   DrawTrendLine(labelName+ "_Low", false, startTime, endTime, low, low, lineColor, style,false,0,1,true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawArrow(string labelName, double price, datetime time, bool bullish, int bar_index = 0, int timeFrame = PERIOD_CURRENT)
  {

   double point_compat = 30;
   if(Digits == 3 || Digits == 5)
      point_compat = 50;
//else
//    point_compat = 20;

   if(bullish == false)
      price = price + (Point * point_compat);
   if(bullish == true)
      price = price - (Point * point_compat);


   labelName +="_"+ (bullish?"up":"down") /*+"_" + (string)bar_index*/;
   ObjectDelete(labelName);
   ObjectCreate(labelName,OBJ_ARROW_CHECK,0,time,price);
   ObjectSet(labelName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(labelName, OBJPROP_ARROWCODE, bullish?SYMBOL_ARROWUP:SYMBOL_ARROWDOWN);
   ObjectSet(labelName, OBJPROP_COLOR, bullish? clrBlue : clrRed);
   ObjectSet(labelName, OBJPROP_TIMEFRAMES, ConvertTFtoObj_Period(timeFrame));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawArrowAndText(string arrowName, double price, bool isBuy, int bar_index = 0, int timeFrame = PERIOD_CURRENT, string lblText="")
  {
   return;
   arrowName += "_" + (string)timeFrame;
   string lblName = lblText + "_" + (string)timeFrame;
//DeleteObjects(arrowName);
   double txt_price = price;
   double point_compat = 30;
   if(Digits == 3 || Digits == 5)
      point_compat = 50;
   if(isBuy == false)
     {
      price = price + (Point * point_compat);
      txt_price = price + (Point * point_compat);
     }
   if(isBuy == true)
     {
      price = price - (Point * point_compat);
      txt_price = price - (Point * point_compat);
     }
   arrowName += "_"+ (isBuy?"up":"down");
   lblName += "_"+ (isBuy?"up":"down");
   ObjectDelete(arrowName);
   ObjectDelete(lblName);

   datetime time = iTime(_Symbol, timeFrame, bar_index);

   ObjectCreate(arrowName,OBJ_ARROW,0,time,price);
   ObjectSet(arrowName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(NULL,arrowName, OBJPROP_ARROWCODE, isBuy?233:234);
   ObjectSet(arrowName, OBJPROP_COLOR, isBuy? clrBlue : clrRed);
   ObjectSet(arrowName, OBJPROP_TIMEFRAMES, ConvertTFtoObj_Period(timeFrame));

   ObjectCreate(lblName, OBJ_TEXT, 0, time, txt_price);
   ObjectSetText(lblName, lblText, 8, "Tahoma", isBuy? clrBlue : clrRed);
//ObjectSet(label, OBJPROP_ANGLE, 90);
//ObjectSet(lblName, OBJPROP_BACK, true);
   ObjectSet(lblName, OBJPROP_TIMEFRAMES, ConvertTFtoObj_Period(timeFrame));

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TextONchart(int timeFrame, /*string &text_arr[],*/ string signal_name = "txt_system_ema_")
  {
   string tfStr = ConvertTimeFrametoString(timeFrame);
   int text_arr_size = ArraySize(text_arr);
//ObjectsDeleteAll(0,"txt_singal_*");
   if(text_arr_size == 0)
      return;
   int z=0;
   int k=25; // Shifts the whole block of text up or down
   if(timeFrame == 5)
      k=25;
   if(timeFrame == 15)
      k=25*4;
   if(timeFrame == 30)
      k=25*8;
   if(timeFrame == 60)
      k=25*12;
   if(timeFrame == 240)
      k=25*16;
   string ChartText = "";
   ChartText = signal_name + DoubleToStr(z, 0);
   ObjectCreate(ChartText, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(ChartText, "------------------------["+tfStr+"] --------------------", 8, "Tahoma", Red);
   ObjectSet(ChartText, OBJPROP_CORNER, 1);   // controls the corner the text is put into 0=top left 1=topright 2=bottom left 3=bottom right
   ObjectSet(ChartText, OBJPROP_XDISTANCE, 8);//controls distance text block is from margin
   ObjectSet(ChartText, OBJPROP_YDISTANCE, k);
   z++;
   k=k+15;// bigger the number the larger the gap between the lines of text
   for(int i = 0; i < text_arr_size; i++)
     {
      //printf(text_arr[i]);
      ChartText = signal_name + DoubleToStr(z, 0);
      ObjectCreate(ChartText, OBJ_LABEL, 0, 0, 0);
      ObjectSetText(ChartText, text_arr[i]/*+" - ["+tfStr+"]"*/, 8, "Tahoma", Blue);
      ObjectSet(ChartText, OBJPROP_CORNER, 1);   // controls the corner the text is put into 0=top left 1=topright 2=bottom left 3=bottom right
      ObjectSet(ChartText, OBJPROP_XDISTANCE, 8);//controls distance text block is from margin
      ObjectSet(ChartText, OBJPROP_YDISTANCE, k);
      z++;
      k=k+15;// bigger the number the larger the gap between the lines of text
     }
   ChartText = signal_name + DoubleToStr(z, 0);
   ObjectCreate(ChartText, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(ChartText, "----------------------------------------------------", 8, "Tahoma", Red);
   ObjectSet(ChartText, OBJPROP_CORNER, 1);   // controls the corner the text is put into 0=top left 1=topright 2=bottom left 3=bottom right
   ObjectSet(ChartText, OBJPROP_XDISTANCE, 8);//controls distance text block is from margin
   ObjectSet(ChartText, OBJPROP_YDISTANCE, k);
   /*
      textcomment[2]="Magic Number = 12345";
      textcomment[3]="Lot size sequence = "+DoubleToStr(OrderLots(),2);
      string signal;
      if(Close[0]>Open[1])
         signal="UP";
      if(Close[0]<Open[1])
         signal="DOWN";
      textcomment[4]="Trading Signal = "+signal;
      textcomment[5]="Price = "+DoubleToStr(Close[0],Digits);
      textcomment[6]="Profit = "+DoubleToStr(OrderProfit(),2);
      textcomment[7]="---------------------------------------";
      */
//   PlaySound("news.wav");
   /* while(z<8)  //z must be equal to or larger than the textcomment[8] in this case 8 for 8 lines of test
      {
       if(StringLen(textcomment[z]) < 1)
         {
          z++;

         }
       else
         {
          color textcol;
          textcol=Gray; //Basic color for all lines unless specified otherwise in lines of code below

          string font;
          font = "Tahoma";//Basic font for all lines unless specified otherwise in lines of code below

          int size;
          size = 8; //Default text size if not specified otherwise in lines of code

          if(z==0)
            {
             textcol=Gray;   // z = 1 is color/size/font controls for line 1
             size=12;
             font = "Arial Bold";
            }
          if(z==1)
            {
             textcol=Silver;  // z = 2 is control of line 2 and so on down through the lines
            }
          // z = 3 is missing here so the default color size etc takes control of the 3rd line of text in this case font=Tahoma textcolor=Gray
          if(z==4)
            {
             textcol=Gold;
            }

          color sig;
          if(Close[0]>=Open[1])
             sig=Lime;
          if(Close[0]< Open[1])
             sig=Red;
          if(z==5)
            {
             textcol=sig;
             size=9;
             font = "Times";
            }

          if(z==5 || z==6)
            {
             size=9;
            }

          color ColorPrice;
          double ma1 = iMA(NULL,1,1,0,0,0,1);
          if(Close[0]<ma1)
            {
             ColorPrice= DarkOrange;
            }
          if(Close[0]>ma1)
            {
             ColorPrice=ForestGreen;
            }
          if(Close[0]==ma1)
            {
             ColorPrice=Gray;
            }
          ma1=Close[0];

          if(z==6)
            {
             textcol=ColorPrice;
            }

          if(z==7)
            {
             textcol=Silver;
            }

          string ChartText = "txt_singal_" + DoubleToStr(z, 0);
          ObjectCreate(ChartText, OBJ_LABEL, 0, 0, 0);
          ObjectSetText(ChartText, textcomment[z], size, font, textcol);
          ObjectSet(ChartText, OBJPROP_CORNER, 1);   // controls the corner the text is put into 0=top left 1=topright 2=bottom left 3=bottom right
          ObjectSet(ChartText, OBJPROP_XDISTANCE, 8);//controls distance text block is from margin
          ObjectSet(ChartText, OBJPROP_YDISTANCE, k);
          z++;
          k=k+15;// bigger the number the larger the gap between the lines of text
         }
      }*/
//return(0);
  }
//+------------------------------------------------------------------+
void DrawTrendPrice(string signal_text_0, string signal_text_1, string signal_text_2)
  {
  string signal_name = "txt_trend_price"; 
  
   ObjectCreate("txt_trend_price_0", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("txt_trend_price_0", signal_text_0, 8, "Arial Bold", Green);
   ObjectSet("txt_trend_price_0", OBJPROP_CORNER, 2);   // controls the corner the text is put into 0=top left 1=topright 2=bottom left 3=bottom right
   ObjectSet("txt_trend_price_0", OBJPROP_XDISTANCE, 8);//controls distance text block is from margin
   ObjectSet("txt_trend_price_0", OBJPROP_YDISTANCE, 35);

   ObjectCreate("txt_trend_price_1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("txt_trend_price_1", signal_text_1, 8, "Arial Bold", Green);
   ObjectSet("txt_trend_price_1", OBJPROP_CORNER, 2);   // controls the corner the text is put into 0=top left 1=topright 2=bottom left 3=bottom right
   ObjectSet("txt_trend_price_1", OBJPROP_XDISTANCE, 8);//controls distance text block is from margin
   ObjectSet("txt_trend_price_1", OBJPROP_YDISTANCE, 22);
   
   ObjectCreate("txt_trend_price_2", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("txt_trend_price_2", signal_text_2, 8, "Arial Bold", Green);
   ObjectSet("txt_trend_price_2", OBJPROP_CORNER, 2);   // controls the corner the text is put into 0=top left 1=topright 2=bottom left 3=bottom right
   ObjectSet("txt_trend_price_2", OBJPROP_XDISTANCE, 8);//controls distance text block is from margin
   ObjectSet("txt_trend_price_2", OBJPROP_YDISTANCE, 10);
  }