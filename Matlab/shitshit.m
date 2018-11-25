close all;
ORIGINAL=imread('dice10.jpg');
figure; imshow(ORIGINAL); title('Original');
B = rgb2gray(ORIGINAL);
bw = im2bw(B);
figure;
imshow(bw)
bw = imcomplement(bw);
bw2 = imfill(bw, 'holes');
L = bwlabel(bw2);

bw2 = bwareaopen(bw2, 100);
for k=1:2
    CC = bwconncomp(bw2)
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);
    bw2(CC.PixelIdxList{idx}) = 0;
    
end

se = strel('disk', 4);
bw2 = imerode(bw2, se);
bw2 = bwareaopen(bw2, 100);
bw2 = imerode(bw2, se);
CC = bwconncomp(bw2);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
figure; imshow(bw2); title('asdasd');


stats = regionprops('table',bw2,'Centroid',...
    'MajorAxisLength','MinorAxisLength')
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;

[labeledImage, numberOfObject] = bwlabel(bw2);
hold on
viscircles(centers,radii);
hold off
[B,L, N, A] = bwboundaries(bw2,'noholes');
RGB = label2rgb(labeledImage);
figure
imshow(RGB);
figure;
imshow(ORIGINAL); 
hold on
colors=['b' 'g' 'r' 'c' 'm' 'y'];
for k=1:length(B),
  boundary = B{k};
  cidx = mod(k,length(colors))+1;
  plot(boundary(:,2), boundary(:,1),...
       colors(cidx),'LineWidth',2);

  %randomize text position for better visibility
  rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
  col = boundary(rndRow,2); row = boundary(rndRow,1);
  h = text(col+1, row-1, num2str(L(row,col)));
  set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
end
text(5,30,strcat('\color{red}Value of dices:',num2str(numberOfObject)))
