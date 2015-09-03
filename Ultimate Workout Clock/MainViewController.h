/*
 *  The Ultimate Workout Clock for iOS
 *
 *  Created by Michael Okner. Copyright 2011-2015.
 *
 *  Distributed under the BSD "modified" 3-clause license.
 */

#import <AudioToolbox/AudioToolbox.h>
#import <InAppSettingsKit/IASKAppSettingsViewController.h>


@interface MainViewController : UIViewController <IASKSettingsDelegate>

@property (nonatomic, retain) IBOutlet UILabel *secondLabel;
@property (nonatomic, retain) IBOutlet UILabel *minuteLabel;
@property (nonatomic, retain) IBOutlet UILabel *hourLabel;
@property (nonatomic, retain) IBOutlet UILabel *rdlabel;
@property (nonatomic, retain) IBOutlet UILabel *rdnum;
@property (retain, nonatomic) IBOutlet UIButton *startStopButton;
@property (retain, nonatomic) IBOutlet UIButton *resetButton;
@property (retain, nonatomic) IBOutlet UIButton *settingsButton;
@property (nonatomic, retain) IASKAppSettingsViewController *settingsController;

- (IBAction)onStartPressed:(id)sender;
- (IBAction)onResetPressed:(id)sender;
- (IBAction)showInfo:(id)sender;

@end
