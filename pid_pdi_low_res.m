a = arduino('com3' , 'uno' , 'Libraries' , 'Servo' );
sx = servo(a , 10, 'MinPulseDuration', 544*10^-6, 'MaxPulseDuration', 2400*10^-6); %default 544, 2400
sy = servo(a , 9, 'MinPulseDuration', 544*10^-6, 'MaxPulseDuration', 2400*10^-6); %default 544, 2400
cam = webcam('USB2.0 Camera');
cam.Resolution='320x240';
%%
writePosition(sx,65.0/180.0);
writePosition(sy,24.0/180.0);
fprintf('arduino and servo\n');
%%
iter=500;

ct_x=zeros([1 2]);
ct_y=zeros([1 2]);
ct_y=[155, 231];
ct_x=[295, 137];
ct=[163, 141];		
pics=cell(1,iter);
rgb=cell(1,iter);
centre_final=zeros([iter 2]);
i_cap = [ct_x(1,1)-ct(1,1) ct_x(1,2)-ct(1,2)];
i_cap = i_cap/norm(i_cap);
j_cap = [ct_y(1,1)-ct(1,1) ct_y(1,2)-ct(1,2)];
j_cap = j_cap/norm(j_cap);
fprintf('cam and variables\n');
%%
dx=0;
dy=0;
ix=0;
iy=0;
posx = zeros([iter,1]);
posy = zeros([iter,1]);
px = zeros([iter,1]);
py = zeros([iter,1]);

%%
preview(cam)

%%
kix = 0; kiy = 0;
ix = 0; iy = 0;
dx=0;
dy=0;
for i = 1.0:1.0:iter
%preview(cam);

img = snapshot(cam);
%rgb{i}=img;
img = im2bw(img,0.23);
pics{i}=img;
%imshow(img);
[centers,radii] = imfindcircles(pics{i},[10 25], ...
  'ObjectPolarity','dark','Sensitivity',0.80,'EdgeThreshold',0.3);
%screening function
 
centre_final(i,1)=centers(1,1);
centre_final(i,2)=centers(1,2);
%elapsed = etime(clock, iTime); 

%py(i) = (centre_final(i,1)-ct(1,1))*(ct_y(1,1)-ct(1,1))+(centre_final(i,2)-ct(1,2))*(ct_y(1,2)-ct(1,2));
py(i) = sum([centre_final(i,1)-ct(1,1) , centre_final(i,2) - ct(1,2) ].*j_cap);

if i~=1
ds = [centre_final(i,1)-centre_final(i-1,1) centre_final(i,2)-centre_final(i-1,2)];
dx = sum(ds.*i_cap);
dy = sum(ds.*j_cap);

end


%px(i) = (centre_final(i,1)-ct(1,1))*(ct_x(1,1)-ct(1,1))+(centre_final(i,2)-ct(1,2))*(ct_x(1,2)-ct(1,2));
px(i) = sum([centre_final(i,1)-ct(1,1) , centre_final(i,2)-ct(1,2)].*i_cap);
kdx = -0.0000025*246.0973*2;
kdy = 0.0000025*147.8311*2;
kpx= -0.0000009*246.0973*2;
kpy= 0.00000119*147.8311*2;
%kdx = 0; kdy = 0;
%kix= -0.00000005;
%kiy=  0.00000010;
kix= -0.0000009*246.0973*2/50;
kiy= 0.00000119*147.8311*2/50;
if(i~=1)
    if(px(i)*px(i-1)<0 && i~=1)
        ix = 0;
    end
end
    
if(i~=1)
    if(py(i)*py(i-1)<0 && i~=1)
        iy = 0;
    end
end

ix=ix+px(i);
iy=iy+py(i);
posx(i) = 65/180 + kpx*px(i) + kdx*dx + kix*ix  ; 
posy(i) = 25/180 + kpy*py(i) + kdy*dy  + kiy*iy ;
writePosition(sx,posx(i));
writePosition(sy,posy(i));


%posy

end
%%
writePosition(sx,65.0/180.0);
writePosition(sy,24.0/180.0);
fprintf('arduino and servo\n');
fprintf('DONE');