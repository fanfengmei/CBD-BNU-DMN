% =========================================================================
% This procedure is used to calculate degree and examine age effect on degree of 32 DMN nodes
% Written by Fengmei Fan, NKLCNL, BNU, BeiJing, 2020/11/27, fanfengmei@live.com
% =========================================================================
clear all; clc;
Covariance_path = pwd; %% work directory
subjects = textread('sub_CBDPC.list' ,'%s');
N_sub = size(subjects,1);
nodes_name = textread('nodes_name.txt','%s');
N_node = numel(nodes_name);
load matrix_child_CBDPC.mat
load info_child.mat
r_thr = 0.2  % correlation threshold rth of 0.2 was used to remove the spurious correlations
matrix_FC(find(matrix_FC<r_thr)) = 0;  %% if FC < 0, then put FC = 0 in matrix_FC
for i_sub = 1:N_sub
    [averk degree(i_sub,:)] = gretna_node_degree_weight(matrix_FC(:,:,i_sub));
end
%%
%% examine age effect
for i = 1:N_node
    prediction = degree(:,i);
    [age_t(i),age_p(i),age_beta(i),model_type(i)] = mixed_model(prediction,Covariance_path);
    [age_tt1(i), age_pp1(i),age_beta1(i),age_tt2(i), age_pp2(i),age_beta2(i)] = mixed_model_LQ(prediction,Covariance_path);
end
[pID1] = gretna_FDR(age_pp1,0.05) %% pID1=0.0097
[pID2] = gretna_FDR(age_pp2,0.05) %% pID2=[];
% Here,please check threshold for FDR correction. We get p value for FDR correction "pID1=0.0097, pID2 is empty",
% which means there is only linear change but no significant quadratic change of regional degree
Degree_index = zeros(N_node, 1);
Degree_index(find(age_tt1 < 0 &  age_pp1 <= pID1 & model_type == 1)) = -1;
Degree_index(find(age_tt1 > 0 &  age_pp1 <= pID1 & model_type == 1)) = 1;
nodes_name(find(Degree_index == 1))  %% nodes with significant increased change across age, q < 0.05 FDR corrected
nodes_name(find(Degree_index == -1)) %% nodes with significant decreased change across age, q < 0.05 FDR corrected
save Degree_age