//+------------------------------------------------------------------+
//|                                              M_StocDuplo_C01.mq5 |
//|                                                    MarceloFSousa |
//|                                           https://www.a4t.com.br |
//+------------------------------------------------------------------+
#property copyright "MarceloFSousa"
#property link      "https://www.a4t.com.br"
#property
#property indicator_separate_window
#property script_show_inputs

#property indicator_buffers 6
#property indicator_plots   6

#property indicator_level1 80
#property indicator_level2 20

#property indicator_label1  "Estoc_Curto"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrBlack
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

#property indicator_label2  "Sinal_Curto"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrCyan
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

#property indicator_label3  "Estoc_Longo"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrBlack
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1

#property indicator_label4  "Sinal_Longo"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrBlue
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1

input int     PeriodoStocC = 14; // Periodo estocastico curto
input int     MediaStocC = 3; // Periodo media estocastico curto
input int     SinalStocC = 3; // Periodo sinal estocastico curto

input int     PeriodoStocL = 84; // Periodo estocastico longo
input int     MediaStocL = 18; // Periodo media estocastico longo
input int     SinalStocL = 3; // Periodo sinal estocastico longo

double stocL[], stocC[], sinalStocL[], sinalStocC[];

int stocHandleL,stocHandleC;

datetime expiryDate = D'20.11.2050';

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
{
    if(TimeCurrent() > expiryDate)
    {
        Alert("Periodo expirado!");
        return(INIT_FAILED);
    }
    SetIndexBuffer(0,stocC,INDICATOR_DATA);
    SetIndexBuffer(1,sinalStocC,INDICATOR_DATA);
    SetIndexBuffer(2,stocL,INDICATOR_DATA);
    SetIndexBuffer(3,sinalStocL,INDICATOR_DATA);

    stocHandleC =iStochastic(_Symbol,_Period,PeriodoStocC,SinalStocC,MediaStocC,MODE_SMA,STO_LOWHIGH);
    stocHandleL =iStochastic(_Symbol,_Period,PeriodoStocL,SinalStocL,MediaStocL,MODE_SMA,STO_LOWHIGH);
    if(stocHandleL == INVALID_HANDLE || stocHandleC == INVALID_HANDLE)
    {
        Print("Handle invalido");
        return(INIT_FAILED);
    }

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

    int copiar = MathMin(rates_total, rates_total - prev_calculated + 1);

    if(CopyBuffer(stocHandleC, 0, 0, copiar, stocC)<=0)
    {
        return 0;
    }
    if(CopyBuffer(stocHandleC, 1, 0, copiar, sinalStocC)<=0)
    {
        return 0;
    }
    if(CopyBuffer(stocHandleL, 0, 0, copiar, stocL)<=0)
    {
        return 0;
    }
    if(CopyBuffer(stocHandleL, 1, 0, copiar, sinalStocL)<=0)
    {
        return 0;
    }

    return(rates_total);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
