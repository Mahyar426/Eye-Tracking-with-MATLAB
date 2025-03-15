clc
clear all
close all
img=imread('img.jpg');
[X,Y,Width,Height] = Sep(img);
cropped=imcrop(img,[X,Y,Width,Height]);
cropped=rgb2gray(cropped);
[centerspupil,centerfinal]=pupiliris(cropped);
