//
// This Stan program fit a mixed model to estimate the direct effect (Eartag) on visit duration 
// at the feeder of group-housed pigs.
//

// The input data is a vector 'y' of length 'Nobs'.
data {
  int<lower=0> Nobs;                     // observation number
  int<lower=0> Npreds;                  // locations and wt covariate predictors 
  int<lower=0> Neart;                   // eartags random effects number
  int<lower=1, upper=Neart> ET[Nobs];  // eartag identifiers
  matrix[Nobs,Npreds] x;               // desing matrix fixed effects
  vector[Nobs] y;                     // visit lenght vector data
}

// The parameters accepted by the model. Our model
// accepts parameters  beta: locations(2) and wt,eartag (24),"sigma_eartag",'sigma_e'.
parameters {
  vector[Npreds] beta;                  // fixed effects vector 
  vector[Neart] Eartag;                 // vector random effects eartag
  real<lower=0> sigma_eartag;           // sd eartag effect
  real<lower=0> sigma_e;               // standar deviation error
  }

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'locat+ wt cova'
// and standard deviation 'sigma_e', prior to sigma_e~ uniform(0,inf).

model {   
  // priors for beta(locations,weight) ~ uniform(-inf, inf), Eartag ~ normal(0,sigma_eartag),
  // sigma_eartag ~ U(0,inf)
  Eartag ~ normal(0,sigma_eartag); 
  // likelihood
for  (i in 1: Nobs)               
  y[i]~ normal(x[i]*beta + Eartag[ET[i]], sigma_e);  
}

generated quantities{
  // generate estimate variance components of the model
 
 real var_eartag;        //  eartag variance
 real var_error;         // error variance
 real prp_var_eartag;     // proportion eartag variance
 real prp_var_error;     // proportion error variance
 //vector[Nobs] log_lik;    // computing to saving the loglikelihood for a linear regression with Nobs
                          // data points
 
 var_eartag = pow(sigma_eartag,2);  // compute the eartag variance
 var_error = pow(sigma_e,2);       // compute the error variance
 
 prp_var_eartag = var_eartag/(var_eartag + var_error);  // compute the proportion of variance eartag
 prp_var_error = var_error/(var_eartag + var_error);   // compute the proportion of variance error
 
 
 // compute the lolikelihood
 //for (n in 1:Nobs) 
 //log_lik[n] = normal_lpdf(y[n] | x[n, ]*beta + Eartag[ET[n]] , sigma_e);
 
}









