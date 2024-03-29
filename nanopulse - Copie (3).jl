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

# ╔═╡ 5780387b-68ae-409d-b5aa-120f00456f6e
begin
	using ModelingToolkit
	using BasicBSpline
	using Plots
	#using BasicBSplineExporter
	using StaticArrays
	using QuadGK
	using IfElse
	using DifferentialEquations
	using DataInterpolations
	using Interpolations
	using Sobol
	using PlutoUI
end

# ╔═╡ b221a55a-566d-4922-97ba-e8c53b707075
using  Statistics

# ╔═╡ b179584b-d9c9-4ba2-b069-af55726f9b71
md"""
## Plan de travail
- switch avec capacité parasite/masse & inductance et transil si surtension
- interpolation de i(t) des diodes 
- calcul du timing pour un cahier des charges nanopulse donné 
- calcul des pertes thermiques, Vmav irms etc...
_ ground specifique au projet
"""

# ╔═╡ eb987440-3e6e-485f-8915-8e00d60a518d
begin
	prfnp=1e4  # pulse repetition frequency
	tpulsenp=20e-9  # pulse duration
	typenp="monopolar"  # monopolar pulse other option bipolar pulse "bipolar" 
	nbpulsenp=2 # total number of number of pulses
	linelengthnp=3 # in meter  5ns/m typical
	swonnp=5e-9  # initial delay
	swtrnp=5e-9  #rise and fall time
	swtoff=swonnp+tpulsenp
	crbr=IfElse.ifelse(typenp=="monopolar",1e6,IfElse.ifelse(typenp=="bipolar",1e-6,50))
	inouttime=5e-9*linelengthnp*2
	#crowbar commutes after initial pulse closing until n reflexion occurs 
	crbswtonnp=swtoff+swtrnp
	crbswtoffnp=crbswtonnp+inouttime*(nbpulsenp-1)
end
	

# ╔═╡ 16ded44f-1449-4f51-8c1b-2e18188b1704

		fail
function SwitchET(;name,ton=ton,twidth=twidth,rt=rt,ron=1e-3,roff=1e6,rdiode=1e-3)

		@named oneport = OnePort()
	    @unpack v, i = oneport


			
		function r_switch(t;i=i,ton=ton,twidth=twidth,rt=rt,ron=ron,roff=roff,rdiode=rdiode)
			IfElse.ifelse(i<0.0,rdiode,
				   IfElse.ifelse(t<=ton,
				   	roff,
				   	IfElse.ifelse(t<=ton+rt,
				   			(ron-roff)/rt*t+roff-(ron-roff)/rt*ton,
				   			IfElse.ifelse(t<=ton+twidth, 
								ron,
								IfElse.ifelse(t<ton+twidth+rt,
					   				(roff-ron)/rt*t+ron-(roff-ron)/rt*(ton+twidth),
									roff
								)))))
		end	
			
		eval(Meta.parse("@register_symbolic r_switch(t,i)"))
		sts= []#@variables t rsw
		ps= @parameters ton=ton twidth=twidth rt=rt rdiode=rdiode
		#a=(roff-ron)/tr  b=ron-a*(ton+twidth)
	    eqs = [    
			   v ~ i*r_switch(t)
				   ]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
		end

# ╔═╡ ae62780f-4171-4782-be1b-c3153a3b3e24
md"""
Il est nécessaire de supprimer une variable avant de la recréer par eval(Meta.parse...

cpar1l=nothing
eval(Meta.parse("@named cpar"*project*"=Capacitor(C=cpar)"))

On peut aussi l'encapsuler dans une fonction

"""

# ╔═╡ 54c50217-3d1b-41bb-9172-4562284b6017
begin
	cpar1l=nothing
	project="1l"
	eval(Meta.parse("@named cpar"*project*"=Capacitor(C=cpar"*project*")"))
end

# ╔═╡ 04082fc8-8830-4fe0-8276-f98fa7619238
gr

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

