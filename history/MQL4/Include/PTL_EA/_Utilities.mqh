//+------------------------------------------------------------------+
//|                                                Ptl_Exception.mqh |
//|                                       Copyright 2019, Luan Pham. |
//|                                     http://www.phamthanhluan.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Luan Pham."
#property link      "http://www.phamthanhluan.com"
#property strict

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime _tms_last_time_messaged;

datetime ArrayTime_M1[2], LastTime_M1;
datetime ArrayTime_M5[2], LastTime_M5;
datetime ArrayTime_M15[2], LastTime_M15;
datetime ArrayTime_M30[2], LastTime_M30;
datetime ArrayTime_H1[2], LastTime_H1;
datetime ArrayTime_H4[2], LastTime_H4;
datetime ArrayTime_D1[2], LastTime_D1;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*long Tele_Token_Pair()
  {
   if(StringFind(_Symbol, "XAUUSD") != -1)
      return (1001164224121);
   if(StringFind(_Symbol, "USDCHF") != -1)
      return (1001430193729);
   if(StringFind(_Symbol, "USDCAD") != -1)
      return (1001444367975);
   if(StringFind(_Symbol, "USDJPY") != -1)
      return (1001379164153);
   if(StringFind(_Symbol, "EURUSD") != -1)
      return (1001442613533);
   if(StringFind(_Symbol, "GBPUSD") != -1)
      return (1001192502979);
   if(StringFind(_Symbol, "NZDUSD") != -1)
      return (1001412248139);
   if(StringFind(_Symbol, "AUDUSD") != -1)
      return (1001358167406);
   if(StringFind(_Symbol, "GBPJPY") != -1)
      return (1001099875552);
   if(StringFind(_Symbol, "EURJPY") != -1)
      return (1001242373999);
   return(-1);
  }*/
