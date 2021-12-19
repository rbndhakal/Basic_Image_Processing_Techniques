%Folder = 'E:\TTU Documents\Academic Documents\Image Processing Fall 2019\ImageSet1\ImageSet1';
%Put all the image in the folder containing the code
Folder = input('Enter image dataset location.\n', 's');
filetype = fullfile(Folder, '*.jpg');
Files = dir(filetype);
for k = 1:length(Files)
  FileName = Files(k).name;
  fullFileName = fullfile(Folder, FileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  imageArray = imread(fullFileName);
    I=imageArray;
    Im=rgb2hsv(I);
    H=Im(:,:,1);
    S=Im(:,:,2);
    V=Im(:,:,3);
    totalH=0;
    totalS=0
    for i=1:size(H,1)
        for j=1:size(H,2)
            totalH=totalH + H(i,j);
            totalS=totalS+ S(i,j);
        end
    end
    if totalH/(size(H,1) * size(H,2)) < 0.02 && totalS/(size(S,1) * size(S,2)) < 0.02
        %imwrite(I , sprintf('Night%d.jpg', k-1))
        figure(); imshow(I); title('night');
    else
        %imwrite(I, sprintf('Day%d.jpg',k-1))
        figure(); imshow(I); title('day');
    end
end

            
            
    
