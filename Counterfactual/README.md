# Counterfacutal Analysis: Borderless

From the general equilibrium, the paper implement the counterfactual analysis under the borderless setting. If the Canada-US border does not exist anymore, how would the multilateral resistance terms change?

## Counterfactual Equilibrium Condition

According to _Appendix B_ in the paper, after the removal of the border, the quantities must be the same. Thus, we have

$$
\frac{y_{i}^{1}}{p_{i}^{1}} = \frac{y_{i}^{0}}{p_{i}^{0}}
$$

where $0$ and $1$ refer the baseline and counterfactual equilibrium, respectively. If I understood correctly, without loss of generality, we could assume that $\beta_{i} = 1$ for all $i$. Then, we can back out $\\{p_{i}\\}$ from the multilateral resistance equations.

$$
\left(p_{i}^{0}\right)^{1-\sigma} = y_{i}^{0}\left\\{\sum_{j}\frac{\exp{a_{2}(1-\delta_{ij}) + a_{1}\ln{d_{ij}}}}{P_{j}^{1-\sigma}} \cdot y_{j}^{0}\right\\}^{-1} \quad \forall i
$$

## Estimation Strategy

1. Load the baseline equilibrium $\\{P_{i}^{0}\\}$ and compute $\\{p_{i}^{0}\\}$.
2. Guess $y_{i}^{1,old} = y_{i}^{0}$ and set $\delta_{ij} = 1$ for all $i,j$.
3. Compute $\\{P_{i}^{1}\\}$ and back out $p_{i}^{1}$. Then, calculate

$$
y_{i}^{1,new} = \frac{p_{i}^{1}}{p_{i}^{0}}y_{i}^{0}
$$
4. If $|y_{i}^{1,old} - y_{i}^{1,new}|$ is smaller than tolerance level, exit. If not, set $y_{i}^{1,old} = y_{i}^{1,new}$ and iterate.

## Result

<img src="images/Table_Count.png" alt="Table 5: GDP and Trade Network" width="900">