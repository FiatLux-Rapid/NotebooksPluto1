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

# ╔═╡ 0de9b7de-005e-11ed-13e0-d9281d99f9ce
html"""
<style>
.requestBody, .responseBody {
	font-size: 0.7em;
}
</style>
"""

# ╔═╡ 2a16ff91-35de-4fa0-ae97-b16d82b274fe
@bind x html"<input type=range>"

# ╔═╡ 120da078-7a75-4fb3-9954-b3f6d1d040bc
x

# ╔═╡ ebf278fc-a286-4d0b-9976-fa81e50b03ab
x^2

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╠═0de9b7de-005e-11ed-13e0-d9281d99f9ce
# ╠═2a16ff91-35de-4fa0-ae97-b16d82b274fe
# ╠═120da078-7a75-4fb3-9954-b3f6d1d040bc
# ╠═ebf278fc-a286-4d0b-9976-fa81e50b03ab
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