# ╔═╡ c1fca69b-bf9e-4341-bb72-37012bd2703b
begin
#switch ideal
	function SwitchET1(;name,R=1e3,Cp=1e-11)
		@parameters R=R Cp=cp
		@named oneport = OnePort()
	    @unpack v, i = oneport
        sts=[]
		ps=[]
		eqs = [    
			   v ~ i*R
				   ]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
	end
	
	swet=SwitchET1(name=:swet)
	
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
				push!(rc_eqs3,connect(li[i].p,ci[i].p,li[i+1].p))
			end
		catch
		end

		for i in 2:nloop-1
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

		function Switchrt(;name,ton=ton,twidth=twidth,rt=rt,ron=1e-3,roff=1e6) 
		@named oneport = OnePort()
	    @unpack v, i = oneport
	   sts= []#@variables t rsw
		ps= @parameters ton=ton twidth=twidth rt=rt
		#a=(roff-ron)/tr  b=ron-a*(ton+twidth)
	    eqs = [    
			   v ~ i*(IfElse.ifelse(t<=ton,
				   	roff,
				   	IfElse.ifelse(t<=ton+rt,
				   			(ron-roff)/rt*t+roff-(ron-roff)/rt*ton,
				   			IfElse.ifelse(t<=ton+twidth, 
								ron,
								IfElse.ifelse(t<ton+twidth+rt,
					   				(roff-ron)/rt*t+ron-(roff-ron)/rt*(ton+twidth),
									roff
								)))))]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
		end


	   
	
		function SwitchET(;name,ton=ton,twidth=twidth,rt=rt,ron=1e-3,roff=1e6,rdiode=1e-3)

		@named oneport = OnePort()
	    @unpack v, i = oneport


			
		function r_switch(t;i=i,ton=ton,twidth=twidth,rt=rt,ron=ron,roff=roff,rdiode=rdiode)
			IfElse.ifelse(i<0.0,rdiode,
				   IfElse.ifelse(t<=ton,
				   	roff,
				   	IfElse.ifelse(t<=ton+rt,
				   			(ron-roff)/rt*t+roff-(ron-roff)/rt*ton,
				   			IfElse.ifelse(t<=ton+twidth, 
								ron,
								IfElse.ifelse(t<ton+twidth+rt,
					   				(roff-ron)/rt*t+ron-(roff-ron)/rt*(ton+twidth),
									roff
								)))))
		end	
			
		eval(Meta.parse("@register_symbolic r_switch(t,i)"))
		sts= []#@variables t rsw
		ps= @parameters ton=ton twidth=twidth rt=rt rdiode=rdiode
		#a=(roff-ron)/tr  b=ron-a*(ton+twidth)
	    eqs = [    
			   v ~ i*r_switch(t)
				   ]
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
	@named resistorz = Switch1(ton=tonz,toff=toffz,ron=1e-3,roff=1e6)
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
	#@named sw50=SwitchET(ton=ton50,twidth=54e-9,ron= 1e6,roff=1e6,rt=5e-9)
	@named sw50=Switch1(ton=ton50,toff=toff50,ron= 1e6,roff=1e6)
	#tₒₙ50=[ton50] =>[sw50.rsw ~ ron]    #ODESYSTEM discrete_events=[tₒₙ,tₖ]
	#tₖ50=[toff50] =>[sw50.rsw ~ roff]
	#pin50=[sw50.rsw=>roff] 
	
	#switch swpulse
	ronsw=1e-3
	ronnp=1e-3
	#ronet=1e-3
	roffsw=1e6
	roffnp=1e6
	rinisw=1e6
	tonnp=5.0e-9
	#tonet=5.0e-9
	toffnp=25.0e-9
	rtnp=5e-9
	twidthnp=12e-9
	#twidthet=12e-9
	@named swpulse=SwitchET(ton=tonnp,twidth=twidthnp,ron=1e-3,roff=1e6,rt=5e-9)
	#@named swpulse=Switch1(ton=tonnp,toff=toffnp,ron=1e-3,roff=1e6)
	#@named swpulse=SwitchET(ton=tonnp,twidth=twidthnp,rt=rtnp) 
	rswpulse(t)=IfElse.ifelse(t<=tonnp,rinisw,IfElse.ifelse(t<=toffnp,ronsw,roffsw))
	rswpulsetr(t)=IfElse.ifelse(t<=tonnp,
				   	roffnp,
				   	IfElse.ifelse(t<=tonnp+rtnp,
				   			(ronnp-roffnp)/rtnp*t+roffnp-(ronnp-roffnp)/rtnp*tonnp,
				   			IfElse.ifelse(t<=tonnp+twidthnp, 
								ronnp,
								IfElse.ifelse(t<tonnp+twidthnp+rtnp,
					   				(roffnp-ronnp)/rtnp*t+ronnp-(roffnp-ronnp)/rtnp*(tonnp+twidthnp),
									roffnp
								))))
	pini=[]
	
	@named npline=line(name="npline")
	@named vin=Capacitor(C=1)  #ConstantVoltage(V=5e3)    
	@named rcircuit=Resistor(R=1)
	
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


# ╔═╡ 1e3266b2-c46a-4162-890e-953de4da4474
npline.cout

# ╔═╡ 06f3aef2-97c1-4cc5-901c-5ce74cda120a
plot(rswpulsetr,0:1e-9:75e-9)

# ╔═╡ b4f2065a-6b8a-45aa-a1ff-1f84381c6de1
myvarnpix=findall(x -> occursin(" ~",x),string.(full_equations(rc_modelnp))) #

# ╔═╡ 73a6e8bd-487e-4892-9680-b5584a391295
string.(full_equations(rc_modelnp))[7][1:19] #findfirst("~", string.(full_equations(rc_modelnp))[7])

# ╔═╡ 31dc7d14-3eca-4c00-8e7c-e61397278202
findfirst("~", string.(full_equations(rc_modelnp))[7])

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
	#solnp = solve(probnp, Tsit5(),tstops = [tonnp, toffnp,ton50,toff50])
	solnp = solve(probnp, Tsit5(),tstops = [tonnp, tonnp+twidthnp,ton50,toff50])
	#plot(solnp,idxs=[npline.cout.v]) #,ylims=(-1e4,1e4),xlims=(0.0,toff50))
end

# ╔═╡ 171c1ae3-bbeb-4b94-8423-1c0f15cd15fe
begin
# Check variable
	solnp
	cheksolstr="solnp"
	checkvarstr="npline.cout"  #swpulse
	checkvar=eval(Meta.parse(checkvarstr))  #npline.cout
	checksol=eval(Meta.parse(cheksolstr))  #solnp
	#plot(soln,checkvar.v)
	
	nothing
end

# ╔═╡ 65a3f1c1-1b41-4655-bcc4-c31ada9cb7df
plot(checksol,idxs=[checkvar.v],ylimits=(0,12000))

# ╔═╡ 09ab26e2-3a10-4455-b908-df0d1983e0a3
plot(checksol,idxs=[checkvar.i]) #,ylimits=(-10,16))

# ╔═╡ 976f8973-f4d6-447c-9d6f-c2980d8409fe
begin
checkintv=DataInterpolations.CubicSpline(checksol[checkvar.v],checksol[t])
checkinti=DataInterpolations.CubicSpline(checksol[checkvar.i],checksol[t])
end

# ╔═╡ a06350b1-013d-46da-ab1c-e6c7545ce81b
"vmax="*string(maximum(checkintv))*",imax="*string(maximum(checkinti))*",imean="*string(mean(checkinti))*",irms="*string(mean(abs2,checkinti))

# ╔═╡ 8998ddc7-028b-423f-85ed-8e60ee552272
plot(solnp,idxs=[npline.cout.v],tspan=[25e-9,29e-9])

# ╔═╡ 7e4ed6e4-31f7-4c9f-95f1-dd6e62867d8b
solnp[swpulse.v]

# ╔═╡ 5b21dd56-2bf1-41a6-9127-9ea2a920d72b
plot(solnp, idxs= [npline.cout.v])

# ╔═╡ c47c7480-4049-4bbd-864d-0f79b1023877
solnp[npline.cout.v]

