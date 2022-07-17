### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 0b6c67a5-5bd0-466a-9094-573c477185f4
using Pkg; Pkg.add(url="https://github.com/eliascarv/WebAPI.jl")#, adding rev="master" and/or subdir="tree/master/src

# ╔═╡ 5cd22eaa-3bb9-4722-8d31-d858d88e8ed4
Pkg.add("IntervalArithmetic")

# ╔═╡ b375ca2f-7e5f-486c-98be-07f1dc5621f5
Pkg.add("IntervalRootFinding")

# ╔═╡ e097ebd7-a0d1-45fb-b5b0-8f3bd7094d86
Pkg.add("DifferentialEquations")

# ╔═╡ 0b4f6d70-d78b-4065-a058-4488fdc5d71e
Pkg.add("JuMP")

# ╔═╡ 5e80f21c-45c7-4d1b-9b41-6e7bfd431050
using JuMP

# ╔═╡ 18c41582-764e-43e8-b217-9d8fd4c98327
using WebAPI

# ╔═╡ efbba27d-af40-48a1-88c8-6a419785bef3
using IntervalArithmetic, IntervalRootFinding

# ╔═╡ 78a1f079-55f8-4f7c-b8f5-c63e15e2f406
using DifferentialEquations

# ╔═╡ fa902b2d-925a-4657-bc32-1f831c8bf762


# ╔═╡ 75e2b1f0-00f2-11ed-1ab6-4d297af5bc4e
md"""
## Serveur WebAPI
Remarques préliminaires
* On ne passe que des chaines de caractères avec minuscules pour les requêtes client: donc routes avec  *rootint* et non pas *rootInt* et en paramètre x\*x-1 et non pas *x^2-1*
* En retour une chaine de caractères

"""

# ╔═╡ 8688cc8f-de32-4d33-b628-3eac79accc35
md"""
## Importation des *packages*
"""

# ╔═╡ 566edbdb-7fd8-439b-a955-c600fa90f0af
import Ipopt

# ╔═╡ f6442ce4-80fb-4a7d-8a3a-5c0a5f274e18
md"""
## Définition des fonctions à assurer
"""

# ╔═╡ 11c2aefc-f1b0-45b9-ab00-d0758c273dae



# ╔═╡ 45042b51-0148-4e07-add4-6ae808ec4003


# ╔═╡ 505f20c1-2b71-40d6-ae83-358329c1067c


# ╔═╡ c9bd2683-e1d6-4355-91d8-2c51d1bb90ac
md"""
## Lancement du serveur
"""

# ╔═╡ 67f3c20b-11d6-4015-83c3-0e63a41b507e
# to kill a task but lock the cell : do better 
# Pour arrêter le serveur revenir sur l'entrée de démarrage du notebook Pluto et arrêter le fichier .jl en cours d'exécution 
#ex = InterruptException()
#Base.throwto(t, ex)

# ╔═╡ c4c8ac64-c5e1-4bab-af6a-2ccf93124d17
begin
const app = App()



function bhaskara(a, b, c)
    Δ = b^2 - 4*a*c

    Δ < 0 && (Δ = complex(Δ))

    x₁ = (-b + √Δ) / 2a
    x₂ = (-b - √Δ) / 2a
    return x₁, x₂
end	


		# Calcul des racines d'un polynome dégré 2 à coefficents entiers
	# f(x)=ax*x+b*x+c
	
	function rootint(a, b, c)
    Δ = b^2 - 4*a*c

    Δ < 0 && (Δ = complex(Δ))

    x₁ = (-b + √Δ) / 2a
    x₂ = (-b - √Δ) / 2a
    return x₁, x₂
end
	
function myroots(myFonct,myInterval)
	# fonction de recherche des intervalles où ce trouve les zéros d'un polynomes quelconques. Eviter x^3 --> x*x*x
	f1=eval(Meta.parse("f0(x)="*myFonct))
	myIn= eval(Meta.parse(myInterval))
	return String(string(roots(f1,myIn)))
