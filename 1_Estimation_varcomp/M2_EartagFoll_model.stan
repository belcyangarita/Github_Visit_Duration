//
// This Stan program fit a mixed model to estimate the direct (Eartag) and social (Follower) effects 
// on visit duration at the feeder of group-housed pigs.
//

// The input data is a vector 'y' of length 'Nobs'.
data {
  int<lower=0> Nobs;                     // observation number
  int<lower=0> Npreds;                  // locations and wt covariate predictors 
  int<lower=0> Neart;                   // eartags random effects number
  int<lower=0> Nfoll;                   // follower random effects
  int<lower=1, upper=Neart> ET[Nobs];  // eartag identifier records
  int<lower=1,upper=Nfoll> Foll[Nobs]; // follower identifier records
  matrix[Nobs,Npreds] x;               // desing matrix fixed effects
  vector[Nobs] y;                     // visit lenght vector data
}

// The parameters  of the model= beta: locations(2) and wt,eartag (24),"sigma_eartag",'sigma_e'.
parameters {
  vector[Npreds] beta;                           // fixed effects vector 
  vector[Neart] Eartag;                         // vector random effects eartag
  vector[Nfoll] Follower;                       // vector random effects follower
  real<lower=0, upper=10> sigma_eartag;         // sd eartag effet
  real<lower=0, upper=10> sigma_follower;       // sd follower effect
  real<lower=0> sigma_e;                       // standar deviation error
  }
// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'locat+ wt cova'
// and standard deviation 'sigma_e', prior to sigma_e~ uniform(0,inf).
model {   
  // priors for beta(locations,weight) ~ uniform(-inf, inf), 
  // Eartag~ Normal(0,sigma_eartag), Follower ~ Normal(0,sigma_follower),
  // sigma_eartag and sigma_follower ~ unif(0,10), defaults stan
Eartag ~ normal(0,sigma_eartag); 
Follower ~ normal(0, sigma_follower);
  // likelihood
for  (i in 1: Nobs)                       
  y[i]~ normal(x[i]*beta + Eartag[ET[i]] + Follower[Foll[i]], sigma_e);  

}

generated quantities{
  
  // generate estimate variance components of the model
 
 real var_eartag;        //  eartag variance
 real var_follower;       // follower variance
 real var_error;               // error variance
 real prp_var_eartag;     // proportion eartag variance
 real prp_var_follower;     // proportion follower variance
 real prp_var_error;     // proportion error variance
 //vector[Nobs] log_lik;    // computing to saving the loglikelihood for a linear regression with Nobs
                          // data points
 
 var_eartag = pow(sigma_eartag,2);       // compute the eartag variance
 var_follower = pow(sigma_follower,2);   // compute the follower variance
 var_error = pow(sigma_e,2);            // compute the error variance
 
 prp_var_eartag = var_eartag/(var_eartag + var_follower + var_error);  // compute the proportion of variance eartag
 prp_var_follower = var_follower/(var_eartag + var_follower + var_error);  // compute the proportion of variance eartag
 prp_var_error = var_error/(var_eartag + var_follower + var_error);   // compute the proportion of variance error
 
 // compute the lolikelihood
  //for (n in 1:Nobs) 
  //log_lik[n] = normal_lpdf(y[n] | x[n, ]*beta + Eartag[ET[n]] + Follower[Foll[n]], sigma_e);
  
}



