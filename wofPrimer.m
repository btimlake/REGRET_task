% Function to run graphical wheels of fortune choice task
% Outcomes could include relief, satisfaction, regret and disappointment
% Ben Timberlake and Tobias Larsen, April 2016

Lottery choice task
function [player1Earnings] = wofPrimer(group)

% Load some variables
group = 

lotteryOutcome %determines arrow position

% Get the size of the on-screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', win);
% Get the center coordinates of the window
% [xCenter, yCenter] = RectCenter(screenRect);
% screenCenter = [xCenter, yCenter]; % center coordinates

wheelRadius = (screenXpixels*.35 - screenXpixels*.15) / 2;

% Set positions of graphical elements
leftWheelpos = [screenXpixels*.25-wheelRadius screenYpixels*.25-wheelRadius screenXpixels*.25+wheelRadius screenYpixels*.25+wheelRadius];
rightWheelpos = [screenXpixels*.75-wheelRadius screenYpixels*.25-wheelRadius screenXpixels*.75+wheelRadius screenYpixels*.25+wheelRadius];

numtopRect = length(topRectXpos); % Screen X positions of top five rectangles


uppRectXpos = [screenXpixels * 0.09 screenXpixels * 0.18 screenXpixels * 0.27 screenXpixels * 0.36];
numuppRect = length(uppRectXpos); % Screen X positions of upper four rectangles
lowRectXpos = [screenXpixels * 0.09 screenXpixels * 0.18 screenXpixels * 0.27 screenXpixels * 0.36 screenXpixels * 0.45 screenXpixels * 0.54 screenXpixels * 0.63 screenXpixels * 0.72 screenXpixels * 0.81 screenXpixels * 0.9];
numlowRect = length(lowRectXpos); % Screen X positions of lower ten rectangles
botRectXpos = [screenXpixels * 0.54 screenXpixels * 0.63 screenXpixels * 0.72 screenXpixels * 0.81 screenXpixels * 0.9];
numbotRect = length(botRectXpos); % Screen X positions of bottom five rectangles
topRectYpos = screenYpixels * 7/40; % Screen Y positions of top five rectangles (4/40)
uppRectYpos = screenYpixels * 16/40; % Screen Y positions of upper four rectangles (13/40)
sepLineYpos = screenYpixels * 39/80; % Screen Y position of separator line
lowRectYpos = screenYpixels * 27/40; % Screen Y positions of lower ten rectangles (24/40)
botRectYpos = screenYpixels * 34/40; % Screen Y positions of bottom five rectangles (31/40)

topTextYpos = round(screenYpixels * 2/40); % Screen Y positions of top text
textXpos = round(screenXpixels * 0.09 - screenXpixels * 2/56); % left position of text and separator line
botTextYpos = round(screenYpixels * 30/40); % Screen Y positions of bottom text 

uppTextYpos = screenYpixels * 11/40; % Screen Y positions of upper text
low1TextYpos = screenYpixels * 20/40; % Screen Y positions of lower text line 1
lowTextYpos = screenYpixels * 22/40; % Screen Y positions of lower text line2
lineEndXpos = round(screenXpixels * 0.91 + screenXpixels * 2/56); % right endpoint of separator line


%% Load up some variables
NUMROUNDS = 3;
lotteryOutcome = 0 + (1-0).*rand(NUMROUNDS,2); % Creates array of random outcome probabilities for both wheels in each round


%% Screen 1 - present wheels
% arrows should start out pointing to a spot between the two probabilities
% which probabilities?
% which amounts?

%% Screen 2 - player choice


%% Screen 3-partial - arrow spin

% non-choice blank
locChoice = leftWheelpos
[xCenter-650/2 yCenter-650/2 xCenter+650/2 yCenter+650/2]
[screenXpixels*.25-wheelRadius screenYpixels*.25-wheelRadius screenXpixels*.25+wheelRadius screenYpixels*.25+wheelRadius]
locNonChoice = rightWheelpos
arrowChoice = [screenXpixels*.25-wheelRadius/10 screenYpixels*.25-wheelRadius/10 screenXpixels*.25+wheelRadius/10 screenYpixels*.25+wheelRadius/10];

[xCenter-24 yCenter-240 xCenter+48 yCenter+240]
[screenXpixels*.25-wheelRadius/10 screenYpixels*.25-wheelRadius/10 screenXpixels*.25+wheelRadius/10 screenYpixels*.25+wheelRadius/10];
arrowNonChoice = 

        Screen('DrawTexture', window, texProb66, [0 0 550 550], locNonChoice); %%!! Location should not be hard coded
    
% choice spin
    lotteryOutcome = 0.33;      %%!! this is the outcome of the lottery's probability roll, a number between 0 and 1
    time.start = GetSecs;
    ang=0;
    
    while(ang < (4*360 + 360*lotteryOutcome)) %% 4*360 means the arrow will spin 4 full rounds before stopping at the outcome
        ang=ang+degPerFrame;
        Screen('DrawTexture', window, texProb66, [0 0 550 550], locChoice); %%!! Location should not be hard coded
        Screen('DrawTexture', window, texArrow, [0 0 96 960], [xCenter-24 yCenter-240 xCenter+48 yCenter+240],ang);
        vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end
    WaitSecs(2); 

    
%% Screen 3-complete - arrows spin


%% Screen 4-partial - result


%% Screen 4-complete - result
