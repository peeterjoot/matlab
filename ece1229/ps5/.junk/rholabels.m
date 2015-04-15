    f = figure ;
    t = 0:0.01: pi/2 ;
    polar(t, 10 * log10(cos(t))/(50) + 1)
    
    rho_labels = {'1' '0.8' '0.6' '0.4' '0.2'};
    rho_labels2 = {'0' '-10' '-20' '-30' '-40'};
    for r=1:length(rho_labels)
       ff = findall(f, 'string', rho_labels{r}) ;
       ff = rho_labels2{r} ;
    end

%rlim = 10;
%axis([-1 1 -1 1]*rlim);

%polar(0,30,'-k')
%hold on

%polar(-50:0,'-k')
%hold on
