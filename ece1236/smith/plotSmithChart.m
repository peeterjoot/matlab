%Victor Aprea Cornell University 6/27/02
%
%Usage:		plotsmithchart(Zl,Zo)
%		where Zl is the Load Impedence (possibly complex)
%		and Zo is the Characteristic Line Impedence 
%		Plots a smith chart, along with the reflection coefficient circle
%		and the line of intersection with resistive component equal to 1.

%		plotsmithchart
%		Without any parameters draws a blank smith chart.
%		Wavelengths toward the generator are labeled around the perimeter
%
%For example:	plotsmithchart(25,50)
%		Draws a smithchart, calculates and plots the reflection coefficient
%		for a characteristic impedence of 50 ohms and a load impedence of 25 ohms,
%		and draws the line of intersection with the R=1 circle.

function answer = plotSmithChart(Zl,Zo);
constant = linspace(0,10,5);
phaseAngle = linspace(0,2*pi,50);
unitGamma = exp(j*phaseAngle);
%plot the unit circle in the complex plane
hold on;
plot(real(unitGamma),imag(unitGamma),'r');
%set(gcf,'Position',[0 0 1280 990]);
axis square
zoom on
axis([-1.1 1.1 -1.1 1.1]);

MAX=2001;
bound2=0;
bound3=0;
min_bound1=0;
min_bound2=0;
max_bound2=0;
H=0;
word=0;

Gr = linspace(-1,1,MAX);
hold on;

interval = [[.01:.01:.2],[.22:.02:.5],[.55:.05:1],[1.1:.1:2],[2.2:.2:5],[6:10],[12:2:20],[30:10:50]];
interval2= [[.01:.01:.5],[.55:.05:1],[1.1:.1:2],[2.2:.2:5],[6:10],[12:2:20],[30:10:50]];

%plot real axis
plot(Gr, zeros(1,length(Gr)),'r');

