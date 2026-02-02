% =========================================================================
% ESTIMATE Anderson & van Wincoop (2003) Gravity Model
% Counterfactual Analysis
% Scenario: No border: (1-delta_ij) = 0 for all i,j
% Notation: 0 and 1 implies the baseline model and counterfacutal model,
%          respectively
% =========================================================================

clear all; close all; clc;

fprintf('=== Anderson & van Wincoop Counterfacutal ===\n\n');

%% 1. LOAD DATA
% -------------------------------------------------------------------------
load('trade_data.mat');
load('results.mat');

n_regions = 40;
sigma = 5;

fprintf('Loaded trade data, results a_1 = %d and a_2 = %d \n\n', results.a1, results.a2);

%% 2. Construct counterfactual setups
% -------------------------------------------------------------------------


fprintf('Step 1: Loading P_i^0 from estimation...\n');
y0 = y(1:n_regions);
d_data = d(1:n_regions, 1:n_regions);
delta0 = delta(1:n_regions, 1:n_regions);

a1_hat = results.a1;
a2_hat = results.a2;

% Load P_i^{0}
T0 = results.T_hats(1:n_regions);
P0 = T0.^(1/(1-sigma));


%% 3. Back out p0 from P
% -------------------------------------------------------------------------

fprintf('Step 2: Computing p_i^0...\n');
p0 = back_out_p(a1_hat, a2_hat, delta0, y0, P0, d_data, n_regions, sigma);


%% 4. Analyze the counterfactual model
% -------------------------------------------------------------------------

% From estimation
T_hat = results.T_hats(1:40);
% Calculate P_{i}s (Calibrate sigma = 5)
T_us = exp(mean(-log(T_hat(1:30))));
T_ca = exp(mean(-log(T_hat(31:40))));
sd_T_us = std(T_hat(1:30));
sd_T_ca = std(T_hat(31:40));

fprintf('Step 3: Counterfactual: Borderless...\n');
[y1, p1, P1] = counterf_solve(a1_hat, a2_hat, y0, p0, d_data, n_regions, sigma);

% Calculate P_{i}s (Calibrate sigma = 5)
T1_hat = P1.^(1-sigma);
T1_us = exp(mean(-log(T1_hat(1:30))));
T1_ca = exp(mean(-log(T1_hat(31:40))));

sd_T1_us = std(T1_hat(1:30));
sd_T1_ca = std(T1_hat(31:40));

% Calcaulte ratio of P_{i}^{0} to P_{i}^{1}
T_ratio = T_hat ./ T1_hat;
T_ratio_us = exp(mean(-log(T_ratio(1:30))));
T_ratio_ca = exp(mean(-log(T_ratio(31:40))));

sd_T_ratio_us = std(T_ratio(1:30));
sd_T_ratio_ca = std(T_ratio(31:40));

fprintf('Average of T:\n');
fprintf('  E[T_us] = %.4f  [True: 0.77]\n', T_us);
fprintf('  E[T_ca] = %.4f  [True: 2.45]\n', T_ca);
fprintf('Std of T:\n');
fprintf('  std(T_us) = %.4f  [True: 0.03]\n', sd_T_us);
fprintf('  std(T_ca) = %.4f  [True: 0.12]\n', sd_T_ca);


fprintf('Average of T1:\n');
fprintf('  E[T1_us] = %.4f  [True: 0.75]\n', T1_us);
fprintf('  E[T1_ca] = %.4f  [True: 1.18]\n', T1_ca);
fprintf('Std of T1:\n');
fprintf('  std(T1_us) = %.4f  [True: 0.03]\n', sd_T1_us);
fprintf('  std(T1_ca) = %.4f  [True: 0.01]\n', sd_T1_ca);