end


		function verre1(e,vol)
		# e and v are string
		e=parse(Float64,e)
		vol=parse(Float64,vol)
		model1 = Model(Ipopt.Optimizer)
		r1,h1= nothing, nothing # clear the julia variables
		@variable(model1, r1 >= 0.0)  # le rayon
		@variable(model1, h1 >= 0.0); # la hauteur
			@NLobjective(model1, Min,π*r1^2*e+2*π*r1*h1*e)  # le volume de la part matière est à minimiser
		# On calcule le volume intérieur du verre
		@NLconstraint(model1, c, π*(r1-e)^2*(h1-e)== vol) # "c" est le nom de la contrainte
		optimize!(model1);
	
		r1=value(r1)  # variable à nouveau julia
		h1=value(h1)

		return r1,h1
	end





	
	#lancement avec http://localhost:8081/bhaskara/1/3/7
add_get!(app, "/bhaskara/:a/:b/:c") do req
    a = parse(Int, req.params.a)
    b = parse(Int, req.params.b)
    c = parse(Int, req.params.c)
    x₁, x₂ = bhaskara(a, b, c)

    return Dict("x1" => "$x₁", "x2" => "$x₂")
end

add_get!(app, "/bhaskara") do req
    verifykeys(req.query, (:a, :b, :c)) || return Res(400, "Incorrect Query.")

    a = parse(Int, req.query.a)
    b = parse(Int, req.query.b)
    c = parse(Int, req.query.c)
    x₁, x₂ = bhaskara(a, b, c)

    return (x1 = "$x₁", x2 = "$x₂")
end

add_post!(app, "/bhaskara") do req
    verifykeys(req.body, ["a", "b", "c"]) || return Res(400, "Incorrect JSON.")

    a = req.body.a
    b = req.body.b
    c = req.body.c
    x₁, x₂ = bhaskara(a, b, c)

    return Res(201, (x1 = "$x₁", x2 = "$x₂"))
end

	
add_get!(app, "/verre/:e/:v") do req
    v = req.params.v  # goal Volume
    e = req.params.e  # glass thickness
    r, h = verre1(e, v)  # radius,height of the optimized glass

    return Dict("rayon" => "$r", "hauteur" => "$h")
end

	
# Parameters are given within the request without body
add_get!(app, "/rootint/:a/:b/:c") do req
    a = parse(Int, req.params.a)
    b = parse(Int, req.params.b)
    c = parse(Int, req.params.c)
    x₁, x₂ = rootint(a, b, c)

    return Dict("x1" => "$x₁", "x2" => "$x₂")
end
	
# lancement avec http://localhost:8081/rootint/3/4/5
add_get!(app, "/rootint") do req
    verifykeys(req.query, (:a, :b, :c)) || return Res(400, "Incorrect Query.")

    a = parse(Int, req.query.a)
    b = parse(Int, req.query.b)
    c = parse(Int, req.query.c)
    x₁, x₂ = rootint(a, b, c)

    return (x1 = "$x₁", x2 = "$x₂")
end


add_post!(app, "/rootint") do req
    verifykeys(req.body, ["a", "b", "c"]) || return Res(400, "Incorrect JSON.")

    a = req.body.a
    b = req.body.b
    c = req.body.c
    x₁, x₂ = rootint(a, b, c)

    return Res(201, (x1 = "$x₁", x2 = "$x₂"))
end


# request with http://localhost:8081/myroots/x*x*x-2/-10..10/ on browser
add_get!(app, "/myroots/:a/:b") do req
    a = req.params.a
    b = req.params.b
    x₁= myroots(a,b)

    return Dict("x1" => "$x₁")
end
	


#ip="192.168.32.113"
#ip=	"141.101.68.140" # from myIp
@async serve(app) #serve(app,ip) #Default: ip = localhost, port = 8081

end

# ╔═╡ 5d89ef69-c892-412f-abde-c195969f6feb


# ╔═╡ 41247b83-8390-42f8-8ae8-17a5d9e84d95
md"""
## Génératisation
avec [SciML Tuto](https://tutorials.sciml.ai/)
### [ODE](https://tutorials.sciml.ai/html/introduction/01-ode_introduction.html)
Les données de définition du problème doivent être des *string*s
* la fonction f ; eval(Meta.parse("f(u,p,t)=p*u)) 
* le paramètre p : string(p)
* la condition initiale u0=string(u0)
* tmin et tmax
* le point t où l'on souhaite connaître le résultat  en sortie 

Le alcul d'une seule solution n'est pas rentable en temps car on repasse sur tout le programme (durée typique 1.6 s) alors qu"un calcul supplémentaire ne prend que 21 µs

Nous rajoutons donc un paramètre n : nb de points dans l'intervalle tmin tmax, si tmi=tmax calcul au point correspondant 

"""

