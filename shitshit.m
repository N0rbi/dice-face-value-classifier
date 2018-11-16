A=imread('dice4.jpg');
%figure; imshow(A);
B = rgb2gray(A);
%figure; imshow(B);
B = im2bw(B, graythresh(B));
figure; imshow(B);
B = imcomplement(B);
figure; imshow(B);

%eldetektalas = fspecial('average', [16 1]); 
%The second argument can be a vector specifying the number of rows and columns in h
%Probalgatas utan a [16 1] mukszik jol, idk why tho.

%A = imfilter(B, eldetektalas);
%figure, imshow(A);title('Szurt kép');

se = strel('disk',4);
vizszintes=imerode(B,se);

vizszintes=imerode(vizszintes,se);
vizszintes=imclose(vizszintes,se);

vizszintes = bwareaopen(vizszintes, 30);

B = bwboundaries(vizszintes);
figure, imshow(vizszintes);title('Number of dots on the upper surface  ');

text(5,30,strcat('\color{red}Sum of dots:',num2str(length(B) - 2)))

