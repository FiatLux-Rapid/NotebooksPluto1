### A Pluto.jl notebook ###
# v0.19.12

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

# ╔═╡ baef13c4-dc58-49df-b877-6d15d60212a5
begin
	import Pkg; 
	Pkg.add(url="https://github.com/hyrodium/BasicBSplineExporter.jl")
	#Pkg.add("BasicBSpline")
	#Pkg.add("StaticArrays")
	#Pkg.add("Plots")	
	#Pkg.add("ModelingToolkit"@v8.23.0)
	#Pkg.add("QuadGK")
	#Pkg.add("IfElse")
	#Pkg.add("Sobol")
	#Pkg.add("DataInterpolations")
	#Pkg.add("DifferentialEquations")
	#Pkg.add("PyPlot")
	#Pkg.add("Interpolations")
	#Pkg.status("ModelingToolkit")
	#Pkg.add("PlutoUI")
	
end

# ╔═╡ 5780387b-68ae-409d-b5aa-120f00456f6e
begin
	using ModelingToolkit
	using BasicBSpline
	using Plots
	using BasicBSplineExporter
	using StaticArrays
	using QuadGK
	using IfElse
	using DifferentialEquations
	using DataInterpolations
	using Interpolations
	using Sobol
	using PlutoUI
end

# ╔═╡ 3369d29a-9f07-4c2c-ace2-4316839f3781
i2_50(t)=ir50(t)^2

# ╔═╡ e6ec45a2-5a82-47bf-9797-a754970613ca
maximum(zzz)

# ╔═╡ 42d502b0-b21a-46e7-8d17-dc15eef09dcd
begin  # creation de fonctions interpolées à partir des données 
	#coutv=DataInterpolations.LinearInterpolation(solnp[npline.cout.v],solnp.t)
	#coutv=DataInterpolations.CubicSpline(solnp[npline.cout.v],solnp.t)
	#ir50=DataInterpolations.LinearInterpolation(solnp[r50.i],solnp.t)
end

# ╔═╡ f6b4f678-da14-48bd-b174-094220cdbff4
npline₊cout₊v(3e-9)

# ╔═╡ e843f6c1-6933-4282-8943-56ec9c77a37a
swpulse₊i(3e-9)

# ╔═╡ 184fdf94-af5d-4aa1-99f8-9177eef71df4
npline₊cout₊i(25e-9)

# ╔═╡ 7009ebea-27fc-4ab0-9efd-9ab0367230ec
begin
# génération de fonction v(t) et i(t) pour tous les éléments du circuit électronique
# récupération des variables à prendre en compte
	
end

# ╔═╡ 6f745422-bd58-43fc-9a2d-65842b8d7664
swpulse₊p₊i(3e-9)

# ╔═╡ 0d7b5f8e-f039-41f2-a8e4-1182deda2536
swpulse₊i(3e-9)

# ╔═╡ 3d8e0dc0-52d4-4418-be09-a26fdd01b151
r50.p.i(3e-9)

# ╔═╡ b9c7472a-4981-4e45-9146-0cbaf8f7a022
swpulse₊i(3e-9)

# ╔═╡ 4a6d809d-1437-4193-9ab3-7a47fa3e69e7
r50₊i(3e-9)

# ╔═╡ 352b8f59-b52b-4e40-bcfb-fcf3794638e7
typeof(swpulse₊p₊i)

# ╔═╡ f993ee10-acd8-4ae5-be54-4cdaa9e4491f
length(myfunct)

# ╔═╡ 95d78452-8f00-4d96-82f2-360851d17bd6
swpulse₊p₊i(3e-9)

# ╔═╡ d6964882-64f6-4454-bfa8-fa7f6c13eaa7
swpulse₊p₊i(3e-9)

# ╔═╡ 740f22e3-35ce-4c75-aab6-8a913d688cf1
md"""
## Sampling and twins
"""

# ╔═╡ e1506254-49e3-46c7-b407-900bab0167a2
begin
	

tz = 0:0.05:1
x = sin.(2π*tz)
y = cos.(2π*tz)
A = hcat(x,y)

itp = Interpolations.scale(interpolate(A, (BSpline(Cubic(Natural(OnGrid()))), NoInterp())), tz, 1:2)

tfine = 0:.001:1
xs, ys = [itp(t,1) for t in tfine], [itp(t,2) for t in tfine]
	scatter(xs, ys)
	scatter!(x,y)
end

# ╔═╡ a295d5b2-1e24-49d9-9312-8d0b4c58bafe
begin
	lb=[90e3,0.00]
	ub=[200e3,1]
s1 = SobolSeq(lb, ub)
skip(s1, 5000)
p1 = reduce(hcat, next!(s1) for i = 1:67)'
	
#subplot(111, aspect="equal")
scatter(p1[:,1], p1[:,2])
	x1 = next!(s1)
#scatter!(x1)	
	scatter!([x1[1]], [x1[2]], color = "green", label = "next", markersize = 5)
end

# ╔═╡ 796f8d72-437c-4c71-b24a-cf63625ef0db
begin
	mind=[]
	for i in 1:size(p1)[1]
		push!(mind,(((p1[i,1]-x1[1])/(ub[1]-lb[1]))^2+((p1[i,2]-x1[2])/(ub[2]-lb[2]))^2)^0.5 )
	end
	nearpoint=p1[findmin(mind)[2],:]
