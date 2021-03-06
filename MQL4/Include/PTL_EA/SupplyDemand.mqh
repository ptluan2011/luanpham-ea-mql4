//+------------------------------------------------------------------+
//|                                                 SupplyDemand.mqh |
//|                                       Copyright 2019, Luan Pham. |
//|                                     http://www.phamthanhluan.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Luan Pham."
#property link      "http://www.phamthanhluan.com"
#property strict
/*
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Red
#property indicator_color2 Red
#property indicator_color3 DodgerBlue
#property indicator_color4 DodgerBlue
*/
extern int BackLimit=500;

//extern string pus1="/////////////////////////////////////////////////";
bool zone_show_weak=true;
bool zone_show_untested = true;
bool zone_show_turncoat = false;
double zone_fuzzfactor=0.5;

//extern string pus2="/////////////////////////////////////////////////";
bool fractals_show=false;
double fractal_fast_factor = 3.0;
double fractal_slow_factor = 6.0;
bool SetGlobals=true;

//extern string pus3="/////////////////////////////////////////////////";
bool zone_solid=true;
int zone_linewidth=1;
int zone_style=0;
bool zone_show_info=true;
int zone_label_shift=4;
bool zone_merge=true;
bool zone_extend=true;
//extern string pus4="/////////////////////////////////////////////////";
extern bool zone_show_alerts  = false;
extern bool zone_alert_popups = true;
extern bool zone_alert_sounds = true;
extern int zone_alert_waitseconds=300;

extern string pus5="/////////////////////////////////////////////////";
extern int Text_size=8;
extern string Text_font = "Courier New";
extern color Text_color = White;
extern string sup_name = "Sup";
extern string res_name = "Res";
extern string test_name= "Retests";
extern color color_support_weak     = DarkSlateGray;
extern color color_support_untested = SeaGreen;
extern color color_support_verified = Green;
extern color color_support_proven   = LimeGreen;
extern color color_support_turncoat = OliveDrab;
extern color color_resist_weak      = Indigo;
extern color color_resist_untested  = Orchid;
extern color color_resist_verified  = Crimson;
extern color color_resist_proven    = Red;
extern color color_resist_turncoat  = DarkOrange;

double FastDnPts[],FastUpPts[];
double SlowDnPts[],SlowUpPts[];

double zone_hi[],zone_lo[];
int    zone_start[],zone_hits[],zone_type[],zone_strength[],zone_count=0, time_Frame = 0;
bool   zone_turn[];

#define ZONE_SUPPORT 1
#define ZONE_RESIST  2

#define ZONE_WEAK      0
#define ZONE_TURNCOAT  1
#define ZONE_UNTESTED  2
#define ZONE_VERIFIED  3
#define ZONE_PROVEN    4

#define UP_POINT 1
#define DN_POINT -1

int time_offset=0;

double ner_lo_zone_P1[5];
double ner_lo_zone_P2[5];
double ner_hi_zone_P1[5];
double ner_hi_zone_P2[5];

int LayVungSupplyDemand()
  {
   //if(NewBar(Period()))
   //  {
    //ArrayResize(Sup_Res_M15, 3);
    //if(NewBar(PERIOD_M1))
    //{
       UpdateZoneToArray(PERIOD_M15, Sup_Res_M15);     
       UpdateZoneToArray(PERIOD_M30, Sup_Res_M30);  
       UpdateZoneToArray(PERIOD_H1, Sup_Res_H1);
       UpdateZoneToArray(PERIOD_H4, Sup_Res_H4);
       UpdateZoneToArray(PERIOD_D1, Sup_Res_D1);
    //}
     /* else if(time_Frame == PERIOD_M30 || NewBar(PERIOD_M30))
      {
        
      }
      else if(time_Frame == PERIOD_H1 || NewBar(PERIOD_H1))
      {
         
      }
      else if(time_Frame == PERIOD_H4 || NewBar(PERIOD_H1))
      {
         
      }
      else if(time_Frame == PERIOD_D1 || NewBar(PERIOD_H1))
      {
         
      }*/     
   //  }
   return(0);
  }
  
