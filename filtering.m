function y=filtering(x,low_f,high_f,fs,flag)

% $This algorithm was a band-pass filter for the processed signal x.
%
% $inputs:
%   x: the signal, column vector.
%   low_f: the low cut frequency of the band-pass filter.
%   high_f: the high cut frequency of the band-pass filter.
%   fs: sample frequency
%   flag: if perform the band-pass filtering, flag=1 yes, flag=0 no.
% $output:
%   y: the filtered signal.
%
% $Author:  Chengyu Liu; bestlcy@sdu.edu.cn
%           School of Control Science and Engineering,
%           Shandong University
% $Date:    2015.06.13
% $Last update:    2015.06.13
x = x';
if flag>0
    n = 4;
    Wn = high_f/fs/2;
    [b, a] = butter(n, Wn);
    x1 = filtfilt(b, a, x);
    Wn = low_f/fs/2;
    [d, c] = butter(n, Wn, 'high');
    y = filtfilt(d, c, x1);
else
    y=x;
end