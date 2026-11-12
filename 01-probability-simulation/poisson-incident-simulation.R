set.seed(5092026)
lambda = 27/1736
simulation = rpois(1000000, lambda * 203)
probability = mean(simulation >= 14)
probability

set.seed(5092026)
n_lambda = 1/lambda
nurse_rate = rexp(1000000, rate= n_lambda)
rev_simulation = rpois(1000000, nurse_rate * 203) 
rev_probability = mean(rev_simulation >= 14)
