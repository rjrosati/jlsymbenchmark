import SymPy
a,b,c,x = SymPy.symbols("a b c x",real=true)
quadsympy = SymPy.lambdify(a*x^2 + b*x + c,[a;b;c;x])
function quadjl(a,b,c,x)
    return a*x^2 + b*x + c
end

import SymEngine
as,bs,cs,xs = @SymEngine.vars as bs cs xs
quadsyme = SymEngine.lambdify(as*xs^2 + bs*xs + cs,[as;bs;cs;xs])

import Reduce
eval(Expr(:function,:(quadred(a,b,c,x)),:(a*x^2 + b*x + c)))


function test(n)
    as = rand(n)
    bs = rand(n)
    cs = rand(n)
    xs = rand(n)
    println("native Julia")
    @time quadjl.(as,bs,cs,xs)
    println("Reduce.jl")
    @time quadred.(as,bs,cs,xs)
    println("SymPy")
    @time quadsympy.(as,bs,cs,xs)
    println("SymEngine")
    @time quadsyme.(as,bs,cs,xs)
end

test(Int(1e7))
