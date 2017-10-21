clc
im1 = imread('image.png');

message = fileread('message.txt');

message_binary = reshape(dec2bin(message, 8)', 1, []);

message_size = length(message_binary);

[l,w,b] = size(im1);

cover_size = l*w*b;

if (message_size > cover_size)
    disp('Message too large for image.');
end

im2 = im1;

i = 1; j = 1; k=1;

for a = 1 : length(message_binary)
    if (k > 3)
        k = 1;
        j = j + 1;
    end
    if (j > w)
       i = i + 1;
       j = 1;
    end
    

    temp_pixel = dec2bin(im1(i, j, k), 8);
    LSB = temp_pixel(8);
    SM = message_binary(a);
    
    if (LSB ~= SM)
        if (LSB == '1')
            im2(i, j, k) = im1(i, j, k) - 1;
        else
            im2(i, j, k) = im1(i, j, k) + 1;
        end
    end
    
    k = k + 1;
end

imwrite(im2, 'stego.png');

figure;
subplot(1,2,1), imshow(im1), title('Original Image');
subplot(1,2,2), imshow(im2), title('Secret Image');
