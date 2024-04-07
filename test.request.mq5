//+------------------------------------------------------------------+
//|                                                      TestRequest |
//|                                        https://github.com/Rojomr |
//+------------------------------------------------------------------+

input group "Data Trade";

input double LotSize = 1.0;

input uint StopLossInPoint = 15000;

input uint TakeProfitInPoint = 20000;

input uint MagicNumber = 666;

MqlRates Rates[];
#include <Trade/Trade.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   ArraySetAsSeries(Rates, true);

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {Comment("");}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick(void)
  {
   int CopiedRates = CopyRates(Symbol(), PERIOD_H1, 0, 72, Rates);

   if(CopiedRates < 0)
     {
      Print("Error: No posible copy rates into MqlRates.Rates");
     }

   int total = PositionsTotal();
   if(total > 0)
     {
      return;
     }

   if(
      Rates[1].close >= Rates[1].open &&
      Rates[2].close >= Rates[2].open &&
      Rates[3].close >= Rates[3].open &&
      Rates[4].close < Rates[4].open
   )
     {
      MqlTradeRequest request = {};
      MqlTradeResult result = {};
      
      request.action = TRADE_ACTION_DEAL;
      request.symbol = _Symbol;
      request.volume = LotSize;
      request.tp = ORDER_TYPE_BUY;
      request.type_filling = ORDER_FILLING_IOC;
      request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      request.sl = request.price - StopLossInPoint * _Point;
      request.tp = request.price + TakeProfitInPoint * _Point;
      request.deviation = 100;
      request.magic = MagicNumber;
      
      if(!OrderSend(request, result))
        {
         Print("Retcode: " + IntegerToString(result.retcode) + " " + result.comment);
        }
     }









   /*
   string VelaActual;

   if(Rates[0].close >= Rates[0].open)
     {
      VelaActual = "Bull";
     } else
         {
          VelaActual = "Bear";
         }

   string comment = StringFormat("Prices C: %.2f - O: %.2f | La vela actual es %s", Rates[0].close, Rates[0].open, VelaActual);

   Comment(comment);
   */
  }
//+------------------------------------------------------------------+
