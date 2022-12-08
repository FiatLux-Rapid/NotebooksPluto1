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

# ╔═╡ c5d1f912-9fae-4f8e-ac43-80326f9b8268
begin
import Pkg; Pkg.add(url="https://github.com/hyrodium/BasicBSplineExporter.jl")
#=
	Pkg.add("BasicBSpline")
Pkg.add("StaticArrays")
Pkg.add("Plots")	
=#	
end


# ╔═╡ 681ceb3e-286f-11ed-33b8-43fdd33cf785
begin
using BasicBSpline
using Plots
using BasicBSplineExporter
using StaticArrays
end

# ╔═╡ d922eb21-0264-4e12-9e74-fc7682310936
begin
	using Interpolations

tz = 0:0.05:1
x = sin.(2π*tz)
y = cos.(2π*tz)
A = hcat(x,y)

itp = Interpolations.scale(interpolate(A, (BSpline(Cubic(Natural(OnGrid()))), NoInterp())), tz, 1:2)

tfine = 0:.001:1
xs, ys = [itp(t,1) for t in tfine], [itp(t,2) for t in tfine]
end

# ╔═╡ f33bbe69-d33b-46d1-add5-290645ad1f72
begin
	using Sobol
end

# ╔═╡ 2ede9640-e3ad-4084-8a81-7c649746f5d0
using IfElse

# ╔═╡ d9e571a8-c85b-43b2-a89d-e58001691107
using ModelingToolkit

# ╔═╡ 2607106f-a5c6-49f2-9cf5-05cdb9f659fc
using DifferentialEquations

# ╔═╡ f945a593-3690-499b-ba7f-0c51e408ff89
using DataInterpolations

# ╔═╡ 7c041ccd-20d7-4eac-a7a7-d01b527434d4
using QuadGK


# ╔═╡ 477f0bdc-cd15-4601-8f00-25263a70c8f3
using PlutoUI

# ╔═╡ 0fae61c8-a770-4366-bbf2-76e7995e4fbe
begin
p = 3
k = KnotVector(range(-2π,2π,length=8))+p*KnotVector(-2π,2π)
P = BSplineSpace{p}(k)

f(u) = SVector(u,sin(u))

a = fittingcontrolpoints(f, (P,))
M = BSplineManifold(a, (P,))
save_svg("sine-curve.svg", M, unitlength=50, xlims=(-2,2), ylims=(-8,8))
save_svg("sine-curve_no-points.svg", M, unitlength=50, xlims=(-2,2), ylims=(-2,2), points=false)
end
	

# ╔═╡ bffc0fa0-28b8-434b-961b-d266d02d5cf4
KnotVector(1)

# ╔═╡ a00a9f5e-7812-4d26-b7cb-91eaab236750
save_png("2dim.png", M) # save image

# ╔═╡ 81f1a20b-f1d6-403f-bd26-561f5a6b08ba
pwd()

# ╔═╡ 54b30380-b298-4906-8ed5-e7ce329862dc
#Pkg.add("Interpolations")

# ╔═╡ c3c750bb-ec10-4277-815c-23b4d6efa7eb
itp

# ╔═╡ 46cbeea8-eac3-47a5-8e26-40aabf9dcca4
scatter(xs, ys)

# ╔═╡ 937a05d0-a2a8-42f1-a18e-be6f980cf8f4
scatter!(x,y)

# ╔═╡ c570e19b-57e9-4426-8cd3-004de43254da
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

# ╔═╡ a25c4a50-cafb-4305-9457-5eb072a3e3c9
#Pkg.add("Sobol")

# ╔═╡ cead2d60-04bb-423e-a2fe-9205b7463997
#Pkg.add("PyPlot")

# ╔═╡ 03a767a1-0b47-42fa-ae4f-63f472adc369
begin
	mind=[]
	for i in 1:size(p1)[1]
		push!(mind,(((p1[i,1]-x1[1])/(ub[1]-lb[1]))^2+((p1[i,2]-x1[2])/(ub[2]-lb[2]))^2)^0.5 )
	end
end

# ╔═╡ 34b8af20-b7d2-4bbc-9be1-40440aeb17b3
x1

# ╔═╡ 4f14d959-a4be-4c9d-8c8c-6cd7cf3d6713
nearpoint=p1[findmin(mind)[2],:]

# ╔═╡ 3d22af7c-26b6-4dac-a27c-2ccdb6cd060f
begin

end

# ╔═╡ 32798c11-ffba-4e01-97bc-363f6798b2d6


# ╔═╡ fb3e71b5-7372-417e-8888-5b0114ca2ab8


# ╔═╡ f7fe7bf0-606d-46fc-9eca-2009a616337d
tscano

