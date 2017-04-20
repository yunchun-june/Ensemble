clear all;
close all;

x = 1:3;
y3 = [-5 0 5];
y1 = y3+2;
y2 = y3+1;
y4 = y3-1;
y5 = y3-2;


figure

plot(x,y1,x,y2,x,y3,x,y4,x,y5);
xlabel('presented emotion');
ylabel('emotion rating');
axis([1 3 -10 10])
set(gca,'XTickLabel', {'negitive','','neutral','','positive'});

%=================%

x = 1:5;
y = [0.4 0.2 0 -0.2 -0.4]

figure
scatter(x,y);
axis([0 6 -1 1])
xlabel('Ensumble Condition');
ylabel('Emotion Rating(normalized)');
set(gca,'XTickLabel', {'','4F','3F1H','2F2H','1F3H','4H',''});

