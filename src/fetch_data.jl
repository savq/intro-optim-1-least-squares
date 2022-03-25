# Fetch financial data for the commodities analysed in the notebook from the
# Yahoo Finance API, and write it to CSVs.
#
# Note that the Yahoo finance API requires an API key. You can get an API key by
# creating an account on yahoofinanceapi.com . After getting the API key, you
# should set it as an environment variable:
# export YAHOOFINANCE_TOKEN='...'

using Dates

using CSV
using DataFrames
using Stonks    # package for financial data retrieval

function main()
    dir = "./data/"
    !isdir(dir) && mkdir(dir)

    api_key = ENV["YAHOOFINANCE_TOKEN"]  # Will throw exception if YAHOOFINANCE_TOKEN wasn't defined
    client = YahooClient(api_key)

    to = Date(2022, 03, 21)
    from = to - Year(1)

    stocks = Dict(
        "bitcoin" => "BTC-USD",
        "gold" => "GC=F",
        "silver" => "SI=F",
        "crude" => "CL=F",
    )

    for (name, ticker_symbol) in pairs(stocks)
        time_series = get_price(ticker_symbol, client; from=from, to=to)
        df = select!(DataFrame(time_series), ["date", "close"]) # we're only interested in the closing value
        path = "$dir$name.csv"
        CSV.write(path, df)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
