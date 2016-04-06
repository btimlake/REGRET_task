% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

Screen('Preference', 'SkipSyncTests', 2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% We will set the rotations angles to increase by 1 degree on every frame
degPerFrame = 10;

% We position the squares in the middle of the screen in Y, spaced equally
% scross the screen in X
% posXs = [screenXpixels * 0.25 screenXpixels * 0.5 screenXpixels * 0.75];
% posYs = ones(1, numRects) .* (screenYpixels / 2);

arrow=imread(fullfile('arrow.png')); %load image of arrow
texArrow = Screen('MakeTexture', window, arrow); % Draw arrow to the offscreen window
prop66=imread(fullfile('propCircle.png')); %load image of arrow
texProb66 = Screen('MakeTexture', window, prop66); % Draw arrow to the offscreen window


% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

% Animation loop
    
    lotteryOutcome = 0.33;      %%!! this is the outcome of the lottery's probability roll, a number between 0 and 1
    time.start = GetSecs;
    ang=0;
    
    while(ang < (4*360 + 360*lotteryOutcome)) %% 4*360 means the arrow will spin 4 full rounds before stopping at the outcome
        ang=ang+degPerFrame;
        Screen('DrawTexture', window, texProb66, [0 0 550 550], [xCenter-650/2 yCenter-650/2 xCenter+650/2 yCenter+650/2]); %%!! Location should not be hard coded
        Screen('DrawTexture', window, texArrow, [0 0 96 960], [xCenter-24 yCenter-240 xCenter+48 yCenter+240],ang);
        vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end
    WaitSecs(2); 


% Clear the screen
sca;