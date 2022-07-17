### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 4c8f6863-0b35-4300-b0c3-62e88193e477
import Pkg

# ╔═╡ f4119b24-258c-403c-8fa7-61c5614d4893
Pkg.add("PlutoSliderServer")

# ╔═╡ 179338be-0063-11ed-07ce-f9b037d821d8
html"""
<style>
.requestBody, .responseBody {
	font-size: 0.7em;
}
</style>
"""

# ╔═╡ d93b3509-3b25-4692-bbdb-39fd070d7849
@bind x html"<input type=range>"


# ╔═╡ c268ff54-2ca3-4f23-89ff-2ae5716cc1a7
x

# ╔═╡ a171ab1e-3bc3-4fb9-a618-e045c059d53c
y=x^2

# ╔═╡ bbf6f5f6-186d-4455-83d2-ee450efb04c1
pwd()

# ╔═╡ Cell order:
# ╠═4c8f6863-0b35-4300-b0c3-62e88193e477
# ╠═f4119b24-258c-403c-8fa7-61c5614d4893
# ╠═179338be-0063-11ed-07ce-f9b037d821d8
# ╠═d93b3509-3b25-4692-bbdb-39fd070d7849
# ╠═c268ff54-2ca3-4f23-89ff-2ae5716cc1a7
# ╠═a171ab1e-3bc3-4fb9-a618-e045c059d53c
# ╠═bbf6f5f6-186d-4455-83d2-ee450efb04c1
