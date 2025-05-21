function OutSigs = subsig(LongSig, FrameStarts, NumFrames)
  % This function extracts equal-length segments of a time-series signal.
  %
  %  Inputs:
  %    LongSig - vector of the main signal to be segmented.
  %    FrameStarts - vector of starting indecies to extract sub-signals.
  %    NumFrames - scalar value indicating the length of the sub-signals.
  %                If NumFrames is negative, subsig will return sub-signals
  %                before the FrameStart index.
  %
  %  Outputs:
  %    OutSigs - NxM array were N is the length of FrameStarts and M is 
  %              NumFrames. Each row (N) is a sub-signal that is NumFrames
  %              long.
  %
  %  Example:
  %    sig = [10 20 30 40 50 60 70 80 90 100];
  %    startPoints = [2, 6];
  %    sigLength = 3;
  %    subSigs = sigproc.subsig(sig, startPoints, sigLength);
  %    
  %  'subSigs' will be [20, 30, 40; 60, 70, 80]
  
  arguments
    LongSig (1,:)
    FrameStarts (:,1) {mustBePositive}
    NumFrames (1,1) {mustBeNonzero}
  end
  
  if NumFrames < 0
    NumFrames = abs(NumFrames);
    FrameStarts = FrameStarts - NumFrames + 1;
  end
  
  % In the case where we need to get data from negative indecies
  % (say we are looking for 2000 points of data before a FrameStart
  % that began at frame 300 - we will be starting at index
  % -1700), we can pad the LongSig with leading zeros and shift
  % all FrameStarts by that same number of points. The extraction
  % of data is the same but negative indecies will be replaced by
  % zeros.
  LongSig = [zeros(1,NumFrames), LongSig, zeros(1,NumFrames)];
  FrameStarts = FrameStarts + NumFrames;
  
  SectionIdxs = arrayfun(@(x)(x:(x+NumFrames-1)), FrameStarts, 'UniformOutput', false);
  SectionIdxs = cell2mat(SectionIdxs);
  OutSigs = LongSig(SectionIdxs);
end
