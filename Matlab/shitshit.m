close all;
A=imread('dice2.jpg');
figure; imshow(A);

%A = A - sqrt(power(A - mean(A),2));
%figure; imshow(A);
B = rgb2gray(A);
figure; imshow(B);
A = adapthisteq(B);
figure; imshow(A);
bw = im2bw(B, 0.3);
imshow(bw)
bw = imcomplement(bw);
bw2 = imfill(bw, 'holes');
figure; imshow(bw2); title('asd');

B = edge(bw2, 'Canny');
se = strel('disk',4);
B=imdilate(B,se);
se = strel('disk',3);
B=imerode(B, se);
B = bwareaopen(B, 50);
L = bwlabel(B);
figure; imshow(B);
figure; imshow(L == 1)
title('Object 1')


%B = im2bw(B, graythresh(B));
%figure; imshow(B);
%text(5,30,strcat('\color{red}Sum of dots:',num2str(length(B))))

%LB = 20;
%UB = 50;
%Iout = xor(bwareaopen(bw,LB),  bwareaopen(bw,UB));
%figure, imshow(Iout); title('Iout ');


%figure; imshow(B);

%se = strel('disk',3);
%vizszintes=imdilate(Iout,se);

%vizszintes=imerode(vizszintes,se);
%vizszintes=imerode(vizszintes,se);
%vizszintes=imclose(vizszintes,se);

%vizszintes = bwareaopen(vizszintes, 100);
%figure, imshow(vizszintes);title('Motherfuck ');
%B = bwboundaries(vizszintes);
%figure, imshow(vizszintes); title('Number of dots on the upper surface  ');

%text(5,30,strcat('\color{red}Sum of dots:',num2str(length(B) - 2)))