# ╔═╡ b278d2fd-8c77-4f90-90ee-26428fe9194a
solnp(3e-9)

# ╔═╡ 994f178f-2465-4e02-b9ba-c10bfaed4155
solnp(3e-8)

# ╔═╡ 971b6584-34bd-44da-b6e5-2e9dcf1a2868
sysnp

# ╔═╡ 5778e0b0-a467-4620-a9c6-bd4d1e65c8e6
solnp[npline.cout.v]

# ╔═╡ bf742564-7f6b-471a-9972-49067cd327c3
full_equations(sysnp)

# ╔═╡ a1d3bdc6-a680-4d41-a5ab-47d41efb1927
plot(solnp,idxs=[swpulse.i],tstops=[tonnp,toffnp,ton50,toff50])

# ╔═╡ 5c8cf8bc-9594-47fc-9eb3-641cf9277b8b
plot(solnp,idxs=[swpulse.v])

# ╔═╡ bf1d13a5-1bd8-4af7-8aee-b906fe6dc85c
plot(solnp[swpulse.i])

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

# ╔═╡ 70acb7f4-510a-43dc-b389-84641e84b3c1


# ╔═╡ baef13c4-dc58-49df-b877-6d15d60212a5
begin
	#import Pkg; 
	#Pkg.add(url="https://github.com/hyrodium/BasicBSplineExporter.jl")
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
	#Pkg.add("Statistics")
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BasicBSpline = "4c5d9882-2acf-4ea4-9e48-968fd4518195"
DataInterpolations = "82cc6244-b520-54b8-b5a6-8a565e85f1d0"
DifferentialEquations = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
IfElse = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
Interpolations = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
ModelingToolkit = "961ee093-0014-501f-94e3-6117800e7a78"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
Sobol = "ed01d8cd-4d21-5b2a-85b4-cc3bdc58bad4"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
BasicBSpline = "~0.8.2"
DataInterpolations = "~3.10.1"
DifferentialEquations = "~7.5.0"
IfElse = "~0.1.1"
Interpolations = "~0.14.5"
ModelingToolkit = "~8.26.0"
Plots = "~1.34.4"
PlutoUI = "~0.7.43"
QuadGK = "~2.5.0"
Sobol = "~1.5.0"
StaticArrays = "~1.5.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.1"
manifest_format = "2.0"
project_hash = "0fbec88dd1ac3cc0acb27ef7a78575f7094f804b"

[[deps.AbstractAlgebra]]
deps = ["GroupsCore", "InteractiveUtils", "LinearAlgebra", "MacroTools", "Markdown", "Random", "RandomExtensions", "SparseArrays", "Test"]
git-tree-sha1 = "ba2beb5f2a3170a0ef87953daefd97135cf46ecd"
uuid = "c3fe647b-3220-5bb0-a1ea-a7954cac585d"
version = "0.27.4"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "5c0b629df8a5566a06f5fef5100b53ea56e465a0"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.2"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "195c5505521008abea5aee4f96930717958eac6f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.4.0"

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.ArrayInterface]]
deps = ["ArrayInterfaceCore", "Compat", "IfElse", "LinearAlgebra", "Static"]
git-tree-sha1 = "d6173480145eb632d6571c148d94b9d3d773820e"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "6.0.23"

[[deps.ArrayInterfaceCore]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "5bb0f8292405a516880a3809954cb832ae7a31c5"
uuid = "30b0a656-2188-435a-8636-2ec0e6a096e2"
version = "0.1.20"

[[deps.ArrayInterfaceGPUArrays]]
deps = ["Adapt", "ArrayInterfaceCore", "GPUArraysCore", "LinearAlgebra"]
git-tree-sha1 = "fc114f550b93d4c79632c2ada2924635aabfa5ed"
uuid = "6ba088a2-8465-4c0a-af30-387133b534db"
version = "0.2.2"

[[deps.ArrayInterfaceOffsetArrays]]
deps = ["ArrayInterface", "OffsetArrays", "Static"]
git-tree-sha1 = "c49f6bad95a30defff7c637731f00934c7289c50"
uuid = "015c0d05-e682-4f19-8f0a-679ce4c54826"
version = "0.1.6"

[[deps.ArrayInterfaceStaticArrays]]
deps = ["Adapt", "ArrayInterface", "ArrayInterfaceStaticArraysCore", "LinearAlgebra", "Static", "StaticArrays"]
git-tree-sha1 = "efb000a9f643f018d5154e56814e338b5746c560"
uuid = "b0d46f97-bff5-4637-a19a-dd75974142cd"
version = "0.1.4"

[[deps.ArrayInterfaceStaticArraysCore]]
deps = ["Adapt", "ArrayInterfaceCore", "LinearAlgebra", "StaticArraysCore"]
git-tree-sha1 = "a1e2cf6ced6505cbad2490532388683f1e88c3ed"
uuid = "dd5226c6-a4d4-4bc7-8575-46859f9c95b9"
version = "0.1.0"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "ac5cc6021f32a272ee572dd2a325049a1fa0d034"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "0.8.11"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AutoHashEquals]]
git-tree-sha1 = "45bb6705d93be619b81451bb2006b7ee5d4e4453"
uuid = "15f4f7f2-30c1-5605-9d31-71845cf9641f"
version = "0.2.0"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "d37d493a1fc680257f424e656da06f4704c4444b"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "0.17.7"

[[deps.BangBang]]
deps = ["Compat", "ConstructionBase", "Future", "InitialValues", "LinearAlgebra", "Requires", "Setfield", "Tables", "ZygoteRules"]
git-tree-sha1 = "7fe6d92c4f281cf4ca6f2fba0ce7b299742da7ca"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.3.37"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.BasicBSpline]]
deps = ["ChainRulesCore", "FastGaussQuadrature", "IntervalSets", "LinearAlgebra", "RecipesBase", "StaticArrays"]
git-tree-sha1 = "bf3a5e88f38e43a99129d48fe9c5cb6c56f75a4a"
uuid = "4c5d9882-2acf-4ea4-9e48-968fd4518195"
version = "0.8.2"

