%file for holt winters
clc
FID = fopen('datan2.txt', 'r'); 
% Reads File1 data into a cell array Data
Data = textscan(FID,'%f');   
% Returns the first line of cell array of strings Data to lines1
% Close the opened first file
fclose(FID); 
y=Data{1};

disp('Now Enter the Values of alpha, gamma and betta=  ')
fprintf('\n')
alpha=input('Enter the Value of Alpha=  ');
fprintf('\n')
beta=input('Enter the Value of Beta=  ');
fprintf('\n')
gama=input('Enter the Value of Gamma=  ');
fprintf('\n')
c=input('Enter the Value of (extrapolated future data points) C=  ');
fprintf('\n')
ylen=length(y);
yb=0;
for i=c:2*c
  yb=yb+y(i);
end
ybar2=yb/c;
yg=0;
for i=1:c
    yg=yg+y(i);
end
ybar1=yg/c;
  b0 =(ybar2 - ybar1)/c;   

   %Compute for the level estimate a0 using b0 above.
   s=0;
   for i=1:c+1
       s=s+i;
   end
   tbar=s/c;
    a0 =ybar1  - b0 * tbar;
     
    %Compute for initial indices
    for i=1:ylen
        I(i)=y(i)/(a0 +(i+1)* b0);
    end
    
   
    
    for i=1:c
S(i) =(I(i) + I(i+c))/ 2.0;
    end
% Normalize
fg=0;
for i=1:c;
fg=S(i)+fg;
end
tS=c/fg;
  for i=1:c
S(i)=S(i)*tS;
  end
  
  
  % Holt Winters Calculations
  
   F=zeros(1,ylen+c);
    At2 =a0;
    Bt2 =b0;
  At=[];
  Bt=[];
     
for i=1:ylen
Atm1 =At2;
Btm1 =Bt2;
        At1 =alpha*y(i)/(S(i)+(1.0-alpha)*(Atm1 + Btm1));
        Bt1=beta*(At1-Atm1)+(1- beta)*Btm1;
        S(i+c) =gama * y(i) / At1 + (1.0 - gama) * S(i);
F(i)=(a0+b0*(i+1)) * S(i);

At=[At;At1];
Bt=[Bt;Bt1];
end
gama=gama+0.1;
alpha=alpha+0.1;
beta=beta+0.1;
  
  

to=[];
fprintf(' Index     Data   Smoothed    Holt Winter \n')
for i=1:ylen
    fprintf('%d     %f      %f    %f \n',i,y(i),S(i),F(i))
    ty=y(i)-F(i);
    to=[to;ty];
    
end

  % finding the errors
  MSE = mean((to).^2) %MSE
  RMSE=sqrt(MSE) % RMSE
  Error_Percentage = (abs(to)./y) * 100;
  MAPE = mean(Error_Percentage(~isinf(Error_Percentage))) %MAPE
  
  
  % plotting
  figure
  hold on 
 plot(1:ylen,y,1:ylen,F(1:ylen))
 xlabel('Period')
 ylabel('Predicted and Actual Price')
 title('Plot between predicted and Actual Value')
 legend('Actual','Predicted')
 hold off