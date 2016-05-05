% Clear the workspace and the screen
sca;
close all;
clearvars;

load('regretTasktrialWheels.mat')

%% Screen -1: Participant number entry

%%% Enter participant number (taken from:
%%% http://www.academia.edu/2614964/Creating_experiments_using_Matlab_and_Psychtoolbox)
fail1='Please enter a participant number.'; %error message
prompt = {'Enter participant number:'};
dlg_title ='New Participant';
num_lines = 1;
def = {'0'};
answer = inputdlg(prompt,dlg_title,num_lines,def);%presents box to enterdata into
switch isempty(answer)
    case 1 %deals with both cancel and X presses 
        error(fail1)
    case 0
        particNum=(answer{1});
end

% uncomment after debugging
% HideCursor;

%% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

Screen('Preference', 'SkipSyncTests', 2);
KbName('UnifyKeyNames');

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
% screenNumber = max(screens);
screenNumber = 0;

% Define black and white and other colors
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
BG=[1 1 1]; % set background color of PNG imports
% NOTE that colors now have to be in the set [0,1], so to get values, just 
% divide old RGB amounts by 255
winColors = [.1333, .5451, .1333]; %ForestGreen
loseColors = [.8039, .2157, 0]; %OrangeRed3
% winColors = black; %black
% loseColors = black; %black
chooseColors = [1, .84, 0]; %Gold

% Open an on screen window
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0 0 640 480]);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
screenCenter = [xCenter, yCenter]; % center coordinatesf


%% Set position info
wheelRadius = (screenXpixels*.13);

% Set positions of graphical elements
leftWheelpos = [screenXpixels*.25-wheelRadius screenYpixels*.5-wheelRadius screenXpixels*.25+wheelRadius screenYpixels*.5+wheelRadius];
rightWheelpos = [screenXpixels*.75-wheelRadius screenYpixels*.5-wheelRadius screenXpixels*.75+wheelRadius screenYpixels*.5+wheelRadius];
leftArrowpos = [screenXpixels*.25-wheelRadius*.25 screenYpixels*.5-wheelRadius*.75 screenXpixels*.25+wheelRadius*.25 screenYpixels*.5+wheelRadius*.75];
rightArrowpos = [screenXpixels*.75-wheelRadius*.25 screenYpixels*.5-wheelRadius*.75 screenXpixels*.75+wheelRadius*.25 screenYpixels*.5+wheelRadius*.75];

% Set positions of text elements
topTextYpos = screenYpixels * 2/40; % Screen Y positions of top text
leftwheelLeftTextXpos = screenXpixels*.04;
leftwheelRightTextXpos = screenXpixels*.4;
rightwheelLeftTextXpos = screenXpixels*.54;
rightwheelRightTextXpos = screenXpixels*.9;
leftwheelLeftTextYpos = screenYpixels*.45;
leftwheelRightTextYpos = screenYpixels*.5;
rightwheelLeftTextYpos = screenYpixels*.45;
rightwheelRightTextYpos = screenYpixels*.5;

% Rect positions/dimensions based on wheel positions/dimensions
rectWidth = screenXpixels*.3; % based on wheelRadius = (screenXpixels*.13);
rectHeight = screenYpixels*.45;
baseRect = [0 0 rectWidth rectHeight];
rectYpos = screenYpixels*.5;
leftRectXpos = screenXpixels*.25;
rightRectXpos = screenXpixels*.75;
leftRect = CenterRectOnPointd(baseRect, leftRectXpos, rectYpos);
rightRect = CenterRectOnPointd(baseRect, rightRectXpos, rectYpos);
lineWeight = round(screenYpixels*.01);

% temporary; will be modified to make these vary depending on choice
locChoice = leftWheelpos;  
locNonChoice = rightWheelpos; 
arrowChoice = leftArrowpos;
arrowNonChoice = rightArrowpos;

% Display text
topInstructText = ['Choose which wheel to spin.'];

% Select specific text font, style and size:
fontSize = round(screenYpixels * 2/40);
    Screen('TextFont', window, 'Courier New');
    Screen('TextSize', window, fontSize);
    Screen('TextStyle', window);
    Screen('TextColor', window, [0, 0, 0]);
    
