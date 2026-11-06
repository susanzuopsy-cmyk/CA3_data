function S = repro_style()
%REPRO_STYLE  Colours and sizes of the printed figures.
% Lengths are in points, as on the authors' figure pages, where text is 14-16 pt on a page about 1,230 pt wide.
% Everything is drawn at S.k of that size so that each figure window fits a 1440 x 810 pixel screen: MATLAB saves
% only the part of a figure that fits on the screen. Saved files can be enlarged freely.

S.k     = 0.55;
S.font  = 'Arial';
S.axcol = [0.149 0.149 0.149];

% sessions
S.cTrain = [0.121 0.234 1.000];
S.cTest  = [1.000 0.012 0.000];

% treatments: control, left CA3 inhibition, right CA3 inhibition
S.cTreat     = [0.502 0.502 0.502; 0.289 0.625 1.000; 0.891 0.205 0.185];
S.cTreatDark = [0.326 0.326 0.326; 0.090 0.320 0.752; 0.511 0.118 0.090];

% box panels with paired lines (Fig 1, Fig 6)
A.axLW = 0.5;  A.box = 'on';   A.xlim = [0.5 2.5];
A.tickFS = 14; A.titleFS = 16; A.ylabFS = 14;
A.boxW = 0.3;  A.capW = 0.15;  A.boxCol = S.cTrain;
A.boxLW = 0.5; A.medLW = 2.0;  A.whLW = 0.5; A.capLW = 0.5; A.whStyle = '--';
A.ptD = 7.07;  A.ptAlpha = 0.30;
A.pairLines = true;
A.sigFS = 16;  A.nsFS = 14;    A.sigDY = 1.49; A.nsDY = 4.4;
A.sigX = [1 2]; A.sigLW = 2.0; A.sigCol = S.axcol;
S.boxPaired = A;

% box panels with a difference inset (Fig 2, Fig S7)
B = A;
B.box = 'off'; B.xlim = [0.36331 2.91008];
B.boxW = 0.38202; B.capW = 0.19101; B.capLW = 1.0;
B.ptD = 2.83;  B.jitSD = 0.13;
B.pairLines = false;
B.sigDY = 0.27; B.sigX = [0.986 2.0145];
B.barDown = 25;                       % bar this far below the axes top, or 3 pt above the highest point
B.axW = 232.8; B.axH = 219.6;
B.inW = 106.58; B.inH = 162.75;       % inset, and its origin relative to the main axes origin
B.inDX = 211.2; B.inDY = 38.7;
B.inLW = 1.2;  B.inTickFS = 9;
B.inXLim = [0.5 1.5]; B.inJit = 0.116;
B.inPtD = 2.80; B.inPtAlpha = 0.349;
B.inMeanHalf = 0.24; B.inMeanLW = 2.0;
B.inZeroCol = [0.502 0.502 0.502 0.702]; B.inZeroLW = 1.2;
B.titleDX = 158.9;                    % title centred over the main axes and the inset
S.boxInset = B;

% Fig 2J-K pies
P.cUp = [0.251 0.455 0.722]; P.cDown = [0.957 0.800 0.251];
P.d = 116; P.pitch = 180; P.titleFS = 16; P.headFS = 16; P.pctFS = 16; P.legFS = 14; P.legPatch = [29 9.5];
S.pie = P;
end
