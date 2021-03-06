//+------------------------------------------------------------------+
//|                                                  LuanPham_EA.mq4 |
//|                                                        Luan Pham |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luan Pham"
#property link      ""
#property version   "1.00"
#property strict

#include <stdlib.mqh>
#include <PTL_EA/PTL_Systems.mqh>
#include <PTL_EA/_Utilities.mqh>
#include <PTL_EA/_DrawSignal.mqh>
#include <Telegram.mqh>
#include <PTL_EA/PTL_MyBot.mqh>
#include <PTL_EA/_PriceAction.mqh>
#include <PTL_EA/_PriceOpen.mqh>
#include <PTL_EA/_EMA.mqh>
#include <PTL_EA/_Trend.mqh>
#include <PTL_EA/_CandlestickPatterns.mqh>
#include <PTL_EA/_ResistanceSupport.mqh>

input ENUM_LANGUAGES    InpLanguage=LANGUAGE_VN;//Language
input string TelegramToken = "927322228:AAFxIy4Tw_rfZr6LEoyO5tocsMNBxwNXIHI";
extern bool TelegramNotification = true;
//extern bool MobileNotification = false;
//extern bool EmailNotification = false;
extern string Pair_suffix = "";//pair prefix
input ENUM_UPDATE_MODE  InpUpdateMode=UPDATE_NORMAL;//Update Mode
input string            InpTemplates="ptl_screenshot;ptl_screenshot_zoom";
bool isBigMove= false;

long tele_EMA_id = -1001181930926;//-1001415417026;
long tele_PA_id = -1001207582460;//-1001200978562;
long tele_SR_id = -1001158562267;//-1001364314480;
long tele_indices = -1001451604118;
long tele_chat_id = -1;
string list_pairs = "XAUUSD.pro,GBPUSD.pro,GBPJPY.pro,GBPAUD.pro,EURUSD.pro,EURJPY.pro,GBPJPY.pro,USDJPY.pro,USDCAD.pro,S&P.fs,USDINDEX.fs";
int text_arr_i = 0;
string text_arr[100];
CMyBot bot;
string broker = "";
long account_login = 0;
bool CheckNotification = false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   broker = AccountInfoString(ACCOUNT_SERVER);
   account_login = AccountInfoInteger(ACCOUNT_LOGIN);
   if(StringFind(broker,"AxiTrader") >= 0)
      Pair_suffix = ".pro";
   if(StringFind(broker,"Think") >= 0)
      Pair_suffix = "x";
   if(StringFind(broker,"Yulo") >= 0)
      Pair_suffix = ".yt";
   if(StringFind(broker,"AxiTrader") >= 0 && account_login == 4136966)
     {
      CheckNotification = true;
     }
   bot.Token(TelegramToken);
   bot.Language(InpLanguage);
   bot.Templates(InpTemplates);
   tele_chat_id = GetTeleTokenPair();
   System_ResistanceSupport(Period(), 500, true);//Vẽ Kháng cự hỗ trợ
   Get_Trend_CandlePattern(Period());
//--- set timer
   EventSetMillisecondTimer(1000);
   OnTimer();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//ObjectsDeleteAll(0, "_RS_*");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+-------------1-----------------------------------------------------+
void start()
  {
   if(TimeHour(TimeLocal()) < 6 || TimeHour(TimeLocal()) > 23)
     {
      return;
     }
   if(StringFind(list_pairs,_Symbol)<0)
      return;
   string str_signal = "";
   int timeFrame = 0;
// return;
//ObjectsDeleteAll(0, "*txt_system_*");

   if(StringFind(_Symbol,"GBPUSD") >= 0 /*|| StringFind(_Symbol,"GBPUSD") >= 0  || StringFind(_Symbol,"EURJPY") >= 0*/)
     {
      Dojibar(15,7);
      //Comment(TinhSoPips(Bid, Ask));
      //PTL_System(5);
      //string filename ="D://"+ _Symbol +"_" +TimeCurrent() + ".png";
      //PlaySound("news.wav");
     }
   if(isNewBar(PERIOD_M1))
     {
      if(StringFind(_Symbol,"GBPUSD") >= 0 /*|| StringFind(_Symbol,"GBPUSD") >= 0  || StringFind(_Symbol,"EURJPY") >= 0*/)
        {

         //PTL_System(PERIOD_M5);
         //string p_id;
         //string s_name  = ScreenShot(PERIOD_M5, false);
         //bot.SendPhoto(p_id, -1001200978562, s_name, s_name);
        }
      isBigMove = false;
     }
   if(isNewBar(PERIOD_M5))
     {
      string signal_m5 = PTL_System(PERIOD_M5);
      if(signal_m5 != "")
        {
         str_signal += signal_m5;
         timeFrame = PERIOD_M5;
        }
     }
   if(isNewBar(PERIOD_M15))
     {
      string signal_m15 = PTL_System(PERIOD_M15);
      if(signal_m15 != "")
        {
         str_signal += signal_m15;
         timeFrame = PERIOD_M15;
        }
     }
   if(isNewBar(PERIOD_M30))
     {
      string signal_m30 = PTL_System(PERIOD_M30);
      if(signal_m30 != "")
        {
         str_signal += signal_m30;
         timeFrame = PERIOD_M30;
        }
     }
   if(isNewBar(PERIOD_H1))
     {
      string signal_h1 = PTL_System(PERIOD_H1);
      if(signal_h1 != "")
        {
         str_signal += signal_h1;
         timeFrame = PERIOD_H1;
        }
     }
   if(isNewBar(PERIOD_H4))
     {
      string signal_h4 = PTL_System(PERIOD_H4);
      if(signal_h4 != "")
        {
         str_signal += signal_h4;
         timeFrame = PERIOD_H4;
        }
     }
   if(isNewBar(PERIOD_D1))
     {

     }
   if(CheckNotification)
     {
      if(str_signal != "")
        {
         string p_id;
         string s_name = ScreenShot(timeFrame,_Symbol,"_Signal_"+(string)MathRand(), "ptl_screenshot", true);
         bot.SendPhoto(p_id, tele_chat_id, s_name, str_signal);
        }
      if(isBigMove==false)
        {
         string strBigMove = CheckBarBigMove(PERIOD_M1);
         if(strBigMove != "")
           {
            isBigMove = true;
            Sleep(500);
            //string p_id;
            //string s_name  = ScreenShot(PERIOD_M5,_Symbol,"_BigMove", "ptl_screenshot", true);
            //bot.SendPhoto(p_id, tele_PA_id, s_name, strBigMove);
            //bot.SendMessage(tele_chat_id, strBigMove);
           }

        }
     }
  }

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   PriceOpenGraph();//Vẽ line giá mở cửa
   GetTrendPrice();

   if(StringFind(_Symbol,"USDINDEX") >= 0)
     {
      //bot.GetUpdates();
      //bot.ProcessMessages();
     }
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
