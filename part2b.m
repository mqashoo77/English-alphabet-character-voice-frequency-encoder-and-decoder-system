clc;
Fs = 8000;
n = 0:319;
N = 320;
A = cos(2*pi*400*n/Fs) + cos(2*pi*800*n/Fs) + cos(2*pi*1600*n/Fs) + cos(2*pi*200*n/Fs);
chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', ' '];
low = [400, 400,400, 400, 400, 400, 400, 400, 400, 600, 600, 600, 600, 600, 600, 600, 600, 600, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000];
middle = [800, 800, 800, 1200, 1200, 1200, 2000, 2000, 2000, 800, 800, 800, 1200, 1200, 1200, 2000, 2000, 2000, 800, 800, 800, 1200, 1200, 1200, 2000, 2000, 2000];
high = [1600, 2400, 4000, 1600, 2400, 4000, 1600, 2400, 4000, 1600, 2400, 4000, 1600, 2400, 4000, 1600, 2400, 4000, 1600, 2400, 4000, 1600, 2400, 4000, 1600, 2400, 4000];
freq = [100, 200, 400, 600, 800, 1000, 1200, 1600, 2000, 2400, 4000];

flag = 0;
input_wave_file = input("Enter a .wav file: ", "s");
while flag == 0
    file_length = strlength(input_wave_file);
    if file_length < 4  % it's assumed that the file name is entered without the extension ".wav"
        input_wave_file = input_wave_file + ".wav";
    else
        wav = input_wave_file(file_length-3 : file_length);
        if strcmp(wav, ".wav") == 0  % fine whether the extension is entered or not
            input_wave_file = input_wave_file + ".wav";
        end
    end
    try
        [signal, F] = audioread(input_wave_file);
        flag = 1;
    catch
        input_wave_file = input("Enter a valid and existed .wav file: ", "s");
    end
end


f1 = fir1(N, [90 110]/(Fs/2), 'bandpass');
f2 = fir1(N, [190 210]/(Fs/2), 'bandpass');
f3 = fir1(N, [390 410]/(Fs/2), 'bandpass');
f4 = fir1(N, [590 610]/(Fs/2), 'bandpass');
f5 = fir1(N, [790 810]/(Fs/2), 'bandpass');
f6 = fir1(N, [990 1010]/(Fs/2), 'bandpass');
f7 = fir1(N, [1190 1210]/(Fs/2), 'bandpass');
f8 = fir1(N, [1590 1610]/(Fs/2), 'bandpass');
f9 = fir1(N, [1990 2010]/(Fs/2), 'bandpass');
f10 = fir1(N, [2390 2410]/(Fs/2), 'bandpass');
f11  = fir1(N, [3990 3999]/(Fs/2), 'bandpass');

x = zeros(1,11);
output_string = "";
for r = 1:length(signal)/320
    new_sig = signal((r-1)*320+1 : r*320);
    
    filtered1 = filter(f1, 1, new_sig);
    filtered2 = filter(f2, 1, new_sig);
    filtered3 = filter(f3, 1, new_sig);
    filtered4 = filter(f4, 1, new_sig);
    filtered5 = filter(f5, 1, new_sig);
    filtered6 = filter(f6, 1, new_sig);
    filtered7 = filter(f7, 1, new_sig);
    filtered8 = filter(f8, 1, new_sig);
    filtered9 = filter(f9, 1, new_sig);
    filtered10 = filter(f10, 1, new_sig);
    filtered11 = filter(f11, 1, new_sig);   
    
    x(1) = sum(filtered1).^2;
    x(2) = sum(filtered2).^2;
    x(3) = sum(filtered3).^2;
    x(4) = sum(filtered4).^2;
    x(5) = sum(filtered5).^2;
    x(6) = sum(filtered6).^2;
    x(7) = sum(filtered7).^2;
    x(8) = sum(filtered8).^2;
    x(9) = sum(filtered9).^2;
    x(10) = sum(filtered10).^2;
    x(11) = sum(filtered11).^2;
      
    maxx = zeros(1,4);
    for n = 1:4
        h = max(x);
        i = find(x == h);
        maxx(n) = i;
        x(i) = 0;
    end 
    maxx = sort(maxx);
    
    if maxx(4) == 0
        maxx = circshift(maxx, 1);
        maxx(1) = 1;
    end
    
    for i = 1:4
        maxx(i) = freq(maxx(i));
    end
    
    if maxx(2) == 800
        temp = maxx(2);
        maxx(2) = maxx(3);
        maxx(3) = temp;
    end
    if maxx(3) == 1600 && maxx(4) == 2000
        temp = maxx(3);
        maxx(3) = maxx(4);
        maxx(4) = temp;
    end
   
    for k = 1:27
        if maxx(2) == low(k) && maxx(3) == middle(k) && maxx(4) == high(k)
            if maxx(1) == 100
                output_string = output_string + chars(k);
            elseif maxx(1) == 200
                output_string = output_string + upper(chars(k));
            end
            break
        end
    end
end
disp("-----------------------------------------------------------------------------------------------------------------------------")
disp("The decoded signal is: ")
disp(output_string)