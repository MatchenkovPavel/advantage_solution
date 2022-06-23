using HTTP
using JSON
using YAML


function get_data(url)
    response = HTTP.get(url)
    data = JSON.parse(String(response.body))
end

data = get_data("https://api.exchange.coinbase.com/products")
tickers = Dict()
for i in 1:length(data)
    if data[i]["trading_disabled"] == false
        key = split(data[i]["id"],"-")[1]
        if haskey(tickers, key) == true
            push!(tickers[key], replace(data[i]["id"], '-' => ""))
        else
            tickers[key] = Vector()
            push!(tickers[key], replace(data[i]["id"], '-' => ""))
        end
    end
end

#instruments = Dict()
#instruments["spot"] = tickers
YAML.write_file("coinbase.yml", tickers)