end

# ╔═╡ f5f9aa89-6842-4e50-a85f-eeeafb613a1f
md"""
## Electronic components database
"""

# ╔═╡ db983b9d-872d-4155-b30c-28e493f8900b
begin
#module myCirc
	#export t,Ground,connect, OnePort,Resistor,real_transformer,Pin, ConstantVoltage, Capacitor,Inductor,CoupledInductor
   #  using ModelingToolkit, Plots, DifferentialEquations

@isdefined(t) || @parameters t
@connector function Pin(; name)
    sts = @variables v(t)=1.0 i(t)=1.0 [connect = Flow]
    ODESystem(Equation[], t, sts, []; name = name)
end

function Ground(;name)
    @named g = Pin()
    eqs = [g.v ~ 0]
    compose(ODESystem(eqs, t, [], []; name=name), g)
end

function OnePort(;name)
    @named p = Pin()
    @named n = Pin()
    sts = @variables v(t)=1.0 i(t)=1.0
    eqs = [
           v ~ p.v - n.v
           0 ~ p.i + n.i
           i ~ p.i
          ]
    compose(ODESystem(eqs, t, sts, []; name=name), p, n)
end

function Resistor(;name, R = 1.0)
    @named oneport = OnePort()
    @unpack v, i = oneport
    ps = @parameters R=R
    eqs = [
           v ~ i * R
          ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
end

function Capacitor(;name, C = 1.0)
    @named oneport = OnePort()
    @unpack v, i = oneport
    ps = @parameters C=C
    D = Differential(t)
    eqs = [
           D(v) ~ i / C
          ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
end

function ConstantVoltage(;name, V = 1.0)
    @named oneport = OnePort()
    @unpack v = oneport
    ps = @parameters V=V
    eqs = [
           V ~ v
          ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
end

function SinVoltage(;name, V = 1.0,freq=freq)
    f=2e5
	@named oneport = OnePort()
    @unpack v = oneport
     ps = @parameters V=V freq=freq

    eqs = [
           v ~ V*sin(2*π*f*t)
          ]
    extend(ODESystem(eqs, t, [v],ps; name=name), oneport)
end

	
	function Inductor(;name, L = 1.0)
    @named oneport = OnePort()
    @unpack v, i = oneport
    ps = @parameters L=L
    D = Differential(t)
    eqs = [
           D(i) ~ v / L
          ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
	end

	
function Transformer(;name,ratio=1.0)
	tp=OnePort(name=:tp)
	ts=OnePort(name=:ts)
	ps = @parameters ratio=ratio
	eqs = [ 
           
		    ts.i ~ -tp.i*ratio
			ts.v ~ tp.v/ratio
          ]
    compose(ODESystem(eqs, t, [], ps; name=name),tp,ts)
	end

function CoupledInductor(;name,coupling=0.1,ratio=1.0,Lp=1.0)
	tp=OnePort(name=:tp)
	ts=OnePort(name=:ts)
	Ls=(ratio*coupling)^2*Lp
	Mv=ratio*(Ls*Lp)^0.5
	D = Differential(t)
	ps =@parameters ratio=ratio coupling=coupling  Lp=Lp
	sts = @variables vp(t)  ip(t) vs(t) is(t)
	eqs = [ 
         vp ~ tp.v
		 ip ~ tp.i
		 vs ~ ts.v
		 is ~ ts.i
	     D(ip)~(Ls*tp.v-Mv*ts.v)/(Ls*Lp-Mv^2)	
		 D(is)~(Mv*tp.v-Lp*ts.v)/(Mv^2-Ls*Lp)   
	      ]
    compose(ODESystem(eqs, t, [vp,ip,vs,is], ps; name=name),tp,ts)
	end	

function CoupledInductanceV1(;name,coupling=0.1,ratio=1.0,Lp=1.0)
	tp=OnePort(name=:tp)
	ts=OnePort(name=:ts)
	Ls=(ratio*coupling)^2*Lp
	Mv=ratio*(Ls*Lp)^0.5
	D = Differential(t)
	ps =@parameters ratio=ratio coupling=coupling  Lp=Lp
	sts = @variables vp(t)  ip(t) vs(t) is(t)
	eqs = [ 
         vp ~ tp.v
		 ip ~ tp.i
		 vs ~ ts.v
		 is ~ ts.i
	     D(ip)~(Ls*tp.v-Mv*ts.v)/(Ls*Lp-Mv^2)	
		 D(is)~(Mv*tp.v-Lp*ts.v)/(Mv^2-Ls*Lp)   
	      ]
    compose(ODESystem(eqs, t, [vp,ip,vs,is], ps; name=name),tp,ts)
	end	


	function Diode(;name,st_d=0) # 0 bloqué, 1 passant i>0 
		
		#i(v)=IS[exp(vηVT)−1]
		d=OnePort(name=:d)
		r_on= 10.0e-3 
		r_off=1e6
		#https://eng.libretexts.org/Bookshelves/Materials_Science/Supplemental_Modules_%28Materials_Science%29/Solar_Basics/D._P-N_Junction_Diodes/3%3A_Ideal_Diode_Equation
		Is=1e-3
		vt=300.0/11586.0  #300°K
		η=2.0
		#sts = @variables v(t) i(t) 
		#ps = @parameters st_d=st_d
		#st_d=0;
		#ps = @parameters st_d=st_d; 
		sts=@variables i(t) v(t);
		d=OnePort(name=:d);
		eqs=[ 
			i ~ d.i
			v ~ r_on*(d.i>0.00)*d.i+r_off*(d.i<=0.00)*d.i+0.0  # condition OK (TTRBDF2() 10-9)
	        v ~ d.v
			#i ~ Is*(ℯ^(d.v*η*vt)−1)
			#v ~ ifelse(i>0.04,r_on,ifelse(i<0.04,r_off,0.0))
		]	
		    
    compose(ODESystem(eqs, t, sts, []; name=name),d)
	end
end

# ╔═╡ c7daeaf9-904a-4cf4-8d57-868c1b0cc979
begin
	Ls =3e-9 # Lp*(1-k^2)
	Lm = 3e-6 # Lp*k^2
	@named	ls =Inductor(L=Ls)
    @named	lm =Inductor(L=Lm)
    @named	transf=Transformer(ratio=1.0)
	@named groundp=Ground()
	@named grounds=Ground()

	rc_eqs1 = [
          connect(ls.n, lm.p)
		  connect(lm.n, groundp.g,transf.tp.n)
		  connect(lm.p,transf.tp.p)
          connect(transf.ts.n,grounds.g)
         ]
		
@named tr = compose(ODESystem(rc_eqs1,t,name=:tr),lm,ls,transf,grounds,groundp)
	nothing
end

# ╔═╡ 09ff0531-188e-4203-a328-649011e2280d
npline₊cout₊v(t)

# ╔═╡ 0102cab9-ffa9-49e9-b56a-e2d1fea2389c
begin
	function Vpulse(t,f,d,v0,tr)
		t2=1.0/f
		tm=t%t2
		ifelse(tm<=tr,v0*tm/tr,
			ifelse(tm<=d-tr,v0,
				ifelse(tm<=d,v0-v0*(tm+tr-d)/tr , 0.0)
					
								))
					
	end
	
	function Vpulsevoltage(;name,d=d,f=f)
    @named oneport = OnePort()
    @unpack v = oneport
    ps =[] # @parameters V=V
    eqs = [
           v ~ vup(t,d,f)
          ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
	end
	vup(t,d,f)= Vpulse(t,f,d,5e3,5e-9)
end

# ╔═╡ a2a565c5-1a4f-43a5-9193-0e1cf373e18a
begin
	vup1(t)=vup(t,1e-8,1e7)
	plot(0:1e-9:200e-9,vup1,tstops=[1.0/1.0e7])
end

# ╔═╡ cda90c96-f253-46f3-90fb-1acbcb9570ce
begin
	li=nothing
	ci=nothing
	cout=nothing
	rc_eqs2=[]
	clength=3
	nloop=20 #0
	
	#name="myname"
	# réalisation d'unne ligne de transmission
	function line(;name="myname")
		
		local vari=""
		for i in 1:nloop-1
			vari*="li["*string(i)*"],ci["*string(i)*"],"
		end
		vari*="li[nloop],"
		vari*="cout"


		eval(Meta.parse("@named cout=Capacitor(C=40e-12)"))
		eval(Meta.parse("@named li 1:"*string(nloop)*" i -> Inductor(L=2.5229658792650916e-7*"*string(clength/nloop)*")"))
		eval(Meta.parse("@named ci 1:"*string(nloop-1)*" i -> Capacitor(C=1.0104986876640419e-10*"*string(clength/nloop)*")"))
		
		try
			for i in 1:nloop-1
				push!(rc_eqs2,connect(li[i].n,ci[i].p,li[i+1].p))
				#push!(rc_eqs2,connect(li[i].n,ci[i+1].p))
			end
		catch
		end

		for i in 2:nloop-1
			push!(rc_eqs2,connect(ci[i].n,ci[i-1].n))
		end
	#	push!(rc_eqs2,connect(li[nloop].p,ci[nloop].p))
		push!(rc_eqs2,connect(li[nloop].n,cout.p))
		push!(rc_eqs2,connect(cout.n,ci[nloop-1].n))
	  eval(Meta.parse(name*"=compose(ODESystem(rc_eqs2,t,name=:"*name*"),"*vari*")"))

	end
		function line0(;name="myname")
		
		local vari=""
		for i in 1:nloop
			vari*="li["*string(i)*"],ci["*string(i)*"],"
		end
		vari*="cout"


		eval(Meta.parse("@named cout=Capacitor(C=40e-12)"))
		eval(Meta.parse("@named li 1:"*string(nloop)*" i -> Inductor(L=2.5229658792650916e-7*"*string(clength/nloop)*")"))
		eval(Meta.parse("@named ci 1:"*string(nloop)*" i -> Capacitor(C=1.0104986876640419e-10*"*string(clength/nloop)*")"))
		
		try
			for i in 1:nloop-1
				push!(rc_eqs2,connect(ci[i].p,li[i].p))
				push!(rc_eqs2,connect(li[i].n,ci[i+1].p))
			end
		catch
		end

		for i in 2:nloop
			push!(rc_eqs2,connect(ci[i].n,ci[i-1].n))
		end
		push!(rc_eqs2,connect(li[nloop].p,ci[nloop].p))
		push!(rc_eqs2,connect(li[nloop].n,cout.p))
		push!(rc_eqs2,connect(cout.n,ci[nloop].n))
	  eval(Meta.parse(name*"=compose(ODESystem(rc_eqs2,t,name=:"*name*"),"*vari*")"))

	end
	@named myline=line(name="myline")
	nothing
end

# ╔═╡ 9ba3e523-5b6d-4d28-81a5-ed1ef212f781
begin
		rc_eqs3=[]
		try
			for i in 1:nloop-1
				push!(rc_eqs3,connect(ci[i].p,li[i].p,ci[i+1].p))
			end
		catch
		end

		for i in 2:nloop
			push!(rc_eqs3,connect(ci[i].n,ci[1].n))
		end
		

end

# ╔═╡ bbd7d4d4-d6ab-422c-8609-f9cb2fd2af97
begin
    duration=40e-9
	R = 1.0
	C = 40.0e-12
	
	#Cload=1.0e-12
	V = 5e3
	ratio=1.0
	@register_symbolic vup(t,d,f)
	#@named transformer = Transformer(ratio=ratio)
	@named resistor = Resistor(R = R)
	#@named cload = Capacitor(C=C)
	#@named source = ConstantVoltage(V = V)
	@named source = Vpulsevoltage(d=10e-9,f=1e5)

	@named ground1 = Ground()
	
		rc_eqs = [ connect(source.p, resistor.p)
			   connect(resistor.n, myline.li_1.p)
		       connect(myline.ci_1.n, ground1.g,source.n)]
	
		@named rc_model = ODESystem(rc_eqs, t)
		rc_model = compose(rc_model, [resistor, myline, source, ground1])
	
	    sys = structural_simplify(rc_model)

	
		u0=[ ]
     
		for i in 1:nloop-1	
			mystr="myline.ci_"*string(i)*".v"
			mypair=eval(Meta.parse(mystr*"=>0.0"))
			push!(u0,mypair)
		end
		push!(u0,myline.cout.v=>0.0)
        u0=convert(Vector{Pair{Num, Float64}},u0)
		prob = ODAEProblem(sys, u0, (0, duration))
		sol = solve(prob, Tsit5())

	#plot(sol, vars=[myline.ci_1.v,eval(Meta.parse("myline.ci_"*string(nloop-1)*".v"))])
	plot(sol, idxs=[myline.cout.v])
		
end

# ╔═╡ 5b707670-7ecb-4458-b16d-a818b0930c2b
#https://discourse.julialang.org/t/modeling-a-crowbar-circuit-with-modelingtoolkit-jl/81968/5
begin
	function VoltageSensor(; name)
	    @named p = Pin()
	    @named n = Pin()
	    @variables v(t)=1.0
	    eqs = [
	        p.i ~ 0
	        n.i ~ 0
	        v ~ p.v - n.v
	    ]
	 ODESystem(eqs, t, [v], []; systems=[p, n], name=name)
	end
	#@named level = VoltageSensor()

end

# ╔═╡ 4a6f61b7-c30d-4174-803e-3df380747982
begin
	function Switch(;name,ton=ton,toff=toff) 
		@named oneport = OnePort()
	    @unpack v, i = oneport
		ps= @parameters ton=ton toff=toff rsw
		
	    eqs = [
	           v ~ i * rsw
			   
	          ]
	    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
	end

		function Switch1(;name,ton=ton,toff=toff,ron=ron,roff=roff) 
		@named oneport = OnePort()
	    @unpack v, i = oneport
	   sts= []#@variables t rsw
		ps= @parameters ton=ton toff=toff 
		
	    eqs = [
	           
			   v ~ IfElse.ifelse(t<=ton,roff,IfElse.ifelse(t<=toff,ron,roff))*i
	          ]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
	end

		function Switchrt(;name,ton=ton,twidth=twidth,rt=rt) 
		@named oneport = OnePort()
	    @unpack v, i = oneport
	   sts= []#@variables t rsw
		ps= @parameters ton=ton twidth=twidth rt=rt
		#a=(roff-ron)/tr  b=ron-a*(ton+twidth)
	    eqs = [    
			   v ~ i*(IfElse.ifelse(t<=ton,
				   	roff,
				   	IfElse.ifelse(t<=ton+tr,
				   			(ron-roff)/tr*t+roff-(ron-roff)/tr*ton,
				   			IfElse.ifelse(t<=ton+twidth, 
								ron,
								IfElse.ifelse(t<ton+twidth+tr,
					   				(roff-ron)/tr*t+ron-(roff-ron)/tr*(ton+twidth),
									roff
								)))))]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
	end
end

# ╔═╡ d34ff992-dbc5-4a65-8191-0f671f20d455
begin

	#circuit
	Cz=1.0
	Vz=1.0

	#configuration du switch "resistorz"
	tonz=2
	
	roffz=1e6
	rini=1e6
	toffz=5
	@named resistorz = Switch1(ton=tonz,toff=toffz,ron=1,roff=1e6)
	#tₒₙ=[ton] =>[resistorz.rsw ~ ron]    #ODESYSTEM discrete_event=[tₒₙ,tₖ]
	#tₖ=[toff] =>[resistorz.rsw ~ roff]
	#pevt=[resistorz.rsw=>roff]          # ODAEProblem(sysz,u0z, (0, 20),pevt)
	#resistorz₊rsw(t)=IfElse.ifelse(t<=ton,rini,IfElse.ifelse(t<=toff,ron,roff))
	
	@named capacitorz = Capacitor(C=Cz)
	@named sourcez = ConstantVoltage(V=Vz)
	@named groundz = Ground()
	rc_eqsz = [
	          connect(sourcez.p, resistorz.p)
	          connect(resistorz.n, capacitorz.p)
	          connect(capacitorz.n, sourcez.n)
	          connect(capacitorz.n, groundz.g)
	         ]


	#résolution
	#@named _rc_modelz = ODESystem(rc_eqsz, t,[],[];discrete_events=[tₒₙ,tₖ])
    @named _rc_modelz = ODESystem(rc_eqsz, t,[],[])
	@named rc_modelz = compose(_rc_modelz,
	                          [resistorz, capacitorz, sourcez, groundz])
	sysz = structural_simplify(rc_modelz)
	u0z = [
	      capacitorz.v => 0.0
		 
	     ]
	probz = ODAEProblem(sysz,u0z, (0, 20))
	#probz = ODAEProblem(sysz,u0z, (0, 20),pevt)
	solz = solve(probz, Tsit5(),tstops=[tonz,toffz])
	plot(solz)
	
end

# ╔═╡ 7de718e3-d037-4b59-ab8b-9b07521ccfcb
solz[capacitorz.v]

# ╔═╡ 499207e1-716c-4e7d-84be-54b82cbee655
begin
plot(solz, idxs=[resistorz.v,resistorz.i])
	
end

# ╔═╡ d4890103-c2ef-4d19-a766-abb6cb5d319c
equations(sysz),observed(sysz),states(sysz),parameters(sysz),full_equations(sysz)

# ╔═╡ 25d9e03a-ccd3-4bbd-8eaf-23aa6a052d05
solz[resistorz.v]./solz[resistorz.i]

# ╔═╡ f9f44a72-6ba4-4715-aba2-cbf9b053367d
plot(solz, idxs=[resistorz.i,resistorz.v])

# ╔═╡ a495c951-cf80-4646-9438-1e4de38348ab
begin
# NANOPULSE Une ligne chargant une capacité Cout
# Un switch parfait swpulse  fermeture ouverture pour l'impulsion courte
# Deux autres switchs swcc,sw50 pour traiter les réflexions (CC et 50 ohm)
	#plot()
    
	#switch sw50
	ton50=26.0e-9
	toff50=80.0e-9
	@named sw50=Switch1(ton=ton50,toff=toff50,ron=50.0,roff=1e6)
	#tₒₙ50=[ton50] =>[sw50.rsw ~ ron]    #ODESYSTEM discrete_events=[tₒₙ,tₖ]
	#tₖ50=[toff50] =>[sw50.rsw ~ roff]
	#pin50=[sw50.rsw=>roff] 
	
	#switch swpulse
	ronsw=1e-3
	roffsw=1e6
	rinisw=1e6
	tonnp=5.0e-9
	toffnp=25.0e-9
	@named swpulse=Switch1(ton=tonnp,toff=toffnp,ron=1e-3,roff=1e6)
	#tₒₙnp=[tonnp] =>[swpulse.rsw ~ ron]    #ODESYSTEM discrete_event=[tₒₙ,tₖ]
	#tₖnp=[toffnp] =>[swpulse.rsw ~ roff]
	#pininp=[swpulse.rsw=>roff]          # ODAEProblem(sysz,u0z, (0, 20),pevt)
	#pini=[swpulse.rsw=>roff,sw50.rsw=>roff]
	#discrete_events= [tₒₙnp,tₖnp,tₒₙ50,tₖ50]
	rswpulse(t)=IfElse.ifelse(t<=tonnp,rinisw,IfElse.ifelse(t<=toffnp,ronsw,roffsw))
	pini=[]
	
	@named npline=line(name="npline")
	@named vin=Capacitor(C=1)  #ConstantVoltage(V=5e3)    
	@named rcircuit=Resistor(R=1e-3)
	
	@named groundnp=Ground()
	@named vprobe=VoltageSensor()
	
	rc_eqsnp = [
	          connect(vin.p, swpulse.p,vprobe.p)
	          connect(swpulse.n,vprobe.n, rcircuit.p)
			  connect(swpulse.n, sw50.p)
			  connect(rcircuit.n, npline.li_1.p)        
	          connect( groundnp.g,vin.n,sw50.n,npline.ci_1.n)
	         ]
	
	@named _rc_modelnp = ODESystem(rc_eqsnp, t) #;discrete_events=discrete_events)
	@named rc_modelnp = compose(_rc_modelnp, [groundnp,rcircuit,vin,sw50,swpulse,npline,vprobe])

		u0np=[ ]
		for i in 1:nloop-1	
			npstr="npline.ci_"*string(i)*".v"
			nppair=eval(Meta.parse(npstr*"=>0.0"))
			push!(u0np,nppair)
		
			#npstr="npline.li_"*string(i)*".i"
			#nppair=eval(Meta.parse(npstr*"=>0.0"))
			#push!(u0np,nppair)
		end
		push!(u0np,npline.cout.v=>0.0)
	    push!(u0np,vin.v=>5.0e3)
	    #push!(u0np,r50.v=>0.0)
	    #push!(u0np,swpulse.v=>2.5e3)
	    push!(u0np,npline.li_1.i=>0.0)
	
        u0np=convert(Vector{Pair{Num, Float64}},u0np)
		sysnp = structural_simplify(rc_modelnp)
	
		probnp = ODAEProblem(sysnp, u0np, (0, toff50)) #,pini)
		
end


# ╔═╡ 28b4ec1c-5c92-46ea-af2c-d9cf2e060965
u0np

# ╔═╡ 06f3aef2-97c1-4cc5-901c-5ce74cda120a
plot(rswpulse(t),0:1e-9:75e-9)

# ╔═╡ 6468e745-1aa6-470e-b6a2-0a6e9a4ae566
observed(sysnp)

# ╔═╡ b4f2065a-6b8a-45aa-a1ff-1f84381c6de1
myvarnpix=findall(x -> occursin(" ~",x),string.(full_equations(rc_modelnp))) #

# ╔═╡ 73a6e8bd-487e-4892-9680-b5584a391295
string.(full_equations(rc_modelnp))[7][1:19] #findfirst("~", string.(full_equations(rc_modelnp))[7])

# ╔═╡ 31dc7d14-3eca-4c00-8e7c-e61397278202
findfirst("~", string.(full_equations(rc_modelnp))[7])

# ╔═╡ c79d3dee-80b7-4d65-ad64-26c571125e4a
value(full_equations(rc_modelnp)[10].lhs)

# ╔═╡ e055f5fa-d71d-4309-9a1c-9270d973c3f7
ixr50=findall( x -> occursin("r50₊i(t) ~",x) ,string.(observed(sysnp)))

# ╔═╡ 1d6f6f3a-8bf9-4c1c-a32f-322945107d54
observed(sysnp)[eval(Meta.parse(string(ixr50)))]

# ╔═╡ d9437005-df90-4c71-aa75-f934668fa9c9
string.(states(sysnp))

# ╔═╡ 0a5a5433-816e-48b0-ab5c-9f1f0a637ecd
vcat(string.(states(sysnp)),string.(observed(sysnp)))

# ╔═╡ b07cd205-b80c-46a5-b3ac-15e687b1c55e
string(observed(sysnp)[210])  #states(sysnp),

# ╔═╡ 54b04a46-bc23-4495-94e8-bbc315e6b9b8
string(equations(sysnp)[1]) #full_equations(sysnp) #

# ╔═╡ b02d1db7-4f66-45d2-ac29-846d296d1144
begin
	plot()
	solnp = solve(probnp, Tsit5(),tstops = [tonnp, toffnp,ton50,toff50])
	plot(solnp,idxs=[npline.cout.v,vprobe.v],ylims=(-300,1e4),xlims=(0.0,toff50))
end

# ╔═╡ 10d31e87-5d57-42c8-9df1-98263a873196
begin
	plot(solnp,idxs=[sw50.i],ylimits=(0,200))
end

# ╔═╡ 362c1a8b-10d7-4318-96eb-a2f23c6be8e3
solnp[sw50.v]

# ╔═╡ 8998ddc7-028b-423f-85ed-8e60ee552272
plot(solnp,idxs=[npline.cout.v],tspan=[20e-9,29e-9])

# ╔═╡ 7e4ed6e4-31f7-4c9f-95f1-dd6e62867d8b
solnp[npline.ci_1.v]

# ╔═╡ 5b21dd56-2bf1-41a6-9127-9ea2a920d72b
plot(solnp, idxs= [npline.cout.v],ylims=(-1.2e4,1.5e4))

# ╔═╡ c47c7480-4049-4bbd-864d-0f79b1023877
solnp[npline.cout.v]

# ╔═╡ b278d2fd-8c77-4f90-90ee-26428fe9194a
solnp(3e-9)

# ╔═╡ 994f178f-2465-4e02-b9ba-c10bfaed4155
solnp(3e-8)

# ╔═╡ bf742564-7f6b-471a-9972-49067cd327c3
equations(sysnp)

# ╔═╡ a1d3bdc6-a680-4d41-a5ab-47d41efb1927
plot(solnp,idxs=[swpulse.i],tstops=[tonnp,toffnp,ton50,toff50])

# ╔═╡ 5c8cf8bc-9594-47fc-9eb3-641cf9277b8b
plot(solnp,idxs=[swpulse.v])

# ╔═╡ bf1d13a5-1bd8-4af7-8aee-b906fe6dc85c
plot(solnp[swpulse.i],ylimits=[0.0,5000])

# ╔═╡ b051569e-fc1d-4eaf-b3a5-6bda906fa363
plot(solnp,idxs=[swpulse.i],ylimit=(0,5000))

# ╔═╡ bd605376-5af9-4c44-b179-e7792a47aacc
plot(solnp,idxs=[npline.cout.v])

# ╔═╡ abebbaa2-c246-445c-bb78-353576959dae
50*quadgk(i2_50, 0, toff50, rtol=1e-3)[1]*100000

# ╔═╡ 5df71cc8-f0d2-4672-9975-e7dd9c3e3130
maximum(solnp[npline.cout.v])

# ╔═╡ 7d7f443a-238a-48fe-9840-b15699ac1ae8
solnp[npline.cout.v][Int64((end+1)/2)]

# ╔═╡ ce9aeba4-7751-426e-b4bb-0147f6ccb3ce
sum(abs2,solnp[npline.cout.v])

# ╔═╡ ab949d5e-ecec-49db-a53b-442023a8e502
begin # create function for state variables
	for i in 1:length(states(sysnp))
		eval(Meta.parse(string(states(sysnp)[i])*"=solnp(t)["*string(i)*"]" ))
	end
end

# ╔═╡ 3c07c738-00df-468e-bb64-2176f58bc1b8
string(states(sysnp)[41])*"=solnp(t)["*string(41)*"]"

# ╔═╡ 1702b759-ef49-474b-b1fc-3fbc1ff1bf4c
begin
@bind veg MultiSelect(string.(observed(sysnp)))
end

# ╔═╡ a7341e35-682a-4db4-8b33-88bd46fa84a3
begin  # create fuction for observed value only . Activated on veg change
	veg
	vegix=[]
for j in 1:length(veg)
	push!(vegix,findfirst(i==string(veg[j]) for i  in collect(string.(observed(sysnp)))))
end
	for i in 1:length(observed(sysnp))
	#eval.(Meta.parse.([replace(string(observed(sysnp)[vegix[i]]),"~"=>"=") for i in 1:length(vegix)]))
		eval(Meta.parse(replace(string(observed(sysnp)[i]),"~"=>"=")))
	end
	
end

# ╔═╡ bf134849-afb3-4577-b692-e4622a67fa95
begin
	observedlabel=Matrix{String}(undef, 1, length(vegix))
	observedvars=""
    for i in 1:length(vegix)
		
		observedlabel[1,i]=string(myfunct[i])
	end
end

# ╔═╡ f25f5246-4cb7-4fe3-9518-6920a6d63711
begin
	plot()
	tvec =collect( 0.0:1e-9:75e-9)
	plot([i for i in myfunct],tvec,label=observedlabel,layout = (length(veg), 
	1)) 
end

# ╔═╡ 906b5b77-c408-44a4-8505-1110b1df18fc
observedlabel

# ╔═╡ 6dad160b-d262-42f2-bfd1-53a83f94b66a
convert(Matrix{String},1,8, [observedlabel])

# ╔═╡ c3a1e3b4-a574-47df-a561-ddb12082455e
observedlabel

# ╔═╡ e89ed2c6-8ec4-4235-9513-cf0cc167f8ad
begin  # active when vegix change
	vegix
	npline₊li_19₊n₊v(3e-9)
end

# ╔═╡ 6febb1b8-b10f-485a-80ed-79a8c6578880
replace(string(observed(sysnp)[41]),"~"=>"=")

# ╔═╡ 582dc111-11fa-4d07-b5db-9b47d4cd3c21
string.(states(sysnp))[41]

# ╔═╡ f3a96af3-c035-4e12-a54e-4a6a75321d0b
eval.(Meta.parse.([replace(string(observed(sysnp)[vegix[i]]),"~"=>"=") for i in 1:length(vegix)]))

# ╔═╡ 33c5398e-88c8-4345-bf4c-86755e626dcb
eval.(Meta.parse.([replace(string(observed(sysnp)[vegix[i]]),"~"=>"=") for i in [150]]))

# ╔═╡ 9de72fd8-26d9-4fb6-8092-4cced8830836
string.(observed(sysnp))

# ╔═╡ 1d108e93-c8f9-491a-8337-c749958a8d1a
states(sysnp)

# ╔═╡ Cell order:
# ╠═c7daeaf9-904a-4cf4-8d57-868c1b0cc979
# ╠═9ba3e523-5b6d-4d28-81a5-ed1ef212f781
# ╠═a2a565c5-1a4f-43a5-9193-0e1cf373e18a
# ╠═d34ff992-dbc5-4a65-8191-0f671f20d455
# ╠═7de718e3-d037-4b59-ab8b-9b07521ccfcb
# ╠═499207e1-716c-4e7d-84be-54b82cbee655
# ╠═d4890103-c2ef-4d19-a766-abb6cb5d319c
# ╠═25d9e03a-ccd3-4bbd-8eaf-23aa6a052d05
# ╠═f9f44a72-6ba4-4715-aba2-cbf9b053367d
# ╠═a495c951-cf80-4646-9438-1e4de38348ab
# ╠═28b4ec1c-5c92-46ea-af2c-d9cf2e060965
# ╠═10d31e87-5d57-42c8-9df1-98263a873196
# ╠═362c1a8b-10d7-4318-96eb-a2f23c6be8e3
# ╠═06f3aef2-97c1-4cc5-901c-5ce74cda120a
# ╠═6468e745-1aa6-470e-b6a2-0a6e9a4ae566
# ╠═b4f2065a-6b8a-45aa-a1ff-1f84381c6de1
# ╠═73a6e8bd-487e-4892-9680-b5584a391295
# ╠═31dc7d14-3eca-4c00-8e7c-e61397278202
# ╠═c79d3dee-80b7-4d65-ad64-26c571125e4a
# ╠═e055f5fa-d71d-4309-9a1c-9270d973c3f7
# ╠═1d6f6f3a-8bf9-4c1c-a32f-322945107d54
# ╠═8998ddc7-028b-423f-85ed-8e60ee552272
# ╠═7e4ed6e4-31f7-4c9f-95f1-dd6e62867d8b
# ╠═5b21dd56-2bf1-41a6-9127-9ea2a920d72b
# ╠═09ff0531-188e-4203-a328-649011e2280d
# ╠═c47c7480-4049-4bbd-864d-0f79b1023877
# ╠═d9437005-df90-4c71-aa75-f934668fa9c9
# ╠═b278d2fd-8c77-4f90-90ee-26428fe9194a
# ╠═0a5a5433-816e-48b0-ab5c-9f1f0a637ecd
# ╠═b07cd205-b80c-46a5-b3ac-15e687b1c55e
# ╠═54b04a46-bc23-4495-94e8-bbc315e6b9b8
# ╠═b02d1db7-4f66-45d2-ac29-846d296d1144
# ╠═bf742564-7f6b-471a-9972-49067cd327c3
# ╠═a1d3bdc6-a680-4d41-a5ab-47d41efb1927
# ╠═5c8cf8bc-9594-47fc-9eb3-641cf9277b8b
# ╠═bf1d13a5-1bd8-4af7-8aee-b906fe6dc85c
# ╠═b051569e-fc1d-4eaf-b3a5-6bda906fa363
# ╠═bd605376-5af9-4c44-b179-e7792a47aacc
# ╠═abebbaa2-c246-445c-bb78-353576959dae
# ╠═3369d29a-9f07-4c2c-ace2-4316839f3781
# ╠═5df71cc8-f0d2-4672-9975-e7dd9c3e3130
# ╠═e6ec45a2-5a82-47bf-9797-a754970613ca
# ╠═7d7f443a-238a-48fe-9840-b15699ac1ae8
# ╠═ce9aeba4-7751-426e-b4bb-0147f6ccb3ce
# ╠═42d502b0-b21a-46e7-8d17-dc15eef09dcd
# ╠═ab949d5e-ecec-49db-a53b-442023a8e502
# ╠═f6b4f678-da14-48bd-b174-094220cdbff4
# ╠═3c07c738-00df-468e-bb64-2176f58bc1b8
# ╠═e843f6c1-6933-4282-8943-56ec9c77a37a
# ╠═994f178f-2465-4e02-b9ba-c10bfaed4155
# ╠═184fdf94-af5d-4aa1-99f8-9177eef71df4
# ╠═7009ebea-27fc-4ab0-9efd-9ab0367230ec
# ╠═1702b759-ef49-474b-b1fc-3fbc1ff1bf4c
# ╠═6f745422-bd58-43fc-9a2d-65842b8d7664
# ╠═a7341e35-682a-4db4-8b33-88bd46fa84a3
# ╠═6febb1b8-b10f-485a-80ed-79a8c6578880
# ╠═0d7b5f8e-f039-41f2-a8e4-1182deda2536
# ╠═3d8e0dc0-52d4-4418-be09-a26fdd01b151
# ╠═582dc111-11fa-4d07-b5db-9b47d4cd3c21
# ╠═b9c7472a-4981-4e45-9146-0cbaf8f7a022
# ╠═f3a96af3-c035-4e12-a54e-4a6a75321d0b
# ╠═33c5398e-88c8-4345-bf4c-86755e626dcb
# ╠═4a6d809d-1437-4193-9ab3-7a47fa3e69e7
# ╠═352b8f59-b52b-4e40-bcfb-fcf3794638e7
# ╠═f25f5246-4cb7-4fe3-9518-6920a6d63711
# ╠═f993ee10-acd8-4ae5-be54-4cdaa9e4491f
# ╠═95d78452-8f00-4d96-82f2-360851d17bd6
# ╠═bf134849-afb3-4577-b692-e4622a67fa95
# ╠═9de72fd8-26d9-4fb6-8092-4cced8830836
# ╠═d6964882-64f6-4454-bfa8-fa7f6c13eaa7
# ╠═1d108e93-c8f9-491a-8337-c749958a8d1a
# ╠═906b5b77-c408-44a4-8505-1110b1df18fc
# ╠═e89ed2c6-8ec4-4235-9513-cf0cc167f8ad
# ╠═6dad160b-d262-42f2-bfd1-53a83f94b66a
# ╠═c3a1e3b4-a574-47df-a561-ddb12082455e
# ╟─740f22e3-35ce-4c75-aab6-8a913d688cf1
# ╠═e1506254-49e3-46c7-b407-900bab0167a2
# ╠═a295d5b2-1e24-49d9-9312-8d0b4c58bafe
# ╠═796f8d72-437c-4c71-b24a-cf63625ef0db
# ╟─f5f9aa89-6842-4e50-a85f-eeeafb613a1f
# ╠═db983b9d-872d-4155-b30c-28e493f8900b
# ╠═0102cab9-ffa9-49e9-b56a-e2d1fea2389c
# ╠═cda90c96-f253-46f3-90fb-1acbcb9570ce
# ╠═bbd7d4d4-d6ab-422c-8609-f9cb2fd2af97
# ╠═5b707670-7ecb-4458-b16d-a818b0930c2b
# ╠═4a6f61b7-c30d-4174-803e-3df380747982
# ╠═5780387b-68ae-409d-b5aa-120f00456f6e
# ╠═baef13c4-dc58-49df-b877-6d15d60212a5