# ╔═╡ be5b8a95-f634-4347-ac1d-4925683759f7
farray

# ╔═╡ f2a86c2f-ff50-405c-b369-33dccc364575
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

# ╔═╡ dcc52de0-af12-40b1-bf7c-8b580d40893e
begin
	li=nothing
	ci=nothing
	
	rc_eqs2=[]
	clength=3
	nloop=20
	
	#name="myname"
	# réalisation d'unne ligne de transmission
	function line(;name="myname")
		
		
		
		local vari=""
		
		for i in 1:nloop-1
			vari*="li["*string(i)*"],ci["*string(i)*"],"
		end
		vari*="li["*string(nloop)*"],cout"
		
		#Cs=1e-12

		#eval(Meta.parse("@named cout=Capacitor(C=40e-12)"))
		Capacitor(name=:cout,C=40e-12)
		eval(Meta.parse("@named li 1:"*string(nloop)*" i -> Inductor(L=253e-9*"*string(clength/nloop)*")"))
	
		eval(Meta.parse("@named ci 1:"*string(nloop-1)*" i -> Capacitor(C=1e-10*"*string(clength/nloop)*")"))
		
	
		try
			for i in 1:nloop-1
				push!(rc_eqs2,connect(li[i].n,ci[i].p,li[i+1].p))
			end
		catch
		end
        try
			for i in 1:nloop-2
				push!(rc_eqs2,connect(ci[i].n,ci[i+1].n))
			end
		catch
		end
		push!(rc_eqs2,connect(li[nloop].n,cout.p))
		push!(rc_eqs2,connect(ci[nloop-1].n,cout.n))
		
	#var1=vari[1:end-1]
	  eval(Meta.parse(name*"=compose(ODESystem(rc_eqs2,t,name=:"*name*"),"*vari*")"))

	end
	
	@named myline=line(name="myline");
	nothing
end

# ╔═╡ 964cafb3-ff81-4e99-821b-0cbadb943315
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
	vup1(t)=vup(t,1e-8,1e5)
	plot(0:1e-9:200e-9,vup1)
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

	@named ground = Ground()
	
		rc_eqs = [ connect(source.p, resistor.p)
			   connect(resistor.n, myline.li_1.p)
		       connect(myline.ci_1.n, ground.g,source.n)]
	
		@named rc_model = ODESystem(rc_eqs, t)
		rc_model = compose(rc_model, [resistor, myline, source, ground])
	
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
	plot(sol, vars=[myline.cout.v])
		
end

# ╔═╡ 87ce2f92-ad52-435b-807c-c6dced9d222c
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
	@named level = VoltageSensor()
	#=
	function condition(u,t,integrator)
	    integrator.sol[level.v][end]<0.0
	end
	function affect!(integrator)
	    integrator.p[1] = 0.1*1e-3 
	end 
	cb = DiscreteCallback(condition,affect!, save_positions=(false,false))
	=#
end

# ╔═╡ 71569d42-feb4-4acc-96c5-9b20f8a4c595
begin
	#function llcfonction2(x)
		
		solllc1=[]
		solllc2=[]
		fr=freq1 #x[1]
		du=dut1 #x[2]
		
		#vcoave=[]
		  # try
			@named 	sour0 = Vdfvoltage(d=du,f=fr)
  			rc_eqsllc0 = [
			connect(sour0.p,tr.ls.p)
			connect(tr.lm.n,c_r.p)
			connect(c_r.n,sour0.n)
	 
			connect(tr.transf.ts.p,d1.d.p,d2.d.n)
			connect(tr.transf.ts.n, d3.d.p,d4.d.n)
			connect(d1.d.n,d3.d.n,r_s.p)
			connect( d2.d.p,d4.d.p,c_o.n,r_l.n)
			connect(r_s.n,c_o.p,r_l.p)
	        connect(tr.groundp.g,tr.grounds.g)]
		
			@named _rc_model_llc0 = ODESystem(rc_eqsllc0, t)
			@named rc_model_llc0 = compose(_rc_model_llc0,[sour0,tr,c_r,c_o,r_s,r_l,d1,d2,d3,d4])
			sys_llc0 = structural_simplify(rc_model_llc0)


	u0llc1=[]

    probllc0 = ODAEProblem(sys_llc0, u0llc1, (0, duration1)) #,jac=jacob)
	    solllc1 = solve(probllc0,TRBDF2(),maxiters=1e8,abstol=1e-9,reltol=1e-9)	
    	#solt(t)= solllc0(t)[4]
		#vcoave=mean(solt.(duration1-0.5/f:1e-6:duration1))  
         
	 	 push!(solllc2,solllc1)  
		#catch
	#	 solllc1=[]
	#	end  #try 
		
	#return solllc2
		
	#end	
	#zz=llcfonction2([200e3,0.95])
	end