long GetTeleTokenPair()
  {
   /*if(StringFind(_Symbol, "XAUUSD") != -1)
      return (-1001461484876);
   if(StringFind(_Symbol, "USDCHF") != -1)
      return (-1001468171872);
   if(StringFind(_Symbol, "USDCAD") != -1)
      return (-1001258113339);
   if(StringFind(_Symbol, "USDJPY") != -1)
      return (-1001140974043);
   if(StringFind(_Symbol, "EURUSD") != -1)
      return (-1001486443151);
   if(StringFind(_Symbol, "GBPUSD") != -1)
      return (-1001413665612);
   if(StringFind(_Symbol, "NZDUSD") != -1)
      return (-1001423214038);
   if(StringFind(_Symbol, "AUDUSD") != -1)
      return (-1001387399788);
   if(StringFind(_Symbol, "GBPJPY") != -1)
      return (-1001466124256);
   if(StringFind(_Symbol, "EURJPY") != -1)
      return (-1001191265790);
   if(StringFind(_Symbol,".fs") != -1)
      return (-1001451604118);
   return(-1001207582460);
   */
   if(StringFind(_Symbol, ".fs")>=0)
      return (-1001451604118);
   else
      if(StringFind(_Symbol, "XAUUSD") != -1)
         return (-1001461484876);
      else
         if(StringFind(_Symbol, "GBP") == 0)
           {
            return (-1001413665612);
           }
         else
            if(StringFind(_Symbol, "EUR") == 0)
              {
               return (-1001486443151);
              }
            else
               if(StringFind(_Symbol, "USD") == 0)
                 {
                  return (-1001486443151);
                 }
   return(-1001486443151);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Telegram_send(string message, long token=1001312323799)
  {
   return false;
   if(TimeHour(TimeLocal()) < 6 || TimeHour(TimeLocal()) >= 23)
     {
      return false;
     }
   long tele_token = token;// Tele_Token_Pair();
   if(tele_token >0)
     {
      tele_token = token;
     }
   const string url = "https://api.telegram.org/bot927322228:AAFxIy4Tw_rfZr6LEoyO5tocsMNBxwNXIHI/sendMessage";
   string response,headers;
   int result;
   char post[],res[];

   if(IsTesting() || IsOptimization())
      return true;
   if(_tms_last_time_messaged == Time[0])
      return false; // do not send twice at the same candle; ?chat_id=-1001312323799:ee747fb9

   string spost = StringFormat("chat_id=%s&text=%s&parse_mode=markdown", tele_token, message);

   ArrayResize(post,StringToCharArray(spost,post,0,WHOLE_ARRAY, CP_UTF8)-1);

   result = WebRequest("POST",url,"",NULL,3000,post,ArraySize(post),res,headers);
   _tms_last_time_messaged = Time[0];

   if(result==-1)
     {
      if(GetLastError() == 4060)
        {
         printf("Telegram_send() | Add the address %s in the list of allowed URLs on tab 'Expert Advisors'",url);
        }
      else
        {
         printf("Telegram_send() | webrequest filed - error № %i " +message, GetLastError());
        }
      return false;
     }
   else
     {
      response = CharArrayToString(res,0,WHOLE_ARRAY);

      if(StringFind(response,"\"ok\":true")==-1)
        {
         string data_err = "Telegram_send() return an error - " + response;
         data_err+= "Data Send: " + message;
         printf(data_err);
         return false;
        }
     }
   Sleep(1000); //to prevent sending more than 1 message per seccond
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Mail_send(int timeFrame = PERIOD_CURRENT, string Sub="", string content="")
  {
   if(content == "")
      return;
   if(TimeHour(TimeLocal())>=5 && TimeHour(TimeLocal())<=24)
     {
      //SendMail("["+ConvertTimeFrametoString(timeFrame)+"-" +Symbol()+"] ["+GetTimeLocal()+"]-"+Sub, content/*+"\n["+GetTimeLocal()+"] - "*/);
      SendMail("["+ConvertTimeFrametoString(timeFrame)+"-" +Symbol()+"] - "+Sub, content/*+"\n["+GetTimeLocal()+"] - "*/);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetPercentage(double value, double totalValues)
  {
   return (value/totalValues)*100;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetTimeLocal()
  {
   string MonthDay = IntegerToString(TimeDay(TimeLocal())) + "/" + IntegerToString(TimeMonth(TimeLocal())) /*+ "/" + IntegerToString(TimeYear(TimeLocal()))*/;
   string HourMinute = IntegerToString(TimeHour(TimeLocal())) + ":" + IntegerToString(TimeMinute(TimeLocal())) /*+ ":" + IntegerToString(TimeSeconds(TimeLocal()))*/;
   string strRet = MonthDay + " | " + HourMinute ;
   return(strRet);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double NormPrice(double price)
  {
   double tickSize=MarketInfo(Symbol(),MODE_TICKSIZE);
   price=NormalizeDouble(MathRound(price/tickSize)*tickSize,Digits);
   return price;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ConvertTimeFrametoString(int n)
  {
   if(n==0)
      n=Period();
   switch(n)
     {
      case PERIOD_M1:
         return ("M1");
      case PERIOD_M5:
         return ("M5");
      case PERIOD_M15:
         return ("M15");
      case PERIOD_M30:
         return ("M30");
      case PERIOD_H1:
         return ("H1");
      case PERIOD_H4:
         return ("H4");
      case PERIOD_D1:
         return ("D1");
      case PERIOD_W1:
         return ("W1");
      case PERIOD_MN1:
         return ("MN1");
     }
   return("TF?");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ConvertTFtoObj_Period(int n)
  {
   if(n==0)
      return OBJ_ALL_PERIODS;
   switch(n)
     {
      case PERIOD_M1:
         return OBJ_PERIOD_M1;
      case PERIOD_M5:
         return OBJ_PERIOD_M5;
      case PERIOD_M15:
         return OBJ_PERIOD_M15;
      case PERIOD_M30:
         return OBJ_PERIOD_M30;
      case PERIOD_H1:
         return OBJ_PERIOD_H1;
      case PERIOD_H4:
         return OBJ_PERIOD_H4;
      case PERIOD_D1:
         return OBJ_PERIOD_D1;
      case PERIOD_W1:
         return OBJ_PERIOD_W1;
      case PERIOD_MN1:
         return OBJ_PERIOD_MN1;
     }
   return(EMPTY);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteObjects(string objName)
  {
   for(int i=0; i < ObjectsTotal(); i++)
     {
      string name=ObjectName(i);
      if(StringFind(name,objName) != -1)
        {
         ObjectDelete(name);
        }
      Sleep(1);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*bool isNewBar(int period)
  {
   if(GlobalVariableGet(Symbol()+(string)period)!=iTime(NULL,period,0))
     {
      GlobalVariableSet(Symbol()+(string)period,iTime(NULL,period,0));
      return(true);
     }
   return(false);
  }
 */
bool isNewBar(int period) //Kiểm tra có phải là nến mới không
  {
   bool firstRun = false, newBar = false;

   if(period==0)
      period=Period();
   switch(period)
     {
      case PERIOD_M1:
         ArraySetAsSeries(ArrayTime_M1,true);
         CopyTime(Symbol(),period,0,2,ArrayTime_M1);
         if(LastTime_M1 == 0)
            firstRun = true;
         if(ArrayTime_M1[0] > LastTime_M1)
           {
            if(firstRun == false)
               newBar = true;
            LastTime_M1 = ArrayTime_M1[0];
           }
         return newBar;
      case PERIOD_M5:
         ArraySetAsSeries(ArrayTime_M5,true);
         CopyTime(Symbol(),period,0,2,ArrayTime_M5);
         if(LastTime_M5 == 0)
            firstRun = true;
         if(ArrayTime_M5[0] > LastTime_M5)
           {
            if(firstRun == false)
               newBar = true;
            LastTime_M5 = ArrayTime_M5[0];
           }
         return newBar;
      case PERIOD_M15:
         ArraySetAsSeries(ArrayTime_M15,true);
         CopyTime(Symbol(),period,0,2,ArrayTime_M15);
         if(LastTime_M15 == 0)
            firstRun = true;
         if(ArrayTime_M15[0] > LastTime_M15)
           {
            if(firstRun == false)
               newBar = true;
            LastTime_M15 = ArrayTime_M15[0];
           }
         return newBar;
      case PERIOD_M30:
         ArraySetAsSeries(ArrayTime_M30,true);
         CopyTime(Symbol(),period,0,2,ArrayTime_M30);
         if(LastTime_M30 == 0)
            firstRun = true;
         if(ArrayTime_M30[0] > LastTime_M30)
           {
            if(firstRun == false)
               newBar = true;
            LastTime_M30 = ArrayTime_M30[0];
           }
         return newBar;
      case PERIOD_H1:
         ArraySetAsSeries(ArrayTime_H1,true);
         CopyTime(Symbol(),period,0,2,ArrayTime_H1);
         if(LastTime_H1 == 0)
            firstRun = true;
         if(ArrayTime_H1[0] > LastTime_H1)
           {
            if(firstRun == false)
               newBar = true;
            LastTime_H1 = ArrayTime_H1[0];
           }
         return newBar;
      case PERIOD_H4:
         ArraySetAsSeries(ArrayTime_H4,true);
         CopyTime(Symbol(),period,0,2,ArrayTime_H4);
         if(LastTime_H4 == 0)
            firstRun = true;
         if(ArrayTime_H4[0] > LastTime_H4)
           {
            if(firstRun == false)
               newBar = true;
            LastTime_H4 = ArrayTime_H4[0];
           }
         return newBar;
      case PERIOD_D1:
         ArraySetAsSeries(ArrayTime_D1,true);
         CopyTime(Symbol(),period,0,2,ArrayTime_D1);
         if(LastTime_D1 == 0)
            firstRun = true;
         if(ArrayTime_D1[0] > LastTime_D1)
           {
            if(firstRun == false)
               newBar = true;
            LastTime_D1 = ArrayTime_D1[0];
           }
         return newBar;
         /* case PERIOD_W1:
             return ("W1");
          case PERIOD_MN1:
             return ("MN1");*/
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TinhSoPips(double price_1, double price_2)
  {
   double point_compat = 1;
   if(StringFind(_Symbol,"XAU")>=0 || StringFind(_Symbol,"GOLD")>=0)
     {
      return NormalizeDouble(MathAbs((price_1 - price_2)/(Point*10)),2);
     }
   if(Digits == 2)
      return NormalizeDouble(MathAbs((price_1 - price_2)/(Point*100)),2);

   if(Digits == 3 || Digits == 5)
      point_compat = 10;
   return NormalizeDouble(MathAbs((price_1 - price_2)/(Point*point_compat)),2);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ScreenShot(int timeFrame, string symb, string screenShotName = "_Signal", string _template = "ptl_screenshot.tpl", bool isOpenChart=true)
  {
//string folder = "Screenshots\\"/*+_Symbol+"\\"*/;
   string name =  symb + screenShotName+ "_" + ConvertTimeFrametoString(timeFrame)+".gif";
   if(isOpenChart)
     {
      long chart = ChartOpen(symb, timeFrame);
      Sleep(700);
      ChartApplyTemplate(chart, _template);
      Sleep(1200);
      ChartScreenShot(chart, name, 1366, 768);
      Sleep(300);
      ChartClose(chart);
     }
   else
     {
      //ChartSetSymbolPeriod(NULL, symb, timeFrame);
      /*int wait=60;
      while(--wait>0)
        {
         if(SeriesInfoInteger(symb,timeFrame, SERIES_SYNCHRONIZED))
            break;
         Sleep(500);
        }*/
      //Sleep(500);
      ChartScreenShot(NULL, name, 1280, 720);
     }
   Sleep(1000);
   return name;
  }
//+------------------------------------------------------------------+
