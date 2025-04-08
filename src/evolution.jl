


function f_unitary(H, O, s, hbar)
    return s * com(H, O) / hbar
end



"""
    rk4(H::Operator, O::Operator, dt::Real; hbar::Real=1, heisenberg=true, M=2^20, keep::Operator=Operator(N))

Single step of Runge–Kutta-4 with time independant Hamiltonian.
Returns O(t+dt).
Set `heisenberg=true` for evolving an observable in the heisenberg picture.
If `heisenberg=false` then it is assumed that O is a density matrix.
`M` is the number of strings to keep.
"""
function rk4(H::Operator, O::Operator, dt::Real; hbar::Real=1, heisenberg=true, M=2^20)
    s = -1im
    heisenberg && (s = 1im)
    k1 = f_unitary(H, O, s, hbar)
    k1 = trim(k1, M)
    k2 = f_unitary(H, O + dt * k1 / 2, s, hbar)
    k2 = trim(k2, M)
    k3 = f_unitary(H, O + dt * k2 / 2, s, hbar)
    k3 = trim(k3, M)
    k4 = f_unitary(H, O + dt * k3, s, hbar)
    k4 = trim(k4, M)
    return O + (k1 + 2 * k2 + 2 * k3 + k4) * dt / 6
end
