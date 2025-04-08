# Time evolution


## Single mode example: harmonic oscillator

Let's compute $\langle 0 | O(t) |0\rangle$ for $O(t=0)=a^\dagger a$ and

```math
H = \omega a^\dagger a + \Omega (a+a^\dagger)
```

Construct $H$ and $O$
```@example constructing
using BosonStrings
ω = 1.0
Ω = 2.5
O = Operator(1)
O += 1, (1, 1, 1)
H = Operator(1)
H += ω, (1, 1, 1)
H += Ω, (1, 0, 1)
H += Ω, (1, 1, 0)
println(H)
```


Time evolve using Runge-Kutta
```@example constructing
using ProgressBars
function evolve(H, O, state, times)
    result = []
    dt = times[2] - times[1]
    for t in ProgressBar(times)
        push!(result, expect(O, state, state))  # save <0|O|0>
        O = rk4(H, O, dt)  #preform one step of rk4
    end
    return real.(result)
end

times = 0:0.1:20
state = 0
result = evolve(H, O, state, times)
```

Plot the result
```@example constructing
using Plots
plot(times, result)
xlabel!("Time")
ylabel!("<0|O|0>")
```
