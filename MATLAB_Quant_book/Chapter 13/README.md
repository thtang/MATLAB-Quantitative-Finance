## Metrics
calculate the following for each asset and portfolio (you align pnls for different assets, and sum them together to get the portfolio pnl).
* Volatility = Std(daily return). (We expect that different assets deliver comparable volatility.)
* SR = average(daily return) / std(daily return) * sqrt(250)  (On this large set of currencies, we expect a SR close to 1.)
* Holding period = avg(abs(position)) / avg(abs(diff(position)). You do this for each asset, and average the holding period across asset to get the portfolio holding period.

**Accounting**

Assume the following.

* On day t-1, you hold a position Pos(t-1)
* Price on day t-1 and t is respectively Px(t-1) and Px(t), in £ (foreign currency).
* FX rate $/£ on t is FX(t). For convenience, you can keep an FX series for each asset, so that you can apply the same accounting formula.
* For USDXXX (nominated in foreign currency), FX(t) = 1/Px(t)
* For XXXUSD (nominated in USD), FX(t)=1 

You can make a table like this and save it in a csv file.
 
Cumulative pnl graph
* Print pnl of portfolio and assets and save them in a pdf. (something like below, with timeline in the X-axis.)
* Accounting formula. Pnl (in $) on t equals Pnl(t) = Pos(t-1) x [Px(t) - Px(t-1)] x FX(t)




 


### Reference
[【live笔记】带你重新认识海龟交易策略, lostleaf](http://lostleaf.github.io/2019/09/11/%E5%B8%A6%E4%BD%A0%E9%87%8D%E6%96%B0%E8%AE%A4%E8%AF%86%E6%B5%B7%E9%BE%9F%E4%BA%A4%E6%98%93%E7%AD%96%E7%95%A5/)