# ╔═╡ 76f3b2f4-661e-432b-a88f-121b09ac6cfd
plot(solllc1,vars=[states(sys_llc0)[4]])

# ╔═╡ 78de9afe-c0fe-41f2-b8e9-fe308ee489a8


# ╔═╡ 18a05579-02c4-49cc-ad61-7a2417f518f1
prob_llc1 = ODAEProblem(sys_llc, [], (0.0, duration1)) #,jac=jacob)

# ╔═╡ 3672b8c2-5503-4648-83fc-d9e811489ee7
r_s

# ╔═╡ 569191c9-271b-4177-bb89-e42f4cd88ead
prob_llc1.u0

# ╔═╡ 4e5515df-77de-41d1-8870-4c0f0025c092
sys_llc,equations(sys_llc),states(sys_llc),observed(sys_llc),calculate_jacobian(sys_llc)

# ╔═╡ 5a9cdd1b-0358-4d4a-992a-a99dbdd3e48f
states(sys_llc)

# ╔═╡ eece0367-4438-4743-b0c6-b4fc0fdc4420
observed(sys_llc)

# ╔═╡ 944b8f33-62f7-4884-bb9a-4074fe21b805
solllc0 = solve(prob_llc1,TRBDF2(),maxiters=1e8,abstol=1e-9,reltol=1e-9)	

# ╔═╡ 4609822a-840d-4a32-b61b-a6e97dfdacc0


# ╔═╡ 318529e6-ca45-40b3-8f24-2aff34e0ff71


# ╔═╡ 631004a6-5f2f-487a-92c3-48499dcc0fb0
plot(solllc0,vars=[states(sys_llc)[4]])

# ╔═╡ 2bfd9ed4-8ed0-436d-97c6-837cd13dc09e
begin
	zoom_time=duration1-1.0/200e3:1e-8:duration1
endvco=[solllc0.(zoom_time)[i][4] for i in 1:length(zoom_time)]
	plot(zoom_time,endvco)
end

# ╔═╡ 21eb509b-3820-417c-af01-ee1a867116f6
begin
	
endvco1=[solllc1.(zoom_time)[i][4] for i in 1:length(zoom_time)]
	plot!(zoom_time,endvco1)
end

# ╔═╡ e70945c5-bfed-42b3-9cdb-a358c9de7199
solllc0.(zoom_time)

# ╔═╡ 1b6b96e1-e983-4908-9394-f487f6c7b3a1
states(sys_llc)

# ╔═╡ 53cf0863-3045-493d-99ef-47748c0e7e86
plot(solllc0, vars=states(sys_llc))

# ╔═╡ 7ca27045-9a6c-479b-9397-1d901b7147c1
typeof(sys_llc)

# ╔═╡ d22fadef-edee-4010-a555-489d97dcba40
prob_llc1.f

# ╔═╡ ffb4f13a-44fb-43b7-b614-87d947e17fef
equations(solllc0)

# ╔═╡ 6466fdde-b6dd-478b-8d24-5ec222a07d0b


# ╔═╡ aa4b77c9-165d-4845-b85d-35b0b523698a
begin
	xl=[]
	yl=[]
	zl=[]
	lbb=[90e3,0.1]
	hbb=[220e3,1.0]
	nl=2
	for i in  collect(1:1:nl)
		for j in collect(1:1:nl)
		newz=llcfonction2((lbb[1]+(hbb[1]-lbb[1])*(i-1)/49,lbb[2]+(hbb[2]-lbb[2])*(j-1)/49))
    		if newz!=[]
				push!(xl,lbb[1]+(hbb[1]-lbb[1])*(i-1)/(nl-1))
				push!(yl,lbb[2]+(hbb[2]-lbb[2])*(j-1)/(nl-1))
				push!(zl,newz)
			end
		end
	end
end

# ╔═╡ 94157a91-075f-40e9-a335-e5205f9501e0
zl

# ╔═╡ b0b2e8cb-1e51-4268-b20c-2727ec7ce244
#Pkg.add("IfElse")

# ╔═╡ a920f40c-7e13-406e-a7ec-efb4dff01639
#Pkg.add("DifferentialEquations")

# ╔═╡ dd326b99-85c6-4207-8e9d-645d1e500d4d
#Pkg.add("ModelingToolkit")

