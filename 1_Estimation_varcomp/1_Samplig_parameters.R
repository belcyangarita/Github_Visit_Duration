#-----------------------------------------------------------------------------------------------#
# Date: September 01 2020
# Description code: Estimation of direct and social effects of feeding duration in growing pigs 
#                   using record from automatic feeding stations
#----------------------------------------------------------------------------------------------#

rm(list = ls())
setwd("~/Documents/Github_Visit_Duration/1_Estimation_varcomp/")

# 1. Load library and data file
library(tidyverse)
library(rstan)


# 1.1. Data file
# R object: trials.data, class: "tbl_df", "tbl","data.frame", Dimension: 74413 x 14

load("~/Documents/Github_Visit_Duration/trialsdata.Rdata")

# 1.2. Input files: 
# To Fit the models in RStan was necesary write a Stan program for the model 
# in a text file that have the extension .stan, which are:   
# M1_Eartag_model.stan
# M2_EartagFoll_model.stan
# M3_corEartagFoll_model.stan

# 1.3. Setting options to rstan
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

#-------------------------------------------------------------------------------------# 
# 2. Selection of records according to the replacement time at the feeder and
#     fit the models
#-------------------------------------------------------------------------------------#

#**************************************************************************************
# 2.1. Immediate replacement time subset (IRT):
#
# Select files where the elapsed time between the end of the current visit and the start 
# of the next visit was less than or equal to 60 seconds.
#**************************************************************************************
tn<-60
trials.data<-trials.data%>%filter(to_next<=tn)
dim(trials.data)

#-------------------------------------------#
# 2.1.2. Fitting three linear mixed models 
#-------------------------------------------#

#------------------------------------------------------
# 2.1.2.1. M1 Model with Animal (eartag) random effect
#------------------------------------------------------

# A. Desing matrix for fixed effects (Contemporary group, hour entry at the feeder, median weight)
# and vector of animals (Eartag)
Xmatrix = model.matrix(~trials.data$Loc_trial+ trials.data$hour_entry+ trials.data$wt_median -1)
dim(Xmatrix)
Eartag<-as.numeric(as.factor(trials.data$Eartag_trial))

# B. Data to stan function
stanDat<- list(Nobs = nrow(trials.data), 
               Npreds=ncol(Xmatrix),
               Neart=length(unique(Eartag)),
               ET=Eartag,
               x = Xmatrix,
               y = trials.data$visit.length)

# C. Sample from posterior distribution: Using stan function

system.time(
  {M160s.model <- stan(file = "M1_Eartag_model.stan", data = stanDat,
                      pars=c("beta", "var_eartag","var_error", "prp_var_eartag","prp_var_error"),
                      save_warmup=FALSE, iter = 12000, chains = 3, warmup = 2000)})


# D. Save the object with posterior distribution for the parameters
save(M160s.model, file="M1_60s_6trials.Rdata")



#---------------------------------------------------------------
# 2.1.2.2. M2 Model with Animal + Follower random effects
#---------------------------------------------------------------

# A. Vector of animal followers
follower<-as.numeric(as.factor(trials.data$follower_trial))

# B. Data to stan function
stanDat2 <- list(Nobs = nrow(trials.data), 
                 Npreds=ncol(Xmatrix),
                 Neart=length(unique(Eartag)),
                 Nfoll=length(unique(follower)),
                 ET=Eartag,
                 Foll=follower,
                 x = Xmatrix,
                 y = trials.data$visit.length)

# C. Sample from posterior distribution: Using stan function

system.time({
  M260s.model <- stan(file = "M2_EartagFoll_model.stan", data = stanDat2,
                      pars = c("beta","var_eartag","var_follower","var_error", 
                               "prp_var_eartag","prp_var_follower", "prp_var_error"),
                      save_warmup=FALSE, iter = 12000, chains = 3, warmup = 2000)})

# D. Save the object with posterior distribution for the parameters
save(M260s.model, file = "M2_60s_6trials.Rdata")

#----------------------------------------------------------------------------------
# 2.1.2.3. M3 Model fit covariance between Animal and Follower random effects
#----------------------------------------------------------------------------------

# A. Data to stan function
stanDat3 <- list(Nobs = nrow(trials.data), 
                 Npreds=ncol(Xmatrix),
                 Neart=length(unique(Eartag)),
                 ET=Eartag,
                 Foll=follower,
                 x = Xmatrix,
                 y = trials.data$visit.length)

