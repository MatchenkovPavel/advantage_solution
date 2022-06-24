using HTTP
using JSON
using YAML


function get_data(url)
    response = HTTP.get(url)
    data = JSON.parse(String(response.body))
end

data = get_data("https://api.kraken.com/0/public/AssetPairs")
keys_json = collect(keys(data["result"]))
spot_tickers = Dict() #(zip(keys_json,[]))
for key in keys_json
    if haskey(spot_tickers,data["result"][key]["base"]) == true
        push!(spot_tickers[data["result"][key]["base"]],key)
    else
        spot_tickers[data["result"][key]["base"]] = Vector()
        push!(spot_tickers[data["result"][key]["base"]],key)
    end
end


"""data = get_data("https://futures.kraken.com/derivatives/api/v3/tickers")
futures_tickers = Dict() #(zip(keys_json,[]))
for i in 1:(length(data["tickers"]) - 10) #strange end of json
    key = split(data["tickers"][i]["pair"],":")[1]
    if haskey(futures_tickers, key) == true
        push!(futures_tickers[key] , data["tickers"][i]["pair"])
    else
        futures_tickers[key] = Set()
        push!(futures_tickers[key], data["tickers"][i]["pair"])
    end
end"""


#instruments = Dict()
#instruments["futures"] = futures_tickers
#instruments["spot"] = spot_tickers

YAML.write_file("out/kraken.yml", spot_tickers)