# ╔═╡ d34ff992-dbc5-4a65-8191-0f671f20d455
begin
	pz = [1.0e6]
	ton=0.0
	toff=30e-9
	function Switch(;name,ton=ton,toff=toff) 
	    @named oneport = OnePort()
	    @unpack v, i = oneport
	    ps = @parameters ton=ton  toff=toff
		eqsw = [ v ~ IfElse.ifelse((t>ton) & (t<=toff) ,1e-3*i,IfElse.ifelse(t>toff,1e6*i,1e6*i))]
	 return extend(ODESystem(eqsw, t, [], ps;name=name), oneport)
	               
	end
	
	Rz = 1.0e6
	
	Cz = 1.0
	Vz = 1.0
	@named resistorz = Switch(ton=ton,toff=toff)
	@named capacitorz = Capacitor(C=Cz)
	@named sourcez = ConstantVoltage(V=Vz)
	@named groundz = Ground()
	
	rc_eqsz = [
	          connect(sourcez.p, resistorz.p)
	          connect(resistorz.n, capacitorz.p)
	          connect(capacitorz.n, sourcez.n)
	          connect(capacitorz.n, groundz.g)
	         ]
	
	@named _rc_modelz = ODESystem(rc_eqsz, t)
	@named rc_modelz = compose(_rc_modelz,
	                          [resistorz, capacitorz, sourcez, groundz])
	sysz = structural_simplify(rc_modelz)
	u0z = [
	      capacitorz.v => 0.0
	     ]
	probz = ODAEProblem(sysz, u0z, (0, 60e-9))
	solz = solve(probz, Tsit5(),tstops = [ton, toff])
	plot(solz)
end

# ╔═╡ 3e1c02e2-5a38-4805-9bf5-8b57551fa3e1
begin
	@parameters tkill
	@parameters M1  α
	@variables w N(w)
	Dₜ = Differential(w)
	eqs1 = [Differential(w)(N) ~ α - N]
	
	# at time tinject we inject M cells
	#injection = (t == tinject) => [N ~ N + M]
	injection = [10.0] => [N ~ N + M1]
    #periodic
	#discrete_events=[1.0 => [v ~ -v]]

	# at time tkill we turn off production of cells
	#killing = (t == tkill) => [α ~ 0.0]
	killing = [20.0] => [α ~ 0.0]
	
	u01 = [N => 0.0]
	
	tspan = (0.0, 60.0)
	#p = [α => 100.0, tinject => 10.0, M => 50, tkill => 20.0]
	p11 = [α => 100.0, M1 => 50]

	#@named osys = ODESystem(eqs, t, [N], [α, M, tinject, tkill];discrete_events = [injection, killing])
	@named osys1 = ODESystem(eqs1, w, [N], [α, M1]; discrete_events = [injection, killing])
	oprob = ODEProblem(osys1, u01, tspan, p11)
	#sol = solve(oprob, Tsit5(); tstops = [10.0, 20.0])
	sol1 = solve(oprob, Tsit5())
	plot(sol1)
end

# ╔═╡ a495c951-cf80-4646-9438-1e4de38348ab
begin
# NANOPULSE Une ligne chargan une capacité Cout
# Un switch parfait swpulse  fermeture ouverture pour l'impulsion courte
# Deux autres switchs swcc,sw50 pour traiter les réflexions (CC et 50 ohm)
	#plot()
	tonnp=5.0e-9
	toffnp=15.0e-9
	ton50=16.0e-9
	toff50=75.0e-9
	@named npline=line(name="npline");
	@named swpulse=Switch(ton=tonnp,toff=toffnp)
	#@named swcc=Switch(ton=1.0,toff=0.0)	
	@named sw50=Switch(toff=1.0,ton=ton50)
	#@named vin=ConstantVoltage(V=5e3)
	@named vin=Capacitor(C=1)
	#@named vin = Vpulsevoltage(d=10e-9,f=1e5)
	@named rcircuit=Resistor(R=1e-3)
	@named r50=Resistor(R=50.0)
	@named groundnp=Ground()
	@named vprobe=VoltageSensor()
	rc_eqsnp = [
	          connect(vin.p, swpulse.p,vprobe.p)
		      #connect(vin.p, rcircuit.p)
	          connect(swpulse.n,vprobe.n, rcircuit.p)
			  connect(swpulse.n, sw50.p)
			  connect(sw50.n, r50.p)
			  connect(rcircuit.n, npline.li_1.p)
			  #connect(swpulse.n, rcircuit.p)
	          
	          connect( groundnp.g,vin.n,r50.n,npline.ci_1.n)
		      #connect( groundnp.g,vin.n,npline.ci_1.n)
	         ]
	
	@named _rc_modelnp = ODESystem(rc_eqsnp, t)
	@named rc_modelnp = compose(_rc_modelnp, [groundnp,rcircuit,vin,sw50,swpulse,npline,r50,vprobe])
