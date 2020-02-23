## Metrics
calculate the following for each asset and portfolio (you align pnls for different assets, and sum them together to get the portfolio pnl).
* Volatility = Std(daily return). (We expect that different assets deliver comparable volatility.)
* SR = average(daily return) / std(daily return) * sqrt(250)  (On this large set of currencies, we expect a SR close to 1.)
* Holding period = avg(abs(position)) / avg(abs(diff(position)). You do this for each asset, and average the holding period across asset to get the portfolio holding period.

 

You can make a table like this and save it in a csv file.
 
Cumulative pnl graph
* Print pnl of portfolio and assets and save them in a pdf. (something like below, with timeline in the X-axis.)
