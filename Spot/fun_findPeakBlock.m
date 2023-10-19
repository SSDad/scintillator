function cent = fun_findPeakBlock(I, mB, nB)
[mI, nI] = size(I);
MM = mI-mB+1;
NN = nI-nB+1;
s = zeros(MM, NN);
for m = 1:MM
    for n = 1:NN
        K = I(m:m+mB-1, n:n+nB-1);
        s(m, n) = sum(K(:));
    end
end

[max_num, idx] = max(s(:));
[Y, X]=ind2sub(size(s), idx);
cent = [X+ceil(nB/2) Y+ceil(mB/2)];

%     J = ones(mB, nB)-rand(mB, nB)/1e6;
% 
%     c = normxcorr2(J, I);
%     [max_c, imax] = max(abs(c(:)));
%     [ypeak, xpeak] = ind2sub(size(c),imax(1));
%     offset = [(xpeak-size(J,2)) (ypeak-size(J,1))];

end