# B. Sample from posterior distribution: Using stan function

system.time({
  M360s.model <- stan(file = "M3_corEartagFoll_model.stan", data = stanDat3,
                      pars = c("beta", "rho","var_eartag","var_follower","var_error",
                               "prp_var_eartag","prp_var_follower", "prp_var_error"),      
                      save_warmup=FALSE,iter = 12000, chains = 3, warmup = 2000) }) 


# C.Save the object with posterior distribution for the parameters
save(M360s.model, file = "M3_60s_6trials.Rdata")

# Remove objects 
rm(trials.data, Xmatrix,stanDat,stanDat2,stanDat3)


#**************************************************************************************
# 2.2. **Non-immediate replacement time subset (NIRT):
#
# Select files where the elapsed time between the end of the current visit and the start 
# of the next visit was lat least 600 seconds.
#**************************************************************************************

# load data
load("~/Documents/Github_Visit_Duration/trialsdata.Rdata")

tn<-600
trials.data<-trials.data%>%filter(to_next>=tn)
dim(trials.data)

#-------------------------------------------#
# 2.2.1. Fitting three linear mixed models 
#-------------------------------------------#

#------------------------------------------------------
# 2.2.1.1. M1 Model with Animal (eartag) random effect
#------------------------------------------------------

# A. Desing matrix for fixed effects (Contemporary group, hour entry at the feeder, median weight)
# and vector of animals (Eartag)
Xmatrix = model.matrix(~trials.data$Loc_trial+ trials.data$hour_entry+ trials.data$wt_median -1)
dim(Xmatrix)
Eartag<-as.numeric(as.factor(trials.data$Eartag_trial))

# B. Data to stan function
stanDat<- list(Nobs = nrow(trials.data), 
               Npreds=ncol(Xmatrix),
               Neart=length(unique(Eartag)),
               ET=Eartag,
               x = Xmatrix,
               y = trials.data$visit.length)

# C. Sample from posterior distribution: Using stan function

system.time(
  {M1600s.model <- stan(file = "M1_Eartag_model.stan", data = stanDat,
                       pars=c("beta", "var_eartag","var_error", "prp_var_eartag","prp_var_error"),
                       save_warmup=FALSE, iter = 12000, chains = 3, warmup = 2000)})


# D. Save the object with posterior distribution for the parameters
save(M1600s.model, file="M1_600s_trials.Rdata")

#---------------------------------------------------------------
# 2.2.1.2. M2 Model with Animal + Follower random effects
#---------------------------------------------------------------

# A. Vector of animal followers
follower<-as.numeric(as.factor(trials.data$follower_trial))

# B. Data to stan function
stanDat2 <- list(Nobs = nrow(trials.data), 
                 Npreds=ncol(Xmatrix),
                 Neart=length(unique(Eartag)),
                 Nfoll=length(unique(follower)),
                 ET=Eartag,
                 Foll=follower,
                 x = Xmatrix,
                 y = trials.data$visit.length)

# C. Sample from posterior distribution: Using stan function

system.time({
  M2600s.model <- stan(file = "M2_EartagFoll_model.stan", data = stanDat2,
                      pars = c("beta","var_eartag","var_follower","var_error", 
                               "prp_var_eartag","prp_var_follower", "prp_var_error"),
                      save_warmup=FALSE, iter = 12000, chains = 3, warmup = 2000)})

# D. Save the object with posterior distribution for the parameters
save(M2600s.model, file = "M2_600s_trials.Rdata")

#----------------------------------------------------------------------------------
# 2.2.1.3. M3 Model fit covariance between Animal and Follower random effects
#----------------------------------------------------------------------------------

# A. Data to stan function
stanDat3 <- list(Nobs = nrow(trials.data), 
                 Npreds=ncol(Xmatrix),
                 Neart=length(unique(Eartag)),
                 ET=Eartag,
                 Foll=follower,
                 x = Xmatrix,
                 y = trials.data$visit.length)

# B. Sample from posterior distribution: Using stan function

system.time({
  M3600s.model <- stan(file = "M3_corEartagFoll_model.stan", data = stanDat3,
                      pars = c("beta", "rho","var_eartag","var_follower","var_error",
                               "prp_var_eartag","prp_var_follower", "prp_var_error"),      
                      save_warmup=FALSE,iter = 12000, chains = 3, warmup = 2000) }) 


# C.Save the object with posterior distribution for the parameters
save(M3600s.model, file = "M3_600s_trials.Rdata")