#@named rc_modelnp = compose(_rc_modelnp, [groundnp,rcircuit,vin,npline,swpulse])

		u0np=[ ]
		for i in 1:nloop-1	
			npstr="npline.ci_"*string(i)*".v"
			nppair=eval(Meta.parse(npstr*"=>0.0"))
			push!(u0np,nppair)
		end
		push!(u0np,npline.cout.v=>0.0)
	    push!(u0np,vin.v=>5e3)
        u0np=convert(Vector{Pair{Num, Float64}},u0np)
		sysnp = structural_simplify(rc_modelnp)
		probnp = ODAEProblem(sysnp, u0np, (0, toff50))
		
	
end


# ╔═╡ b4f2065a-6b8a-45aa-a1ff-1f84381c6de1
myvarnpix=findall(x -> occursin(" ~",x),string.(full_equations(rc_modelnp))) #

# ╔═╡ 73a6e8bd-487e-4892-9680-b5584a391295
string.(full_equations(rc_modelnp))[7][1:19] #findfirst("~", string.(full_equations(rc_modelnp))[7])

# ╔═╡ 31dc7d14-3eca-4c00-8e7c-e61397278202
findfirst("~", string.(full_equations(rc_modelnp))[7])

# ╔═╡ fcb06630-293b-493e-9886-553fa0a1b97b
string(21:21)[1:findfirst(":",21:21)]

# ╔═╡ 9dd07398-3d8a-4303-9203-2fd3906bce79
st="3:3"

# ╔═╡ 15f6aba5-ead9-4531-9e0d-91552ed42f7c
collect(findfirst(":",st))[1]-1

# ╔═╡ c79d3dee-80b7-4d65-ad64-26c571125e4a
value(full_equations(rc_modelnp)[10].lhs)

# ╔═╡ e055f5fa-d71d-4309-9a1c-9270d973c3f7
ixr50=findall( x -> occursin("r50₊i(t) ~",x) ,string.(observed(sysnp)))

# ╔═╡ 1d6f6f3a-8bf9-4c1c-a32f-322945107d54
observed(sysnp)[eval(Meta.parse(string(ixr50)))]

# ╔═╡ 09ff0531-188e-4203-a328-649011e2280d
npline₊cout₊v(t)

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
	plot(solnp,vars=[npline.cout.v,vprobe.v],ylims=(-1.5e4,1.5e4),xlims=(0.0,toff50))
end

# ╔═╡ c47c7480-4049-4bbd-864d-0f79b1023877
solnp[r50.i]

# ╔═╡ a1d3bdc6-a680-4d41-a5ab-47d41efb1927
plot(solnp,vars=[swpulse₊i])

# ╔═╡ d8f42d0f-eb80-4cf2-89d1-f20b1bc7d935
#Pkg.add("DataInterpolations")

# ╔═╡ b01ef842-450d-4e6d-859c-55c4f13894f3
#Pkg.add("QuadGK")

# ╔═╡ ea497602-a39a-4efc-86f5-c34bf6100a11
r50

# ╔═╡ 19c6296b-987a-44bc-97d3-ec2420f057e1
50*10e2*100e-9*1e5

# ╔═╡ 11100107-cae8-4e82-b999-a076dc31061e
40e-12*1e8*1e5

# ╔═╡ 3369d29a-9f07-4c2c-ace2-4316839f3781
i2_50(t)=ir50(t)^2

# ╔═╡ abebbaa2-c246-445c-bb78-353576959dae
50*quadgk(i2_50, 0, toff50, rtol=1e-3)[1]*100000

# ╔═╡ 5df71cc8-f0d2-4672-9975-e7dd9c3e3130
maximum(solnp[npline.cout.v])

# ╔═╡ e6ec45a2-5a82-47bf-9797-a754970613ca
maximum(zzz)

# ╔═╡ d902928b-0f10-44e8-b8ac-53a4e8db87de


# ╔═╡ 7d7f443a-238a-48fe-9840-b15699ac1ae8
solnp[npline.cout.v][Int64((end+1)/2)]

# ╔═╡ ce9aeba4-7751-426e-b4bb-0147f6ccb3ce
sum(abs2,solnp[npline.cout.v])

# ╔═╡ 42d502b0-b21a-46e7-8d17-dc15eef09dcd
begin  # creation de fonctions interpolées à partir des données 
	#coutv=DataInterpolations.LinearInterpolation(solnp[npline.cout.v],solnp.t)
	#coutv=DataInterpolations.CubicSpline(solnp[npline.cout.v],solnp.t)
	#ir50=DataInterpolations.LinearInterpolation(solnp[r50.i],solnp.t)
end

