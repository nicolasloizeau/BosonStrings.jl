
using BosonStrings
using ProgressBars
import PyPlot as plt


function evolve(H, O, state, times)
    result = []
    dt = times[2] - times[1]
    for t in ProgressBar(times)
        push!(result, expect(O, state, state))  # save <0|O|0>
        O = rk4(H, O, dt)  #preform one step of rk4
    end
    return real.(result)
end




# Parameters
ω = 1.0 # bare frequency of the mode
Ω = 2.5 # drive strength (time-independent in lab frame)

# construct the Hamiltonian and number operator
O = Operator(1)
O += 1, (1, 1, 1)
H = Operator(1)
H += ω, (1, 1, 1)
H += Ω, (1, 0, 1)
H += Ω, (1, 1, 0)


# Time evolution, time compute <0|num(t)|0>
times = 0:0.1:100
state = 0
result = evolve(H, O, state, times)


plt.plot(times, result)
plt.xlabel("Time")
plt.ylabel("Photon number expectation")
plt.title("Driven, lossless single-mode oscillator")
plt.show()
