function [answer] = getr2(x,y)  

  p = polyfit(x,y,1);
  f = polyval(p,x);
  [r2 rmse] = rsquare(y,f);
  
  answer = r2;