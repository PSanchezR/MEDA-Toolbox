function [cumpress,press] = crossval_pca(x,pcs,leave_m,blocks_r,blocks_c,prep,opt)

% Cross-validation for square-prediction-errors computing. The original
% papers are Chemometrics and Intelligent Laboratory Systems 131, 2014, pp.
% 37-50 and Journal of Chemometrics, 26(7), 2012, pp. 361-373.
%
% [cumpress,press] = crossval_pca(x,pcs) % minimum call
% [cumpress,press] = crossval_pca(x,pcs,leave_m,blocks_r,blocks_c,prep,opt)
% % complete call
%
% INPUTS:
%
% x: (NxM) billinear data set for model fitting
%
% pcs: (1xA) Principal Components considered (e.g. pcs = 1:2 selects the
%   first two PCs)
%
% leave_m: (str) cross-validation procedure:
%   'rkf': row-wise k fold (default)
%   'ekf': element-wise k fold
%   'cekf': corrected element-wise k fold
%
% blocks_r: (1x1) maximum number of blocks of samples (Inf by default)
%
% blocks_c: (1x1) maximum number of blocks of variables (Inf by default)
%
% prep: (1x1) preprocesing
%       0: no preprocessing 
%       1: mean-centering 
%       2: auto-scaling (default)  
%
% opt: (1x1) options for data plotting.
%       0: no plots.
%       1: bar plot (default)
%
% OUTPUTS:
%
% cumpress: (pcs x 1) Cumulative PRESS.
%
% press: (pcs x M) PRESS per variable.
%
% codified by: Jose Camacho Paez (josecamacho@ugr.es)
% last modification: 2/Feb/15.
%
% Copyright (C) 2014  University of Granada, Granada
% Copyright (C) 2014  Jose Camacho Paez
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


% Arguments checking

if nargin < 2, error('Error in the number of arguments.'); end;

if ndims(x)~=2, error('Incorrect number of dimensions of x.'); end;
s = size(x);
if find(s<1), error('Incorrect content of x.'); end;

if min(pcs)<0, pcs = 0:max(pcs); end;

if nargin < 3, leave_m = 'rkf'; end;
if nargin < 4, blocks_r = Inf; end;
if nargin < 5, blocks_c = Inf; end;
if nargin < 6, prep = 2; end;
if nargin < 7, opt = 1; end;

if pcs<0, error('Incorrect value of pc.'); end;
if blocks_r>s(1), blocks_r = s(1); end
if (blocks_r<2), error('Incorrect value of blocks_r.'); end;
if blocks_c>s(2), blocks_c = s(2); end
if (blocks_c<2), error('Incorrect value of blocks_r.'); end;


% Initialization
cumpress = zeros(max(pcs)+1,1);
press = zeros(max(pcs)+1,s(2));

rows = rand(1,s(1));
[a,r_ind]=sort(rows);
elem_r=s(1)/blocks_r;

cols = rand(1,s(2));
[a,c_ind]=sort(cols);
elem_c=s(2)/blocks_c;


% Cross-validation
for i=1:blocks_r,
    
    %disp(sprintf('Block %i of %i',i,blocks_r))
    
    ind_i = r_ind(round((i-1)*elem_r+1):round(i*elem_r)); % Sample selection
    i2 = ones(s(1),1);
    i2(ind_i)=0;
    sample = x(ind_i,:);
    calibr = x(find(i2),:); 
    sc = size(calibr);
    ss = size(sample);

    [ccs,av,st] = preprocess2D(calibr,prep);
    
    if ~prep,
        avs_prep=ones(ss(1),1)*mean(ccs);
    else
        avs_prep=zeros(ss);
    end
        
    scs=sample;
    for j=1:length(ind_i),
        scs(j,:) = (sample(j,:)-av)./st;
    end
     
    p = pca_pp(ccs,pcs(end));
    
    for pc=pcs,
        
        if pc > 0, % PCA Modelling
                               
            p2 = p(:,max(1,pcs(1)):min(pc,end));
            
            switch lower(leave_m)
                
                case 'rkf',
                    t_est = scs*p2;
                    srec = t_est*p2';
                    pem = sum((scs-srec).^2,1);
                                     
                case 'ekf',
                    t_est = scs*p2;
                    srec = t_est*p2';
                    erec = scs - srec;
                    term3_p = erec;
                    if blocks_c == s(2),
                        term1_p = (scs-avs_prep).*(ones(ss(1),1)*(sum(p2.*p2,2))');
                    else
                        term1_p = zeros(size(term3_p));
                        for j=1:blocks_c,
                            ind_j = c_ind(round((j-1)*elem_c+1):round(j*elem_c)); % Variables selection
                            term1_p(:,ind_j) = (scs(:,ind_j)-avs_prep(:,ind_j))*(p2(ind_j,:)*p2(ind_j,:)');
                        end
                    end
                    
                    term1 = sum(term1_p.^2,1);
                    term2 = sum(2*term1_p.*term3_p,1);
                    term3 = sum(term3_p.^2,1);
                    
                    pem = term1 + term2 + term3;
                    
                case 'cekf'
                    t_cest = ccs*p2;
                    t_sest = scs*p2;
                    
                    rec = t_cest*p2';
                    rec_sam = t_sest*p2';
                    for j=1:blocks_c,
                        ind_j = c_ind(round((j-1)*elem_c+1):round(j*elem_c)); % Variables selection
                        p3 = pca_pp([ccs rec(:,ind_j)],pc);
                        scs2 = [scs rec_sam(:,ind_j)];
                        scs2(:,ind_j) = avs_prep(:,ind_j);
                        t_est = scs2*p3;
                        pred = t_est*p3';
                        srec(:,ind_j) = pred(:,ind_j);
                    end
                    
                    pem = sum((scs-srec).^2,1);
            
                otherwise
                    error('Incorrect leave_m.');
                    
            end
            
        else % Modelling with the average
            pem = sum(scs.^2,1);
        end
        
        press(pc+1,:) = press(pc+1,:) + pem;
        
    end            
end

cumpress = sum(press,2);


%% Show results

if opt == 1,
    fig_h = plot_vec(cumpress(pcs+1),num2str((pcs')),'PRESS',[],1);
end

