function [centerspupil,centerfinal]=pupiliris(A)
%% Defining Radii and Sensitivity
Min_Radii=10;          % this is for Mahyar Pictures
Max_Radii=60;          % this is for Mahyar Pictures
%Min_Radii=90;         % this is for CASIA Pictures
%Max_Radii=160;        % this is for CASIA Pictures
%Sensitivity=0.96;      % this is for Mahyar Pictures
Sensitivity=0.98;     % this is for CASIA Pictures
SensitivityPupil=0.85; % this is for CASIA Pictures
%Min_Radii_Pupil=30;    % this is for CASIA Pictures
%Max_Radii_Pupil=50;    % this is for CASIA Pictures
Min_Radii_Pupil=round(Min_Radii/3);    % this is for CASIA Pictures
Max_Radii_Pupil=round(Max_Radii/3);    % this is for CASIA Pictures
%% Pupil Detection
%A=rgb2gray(A); % for rgb pictures
doubleA=double(A);
edgeA=edge(doubleA);
imshow(A);
[centerspupil, radiipupil, metricpupil] = imfindcircles(edgeA,[Min_Radii_Pupil Max_Radii_Pupil],'ObjectPolarity','dark','Sensitivity',SensitivityPupil);
%viscircles(centerspupil, radiipupil,'EdgeColor','r');
%% Iris Detection
B=A;
Laplacian=[1,1,1;1,-8,1;1,1,1];
filteredB=conv2(B,Laplacian,'same');
diffB=B-uint8(filteredB);
doubleB=double(diffB);
edgeB=edge(doubleB,'canny');
[centersirisdark, radiiirisdark, metricirisdark] = imfindcircles(edgeB,[Min_Radii Max_Radii],'ObjectPolarity','dark','Sensitivity',Sensitivity);
%[centersirisbright, radiiirisbright, metricirisbright] = imfindcircles(edgeB,[Min_Radii Max_Radii],'ObjectPolarity','bright','Sensitivity',Sensitivity);
centerfinal=[];
centersirisbright=[];
if( ( isempty(centersirisbright) ) == 0 )
    centeririsbrightstrong=centersirisbright(1,:);
    radiiirisbrightstrong=radiiirisbright(1,:);
    metricirisbrightstrong=metricirisbright(1,:);
    %viscircles(centeririsbrightstrong, radiiirisbrightstrong,'EdgeColor','b');
end
if( ( isempty(centersirisdark) ) == 0 )
    centersirisdarkstrong=centersirisdark(1,:);
    radiiirisdarkstrong=radiiirisdark(1,:);
    metricirisdarkstrong=metricirisdark(1,:);
    %viscircles(centersirisdarkstrong, radiiirisdarkstrong,'EdgeColor','g');
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