%equations were derived using the symbolic toolbox as follows
%solve('R=(1-Gr^2-Gi^2)/((1-Gr)^2+Gi^2)','Gi')
%bound was derived as follows
%solve('1/(R+1)*(-(R+1)*(R-2*R*Gr+R.*Gr^2-1+Gr^2))^(1/2)=0','Gr')
for R = interval2,
   min_bound1 = (R-1)/(R+1);
   
   if(R<.2)        
      if(mod(R,.1)==0) 
         max_bound = (-1+2^2+R^2)/(2^2+R^2+2*R+1);
      elseif(mod(R,.02)==0)
         max_bound = (-1+.5^2+R^2)/(.5^2+R^2+2*R+1);
      else
         max_bound = (-1+.2^2+R^2)/(.2^2+R^2+2*R+1);
         if(R==.05 | (R<.151 & R>.149))
            min_bound2 = (-1+.5^2+R^2)/(.5^2+R^2+2*R+1);
            max_bound2 = (-1+1^2+R^2)/(1^2+R^2+2*R+1);
         end
      end	
   elseif(R<1)
      if(mod(R,.2)==0) 
         max_bound = (-1+5^2+R^2)/(5^2+R^2+2*R+1);
      elseif(mod(R,.1)==0) 
         max_bound = (-1+2^2+R^2)/(2^2+R^2+2*R+1); 
      elseif(R==.25 | R==.35 | R==.45)
         temp = (-1+.5^2+R^2)/(.5^2+R^2+2*R+1);
         min_bound2 = max(min_bound1, temp);
         max_bound = (-1+1^2+R^2)/(1^2+R^2+2*R+1);
      elseif(R<.5) 
         max_bound = (-1+.5^2+R^2)/(.5^2+R^2+2*R+1); 
      else 
         max_bound = (-1+1^2+R^2)/(1^2+R^2+2*R+1); 
      end      
   elseif(R<5)
      if(mod(R,2)==0)
         max_bound = (-1+20^2+R^2)/(20^2+R^2+2*R+1); 
      elseif(mod(R,1)==0)
         max_bound = (-1+10^2+R^2)/(10^2+R^2+2*R+1); 
      elseif(R>2)
         max_bound = (-1+5^2+R^2)/(5^2+R^2+2*R+1);
      else
         if(mod(R,.2)==0)
	         max_bound = (-1+5^2+R^2)/(5^2+R^2+2*R+1);
         else
            max_bound = (-1+2^2+R^2)/(2^2+R^2+2*R+1);       
         end
      end
   elseif(R<10)
      if(mod(R,2)==0)
         max_bound = (-1+20^2+R^2)/(20^2+R^2+2*R+1); 
      else
         max_bound = (-1+10^2+R^2)/(10^2+R^2+2*R+1); 
      end
   else
      if(R==10|R==20)
         max_bound = (-1+50^2+R^2)/(50^2+R^2+2*R+1); 
      elseif(R==50)
         max_bound = 1;
      elseif(R<20)
         max_bound = (-1+20^2+R^2)/(20^2+R^2+2*R+1); 
      else
         max_bound = (-1+50^2+R^2)/(50^2+R^2+2*R+1); 
      end
   end      
   
   index = ceil((min_bound1+1)*(MAX-1)/2+1);
   actual_value = Gr(index);
   if(actual_value<min_bound1)
      index = index + 1;
   end
   MIN=index;  
   
   index = ceil((max_bound+1)*(MAX-1)/2+1);
   actual_value = Gr(index);
   if(actual_value>max_bound)
      index = index - 1;
   end
   
   MIN2 = ceil((min_bound2+1)*(MAX-1)/2+1);
   actual_value = Gr(MIN2);
   if(actual_value<min_bound2	)
      MIN2 = MIN2 + 1;
   end 
   
   MAX2 = ceil((max_bound2+1)*(MAX-1)/2+1);
   actual_value = Gr(MAX2);
   if(actual_value<max_bound2	)
      MAX2 = MAX2 + 1;
	end	

   r_L_a=1/(R+1)*(-(R+1)*(R-2*R.*Gr(MIN:index)+R.*Gr(MIN:index).^2-1+Gr(MIN:index).^2)).^(1/2);
   r_L_b=-1/(R+1)*(-(R+1)*(R-2*R.*Gr(MIN:index)+R.*Gr(MIN:index).^2-1+Gr(MIN:index).^2)).^(1/2);
   r_L_b(1)=0;
   r_L_a(1)=0;
      
   r_L_a2=1/(R+1)*(-(R+1)*(R-2*R.*Gr(MIN2:MAX2)+R.*Gr(MIN2:MAX2).^2-1+Gr(MIN2:MAX2).^2)).^(1/2);
   r_L_b2=-1/(R+1)*(-(R+1)*(R-2*R.*Gr(MIN2:MAX2)+R.*Gr(MIN2:MAX2).^2-1+Gr(MIN2:MAX2).^2)).^(1/2);
   
   r_L_a3=1/(R+1)*(-(R+1)*(R-2*R.*Gr(MIN2:index)+R.*Gr(MIN2:index).^2-1+Gr(MIN2:index).^2)).^(1/2);
   r_L_b3=-1/(R+1)*(-(R+1)*(R-2*R.*Gr(MIN2:index)+R.*Gr(MIN2:index).^2-1+Gr(MIN2:index).^2)).^(1/2);
   
   %fix resolution issues in .2-.5 range
   
   if(~(R>.2 & R<.5 & ~(mod(R,.02)==0)))
		if(R==1)
         color = 'r';
      else
         color ='b';
      end            
      plot(Gr(MIN:index),r_L_a(1:index-MIN+1),color,Gr(MIN:index), r_L_b(1:index-MIN+1),color);   
      if(R<=1)
      	if(mod(R,1)==0)
         	word = [num2str(R) '.0'];
         else
            word = num2str(R);
         end
         
         if(mod(R,.1)==0) 
         	set(text(Gr(MIN),0,word),'Rotation',90,'HorizontalAlignment','left','VerticalAlignment','bottom');
      	end
   	elseif(R<=2)
         if(mod(R,.2)==0)
            if(mod(R,1)==0)
               word = [num2str(R) '.0'];
            else
               word = num2str(R);
            end
         	set(text(Gr(MIN),0,word),'Rotation',90,'HorizontalAlignment','left','VerticalAlignment','bottom');
      	end
   	elseif(R<=5)
      	if(mod(R,1)==0)
         	set(text(Gr(MIN),0,[num2str(R) '.0']),'Rotation',90,'HorizontalAlignment','left','VerticalAlignment','bottom');
      	end
   	else
      	if(mod(R,10)==0)
         	set(text(Gr(MIN),0,num2str(R)),'Rotation',90,'HorizontalAlignment','left','VerticalAlignment','bottom');
      	end
      end   
      elseif(R==.25 | R==.35 | R==.45)
      plot(Gr(MIN2:index),r_L_a3,'b');
      plot(Gr(MIN2:index),r_L_b3,'b');		
   end
   
   if(R==.05 | (R>.149 & R<.151))
      plot(Gr(MIN2:MAX2),r_L_a2(length(Gr(MIN2:MAX2))-length(r_L_a2)+1:length(r_L_a2)),'b');
      plot(Gr(MIN2:MAX2),r_L_b2(length(Gr(MIN2:MAX2))-length(r_L_b2)+1:length(r_L_b2)),'b');		
   end
   
