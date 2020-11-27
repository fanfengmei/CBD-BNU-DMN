% =========================================================================
% This procedure is used to calculate degree and examine age effect on degree of 32 DMN nodes
% Written by Fengmei Fan, SKLCNL, BNU, Beijing, 2020/11/27, fanfengmei@live.com
% =========================================================================
clear all
Covariance_path = pwd; % working directory
nodes_name = textread('nodes_name.txt','%s');
N_node = numel(nodes_name);
load matrix_child_CBDPC.mat
load info_child.mat
r_thr = 0.2  % correlation threshold rth of 0.2 was used to remove the spurious correlations
matrix_FC(find(matrix_FC<r_thr)) = 0;  % remove connections with weak correlation strength
for i_sub = 1:size(matrix_FC,3)
    [averk degree(i_sub,:)] = gretna_node_degree_weight(matrix_FC(:,:,i_sub));
end
%% examine the age effect
for i = 1:N_node
    prediction = degree(:,i);
    [age_t(i),age_p(i),age_beta(i),model_type(i)] = mixed_model(prediction,Covariance_path);
    [age_tt1(i), age_pp1(i),age_beta1(i),age_tt2(i), age_pp2(i),age_beta2(i)] = mixed_model_LQ(prediction,Covariance_path);
end
%% Correction for multiple comparisons using the FDR method
[pID1] = gretna_FDR(age_pp1,0.05)
[pID2] = gretna_FDR(age_pp2,0.05)
% Please check the output threshold for the FDR method. Here,we found "pID1=0.0097, pID2 is empty",
% which means there is significant linear change but no significant quadratic change
Degree_index = zeros(N_node, 1);
Degree_index(find(age_tt1 < 0 &  age_pp1 <= pID1 & model_type == 1)) = -1;
Degree_index(find(age_tt1 > 0 &  age_pp1 <= pID1 & model_type == 1)) = 1;
nodes_name(find(Degree_index == 1))  % nodes with significant increased change across age, q < 0.05 FDR corrected
nodes_name(find(Degree_index == -1)) % nodes with significant decreased change across age, q < 0.05 FDR corrected
save Degree_age