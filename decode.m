delimiter = '%';

clc
im1 = imread('stego.png');

% figure(1), imshow(im1); title('Original Image');
[l,w,b] = size(im1);

cover_size = l*w*b;

message = '';

char_stream = '';

i = 1; j = 1; k=1;

while (true)
   if (k > 3)
        k = 1;
        j = j + 1;
    end
    if (j > w)
       i = i + 1;
       j = 1;
    end
    
    if (i > l)
        break;
    end
    
    temp_pixel = dec2bin(im1(i, j, k), 8);
    LSB = temp_pixel(8);
    char_stream = strcat(char_stream, num2str(LSB));
    
    if length(char_stream) == 8
        new_char = char(bin2dec(char_stream));
        message = horzcat(message, new_char);
        if (new_char == delimiter)
            break;
        end
        char_stream = '';
    end
    
    k = k + 1;
end

secret_file = fopen('secret.txt','wb');
fwrite(secret_file, message);
fclose(secret_file);


disp(message);