library(MASS) 

B_0 = 2
B_1 = 1 
B_2 = 1

n = c(20, 100)
p_12 = c(0, 0.5, 0.9, 0.99)
var = 1 
S = 10000

set.seed(67)

results = data.frame()

for (j in n) {
  for (k in p_12) {
    
    sigma_corr = matrix(c(1, k, k, 1), nrow = 2)
    
    Bh_1 = c()
    Bh_2 = c()
    
    for (i in 1:S) {
      X = mvrnorm(j, c(0,0), sigma_corr)
      X_1 = X[, 1]
      X_2 = X[, 2]
      E = rnorm(j, 0, sqrt(var))
      Y = B_0 + B_1 * X_1 + B_2 * X_2 + E
      model = lm(Y ~ X_1 + X_2)
      Bh_1[i] = coef(model)[2]
      Bh_2[i] = coef(model)[3]
    }
    
    Bias_1 = mean(Bh_1) - B_1
    Bias_2 = mean(Bh_2) - B_2
    Var_1 = var(Bh_1)
    Var_2 = var(Bh_2)
    MSE_1 = mean((Bh_1 - B_1)^2)
    MSE_2 = mean((Bh_2 - B_2)^2)
    
    results = rbind(results, data.frame(
      n = j,
      p_12 = k,
      parameter = c("beta1", "beta2"),
      bias = c(Bias_1, Bias_2),
      variance = c(Var_1, Var_2),
      MSE = c(MSE_1, MSE_2)
    ))
  }
}

print(results)
