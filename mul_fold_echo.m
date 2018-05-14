function outputSignal = mul_fold_echo(inputSignal)
    outputSignal = inputSignal;
    n = length(inputSignal);
    
    for i=1:n
        if i > 3200
            outputSignal(i) = inputSignal(i) + 0.8 * outputSignal(i - 3200);
        else
            outputSignal(i) = outputSignal(i);
        end
    end
end