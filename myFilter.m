function [outputSignal, outputFilter] = myFilter(inputSignal, fsample, N, windowName, filterName, fcutoff)
%%% Input 
% inputSignal: input signal
% fsample: sampling frequency
% N : size of FIR filter(odd)
% windowName: 'Blackmann'
% filterName: 'low-pass', 'high-pass', 'bandpass', 'bandstop' 
% fcutoff: cut-off frequency or band frequencies
%       if type is 'low-pass' or 'high-pass', para has only one element         
%       if type is 'bandpass' or 'bandstop', para is a vector of 2 elements

%%% Ouput
% outputSignal: output (filtered) signal
% outputFilter: output filter 

%% 1. Normalization
fcutoff(1) = fcutoff(1) / fsample;
fcutoff(2) = fcutoff(2) / fsample;
middle = floor(N / 2);


%% 2. Create the filter according the ideal equations (slide #76)
% (Hint) Do the initialization for the outputFilter here
if strcmp(filterName,'low-pass') == 1
    for n=-middle:middle
        if n == 0
            h(middle + 1) = 2 * fcutoff(1);
        else
            h(n + middle + 1) = sin(2 * pi * fcutoff(1) * n) / pi / n;
        end
    end
end

if strcmp(filterName, 'bandpass') == 1
    for n=-middle:middle
        if n == 0
            h(middle + 1) = 2 * (fcutoff(2) - fcutoff(1));;
        else
            h(n + middle + 1) = (sin(2*pi*fcutoff(2)*n) - sin(2*pi*fcutoff(1)*n)) / pi / n;
        end 
    end
end

if strcmp(filterName, 'high-pass') == 1
    for n=-middle:middle
        if n == 0
            h(middle + 1) = 1 - 2 * fcutoff(1);;
        else
            h(n + middle + 1) = -1 * sin(2 * pi * fcutoff(1) * n) / pi / n;
        end
    end
end
    

%% 3. Create the windowing function (slide #79) and Get the realistic filter
if strcmp(windowName,'Blackman') == 1 
     for n=1:N
         h(n) = 0.42 + 0.5 * cos(2*pi*n/(N-1)) + 0.08 * cos(4*pi*n/(N-1));
         %h(n) = h(n) * (0.42 - 0.5 * cos(2*pi*(-middle+n)/(N+1)) + 0.08 * cos(4*pi*(-middle+n)/(N-1)));
     end
end

outputFilter = h;
%% 4. Filter the input signal in time domain. Do not use matlab function 'conv'
outputSignal = zeros( length(inputSignal) , 1);

for i=1:length(inputSignal) %1D-convolution
    for n=1:N
        if i - n > 0
            outputSignal(i) = outputSignal(i) + h(n) * inputSignal(i-n);
        end
    end
end
