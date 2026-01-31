## How to calculate 'Robust Standard Error'

This note outlines the computation of **Robust S.E.** for nonlinear least square estimation model where no closed-form solution exists.

By the F.O.C,

$$
\frac{\partial \text{SSR}(\theta)}{\partial \theta} = 0
$$

where

$$
\frac{\partial \text{SSR}(\theta)}{\partial \theta} = \frac{\partial}{\partial \theta} \varepsilon(\theta)^{T} \cdot \varepsilon(\theta) = 2 \frac{\partial}{\partial \theta^{T}} \varepsilon(\theta) \cdot \varepsilon(\theta)
$$

Since $\partial\varepsilon(\theta)/\partial\theta$ is the _Jacobian_ matrix, we can simplify the F.O.C;

$$
\frac{\partial \text{SSR}(\theta)}{\partial \theta} = 2 J(\theta)^{T} \cdot \varepsilon(\theta) = 0
$$

Next, do a 1st order Talyor explansion around the true value of $\theta$, $\theta_{0}$:

$$
\begin{align*}
\varepsilon(\theta) & \approx \varepsilon(\theta_{0}) + J(\theta_{0})(\theta - \theta_{0}) \\
J(\theta) & \approx J(\theta_{0})
\end{align*}
$$

Plug this into the F.O.C,

$$
J(\theta)^{T}\varepsilon(\theta) \approx J(\theta_{0})^{T}\left(\varepsilon(\theta_{0}) + J(\theta_{0})(\theta - \theta_{0})\right) = 0
$$

Solving for $(\theta - \theta_{0})$ gives

$$
(\theta - \theta_{0}) = -\left(J(\theta_{0})^{T}J(\theta_{0})\right)^{-1}J(\theta_{0})^{T} \cdot \varepsilon(\theta_{0})
$$

Therefore, the asymptotic variance of $\theta$ is

$$
Var(\theta) = Var\left(\left(J^{T}J\right)^{-1}J^{T}\varepsilon\right) = \left(J^{T}J\right)^{-1}J^{T} \cdot Var(\varepsilon) \cdot J(J^{T}J)^{-1}
$$

### 1. Homoskedastic Erros

If $Var(\varepsilon) = \sigma^{2}I$,

$$
Var(\theta) = \sigma^{2}\left(J^{T}J\right)^{-1}
$$

### 2. Heteroskedastic Erros

If $Var(\varepsilon) = \Omega$,

$$
Var(\theta) = \left(J^{T}J\right)^{-1}J^{T} \Omega J(J^{T}J)^{-1}
$$

## Application to the replication pracitce

Since the function, ```lsqnonlin```, returns the _Jacobian_ matrix, robust standard errors can be computed directly using the estimation output:

```matlab
Omega = diag(residuals.^2);

% Sandwich estimator
A = inv(jacobian' * jacobian);
B = jacobian' * Omega * jacobian;
vcov_robust = A*B*A;

% Standard errors
robust_se = sqrt(diag(vcov_robust));
```