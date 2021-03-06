function [centr,multn,classn,olabn,updatedn,obslist] = psc(x,n_min,mult,class,olab,updated,mat,obslist)

% Projection sequential clustering. 
%
% [centr,multn,classn] = psc(x,n_min)          % minimum call
% [centr,multn,classn] = psc(x,n_min,mult,class,olab,mat,obslist) % complete call
%
%
% INPUTS:
%
% x: (NxM) original matrix with centroids.
%
% n_min: (1x1) number of output clusters.
%
% mult: (Nx1) multiplicity of each cluster.
%
% class: (Nx1) class associated to each cluster.
%
% olab: {Nx1} label of each cluster.
%
% updated: (Nx1) specifies if the data is a new point
%   0: old point
%   1: new point
%
% mat: (MxA) projection matrix for distance computation.
%
% obslist: (Nx1) list of observations for the clustering file system.
%
%
% OUTPUTS:
%
% centr: (n_minxM) output centroids.
%
% multn: (n_minx1) output multiplicity.
%
% classn: (n_minx1) output classes.
%
% olabn: {n_minx1} output labels.
%
% updatedn: {n_minx1} output updated values
%   0: old point
%   1: new point or combination with a new point
%
% obslist: (n_minx1) output list of observations for the clustering file
%   system.
%
%
% coded by: Jose Camacho Paez (josecamacho@ugr.es)
% last modification: 03/Sep/15.
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
    
%% Parameters checking

if nargin < 2, error('Error in the number of arguments.'); end;
if ndims(x)~=2, error('Incorrect number of dimensions of x.'); end;
s = size(x);
if find(s<1), error('Incorrect content of x.'); end;
if nargin < 3, mult = ones(s(1),1); end;
if nargin < 4, class = ones(s(1),1); end;
if nargin < 5, olab = {}; end;
if nargin < 6, updated = ones(s(1),1); end;
if nargin < 7, mat = eye(s(2)); end;
if nargin < 8, obslist = {}; end;


% Main code

u = x*mat;
D = Inf*ones(s(1)); % initialization of the (upper triangular) matrix of Mahalanobis distances 
for i=1:s(1),
    for j=i+1:s(1),
        if class(i)==class(j), % if belong to the same class, compute the distance between observations i and j
            r = (u(i,:)-u(j,:))';
            D(i,j) = r'*r; 
        else % of different classes, not comparable
            D(i,j) = Inf;
        end
        
    end
end

centr = x;
multn = mult;
classn = class;
olabn = olab;
updatedn = updated;
for i=s(1)-1:-1:n_min, % reduction to n_min clusters
    
    % Computation of the minimum distance between observations or clusters
    min_dist = find(min(min(D))==D,1);
    
    % Location of the element with minimum distance
    row = mod(min_dist,i+1);
    if ~row, row = i+1; end
    column = ceil(min_dist/(i+1)); 
    if multn(column)>multn(row),
        aux_v = row;
        row = column;
        column = aux_v;
    end     
        
    % Actualization of the list
    if ~isempty(obslist),
        obslist{row} = [obslist{row} obslist{column}];
    end
    
    % Actualization of labels
    if ~isempty(olabn),
        if ~isequal(olabn{row},olabn{column})
            olabn{row} = 'mixed';
        end      
    end
    
    % Actualization of centroids, multiplicity and updated values 
    centr(row,:) = (multn(row)*centr(row,:)+multn(column)*centr(column,:))/sum(multn([row column])); % centroids 
    multn(row) = sum(multn([row column])); 
    updatedn(row) = max(updatedn([row column])); 
   
    % Actualization of the distance
    u(row,:) = centr(row,:)*mat;
    r = u-ones((i+1),1)*u(row,:);
    new_dist = sum(r.^2,2);
    classdiff = find(classn~=classn(row)); 
    new_dist(classdiff) = Inf; 
    D(1:(row-1),row) = new_dist(1:(row-1));
    D(row,(row+1):end) = new_dist((row+1):end);
   
    % Delete old cluster references
    if ~isempty(obslist),
        obslist = obslist([1:(column-1) (column+1):end]);
    end
    if ~isempty(olabn),
        olabn = olabn([1:(column-1) (column+1):end]);
    end
    multn = multn([1:(column-1) (column+1):end]);
    classn = classn([1:(column-1) (column+1):end]);
    updatedn = updatedn([1:(column-1) (column+1):end]); 
    centr = centr([1:(column-1) (column+1):end],:);
    u = u([1:(column-1) (column+1):end],:);
    D = D([1:(column-1) (column+1):end],[1:(column-1) (column+1):end]);
    
    if isempty(find(D<Inf)),
        indmin = i;
        break;
    end
        
end