fprintf('Average of T_ratio:\n');
fprintf('  E[T_ratio_us] = %.4f  [True: 1.02]\n', T_ratio_us);
fprintf('  E[T_ratio_ca] = %.4f  [True: 2.08]\n', T_ratio_ca);
fprintf('Std of T1:\n');
fprintf('  std(T_ratio_us) = %.4f  [True: 0.03]\n', sd_T_ratio_us);
fprintf('  std(T_ratio_ca) = %.4f  [True: 0.01]\n', sd_T_ratio_ca);


% ADD THIS DEBUG LINE
fprintf('\n===== ABOUT TO PRINT GDP (size of y1: %d) =====\n', length(y1));

% GDP Changes
fprintf('Nominal GDP Changes:\n');
fprintf('  Baseline total: $%.2f billion\n', sum(y0));
fprintf('  Counterfactual total: $%.2f billion\n', sum(y1));
fprintf('  Change: %.2f%%\n\n', 100*(sum(y1)/sum(y0) - 1));

fprintf('  US:\n');
fprintf('    Baseline: $%.2f billion\n', sum(y0(1:30)));
fprintf('    Counterfactual: $%.2f billion\n', sum(y1(1:30)));
fprintf('    Change: %.2f%%\n\n', 100*(sum(y1(1:30))/sum(y0(1:30)) - 1));

fprintf('  Canada:\n');
fprintf('    Baseline: $%.2f billion\n', sum(y0(31:40)));
fprintf('    Counterfactual: $%.2f billion\n', sum(y1(31:40)));
fprintf('    Change: %.2f%%\n\n', 100*(sum(y1(31:40))/sum(y0(31:40)) - 1));

%% Helper functions

function [y1, p1, P1] = counterf_solve(a1_hat, a2_hat, y0, p0, d_data, n_regions, sigma)

% initial guess
y1 = y0;
delta1 = ones(n_regions, n_regions);

max_iter = 1000;
tol = 1e-10;

for iter = 1:max_iter
  y1_old = y1;

  theta1 = y1/sum(y1);

  % Solve for T1 without border
  T1 = T_solve(a1_hat, a2_hat, theta1, delta1, d_data, n_regions);

  P1 = T1.^(1/(1-sigma));

  p1 = back_out_p(a1_hat, a2_hat, delta1, y1, P1, d_data, n_regions, sigma);

  y1 = (p1./p0).* y0;
  
  err = max(abs(y1 - y1_old));

  if mod(iter, 50) == 0
            fprintf('  Iter %4d: err = %.8f\n', iter, err);
        end
        
        if err < tol
            fprintf('  ✓ Converged after %d iterations\n', iter);
            return;
        end

end

warning('y1 did not converge after %d iterations', max_iter);

end

function T1 = T_solve(a1_hat, a2_hat, theta, delta, d_data, n_regions)

T1 = ones(n_regions, 1);

max_iter = 1000;
tol = 1e-8;

for iter = 1:max_iter
    T1_old = T1;

    for j=1:n_regions
        sum_val = 0;

        for i=1:n_regions
        exp_term = exp(a1_hat * log(d_data(i,j)) + a2_hat * (1 - delta(i,j)));
        sum_val = sum_val + (1/T1_old(i)) * theta(i) * exp_term;
        end
        T1(j) = sum_val;
    end

    % Normalize
    T1 = T1 / T1(1);

    % Check convergence
    if max(abs(T1 - T1_old)) < tol
       return;
    end
    
    
end

warning('T did not converge');

end

function p = back_out_p(a1_hat, a2_hat, delta, y, P, d_data, n_regions, sigma)

p = zeros(n_regions,1);

for i = 1:n_regions
    sum_val = 0;

    for j=1:n_regions
        exp_term = exp(a1_hat * log(d_data(i,j)) + a2_hat * (1 - delta(i,j)));
        term = y(j) * exp_term / (P(j)^(1-sigma));

        sum_val = sum_val + term;
    end

    p(i) = (y(i) / sum_val)^(1/(1-sigma));
end

    % Normalize
    p = p / p(1);

end