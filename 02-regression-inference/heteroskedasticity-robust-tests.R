library(sandwich)
library(lmtest)

B_0 = 10
B_1 = c(0, 0.3)
B_2 = 1
An = c(20, 100)
mechanisms = c("additive", "multiplicative")
alpha = 0.05
S = 10000

results = data.frame()

set.seed(67)

for (n in An) {
  for (mechanism in mechanisms) {
    
    if (mechanism == "additive") {
      std_values = c(3)
    } else {
      std_values = c(0.3, 0.6, 1)
    }
    
    for (std in std_values) {
      for (B_1_val in B_1) {
        
        classical_rejections = 0
        robust_rejections = 0
        
        for (i in 1:S) {
          X_1 = runif(n, 1, 15)
          X_2 = rnorm(n, 5, 1)
          u = rnorm(n, 0, std)
          
          if (mechanism == "additive") {
            Y = B_0 + X_1 * B_1_val + X_2 * B_2 + u
          } else {
            Y = B_0 + X_1 * B_1_val + X_2 * B_2 + u * X_1
          }
          
          model = lm(Y ~ X_1 + X_2)
          
          classic_test = summary(model)$coefficients
          classic_p = classic_test["X_1", "Pr(>|t|)"]
          
          if (classic_p < alpha) {
            classical_rejections = classical_rejections + 1
          }
          
          
          robust_test = coeftest(model, vcov. = vcovHC(model, type = "HC3"))
          robust_p = robust_test["X_1", "Pr(>|t|)"]
          
          if (robust_p < alpha) {
            robust_rejections = robust_rejections + 1
          }
          
        }
        
        results = rbind(results, data.frame(
          n = n,
          mechanism = mechanism,
          std = std,
          B_1 = B_1_val,
          classical_rate = classical_rejections / S,
          robust_rate = robust_rejections / S
        ))
      }
    }
  }
}

print(results)