% Set some variables
NUMROUNDS = 3;
lotteryOutcome = 0 + (1-0).*rand(NUMROUNDS,2); % Creates array of random outcome probabilities for both wheels in each round
% outcome values
OUTCOME1 = 50;
OUTCOME2 = -50;
OUTCOME3 = 200;
OUTCOME4 = -50;
% outcome strings
winL = num2str(OUTCOME1);
loseL = num2str(OUTCOME2);
winR = num2str(OUTCOME3);
loseR = num2str(OUTCOME4);

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
prop25=imread(fullfile('propCircle25-75.png'), 'BackgroundColor',BG); %load image of circle
prop33=imread(fullfile('propCircle33-66.png'), 'BackgroundColor',BG ); %load image of circle
prop50=imread(fullfile('propCircle50-50.png'), 'BackgroundColor',BG); %load image of circle
prop66=imread(fullfile('propCircle66-33.png'), 'BackgroundColor',BG); %load image of circle
prop75=imread(fullfile('propCircle75-25.png'), 'BackgroundColor',BG); %load image of circle
texProb25 = Screen('MakeTexture', window, prop25); % Draw circle to the offscreen window
texProb33 = Screen('MakeTexture', window, prop33); % Draw circle to the offscreen window
texProb50 = Screen('MakeTexture', window, prop50); % Draw circle to the offscreen window
texProb66 = Screen('MakeTexture', window, prop66); % Draw circle to the offscreen window
texProb75 = Screen('MakeTexture', window, prop75); % Draw circle to the offscreen window

%     [...] = imread(...,'BackgroundColor',BG) composites any transparent 
%     pixels in the input image against the color specified in BG.  If BG is
%     'none', then no compositing is performed. Otherwise, if the input image
%     is indexed, BG should be an integer in the range [1,P] where P is the
%     colormap length. If the input image is grayscale, BG should be a value
%     in the range [0,1].  If the input image is RGB, BG should be a 
%     three-element vector whose values are in the range [0,1]. The string
%     'BackgroundColor' may be abbreviated. 
    
% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

%%
% Make an array with the variables for each trial
% Set loop to get variables (wheels, awards) for each trial

for i=1:NUMROUNDS

%% Screen 1

keyName=''; % empty initial value

%     [keyTime, keyCode]=KbWait([],2);
%     keyName=KbName(keyCode);
% 
% while(strcmp(keyName,'')) % continues until any key pressed
    
%         switch keyName
%             case 'LeftArrow' 
%                 currPlayerSelection = 0; % choice is left lottery
%             case 'RightArrow'
%                 currPlayerSelection = 1; % choice is right lottery
%         end

% Set win/lose values based on trial round
winL = num2str(regretTasktrialWheels.wlv1(i));
loseL = num2str(regretTasktrialWheels.wlv2(i));
winR = num2str(regretTasktrialWheels.wrv1(i));
loseR = num2str(regretTasktrialWheels.wrv2(i));
% wheelL = ['texProb' num2str(regretTasktrialWheels.wlp1(i)*100)];
% wheelR = ['texProb' num2str(regretTasktrialWheels.wrp1(i)*100)];

wheelL = [];
wheelR = [];

probL = num2str(regretTasktrialWheels.wlp1(i));
probR = num2str(regretTasktrialWheels.wrp1(i));

switch probL
    case {'0.25'}
    wheelL=texProb25;
    case {'0.33'}
    wheelL=texProb3';
    case {'0.5'}
    wheelL=texProb50;
    case {'0.66'}
    wheelL=texProb66;
    case {'0.75'}
    wheelL=texProb75;
end

  
switch probR
    case {'0.25'}
    wheelR=texProb25;
    case {'0.33'}
    wheelR=texProb33;
    case {'0.5'}
    wheelR=texProb50;
    case {'0.66'}
    wheelR=texProb66;
    case {'0.75'}
    wheelR=texProb75;
end      
        
