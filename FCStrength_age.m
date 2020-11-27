% =========================================================================
% This procedure is used to examine age effect on functional connectivity between 32 DMN nodes
% Written by Fengmei Fan, NKLCNL, BNU, BeiJing, 2020/11/27, fanfengmei@live.com
% =========================================================================
clear all
load matrix_child_CBDPC.mat
load info_child.mat
Covariance_path = pwd; %% work directory
nodes_name = textread('nodes_name.txt','%s');
N_node = numel(nodes_name);
%% FDR
for i_node = 1:N_node
    for j_node = 1:N_node
        if i_node ~= j_node
            prediction = squeeze(matrix_FC(i_node,j_node,:));
            % calculate t and p values for linear and quadratic model
            [age_tt1(i_node,j_node), age_pp1(i_node,j_node),age_beta1(i_node,j_node),...
                age_tt2(i_node,j_node), age_pp2(i_node,j_node),age_beta2(i_node,j_node)] = mixed_model_LQ(prediction,Covariance_path);
            % model selection acordding to AIC
            [age_t(i_node,j_node),age_p(i_node,j_node),age_beta(i_node,j_node),model_type(i_node,j_node)] = mixed_model(prediction,Covariance_path);
        else
            age_pp1(i_node,j_node) = 0;
            age_pp2(i_node,j_node) = 0;
        end
    end
end
[pID1] = gretna_FDR(squareform(age_pp1),0.05)  %%linear FDR correction, pID1=0.0052
[pID2] = gretna_FDR(squareform(age_pp2),0.05)  %% pID2=[];
% Here,please check threshold for FDR correction. We get p value for FDR correction "pID1=0.0052, pID2 is empty",
% which means there is only linear change but no significant quadratic change of functional connectivity
FC_index = zeros(N_node, N_node);
FC_index(find(age_tt1 < 0 & age_pp1 <= pID1 & age_pp1 ~= 0 & model_type==1)) = -1;
FC_index(find(age_tt1 > 0 &  age_pp1 <= pID1 & age_pp1 ~= 0 & model_type==1)) = 1;
% FC_index is a 32*32 matrix, where 1 represents significant linear increase with age,
% and -1 represents significant linear decrease with age, q<0.05,FDR corrected
%% save results
save FCStrength_Age