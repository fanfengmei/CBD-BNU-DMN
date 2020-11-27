% =========================================================================
% This procedure is used to calculate global and local efficiency, and
% examine age effect on global and local efficiency
% Written by Fengmei Fan, SKLCNL, BNU, Beijing, 2020/11/27, fanfengmei@live.com
% =========================================================================
clear all
Covariance_path = pwd; % working directory
r_thr = 0.2;  % correlation threshold rth of 0.2 was used to remove the spurious correlations
n = 100;      % number of generated random networks
randtype = 1; % The random matrix was generated using a modified Maslov's wiring program (Maslov and Sneppen 2002).
%% calculate global and local efficiency
load matrix_child_CBDPC.mat
matrix_FC(find(matrix_FC < r_thr)) = 0;
for i_sub = 1:size(matrix_FC,3)
    [A, rthr] = gretna_R2b(matrix_FC(:,:,i_sub), 'r', r_thr);
    M_thr=A.*matrix_FC(:,:,i_sub);
    [N, K, sw] = gretna_sw_efficiency_weight(M_thr, n, randtype)
    locE(i_sub) = sw.locE;  % locE(i_sub) is local efficiency for subject i_sub
    gE(i_sub) = sw.gE;      % gE(i_sub) is global efficiency for subject i_sub
end
%%  age effect on global efficiency
[age_t_gE,age_p_gE,age_beta_gE,model_type_gE] = mixed_model(gE',Covariance_path);
%%  age effect on local efficiency
[age_p_locE,age_t_locE,age_beta_locE,model_type_locE] = mixed_model(locE',Covariance_path);
%% save result
save NeLe_age