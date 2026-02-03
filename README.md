# Gravity with Gravitas: A Solution to the Border Puzzle
[Anderson and van Wincoop(2003)](https://www.aeaweb.org/articles?id=10.1257/000282803321455214) builds a seminal foundation for the gravity equation in quantitative international trade literature.
Here, I introduce the paper briefly and replicate its **two-country model** results using **synthetic data**. The data package I use is constructed based on the paper's estimates $a_{1}$ and $a_{2}$.

- Data is available with description [here](https://github.com/JaeSeok1218/Gravity_with_Gravitas/tree/main/Data).
- Replication procesure is provided [here](https://github.com/JaeSeok1218/Gravity_with_Gravitas/tree/main/Estimation).
- Counterfacutal analysis code is available [here](https://github.com/JaeSeok1218/Gravity_with_Gravitas/tree/main/Counterfactual).


## Brief Introduction

The border puzzle was raised in [McCallum(1995)](https://www.jstor.org/stable/2118191?casa_token=XLbC-ONAJjYAAAAA%3ANBdsn1X7reV2fZNT6Cq5i8qdtLoShZdfNuSc4mHFycxD_79rCwoyEKL19YLkqHHuAUl0gP-PjGcf0dTVcYiIpVYGc3beeARLxuQBVWVTgrzR_8Xdlqcp&seq=1), which found an unexpectedly large reduction in trade flows across the Canada-US border. A few years later, [Anderson and van Wincoop(2003)](https://www.aeaweb.org/articles?id=10.1257/000282803321455214) resolved this puzzle by deriving a theoretical gravity equation:

$$
x_{ij} = \frac{y_{i}y_{j}}{y^{W}}\left(\frac{t_{ij}}{P_{i}P_{j}}\right)^{1-\sigma}
$$

subject to

$$
(1) \quad P_{j}^{1-\sigma} = \sum_{i}P_{i}^{\sigma-1}\theta_{i}t_{ij}^{1-\sigma} \quad \forall j \quad \text{(market clearing condition)}
$$

where $\\{ P_{i} \\}$ are multilateral resistance variables and $\theta_{i}$ denotes an income share.

## Estimation

The estimation strategy is straightforward but involves structural parameters. First, the paper assumes

$$
(2) \quad t_{ij} = b_{ij}d_{ij}^{\rho} 
$$

where $b_{ij} = 1$ if regions $i$ and $j$ are located in the same country, and $d_{ij}$ is bilateral distance with distance elasticity $\rho$. Under this assumption, the general equilibrium implies

$$
\ln{x_{ij}} = k + \ln{y_{i}} + \ln{y_{j}} + (1-\sigma)\rho\ln{d_{ij}} + (1-\sigma)\ln{b_{ij}} - (1-\sigma)\ln{P_{i}} - (1-\sigma)\ln{P_{j}}
$$

where $k$ is a constant. Note that $\sigma$ cannot be estimated separately because it shows in every multilateral resistance terms. Therefore, we substitute assumption (2) into the market-clearing condition:

$$
P_{j}^{1-\sigma} = \sum_{i}P_{i}^{\sigma-1}\theta_{i}\exp{\\{a_{1}\ln{d_{ij}} + (1-\sigma)\ln{b_{ij}}\\}}
$$

which implies

$$
(3) \quad P_{j}^{1-\sigma} = \sum_{i}P_{i}^{\sigma-1}\theta_{i}\exp{\\{a_{1}\ln{d_{ij}} + a_{2}(1-\delta_{ij})\\}}
$$

where $a_{1} = (1-\sigma)\rho$. Moreover, since $b_{ij}$ represents tariff-type barriers, the paper further assumes $b_{ij} = b^{1-\delta_{ij}}$, where $b-1$ constitutes tariff-equivalent of the Canada-US border, which yields the equation (3). Using the non-linear least squares, the paper estimates

***
$$
\min_{k,a_{1},a_{2}} \sum_{i}\sum_{j\neq i} \left[\ln{z_{ij}} - k - a_{1}\ln{d_{ij}} - a_{2}(1-\delta_{ij}) + \ln{P_{i}^{1-\sigma}} + \ln{P_{j}^{1-\sigma}}\right]^{2}
$$

subject to

$$
\quad P_{j}^{1-\sigma} = \sum_{i}P_{i}^{\sigma-1}\theta_{i}\exp{\\{a_{1}\ln{d_{ij}} + a_{2}(1-\delta_{ij})\\}}
$$

where $\ln{z_{ij}} \equiv \ln{\left(x_{ij}/y_{i}y_{j}\right)}$.

***

### Estimation Strategy

1. Guess values for $a_{1}$ and $a_{2}$
2. Solve for $\\{P_{i}\\}$ using the market clearing conditions for all $j$.
3. Calculate the nonlinear least squares objective.
4. If the difference between $\ln{z_{ij}}$ from the data and the prediction is below a tolerance level, stop.
5. Otherwise, return to step 1.

## Counterfactual Analysis: Borderless

To compute the border effect, the paper implements a counterfactual analysis by removing the Canada-US border (i.e., setting $\delta_{ij}=1$, for all $i,j$). The analysis strategy is described in detail [here](https://github.com/JaeSeok1218/Gravity_with_Gravitas/tree/main/Counterfactual).

### Result

<p align="center">
<img src="images/Table_Count.png" alt="Table 5: GDP and Trade Network" width="400">
</P>

>Note: The results are very close to the results of the paper. _True_ values refer to the paper's estimates.

### Implication 1: Multilateral Resistance

The magnitude of the numbers reflects the fact that the border effects operating through $dt$ would lead larger impacts on multilateral resistance of a small country than that of a lager country.
$$
dP_{i} = \left(\frac{1}{2}-\theta_{i} + \frac{1}{2}\sum_{k}\theta_{k}^{2}\right)dt
$$

### Implication 2: Border effect on Trade

Based on the result above, the paper decomposes the border effect on bilateral trade flows within and between countries. 

$$
\begin{align*}
\frac{x_{ij} \frac{y^{W}}{y_{i}y_{j}}}{\widetilde{x}_{ij} \frac{\widetilde{y}^{W}}{\widetilde{y}_{i}\widetilde{y}_{j}}} = \underbrace{b_{ij}^{1-\sigma}}_\text{BR impact}\underbrace{\left(\frac{P_{i}^{\sigma-1}}{\widetilde{P}_{i}^{\sigma-1}}\right)\left(\frac{P_{j}^{\sigma-1}}{\widetilde{P}_{j}^{\sigma-1}}\right)}_\text{MR impact}
\end{align*}
$$

Accordingly, the paper reports three bilateral trade flows: US-US, CA-CA, and CA-US. Please see the paper for the full interpretation including the multi-country model; here I focus on the overall impact of the border:

> US-US: 1.05
>
> CA-CA: 4.31
>
> US-CA: 0.41

These results show that trade within the US changes very little, whereas the presence of the CA-US border increases intra-Canadian trade by nearly four times. Moreover, bilateral trade between Canada and the US declines by approximately 59 percent.