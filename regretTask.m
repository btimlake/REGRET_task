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

% Define black and white and other colors
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
% winColors = [34, 139, 34]; %ForestGreen
% loseColors = [205, 55, 0]; %OrangeRed3
winColors = black; %black
loseColors = black; %black

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0 0 640 480]);
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, [255, 255, 255], [0 0 640 480]);

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
topTextYpos = screenYpixels * 2/40; % Screen Y positions of top text

% Set positions of text elements
leftwheelLeftTextXpos = screenXpixels*.05;
leftwheelRightTextXpos = screenXpixels*.40;
rightwheelLeftTextXpos = screenXpixels*.54;
rightwheelRightTextXpos = screenXpixels*.90;
leftwheelLeftTextYpos = screenYpixels*.5;
leftwheelRightTextYpos = screenYpixels*.5;
rightwheelLeftTextYpos = screenYpixels*.5;
rightwheelRightTextYpos = screenYpixels*.5;

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
prop66=imread(fullfile('propCircle.png')); %load image of arrow
texProb66 = Screen('MakeTexture', window, prop66); % Draw arrow to the offscreen window


% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;


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

   
    angChoice=0;
    angNonChoice=0;
    
    DrawFormattedText(window, topInstructText, 'center', topTextYpos); % Instruction text

    % Show lottery choices
    Screen('DrawTexture', window, texProb66, [0 0 550 550], locChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowChoice, angChoice);
    DrawFormattedText(window, loseL, leftwheelLeftTextXpos, leftwheelLeftTextYpos, loseColors); % loss amount 
    DrawFormattedText(window, winL, leftwheelRightTextXpos, leftwheelLeftTextYpos, winColors); % win amount
    % non-choice wheel & arrow
    
    Screen('DrawTexture', window, texProb66, [0 0 550 550], locNonChoice); % Draw probability circle
    Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowNonChoice, angNonChoice);
    DrawFormattedText(window, loseR, rightwheelLeftTextXpos, leftwheelLeftTextYpos, loseColors); % loss amount
    DrawFormattedText(window, winR, rightwheelRightTextXpos, leftwheelLeftTextYpos, winColors); % win amount
    Screen('Flip', window)

%         switch keyName
%             case 'LeftArrow' 
%                 currPlayerSelection = 0; % choice is left lottery
%             case 'RightArrow'
%                 currPlayerSelection = 1; % choice is right lottery
%         end
% end
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
        Screen('DrawTexture', window, texProb66, [0 0 550 550], locChoice); %%!! Location should not be hard coded
        Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowChoice,angChoice);
    DrawFormattedText(window, loseL, leftwheelLeftTextXpos, leftwheelLeftTextYpos, loseColors); % loss amount 
    DrawFormattedText(window, winL, leftwheelRightTextXpos, leftwheelLeftTextYpos, winColors); % win amount
        % non-choice wheel & arrow        
        Screen('DrawTexture', window, texProb66, [0 0 550 550], locNonChoice); %%!! Location should not be hard coded
        Screen('DrawTexture', window, texArrow, [0 0 96 960], arrowNonChoice,angNonChoice);
    DrawFormattedText(window, loseR, rightwheelLeftTextXpos, leftwheelLeftTextYpos, loseColors); % loss amount
    DrawFormattedText(window, winR, rightwheelRightTextXpos, leftwheelLeftTextYpos, winColors); % win amount
        vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
end



end

    WaitSecs(2);

% Clear the screen
sca;