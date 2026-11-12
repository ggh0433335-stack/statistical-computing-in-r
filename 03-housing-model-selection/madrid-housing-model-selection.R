madrid <- read.csv('madrid_houses_clean.csv')
#recode several categorical variables to type factor
madrid$house_type <- as.factor(madrid$house_type)
madrid$has_parking <- as.factor(madrid$has_parking)
madrid$has_lift <- as.factor(madrid$has_lift)
madrid$is_exterior <- as.factor(madrid$is_exterior)
madrid$is_renewal_needed <- as.factor(madrid$is_renewal_needed)
head(madrid)
summary(madrid)


#select the houses = house type 2 and select relevant columns
#e.g., none of the houses have a lift so discard has_lift variable
casas <- madrid[madrid$house_type=='2',c(3:7,9,10,14)]
summary(casas) #check: balanced categories? skewed variables?

#explore house price and other skewed variables
par(mfrow=c(1,1),mar=c(2,2,2,2))
hist(casas$buy_price)
hist(log(casas$buy_price))

#log transform
casas$buy_price <- log(casas$buy_price)
casas$sq_mt_built <- log(casas$sq_mt_built)
casas$sq_mt_allotment <- log(casas$sq_mt_allotment+0.1)#avoid -Inf

#scatter plots of price against each continuous predictor
pairs(casas[,1:6])

#predict log transformed house price using all variables
allvar <- lm(buy_price~sq_mt_built+n_rooms+n_bathrooms+n_floors+sq_mt_allotment+is_renewal_needed+has_parking,data = casas)
summary(allvar)

#create data in matrix format
casas_matrix <- as.matrix(casas)


set.seed(12)
casas$is_renewal_needed = as.numeric(casas$is_renewal_needed) - 1
casas$has_parking = as.numeric(casas$has_parking) - 1

pred_names = c("sq_mt_built","n_rooms","n_bathrooms","n_floors", "sq_mt_allotment","is_renewal_needed","has_parking")

y = casas$buy_price
X = as.matrix(casas[, pred_names])
n = nrow(X)

index = sample(n)
train_i = round(0.5 * n) # random indexes for training set
validation_i = round(0.25 * n) # random indexes for validation set

train = index[1:train_i]
valid = index[(train_i + 1):(train_i + validation_i)]
test = index[(train_i + validation_i + 1):n]


# create all models with 1 to 4 predictors
models = list()

for (k in 1:4) {
  cmb = combn(7, k)
  for (j in 1:ncol(cmb)) {
    one_model = cmb[, j] # take one combination
    position = length(models) + 1
    models[[position]] = one_model # store model
  }
}

# calculate validation MSE for all models
val_mse = numeric(length(models))

for (m in seq_along(models)) {
  cols = models[[m]]
  fit = lm(y[train] ~ X[train, cols])
  coefs = coef(fit)
  ynew = numeric(length(valid))
  for (i in seq_along(valid)) {
    ynew[i] = c(1, X[valid[i], cols]) %*% coefs
  }
  
  val_mse[m] = mean((y[valid] - ynew)^2)
}

# histogram of validation errors
hist(val_mse, breaks = 30,
     main = "Validation MSE of all models",
     xlab = "Validation MSE")

# select the best model
best = which.min(val_mse)
best_cols = models[[best]]

pred_names[best_cols]
val_mse[best]

# fit the selected model
trval = c(train, valid)
final = lm(y[trval] ~ X[trval, best_cols])
coefs = final$coef
names(coefs) = c("(Intercept)", pred_names[best_cols])
coefs

# Evaluate the model selected by validation on the untouched test set.
# Keep best_cols = models[[best]] rather than replacing it with fixed predictors.
coef = lm(y[trval] ~ X[trval, best_cols])$coef
ynew = cbind(1, X[test, best_cols]) %*% coef # predictions for test houses

test_mse = mean((y[test] - ynew)^2)
test_mse
sqrt(test_mse) # RMSE