end

%equations were derived using the symbolic toolbox as follows
%solve('2*Gi/((1-Gr)^2+Gi^2)=x','Gi')
%bound was derived as follows
%solve('1-X^2+2*X^2*Gr-X^2*Gr^2=0','Gr')
%solve('1/2/X*(2+2*(1-X^2+2*X^2*Gr-X^2*Gr^2)^(1/2))=(1-Gr^2)^(1/2)','Gr')
for X = interval,
   inter_bound = (-1+X^2)/(X^2+1); %intersection with unit circle: all values must be less than this\
   imag_bound =  (-1+X)/X; %boundary of imagination: all values must be greater than this
   angle_point = 0;
   if(inter_bound ~= 0)
	   angle_point = sqrt(1-inter_bound^2)/inter_bound;
   end
   
   imag_bound_y =  1/2/X*(-2+2*(1-X^2+2*X^2.*inter_bound-X^2.*inter_bound.^2).^(1/2));
   
   imag_rad = (imag_bound^2 + imag_bound_y^2)^(1/2);
   condition = imag_rad < 1;
   if(inter_bound > 1)
      inter_bound = 1;
   elseif(inter_bound < -1)
      imag_bound=-1;
   end
   
   if(imag_bound > 1)
      imag_bound = 1;
   elseif(imag_bound < -1)
      imag_bound=-1;
   end
   
   %used solve function to find intersection of appropriate circle with corresponding hyperbolics
   %solve('-1/(R+1)*(-(R+1)*(R-2*R*Gr+R*Gr^2-1+Gr^2))^(1/2)=1/2/X*(-2+2*(1-X^2+2*X^2*Gr-X^2*Gr^2)^(1/2))','Gr')
   %The following conditional tree creates the internal bounding between the two types of curves for variable resolution
   if(X<.2)
      if(mod(X,.1)==0) 
         max_bound = (-1+X^2+2^2)/(X^2+2^2+2*2+1);
      elseif(mod(X,.02)==0)
         max_bound = (-1+X^2+.5^2)/(X^2+.5^2+2*.5+1);
      else
         max_bound = (-1+X^2+.2^2)/(X^2+.2^2+2*.2+1);
      end
   elseif(X<1)
      if(mod(X,.2)==0) 
         max_bound = (-1+X^2+5^2)/(X^2+5^2+2*5+1);
      elseif(mod(X,.1)==0) 
         max_bound = (-1+X^2+2^2)/(X^2+2^2+2*2+1); 
      elseif(X<.5) 
         max_bound = (-1+X^2+.5^2)/(X^2+.5^2+2*.5+1); 
      else 
         max_bound = (-1+X^2+1^2)/(X^2+1^2+2*1+1); 
      end      
   elseif(X<5)
      if(mod(X,2)==0)
         max_bound = (-1+X^2+20^2)/(X^2+20^2+2*20+1); 
      elseif(mod(X,1)==0)
         max_bound = (-1+X^2+10^2)/(X^2+10^2+2*10+1); 
      elseif(X>2)
         max_bound = (-1+X^2+5^2)/(X^2+5^2+2*5+1);
      else
         if(mod(X,.2)==0)
   	   	max_bound = (-1+X^2+5^2)/(X^2+5^2+2*5+1);
         else
            max_bound = (-1+X^2+2^2)/(X^2+2^2+2*2+1);
         end
      end
   elseif(X<10)
      if(mod(X,2)==0)
         max_bound = (-1+X^2+20^2)/(X^2+20^2+2*20+1); 
      else
         max_bound = (-1+X^2+10^2)/(X^2+10^2+2*10+1); 
      end
   else
      if(X==10|X==20)
         max_bound = (-1+X^2+50^2)/(X^2+50^2+2*50+1); 
      elseif(X==50)
         max_bound = 1;
      elseif(X<20)
         max_bound = (-1+X^2+20^2)/(X^2+20^2+2*20+1); 
      else
         max_bound = (-1+X^2+50^2)/(X^2+50^2+2*50+1); 
      end
   end 
  
   inter_index = ceil((inter_bound+1)*(MAX-1)/2+1);
   imag_index = ceil((imag_bound+1)*(MAX-1)/2+1);   
   index4 = ceil((max_bound+1)*(MAX-1)/2+1);
   
   index1 = max(inter_index,imag_index); %maximum index for c,d
   index2 = min(imag_index,inter_index); %minimum index for c,d
   
   if(condition)
      index3=imag_index;
   else
      index3=inter_index;
   end
  
   actual_value1 = Gr(index1);
   actual_value2 = Gr(index2);
   actual_value3 = Gr(index3);
   actual_value4 = Gr(index4);
   
   if((actual_value1 > inter_bound & index1 == inter_index)|(actual_value1 > imag_bound & index1 == imag_index))
      index1 = index1 - 1;
   end
   if((actual_value2 < inter_bound & index2 == inter_index)|(actual_value2 < imag_bound & index2 == imag_index))
      index2 = index2 + 1;
   end   
   if((actual_value3 < inter_bound & index3 == inter_index)|(actual_value3 < imag_bound & index3 == imag_index))
   	index3 = index3 + 1;
   end   
   if(actual_value4 > max_bound)
      index4 = index4 - 1;
   end
  
   MIN=index2;
   MAX2=index1;
   MAX3=index4;
   MIN2 = index3;
   
 %  actual_value1 = Gr(MIN);
 %  actual_value2 = Gr(MAX2);
 %  MIN=1;
 %  MAX2=MAX;
 %  MIN2=1;
      
   x_L_a = real(1/2/X*(-2+2*(1-X^2+2*X^2.*Gr(MIN2:MAX3)-X^2.*Gr(MIN2:MAX3).^2).^(1/2)));   
   x_L_b = real(1/2/X*(2-2*(1-X^2+2*X^2.*Gr(MIN2:MAX3)-X^2.*Gr(MIN2:MAX3).^2).^(1/2)));
   x_L_c= real(1/2/X*(2+2*(1-X^2+2*X^2.*Gr(MIN:MAX2)-X^2.*Gr(MIN:MAX2).^2).^(1/2)));
   x_L_d= real(1/2/X*(-2-2*(1-X^2+2*X^2.*Gr(MIN:MAX2)-X^2.*Gr(MIN:MAX2).^2).^(1/2)));   
   
   if(MIN2<MAX3)
   	x_L_c(1)=x_L_b(1);
   	x_L_d(1)=x_L_a(1);
   end
   
   check1 = abs(round(10000*1/2/X*(-2-2*(1-X^2+2*X^2*inter_bound-X^2*inter_bound^2)^(1/2))));
   check2 = abs(round(10000*(1-inter_bound^2)^(1/2)));

   if(imag_bound > -1 & check1 == check2)
      plot(Gr(MIN:MAX2),x_L_c,'g')
      plot(Gr(MIN:MAX2),x_L_d,'g') 
   end
      
   plot(Gr(MIN2:MAX3),x_L_a,'g')
   plot(Gr(MIN2:MAX3),x_L_b,'g')
   
   condition = Gr(MIN2)^2 + x_L_d(1)^2 > .985;   
   if(X<=1)      
      if(mod(X,.1)==0) 
         if(mod(X,1)==0)
            word = [num2str(X) '.0'];
         else
            word = num2str(X);
         end
         if(X==1)
            angle = 90;
         else
            angle = -atan(angle_point)*180/pi;
         end
         set(text(Gr(MIN2),x_L_d(1),word),'Rotation',angle,'VerticalAlignment','bottom','HorizontalAlignment','left');
         set(text(Gr(MIN2),-x_L_d(1),word),'Rotation',-angle+180,'HorizontalAlignment','right','VerticalAlignment','bottom');
       	if(mod(X,.2)==0)
            xval=X^2/(X^2+4);
            yval = 1/2/X*(-2+2*(1-X^2+2*X^2*xval-X^2*xval^2)^(1/2));
            angle = -atan(yval/(.5-xval))*180/pi;
				set(text(xval,yval,word),'Rotation',angle,'HorizontalAlignment','left','VerticalAlignment','bottom');
            set(text(xval,-yval,word),'Rotation',-angle+180,'HorizontalAlignment','right','VerticalAlignment','bottom')
         end   
      end
   elseif(X<=2)
      if(mod(X,.2)==0)
         if(mod(X,1)==0)
            word = [num2str(X) '.0'];
         else
            word = num2str(X);
         end
         if(condition)
            angle = -atan(angle_point)*180/pi+180;
            set(text(Gr(MIN2),x_L_a(1),word),'Rotation',angle,'VerticalAlignment','bottom','HorizontalAlignment','left');
            set(text(Gr(MIN2),-x_L_a(1),word),'Rotation',-angle+180,'HorizontalAlignment','right','VerticalAlignment','bottom');            
         else
            angle = -atan(angle_point)*180/pi+180;            
      		set(text(Gr(MAX2),x_L_d(length(x_L_d)),word),'Rotation',angle,'VerticalAlignment','bottom','HorizontalAlignment','left');
      		set(text(Gr(MAX2),-x_L_d(length(x_L_d)),word),'Rotation',-angle+180,'HorizontalAlignment','right','VerticalAlignment','bottom');            
         end
      end
   elseif(X<=5)
      if(mod(X,1)==0)
         if(condition)
            angle = -atan(angle_point)*180/pi+180;
      		set(text(Gr(MIN2),x_L_a(1),[num2str(X) '.0']),'Rotation',angle,'VerticalAlignment','bottom','HorizontalAlignment','left');
      		set(text(Gr(MIN2),-x_L_a(1),[num2str(X) '.0']),'Rotation',-angle+180,'HorizontalAlignment','right','VerticalAlignment','bottom');            
         else
            angle = -atan(angle_point)*180/pi+180;            
      		set(text(Gr(MAX2),x_L_d(length(x_L_d)),[num2str(X) '.0']),'Rotation',angle,'VerticalAlignment','bottom','HorizontalAlignment','left');
      		set(text(Gr(MAX2),-x_L_d(length(x_L_d)),[num2str(X) '.0']),'Rotation',-angle+180,'HorizontalAlignment','right','VerticalAlignment','bottom');            
         end
      end
   else
      if(mod(X,10)==0)
         if(condition)
            angle = -atan(angle_point)*180/pi+180;            
      		set(text(Gr(MIN2),x_L_a(1),num2str(X)),'Rotation',angle,'VerticalAlignment','bottom','HorizontalAlignment','left');
      		set(text(Gr(MIN2),-x_L_a(1),num2str(X)),'Rotation',-angle+180,'HorizontalAlignment','right','VerticalAlignment','bottom');            
         else
            angle = -atan(angle_point)*180/pi+180;            
            set(text(Gr(MAX2),x_L_d(length(x_L_d)),num2str(X)),'Rotation',angle,'VerticalAlignment','bottom','HorizontalAlignment','left');
        		set(text(Gr(MAX2),-x_L_d(length(x_L_d)),num2str(X)),'Rotation',-angle+180,'HorizontalAlignment','right','VerticalAlignment','bottom');
   		end
      end
   end