[[deps.Bijections]]
git-tree-sha1 = "fe4f8c5ee7f76f2198d5c2a06d3961c249cce7bd"
uuid = "e2ed5e7c-b2de-5872-ae92-c73ca462fb04"
version = "0.1.4"

[[deps.BitFlags]]
git-tree-sha1 = "84259bb6172806304b9101094a7cc4bc6f56dbc6"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.5"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "eaee37f76339077f86679787a71990c4e465477f"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.4"

[[deps.BoundaryValueDiffEq]]
deps = ["BandedMatrices", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase", "SparseArrays"]
git-tree-sha1 = "2f80b70bd3ddd9aa3ec2d77604c1121bd115650e"
uuid = "764a87c0-6b3e-53db-9096-fe964310641d"
version = "2.9.0"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "Static"]
git-tree-sha1 = "9bdd5aceea9fa109073ace6b430a24839d79315e"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.1.27"

[[deps.CSTParser]]
deps = ["Tokenize"]
git-tree-sha1 = "3ddd48d200eb8ddf9cb3e0189fc059fd49b97c1f"
uuid = "00ebfdb7-1f24-5e51-bd34-a7502290713f"
version = "3.3.6"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.CloseOpenIntervals]]
deps = ["ArrayInterface", "Static"]
git-tree-sha1 = "5522c338564580adf5d58d91e43a55db0fa5fb39"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.10"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonMark]]
deps = ["Crayons", "JSON", "URIs"]
git-tree-sha1 = "4cd7063c9bdebdbd55ede1af70f3c2f48fab4215"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.6"

[[deps.CommonSolve]]
git-tree-sha1 = "332a332c97c7071600984b3c31d9067e1a4e6e25"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.1"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "5856d3031cdb1f3b2b6340dfdc66b6d9a149a374"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.2.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.CompositeTypes]]
git-tree-sha1 = "d5b014b216dc891e81fea299638e4c10c657b582"
uuid = "b152e2b5-7a66-4b01-a709-34e65c35f657"
version = "0.1.2"

[[deps.CompositionsBase]]
git-tree-sha1 = "455419f7e328a1a2493cabc6428d79e951349769"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.1"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "fb21ddd70a051d882a1686a5a550990bbe371a95"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.4.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "1106fa7e1256b402a86a8e7b15c00c85036fef49"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.11.0"

[[deps.DataInterpolations]]
deps = ["ChainRulesCore", "LinearAlgebra", "Optim", "RecipesBase", "RecursiveArrayTools", "Reexport", "RegularizationTools", "Symbolics"]
git-tree-sha1 = "cd5e1d85ca89521b7df86eb343bb129799d92b15"
uuid = "82cc6244-b520-54b8-b5a6-8a565e85f1d0"
version = "3.10.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.DelayDiffEq]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "LinearAlgebra", "Logging", "NonlinearSolve", "OrdinaryDiffEq", "Printf", "RecursiveArrayTools", "Reexport", "SciMLBase", "UnPack"]
git-tree-sha1 = "5acc7807b906d6a938dfeb965a6ea931260f054e"
uuid = "bcd4f6db-9728-5f36-b5f7-82caef46ccdb"
version = "5.38.0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffEqBase]]
deps = ["ArrayInterfaceCore", "ChainRulesCore", "DataStructures", "Distributions", "DocStringExtensions", "FastBroadcast", "ForwardDiff", "FunctionWrappers", "FunctionWrappersWrappers", "LinearAlgebra", "Logging", "MuladdMacro", "NonlinearSolve", "Parameters", "Printf", "RecursiveArrayTools", "Reexport", "Requires", "SciMLBase", "Setfield", "SparseArrays", "Static", "StaticArrays", "Statistics", "Tricks", "ZygoteRules"]
git-tree-sha1 = "0f9f82671406d21f6275cb6e9336259f062e81fa"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.105.0"

