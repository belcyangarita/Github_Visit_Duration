# Direct and social effects of feeding duration in pigs 
This repository contains codes and data needed to reproduce results in Angarita Barajas et al. Estimation of direct and social effects of feeding duration in growing pigs using   record from automatic feeding stations.

> To fit different mixed models to estimate direct and social effects on the feeding time (visit length) of group-housed pigs.

## Table of contents
1. [General information](#general-information)
2. [Sources](#sources)
3. [Technologies](#technologies)
4. [Run examples](#examples)
5. [Contact](#contact)

## General info
This repository contains codes and data needed to reproduce results in the bayesian estimation of covariance componentes fitting
 three different models on feeding duration trait and to calculate the correlation between feeding duration and production traits.

## Sources
 Based on the work from *Angarita Barajas et al.* Estimation of direct and social effects of feeding duration in growing pigs using
  record from automatic feeding stations.

## Technologies
1. R - version 3.5.1

#### Libraries
* tidyverse - version 1.2.1
* rstan - version 2.18.1
* loo - version 2.1.0.9001
* coda - version 0.19-3
* mcmcplots - version 0.4.3
* ggmcmc
* kableExtra - version 1.1.0

2. Stan language

* Stan website at http://mc-stan.org/

## Run Examples
The **global workflow** to reproduce the results is:

1. Estimation of covariance componentes fitting three different models on feeding duration trait. 
2. Calculate the correlation between feeding duration and production traits.

Therefore, **it is very important to follow the order that is described:**


### Features
The repository [Github_Visit_Duration](https://github.com/belcyangarita/Github_Visit_Duration) contains two folder with the principal data file and codes necesaries, which is named with numeric order (1,2, etc) to refer to the execution order of each.

##### Folder:
* [1_Estimation_varcomp](https://github.com/belcyangarita/Github_Visit_Duration/tree/master/1_Estimation_varcomp)
* [2_Correlation_other_traits](https://github.com/belcyangarita/Github_Visit_Duration/tree/master/2_Correlation_other_traits)

##### Data file:
* [trialsdata.Rdata](https://github.com/belcyangarita/Github_Visit_Duration)

The files within the above mentioned folders have the follow exentions:
* *.R*
* *.Rmd*
* *.Rdata*
* *.rds*
* *.stan*
:exclamation:
