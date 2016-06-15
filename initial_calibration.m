%img=imread('test.jpg');
%new=cell(1,1)
%pics{1}=img
%cent=zeros([10 2]);
%%
a = arduino('com4' , 'uno' , 'Libraries' , 'Servo' );
sx = servo(a , 9, 'MinPulseDuration', 544*10^-6, 'MaxPulseDuration', 2400*10^-6); %default 544, 2400
sy = servo(a , 10, 'MinPulseDuration', 544*10^-6, 'MaxPulseDuration', 2400*10^-6); %default 544, 2400
fprintf('arduino and servo\n');
%%
writePosition(sx,17.0/180.0);
writePosition(sy,98.0/180.0);
%%
cam = webcam('USB Video Device');
cam.Resolution='320x240';
%%
preview(cam);
%%
time = clock;
img = snapshot(cam);
imshow(img)
%%
img = im2bw(img,0.13);
imshow(img)
%%
[t,radii] = imfindcircles(img,[10 18], ...
    'ObjectPolarity','dark','Sensitivity',0.80,'EdgeThreshold',0.3);
imshow(img);
clock - time
viscircles(t,radii,'EdgeColor' , 'b' );
%imshow(img);
%centers
