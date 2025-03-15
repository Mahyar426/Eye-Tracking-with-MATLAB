clc
clear all
close all
ImUR=imread('UpRight3.png');
ImUL=imread('UpLeft3.png'); 
ImDL=imread('DownLeft3.png');
ImDR=imread('DownRight3.png');
Desired=imread('Desired3.png');
Board=imread('untitled.png');
[radiifinalUR,centerfinalUR,X,Y,Width,Height] = irisfinder1(ImUR);
figure;
[radiifinalUL,centerfinalUL] = irisfinder2(ImUL,X,Y,Width,Height);
figure;
[radiifinalDR,centerfinalDR] = irisfinder2(ImDR,X,Y,Width,Height);
figure;
[radiifinalDL,centerfinalDL] = irisfinder2(ImDL,X,Y,Width,Height);
figure;
[radiifinalDesired,centerfinalDesired] = irisfinder2(Desired,X,Y,Width,Height);
figure;
%imshow(Board);
%%
avg_X_Left   = ( centerfinalUL(1,1)+ centerfinalDL(1,1) ) / 2;
avg_X_Right  = ( centerfinalUR(1,1)+ centerfinalDR(1,1) ) / 2;
avg_Y_Up     = ( centerfinalUL(1,2)+ centerfinalUR(1,2) ) / 2;
avg_Y_Down   = ( centerfinalDR(1,2)+ centerfinalDL(1,2) ) / 2;
%%
Dist_RtoL_Pixels  = 1720;
Dist_UtoD_Pixels  = 880;
Dist_RtoL_Eyes(1,1)    = avg_X_Right - avg_X_Left ;
Dist_UtoD_Eyes(1,1)    = avg_Y_Down  - avg_Y_Up ;
Dist_DesireToLeft(1,1) = centerfinalDesired(1,1) - avg_X_Left;
Dist_DesireToUp(1,1)   = centerfinalDesired(1,2) - avg_Y_Up;
%----------------------------------------------------------
Desired_Pixel_X=zeros(1,17);
Desired_Pixel_Y=zeros(1,17);
Desired_Pixel_X(1,1)   = 100 + (Dist_RtoL_Pixels*Dist_DesireToLeft(1,1))/ Dist_RtoL_Eyes(1,1);
Desired_Pixel_Y(1,1)   = 100 + (Dist_UtoD_Pixels*Dist_DesireToUp(1,1))  / Dist_UtoD_Eyes(1,1);
%----------------------------------------------------------
Dist_RtoL_Pixels  = 1720;
Dist_UtoD_Pixels  = 880;
XLeft=[centerfinalDL(1,1),centerfinalUL(1,1)];
XRight=[centerfinalDR(1,1),centerfinalUR(1,1)];
YUp=[centerfinalUR(1,2),centerfinalUL(1,2)];
YDown=[centerfinalDL(1,2),centerfinalDR(1,2)];
Index=2;

for XL=1:2
    for XR=1:2
        for YU=1:2
            for YD=1:2
                Dist_RtoL_Eyes   (1,Index)    =  XRight(1,XR)  - XLeft(1,XL) ;
                Dist_UtoD_Eyes   (1,Index)    =  YDown (1,YD)  - YUp (1,YU) ;
                Dist_DesireToLeft(1,Index)    =  centerfinalDesired(1,1) - XLeft(1,XL);
                Dist_DesireToUp  (1,Index)    =  centerfinalDesired(1,2) - YUp(1,YU);
%----------------------------------------------------------
                Desired_Pixel_X(1,Index)   =  100 + (Dist_RtoL_Pixels*Dist_DesireToLeft(1,Index))/ Dist_RtoL_Eyes(1,Index);
                Desired_Pixel_Y(1,Index)   =  100 + (Dist_UtoD_Pixels*Dist_DesireToUp(1,Index))  / Dist_UtoD_Eyes(1,Index);
                Index=Index+1;
            end
        end
    end
end
Combined(1,:) = Desired_Pixel_X(1,:);
Combined(2,:) = Desired_Pixel_Y(1,:);
mean_x = mean(mean(Desired_Pixel_X));
mean_y = mean(mean(Desired_Pixel_Y));
Marked = insertMarker(Board,[mean_x mean_y;400 300],'circle','color',{'blue','black'},'size',25);
imshow(Marked);
