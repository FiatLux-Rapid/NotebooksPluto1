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

# ╔═╡ 0202f4fc-e844-4ead-bc06-80b82049b94c
using PyCall

# ╔═╡ 2cb83c58-946a-4adb-9a7a-2538edd4306e
using PlutoUI

# ╔═╡ 650e857f-ddd3-4b42-b03b-630236408185
using HypertextLiteral

# ╔═╡ 3df83f70-f9a3-4e99-8081-0959060a112b
# reference: https://speckle.guide/dev/py-examples.html

# ╔═╡ f69af12a-c3b0-40e7-a92f-99a0b0760b33
#run(`pip install specklepy`)

# ╔═╡ e541f537-bc14-4d7d-8268-4b326da29135
md"""
## Connexion automatique julia --> Grasshopper
"""

# ╔═╡ 39349c4d-50b6-4f1f-ad56-f0ae27ac619c
md"""
### Passage de données: julia ⟶ python et  python ⟶  julia
"""


# ╔═╡ e58bf7c7-263b-488c-af68-d896c5164fd6
begin
	#convert julia to python
	myvar=3
	mysum=py"""1"""+py"1"+py"$(myvar)" # convert julia to python
	# convert python to julia
	py"""
	var=3
	"""
	z=py"var"
	py"var",mysum,typeof(z)  # py"var"  does not propagate between cells
end

# ╔═╡ 5e90ba42-3ecc-49f9-9fe9-9979fc9f5788
md"""
### Création d'un nouvel ID pour un objet speckle avec un nom de stream
L'ID doit être fournit à GH, la mise à jour est en temps réel.

Il est aussi possible d'accéder à un précédent envoi de données en rajoutant son commit 
"""

# ╔═╡ 9dc30624-7ba1-409d-af50-a43ca7dc3527
stream_name="Connexion Julia Grasshopper avec échanges de données"

# ╔═╡ b22f943e-9145-4e69-8b8e-c7d186db0551
old_stream_id="4a6bacb7a7" #https://speckle.xyz/streams/4a6bacb7a7/commits/f9beeaca00

# ╔═╡ e5319bd4-d52b-4d97-9142-6f656a5d18c9
@bind newID CheckBox()

# ╔═╡ a131fabd-a3a6-4329-9e4a-ad8f587fcbb2
	md""" **new ID** """  

# ╔═╡ dd1f9deb-7d4c-4c24-82da-e4875c183074
begin
		if newID
			
			py"""from specklepy.api.client import SpeckleClient
			from specklepy.api.credentials import get_default_account
			
			# initialise the client
			client = SpeckleClient(host="https://speckle.xyz/")
			#client = SpeckleClient(host="your-server.com") # or whatever your host is
			# client = SpeckleClient(host="localhost:3000", use_ssl=False) or use local server
			
			# authenticate the client with a token
			account = get_default_account()
			client.authenticate_with_account(account)
			
			# if you're in an environment without accounts, you can construct an Account object yourself
			# or authenticate with just a token
			# client.authenticate_with_token("YOUR_TOKEN")"""
			
				py"""# create a new stream. this returns the stream id
			new_stream_id = client.stream.create(name=$(stream_name))
			
			# use that stream id to get the stream from the server
			new_stream = client.stream.get(id=new_stream_id)"""
			client=py"client"
			new_stream_id=py"new_stream_id"
				"le nouvel ID est: " *new_stream_id
	else 
		new_stream_id=old_stream_id
	end
end

# ╔═╡ 60945b3f-734d-4907-919d-cdd8cf7afb18
md"""
### Création d'un objet Speckle avec données (julia) à transmettre
"""

# ╔═╡ 2d9b1790-5e24-461e-bca5-48533b616d6c
md"""
#### Données julia à transmettre à GH (ou ailleurs!)
"""

# ╔═╡ fac115b7-0c31-4618-b4f2-ff3fc8db8e9d
begin # julia data to send via speckle
	length=31.0
	width=3.14159
	height=300
	nothing
end


# ╔═╡ 7e259468-55e1-4105-b3ca-dd104d822d0b
md"""
#### Message à associer au commit

"""

