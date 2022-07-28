### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 9eb3d190-0421-11ed-3ca8-697c04326a2d
using PyCall

# ╔═╡ 40739454-c1de-4e03-9808-393aa141aec1
using PlutoUI

# ╔═╡ 3749df94-1b9f-4004-b7d0-c9fedb1bba3f
using HypertextLiteral

# ╔═╡ e5cce08c-3a8a-44c8-824d-fb5bd34b56f9
using JuMP

# ╔═╡ 908fa649-81d8-4a18-a3f7-4d711eb90f08
using PlutoLinks

# ╔═╡ 23f87e45-d35f-49df-b855-b7d338470823
using Dates

# ╔═╡ f5a4cfbf-ea0e-45f9-86e2-f80362c5b0e7
#pip3 install -r requirements.txt

# ╔═╡ 0e20a115-ad8e-4c9e-b2d9-a4f0c6119054
md"""
#### Réception des données V,e en provenance de app.py (via in.py qui modifie le fichier in.txt si les données changent)
* L'envoi API → in.py a été réalisé dans app.py

```python
submitted = st.form_submit_button("Submit")   #  "send" action from client
    if submitted:
        block = Block1(volume=V, epaisseur=e)  # data to be transfered	
        client = SpeckleClient(host="https://speckle.xyz/")#client must be registered
        new_stream_id="36b6a4554d" #id specific for these data:ToyExampleV2_APIJulia
        account = get_default_account()
        client.authenticate_with_account(account)
        transport = ServerTransport(client=client, stream_id=new_stream_id)
        hash = operations.send(base=block, transports=[transport])
        commid_id = client.commit.create(
            stream_id=new_stream_id, 
            object_id=hash, 
            message="V and e transmission",
            )
        st.write("Les nouvelles données ont été reçues")
```
et in.py les reçoit et les stocke dans in.txt:
```python
if a != st.session_state.ID:  # the state of ID has changed 
    st.session_state.ID=a   
    st.write(st.session_state.ID)  #info to API (for debug information)
    file1 = open("in.txt", "w")     # new ID saved in in.txt
    file1.write(a+" \n"+str(b)+"\n"+str(c))
    file1.close()
```
toy_example_v2.jl récupère ces données en cas de changement du fichier in.txt
```julia
my_file=pwd()*"\\in.txt
file_content = @use_file(my_file)
```

"""

# ╔═╡ b64ca4a9-92a7-4945-b540-03253076787e
begin

#@async file_content =   read(pwd()*"\\in.txt")
end	

# ╔═╡ f8c7166f-9216-48bc-be73-641bcc652ce9
begin

 #data_change=Dates.unix2datetime(mtime((pwd()*"\\in.txt")))
end

# ╔═╡ 04e7fe7a-4e6e-4b67-acf2-940db32578a5
md"""
Nouveau design: on nne lance la modélisation et GH que si la requête est nouvelle
"""

# ╔═╡ 7ca705dd-3906-4936-97d6-0b4a052ec2c5
my_in_file=  pwd()*"\\commit.txt"           # pwd()*"\\in.txt"

# ╔═╡ 622d8cfc-177c-42a3-be2e-9cd768cf8c30
 @use_file(my_in_file)

# ╔═╡ f784480f-2fe6-48f4-a8c4-549f42d6cdc3
begin
	@use_file(my_in_file)
	file_content =   @use_file(my_in_file)
	file_content1 =   @use_file(my_in_file)
	if file_content != file_content1
	   	file_content3= @use_file(my_in_file)
	else
		file_content3=file_content
	end
	
end
	
	

# ╔═╡ 4db62b3d-c8a9-4cff-97a0-70ce16b0a51e
file_content3

# ╔═╡ 739da1cf-9264-4660-a55e-fdddb4cf3297
begin
	sleep(1)
	received_data=split(file_content3,"\r\n")
	received_data=received_data[end-1]
	received_data=split(received_data,",")
end

# ╔═╡ dfa3e35d-970d-4d95-9c3e-53cef27c54b2
received_data[end-1]

# ╔═╡ 4440f44a-69e2-4a6f-98c4-42e1860f0161
received_data[1]

# ╔═╡ 76b72def-3e69-4e99-a1e2-18903ea9e89f
md"""
Il y a un décalage d'un indice dans les données reçues (commit_id en plus en index 1)
"""

