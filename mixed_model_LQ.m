function [age_tValue1,age_pValue1,age_beta1,age_tValue2, age_pValue2,age_beta2] = mixed_model_LQ(prediction,Covariance_path)
% =========================================================================
% This function is used to examine the linear and quadratic age effects on the measures of interest
% Syntax: [age_tValue1, age_pValue1, age_beta1, age_tValue2, age_pValue2, age_beta2] = mixed_model_LQ(prediction,Covariance_path)
%
% Input:
%       prediction: Dependent variable in terms of a column
%       Covariance_path: full path of the data containing the covariance information
% Output:
%       age_tValue1: t value of linear age effect
%       age_pValue1: p value of linear age effect
%       age_beta1: beta value of linear age effect
%       age_tValue2: t value of quadratic age effect
%       age_pValue2: p value of quadratic age effect
%       age_beta2: beta value of quadratic age effect
%
% Written by Tianyuan Lei, SKLCNL, BNU, Beijing, 2020/3/10, tianyuanlei@yeah.net
% Edited by Fengmei Fan, SKLCNL, BNU, Beijing, 2020/11/27, fanfengmei@live.com
% =========================================================================

addpath(Covariance_path);
load('info_child.mat');
table_model.depen_var = prediction;

%% Random intercept and slope, without correlation between them
lme1 = fitlme(table_model,'depen_var ~ 1 + age + sex+ meanFD + (1|subname) + (-1 + age|subname)');
lme2 = fitlme(table_model,'depen_var ~ 1 + age^2 + sex + meanFD + (1|subname) + (-1 + age|subname) + (-1 - age + age^2|subname) ');
%% linear age effect
age_pValue1 = lme1.Coefficients.pValue(2);
age_beta1 = lme1.Coefficients.Estimate(2);
age_tValue1 = lme1.Coefficients.tStat(2);
%% quadratic age effect
age_pValue2 = lme2.Coefficients.pValue(5);    %significance age^2
age_beta2 = lme2.Coefficients.Estimate(5);
age_tValue2 = lme2.Coefficients.tStat(5);
end