void SupplyDemand(int timeFrame)
{
   time_Frame = timeFrame;
   int old_zone_count=zone_count;
   ArrayResize(FastUpPts, MathMin(Bars-1,BackLimit)+1);
   ArrayResize(FastDnPts, MathMin(Bars-1,BackLimit)+1);
   ArrayResize(SlowUpPts, MathMin(Bars-1,BackLimit)+1);
   ArrayResize(SlowDnPts, MathMin(Bars-1,BackLimit)+1);
   FastFractals();
   SlowFractals();
   DeleteZones();
   FindZones();
   DrawZones();
   if(zone_count < old_zone_count)
      DeleteOldGlobalVars(old_zone_count);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdateZoneToArray(int timeFrame, double &sr_array[][4])
{
   time_Frame = timeFrame;
   int old_zone_count=zone_count;
   ArrayResize(FastUpPts, MathMin(Bars-1,BackLimit)+1);
   ArrayResize(FastDnPts, MathMin(Bars-1,BackLimit)+1);
   ArrayResize(SlowUpPts, MathMin(Bars-1,BackLimit)+1);
   ArrayResize(SlowDnPts, MathMin(Bars-1,BackLimit)+1);
   FastFractals();
   SlowFractals();
   DeleteZones();
   FindZones();
   //DrawZones();
   if(zone_count < old_zone_count)
      DeleteOldGlobalVars(old_zone_count);

   ArrayResize(sr_array, zone_count);// thiết lập số dòng của ma trận
   for(int i = 0; i < zone_count; i++)
   {
      if(zone_strength[i]==ZONE_WEAK && zone_show_weak==false)
         continue;

      if(zone_strength[i]==ZONE_UNTESTED && zone_show_untested==false)
         continue;
         
      if(zone_strength[i]==ZONE_TURNCOAT && zone_show_turncoat==false)
         continue;
            
      if(zone_type[i] == ZONE_SUPPORT)//Vùng hỗ trợ
      {
         sr_array[i][0] = -1;
         sr_array[i][1] = zone_lo[i];
         sr_array[i][2] = zone_hi[i];
         sr_array[i][3] = zone_hits[i];// số lần test lại mức kháng cự này 
      } 
      else //Vùng kháng cự
      {
         sr_array[i][0] = 1;
         sr_array[i][1] = zone_lo[i];
         sr_array[i][2] = zone_hi[i];
         sr_array[i][3] = zone_hits[i];// số lần test lại mức kháng cự này          
      }      
   }     
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FindZones()
  {
   int i,j,shift,bustcount=0,testcount=0;
   double hival,loval;
   bool turned=false,hasturned=false;

   double temp_hi[500],temp_lo[500];
   int    temp_start[500],temp_hits[500],temp_strength[500],temp_count=0;
   bool   temp_turn[500],temp_merge[500];
   int merge1[500],merge2[500],merge_count=0;

// iterate through zones from oldest to youngest (ignore recent 5 bars),
// finding those that have survived through to the present___
   for(shift=MathMin(Bars-1,BackLimit); shift>5; shift--)
     {
      double atr= iATR(_Symbol,time_Frame,7,shift);
      double fu = atr/2 * zone_fuzzfactor;
      bool isWeak;
      bool touchOk= false;
      bool isBust = false;

      if(FastUpPts[shift]>0.001)
        {
         // a zigzag high point
         isWeak=true;
         if(SlowUpPts[shift]>0.001)
            isWeak=false;

         hival= iHigh(_Symbol, time_Frame, shift);
         if(zone_extend==true)
            hival+=fu;

         loval=MathMax(MathMin(iClose(_Symbol, time_Frame, shift),iHigh(_Symbol, time_Frame, shift)-fu),iHigh(_Symbol, time_Frame, shift)-fu*2);
         turned=false;
         hasturned=false;
         isBust=false;
         bustcount = 0;
         testcount = 0;

         for(i=shift-1; i>=0; i--)
           {
            if((turned==false && FastUpPts[i]>=loval && FastUpPts[i]<=hival) || 
               (turned==true && FastDnPts[i]<=hival && FastDnPts[i]>=loval))
              {
               // Potential touch, just make sure its been 10+candles since the prev one
               touchOk=true;
               for(j=i+1; j<i+11; j++)
                 {
                  if((turned==false && FastUpPts[j]>=loval && FastUpPts[j]<=hival) || 
                     (turned==true && FastDnPts[j]<=hival && FastDnPts[j]>=loval))
                    {
                     touchOk=false;
                     break;
                    }
                 }

               if(touchOk==true)
                 {
                  // we have a touch_  If its been busted once, remove bustcount
                  // as we know this level is still valid & has just switched sides
                  bustcount=0;
                  testcount++;
                 }
              }

            if((turned==false && iHigh(_Symbol, time_Frame, i)>hival) || 
               (turned==true && iLow(_Symbol, time_Frame, i)<loval))
              {
               // this level has been busted at least once
               bustcount++;

               if(bustcount>1 || isWeak==true)
                 {
                  // busted twice or more
                  isBust=true;
                  break;
                 }

               if(turned == true)
                  turned = false;
               else if(turned==false)
                  turned=true;

               hasturned=true;

               // forget previous hits
               testcount=0;
              }
           }

         if(isBust==false)
           {
            // level is still valid, add to our list
            temp_hi[temp_count] = hival;
            temp_lo[temp_count] = loval;
            temp_turn[temp_count] = hasturned;
            temp_hits[temp_count] = testcount;
            temp_start[temp_count] = shift;
            temp_merge[temp_count] = false;

            if(testcount>3)
               temp_strength[temp_count]=ZONE_PROVEN;
            else if(testcount>0)
               temp_strength[temp_count]=ZONE_VERIFIED;
            else if(hasturned==true)
               temp_strength[temp_count]=ZONE_TURNCOAT;
            else if(isWeak==false)
               temp_strength[temp_count]=ZONE_UNTESTED;
            else
               temp_strength[temp_count]=ZONE_WEAK;

            temp_count++;
           }
        }
      else if(FastDnPts[shift]>0.001)
        {
         // a zigzag low point
         isWeak=true;
         if(SlowDnPts[shift]>0.001)
            isWeak=false;

         loval=iLow(_Symbol, time_Frame, shift);
         if(zone_extend==true)
            loval-=fu;

         hival=MathMin(MathMax(iClose(_Symbol, time_Frame, shift),iLow(_Symbol, time_Frame, shift)+fu),iLow(_Symbol, time_Frame, shift)+fu*2);
         turned=false;
         hasturned=false;

         bustcount = 0;
         testcount = 0;
         isBust=false;

         for(i=shift-1; i>=0; i--)
           {
            if((turned==true && FastUpPts[i]>=loval && FastUpPts[i]<=hival) || 
               (turned==false && FastDnPts[i]<=hival && FastDnPts[i]>=loval))
              {
               // Potential touch, just make sure its been 10+candles since the prev one
               touchOk=true;
               for(j=i+1; j<i+11; j++)
                 {
                  if((turned==true && FastUpPts[j]>=loval && FastUpPts[j]<=hival) || 
                     (turned==false && FastDnPts[j]<=hival && FastDnPts[j]>=loval))
                    {
                     touchOk=false;
                     break;
                    }
                 }

               if(touchOk==true)
                 {
                  // we have a touch_  If its been busted once, remove bustcount
                  // as we know this level is still valid & has just switched sides
                  bustcount=0;
                  testcount++;
                 }
              }

            if((turned==true && iHigh(_Symbol, time_Frame, i)>hival) || 
               (turned==false && iLow(_Symbol, time_Frame, i)<loval))
              {
               // this level has been busted at least once
               bustcount++;

               if(bustcount>1 || isWeak==true)
                 {
                  // busted twice or more
                  isBust=true;
                  break;
                 }

               if(turned == true)
                  turned = false;
               else if(turned==false)
                  turned=true;

               hasturned=true;

               // forget previous hits
               testcount=0;
              }
           }

         if(isBust==false)
           {
            // level is still valid, add to our list
            temp_hi[temp_count] = hival;
            temp_lo[temp_count] = loval;
            temp_turn[temp_count] = hasturned;
            temp_hits[temp_count] = testcount;
            temp_start[temp_count] = shift;
            temp_merge[temp_count] = false;

            if(testcount>3)
               temp_strength[temp_count]=ZONE_PROVEN;
            else if(testcount>0)
               temp_strength[temp_count]=ZONE_VERIFIED;
            else if(hasturned==true)
               temp_strength[temp_count]=ZONE_TURNCOAT;
            else if(isWeak==false)
               temp_strength[temp_count]=ZONE_UNTESTED;
            else
               temp_strength[temp_count]=ZONE_WEAK;

            temp_count++;
           }
        }
     }

// look for overlapping zones___
   if(zone_merge==true)
     {
      merge_count=1;
      int iterations=0;
      while(merge_count>0 && iterations<3)
        {
         merge_count=0;
         iterations++;

         for(i=0; i<temp_count; i++)
            temp_merge[i]=false;

         for(i=0; i<temp_count-1; i++)
           {
            if(temp_hits[i]==-1 || temp_merge[j]==true)
               continue;

            for(j=i+1; j<temp_count; j++)
              {
               if(temp_hits[j]==-1 || temp_merge[j]==true)
                  continue;

               if((temp_hi[i]>=temp_lo[j] && temp_hi[i]<=temp_hi[j]) || 
                  (temp_lo[i] <= temp_hi[j] && temp_lo[i] >= temp_lo[j]) ||
                  (temp_hi[j] >= temp_lo[i] && temp_hi[j] <= temp_hi[i]) ||
                  (temp_lo[j] <= temp_hi[i] && temp_lo[j] >= temp_lo[i]))
                 {
                  merge1[merge_count] = i;
                  merge2[merge_count] = j;
                  temp_merge[i] = true;
                  temp_merge[j] = true;
                  merge_count++;
                 }
              }
           }

         // ___ and merge them ___
         for(i=0; i<merge_count; i++)
           {
            int target = merge1[i];
            int source = merge2[i];

            temp_hi[target] = MathMax(temp_hi[target], temp_hi[source]);
            temp_lo[target] = MathMin(temp_lo[target], temp_lo[source]);
            temp_hits[target] += temp_hits[source];
            temp_start[target] = MathMax(temp_start[target], temp_start[source]);
            temp_strength[target]=MathMax(temp_strength[target],temp_strength[source]);
            if(temp_hits[target]>3)
               temp_strength[target]=ZONE_PROVEN;

            if(temp_hits[target]==0 && temp_turn[target]==false)
              {
               temp_hits[target]=1;
               if(temp_strength[target]<ZONE_VERIFIED)
                  temp_strength[target]=ZONE_VERIFIED;
              }

            if(temp_turn[target] == false || temp_turn[source] == false)
               temp_turn[target] = false;
            if(temp_turn[target] == true)
               temp_hits[target] = 0;

            temp_hits[source]=-1;
           }
        }
     }

// copy the remaining list into our official zones arrays
   zone_count=0;
   ArrayResize(zone_hi,temp_count);
   ArrayResize(zone_lo,temp_count);
   ArrayResize(zone_hits,temp_count);
   ArrayResize(zone_turn,temp_count);
   ArrayResize(zone_start,temp_count);
   ArrayResize(zone_strength,temp_count);
   ArrayResize(zone_type,temp_count);
   for(i=0; i<temp_count; i++)
     {
      if(temp_hits[i]>=0 && zone_count<500)
        {
         zone_hi[zone_count]       = temp_hi[i];
         zone_lo[zone_count]       = temp_lo[i];
         zone_hits[zone_count]     = temp_hits[i];
         zone_turn[zone_count]     = temp_turn[i];
         zone_start[zone_count]    = temp_start[i];
         zone_strength[zone_count] = temp_strength[i];

         if(zone_hi[zone_count]<iClose(_Symbol, time_Frame, 4))
            zone_type[zone_count]=ZONE_SUPPORT;
         else if(zone_lo[zone_count]>iClose(_Symbol, time_Frame, 4))
            zone_type[zone_count]=ZONE_RESIST;
         else
           {
            for(j=5; j<500; j++)
              {
               if(iClose(_Symbol, time_Frame, shift)<zone_lo[zone_count])
                 {
                  zone_type[zone_count]=ZONE_RESIST;
                  break;
                 }
               else if(iClose(_Symbol, time_Frame, shift)>zone_hi[zone_count])
                 {
                  zone_type[zone_count]=ZONE_SUPPORT;
                  break;
                 }
              }

            if(j==500)
               zone_type[zone_count]=ZONE_SUPPORT;
           }

         zone_count++;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void DrawZones()
  {
   double lower_nerest_zone_P1=0;
   double lower_nerest_zone_P2=0;
   double higher_nerest_zone_P1=EMPTY_VALUE;
   double higher_nerest_zone_P2=EMPTY_VALUE;

   if(SetGlobals==true)
     {
      GlobalVariableSet("SSSR_Count_"+Symbol()+time_Frame,zone_count);
      GlobalVariableSet("SSSR_Updated_"+Symbol()+time_Frame,TimeCurrent());
     }
   string test0 = "";
   for(int i=0; i<zone_count; i++)
     {
      if(zone_strength[i]==ZONE_WEAK && zone_show_weak==false)
         continue;

      if(zone_strength[i]==ZONE_UNTESTED && zone_show_untested==false)
         continue;

      if(zone_strength[i]==ZONE_TURNCOAT && zone_show_turncoat==false)
         continue;
      string s = "";
      //name sup
      if(zone_type[i]==ZONE_SUPPORT)
         s="SSSR#S"+i+" Strength=";
      else
      //name res
         s="SSSR#R"+i+" Strength=";

      if(zone_strength[i]==ZONE_PROVEN)
         s=s+"Proven, Test Count="+zone_hits[i];
      else if(zone_strength[i]==ZONE_VERIFIED)
         s=s+"Verified, Test Count="+zone_hits[i];
      else if(zone_strength[i]==ZONE_UNTESTED)
         s=s+"Untested";
      else if(zone_strength[i]==ZONE_TURNCOAT)
         s=s+"Turncoat";
      else
         s=s+"Weak";

      ObjectCreate(s,OBJ_RECTANGLE,0,0,0,0,0);
      ObjectSet(s,OBJPROP_TIME1,iTime(_Symbol, time_Frame,zone_start[i]));
      ObjectSet(s,OBJPROP_TIME2,iTime(_Symbol, time_Frame, 0));
      ObjectSet(s,OBJPROP_PRICE1,zone_hi[i]);
      ObjectSet(s,OBJPROP_PRICE2,zone_lo[i]);
      ObjectSet(s,OBJPROP_BACK,zone_solid);
      ObjectSet(s,OBJPROP_WIDTH,zone_linewidth);
      ObjectSet(s,OBJPROP_STYLE,zone_style);

      if(zone_type[i]==ZONE_SUPPORT)
        {
         test0+= "(ZONE SUPPORT) zone_hi: " + zone_hi[i] + " | zone_lo: " + zone_lo[i] +"\n";
         // support zone
         if(zone_strength[i]==ZONE_TURNCOAT)
            ObjectSet(s,OBJPROP_COLOR,color_support_turncoat);
         else if(zone_strength[i]==ZONE_PROVEN)
            ObjectSet(s,OBJPROP_COLOR,color_support_proven);
         else if(zone_strength[i]==ZONE_VERIFIED)
            ObjectSet(s,OBJPROP_COLOR,color_support_verified);
         else if(zone_strength[i]==ZONE_UNTESTED)
            ObjectSet(s,OBJPROP_COLOR,color_support_untested);
         else
            ObjectSet(s,OBJPROP_COLOR,color_support_weak);
        }
      else
        {
         test0+= "(ZONE RESISTANCE) zone_hi: " + zone_hi[i] + " | zone_lo: " + zone_lo[i] +"\n";
         // resistance zone
         if(zone_strength[i]==ZONE_TURNCOAT)
            ObjectSet(s,OBJPROP_COLOR,color_resist_turncoat);
         else if(zone_strength[i]==ZONE_PROVEN)
            ObjectSet(s,OBJPROP_COLOR,color_resist_proven);
         else if(zone_strength[i]==ZONE_VERIFIED)
            ObjectSet(s,OBJPROP_COLOR,color_resist_verified);
         else if(zone_strength[i]==ZONE_UNTESTED)
            ObjectSet(s,OBJPROP_COLOR,color_resist_untested);
         else
            ObjectSet(s,OBJPROP_COLOR,color_resist_weak);
        }


      if(SetGlobals==true)
        {
         GlobalVariableSet("SSSR_HI_"+Symbol()+time_Frame+i,zone_hi[i]);
         GlobalVariableSet("SSSR_LO_"+Symbol()+time_Frame+i,zone_lo[i]);
         GlobalVariableSet("SSSR_HITS_"+Symbol()+time_Frame+i,zone_hits[i]);
         GlobalVariableSet("SSSR_STRENGTH_"+Symbol()+time_Frame+i,zone_strength[i]);
         GlobalVariableSet("SSSR_AGE_"+Symbol()+time_Frame+i,zone_start[i]);
        }

      //nearest zones
      if(zone_lo[i]>lower_nerest_zone_P2 && Bid>zone_lo[i]) {lower_nerest_zone_P1=zone_hi[i];lower_nerest_zone_P2=zone_lo[i];}
      if(zone_hi[i]<higher_nerest_zone_P1 && Bid<zone_hi[i]) {higher_nerest_zone_P1=zone_hi[i];higher_nerest_zone_P2=zone_lo[i];}
     }

   ner_hi_zone_P1[0]=higher_nerest_zone_P1;
   ner_hi_zone_P2[0]=higher_nerest_zone_P2;
   ner_lo_zone_P1[0]=lower_nerest_zone_P1;
   ner_lo_zone_P2[0]=lower_nerest_zone_P2;
   Comment(test0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Fractal(int M,int P,int shift)
  {
   if(time_Frame>P)
      P=time_Frame;

   P=P/time_Frame*2+MathCeil(P/time_Frame/2);

   if(shift<P)
      return(false);

   if(shift>Bars-P)
      return(false);

   for(int i=1; i<=P; i++)
     {
      if(M==UP_POINT)
        {
         if(iHigh(_Symbol, time_Frame, shift+i)>iHigh(_Symbol, time_Frame, shift))
            return(false);
         if(iHigh(_Symbol, time_Frame, shift-i)>=iHigh(_Symbol, time_Frame, shift))
            return(false);
        }
      if(M==DN_POINT)
        {
         if(iLow(_Symbol, time_Frame, shift+i)<iLow(_Symbol, time_Frame, shift))
            return(false);
         if(iLow(_Symbol, time_Frame, shift-i)<=iLow(_Symbol, time_Frame, shift))
            return(false);
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FastFractals()
  {
   int shift;
   int limit=MathMin(Bars-1,BackLimit);
   int P=time_Frame*fractal_fast_factor;

   FastUpPts[0] = 0.0; FastUpPts[1] = 0.0;
   FastDnPts[0] = 0.0; FastDnPts[1] = 0.0;

   for(shift=limit; shift>1; shift--)
     {
      if(Fractal(UP_POINT,P,shift)==true)
         FastUpPts[shift]=iHigh(_Symbol, time_Frame, shift);
      else
         FastUpPts[shift]=0.0;

      if(Fractal(DN_POINT,P,shift)==true)
         FastDnPts[shift]=iLow(_Symbol, time_Frame, shift);
      else
         FastDnPts[shift]=0.0;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SlowFractals()
  {
   int shift;
   int limit=MathMin(Bars-1,BackLimit);
   int P=time_Frame*fractal_slow_factor;

   SlowUpPts[0] = 0.0; SlowUpPts[1] = 0.0;
   SlowDnPts[0] = 0.0; SlowDnPts[1] = 0.0;

   for(shift=limit; shift>1; shift--)
     {
      if(Fractal(UP_POINT,P,shift)==true)
         SlowUpPts[shift]=iHigh(_Symbol, time_Frame, shift);
      else
         SlowUpPts[shift]=0.0;

      if(Fractal(DN_POINT,P,shift)==true)
         SlowDnPts[shift]=iLow(_Symbol, time_Frame, shift);
      else
         SlowDnPts[shift]=0.0;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteZones()
  {
   int len=5;
   int i;

   while(i<ObjectsTotal())
     {
      string objName=ObjectName(i);
      if(StringSubstr(objName,0,len)!="SSSR#")
        {
         i++;
         continue;
        }
      ObjectDelete(objName);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteGlobalVars()
  {
   if(SetGlobals==false)
      return;

   GlobalVariableDel("SSSR_Count_"+Symbol()+time_Frame);
   GlobalVariableDel("SSSR_Updated_"+Symbol()+time_Frame);

   int old_count=zone_count;
   zone_count=0;
   DeleteOldGlobalVars(old_count);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteOldGlobalVars(int old_count)
  {
   if(SetGlobals==false)
      return;

   for(int i=zone_count; i<old_count; i++)
     {
      GlobalVariableDel("SSSR_HI_"+Symbol()+time_Frame+i);
      GlobalVariableDel("SSSR_LO_"+Symbol()+time_Frame+i);
      GlobalVariableDel("SSSR_HITS_"+Symbol()+time_Frame+i);
      GlobalVariableDel("SSSR_STRENGTH_"+Symbol()+time_Frame+i);
      GlobalVariableDel("SSSR_AGE_"+Symbol()+time_Frame+i);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+