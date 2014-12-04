function [Gq,Cq,Bq,Lq,Vq]=prima(G,C,B,L,order,varargin)
%   PRIMA ORDER REDUCTION 
%
%      [Gq,Cq,Bq,Lq,Vq]=prima(G,C,B,L,order)
%      [Gq,Cq,Bq,Lq,Vq]=prima(G,C,B,L,order,numorth)
%      [Gq,Cq,Bq,Lq,Vq]=prima(G,C,B,L,order,numorth,freqshift)
%
%   Reduces a linear system in MNA form
%
%   	G x + C dx/dt = B u
%   	y = L' x
%
%   to an approximate system of the desired order
%   using the PRIMA algorithm.
%
%   G,C: n x n
%   B: n x ni, where ni is the number of inputs
%   L: n x no, where no is the number of outputs
%   order: desired order for the reduced model (integer)
%   numorth: number of orthogonalizations (default:2)
%   freqshift: frequency shifting (detail: none)
%
%   Gq,Cq: order x order
%   Bq: order x ni
%   Lq: order x no
%   Vq: n x order    projection matrix
%
% -------------------------------------------
% Author: Piero Triverio
% Date: May 11, 2003
% Modified: July 15, 2003 
% Modified: 2013 LUPQR decomposition optimization
% Modified: oct 7, 2013: full variant
% -------------------------------------------

% Process input arguments and options
switch(nargin)
case 5
    s0=0;
    numorth=2;
case 6
    s0=0;
    numorth=varargin{1};
    if (numorth<1)
        numorth=2;
    end
case 7
    s0=varargin{2};
    numorth=varargin{1};
    if (numorth<1)
        numorth=2;
    end
  
otherwise
    error('Wrong number of input arguments');
end

% Order of original system
n=size(G,1);

% Number of inputs and outputs
ni=size(B,2);
no=size(L,2);

if order >= n
    error('The required order is greater or equal to the order of the original system!');
end

% Number of moments to be matched
k=ceil(order/ni);

Aq=zeros(k*ni,k*ni);
Vq=zeros(n,k*ni);          
delta=zeros(ni,ni);

%Precompute the LU decomposition of G+s0*C
if issparse(G+s0*C)
    [LL,UU,PP,QQ,RR] = lu(G+s0*C);
else
    [LL,UU,PP] = lu(G+s0*C);
    QQ = 1;
    RR = 1;
end

%R=full((G+s0*C)\B);
R = RR\B;
R = PP*R;
R = LL\R;
R = UU\R;
R = QQ*R;
R = full(R);

% Generate first block V_0 of projection matrix
[Vq(:,1:ni),~] = qr(R,0);

% Arnoldi iteration
for j=1:k-1       
    %Vq(:,j*ni+1:(j+1)*ni) = -(G+s0*C)\(C*Vq(:,(j-1)*ni+1:j*ni));
    temp = C*Vq(:,(j-1)*ni+1:j*ni);
    temp = RR\temp;
    temp = PP*temp;
    temp = LL\temp;
    temp = UU\temp;
    temp = -QQ*temp;
    Vq(:,j*ni+1:(j+1)*ni) = temp;
    for xi=1:numorth
        for i=1:j % Modified Gram-Schmidt orthonormalization
            delta = Vq(:,(j-i)*ni+1:(j-i+1)*ni)' * Vq(:,j*ni+1:(j+1)*ni);
            Vq(:,j*ni+1:(j+1)*ni) = Vq(:,j*ni+1:(j+1)*ni) -  Vq(:,(j-i)*ni+1:(j-i+1)*ni) * delta;
        end
    end
    [Vq(:,j*ni+1:(j+1)*ni),Aq(j*ni+1:(j+1)*ni,(j-1)*ni+1:j*ni)] = qr(Vq(:,j*ni+1:(j+1)*ni),0);    
end

% Trim Vq in order to achieve the desired order
Vq=Vq(:,1:order); 

% Generate the reduced model by projecting the matrices of the original
% model
Gq=Vq'*G*Vq;
Cq=Vq'*C*Vq;
Bq=Vq'*B;
Lq=Vq'*L;

return
