%%
clc
clear all
close all
%%
%A=imread('cheshmman.jpg');
Im=imread('Bala Chap.jpg');
[X,Y,Width,Height] = Sep(Im);
A=imcrop(Im,[X,Y,Width,Height]);
A=rgb2gray(A);
doubleA=double(A);
edgeA=edge(doubleA);
imshow(A);
[centerspupil, radiipupil, metricpupil] = imfindcircles(edgeA,[30 50],'ObjectPolarity','dark','Sensitivity',0.92);
viscircles(centerspupil, radiipupil,'EdgeColor','r');
%%
B=A;
Laplacian=[1,1,1;1,-8,1;1,1,1];
filteredB=conv2(B,Laplacian,'same');
diffB=B-uint8(filteredB);
%figure;
%imshow(diffB);
doubleB=double(diffB);
edgeB=edge(doubleB,'canny');
%figure;
%imshow(B);
FHeight=floor(Height);
[centersirisdark, radiiirisdark, metricirisdark] = imfindcircles(edgeB,[60 FHeight],'ObjectPolarity','dark','Sensitivity',0.92);
%[centersirisbright, radiiirisbright, metricirisbright] = imfindcircles(edgeB,[6 40],'ObjectPolarity','bright','Sensitivity',0.85);
%centeririsbright2=centersirisbright(1,:);
%radiiirisbright2=radiiirisbright(1,:);
%metricirisbright2=metricirisbright(1,:);
centeririsdark2=centersirisdark(1,:);
radiiirisdark2=radiiirisdark(1,:);
metricirisdark2=metricirisdark(1,:);
%if( ( isempty(centersirisdark )) && ( isempty(centersirisbright )) )
%     if(radiiirisdark(1,1)>=radiiirisbright(1,1))
%           centersStrong = centersirisdark(1,:); 
%           radiiStrong= radiiirisdark(1);
%           metricStrong = metricirisdark(1);
%     end
%     if(radiiirisdark(1,1)<radiiirisbright(1,1))
%           centersStrong = centersirisbright(1,:); 
%           radiiStrong= radiiirisbright(1);
%           metricStrong = metricirisbright(1);
%     end
%end
 %viscircles(centeririsbright2, radiiirisbright2,'EdgeColor','b');
 viscircles(centeririsdark2, radiiirisdark2,'EdgeColor','k');