[[deps.DiffEqCallbacks]]
deps = ["DataStructures", "DiffEqBase", "ForwardDiff", "LinearAlgebra", "Markdown", "NLsolve", "Parameters", "RecipesBase", "RecursiveArrayTools", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "f8cc1ad62a87988225a07524ef84c7df7264c232"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "2.24.1"

[[deps.DiffEqNoiseProcess]]
deps = ["DiffEqBase", "Distributions", "GPUArraysCore", "LinearAlgebra", "Markdown", "Optim", "PoissonRandom", "QuadGK", "Random", "Random123", "RandomNumbers", "RecipesBase", "RecursiveArrayTools", "ResettableStacks", "SciMLBase", "StaticArrays", "Statistics"]
git-tree-sha1 = "8ba7a8913dc57c087d3cdc9b67eb1c9d760125bc"
uuid = "77a26b50-5914-5dd7-bc55-306e6241c503"
version = "5.13.0"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "992a23afdb109d0d2f8802a30cf5ae4b1fe7ea68"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.11.1"

[[deps.DifferentialEquations]]
deps = ["BoundaryValueDiffEq", "DelayDiffEq", "DiffEqBase", "DiffEqCallbacks", "DiffEqNoiseProcess", "JumpProcesses", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEq", "Random", "RecursiveArrayTools", "Reexport", "SciMLBase", "SteadyStateDiffEq", "StochasticDiffEq", "Sundials"]
git-tree-sha1 = "f6b75cc940e8791b5cef04d29eb88731955e759c"
uuid = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
version = "7.5.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "0d7d213133d948c56e8c2d9f4eab0293491d8e4a"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.75"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "5158c2b41018c5f7eb1470d558127ac274eca0c9"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.1"

[[deps.DomainSets]]
deps = ["CompositeTypes", "IntervalSets", "LinearAlgebra", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "dc45fbbe91d6d17a8e187abad39fb45963d97388"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.5.13"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.DynamicPolynomials]]
deps = ["DataStructures", "Future", "LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Pkg", "Reexport", "Test"]
git-tree-sha1 = "d0fa82f39c2a5cdb3ee385ad52bc05c42cb4b9f0"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.4.5"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.ExponentialUtilities]]
deps = ["ArrayInterfaceCore", "GPUArraysCore", "GenericSchur", "LinearAlgebra", "Printf", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "b19c3f5001b11b71d0f970f354677d604f3a1a97"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.19.0"

[[deps.ExprTools]]
git-tree-sha1 = "56559bbef6ca5ea0c0818fa5c90320398a6fbf8d"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.8"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FastBroadcast]]
deps = ["ArrayInterface", "ArrayInterfaceCore", "LinearAlgebra", "Polyester", "Static", "StrideArraysCore"]
git-tree-sha1 = "21cdeff41e5a1822c2acd7fc7934c5f450588e00"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.2.1"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FastGaussQuadrature]]
deps = ["LinearAlgebra", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "58d83dd5a78a36205bdfddb82b1bb67682e64487"
uuid = "442a2c76-b920-505d-bb47-c5924d526838"
version = "0.4.9"

[[deps.FastLapackInterface]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "14a6f7a21125f715d935fe8f83560ee833f7d79d"
uuid = "29a986be-02c6-4525-aec4-84b980013641"
version = "1.2.7"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "87519eb762f85534445f5cda35be12e32759ee14"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.4"

[[deps.FiniteDiff]]
deps = ["ArrayInterfaceCore", "LinearAlgebra", "Requires", "Setfield", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "5a2cff9b6b77b33b89f3d97a4d367747adce647e"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.15.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "187198a4ed8ccd7b5d99c41b69c679269ea2b2d4"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.32"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.FunctionWrappers]]
git-tree-sha1 = "241552bc2209f0fa068b6415b1942cc0aa486bcc"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.2"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "a5e6e7f12607e90d71b09e6ce2c965e41b337968"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.1"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "6872f5ec8fd1a38880f027a26739d42dcda6691f"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.2"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "0ac6f27e784059c68b987f42b909ade0bcfabe69"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.68.0"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

[[deps.GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "fb69b2a645fa69ba5f474af09221b9308b160ce6"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.3"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "fb83fbe02fe57f2c068013aa94bcdf6760d3a7a7"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+1"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "ba2d094a88b6b287bd25cfa86f301e7693ffae2f"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.7.4"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.Groebner]]
deps = ["AbstractAlgebra", "Combinatorics", "Logging", "MultivariatePolynomials", "Primes", "Random"]
git-tree-sha1 = "144cd8158cce5b36614b9c95b8afab6911bd469b"
uuid = "0b43b601-686d-58a3-8a1c-6623616c7cd4"
version = "0.2.10"

[[deps.GroupsCore]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9e1a5e9f3b81ad6a5c613d181664a0efc6fe6dd7"
uuid = "d5909c97-4eac-4ecc-a3dc-fdd0858a4120"
version = "0.4.0"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "4abede886fcba15cd5fd041fef776b230d004cee"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.4.0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "b7b88a4716ac33fe31d6556c02fc60017594343c"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.8"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions", "Test"]
git-tree-sha1 = "709d864e3ed6e3545230601f94e11ebc65994641"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.11"

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

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.Inflate]]
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "f366daebdfb079fd1fe4e3d560f99a0c892e15bc"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "f67b55b6447d36733596aea445a9f119e83498b6"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.5"

[[deps.IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "3f91cd3f56ea48d4d2a75c2a65455c5fc74fa347"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.3"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterativeSolvers]]
deps = ["LinearAlgebra", "Printf", "Random", "RecipesBase", "SparseArrays"]
git-tree-sha1 = "1169632f425f79429f245113b775a0e3d121457c"
uuid = "42fd0dbc-a981-5370-80f2-aaf504508153"
version = "0.9.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

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

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.JuliaFormatter]]
deps = ["CSTParser", "CommonMark", "DataStructures", "Pkg", "Tokenize"]
git-tree-sha1 = "1ec2cb3b87d0c38e3b01c76d9b11639f1eaeec96"
uuid = "98e50ef6-434e-11e9-1051-2b60c6c9e899"
version = "1.0.10"

[[deps.JumpProcesses]]
deps = ["ArrayInterfaceCore", "DataStructures", "DiffEqBase", "DocStringExtensions", "FunctionWrappers", "Graphs", "LinearAlgebra", "Markdown", "PoissonRandom", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "StaticArrays", "TreeViews", "UnPack"]
git-tree-sha1 = "5a6e6c522e8a7b39b24be8eebcc13cc7885c6f2c"
uuid = "ccbc3e58-028d-4f4c-8cd5-9ae44345cda5"
version = "9.2.0"

[[deps.KLU]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse_jll"]
git-tree-sha1 = "cae5e3dfd89b209e01bcd65b3a25e74462c67ee0"
uuid = "ef3ab10e-7fda-4108-b977-705223b18434"
version = "0.3.0"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "92256444f81fb094ff5aa742ed10835a621aef75"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.8.4"

[[deps.KrylovKit]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "49b0c1dd5c292870577b8f58c51072bd558febb9"
uuid = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
version = "0.5.4"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LabelledArrays]]
deps = ["ArrayInterfaceCore", "ArrayInterfaceStaticArrays", "ChainRulesCore", "ForwardDiff", "LinearAlgebra", "MacroTools", "PreallocationTools", "RecursiveArrayTools", "StaticArrays"]
git-tree-sha1 = "3926535a04c12fb986028a4a86bf5a0a3cf88b91"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.12.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "ArrayInterfaceOffsetArrays", "ArrayInterfaceStaticArrays", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static"]
git-tree-sha1 = "b67e749fb35530979839e7b4b606a97105fe4f1c"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.10"

[[deps.Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

[[deps.LeastSquaresOptim]]
deps = ["FiniteDiff", "ForwardDiff", "LinearAlgebra", "Optim", "Printf", "SparseArrays", "Statistics", "SuiteSparse"]
git-tree-sha1 = "06ea4a7c438f434dc0dc8d03c72e61ee0bf3629d"
uuid = "0fc2ff8b-aaa3-5acd-a817-1944a5e08891"
version = "0.8.3"

[[deps.LevyArea]]
deps = ["LinearAlgebra", "Random", "SpecialFunctions"]
git-tree-sha1 = "56513a09b8e0ae6485f34401ea9e2f31357958ec"
uuid = "2d8b4e74-eb68-11e8-0fb9-d5eb67b50637"
version = "1.0.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearSolve]]
deps = ["ArrayInterfaceCore", "DocStringExtensions", "FastLapackInterface", "GPUArraysCore", "IterativeSolvers", "KLU", "Krylov", "KrylovKit", "LinearAlgebra", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "SparseArrays", "SuiteSparse", "UnPack"]
git-tree-sha1 = "c17007396b2ae56b8496f5a9857326dea0b7bb7b"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "1.26.0"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "5d4d2d9904227b8bd66386c1138cf4d5ffa826bf"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "0.4.9"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "ArrayInterfaceCore", "ArrayInterfaceOffsetArrays", "ArrayInterfaceStaticArrays", "CPUSummary", "ChainRulesCore", "CloseOpenIntervals", "DocStringExtensions", "ForwardDiff", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "SIMDDualNumbers", "SIMDTypes", "SLEEFPirates", "SnoopPrecompile", "SpecialFunctions", "Static", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "f06e8b4861f5f84b7041881e0c35f633b2a86bef"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.130"

[[deps.MLStyle]]
git-tree-sha1 = "0638598b2ea9c60303e036be920df8df60fe2812"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.14"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "6872f9594ff273da6d13c7c1a1545d5a8c7d0c1c"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.6"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Memoize]]
deps = ["MacroTools"]
git-tree-sha1 = "2b1dfcba103de714d31c033b5dacc2e4a12c7caa"
uuid = "c03570c3-d221-55d1-a50c-7939bbd78826"
version = "0.4.4"

[[deps.Metatheory]]
deps = ["AutoHashEquals", "DataStructures", "Dates", "DocStringExtensions", "Parameters", "Reexport", "TermInterface", "ThreadsX", "TimerOutputs"]
git-tree-sha1 = "0f39bc7f71abdff12ead4fc4a7d998fb2f3c171f"
uuid = "e9d8d322-4543-424a-9be4-0cc815abe26c"
version = "1.3.5"

[[deps.MicroCollections]]
deps = ["BangBang", "InitialValues", "Setfield"]
git-tree-sha1 = "6bb7786e4f24d44b4e29df03c69add1b63d88f01"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.1.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.ModelingToolkit]]
deps = ["AbstractTrees", "ArrayInterfaceCore", "Combinatorics", "ConstructionBase", "DataStructures", "DiffEqBase", "DiffEqCallbacks", "DiffRules", "Distributed", "Distributions", "DocStringExtensions", "DomainSets", "ForwardDiff", "FunctionWrappersWrappers", "Graphs", "IfElse", "InteractiveUtils", "JuliaFormatter", "JumpProcesses", "LabelledArrays", "Latexify", "Libdl", "LinearAlgebra", "MacroTools", "NaNMath", "NonlinearSolve", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLBase", "Serialization", "Setfield", "SimpleWeightedGraphs", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicUtils", "Symbolics", "UnPack", "Unitful"]
git-tree-sha1 = "cec7d5ff210bc086432bd42ed3b3386af12ac9a3"
uuid = "961ee093-0014-501f-94e3-6117800e7a78"
version = "8.26.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.MuladdMacro]]
git-tree-sha1 = "c6190f9a7fc5d9d5915ab29f2134421b12d24a68"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.2"

[[deps.MultivariatePolynomials]]
deps = ["ChainRulesCore", "DataStructures", "LinearAlgebra", "MutableArithmetics"]
git-tree-sha1 = "393fc4d82a73c6fe0e2963dd7c882b09257be537"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.4.6"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "4e675d6e9ec02061800d6cfb695812becbd03cdf"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.0.4"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "50310f934e55e5ca3912fb941dec199b49ca9b68"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.2"

[[deps.NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.NonlinearSolve]]
deps = ["ArrayInterfaceCore", "FiniteDiff", "ForwardDiff", "IterativeSolvers", "LinearAlgebra", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "StaticArrays", "UnPack"]
git-tree-sha1 = "a754a21521c0ab48d37f44bbac1eefd1387bdcfc"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "0.3.22"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "1ea784113a6aa054c5ebd95945fa5e52c2f378e7"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.7"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "02be9f845cb58c2d6029a6d5f67f4e0af3237814"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.1.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e60321e3f2616584ff98f0a4f18d98ae6f89bbb3"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.17+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "b9fe76d1a39807fdcf790b991981a922de0c3050"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.7.3"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.OrdinaryDiffEq]]
deps = ["Adapt", "ArrayInterface", "ArrayInterfaceGPUArrays", "ArrayInterfaceStaticArrays", "DataStructures", "DiffEqBase", "DocStringExtensions", "ExponentialUtilities", "FastBroadcast", "FastClosures", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "LinearAlgebra", "LinearSolve", "Logging", "LoopVectorization", "MacroTools", "MuladdMacro", "NLsolve", "NonlinearSolve", "Polyester", "PreallocationTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SnoopPrecompile", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "06dbf3ab4f2530d5c5464f78c9aba4cc300ed069"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "6.28.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "cf494dca75a69712a72b80bc48f59dcf3dea63ec"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.16"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "3d5bf43e3e8b412656404ed9466f1dcbf7c50269"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.0"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "284a353a34a352a95fca1d61ea28a0d48feaf273"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.34.4"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "2777a5c2c91b3145f5aa75b61bb4c2eb38797136"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.43"

[[deps.PoissonRandom]]
deps = ["Random"]
git-tree-sha1 = "9ac1bb7c15c39620685a3a7babc0651f5c64c35b"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.1"

[[deps.Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Requires", "Static", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "6ee5518f7baa05e154757a003bfb6936a174dbad"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.6.15"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "b42fb2292fbbaed36f25d33a15c8cc0b4f287fcf"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.1.10"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterfaceCore", "ForwardDiff"]
git-tree-sha1 = "3953d18698157e1d27a51678c89c88d53e071a42"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "311a2aa90a64076ea0fac2ad7492e914e6feeb81"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "3c009334f45dfd546a16a57960a821a1a023d241"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.5.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "7a1a306b72cfa60634f03a911405f4e64d1b718b"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.6.0"

[[deps.RandomExtensions]]
deps = ["Random", "SparseArrays"]
git-tree-sha1 = "062986376ce6d394b23d5d90f01d81426113a3c9"
uuid = "fb686558-2515-59ef-acaa-46db3789a887"
version = "0.4.3"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "612a4d76ad98e9722c8ba387614539155a59e30c"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.0"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "e7eac76a958f8664f2718508435d058168c7953d"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.3"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterfaceCore", "ArrayInterfaceStaticArraysCore", "ChainRulesCore", "DocStringExtensions", "FillArrays", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "StaticArraysCore", "Statistics", "Tables", "ZygoteRules"]
git-tree-sha1 = "3004608dc42101a944e44c1c68b599fa7c669080"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.32.0"

[[deps.RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "SnoopPrecompile", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "0a2dfb3358fcde3676beb75405e782faa8c9aded"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Referenceables]]
deps = ["Adapt"]
git-tree-sha1 = "e681d3bfa49cd46c3c161505caddf20f0e62aaa9"
uuid = "42d2dcc6-99eb-4e98-b66c-637b7d73030e"
version = "0.1.2"

[[deps.RegularizationTools]]
deps = ["Calculus", "Lazy", "LeastSquaresOptim", "LinearAlgebra", "MLStyle", "Memoize", "Optim", "Random", "Underscores"]
git-tree-sha1 = "d445316cca15281a4b36b63c520123baa256a545"
uuid = "29dad682-9a27-4bc3-9c72-016788665182"
version = "0.6.0"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.ResettableStacks]]
deps = ["StaticArrays"]
git-tree-sha1 = "256eeeec186fa7f26f2801732774ccf277f05db9"
uuid = "ae5879a3-cd67-5da8-be7f-38c6eb64a37b"
version = "1.1.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "cdc1e4278e91a6ad530770ebb327f9ed83cf10c4"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.3"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMDDualNumbers]]
deps = ["ForwardDiff", "IfElse", "SLEEFPirates", "VectorizationBase"]
git-tree-sha1 = "dd4195d308df24f33fb10dde7c22103ba88887fa"
uuid = "3cdde19b-5bb0-4aaf-8931-af3e248e098b"
version = "0.1.1"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "2ba4fee025f25d6711487b73e1ac177cbd127913"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.35"

[[deps.SciMLBase]]
deps = ["ArrayInterfaceCore", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "Preferences", "RecipesBase", "RecursiveArrayTools", "StaticArraysCore", "Statistics", "Tables"]
git-tree-sha1 = "2c7b9be95f91c971ae4e4a6e3a0556b839874f2b"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.59.4"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "38d88503f695eb0301479bc9b0d4320b378bafe5"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.2"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays", "Test"]
git-tree-sha1 = "a6f404cc44d3d3b28c793ec0eb59af709d827e4e"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.2.1"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sobol]]
deps = ["DelimitedFiles", "Random"]
git-tree-sha1 = "5a74ac22a9daef23705f010f72c81d6925b19df8"
uuid = "ed01d8cd-4d21-5b2a-85b4-cc3bdc58bad4"
version = "1.5.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SparseDiffTools]]
deps = ["Adapt", "ArrayInterfaceCore", "ArrayInterfaceStaticArrays", "Compat", "DataStructures", "FiniteDiff", "ForwardDiff", "Graphs", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays", "VertexSafeGraphs"]
git-tree-sha1 = "5fb8ba9180f467885e87a2c99cae178b67934be1"
uuid = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
version = "1.26.2"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "39c9f91521de844bad65049efd4f9223e7ed43f9"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.14"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "de4f0a4f049a4c87e4948c04acff37baf1be01a6"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.7.7"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "f86b3a049e5d05227b10e15dbb315c5b90f14988"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.9"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "5783b877201a82fc0014cbf381e7e6eb130473a4"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.0.1"

[[deps.SteadyStateDiffEq]]
deps = ["DiffEqBase", "DiffEqCallbacks", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "f4492f790434f405139eb3a291fdbb45997857c6"
uuid = "9672c7b4-1e72-59bd-8a11-6ac3964bc41f"
version = "1.9.0"

[[deps.StochasticDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqNoiseProcess", "DocStringExtensions", "FillArrays", "FiniteDiff", "ForwardDiff", "JumpProcesses", "LevyArea", "LinearAlgebra", "Logging", "MuladdMacro", "NLsolve", "OrdinaryDiffEq", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "8062351f645bb23725c494be74619ef802a2ffa8"
uuid = "789caeaf-c7a9-5a7d-9973-96adeb23e2a0"
version = "6.54.0"

[[deps.StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "ManualMemory", "SIMDTypes", "Static", "ThreadingUtilities"]
git-tree-sha1 = "ac730bd978bf35f9fe45daa0bd1f51e493e97eb4"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.3.15"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+0"

[[deps.Sundials]]
deps = ["CEnum", "DataStructures", "DiffEqBase", "Libdl", "LinearAlgebra", "Logging", "Reexport", "SnoopPrecompile", "SparseArrays", "Sundials_jll"]
git-tree-sha1 = "5717b2c13ddc167d7db931bfdd1a94133ee1d4f0"
uuid = "c3572dad-4567-51f8-b174-8c6c989267f4"
version = "4.10.1"

[[deps.Sundials_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg", "SuiteSparse_jll"]
git-tree-sha1 = "04777432d74ec5bc91ca047c9e0e0fd7f81acdb6"
uuid = "fb77eaff-e24c-56d4-86b1-d163f2edb164"
version = "5.2.1+0"

[[deps.SymbolicUtils]]
deps = ["AbstractTrees", "Bijections", "ChainRulesCore", "Combinatorics", "ConstructionBase", "DataStructures", "DocStringExtensions", "DynamicPolynomials", "IfElse", "LabelledArrays", "LinearAlgebra", "Metatheory", "MultivariatePolynomials", "NaNMath", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "TermInterface", "TimerOutputs"]
git-tree-sha1 = "027b43d312f6d52187bb16c2d4f0588ddb8c4bb2"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "0.19.11"

[[deps.Symbolics]]
deps = ["ArrayInterfaceCore", "ConstructionBase", "DataStructures", "DiffRules", "Distributions", "DocStringExtensions", "DomainSets", "Groebner", "IfElse", "Latexify", "Libdl", "LinearAlgebra", "MacroTools", "Markdown", "Metatheory", "NaNMath", "RecipesBase", "Reexport", "Requires", "RuntimeGeneratedFunctions", "SciMLBase", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicUtils", "TermInterface", "TreeViews"]
git-tree-sha1 = "873596ee5c98f913bcb2cbb2dc779d815c5aeb86"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "4.10.4"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "2d7164f7b8a066bcfa6224e67736ce0eb54aef5b"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.9.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.TermInterface]]
git-tree-sha1 = "7aa601f12708243987b88d1b453541a75e3d8c7a"
uuid = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"
version = "0.2.3"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "f8629df51cab659d70d2e5618a430b4d3f37f2c3"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.0"

[[deps.ThreadsX]]
deps = ["ArgCheck", "BangBang", "ConstructionBase", "InitialValues", "MicroCollections", "Referenceables", "Setfield", "SplittablesBase", "Transducers"]
git-tree-sha1 = "d223de97c948636a4f34d1f84d92fd7602dc555b"
uuid = "ac1d9e8a-700a-412c-b207-f0111f4b6c0d"
version = "0.1.10"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "9dfcb767e17b0849d6aaf85997c98a5aea292513"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.21"

[[deps.Tokenize]]
git-tree-sha1 = "2b3af135d85d7e70b863540160208fa612e736b9"
uuid = "0796e94c-ce3b-5d07-9a54-7f471281c624"
version = "0.5.24"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "8a75929dcd3c38611db2f8d08546decb514fcadf"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.9"

[[deps.Transducers]]
deps = ["Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "Setfield", "SplittablesBase", "Tables"]
git-tree-sha1 = "c76399a3bbe6f5a88faa33c8f8a65aa631d95013"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.73"

[[deps.TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[deps.TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "SnoopPrecompile", "Static", "VectorizationBase"]
git-tree-sha1 = "fdddcf6b2c7751cd97de69c18157aacc18fbc660"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.1.14"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Underscores]]
git-tree-sha1 = "6e6de5a5e7116dcff8effc99f6f55230c61f6862"
uuid = "d9a01c3f-67ce-4d8c-9b55-35f6e4050bb1"
version = "3.0.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "d57a4ed70b6f9ff1da6719f5f2713706d57e0d66"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.12.0"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static"]
git-tree-sha1 = "4699578969f75c56ca6a7814c54511cdf04a4966"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.50"

[[deps.VertexSafeGraphs]]
deps = ["Graphs"]
git-tree-sha1 = "8351f8d73d7e880bfc042a8b6922684ebeafb35c"
uuid = "19fa3120-7c27-5ec5-8db8-b0b0aa330d6f"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╠═b179584b-d9c9-4ba2-b069-af55726f9b71
# ╠═eb987440-3e6e-485f-8915-8e00d60a518d
# ╠═16ded44f-1449-4f51-8c1b-2e18188b1704
# ╠═1e3266b2-c46a-4162-890e-953de4da4474
# ╠═ae62780f-4171-4782-be1b-c3153a3b3e24
# ╠═54c50217-3d1b-41bb-9172-4562284b6017
# ╠═c1fca69b-bf9e-4341-bb72-37012bd2703b
# ╠═04082fc8-8830-4fe0-8276-f98fa7619238
# ╠═171c1ae3-bbeb-4b94-8423-1c0f15cd15fe
# ╠═65a3f1c1-1b41-4655-bcc4-c31ada9cb7df
# ╠═09ab26e2-3a10-4455-b908-df0d1983e0a3
# ╠═976f8973-f4d6-447c-9d6f-c2980d8409fe
# ╠═a06350b1-013d-46da-ab1c-e6c7545ce81b
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
# ╠═06f3aef2-97c1-4cc5-901c-5ce74cda120a
# ╠═b4f2065a-6b8a-45aa-a1ff-1f84381c6de1
# ╠═73a6e8bd-487e-4892-9680-b5584a391295
# ╠═31dc7d14-3eca-4c00-8e7c-e61397278202
# ╠═8998ddc7-028b-423f-85ed-8e60ee552272
# ╠═7e4ed6e4-31f7-4c9f-95f1-dd6e62867d8b
# ╠═5b21dd56-2bf1-41a6-9127-9ea2a920d72b
# ╠═c47c7480-4049-4bbd-864d-0f79b1023877
# ╠═d9437005-df90-4c71-aa75-f934668fa9c9
# ╠═b278d2fd-8c77-4f90-90ee-26428fe9194a
# ╠═0a5a5433-816e-48b0-ab5c-9f1f0a637ecd
# ╠═b07cd205-b80c-46a5-b3ac-15e687b1c55e
# ╠═54b04a46-bc23-4495-94e8-bbc315e6b9b8
# ╠═b02d1db7-4f66-45d2-ac29-846d296d1144
# ╠═971b6584-34bd-44da-b6e5-2e9dcf1a2868
# ╠═5778e0b0-a467-4620-a9c6-bd4d1e65c8e6
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
# ╠═70acb7f4-510a-43dc-b389-84641e84b3c1
# ╠═5780387b-68ae-409d-b5aa-120f00456f6e
# ╠═b221a55a-566d-4922-97ba-e8c53b707075
# ╠═baef13c4-dc58-49df-b877-6d15d60212a5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
