/*
 *  The Ultimate Workout Clock for iOS
 *
 *  Created by Michael Okner. Copyright 2011-2015.
 *
 *  Distributed under the BSD "modified" 3-clause license.
 */

#import <UIKit/UIKit.h>


@class MainViewController;

@interface UltimateWorkoutClockAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end