# ╔═╡ ab949d5e-ecec-49db-a53b-442023a8e502
begin # create function for state variables
	for i in 1:length(states(sysnp))
		eval(Meta.parse(string(states(sysnp)[i])*"=solnp(t)["*string(i)*"]" ))
	end
end

# ╔═╡ 3c07c738-00df-468e-bb64-2176f58bc1b8
string(states(sysnp)[41])*"=solnp(t)["*string(41)*"]"

# ╔═╡ e843f6c1-6933-4282-8943-56ec9c77a37a
swpulse₊i(3e-9)

# ╔═╡ 6e9a6c03-e752-4bc6-870d-0428f83a6821
states(sysnp)

# ╔═╡ 299ceae8-419f-4de6-ae8f-36f3678279cc
string.(equations(sysnp))

# ╔═╡ 994f178f-2465-4e02-b9ba-c10bfaed4155
solnp(3e-8)[40]

# ╔═╡ 892434b4-1795-4153-92c9-5bb951f53a76
length(string.(solnp(3e-9)))

# ╔═╡ 52852adf-4533-4fe6-a839-78c26d5eedd9
length(states(sysnp))

# ╔═╡ 184fdf94-af5d-4aa1-99f8-9177eef71df4
npline₊cout₊i(25e-9)

# ╔═╡ 7009ebea-27fc-4ab0-9efd-9ab0367230ec
begin
# génération de fonction v(t) et i(t) pour tous les éléments du circuit électronique
# récupération des variables à prendre en compte
	
end

# ╔═╡ 1702b759-ef49-474b-b1fc-3fbc1ff1bf4c
begin
@bind veg MultiSelect(string.(observed(sysnp)))
end

# ╔═╡ 6f745422-bd58-43fc-9a2d-65842b8d7664
swpulse₊p₊i(3e-9)

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

# ╔═╡ 6febb1b8-b10f-485a-80ed-79a8c6578880
replace(string(observed(sysnp)[41]),"~"=>"=")

# ╔═╡ 0d7b5f8e-f039-41f2-a8e4-1182deda2536
swpulse₊i(3e-9)

# ╔═╡ 582dc111-11fa-4d07-b5db-9b47d4cd3c21
string.(states(sysnp))[41]

# ╔═╡ b9c7472a-4981-4e45-9146-0cbaf8f7a022
swpulse₊i(3e-9)

# ╔═╡ f3a96af3-c035-4e12-a54e-4a6a75321d0b
eval.(Meta.parse.([replace(string(observed(sysnp)[vegix[i]]),"~"=>"=") for i in 1:length(vegix)]))

# ╔═╡ 33c5398e-88c8-4345-bf4c-86755e626dcb
eval.(Meta.parse.([replace(string(observed(sysnp)[vegix[i]]),"~"=>"=") for i in [150]]))

# ╔═╡ 4a6d809d-1437-4193-9ab3-7a47fa3e69e7
r50₊i(3e-9)

# ╔═╡ 352b8f59-b52b-4e40-bcfb-fcf3794638e7
typeof(swpulse₊p₊i)

# ╔═╡ f993ee10-acd8-4ae5-be54-4cdaa9e4491f
length(myfunct)

# ╔═╡ 95d78452-8f00-4d96-82f2-360851d17bd6
swpulse₊p₊i(3e-9)

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

# ╔═╡ 9de72fd8-26d9-4fb6-8092-4cced8830836
string.(observed(sysnp))

# ╔═╡ d6964882-64f6-4454-bfa8-fa7f6c13eaa7
swpulse₊p₊i(3e-9)

# ╔═╡ 1d108e93-c8f9-491a-8337-c749958a8d1a
states(sysnp)

# ╔═╡ 2108e828-7ec3-47ee-9346-f315fdd5ab50
[i for i in myfunct]

# ╔═╡ 906b5b77-c408-44a4-8505-1110b1df18fc
observedlabel

# ╔═╡ 6bb5c584-c743-4225-b71a-ce9f1cd5e4f5
[i for i in myfunct]

# ╔═╡ e89ed2c6-8ec4-4235-9513-cf0cc167f8ad
begin  # active when vegix change
	vegix
	npline₊li_19₊n₊v(3e-9)
end

# ╔═╡ 16a7cb2f-06bd-4701-99bd-4e3b875534bd
[1 2]

# ╔═╡ 6dad160b-d262-42f2-bfd1-53a83f94b66a
convert(Matrix{String},1,8, [observedlabel])

# ╔═╡ c3a1e3b4-a574-47df-a561-ddb12082455e
observedlabel

