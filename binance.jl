using HTTP
using JSON
using YAML


response = HTTP.get("https://api.binance.com/api/v3/exchangeInfo")
data = JSON.parse(String(response.body))


tickers = Dict()
for i in 1:length(data["symbols"])
    if data["symbols"][i]["status"] == "TRADING"
        key = data["symbols"][i]["baseAsset"]
        if haskey(tickers, key) == true
            push!(tickers[key] , data["symbols"][i]["symbol"])
        else
            tickers[key] = Vector()
            push!(tickers[key], data["symbols"][i]["symbol"])
        end
    end
end
#"permissions":["SPOT","MARGIN"]}


#instruments = Dict()
#instruments["spot"] = tickers

YAML.write_file("binance.yml", tickers)

