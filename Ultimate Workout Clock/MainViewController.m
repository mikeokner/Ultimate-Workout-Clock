/* 
 *  The Ultimate Workout Clock for iOS
 *
 *  Created by Michael Okner. Copyright 2011-2015.
 *
 *  Distributed under the BSD "modified" 3-clause license.
 */

#import "MainViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <InAppSettingsKit/IASKSettingsReader.h>


@implementation MainViewController
{
    SystemSoundID round_beep;
    SystemSoundID startstop_beep;
    NSURL *beepURL;
    NSURL *ssbeepURL;
    NSInteger currentRound;
    NSInteger startStopState;
    NSInteger countdown;
    NSInteger secs;
    NSInteger mins;
    NSInteger hours;
    NSInteger maxSecs;
    NSInteger maxMins;
    NSInteger clockType;
    NSInteger units;
    NSInteger length;
    BOOL firstLoop;
    NSTimer *stopWatchTimer;
}

@synthesize secondLabel;
@synthesize minuteLabel;
@synthesize hourLabel;
@synthesize rdlabel;
@synthesize rdnum;
@synthesize startStopButton;
@synthesize resetButton;
@synthesize settingsButton;
@synthesize settingsController;


#pragma mark Built-ins

- (void) viewDidLoad
{
    [super viewDidLoad];
    /* Set the properties of the Start/Stop and Reset buttons */
    [[startStopButton layer] setCornerRadius:4.0f];
    [[startStopButton layer] setBorderWidth:2.0f];
    [startStopButton setBackgroundColor:[UIColor blackColor]];
    [[startStopButton layer] setBorderColor:[UIColor grayColor].CGColor];
    [[resetButton layer] setCornerRadius:4.0f];
    [[resetButton layer] setBorderWidth:2.0f];
    [[resetButton layer] setBorderColor:[UIColor grayColor].CGColor];
    [resetButton setBackgroundColor:[UIColor blackColor]];
    [[settingsButton layer] setCornerRadius:4.0f];
    [[settingsButton layer] setBorderWidth:2.0f];
    [[settingsButton layer] setBorderColor:[UIColor grayColor].CGColor];
    [settingsButton setBackgroundColor:[UIColor blackColor]];

    /* Set inital clock text */
    secondLabel.text = @":00";
    minuteLabel.text = @"";
    hourLabel.text = @"";
    rdlabel.text = @"";
    rdnum.text = @"";

    /* Register the beep sound and startstop_beep sound */
    beepURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((CFURLRef)beepURL, &round_beep);
    ssbeepURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"start_stop" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((CFURLRef)ssbeepURL, &startstop_beep);

    NSLog(@"Configuration: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
} 

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void) viewDidUnload
{
    [self setSecondLabel:nil];
    [self setMinuteLabel:nil];
    [self setHourLabel:nil];
    [self setRdnum:nil];
    [self setRdlabel:nil];
    [self setStartStopButton:nil];
    [self setResetButton:nil];
    [super viewDidUnload];
}

- (void) dealloc
{
    [secondLabel release];
    [minuteLabel release];
    [hourLabel release];
    [rdlabel release];
    [rdnum release];
    [beepURL release];
    [ssbeepURL release];
    [startStopButton release];
    [resetButton release];
    AudioServicesDisposeSystemSoundID(startstop_beep);
    AudioServicesDisposeSystemSoundID(round_beep);
    [super dealloc];
}

#pragma mark Settings

- (IASKAppSettingsViewController*) settingsController
{
    if (!settingsController) {
        settingsController = [[IASKAppSettingsViewController alloc] init];
        settingsController.delegate = self;
    }
    return settingsController;
}

- (void) settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // Reconfigure the app for changed settings
}

- (NSInteger) getIntegerPreferenceValue:(NSString*)key
{
    @try {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSInteger choice = [prefs integerForKey:key];
        return choice;
    }
    @catch (NSException *exception) {
        NSLog(@"Failed to look up key in NSUserDefaults: %@", key);
        return [NSNumber numberWithInteger:0];
    }
}

- (BOOL) doPlaySounds
{
    NSInteger choice = [self getIntegerPreferenceValue:@"prefs_play_sounds"];
    return choice;
}

- (NSInteger) getClockType
{
    NSInteger choice = [self getIntegerPreferenceValue:@"prefs_clock_type"];
    return choice;
}

