function [FFTmag, FFTf] = multiFFT(Sigs, Fs, opts)
  % Performs FFTs on multiple equal-length signals 'Sigs'.
  % Useful when paired with the subsigs function. For example,
  % the output of subsigs can be used as 'Sigs' in multiFFT.
  %
  % The output will always be a single-sided FFT.
  %
  %  Inputs:
  %    Sigs - Matrix of time series data. Each row is an
  %			     independent signal for the FFT.
  %    Fs - The sample rate of the time series data
  %    MinFreq (optional) - Trim out all frequencies below
  %                         this value. This shortens the
  %                         length of the output.
  %                         Default: -inf
  %    MaxFreq (optional) - Trim out all frequencies above
  %                         this value. This shortens the
  %                         length of the output.
  %                         Default: inf
  %    Type (optional) - The type of FFT to output. Can be
  %                      "Mag" (magnitude spectrum), "PSD"
  %                      (power spectrum density), or "%PDS"
  %                      (percent PSD relative to total power).
  %                      Default: "Mag"

  % TODO: Clean up comment block and arguments.

  arguments
    Sigs
    Fs
    opts.MinFreq = -inf
    opts.MaxFreq = inf
    opts.Type (1,1) string {mustBeMember(opts.Type, ["%PSD","PSD","Mag"])} = "Mag"
  end

  L = size(Sigs, 2);

  % Determine frequencies of interest
  f = Fs * (0:(L/2))/L; % FFT frequency array
  GoodFreqs = (f >= opts.MinFreq) & (f <= opts.MaxFreq); % FFT frequencies of interest
  FFTf = f(GoodFreqs); % Trim

  Y = fft(Sigs, L, 2); % Compute FFT of each row
  
  switch opts.Type
    case {"%PSD", "PSD"}
      P2 = (1/(Fs*L)) .* abs(Y).^2;
    case "Mag"
      P2 = abs(Y/L); % Normalize
  end
  
  P1 = P2(:, 1:L/2+1); % Get single side
  P1(:, 2:end-1) = 2*P1(:, 2:end-1); % double the single-sided spec (but not DC)
  
  % Trim to only consider frequencies of interest
  FFTmag = P1(:, GoodFreqs);
  
  % If percentage of PSD,
  if opts.Type == "%PSD"
    FFTmag = FFTmag ./ sum(FFTmag, 2);
  end
end
