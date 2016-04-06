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
% screenNumber = max(screens);
screenNumber = 0;

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

%% Set position info
wheelRadius = (screenXpixels*.13);

% Set positions of graphical elements
leftWheelpos = [screenXpixels*.25-wheelRadius screenYpixels*.5-wheelRadius screenXpixels*.25+wheelRadius screenYpixels*.5+wheelRadius];
rightWheelpos = [screenXpixels*.75-wheelRadius screenYpixels*.5-wheelRadius screenXpixels*.75+wheelRadius screenYpixels*.5+wheelRadius];
leftArrowpos = [screenXpixels*.25-wheelRadius*.25 screenYpixels*.5-wheelRadius*.75 screenXpixels*.25+wheelRadius*.25 screenYpixels*.5+wheelRadius*.75];
rightArrowpos = [screenXpixels*.75-wheelRadius*.25 screenYpixels*.5-wheelRadius*.75 screenXpixels*.75+wheelRadius*.25 screenYpixels*.5+wheelRadius*.75];

% temporary; will be modified to make these vary depending on choice
locChoice = leftWheelpos;  
locNonChoice = rightWheelpos; 
arrowChoice = leftArrowpos;
arrowNonChoice = rightArrowpos;

% Set some variables
NUMROUNDS = 3;
lotteryOutcome = 0 + (1-0).*rand(NUMROUNDS,2); % Creates array of random outcome probabilities for both wheels in each round

%% back to original
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
for i=1:NUMROUNDS
    
%     lotteryOutcome = 0.33;      %%!! this is the outcome of the lottery's probability roll, a number between 0 and 1
    time.start = GetSecs;
    angChoice=0;
    angNonChoice=0;
%  && angNonChoice < (4*360 + 360*lotteryOutcome(i,2))
    while( (angChoice < (4*360 + 360*lotteryOutcome(i,1))) || (angNonChoice < (4*360 + 360*lotteryOutcome(i,2))) ) %% 4*360 means the arrow will spin 4 full rounds before stopping at the outcome
        angChoice=angChoice+degPerFrame;
        angNonChoice=angNonChoice+degPerFrame;
        % choice wheel & arrow
        Screen('DrawTexture', window, texProb66, [0 0 550 550], locChoice); %%!! Location should not be hard coded
        Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowChoice,angChoice);
        % non-choice wheel & arrow        
        Screen('DrawTexture', window, texProb66, [0 0 550 550], locNonChoice); %%!! Location should not be hard coded
        Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowNonChoice,angNonChoice);
        vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end
    
%     while(angNonChoice < (4*360 + 360*lotteryOutcome(i,2))) %% 4*360 means the arrow will spin 4 full rounds before stopping at the outcome
%         angNonChoice=angNonChoice+degPerFrame;
%         % non-choice wheel & arrow        
%         Screen('DrawTexture', window, texProb66, [0 0 550 550], locNonChoice); %%!! Location should not be hard coded
%         Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowNonChoice,angNonChoice);
%     end
%         vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    WaitSecs(2); 

end

% Clear the screen
sca;