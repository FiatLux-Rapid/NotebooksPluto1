begin

    const app = App()
    
    # Parameters are given within the request without body
    add_get!(app, "/rootint/:a/:b/:c") do req
        a = parse(Int, req.params.a)
        b = parse(Int, req.params.b)
        c = parse(Int, req.params.c)
        x₁, x₂ = rootint(a, b, c)
    
        return Dict("x1" => "$x₁", "x2" => "$x₂")
    end
        
    
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
    @async  serve(app) #serve(app,ip) #Default: ip = localhost, port = 8081
    
    end