# ╔═╡ 244b8825-882d-4f6f-a9d9-8de8744d114c
begin
# Résolution ODE cas d'école
f(u,p,t) = 0.98u   # equation du/dt=0.98*u
u0 = 1.0            # initila condition
tspan = (0.0,1.0)    # exploration range
prob2 = ODEProblem(f,u0,tspan)  #problem definition
	sol = solve(prob2)  # problem solution# sol request at a given point
	sol(0.45)  
end

# ╔═╡ 126ee253-ff6b-4f12-bf4f-0d9caa2435d3
function myode(myf,myp,myu0,mytmin,mytmax,myt)
	# 
	fode1=eval(Meta.parse("fode(u,p,t)="*myf))
	p1=parse(Float64,myp)
	u01=parse(Float64,myu0)
	tspan1=(parse(Float64,mytmin),parse(Float64,mytmax))
	prob1=ODEProblem(fode1,u01,tspan1) 
	sol1=solve(prob1)
	t1=	parse(Float64,myt)
	#n1=
	return string(sol1(t1))
end

# ╔═╡ f4ec35e4-c42a-4d04-98fe-db3144d0204f
begin
	myf= "0.98*u"
   myp="0.98"
	myu0=  "1"  
	mytmin="0.0"
	mytmax="1.0"
	myt="0.45"
end

# ╔═╡ 0ff2cd5c-a73b-4a03-b4cc-0afb7744502e
#if in error just rerun !

	myode(myf,myp,myu0,mytmin,mytmax,"0.45")  # calcule ODE à partir de data au format string 


# ╔═╡ ff14e00a-6160-46ca-a242-6623bcd2c2c2
sol(0.45)

# ╔═╡ c4c9626c-f22e-438e-ac35-1b57eddf4383
begin
	#string serialization/deserialization of array, works with one float too
	mar="[3,7]" #"8.4"
	try 
		mar1=parse.(Float64, split(chop(mar; head=1, tail=1), ',')) 

	catch 
		mar1=parse.(Float64,mar) 
	end
end

# ╔═╡ cf80c23f-87bc-4e45-bb80-5391adf7f251


# ╔═╡ a5737aef-3554-44de-9225-8450320226b5
md"""
## Exemple cas d'école
Sous un notebook pluto (julia), le client envoie l'épaisseur et le volume du verre, julia l'optimise et envoie une requête via specklepy à Grasshopper, et récupère en retour la forme 3D correspondante  
"""

# ╔═╡ 6649d9b4-20d0-4073-8071-138180628cca
begin
	vol=300  # volume objectif cm3
	e=4e-1 
end

# ╔═╡ 66999905-5876-4464-b4bc-0010c32130a8
md"""
### Optimisation en local
"""

# ╔═╡ 01e9df8b-5838-44bf-b8e0-a4c5d3ab1373
begin
	model = Model(Ipopt.Optimizer)
	r,h= nothing, nothing # clear the julia variables
	@variable(model, r >= 0.0)  # le rayon
	@variable(model, h >= 0.0) # la hauteur
	 # épaisseur du verre
	@NLobjective(model, Min,π*r^2*e+2*π*r*h*e)  # le volume de la part matière est à minimiser
	# On calcule le volume intérieur du verre
	@NLconstraint(model, c, π*(r-e)^2*(h-e)== vol) # "c" est le nom de la contrainte
	optimize!(model);

	r=value(r)  # variable à nouveau julia
	h=value(h)
    [r,h,π*(r-e)^2*(h-e)]  # volume calculé. L'optimum correspond à r=h !
end

# ╔═╡ cd4ad7d4-d0b3-48f2-8823-f0309d8be373
md"""
### Fonction d'optimisation 
rayon,hauteur=verre(epaisseur,volume)

"""

# ╔═╡ 5cd6efc7-12d9-4a9c-9235-901762901ef3
# fonction verre(e,h)

	

# ╔═╡ 0ae02415-4477-4f53-b8a8-e2015fe6c9ad
verre1("0.4","300")

# ╔═╡ bddc78d4-2a6d-442f-b40c-c63b2d0d867d
md"""
### Echanges des données entre client/serveur
"""

# ╔═╡ 4a056a1b-de45-428d-b63b-ae01c161a98d
app

