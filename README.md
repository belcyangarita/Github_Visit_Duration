# Direct and social effects of feeding duration in pigs 

> To fit different mixed models to estimate direct and social effects on the feeding time (visit length) of group-housed pigs.

## Table of contents
1. [General information](#general-information)
2. [Sources](#sources)
3. [Technologies](#technologies)
4. [Run examples](#examples)
5. [Acknowledgements](#Acknowledgements])
6. [Contact](#contact)

## General information
This repository contains codes and data needed to reproduce results in the bayesian estimation of covariance componentes fitting
 three different models on feeding duration trait and to calculate the correlation between feeding duration and production traits.

## Sources
 Based on the work from *Angarita Barajas et al.* Estimation of direct and social effects of feeding duration in growing pigs using
  record from automatic feeding stations.

## Technologies
1. [R](https://www.r-project.org/) - version 3.5.1

#### Libraries
* tidyverse - version 1.2.1
* rstan - version 2.18.1
* loo - version 2.1.0.9001
* coda - version 0.19-3
* mcmcplots - version 0.4.3
* ggmcmc
* kableExtra - version 1.1.0

2. [Stan](http://mc-stan.org/) language

* Stan website at http://mc-stan.org/


## Run Examples
The **global workflow** to reproduce the results is:

1. Estimation of covariance componentes fitting three different models on feeding duration trait. 
2. Calculate the correlation between feeding duration and production traits.

Therefore, **it is very important to follow the order that is described and and take into account the warnings:** :warning:


### Features
The repository [Github_Visit_Duration](https://github.com/belcyangarita/Github_Visit_Duration) contains two folder with the principal data file and codes necesaries, which is named with numeric order (1,2, etc) to refer to the execution order of each.

##### Folder:
* [1_Estimation_varcomp](https://github.com/belcyangarita/Github_Visit_Duration/tree/master/1_Estimation_varcomp)
* [2_Correlation_other_traits](https://github.com/belcyangarita/Github_Visit_Duration/tree/master/2_Correlation_other_traits)

##### Data file:
* [trialsdata.Rdata](https://github.com/belcyangarita/Github_Visit_Duration)

The files within the above mentioned folders have the follow exentions:
* *.R*: R code workflow, used to fit the different models, estimate the model parameters and generate the outputs objects (*.Rdata*) 
* *.Rmd*: R Markdown code to generate the report with the results in html format
* *.Rdata*: files are specific to R, which have the output objects to obtain the principal results
* *.rds*: file generated after compile the .stan files
* *.stan*: Stan program for write the model in a text file


### Run workflow
1. Bayesian estimation of covariance components:

	**1.** To fit the models and obtain the samples for posterior parameters it must execute the code [1_Samplig_parameters.R](https://github.com/belcyangarita/Github_Visit_Duration/tree/master/1_Estimation_varcomp). **IMPORTANT WARNING:** :warning: it is recommended not to run this code as it takes a long time to run and you need to have access to High Performance Computing.

	**2.** To determine the convergence of the Markov's chains it must execute the code [2_Convergence_Diagnostics.Rmd](https://github.com/belcyangarita/Github_Visit_Duration/tree/master/1_Estimation_varcomp)

	**3.** To obtain the pointwise-loglikelihood and compute the widely available information criterion (WAIC) to compare models it must execute the code [3_pointwise_loglikelihood.R](https://github.com/belcyangarita/Github_Visit_Duration/tree/master/1_Estimation_varcomp). **IMPORTANT WARNING:** :warning: it is recommended not to run this code as it takes a long time to run and you need to have access to High Performance Computing.

	**4.** To make the model comparison it must execute the code [4_model_comparison.Rmd](https://github.com/belcyangarita/Github_Visit_Duration/tree/master/1_Estimation_varcomp)

2. Calculate the correlation between feeding duration and production traits:

 	**1.** To obtain the estimates correlations between feeding duration and production traits it must be executed the code [1_Correlations_between_traits.Rmd](https://github.com/belcyangarita/Github_Visit_Duration/tree/master/1_Estimation_varcomp)



## Acknowledgements
> This work is supported by Agriculture and Food Research Initiative Awards number 2017-67007-26176 and 2014-68004-21952 from the USDA National Institute of Food and Agriculture. Additional support for this work was provided by grants from the National Pork Board Award number 17-023, the Michigan Alliance for Animal Agriculture and Michigan State University. The authors acknowledge Kevin Turner and staff at the Swine Teaching and Research Center for the animal care and assistance with data collection


## Contact
> Corresponding author: steibelj@msu.edu
