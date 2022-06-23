using HTTP
using JSON
using YAML


function get_data(url)
    response = HTTP.get(url)
    data = JSON.parse(String(response.body))
end


function parse_json(data)
    tickers =Dict()
    for i in 1:length(data["data"])
        key = split(data["data"][i]["instId"],"-")[1]
        if haskey(tickers, key) == true
            push!(tickers[key] , replace(data["data"][i]["instId"], '-' => ""))
        else
            tickers[key] = Vector()
            push!(tickers[key], replace(data["data"][i]["instId"], '-' => ""))
        end
    end
    return tickers
end


spot = parse_json(get_data("https://www.okx.com/api/v5/market/tickers?instType=SPOT"))
#futures = parse_json(get_data("https://www.okx.com/api/v5/market/tickers?instType=FUTURES"))

instruments = Dict()
#instruments["futures"] = futures
#instruments["spot"] = spot

YAML.write_file("okex.yml", spot)