% wheelL = texProb66
% wheelR = texProb66

    angChoice=0;
    angNonChoice=0;
    
    DrawFormattedText(window, topInstructText, 'center', topTextYpos); % Instruction text

    % Show lottery choices
    Screen('DrawTexture', window, wheelL, [0 0 550 550], locChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowChoice, angChoice);
    DrawFormattedText(window, winL, leftwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount 
    DrawFormattedText(window, loseL, leftwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
    % non-choice wheel & arrow
    
    Screen('DrawTexture', window, wheelR, [0 0 550 550], locNonChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowNonChoice, angNonChoice);
    DrawFormattedText(window, winR, rightwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount
    DrawFormattedText(window, loseR, rightwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
    Screen('Flip', window)

%         switch keyName
%             case 'LeftArrow' 
%                 currPlayerSelection = 0; % choice is left lottery
%             case 'RightArrow'
%                 currPlayerSelection = 1; % choice is right lottery
%         end
% end

% while(~strcmp(keyName,'space')) % continues until current keyName is space

% WaitSecs(1);

RestrictKeysForKbCheck([79, 80]);

[keyTime, keyCode]=KbWait([],2);
keyName=KbName(keyCode);

% while keyName~='LeftArrow' && keyName~='RightArrow'
% while keyCode~=80 && keyCode~=79
% arrowLeft = KbName('LeftArrow');
% arrowRight = KbName('RightArrow');


% while ~strcmp(keyName,'LeftArrow') && ~strcmp(keyName,'RightArrow')
%     keyName=GetChar;


%     if keyName == 'LeftArrow';
    if strcmp(keyName,'LeftArrow')
        rectPos = leftRect;
%     rectPos = Screen('FrameRect', window, winColors, leftRect); % Draw the top rects to the screen
%     Screen('Flip', window)

%     elseif keyName == 'RightArrow';
    elseif strcmp(keyName,'RightArrow')
        rectPos = rightRect;
%     Screen('FrameRect', window, winColors, rightRect); % Draw the top rects to the screen
%     Screen('Flip', window)
%     else
%         KbWait([],2);
    end
    
% end

RestrictKeysForKbCheck([]);

%% show choice rect over wheels
    Screen('DrawTexture', window, wheelL, [0 0 550 550], locChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowChoice, angChoice);
    DrawFormattedText(window, winL, leftwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount 
    DrawFormattedText(window, loseL, leftwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
    % non-choice wheel & arrow
    
    Screen('DrawTexture', window, wheelR, [0 0 550 550], locNonChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowNonChoice, angNonChoice);
    DrawFormattedText(window, winR, rightwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount
    DrawFormattedText(window, loseR, rightwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
        Screen('FrameRect', window, chooseColors, rectPos, lineWeight); % Draw the choice rect to the screen
        Screen('Flip', window)
    
 WaitSecs(1);   

%             switch keyName
%             case 'LeftArrow' 
%                 currPlayerSelection = currPlayerSelection - 1;
%                 if currPlayerSelection < 0
%                     currPlayerSelection = 0;
%                 end
%             case 'RightArrow'
%                 currPlayerSelection = currPlayerSelection + 1;
%                 if currPlayerSelection > PLAYER1MAXBID
%                     currPlayerSelection = PLAYER1MAXBID;
%                 end
%         end

%% Screen 3 - Animation loop

%     lotteryOutcome = 0.33;      %%!! this is the outcome of the lottery's probability roll, a number between 0 and 1
    time.start = GetSecs;
    angChoice=0;
    angNonChoice=0;
%  && angNonChoice < (4*360 + 360*lotteryOutcome(i,2))
while( (angChoice < (4*360 + 360*lotteryOutcome(i,1))) || (angNonChoice < (4*360 + 360*lotteryOutcome(i,2))) ) %% 4*360 means the arrow will spin 4 full rounds before stopping at the outcome
    if(angChoice < (4*360 + 360*lotteryOutcome(i,1)))
        angChoice=angChoice+degPerFrame;
    end
    if(angNonChoice < (4*360 + 360*lotteryOutcome(i,2)))
        angNonChoice=angNonChoice+degPerFrame;
    end
% choice wheel & arrow
    Screen('DrawTexture', window, wheelL, [0 0 550 550], locChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowChoice, angChoice);
    DrawFormattedText(window, winL, leftwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount 
    DrawFormattedText(window, loseL, leftwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
    % non-choice wheel & arrow
    
    Screen('DrawTexture', window, wheelR, [0 0 550 550], locNonChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowNonChoice, angNonChoice);
    DrawFormattedText(window, winR, rightwheelLeftTextXpos, leftwheelLeftTextYpos, winColors); % win amount
    DrawFormattedText(window, loseR, rightwheelRightTextXpos, leftwheelRightTextYpos, loseColors); % loss amount
        Screen('FrameRect', window, chooseColors, rectPos, lineWeight); % Draw the choice rect to the screen
        vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
end

WaitSecs(2); 

% Write logfile
% save(['oneshot-subj_' num2str(particNum) '-' DateTime], 'wofChoice', 'wofEarnings', 'trialLength');


    
end

    WaitSecs(2);
    
% Clear the screen
sca;