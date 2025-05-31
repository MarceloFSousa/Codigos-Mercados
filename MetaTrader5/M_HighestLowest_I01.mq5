//+------------------------------------------------------------------+
//|                                                    MarceloFSousa |
//|                                           https://www.a4t.com.br |
//+------------------------------------------------------------------+
#property copyright "MarceloFSousa"
#property link "https://www.a4t.com.br"
#property description "https://www.a4t.com.br"
#property version   "1.00"
#property indicator_chart_window
#property script_show_inputs

#property indicator_buffers 2
#property indicator_plots   2
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property indicator_type1   DRAW_LINE
#property indicator_label1  "Highest"
#property indicator_style1  STYLE_SOLID
#property indicator_color1  C'29,133,35'
#property indicator_width1  3
//---
#property indicator_type2   DRAW_LINE
#property indicator_label2  "Lowest"
#property indicator_style2  STYLE_SOLID
#property indicator_color2  C'255,0,85'
#property indicator_width2  3
//---
input int inpPeriodo  = 15;                        // Periodo
//---
//---- Indicator buffers
double lowestBuffer[], highestBuffer[];
//---
int bars_total = -1;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(1, lowestBuffer,INDICATOR_DATA);
   SetIndexBuffer(0, highestBuffer,INDICATOR_DATA);

   ArraySetAsSeries(lowestBuffer, true);
   ArraySetAsSeries(highestBuffer, true);
   IndicatorSetString(INDICATOR_SHORTNAME, "HL");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(high,true);

   int shift = rates_total - (inpPeriodo + 1);
   if(prev_calculated > 0)
      shift = (rates_total - prev_calculated) + 1;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   for(int i = shift; i >= 0; i--)
     {
      int lowestIndex = iLowest(_Symbol, _Period, MODE_LOW, inpPeriodo, i);
      double lowest = iLow(_Symbol, _Period, lowestIndex);
      lowestBuffer[i] = lowest;
      //---
      int highestIndex = iHighest(_Symbol, _Period, MODE_HIGH, inpPeriodo, i);
      double highest = iHigh(_Symbol, _Period, highestIndex);
      highestBuffer[i] = highest;
     }

   return(rates_total);
  }
  
//+------------------------------------------------------------------+
