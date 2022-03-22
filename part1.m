clc;
Fs = 8000;
n = 0:319;
%sig = [A;B;C;D];
%sig = [A;B];
%audiowrite("char_A.wav",B,Fs);
%sound(A,Fs);

chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', ' '];
low = [400, 400,400, 400, 400, 400, 400, 400, 400, 600, 600, 600, 600, 600, 600, 600, 600, 600, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000];
middle = [800, 800, 800, 1200, 1200, 1200, 2000, 2000, 2000, 800, 800, 800, 1200, 1200, 1200, 2000, 2000, 2000, 800, 800, 800, 1200, 1200, 1200, 2000, 2000, 2000];
high = [1600, 2400, 4000, 1600, 2400, 4000, 1600, 2400, 4000, 1600, 2400, 4000, 1600,2400, 4000, 1600, 2400, 4000, 1600, 2400, 4000, 1600, 2400, 4000, 1600, 2400, 4000];
x = input('Enter a string: ', 's');
len = strlength(x);
% signal = 0;
signal = [];
for i = 1:len
    if isletter(x(i)) 
        if isstrprop(x(i), 'upper')
            case_frequency = 200;
        elseif isstrprop(x(i), 'lower')
            case_frequency = 100;
        else
            case_frequency = 3000;
        end
    end
    char = lower(x(i));
    for j = 1:27
        if char == chars(j)
            new = cos(2*pi*low(j)*n/Fs) + cos(2*pi*middle(j)*n/Fs) + cos(2*pi*high(j)*n/Fs) + cos(2*pi*case_frequency*n/Fs);
            signal = cat(2, signal, new);
            break
        end
    end
end
%signal = signal/max(abs(signal));
audiowrite("encodedsignal.wav",signal,Fs);
sound(signal,Fs);