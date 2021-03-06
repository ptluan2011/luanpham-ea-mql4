//+-------------Phiên giao dịch (Tính theo giờ VN)--------------------+
//| Mùa hè - thu:
//|+ Sydney: 4:00 - 12:59        0:00 - 8:59
//|+ Tokyo: 6:00 - 14:59         2:00 - 10:59
//|+ London: 14:00 - 22:59       8:00 - 18:59
//|+ New York: 19:00 - 3:59      15:00 - 23:59
//| Mùa đông - xuân:
//|+ Sydney: 5:00 - 13:59
//|+ Tokyo: 6:00 - 14:59
//|+ London: 15:00 - 23:59
//|+ New York: 20:00 - 4:59
//+------------------------------------------------------------------+

#property indicator_chart_window

//+------------------------------------------------------------------+
extern int    NumberOfDays = 5;
extern bool   S_SpringSummer = true;
extern bool   ShowSydneySession = false;
extern bool   ShowDrawSession = true;
extern bool   ShowSessionName = true;
extern bool   ShowDrawMarketSegment = true;
extern string Line1 = "////////////////////////////////////////////////";
extern color  SydneyColor    = C'155,205,255';
extern ENUM_LINE_STYLE    SydneyStyle = STYLE_DOT;
extern color  TokyoColor    = C'211,211,211';
extern ENUM_LINE_STYLE    TokyoStyle = STYLE_DOT;
extern color  LondonColor     = C'222,147,255';
extern ENUM_LINE_STYLE    LondonStyle = STYLE_DOT;
extern color  NewYorkColor     = C'231,156,156';
extern ENUM_LINE_STYLE    NewYorkStyle = STYLE_DOT;
extern string Line2 = "////////////////////////////////////////////////";
color  MarketSegmentColor = C'185,185,185';
extern ENUM_LINE_STYLE  MarketSegmentStyle = STYLE_SOLID;
extern string Line3 = "////////////////////////////////////////////////";
extern color  clFont       = C'211,211,211';
extern int    SizeFont     = 7;
extern int    OffSet       = 60;
extern bool   Background   = false;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void init()
  {
   DeleteObjects();
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void deinit()
  {
   DeleteObjects();
  }

//+------------------------------------------------------------------+
void CreateObjects(string objname, color col, int style=1)
  {
   if(ShowDrawSession == false)
      {
      ShowSessionName = false;
      }
   if(ShowDrawSession == true && StringFind(objname,"MarketSegment") == -1)
     {
      ObjectCreate(objname, OBJ_RECTANGLE, 0, 0,0, 0,0);
      ObjectSet(objname, OBJPROP_STYLE, style);
      ObjectSet(objname, OBJPROP_COLOR, col);
      ObjectSet(objname, OBJPROP_BACK, Background);
     }
   if(ShowDrawMarketSegment == true && StringFind(objname,"MarketSegment") >= 0)
     {
      ObjectCreate(objname, OBJ_RECTANGLE, 0, 0,0, 0,0);
      ObjectSet(objname, OBJPROP_STYLE, style);
      ObjectSet(objname, OBJPROP_COLOR, col);
      ObjectSet(objname, OBJPROP_BACK, Background);
     }
  }

//+------------------------------------------------------------------+
void DeleteObjects()
  {
   ObjectsDeleteAll(0, "Sydney*");
   ObjectsDeleteAll(0, "Tokyo*");
   ObjectsDeleteAll(0, "London*");
   ObjectsDeleteAll(0, "NewYork*");
   ObjectsDeleteAll(0, "MarketSegment*");
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start()
  {
   if(Period() < 60)
     {
      string SydneyBegin;
      string SydneyEnd;
      string TokyoBegin;
      string TokyoEnd;
      string LondonBegin;
      string LondonEnd;
      string NewYorkBegin;
      string NewYorkEnd;
      if(S_SpringSummer)
        {
         SydneyBegin = "0:00";
         SydneyEnd = "8:59";
         TokyoBegin = "02:00";
         TokyoEnd   = "10:59";
         LondonBegin  = "10:00";
         LondonEnd    = "18:59";
         NewYorkBegin  = "15:00";
         NewYorkEnd    = "23:59";
        }
      else
        {
         // Tới mùa đông xuân thì update code giờ chỗ này nếu chạy sai
        }
      datetime dt=CurTime();
      //printf(TimeToStr(dt));


      for(int i=0; i<NumberOfDays; i++)
        {
         if(i== 0)
           {
            dt=decDateTradeDay(dt);
            while(TimeDayOfWeek(dt)>5 || TimeDayOfWeek(dt)<1)
               dt=decDateTradeDay(dt);
            continue;
           }
         if(ShowSydneySession)
            CreateObjects("Sydney_"+i, i==0 ? SydneyColor : clFont, SydneyStyle);
         CreateObjects("Tokyo_"+i, i==0 ? TokyoColor : clFont, TokyoStyle);
         CreateObjects("London_"+i, i==0 ? LondonColor : clFont, LondonStyle);
         CreateObjects("NewYork_"+i, i==0 ? NewYorkColor : clFont, NewYorkStyle);


         if(ShowSydneySession)
            DrawObjects(dt, "Sydney_"+i, SydneyBegin, SydneyEnd, SydneyStyle, "Sy");
         DrawObjects(dt, "Tokyo_"+i, TokyoBegin, TokyoEnd, TokyoStyle, "To");
         DrawObjects(dt, "London_"+i, LondonBegin, LondonEnd, LondonStyle, "Ln");
         DrawObjects(dt, "NewYork_"+i, NewYorkBegin, NewYorkEnd, NewYorkStyle, "Ny");


         CreateObjects("MarketSegment_"+i, MarketSegmentColor, MarketSegmentStyle);
         DrawMarketSegments(dt,"MarketSegment_" + i, MarketSegmentStyle, "MS");

         dt=decDateTradeDay(dt);
         while(TimeDayOfWeek(dt)>5 || TimeDayOfWeek(dt)<1)
            dt=decDateTradeDay(dt);
        }
     }
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawObjects(datetime dt, string objname, string timebegin, string timeend, int style = 1, string sname = "")
  {
//return;
//+------------------------------------------------------------------+
   datetime t1, t2;
   double   p1, p2;
   int      b1, b2;
   t1=StrToTime(TimeToStr(dt, TIME_DATE)+" "+timebegin);

   t2=StrToTime(TimeToStr(dt, TIME_DATE)+" "+timeend);

//Comment(TimeToStr(CurTime()) + " - " + TimeToStr(dt)+ " - " + TimeToStr(t2));

   b1=iBarShift(NULL, 0, t1);
   b2=iBarShift(NULL, 0, t2);
   if(CurTime() <= t1)
     {
      p1=iHigh(NULL,PERIOD_D1,1);
      p2=iLow(NULL,PERIOD_D1,1);
     }
   else
     {
      p1=High[iHighest(NULL, 0, MODE_HIGH, b1-b2+1, b2)];
      p2=Low[iLowest(NULL, 0, MODE_LOW, b1-b2+1, b2)];

     }
//Comment(b1 + " ><  " +b2 +" |||  "+ p1 + " ><  " +p2);
   ObjectSet(objname, OBJPROP_TIME1, t1);
   ObjectSet(objname, OBJPROP_PRICE1, p1);
   ObjectSet(objname, OBJPROP_TIME2, t2);
   ObjectSet(objname, OBJPROP_PRICE2, p2);
   if(ShowSessionName)
     {
      if(ObjectFind(objname+sname)<0)
         ObjectCreate(objname+sname, OBJ_TEXT, 0, 0, 0);
      ObjectSet(objname+sname, OBJPROP_TIME1, t1);
      ObjectSet(objname+sname, OBJPROP_PRICE1, p1+OffSet*Point);
      ObjectSet(objname+sname, OBJPROP_COLOR, clFont);
      ObjectSet(objname+sname, OBJPROP_FONTSIZE, SizeFont);
      ObjectSetText(objname+sname, sname);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*void DrawMarketSegments(datetime dt, string objname, int style = 1, string sname = "")
  {
   datetime t1, t2;
   double   p1, p2;
   int      b0, b1, b2;
   b0=iBarShift(NULL, 0, dt);
   t1 = iTime(NULL, 0, b0-2);
   t2 = iTime(NULL, 0, b0+2);
   p1=High[iHighest(NULL, 0, MODE_HIGH, 5, b0-2)];
   p2=Low[iLowest(NULL, 0, MODE_LOW, 5, b0-2)];
   ObjectSet(objname, OBJPROP_TIME1, t1);
   ObjectSet(objname, OBJPROP_PRICE1, p1);
   ObjectSet(objname, OBJPROP_TIME2, t2);
   ObjectSet(objname, OBJPROP_PRICE2, p2);
   ObjectSet(objname, OBJPROP_BACK, true);
  }*/
void DrawMarketSegments(datetime dt, string objname, int style = 1, string sname = "")
  {
   datetime t1, t2;
   double   p1, p2;
   int      b0, b1, b2;
   b0=iBarShift(NULL, 0, dt);
   t1 = iTime(NULL, 0, b0);
   t2 = iTime(NULL, 0, b0-5);
   p1=High[iHighest(NULL, 0, MODE_HIGH, 5, b0+1-5)];
   p2=Low[iLowest(NULL, 0, MODE_LOW, 5, b0+1-5)];
   ObjectSet(objname, OBJPROP_TIME1, t1);
   ObjectSet(objname, OBJPROP_PRICE1, p1);
   ObjectSet(objname, OBJPROP_TIME2, t2);
   ObjectSet(objname, OBJPROP_PRICE2, p2);
   ObjectSet(objname, OBJPROP_BACK, true);
  }

//+------------------------------------------------------------------+
datetime decDateTradeDay(datetime dt)
  {
//+------------------------------------------------------------------+
   int ty=TimeYear(dt);
   int tm=TimeMonth(dt);
   int td=TimeDay(dt);
   int th=TimeHour(dt);
   int ti=TimeMinute(dt);

   td--;
   if(td==0)
     {
      tm--;
      if(tm==0)
        {
         ty--;
         tm=12;
        }
      if(tm==1 || tm==3 || tm==5 || tm==7 || tm==8 || tm==10 || tm==12)
         td=31;
      if(tm==2)
         if(MathMod(ty, 4)==0)
            td=29;
         else
            td=28;
      if(tm==4 || tm==6 || tm==9 || tm==11)
         td=30;
     }
   return(StrToTime(ty+"."+tm+"."+td+" "+th+":"+ti));
  }

//+------------------------------------------------------------------+
