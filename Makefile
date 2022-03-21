.PHONY: run install fetch

run:
	julia --project='.' -e 'import IJulia; IJulia.notebook(dir=pwd())'

install:
	julia -e 'import Pkg; Pkg.activate("."); Pkg.instantiate()'

fetch:
	$(info API key is $(YAHOOFINANCE_TOKEN))
	julia --project='.' src/fetch_data.jl
