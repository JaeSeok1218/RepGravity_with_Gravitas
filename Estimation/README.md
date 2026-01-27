# Estimation

1. Guess values for $a_{1}$ and $a_{2}$

```matlab
params0 = [-0.8, -1.7];  % Initial guess [a1, a2]
lb = [-1.6, -3.4];       % Lower bounds
ub = [0, 0];             % Upper bounds
```
>**Note**: Based on the estimates from the paper, I set the bounds roughly. Since this exercise is intended to getting the hang of the methodology used in the paper, one cannot learn important things from the specific numbers.



2. Solve for $\\{P_{i}\\}$ using the market clearing conditions for all $j$.
3. Compute $k=E[\ln{z_{ij}}] - E[\text{predicted}]$.
4. Calculate the nonlinear least squares objective.
5. If the difference between $\ln{z_{ij}}$ from the data and the prediction is below a tolerance level, stop.
6. Otherwise, return to step 1.