end
%plot imaginary axis
plot(zeros(1,length(Gr)),Gr,'r');


wavelengths = 0:.01:.5;
angle = linspace(pi,-pi,length(wavelengths));
wave_circle = 1.05*exp(j*phaseAngle);
plot(real(wave_circle),imag(wave_circle),'r');

for i=1:length(wavelengths)-1,
   x=real(1.025*exp(j*angle(i)));
   y=imag(1.025*exp(j*angle(i)));
   if(x>0)
      rot_angle=atan(y/x)*180/pi-90;
   else
      rot_angle=atan(y/x)*180/pi+90;
   end
   if(wavelengths(i)==0)
      word = '0.00';
   elseif(mod(wavelengths(i),.1)==0)
      word = [num2str(wavelengths(i)) '0'];
   else
      word = num2str(wavelengths(i));
   end
   set(text(x,y,word),'Rotation',rot_angle,'VerticalAlignment','middle','HorizontalAlignment','center');
end

%plot reflection coefficient and line of intersection only if arguments are present

if(nargin == 2)
	radius = abs((Zl-Zo)/(Zl+Zo));
	Load_circle=radius*exp(j*phaseAngle);
	plot(real(Load_circle),imag(Load_circle),'r');

	slope = (-(1-radius^2)^(1/2)*radius)/(radius^2);

	value=1/(1+slope^2)^(1/2);
	MAX2 = ceil((value+1)*(MAX-1)/2+1);
	actual_value = Gr(MAX2);
	if(actual_value>value)
  		MAX2 = MAX2 - 1;
	end

	%plot line of intersection
	line = slope*Gr(fix(MAX/2):MAX2);
	plot(Gr(fix(MAX/2):MAX2),line,'r');
end