# ╔═╡ c6e573e6-d994-4d5c-9e70-9ba0df69662b
received_data

# ╔═╡ 1b651911-efd8-4f79-bf16-63df96dff3d1
begin
     commit_id=received_data[1]
	received_id=received_data[2]#received_data[1]
	V= parse(Float64,received_data[3]) #parse(Float64,received_data[2])
	épaisseur=parse(Float64, received_data[4]) #parse(Float64, received_data[3])
	"Volume= "*"$(V)"*", épaisseur="*"$(épaisseur)"*", commit ID: "*"$(commit_id)" 
end

# ╔═╡ c4ea0c3e-d720-4666-bc09-3bfc2e115b14
begin
	totaltime, totallines = open(my_in_file) do f
	    linecounter = 0
	    timetaken = @elapsed for l in eachline(f)
	        linecounter += 1
	    end
    (timetaken, linecounter)
	end
previousrun=[]
  # data associés à une requête identique si l'objet (received_data[2]) est présent dans commit.txt
open(my_in_file) do file
    for ln in 1:totallines-1
		temp=readline(file)
        if occursin(received_data[2], temp)
			previousrun=ln,temp
			break # inutile de chercher davantage...
		end
    end
end
	
end
	


# ╔═╡ 5e27aae7-29fe-4861-ba52-68e7dffd7da2
previousrun

# ╔═╡ 373d2d43-3658-442c-b47e-973e153c70dc
md"""
On ne lance l'optimisation que si elle n'a pas été faite. On peut rechercher l'objet ID dans les commits (on peut faire ce traitement dans in.py ou dans toy_example_v2.jl). Nous choisissons Julia pour sa rapidité. Lecture de $(totallines)
lignes en $(totaltime) secondes !
"""

# ╔═╡ a87033ad-52a9-4777-8859-6081df1462b4


# ╔═╡ b5c604d2-67ec-4e89-b9df-6a3ce96299da
begin
	if previousrun !=[]
		"coucou"
	end
end

# ╔═╡ 50b83ab9-6f75-458e-9121-b667fa9c78f8


# ╔═╡ 800b3df5-8ba0-4d78-945f-b91c5357c29d
md"""
### Optimisation avec contraintes
"""

# ╔═╡ ebc0d851-fafc-44ae-b503-17a50904bd27
import Ipopt

# ╔═╡ 4d970cf0-35e9-4554-a849-b71fb8e4eefc
begin
	if previousrun ==[]
		e=épaisseur # épaisseur du verre
		model = Model(Ipopt.Optimizer)
		r,h= nothing, nothing # clear the julia variables
		@variable(model, r >= e)  # le rayon
		@variable(model, h >= e) # la hauteur
		vol=V  # volume objectif cm3
		
		@NLobjective(model, Min,π*r^2*e+π*(r^2-(r-e)^2)*(h-e))  # le volume de la part matière est à minimiser
		# On calcule le volume intérieur du verre
		@NLconstraint(model, c, π*(r-e)^2*(h-e)== vol) # "c" est le nom de la contrainte
		#@NLconstraint(model, c1, r>=e) # 
		optimize!(model);
	
		r=value(r)  # variable à nouveau julia
		h=value(h)
	    [r,h,π*(r-e)^2*(h-e)]  # volume calculé. L'optimum correspond à r=h !
	end
end

# ╔═╡ f9b35fb4-3022-4bbf-aa82-4d4a0f9add6a
string((string(r),string(h),string(e)))

# ╔═╡ 4bae178c-81f3-4365-abd9-9109fd8bcf11
V

# ╔═╡ 83bd5ef9-d4c2-413d-a8a2-5e2d55c11615
md"""
### Transmission des données vers Grasshopper et l'API
"""

# ╔═╡ 16726266-fc65-4525-b009-58090127c44a
r

# ╔═╡ daa90290-b991-47fc-babf-97d3daf7e5a3
previousrun

