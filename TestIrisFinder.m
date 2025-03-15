clc
clear all
close all
ImBR=imread('Bala_Rast.png');
ImPC=imread('Paeen_Chap.png');
ImPR=imread('Paeen_Rast.png');
ImBC=imread('Bala_Chap.png'); 
%subplot(2,2,1)
[radiifinalBR,centerfinalBR,X,Y,Width,Height] = irisfinder1(ImBR);
%[radiifinalBC,centerfinalBC,X,Y,Width,Height] = irisfinder1(ImBC);
%subplot(2,2,2)
figure;
[radiifinalBC,centerfinalBC] = irisfinder2(ImBC,X,Y,Width,Height);
%[radiifinalBR,centerfinalBR] = irisfinder2(ImBR,X,Y,Width,Height);
%subplot(2,2,3)
figure;
[radiifinalPR,centerfinalPR] = irisfinder2(ImPR,X,Y,Width,Height);
%subplot(2,2,4)
figure;
[radiifinalPC,centerfinalPC] = irisfinder2(ImPC,X,Y,Width,Height);
%%
avg_X_Chap  = ( centerfinalBC(1,1)+ centerfinalPC(1,1) ) / 2;
avg_X_Rast  = ( centerfinalBR(1,1)+ centerfinalPR(1,1) ) / 2;
avg_Y_Bala  = ( centerfinalBC(1,2)+ centerfinalBR(1,2) ) / 2;
avg_Y_Paeen = ( centerfinalPR(1,2)+ centerfinalPC(1,2) ) / 2;