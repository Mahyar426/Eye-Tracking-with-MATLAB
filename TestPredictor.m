clc
clear all
close all
ImUR=imread('UpRight3.png');
ImUL=imread('UpLeft3.png'); 
ImDL=imread('DownLeft3.png');
ImDR=imread('DownRight3.png');
Desired=imread('Desired3.png');
[mean_x,mean_y]= Predictor(ImUR,ImUL,ImDL,ImDR,Desired);
error=sqrt( ((400-mean_x)^2) + ((300-mean_y)^2) );
Percentage=(error*100)/(sqrt(1920^2+1080^2));