# ╔═╡ 9b054907-af65-441e-bfa0-a5f48d8d037f
message="test de tranmission de données entre julia et GH"

# ╔═╡ ba23be3a-ed8f-469a-9ee7-6fabb874a860
md"""
#### Création de l'objet Speckle contenant les données et envoi
"""

# ╔═╡ 18e9c848-f774-4756-93d3-1933105aa05a
begin
	
	py"""from specklepy.objects import Base
from specklepy.objects.geometry import Point

class Block(Base):
    length: float
    width: float
    height: float
    origin: Point = None

    def __init__(self, length=1.0, width=1.0, height=1.0, origin=Point(), **kwargs) -> None:
        super().__init__(**kwargs)
        # mark the origin as a detachable attribute
        self.add_detachable_attrs({"origin"})

        self.length = length
        self.width = width
        self.height = height
        self.origin = origin
	"""
	py"""from specklepy.transports.server import ServerTransport
from specklepy.api import operations

# here's the data you want to send
#block = Block(length=2, height=4)
block = Block(length=$(length), height=$(height),width=$(width))	

# next create a server transport - this is the vehicle through which you will send and receive
client=$(client)
new_stream_id=$(new_stream_id)
transport = ServerTransport(client=client, stream_id=new_stream_id)

# this serialises the block and sends it to the transport
hash = operations.send(base=block, transports=[transport])

# you can now create a commit on your stream with this object
commid_id = client.commit.create(
    stream_id=new_stream_id, 
    object_id=hash, 
    message=$(message),
    )
	"""
	send_hash=py"hash"
	"son hash est" *send_hash
end

# ╔═╡ 4c47ca7a-49bb-4ed2-8d61-d8821a00c79b
md"""
#### Réception d'un objet Speckle
Nous allons reçevoir l'objet précéememnt envoyé dan ce même notebook. L'opération fonctionnerait égalemen à partir d'un notebbok partout dans le monde.
Nous utilisons le stream ayant permis l'envoi *8974348480*
"""

# ╔═╡ d7d53fd4-0da9-4df5-a3d9-ae180f4b6f9c
begin

# get a list of your most recent streams
#stream_list = client.stream.list()

# search your streams
#results = client.stream.search("mech")

# create a stream
#new_stream_id = client.stream.create(name="a shiny new stream")

# get a stream
#new_stream = client.stream.get(id=new_stream_id)
	
py"""

from specklepy.api.wrapper import StreamWrapper

# provide any stream, branch, commit, object, or globals url
#wrapper = StreamWrapper("https://speckle.xyz/streams/$(new_stream_id)")
wrapper = StreamWrapper("https://speckle.xyz/streams/3073b96e86/commits/604bea8cc6")
# get an authenticated SpeckleClient if you have a local account for the server
client = wrapper.get_client()

# get an authenticated ServerTransport if you have a local account for the server
transport = wrapper.get_transport()

# get a list of your most recent streams
#stream = client.stream.list()
stream = client.stream.get(id=$(new_stream_id))
"""
	py"stream"
	
end

# ╔═╡ 4a8eb897-629c-4403-a1c3-b27cb45a79cf
new_stream_id

# ╔═╡ fd33bc17-ce46-49d6-9643-92c603cb1c4b
@htl """
<iframe src="https://speckle.xyz/embed?stream=dc613aeb32&commit=451e58b36b" width="600" height="400" frameborder="0"></iframe>
"""

# ╔═╡ 3194c75a-5a21-44a5-a892-53b70d59c1eb
md"""
#### Extraction des données d'un objet
Il faut connaitre son *hash* (*"cfffefe10c3a14bf376da17f02a5a1ba"* par exemple)
"""

# ╔═╡ 8a24c1b3-fa38-4ef4-975d-903212c579aa
begin
	hash=send_hash #"cfffefe10c3a14bf376da17f02a5a1ba"