# ╔═╡ Cell order:
# ╠═681ceb3e-286f-11ed-33b8-43fdd33cf785
# ╠═c5d1f912-9fae-4f8e-ac43-80326f9b8268
# ╠═0fae61c8-a770-4366-bbf2-76e7995e4fbe
# ╠═bffc0fa0-28b8-434b-961b-d266d02d5cf4
# ╠═a00a9f5e-7812-4d26-b7cb-91eaab236750
# ╠═81f1a20b-f1d6-403f-bd26-561f5a6b08ba
# ╠═54b30380-b298-4906-8ed5-e7ce329862dc
# ╠═d922eb21-0264-4e12-9e74-fc7682310936
# ╠═c3c750bb-ec10-4277-815c-23b4d6efa7eb
# ╠═46cbeea8-eac3-47a5-8e26-40aabf9dcca4
# ╠═937a05d0-a2a8-42f1-a18e-be6f980cf8f4
# ╠═c570e19b-57e9-4426-8cd3-004de43254da
# ╠═a25c4a50-cafb-4305-9457-5eb072a3e3c9
# ╠═cead2d60-04bb-423e-a2fe-9205b7463997
# ╠═f33bbe69-d33b-46d1-add5-290645ad1f72
# ╠═03a767a1-0b47-42fa-ae4f-63f472adc369
# ╠═34b8af20-b7d2-4bbc-9be1-40440aeb17b3
# ╠═4f14d959-a4be-4c9d-8c8c-6cd7cf3d6713
# ╠═3d22af7c-26b6-4dac-a27c-2ccdb6cd060f
# ╠═32798c11-ffba-4e01-97bc-363f6798b2d6
# ╠═fb3e71b5-7372-417e-8888-5b0114ca2ab8
# ╠═f7fe7bf0-606d-46fc-9eca-2009a616337d
# ╠═be5b8a95-f634-4347-ac1d-4925683759f7
# ╠═f2a86c2f-ff50-405c-b369-33dccc364575
# ╠═c7daeaf9-904a-4cf4-8d57-868c1b0cc979
# ╠═dcc52de0-af12-40b1-bf7c-8b580d40893e
# ╠═964cafb3-ff81-4e99-821b-0cbadb943315
# ╠═a2a565c5-1a4f-43a5-9193-0e1cf373e18a
# ╠═bbd7d4d4-d6ab-422c-8609-f9cb2fd2af97
# ╠═87ce2f92-ad52-435b-807c-c6dced9d222c
# ╠═71569d42-feb4-4acc-96c5-9b20f8a4c595
# ╠═76f3b2f4-661e-432b-a88f-121b09ac6cfd
# ╠═78de9afe-c0fe-41f2-b8e9-fe308ee489a8
# ╠═18a05579-02c4-49cc-ad61-7a2417f518f1
# ╠═3672b8c2-5503-4648-83fc-d9e811489ee7
# ╠═569191c9-271b-4177-bb89-e42f4cd88ead
# ╠═4e5515df-77de-41d1-8870-4c0f0025c092
# ╠═5a9cdd1b-0358-4d4a-992a-a99dbdd3e48f
# ╠═eece0367-4438-4743-b0c6-b4fc0fdc4420
# ╠═944b8f33-62f7-4884-bb9a-4074fe21b805
# ╠═4609822a-840d-4a32-b61b-a6e97dfdacc0
# ╠═318529e6-ca45-40b3-8f24-2aff34e0ff71
# ╠═631004a6-5f2f-487a-92c3-48499dcc0fb0
# ╠═2bfd9ed4-8ed0-436d-97c6-837cd13dc09e
# ╠═21eb509b-3820-417c-af01-ee1a867116f6
# ╠═e70945c5-bfed-42b3-9cdb-a358c9de7199
# ╠═1b6b96e1-e983-4908-9394-f487f6c7b3a1
# ╠═53cf0863-3045-493d-99ef-47748c0e7e86
# ╠═7ca27045-9a6c-479b-9397-1d901b7147c1
# ╠═d22fadef-edee-4010-a555-489d97dcba40
# ╠═ffb4f13a-44fb-43b7-b614-87d947e17fef
# ╠═6466fdde-b6dd-478b-8d24-5ec222a07d0b
# ╠═aa4b77c9-165d-4845-b85d-35b0b523698a
# ╠═94157a91-075f-40e9-a335-e5205f9501e0
# ╠═2ede9640-e3ad-4084-8a81-7c649746f5d0
# ╠═b0b2e8cb-1e51-4268-b20c-2727ec7ce244
# ╠═d9e571a8-c85b-43b2-a89d-e58001691107
# ╠═2607106f-a5c6-49f2-9cf5-05cdb9f659fc
# ╠═a920f40c-7e13-406e-a7ec-efb4dff01639
# ╠═dd326b99-85c6-4207-8e9d-645d1e500d4d
# ╠═d34ff992-dbc5-4a65-8191-0f671f20d455
# ╠═3e1c02e2-5a38-4805-9bf5-8b57551fa3e1
# ╠═a495c951-cf80-4646-9438-1e4de38348ab
# ╠═b4f2065a-6b8a-45aa-a1ff-1f84381c6de1
# ╠═73a6e8bd-487e-4892-9680-b5584a391295
# ╠═31dc7d14-3eca-4c00-8e7c-e61397278202
# ╠═fcb06630-293b-493e-9886-553fa0a1b97b
# ╠═9dd07398-3d8a-4303-9203-2fd3906bce79
# ╠═15f6aba5-ead9-4531-9e0d-91552ed42f7c
# ╠═c79d3dee-80b7-4d65-ad64-26c571125e4a
# ╠═e055f5fa-d71d-4309-9a1c-9270d973c3f7
# ╠═1d6f6f3a-8bf9-4c1c-a32f-322945107d54
# ╠═09ff0531-188e-4203-a328-649011e2280d
# ╠═c47c7480-4049-4bbd-864d-0f79b1023877
# ╠═d9437005-df90-4c71-aa75-f934668fa9c9
# ╠═0a5a5433-816e-48b0-ab5c-9f1f0a637ecd
# ╠═b07cd205-b80c-46a5-b3ac-15e687b1c55e
# ╠═54b04a46-bc23-4495-94e8-bbc315e6b9b8
# ╠═b02d1db7-4f66-45d2-ac29-846d296d1144
# ╠═a1d3bdc6-a680-4d41-a5ab-47d41efb1927
# ╠═d8f42d0f-eb80-4cf2-89d1-f20b1bc7d935
# ╠═f945a593-3690-499b-ba7f-0c51e408ff89
# ╠═b01ef842-450d-4e6d-859c-55c4f13894f3
# ╠═7c041ccd-20d7-4eac-a7a7-d01b527434d4
# ╠═ea497602-a39a-4efc-86f5-c34bf6100a11
# ╠═abebbaa2-c246-445c-bb78-353576959dae
# ╠═19c6296b-987a-44bc-97d3-ec2420f057e1
# ╠═11100107-cae8-4e82-b999-a076dc31061e
# ╠═3369d29a-9f07-4c2c-ace2-4316839f3781
# ╠═5df71cc8-f0d2-4672-9975-e7dd9c3e3130
# ╠═e6ec45a2-5a82-47bf-9797-a754970613ca
# ╠═d902928b-0f10-44e8-b8ac-53a4e8db87de
# ╠═7d7f443a-238a-48fe-9840-b15699ac1ae8
# ╠═ce9aeba4-7751-426e-b4bb-0147f6ccb3ce
# ╠═42d502b0-b21a-46e7-8d17-dc15eef09dcd
# ╠═ab949d5e-ecec-49db-a53b-442023a8e502
# ╠═3c07c738-00df-468e-bb64-2176f58bc1b8
# ╠═e843f6c1-6933-4282-8943-56ec9c77a37a
# ╠═6e9a6c03-e752-4bc6-870d-0428f83a6821
# ╠═299ceae8-419f-4de6-ae8f-36f3678279cc
# ╠═994f178f-2465-4e02-b9ba-c10bfaed4155
# ╠═892434b4-1795-4153-92c9-5bb951f53a76
# ╠═52852adf-4533-4fe6-a839-78c26d5eedd9
# ╠═184fdf94-af5d-4aa1-99f8-9177eef71df4
# ╠═7009ebea-27fc-4ab0-9efd-9ab0367230ec
# ╠═1702b759-ef49-474b-b1fc-3fbc1ff1bf4c
# ╠═6f745422-bd58-43fc-9a2d-65842b8d7664
# ╠═a7341e35-682a-4db4-8b33-88bd46fa84a3
# ╠═6febb1b8-b10f-485a-80ed-79a8c6578880
# ╠═0d7b5f8e-f039-41f2-a8e4-1182deda2536
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
# ╠═2108e828-7ec3-47ee-9346-f315fdd5ab50
# ╠═906b5b77-c408-44a4-8505-1110b1df18fc
# ╠═6bb5c584-c743-4225-b71a-ce9f1cd5e4f5
# ╠═e89ed2c6-8ec4-4235-9513-cf0cc167f8ad
# ╠═477f0bdc-cd15-4601-8f00-25263a70c8f3
# ╠═16a7cb2f-06bd-4701-99bd-4e3b875534bd
# ╠═6dad160b-d262-42f2-bfd1-53a83f94b66a
# ╠═c3a1e3b4-a574-47df-a561-ddb12082455e
