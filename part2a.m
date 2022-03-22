clc;
Fs = 8000;
n = 0:319;
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

output_string = "";
for r = 1:length(signal)/320
    new_sig = signal((r-1)*320+1 : r*320);    
    new_sig = fft(new_sig, 128);
    new_sig = abs(new_sig(1:66));
    [peaks, index] = findpeaks(new_sig);
  
    maxx = zeros(1,4);
    for n = 1:4
        h = max(peaks);
        i = find(peaks == h);
        maxx(n) = index(i);
        peaks(i) = 0;
    end 
    maxx = sort(maxx);
    maxx = maxx*(4125/66);

    for k = 1:length(maxx)
        for t = 1:length(freq)
            if maxx(k) > freq(t) && maxx(k) <= (freq(t) + 100)
                maxx(k) = freq(t);
                break
            end
        end
        found = find(freq == maxx(k));
        ie = isempty(found);
        if ie == 1  %space character
            maxx(k) = 100;
        end
    end
    
    maxx = sort(maxx);
    
    if(maxx(2) == 800)
        temp = maxx(2);
        maxx(2) = maxx(3);
        maxx(3) = temp;
    end
    if(maxx(3) == 1600 && maxx(4) == 2000)
        temp = maxx(3);
        maxx(3) = maxx(4);
        maxx(4) = temp;
    end
    
    for k = 1:27
        if maxx(2) == low(k) && maxx(3) == middle(k) && maxx(4) == high(k)
            if(maxx(1) == 100)
                output_string = output_string + chars(k);
            elseif(maxx(1) == 200)
                output_string = output_string + upper(chars(k));
            end         
            break;
        end
    end
end
disp("-----------------------------------------------------------------------------------------------------------------------------")
disp("The decoded signal is: ")
disp(output_string)