# ╔═╡ a549d05e-6ea6-4556-a65c-5243915021b2
begin
	if previousrun==[]
	 	fromJulia="b4fdac11b9" #"36b6a4554d" #"5cd63d05d1"  
		py"""from specklepy.objects import Base
from specklepy.api.client import SpeckleClient 
from specklepy.api.credentials import get_default_account
from specklepy.transports.server.server import ServerTransport
from specklepy.api import operations
		
class Block2(Base):
	e: float
	h: float
	r: float
	v: float
			
		
	def __init__(self, e=0.1,h=1.0,r=1.1,v=10.0, **kwargs) -> None:
		super().__init__(**kwargs)
		self.r = r
		self.e =e
		self.h=h
		self.v=v
				
		
block2 = Block2(e=$(e),h=$(h) ,r=$(r) ,v=$(V))
		# next create a server transport
client = SpeckleClient(host="https://speckle.xyz/")
		
new_stream_id=$(fromJulia) # spécifique au projet	
account = get_default_account()
client.authenticate_with_account(account)
transport = ServerTransport(client=client, stream_id=new_stream_id)
				
		# this serialises the block and sends it to the transport
hash = operations.send(base=block2, transports=[transport])
commid_id = client.commit.create(
		stream_id=new_stream_id, 
		object_id=hash, 
		message="result of optimization",
		)
		"""
	end

	py"hash"
end

# ╔═╡ 84da22af-9f73-4021-bb8e-fe5dc064f197
py"""object_id"""

# ╔═╡ 3c06b8b2-9c65-4cb6-abd9-f0a29c33fffc


# ╔═╡ 719e85b2-dfdd-4791-8e05-3f76617467a1


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Ipopt = "b6b21f68-93f8-5de0-b562-5493be1d77c9"
JuMP = "4076af6c-e467-56ae-b986-b466b2749572"
PlutoLinks = "0ff47ea0-7a50-410d-8455-4348d5de0420"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"

[compat]
HypertextLiteral = "~0.9.4"
Ipopt = "~1.0.3"
JuMP = "~1.1.1"
PlutoLinks = "~0.1.5"
PlutoUI = "~0.7.39"
PyCall = "~1.93.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.ASL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6252039f98492252f9e47c312c8ffda0e3b9e78d"
uuid = "ae81ac8f-d209-56e5-92de-9978fef736f9"
version = "0.1.3+0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "4c10eee4af024676200bc7752e536f858c6b8f93"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.1"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "2dd813e5f2f7eec2d1268c57cf2373d3ee91fcea"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.1"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "6d4fa04343a7fc9f9cb9cff9558929f3d2752717"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.0.9"

[[deps.CodecBzip2]]
deps = ["Bzip2_jll", "Libdl", "TranscodingStreams"]
git-tree-sha1 = "2e62a725210ce3c3c2e1a3080190e7ca491f18d7"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.7.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "924cdca592bc16f14d2f7006754a621735280b74"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.1.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6e47d11ea2776bc5627421d59cdcc1296c058071"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.7.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "28d605d9a0ac17118fe2c5e9ce0fbb76c3ceb120"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.11.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "2f18915445b248731ec5db4e4a17e451020bf21e"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.30"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

[[deps.Ipopt]]
deps = ["Ipopt_jll", "MathOptInterface"]
git-tree-sha1 = "4e57e747abbb426e650afafda2265edcbb576231"
uuid = "b6b21f68-93f8-5de0-b562-5493be1d77c9"
version = "1.0.3"

