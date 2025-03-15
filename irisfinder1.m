function [radiifinal,centerfinal,X,Y,Width,Height] = irisfinder1(Im)
%% Defining a Rectangle which Yields the Eye(Left Eye is the Default)
[X,Y,Width,Height] = Sep(Im);
A=imcrop(Im,[X,Y,Width,Height]);
A=rgb2gray(A);
imshow(A);
 Min_Radii=10;      % this is for Mahyar Pictures
 Max_Radii=60;      % this is for Mahyar Pictures
%Min_Radii=90;     % this is for CASIA Pictures 
%Max_Radii=160;    % this is for CASIA Pictures
Sensitivity=0.96;  % this is for Mahyar Pictures
%Sensitivity=0.98; % this is for CASIA Pictures
%% Iris Recognition
B=A;
Laplacian=[1,1,1;1,-8,1;1,1,1];
filteredB=conv2(B,Laplacian,'same');
diffB=B-uint8(filteredB);
doubleB=double(diffB);
edgeB=edge(doubleB,'canny');
[centersirisdark, radiiirisdark, metricirisdark] = imfindcircles(edgeB,[Min_Radii Max_Radii],'ObjectPolarity','dark','Sensitivity',Sensitivity);
centerfinal=[];
centersirisbright=[];
if( ( isempty(centersirisbright) ) == 0 )
    centeririsbrightstrong=centersirisbright(1,:);
    radiiirisbrightstrong=radiiirisbright(1,:);
    metricirisbrightstrong=metricirisbright(1,:);
end
if( ( isempty(centersirisdark) ) == 0 )
    centersirisdarkstrong=centersirisdark(1,:);
    radiiirisdarkstrong=radiiirisdark(1,:);
    metricirisdarkstrong=metricirisdark(1,:);
end
if ( ( isempty(centersirisdark) ) == 0 && (( isempty(centersirisbright) ) == 1)  )
    centerfinal=centersirisdarkstrong;
    radiifinal=radiiirisdarkstrong;
    metricfinal=metricirisdarkstrong;
end
if ( ( isempty(centersirisdark) ) == 1 && (( isempty(centersirisbright) ) == 0)  )
    centerfinal=centeririsbrightstrong;
    radiifinal=radiiirisbrightstrong;
    metricfinal=metricirisbrightstrong;
end
if ( ( isempty(centersirisdark) ) == 0 && (( isempty(centersirisbright) ) == 0)  )
    if(metricirisbrightstrong>metricirisdarkstrong)
        centerfinal=centeririsbrightstrong;
        radiifinal=radiiirisbrightstrong;
        metricfinal=metricirisbrightstrong;
    end
    if(metricirisbrightstrong < metricirisdarkstrong)
        centerfinal=centersirisdarkstrong;
        radiifinal=radiiirisdarkstrong;
        metricfinal=metricirisdarkstrong;
    end
end
if ( ( isempty(centersirisdark) ) == 1 && (( isempty(centersirisbright) ) == 1)  )
    disp('No Iris is detected! Please Change Parameters or Input a better image!');
end
if( ( isempty(centerfinal) ) == 0 )
    viscircles(centerfinal, radiifinal,'EdgeColor','k');
end