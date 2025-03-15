function [X,Y,Width,Height] = Sep(Im)
I=Im(:,:,1);
faceDetect = vision.CascadeObjectDetector();
bbox=step(faceDetect,I);
[b1,~]=size(bbox);
bbox=bbox(b1,:);
face=imcrop(I,bbox);
eyeDetect = vision.CascadeObjectDetector('RightEye');
eyebox=step(eyeDetect,face);
n=size(eyebox,1);
e=[];
for it=1:n
    for j=1:n
        if (j > it)
          if ((abs(eyebox(j,2)-eyebox(it,2))<68)&& (abs(eyebox(j,1)-eyebox(it,1))>40))
            e(1,:)=eyebox(it,:);
            e(2,:)=eyebox(j,:);
            d=1;break;
          end
        end
    end
end
eyebox(1,:)=e(1,:);
eyebox(2,:)=e(2,:);
c=eyebox(1,3)/2;
d=eyebox(1,4)/2;
eyeCenter1x=eyebox(1,1)+c+bbox(1);
eyeCenter1y=eyebox(1,2)+d+bbox(2);
e=eyebox(2,3)/2;
f=eyebox(2,4)/2;
eyeCenter2x=eyebox(2,1)+e+bbox(1);
eyeCenter2y=eyebox(2,2)+f+bbox(2);
if(eyeCenter1x>eyeCenter2x)
    eyeCenterRightx=eyeCenter1x;
    eyeCenterLeftx=eyeCenter2x;
    eyeCenterRighty=eyeCenter1y;
    eyeCenterLefty=eyeCenter2y;
else
    eyeCenterRightx=eyeCenter2x;
    eyeCenterLeftx=eyeCenter1x;
    eyeCenterRighty=eyeCenter2y;
    eyeCenterLefty=eyeCenter1y;
end
Distance=abs(eyeCenterRightx-eyeCenterLeftx);
Width=Distance; 
Height=Width/2;
X=eyeCenterRightx-Width/2;
Y=eyeCenterRighty-Height/2;

