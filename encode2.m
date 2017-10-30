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
bool_im = zeros(l,w,b);

password = 'CE-712';
% s is the sum of the password in ASCII.
s = 0;
% i iterates over all natural numbers.
t = 1;

for a = 1 : length(password)
    s = s + password(a);
end

for a = 1 : length(message_binary)
    while(true)
        x = mod(mod(s*t, cover_size) + t*t, cover_size);
        k  = ceil(x/(l*w));
        x = mod(x, l*w);
        j = ceil(x/l);
        i = mod(x, l);
        if i == 0
            i = l;
        end
        
        if (bool_im(i,j,k) == 0)
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
            
            bool_im(i,j,k) = 1;
            break;
        end
        t = t + 1;
    end
end

imwrite(im2, 'stego.png');

figure;
subplot(1,2,1), imshow(im1), title('Original Image');
subplot(1,2,2), imshow(im2), title('Secret Image');