py"""
from specklepy.objects import Base
from specklepy.transports.memory import MemoryTransport
from specklepy.api import operations

transport = MemoryTransport()
base_obj = Base()

# this serialises the object and sends it to the transport
hash = operations.send(base=base_obj, transports=[transport])

# if the object had detached objects, you can see these as well
saved_objects = transport.objects # a dict with the obj hash as the key

# this receives an object from the given transport, deserialises it,
# and recomposes it into a base object.
# you can optionally provide a local_transport which will default to
# the `SQLiteTransport` pointing at your local cache

received_base = operations.receive(obj_id=$(hash), remote_transport=transport)

#id=received_base.id
#width=received_base.width
#length=received_base.length
#height=received_base.height

"""
#myobj=py"id",py"width",py"length",py"height"
	py"received_base "
end

# ╔═╡ 87445048-2b3b-438f-a496-60c6bb5f89e8
py"""
$(hash)
"""

# ╔═╡ 3eb02e87-4b6e-4385-aff7-2b1042124448
myobj

# ╔═╡ 39e9c5e5-bd5d-4b81-ae54-e810753cb76f
#https://discourse.mcneel.com/t/transfer-data-to-grasshopper-from-python/144502

# ╔═╡ 8578c178-8d8a-4833-a28f-612945391dee
#https://speckle.guide/user/grasshopper.html#using-the-c-python-script-nodes
#C:\Users\JPB\AppData\Roaming\Grasshopper\Libraries\SpeckleGrasshopper2\SpeckleCore2.dll

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"

[compat]
HypertextLiteral = "~0.9.4"
PlutoUI = "~0.7.39"
PyCall = "~1.93.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

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

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6e47d11ea2776bc5627421d59cdcc1296c058071"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.7.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

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

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

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
# ╠═3df83f70-f9a3-4e99-8081-0959060a112b
# ╠═0202f4fc-e844-4ead-bc06-80b82049b94c
# ╠═2cb83c58-946a-4adb-9a7a-2538edd4306e
# ╠═650e857f-ddd3-4b42-b03b-630236408185
# ╠═f69af12a-c3b0-40e7-a92f-99a0b0760b33
# ╟─e541f537-bc14-4d7d-8268-4b326da29135
# ╟─39349c4d-50b6-4f1f-ad56-f0ae27ac619c
# ╠═e58bf7c7-263b-488c-af68-d896c5164fd6
# ╟─5e90ba42-3ecc-49f9-9fe9-9979fc9f5788
# ╟─9dc30624-7ba1-409d-af50-a43ca7dc3527
# ╠═b22f943e-9145-4e69-8b8e-c7d186db0551
# ╟─e5319bd4-d52b-4d97-9142-6f656a5d18c9
# ╟─a131fabd-a3a6-4329-9e4a-ad8f587fcbb2
# ╠═dd1f9deb-7d4c-4c24-82da-e4875c183074
# ╠═60945b3f-734d-4907-919d-cdd8cf7afb18
# ╠═2d9b1790-5e24-461e-bca5-48533b616d6c
# ╠═fac115b7-0c31-4618-b4f2-ff3fc8db8e9d
# ╠═7e259468-55e1-4105-b3ca-dd104d822d0b
# ╠═9b054907-af65-441e-bfa0-a5f48d8d037f
# ╟─ba23be3a-ed8f-469a-9ee7-6fabb874a860
# ╠═18e9c848-f774-4756-93d3-1933105aa05a
# ╠═4c47ca7a-49bb-4ed2-8d61-d8821a00c79b
# ╠═d7d53fd4-0da9-4df5-a3d9-ae180f4b6f9c
# ╠═4a8eb897-629c-4403-a1c3-b27cb45a79cf
# ╠═fd33bc17-ce46-49d6-9643-92c603cb1c4b
# ╠═3194c75a-5a21-44a5-a892-53b70d59c1eb
# ╠═8a24c1b3-fa38-4ef4-975d-903212c579aa
# ╠═87445048-2b3b-438f-a496-60c6bb5f89e8
# ╠═3eb02e87-4b6e-4385-aff7-2b1042124448
# ╠═39e9c5e5-bd5d-4b81-ae54-e810753cb76f
# ╠═8578c178-8d8a-4833-a28f-612945391dee
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
