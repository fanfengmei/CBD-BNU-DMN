% =========================================================================
% This procedure is used to calculate degree, examine age effect on degree of 32 DMN nodes
% and then detect clusters based on developmental rate of degree using k-means clustering
% Written by Fengmei Fan, SKLCNL, BNU, Beijing, 2020/11/27, fanfengmei@live.com
% =========================================================================
clear all
Covariance_path = pwd; %% working directory
nodes_name = textread('nodes_name.txt','%s');
N_node = numel(nodes_name);
%% degree calculation
load matrix_child_CBDPC.mat
r_thr = 0.2;   % correlation threshold rth of 0.2 was used to remove the spurious correlations
matrix_FC(find(matrix_FC<r_thr)) = 0;  % remove connections with weak correlation strength
for i_sub = 1:size(matrix_FC,3)
    [averk degree(i_sub,:)] = gretna_node_degree_weight(matrix_FC(:,:,i_sub));
end
%% calculate the developmental rate of regional degree: age_beta
for j = 1:N_node
    prediction = degree(:,j);
    [age_tt1(j), age_pp1(j),age_beta1(j),...
        age_tt2(j), age_pp2(j),age_beta2(j)] = mixed_model_LQ(prediction,Covariance_path);
end
%% k-means clustering
k = 3; % the optimal clustering number k is determined by using NbClust package.
para = 'sqEuclidean';  % Squared Euclidean distance
[cluster_index, C, sumd,D ] = kmeans(age_beta1', k, 'dist', para, 'Start','uniform','display','iter','OnlinePhase','on','Replicates',10);
nodes_name(find(cluster_index == 1)) % regions in cluster 1
nodes_name(find(cluster_index == 2)) % regions in cluster 2
nodes_name(find(cluster_index == 3)) % regions in cluster 3
%%
save Clustering