- (NSInteger) getClockLength
{
    NSNumber *choice;
    @try {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *strChoice = [prefs objectForKey:@"prefs_clock_length"];
        NSNumberFormatter *nf = [[[NSNumberFormatter alloc] init] autorelease];
        choice = [nf numberFromString:strChoice];
    }
    @catch (NSException *exception) {
        NSLog(@"Failed to look up prefs_clock_length");
        choice = [NSNumber numberWithInt:30];
    }
    NSInteger returnVal;
    if (choice == nil) {
        // integerValue returns 0 if the string doesn't start with a numerical char
        returnVal = 30;
    }
    else {
        returnVal = [choice integerValue];
    }
    return returnVal;
}

- (NSInteger) getClockUnits
{
    NSInteger choice = [self getIntegerPreferenceValue:@"prefs_clock_units"];
    return choice;
}

- (NSInteger) getCountdownLength
{
    NSNumber *choice;
    @try {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *strChoice = [prefs objectForKey:@"prefs_countdown_length"];
        NSNumberFormatter *nf = [[[NSNumberFormatter alloc] init] autorelease];
        choice = [nf numberFromString:strChoice];
    }
    @catch (NSException *exception) {
        NSLog(@"Failed to look up prefs_countdown_length");
        choice = [NSNumber numberWithInt:10];
    }
    NSInteger returnVal;
    if (choice == nil) {
        // integerValue returns 0 if the string doesn't start with a numerical char
        returnVal = 10;
    }
    else {
        returnVal = [choice integerValue];
    }
    return returnVal;
}

- (BOOL) doUseCountdown
{
    NSInteger choice = [self getIntegerPreferenceValue:@"prefs_use_countdown"];
    return choice;
}

#pragma mark Clock Handlers

- (BOOL) countdownHandler
{
    if (countdown > 0 && [self doUseCountdown]) {
        if (countdown > 59) {
            countdown = 59;
        }
        secondLabel.text = [NSString stringWithFormat:@":%02ld", (long)countdown];
        if (countdown <= 3 && [self doPlaySounds]) {
            AudioServicesPlaySystemSound(round_beep);
        }
        countdown--;
        return YES;
    }
    else {
        return NO;
    }
}

- (void) renderClockValues
{
    if (mins < 1 && hours < 1) {
        // Only seconds
        hourLabel.text = @"";
        minuteLabel.text = @"";
        secondLabel.text = [NSString stringWithFormat:@":%02ld", (long)secs];
    }
    else if (hours < 1) {
        // Seconds & minutes but no hours
        hourLabel.text = @"";
        minuteLabel.text = [NSString stringWithFormat:@"%3ld", (long)mins];
        secondLabel.text = [NSString stringWithFormat:@":%02ld", (long)secs];
    }
    else {
        // Seconds, minutes, and hours
        hourLabel.text = [NSString stringWithFormat:@"%1ld", (long)hours];
        minuteLabel.text = [NSString stringWithFormat:@":%02ld", (long)mins];
        secondLabel.text = [NSString stringWithFormat:@":%02ld", (long)secs];
    }
}

- (void) stopwatchHandler
{
    // Check if we should roll over
    if (secs >= 60) {
        mins++;
        secs = 0;
    }
    if (mins >= 60) {
        hours++;
        mins = 0;
        secs = 0;
    }
    // Update numbers
    [self renderClockValues];
    secs++;
}

- (void) timerHandler
{
    // Update numbers
    [self renderClockValues];

    // Check if we should roll over to new lower minute
    if (secs == 0) {
        if (mins == 0) {
            if (hours == 0) {
                hourLabel.text = @"";
                minuteLabel.text = @"";
                secondLabel.text = @":00";
                startStopState = 0;
                if ([self doPlaySounds]) {
                    AudioServicesPlaySystemSound(startstop_beep);
                }
                [stopWatchTimer invalidate];
            }
            else {
                hours--;
                mins = 59;
                secs = 59;
            }
        }
        else {
            mins--;
            secs = 59;
        }
    }
    else {
        secs--;
    }
}

