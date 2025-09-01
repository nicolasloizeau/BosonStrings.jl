# Constructing operators

Start by importing BosonStrings:
```@example constructing
using BosonStrings
```
Operators are constructed by adding Bonsons strings.
A boson strings is formated in the following waw : `c, (site1, n1,m1), (site2, n2,m2), (site3, n3,m3) ...` where `c` is a coefficient, and triples `(site, n, m)` denote a term of the form $a_{site}^{\dagger n} a_{site}^m$. A Boson string is a tensor product of such sigle site terms.

## Single mode

Compute $a_{1}^{\dagger 1} a_{1}^1 \cdot a_{1}^{\dagger 2} a_{1}^2$

```@example constructing
o1 = Operator(1)
o1 += 1, (1, 1, 1)
o2 = Operator(1)
o2 += 1, (1, 2, 2)
o = o1 * o2
println(o)
```

## Multi mode

Compute $a_{1}^{\dagger 1} a_{1}^1 a_{2}^{\dagger 1} a_{2}^5 \cdot a_{1}^{\dagger 2} a_{1}^2 a_{4}^{\dagger 2} a_{4}^6$

```@example constructing
o1 = Operator(4)
o1 += 1, (1, 1, 1), (2, 1, 5)
o2 = Operator(4)
o2 += 1, (1, 2, 2), (4, 2, 6)
o = o1 * o2
println(o)
```
