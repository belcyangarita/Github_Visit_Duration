#----------------------------------------------------------------------------#
# Date: September 01 2020
# Description code: Calculate the loglikelihood and compute the widely available 
#       information criterion (WAIC) to compare models
#---------------------------------------------------------------------------#

# Input files: trialsdata.Rdata
# output: R object with WAIC value

rm(list = ls())
setwd("~/Documents/Github_Visit_Duration/1_Estimation_varcomp/")

# 1. Load library and data file
library(tidyverse)
library(rstan)
library(loo)

# 1.1. Data file
# R object: trials.data, class: "tbl_df", "tbl","data.frame", Dimension: 74413 x 14
load("~/Documents/Github_Visit_Duration/trialsdata.Rdata")
# 1.2. Input files: 
# To Fit the models in RStan was necesary write a Stan program for the model 
# in a text file that have the extension .stan, which are:   
# M1_Eartag_modelike.stan
# M2_EartagFoll_modelike.stan
# M3_corEartagFoll_modelike.stan

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
  {M160s.model <- stan(file = "M1_Eartag_modelike.stan", data = stanDat,
                       pars=c("log_lik"),
                       save_warmup=FALSE, iter = 12000, chains = 3, warmup = 2000)})


# D. Posterior loglikelihood and WAIC criterion 
m1.60s<-extract_log_lik(M160s.model )
# WAIC- save object
m1.60s.waic<-waic(m1.60s) 
save(m1.60s.waic, file="m1_60s_waic.Rdata")


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
  M260s.model <- stan(file = "M2_EartagFoll_modelike.stan", data = stanDat2,
                      pars = c("log_lik"),
                      save_warmup=FALSE, iter = 12000, chains =3, warmup = 2000)})

# D. Posterior loglikelihood and WAIC criterion 
m2.60s<-extract_log_lik(M260s.model)
# WAIC- save the object
m2.60s.waic<-waic(m2.60s)
save(m2.60s.waic, file="m2_60s_waic.Rdata")

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
  M360s.model <- stan(file = "M3_corEartagFoll_modelike.stan", data = stanDat3,
                      pars = c("log_lik"),      
                      save_warmup=FALSE,iter = 12000, chains =3, warmup = 2000) }) 


# D. Posterior loglikelihood and WAIC criterion 
m3.60s<-extract_log_lik(M360s.model )
# WAIC - save the objec
m3.60s.waic<-waic(m3.60s)
save(m3.60s.waic, file="m3_60s_waic.Rdata")

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
  {M1600s.model <- stan(file = "M1_Eartag_modelike.stan", data = stanDat,
                       pars=c("log_lik"),
                       save_warmup=FALSE, iter = 12000, chains = 3, warmup = 2000)})


# D. Posterior loglikelihood and WAIC criterion 
m1.600s<-extract_log_lik(M1600s.model )
# WAIC - save object
m1.600swo.waic<-waic(m1.600s)
save(m1.600swo.waic, file="m1_600swo_waic.Rdata")

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
  M2600s.model <- stan(file = "M2_EartagFoll_modelike.stan", data = stanDat2,
                      pars = c("log_lik"),
                      save_warmup=FALSE, iter = 12000, chains =3, warmup = 2000)})

# D. Posterior loglikelihood and waic criterion 
m2.600s<-extract_log_lik(M2600s.model )
# WAIC - save object  
m2.600swo.waic<-waic(m2.600s)
save(m2.600swo.waic, file="m2_600swo_waic.Rdata")

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
  M3600s.model <- stan(file = "M3_corEartagFoll_modelike.stan", data = stanDat3,
                      pars = c("log_lik"),      
                      save_warmup=FALSE,iter = 12000, chains =3, warmup = 2000) }) 

# D. Posterior loglikelihood and waic criterion 
m3.600s<-extract_log_lik(M3600s.model)
# WAIC - save object
m3.600swo.waic<-waic(m3.600s)
save(m3.600swo.waic, file="m3_600swo_waic.Rdata")