# ╔═╡ c8769e96-b7c8-475d-a4c7-9f3141429417
md"""
### Envoie des données vers GH
https://speckle.xyz/streams/cac8ca4a7e?u=b416f52ba5
begin
const app1 = App()
	
	#lancement avec http://localhost:8081/bhaskara/1/3/7
add_get!(app1, "/bhaskara/:a/:b/:c") do req
    a = parse(Int, req.params.a)
    b = parse(Int, req.params.b)
    c = parse(Int, req.params.c)
    x₁, x₂ = bhaskara(a, b, c)

    return Dict("x1" => "$x₁", "x2" => "$x₂")
end

@async serve(app1,ip=) #serve(app,ip=https://speckle.xyz/streams/cac8ca4a7e?u=b416f52ba5) #Default: ip = localhost, port = 8081
end
"""

# ╔═╡ b76fdd0e-d24d-40ae-b7e7-b9860548aec7
md"""
Nous avons créé un autre nb oluto pour établir le pont entre *localhost:8083* et Grasshopper : GHserver.jl où nous effecturons la mise au point 
"""

# ╔═╡ f39dfa48-8c79-4dc9-a39f-2605e21e7a8c
md"""
### Récupération de la forme
"""

# ╔═╡ Cell order:
# ╠═fa902b2d-925a-4657-bc32-1f831c8bf762
# ╟─75e2b1f0-00f2-11ed-1ab6-4d297af5bc4e
# ╟─8688cc8f-de32-4d33-b628-3eac79accc35
# ╠═0b6c67a5-5bd0-466a-9094-573c477185f4
# ╠═5cd22eaa-3bb9-4722-8d31-d858d88e8ed4
# ╠═b375ca2f-7e5f-486c-98be-07f1dc5621f5
# ╠═e097ebd7-a0d1-45fb-b5b0-8f3bd7094d86
# ╠═0b4f6d70-d78b-4065-a058-4488fdc5d71e
# ╠═5e80f21c-45c7-4d1b-9b41-6e7bfd431050
# ╠═566edbdb-7fd8-439b-a955-c600fa90f0af
# ╠═18c41582-764e-43e8-b217-9d8fd4c98327
# ╠═efbba27d-af40-48a1-88c8-6a419785bef3
# ╠═78a1f079-55f8-4f7c-b8f5-c63e15e2f406
# ╟─f6442ce4-80fb-4a7d-8a3a-5c0a5f274e18
# ╠═11c2aefc-f1b0-45b9-ab00-d0758c273dae
# ╠═45042b51-0148-4e07-add4-6ae808ec4003
# ╠═505f20c1-2b71-40d6-ae83-358329c1067c
# ╟─c9bd2683-e1d6-4355-91d8-2c51d1bb90ac
# ╠═67f3c20b-11d6-4015-83c3-0e63a41b507e
# ╠═c4c8ac64-c5e1-4bab-af6a-2ccf93124d17
# ╠═5d89ef69-c892-412f-abde-c195969f6feb
# ╟─41247b83-8390-42f8-8ae8-17a5d9e84d95
# ╠═244b8825-882d-4f6f-a9d9-8de8744d114c
# ╠═126ee253-ff6b-4f12-bf4f-0d9caa2435d3
# ╠═f4ec35e4-c42a-4d04-98fe-db3144d0204f
# ╠═0ff2cd5c-a73b-4a03-b4cc-0afb7744502e
# ╠═ff14e00a-6160-46ca-a242-6623bcd2c2c2
# ╠═c4c9626c-f22e-438e-ac35-1b57eddf4383
# ╠═cf80c23f-87bc-4e45-bb80-5391adf7f251
# ╟─a5737aef-3554-44de-9225-8450320226b5
# ╠═6649d9b4-20d0-4073-8071-138180628cca
# ╟─66999905-5876-4464-b4bc-0010c32130a8
# ╠═01e9df8b-5838-44bf-b8e0-a4c5d3ab1373
# ╟─cd4ad7d4-d0b3-48f2-8823-f0309d8be373
# ╠═5cd6efc7-12d9-4a9c-9235-901762901ef3
# ╠═0ae02415-4477-4f53-b8a8-e2015fe6c9ad
# ╟─bddc78d4-2a6d-442f-b40c-c63b2d0d867d
# ╠═4a056a1b-de45-428d-b63b-ae01c161a98d
# ╠═c8769e96-b7c8-475d-a4c7-9f3141429417
# ╠═b76fdd0e-d24d-40ae-b7e7-b9860548aec7
# ╟─f39dfa48-8c79-4dc9-a39f-2605e21e7a8c
