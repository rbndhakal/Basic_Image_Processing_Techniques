Proj2Image = 'Proj2.tif';
[img,map] = imread(Proj2Image);
figure
imshow(img,map);
title('Original Image');
% Store the original image as an array.
img = img(:,:,1);
% Perform the Fast Fourier Transform (FFT) on the Image
imgfft = fft2(img);
% Next, I create a Butterworth Low-Pass Filter.
% Note: c is a constant
%       X is the size of the dimension of array X
%       Y is the size of the dimension of array Y
c = 2;
X = size(imgfft, 1);
Y = size(imgfft, 2);
% A returns an array of ones in X and Y.
A = ones(X,Y);
% 7 unique pixels are used in each array.
XX = [204 182 191 196 214 219 228];
YY = [273 275 267 282 264 279 271];
% L = Max Number of Pixels = 255
L = 255;
for i=1:length(L)
   for x = 1:X
      for y = 1:Y
      %Compute the distance between the points.
      Lxy = sqrt((x-XX(i))^2 + (y-YY(i))^2);
      A(x,y) = A(x,y) + 1/(1+(Lxy/L(i)^2))^(2*c);
      end
   end;
end;
% Next, I apply the Butterworth filter by shifting
% the FFT of the image, and multiplying it by A.
FilterImage = fftshift(imgfft).*A;
figure
imshow(abs(FilterImage),[]);
title('Image After Shifting by FFT and Multiplying By A');
% Here, I shift back and perform the Inverse FFT
FilterImage2 = ifft2(fftshift(FilterImage));
figure
imshow(abs(FilterImage2),[]);
title('Shifting Back and Performing Inverse FFT');
% Then I resize and display the 'Proj2_Output.tif' image
% And compare it to the output Image named 'FilterImage2'.
[img,map] = imread('Proj2_Output.tif');
figure('Name','Periodic Pattern Comparison');
subplot(1,2,1), imshow(abs(FilterImage2),[]);
title('Periodic Pattern of Image');
subplot(1,2,2), imshow(img,map);
title('periodicpattern.tif');