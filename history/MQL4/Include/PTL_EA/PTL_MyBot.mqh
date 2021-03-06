//+------------------------------------------------------------------+
//|                                                  PTL_MyBot.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//#include <PTL_EA/PTLBotTelegram.mqh>
//#include <Telegram.mqh>
//|-----------------------------------------------------------------------------------------|
//|                               M A I N   P R O C E D U R E                               |
//|-----------------------------------------------------------------------------------------|
const ENUM_TIMEFRAMES _periods[]= {PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1,PERIOD_MN1};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMyBot: public CCustomBot
  {
private:
   ENUM_LANGUAGES    m_lang;
   string            m_symbol;
   ENUM_TIMEFRAMES   m_period;
   string            m_template;
   CArrayString      m_templates;
public:
   //+------------------------------------------------------------------+
   void              Language(const ENUM_LANGUAGES _lang) {m_lang=_lang;}

   //+------------------------------------------------------------------+
   int               Templates(const string _list)
     {
      m_templates.Clear();
      //--- parsing
      string text=StringTrim(_list);
      if(text=="")
         return(0);
      //---
      while(StringReplace(text,"  "," ")>0);
      StringReplace(text,";"," ");
      StringReplace(text,","," ");
      //---
      string array[];
      int amount=StringSplit(text,' ',array);
      amount=fmin(amount,5);

      for(int i=0; i<amount; i++)
        {
         array[i]=StringTrim(array[i]);
         if(array[i]!="")
            m_templates.Add(array[i]);
        }
      return(amount);
     }

   void              ProcessMessages(void)
     {
#define EMOJI_TOP    "\xF51D Home"
#define EMOJI_BACK   "\xF519 Back"
#define KEYB_MAIN    (m_lang==LANGUAGE_EN)?"[[\"Account Info\"],[\"Quotes\"],[\"Charts\"]]":"[[\"Thông tin tài khoản\"],[\"Báo giá\"],[\"Biểu đồ\"]]"
      //#define KEYB_SYMBOLS "[[\""+EMOJI_TOP+"\",\"XAUUSD\",\"S&P\",\"WTI(OIL)\",\"USDINDEX\"],[\"EURUSD\",\"EURJPY\",\"GBPUSD\",\"GBPJPY\",\"USDJPY\"],[\"USDCHF\",\"USDCAD\",\"AUDUSD\",\"GBPAUD\"]]"
#define KEYB_SYMBOLS "[[\""+EMOJI_TOP+"\",\"XAUUSD\",\"EURUSD\",\"GBPUSD\"],[\"GBPJPY\",\"EURJPY\",\"USDJPY\",\"USDCHF\"],[\"USDCAD\",\"AUDUSD\",\"GBPAUD\",\"USDINDEX\",\"S&P\"]]"
#define KEYB_PERIODS "[[\""+EMOJI_TOP+"\",\"M1\",\"M5\",\"M15\"],[\""+EMOJI_BACK+"\",\"M30\",\"H1\",\"H4\"],[\" \",\"D1\",\"W1\",\"MN1\"]]"

      //string msg="";
      for(int i=0; i<m_chats.Total(); i++)
        {
         CCustomChat *chat=m_chats.GetNodeAtIndex(i);

         if(!chat.m_new_one.done)
           {
            chat.m_new_one.done=true;
            string text=chat.m_new_one.message_text;

            if(text=="/start" || text=="/help")
              {
               chat.m_state=0;
               string msg="The bot works with your trading account:\n";
               msg+="/info - get account information\n";
               msg+="/quotes - get quotes\n";
               msg+="/charts - get chart images\n";

               if(m_lang==LANGUAGE_VN)
                 {
                  msg="Bot làm việc với tài khoản giao dịch của bạn:\n";
                  msg+="/info - Lấy thông tin tài khoản\n";
                  msg+="/quotes - Lấy báo giá cặp tiền\n";
                  msg+="/charts - Lấy hình ảnh biểu đồ cặp tiền\n";
                 }

               SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_MAIN,false,false));
               continue;
              }
            //---
            if(text==EMOJI_TOP)
              {
               chat.m_state=0;
               string msg=(m_lang==LANGUAGE_EN)?"Choose a menu item":"Chọn một mục";
               SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_MAIN,false,false));
               continue;
              }

            //---
            if(text==EMOJI_BACK)
              {
               if(chat.m_state==31)
                 {
                  chat.m_state=3;
                  string msg=(m_lang==LANGUAGE_EN)?"Enter a symbol name like 'EURUSD'":"Nhập tên một cặp tiền, ví dụ 'EURUSD'";
                  SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_SYMBOLS,false,false));
                 }
               else
                  if(chat.m_state==32)
                    {
                     chat.m_state=31;
                     string msg=(m_lang==LANGUAGE_EN)?"Select a timeframe like 'H1'":"Chọn một khung thời gian, ví dụ 'H1'";
                     SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_PERIODS,false,false));
                    }
                  else
                    {
                     chat.m_state=0;
                     string msg=(m_lang==LANGUAGE_EN)?"Choose a menu item":"Chọn một mục";
                     SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_MAIN,false,false));
                    }
               continue;
              }
            if(text=="/info" || text=="Account Info" || text=="Thông tin tài khoản")
              {
               chat.m_state=1;
               string currency=AccountInfoString(ACCOUNT_CURRENCY);
               string msg=StringFormat("%d: %s\n",AccountInfoInteger(ACCOUNT_LOGIN),AccountInfoString(ACCOUNT_SERVER));
               msg+=StringFormat("%s: %.2f %s\n",(m_lang==LANGUAGE_EN)?"Balance":"Số dư",AccountInfoDouble(ACCOUNT_BALANCE),currency);
               msg+=StringFormat("%s: %.2f %s\n",(m_lang==LANGUAGE_EN)?"Profit":"Lợi nhuận",AccountInfoDouble(ACCOUNT_PROFIT),currency);
               SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_MAIN,false,false));
              }

            //---
            if(text=="/quotes" || text=="Quotes" || text=="Báo giá")
              {
               chat.m_state=2;
               string msg=(m_lang==LANGUAGE_EN)?"Enter a symbol name like 'EURUSD'":"Nhập tên một cặp tiền, ví dụ 'EURUSD'";
               SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_SYMBOLS,false,false));
               continue;
              }

            //---
            if(text=="/charts" || text=="Charts" || text=="Biểu đồ")
              {
               chat.m_state=3;
               string msg=(m_lang==LANGUAGE_EN)?"Enter a symbol name like 'EURUSD'":"Nhập tên một cặp tiền, ví dụ 'EURUSD'";
               SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_SYMBOLS,false,false));
               continue;
              }
            //--- Quotes
            if(chat.m_state==2)
              {
               string mask=(m_lang==LANGUAGE_EN)?"Invalid symbol name '%s'":"Tên cặp tiền không hợp lệ hoặc không có trong Market Watch! '%s'";
               string msg=StringFormat(mask,text);
               StringToUpper(text);
               string symbol=text;
               if(StringFind(symbol, "S&P")>=0 || StringFind(symbol, "USDINDEX")>=0)
                  symbol+=".fs";
               else
                  symbol+=Pair_suffix;
               if(SymbolSelect(symbol,true))
                 {
                  double open[1]= {0};

                  m_symbol=symbol;
                  //--- upload history
                  for(int k=0; k<3; k++)
                    {
#ifdef __MQL4__
                     double array[][6];
                     ArrayCopyRates(array,symbol,PERIOD_D1);
#endif

                     Sleep(1000);
                     CopyOpen(symbol,PERIOD_D1,0,1,open);
                     if(open[0]>0.0)
                        break;
                    }

                  int digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
                  double bid=SymbolInfoDouble(symbol,SYMBOL_BID);

                  CopyOpen(symbol,PERIOD_D1,0,1,open);
                  if(open[0]>0.0)
                    {
                     double percent=100*(bid-open[0])/open[0];
                     //--- sign
                     string sign=ShortToString(0x25B2);
                     if(percent<0.0)
                        sign=ShortToString(0x25BC);

                     msg=StringFormat("%s: %s %s (%s%%)",symbol,DoubleToString(bid,digits),sign,DoubleToString(percent,2));
                    }
                  else
                    {
                     msg=(m_lang==LANGUAGE_EN)?"No history for ":"Không có lịch sử cho "+symbol;
                    }
                 }

               SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_SYMBOLS,false,false));
               continue;
              }
            //--- Charts
            if(chat.m_state==3)
              {

               StringToUpper(text);
               //string symbol= StringFind(text,"INDEX") >= 0 ? text : (text+Pair_suffix);
               string symbol=text;
               if(StringFind(symbol, "S&P")>=0 || StringFind(symbol, "USDINDEX")>=0)
                  symbol+=".fs";
               else
                  symbol+=Pair_suffix;
               if(SymbolSelect(symbol,true))
                 {
                  m_symbol=symbol;

                  chat.m_state=31;
                  string msg=(m_lang==LANGUAGE_EN)?"Select a timeframe like 'H1'":"Chọn một khung thời gian, ví dụ 'H1'";
                  SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_PERIODS,false,false));
                 }
               else
                 {
                  string mask=(m_lang==LANGUAGE_EN)?"Invalid symbol name '%s'":"Cặp tiền '%s' không hợp lệ hoặc không có trong Market Watch";
                  string msg=StringFormat(mask,text);
                  SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_SYMBOLS,false,false));
                 }
               continue;
              }

            //Charts->Periods
            if(chat.m_state==31)
              {
               bool found=false;
               int total=ArraySize(_periods);
               for(int k=0; k<total; k++)
                 {
                  string str_tf=StringSubstr(EnumToString(_periods[k]),7);
                  if(StringCompare(str_tf,text,false)==0)
                    {
                     m_period=_periods[k];
                     found=true;
                     break;
                    }
                 }

               if(found)
                 {
                  //--- template
                  chat.m_state=32;
                  string str="[[\""+EMOJI_BACK+"\",\""+EMOJI_TOP+"\"]";
                  str+=",[\"None\"";
                  for(int k=0; k<m_templates.Total(); k++)
                     str+=",\""+m_templates.At(k)+"\"";
                  str+="]]";
                  SendMessage(chat.m_id,(m_lang==LANGUAGE_EN)?"Select a template":"Chọn một bản mẫu (Template)",ReplyKeyboardMarkup(str,false,false));

                  //string s_name  = ScreenShot(m_period, m_symbol,"", m_template, true);
                  //SendPhoto(s_name,chat.m_id,s_name,m_symbol+"_"+StringSubstr(EnumToString(m_period),7));
                 }
               else
                 {
                  SendMessage(chat.m_id,(m_lang==LANGUAGE_EN)?"Invalid timeframe":"Khung thời gian không hợp lệ",ReplyKeyboardMarkup(KEYB_PERIODS,false,false));
                 }
               continue;
              }
            //---
            if(chat.m_state==32)
              {
               printf(text);
               m_template=text;
               if(m_template=="None")
                  m_template=NULL;
               string s_name  = ScreenShot(m_period, m_symbol,"", m_template, true);
               //string screen_id;
               //int result=SendPhoto(chat.m_id,"https://sslecal2.forexprostools.com/?defaultFont=%23141313&columns=exc_flags,exc_currency,exc_importance,exc_actual,exc_forecast,exc_previous&category=_employment,_economicActivity,_inflation,_credit,_centralBanks,_confidenceIndex,_balance,_Bonds&importance=2,3&features=datepicker,timezone,timeselector,filters&countries=33,4,34,6,11,51,5,39,72,60,110,43,35,71,22,26,12,9,25,178,10,17&calType=day&timeZone=27&lang=52",m_symbol+"_"+StringSubstr(EnumToString(m_period),7),false);
               int result=SendPhoto(s_name,chat.m_id,s_name,m_symbol+"_"+StringSubstr(EnumToString(m_period),7),false);
               //chat.m_state=31;
               //SendPhoto(s_name, chat.m_id,"\\",m_symbol ,0);
               //int result=SendScreenShot(chat.m_id,m_symbol,m_period,m_template);
               if(result!=0)
                  Print(GetErrorDescription(result,InpLanguage));
              }
           }
        }
     }

  };
//+------------------------------------------------------------------+
