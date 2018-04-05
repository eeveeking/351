function ste = STE(signal, winLen)
ste = sum(buffer(signal.^2, winLen));
end