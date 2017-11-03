delimiter = '%';

clc
im1 = imread('stego.png');

% figure(1), imshow(im1); title('Original Image');
[l,w,b] = size(im1);

cover_size = l*w*b;

message = '';

char_stream = '';

bool_im = zeros(l,w,b);

password = 'CE-712';
% s is the sum of the password in ASCII.
s = 0;
% i iterates over all natural numbers.
t = 1;

for a = 1 : length(password)
    s = s + password(a);
end

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
        LSB = int2str(xor(str2double(temp_pixel(7)), str2double(temp_pixel(8))));

        char_stream = strcat(char_stream, num2str(LSB));

        if length(char_stream) == 8
            new_char = char(bin2dec(char_stream));
            message = horzcat(message, new_char);
            if (new_char == delimiter)
                break;
            end
            char_stream = '';
        end

        bool_im(i,j,k) = 1;
    end

    t = t + 1;
end

secret_file = fopen('secret.txt','wb');
fwrite(secret_file, message);
fclose(secret_file);


disp(message);