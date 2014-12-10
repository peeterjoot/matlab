% this is cut and pasted from 'Numerical Mathematics' to test my matlab implemation
% against.

function [x,relres,iter,flag]=conjgrad(A,b,x,P,nmax,tol)
%CONJGRAD Conjugate gradient method
% [X,RELRES,ITER,FLAG]=CONJGRAD(A,B,X0,NMAX,TOL,OMEGA) attempts
% to solve the system A*X=B with the conjugate gradient method. TOL specifies
% the tolerance of the method. NMAX specifies the maximum number of iterations.
% X0 specifies the initial guess. P is a preconditioner. RELRES is the relative
% residual. If FLAG is 1, then RELRES > TOL. ITER is the iteration number at which
% X is computed.
flag = 0 ; iter = 0 ; bnrm2 = norm(b) ;

if bnrm2 == 0, bnrm2 = 1 ; end

r = b - A * x ;
relres = norm(r)/bnrm2 ;

if relres < tol, return, end

for iter = 1:nmax
   z = P\r ;
   rho = r.' * z ;
   if iter > 1
      beta = rho/rho1 ;
      p = z + beta * p ;
   else
      p = z ;
   end

   q = A * p ;
   alpha = rho/(p.' * q) ;
   x = x + alpha * p ;
   r = r - alpha * q ;
   relres = norm(r)/bnrm2 ;
   if relres <= tol, break, end
   rho1 = rho ;
end

if relres > tol, flag = 1 ; end

return