[[deps.Ipopt_jll]]
deps = ["ASL_jll", "Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "MUMPS_seq_jll", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "e3e202237d93f18856b6ff1016166b0f172a49a8"
uuid = "9cc047cb-c261-5740-88fc-0cf96f7bdcc7"
version = "300.1400.400+0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JuMP]]
deps = ["Calculus", "DataStructures", "ForwardDiff", "LinearAlgebra", "MathOptInterface", "MutableArithmetics", "NaNMath", "OrderedCollections", "Printf", "SparseArrays", "SpecialFunctions"]
git-tree-sha1 = "534adddf607222b34a0a9bba812248a487ab22b7"
uuid = "4076af6c-e467-56ae-b986-b466b2749572"
version = "1.1.1"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "52617c41d2761cc05ed81fe779804d3b7f14fff7"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.13"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "dedbebe234e06e1ddad435f5c6f4b85cd8ce55f7"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.2.2"

[[deps.METIS_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "1d31872bb9c5e7ec1f618e8c4a56c8b0d9bddc7e"
uuid = "d00139f3-1899-568f-a2f0-47f597d42d70"
version = "5.1.1+0"

[[deps.MUMPS_seq_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "METIS_jll", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "29de2841fa5aefe615dea179fcde48bb87b58f57"
uuid = "d7ed1dd3-d0ae-5e8e-bfb4-87a502085b8d"
version = "5.4.1+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MathOptInterface]]
deps = ["BenchmarkTools", "CodecBzip2", "CodecZlib", "DataStructures", "ForwardDiff", "JSON", "LinearAlgebra", "MutableArithmetics", "NaNMath", "OrderedCollections", "Printf", "SparseArrays", "SpecialFunctions", "Test", "Unicode"]
git-tree-sha1 = "10d26d62dab815306bbd2c46eb52460e98f01e46"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "1.6.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "4e675d6e9ec02061800d6cfb695812becbd03cdf"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.0.4"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS32_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c6c2ed4b7acd2137b878eb96c68e63b76199d0f"
uuid = "656ef2d0-ae68-5445-9ca0-591084a874a2"
version = "0.3.17+0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "0e8bcc235ec8367a8e9648d48325ff00e4b0a545"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "1fc929f47d7c151c839c5fc1375929766fb8edcc"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.93.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "4d4239e93531ac3e7ca7e339f15978d0b5149d03"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.3.3"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "e972716025466461a3dc1588d9168334b71aafff"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.1"

[[deps.StaticArraysCore]]
git-tree-sha1 = "66fe9eb253f910fe8cf161953880cfdaef01cdf0"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.0.1"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═9eb3d190-0421-11ed-3ca8-697c04326a2d
# ╠═40739454-c1de-4e03-9808-393aa141aec1
# ╠═3749df94-1b9f-4004-b7d0-c9fedb1bba3f
# ╠═e5cce08c-3a8a-44c8-824d-fb5bd34b56f9
# ╠═908fa649-81d8-4a18-a3f7-4d711eb90f08
# ╠═23f87e45-d35f-49df-b855-b7d338470823
# ╠═f5a4cfbf-ea0e-45f9-86e2-f80362c5b0e7
# ╟─0e20a115-ad8e-4c9e-b2d9-a4f0c6119054
# ╠═b64ca4a9-92a7-4945-b540-03253076787e
# ╠═622d8cfc-177c-42a3-be2e-9cd768cf8c30
# ╠═f784480f-2fe6-48f4-a8c4-549f42d6cdc3
# ╠═4db62b3d-c8a9-4cff-97a0-70ce16b0a51e
# ╠═739da1cf-9264-4660-a55e-fdddb4cf3297
# ╠═dfa3e35d-970d-4d95-9c3e-53cef27c54b2
# ╠═f8c7166f-9216-48bc-be73-641bcc652ce9
# ╠═4440f44a-69e2-4a6f-98c4-42e1860f0161
# ╠═04e7fe7a-4e6e-4b67-acf2-940db32578a5
# ╠═7ca705dd-3906-4936-97d6-0b4a052ec2c5
# ╟─76b72def-3e69-4e99-a1e2-18903ea9e89f
# ╠═c6e573e6-d994-4d5c-9e70-9ba0df69662b
# ╟─1b651911-efd8-4f79-bf16-63df96dff3d1
# ╠═5e27aae7-29fe-4861-ba52-68e7dffd7da2
# ╟─373d2d43-3658-442c-b47e-973e153c70dc
# ╠═c4ea0c3e-d720-4666-bc09-3bfc2e115b14
# ╠═a87033ad-52a9-4777-8859-6081df1462b4
# ╠═b5c604d2-67ec-4e89-b9df-6a3ce96299da
# ╠═f9b35fb4-3022-4bbf-aa82-4d4a0f9add6a
# ╠═50b83ab9-6f75-458e-9121-b667fa9c78f8
# ╟─800b3df5-8ba0-4d78-945f-b91c5357c29d
# ╠═ebc0d851-fafc-44ae-b503-17a50904bd27
# ╠═4d970cf0-35e9-4554-a849-b71fb8e4eefc
# ╠═4bae178c-81f3-4365-abd9-9109fd8bcf11
# ╟─83bd5ef9-d4c2-413d-a8a2-5e2d55c11615
# ╠═16726266-fc65-4525-b009-58090127c44a
# ╠═daa90290-b991-47fc-babf-97d3daf7e5a3
# ╠═a549d05e-6ea6-4556-a65c-5243915021b2
# ╠═84da22af-9f73-4021-bb8e-fe5dc064f197
# ╠═3c06b8b2-9c65-4cb6-abd9-f0a29c33fffc
# ╠═719e85b2-dfdd-4791-8e05-3f76617467a1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
