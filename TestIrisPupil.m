clc
clear all
close all
A=imread('img.jpg');
A=rgb2gray(A);
[centerspupil,centerfinal]=pupiliris(A);