import SymPy
a,b,c,x = SymPy.symbols("a b c x",real=true)
quadsympy = SymPy.lambdify(a*x^2 + b*x + c,[a;b;c;x])
quadsympyjl = SymPy.lambdify(a*x^2 + b*x + c,[a;b;c;x],invoke_latest=false,use_julia_code=true)
quadsympyjl2 = SymPy._lambdify(a*x^2 + b*x + c,[a;b;c;x])

@inline function quadjl(a::Float64,b::Float64,c::Float64,x::Float64)
    e = a*x^2 + b*x + c
    return e
end

import SymEngine
as,bs,cs,xs = @SymEngine.vars as bs cs xs
quadsyme = SymEngine.lambdify(as*xs^2 + bs*xs + cs,[as;bs;cs;xs])


Lambdify(ex, vars=free_symbols(ex)) = eval(Expr(:function,
                         Expr(:call, gensym(), map(Symbol,vars)...),
                              convert(Expr, ex)))
quadsymejl = Lambdify(as*xs^2 + bs*xs + cs,[as;bs;cs;xs])

import Reduce
eval(Expr(:function,:(quadred(a,b,c,x)),Reduce.Algebra.:+(Reduce.Algebra.:*(:a,:x,:x),Reduce.Algebra.:*(:b,:x),:c)))


function test(n::Int)
    as = rand(n)
    bs = rand(n)
    cs = rand(n)
    xs = rand(n)
    quadred(as[1],bs[1],cs[1],xs[1])
    quadjl(as[1],bs[1],cs[1],xs[1])
    quadsympy(as[1],bs[1],cs[1],xs[1])
    quadsympyjl(as[1],bs[1],cs[1],xs[1])
    quadsympyjl2(as[1],bs[1],cs[1],xs[1])
    quadsyme(as[1],bs[1],cs[1],xs[1])
    quadsymejl(as[1],bs[1],cs[1],xs[1])
    @time println("test")
    println("Reduce.jl")
    @time quadred.(as,bs,cs,xs)
    println("native Julia")
    @time quadjl.(as,bs,cs,xs) 
    println("SymPy")
    @time quadsympy.(as,bs,cs,xs)
    println("SymPy julia_code")
    @time quadsympyjl.(as,bs,cs,xs)
    println("SymPy _lambdify")
    @time quadsympyjl2.(as,bs,cs,xs)
    println("SymEngine")
    @time quadsyme.(as,bs,cs,xs)
    println("SymEngine custom lambdify")
    @time quadsymejl.(as,bs,cs,xs)
end

test(Int(1e8))
