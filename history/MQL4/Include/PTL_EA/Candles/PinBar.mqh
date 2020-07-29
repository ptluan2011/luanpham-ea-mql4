//+------------------------------------------------------------------+
//|                                                       PinBar.mqh |
//|                                       Copyright 2019, Luan Pham. |
//|                                     http://www.phamthanhluan.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Luan Pham."
#property link      "http://www.phamthanhluan.com"
#property strict

string LayPinBar(int timeFrame, int maxBar = 3)
{  
   int counter=0;
   //double poslGap=0.0;
   int pos = 0;
   double dayRange = 0.0;
   while(pos < maxBar )
   {
      //addInfo=false;
      if (IsBuyPinbar(dayRange,pos))
      {
         return "Co pin bar dao chieu TANG gia tai nen thu " + pos;
      }
      if (IsSellPinbar(dayRange,pos))
      {
         return "Co pin bar dao chieu GIAM gia tai nen thu " + pos;
      } 
      pos++;
   }
      
   return("");
}


//+------------------------------------------------------------------+
//| User function IsPinbar                                           |
//+------------------------------------------------------------------+
bool IsBuyPinbar(double& dayRange, int pos)
{
   //start of declarations
   double actOp,actCl,actHi,actLo,preHi,preLo,preCl,preOp,actRange,preRange,actHigherPart,actHigherPart1;
   actOp=Open[pos+1];
   actCl=Close[pos+1];
   actHi=High[pos+1];
   actLo=Low[pos+1];
   preOp=Open[pos+2];
   preCl=Close[pos+2];
   preHi=High[pos+2];
   preLo=Low[pos+2];
   actRange=actHi-actLo;
   preRange=preHi-preLo;
   actHigherPart=actHi-actRange*0.4;//helping variable to not have too much counting in IF part
   actHigherPart1=actHi-actRange*0.4;//helping variable to not have too much counting in IF part
   //end of declaratins
   //start function body
   dayRange=AveRange4(pos);
   if((actCl>actHigherPart1&&actOp>actHigherPart)&&  //Close&Open of PB is in higher 1/3 of PB
      (actRange>dayRange*0.5)&& //PB is not too small
      //(actHi<(preHi-preRange*0.3))&& //High of PB is NOT higher than 1/2 of previous Bar
      (actLo+actRange*0.25<preLo)) //Nose of the PB is at least 1/3 lower than previous bar
   {
    
      if(Low[ArrayMinimum(Low,3,pos+3)]>Low[pos+1])
         return (true);
   }
   return(false);
   
}//------------END FUNCTION-------------


bool IsSellPinbar(double& dayRange, int pos)
{
   //start of declarations
   double actOp,actCl,actHi,actLo,preHi,preLo,preCl,preOp,actRange,preRange,actLowerPart, actLowerPart1;
   actOp=Open[pos+1];
   actCl=Close[pos+1];
   actHi=High[pos+1];
   actLo=Low[pos+1];
   preOp=Open[pos+2];
   preCl=Close[pos+2];
   preHi=High[pos+2];
   preLo=Low[pos+2];
   //SetProxy(preHi,preLo,preOp,preCl);//Check proxy
   actRange=actHi-actLo;
   preRange=preHi-preLo;
   actLowerPart=actLo+actRange*0.4;//helping variable to not have too much counting in IF part
   actLowerPart1=actLo+actRange*0.4;//helping variable to not have too much counting in IF part
   //end of declaratins
   
   //start function body

   dayRange=AveRange4(pos);
   if((actCl<actLowerPart1&&actOp<actLowerPart)&&  //Close&Open of PB is in higher 1/3 of PB
      (actRange>dayRange*0.5)&& //PB is not too small
      //(actLo>(preLo+preRange/3.0))&& //Low of PB is NOT lower than 1/2 of previous Bar
      (actHi-actRange*0.25>preHi)) //Nose of the PB is at least 1/3 lower than previous bar
      
   {
      if(High[ArrayMaximum(High,3,pos+3)]<High[pos+1])
         return (true);
   }
   return(false);
}//------------END FUNCTION-------------

double AveRange4(int pos)
{
   double sum;
   double rangeSerie[4];
   
   int i=0;
   int ind=1;
   int startYear=1995;
   int den;
   
   if(pos<=0)den=1;
   else den = pos;
   if (TimeYear(Time[den-1])>=startYear)
   {
      while (i<4)
      {
         //datetime pok=Time[pos+ind];
         if(TimeDayOfWeek(Time[pos+ind])!=0)
         {
            sum+=High[pos+ind]-Low[pos+ind];//make summation
            i++;
         }
         ind++;   
         //i++;
      }
      //Comment(sum/4.0);
      return (sum/4.0);//make average, don't count min and max, this is why I divide by 4 and not by 6
   } 
      return (50*Point);
   
}//------------END FUNCTION-------------

