//+------------------------------------------------------------------+
//|                                                      DojiBar.mqh |
//|                                       Copyright 2019, Luan Pham. |
//|                                     http://www.phamthanhluan.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Luan Pham."
#property link      "http://www.phamthanhluan.com"
#property strict


//---- input parameters for regular doji
bool      FindRegularDoji=true; //false to disable
int       MinLengthOfUpTail=3; //candle with upper tail equal or more than this will show up
int       MinLengthOfLoTail=3; //candle with lower tail equal or more than this will show up
double    MaxLengthOfBody=1; //candle with body less or equal with this will show up
     
//---- input parameters for dragonfly doji
bool      FindDragonflyDoji=true; //false to disable
int       MaxLengthOfUpTail1=0; //candle with upper tail equal or more than this will show up
int       MinLengthOfLoTail1=3; //candle with lower tail equal or more than this will show up
double    MaxLengthOfBody1=1; //candle with body less or equal with this will show up

//---- input parameters for gravestone doji
bool      FindGravestoneDoji=true; //false to disable
int       MinLengthOfUpTail2=3; //candle with upper tail equal or more than this will show up
int       MaxLengthOfLoTail2=0; //candle with lower tail equal or more than this will show up
double    MaxLengthOfBody2=1; //candle with body less or equal with this will show up

//---- initialization for variables

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int FindDoji(int timeFrame, int barNum = 1)//Trả về vị trí nến doji
{   
   double pt=0, pt1=0;
   if(Digits<4) pt=0.001;
   else pt=0.00001;
   if(Digits<4) pt1=0.001;
   else pt1=0.00001;
   int counter1=1, counter2=1, counter3=1;
   string name1="Doji", name2="Dragonfly", name3="Gravestone";
   double H, L, C, O;
   datetime T;
   for(int i = 1; i <= barNum; i++)
   {
      H = iHigh(_Symbol,timeFrame,i);
      L = iLow(_Symbol,timeFrame,i);
      C = iClose(_Symbol,timeFrame,i);
      O = iOpen(_Symbol,timeFrame,i);
      T = Time[i];
       if(FindRegularDoji)
         {
          if(H-C>=MinLengthOfUpTail*pt && C-L>=MinLengthOfLoTail*pt  && MathAbs(C-O)<=MaxLengthOfBody*pt) 
            {
              counter1++;
            }
         } 
       if(FindDragonflyDoji)
         {
          if(H-C<=MaxLengthOfUpTail1*pt && C-L>=MinLengthOfLoTail1*pt  && MathAbs(C-O)<=MaxLengthOfBody1*pt)
            {
             counter2++;
             
             }
         } 
       if(FindGravestoneDoji)
         {
          if(H-C>=MinLengthOfUpTail2*pt && C-L<=MaxLengthOfLoTail2*pt  && MathAbs(C-O)<=MaxLengthOfBody2*pt)
            {
             counter3++;
            }
         } 
      } 
   //if(Volume[0]>1) return(0);
   H=High[1]; L=Low[1]; C=Close[1]; O=Open[1];
   if(FindRegularDoji)
     {
      if(H-C>=MinLengthOfUpTail*pt && C-L>=MinLengthOfLoTail*pt && MathAbs(C-O)<=MaxLengthOfBody*pt) 
        {   
         Alert("new regular doji at ",Symbol()," M",Period());
        }
     }
   if(FindDragonflyDoji)
     {
      if(H-C<=MaxLengthOfUpTail1*pt && C-L>=MinLengthOfLoTail1*pt  && MathAbs(C-O)<=MaxLengthOfBody1*pt)
        {
         Alert("new dragonfly doji at ",Symbol()," M",Period()); 
        }
     }
   if(FindGravestoneDoji)
     {
      if(H-C>=MinLengthOfUpTail2*pt && C-L<=MaxLengthOfLoTail2*pt  && MathAbs(C-O)<=MaxLengthOfBody2*pt)
        {  
         Alert("new gravestone doji at ",Symbol()," M",Period());
        }
     }             
   return(0);
  } //end of file 
//+------------------------------------------------------------------+