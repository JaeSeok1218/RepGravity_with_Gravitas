# Data Description

Since there is no available online resource to replicate [Anderson and van Wincoop(2003)](https://www.aeaweb.org/articles?id=10.1257/000282803321455214), I constructed a synthetic data with the estimates of the paper $a_{1}$ and $a_{2}$. Here I want to share the way how and some statistics of the data.

## Overall Trade network

<img src="images/figure_network.png" alt="Figure 1: GDP and Trade Network" width="900">

## Data Construction

### Trade flows

The paper shows the estimates of $a_{1}$ and $a_{2}$ for this two-country model, $-0.79$ and $-1.65$, respectively. Given these estimates, I can solve the following market-clearing condition for $ \\{P_{i} \\}$.

$$
\quad P_{j}^{1-\sigma} = \sum_{i}P_{i}^{\sigma-1}\theta_{i}\exp{\\{a_{1}\ln{d_{ij}} + a_{2}(1-\delta_{ij})\\}}
$$

Then, plug $ \\{P_{i} \\}$ back to the original gravity equation:

$$
x_{ij} = \frac{y_{i}y_{j}}{y^{W}}\left(\frac{t_{ij}}{P_{i}P_{j}}\right)^{1-\sigma}
$$

with small noise:

```matlab
noise = exp(0.05 * randn(n_total, n_total));
x = x .* noise;
```

<p align="center">
  <img src="images/Table_Trade.png"
       alt="Figure 1: GDP and Trade Network"
       width="300">
</p>

### Distance

In order to construct distance information, following the paper, I ask _Claude_ to point approximated longitude and latitude of each state and province and calculate the Great circle distance using the longitude and latitude of regions for different regions.

```matlab
haversine = @(lat1, lon1, lat2, lon2) 2 * 6371 * asin(sqrt(...
    sin((lat2-lat1)*pi/180/2)^2 + ...
    cos(lat1*pi/180) * cos(lat2*pi/180) * sin((lon2-lon1)*pi/180/2)^2)) / 1000;
```
<p align="center">
<img src="images/Table_Dist.png" alt="Figure 1: GDP and Trade Network" width="250">
</p>

### GDP

Because the purpose of this practice is to learn from the paper, I also approximately construct each region's GDP. 

<p align="center">
<img src="images/Table_GDP.png" alt="Figure 1: GDP and Trade Network" width="400">
</p>