- (void) roundHandler
{
    if (secs == maxSecs && mins == maxMins) {
        // Check if we should roll over rounds
        secs = 0;
        mins = 0;
        currentRound++;
        if ([self doPlaySounds]) {
            AudioServicesPlaySystemSound(round_beep);
        }
    }
    // Check if we should roll over
    if (secs >= 60) {
        mins++;
        secs = 0;
    }
    // Update numbers
    rdnum.text = [NSString stringWithFormat:@"%ld", (long)currentRound];
    [self renderClockValues];
    secs++;
}

- (void) clockHandler
{
    // Coutdown
    BOOL didCountdown = [self countdownHandler];

    /* Actual clocks */
    if (!didCountdown) {
        if (firstLoop == YES && [self doPlaySounds]) {
            // play the start sound
            AudioServicesPlaySystemSound(startstop_beep);
            firstLoop = NO;
        }

        /* Count up (stopwatch) */
        if (clockType == 0) {
            [self stopwatchHandler];
        }
        /* Count down (Timer) */
        else if (clockType == 1) {
            [self timerHandler];
        }

        /* Rounds */
        else if (clockType == 2) {
            [self roundHandler];
        }
    }
}

#pragma mark Button Handlers

- (void) handleStartAction
{
    clockType = [self getClockType];
    units = [self getClockUnits];
    length = [self getClockLength];
    firstLoop = YES;
    if (clockType == 0) {
        // Count up (Stopwatch)
        secs = 0;
        mins = 0;
        hours = 0;
        secondLabel.text = @":00";
        minuteLabel.text = @"";
        hourLabel.text = @"";
        rdlabel.text = @"";
        rdnum.text = @"";
    }
    else if (clockType == 1) {
        // Timer (Count down)
        secondLabel.text = @":00";
        minuteLabel.text = @"";
        hourLabel.text = @"";
        rdlabel.text = @"";
        rdnum.text = @"";
        hours = 0;
        if (units == 0) {
            secs = length % 60;
            mins = (length - secs) / 60;
        }
        else if (units == 1) {
            secs = 0;
            mins = length;
        }
        if (mins > 59) {
            hours = mins / 60;
            mins = mins % 60;
        }
    }
    else if (clockType == 2) {
        // Rounds (cycle)
        secondLabel.text = @":00";
        minuteLabel.text = @"";
        hourLabel.text = @"";
        rdlabel.text = @"Round:";
        rdnum.text = @"1";
        if (units == 0) {
            maxSecs = length % 60;
            maxMins = (length - secs) / 60;
        }
        else if (units == 1) {
            maxSecs = 0;
            maxMins = length;
        }
        secs = 0;
        mins = 0;
        hours = 0;
        currentRound= 1;
    }
    countdown = [self getCountdownLength];
    startStopState = 1;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                              target:self
                              selector:@selector(clockHandler)
                              userInfo:nil
                              repeats:YES];
}

- (void) handleStopAction
{
    startStopState = 2;
    [stopWatchTimer invalidate];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void) handleRestartAction
{
    startStopState = 1;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                              target:self
                              selector:@selector(clockHandler)
                              userInfo:nil
                              repeats:YES];
}

- (IBAction) onStartPressed:(id)sender
{
    // Pressing start/stop from a blank clock
    if (startStopState == 0) {
        [self handleStartAction];
    }
    // Pressing start/stop while clock is running
    else if (startStopState == 1) {
        [self handleStopAction];
    }
    // Pressing start/stop to restart from pause
    else if (startStopState == 2) {
        [self handleRestartAction];
    }
}
 
- (IBAction) onResetPressed:(id)sender
{
    // Reset the timer
    // Only does anything if clock is in paused state
    if (startStopState == 2) {
        if ([self getClockType] == 2) {
            rdlabel.text = @"Round:";
            rdnum.text = @"1";
        }
        else {
            rdnum.text = @"";
            rdlabel.text = @"";
        }
        secondLabel.text = @":00";
        minuteLabel.text = @"";
        hourLabel.text = @"";
        stopWatchTimer = nil;
        startStopState = 0;
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}
          
- (IBAction) showInfo:(id)sender
{
    // Show the Settings view
    settingsController = [[[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil] autorelease];
    settingsController.delegate = self;
    settingsController.showDoneButton = YES;
    [settingsController setShowCreditsFooter:NO];
    UINavigationController *aNavController = [[[UINavigationController alloc] initWithRootViewController:settingsController] autorelease];
    [self presentViewController:aNavController animated:YES completion:nil];
}

@end
