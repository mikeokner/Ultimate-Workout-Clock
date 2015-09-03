/*
 *  The Ultimate Workout Clock for iOS
 *
 *  Created by Michael Okner. Copyright 2011-2015.
 *
 *  Distributed under the BSD "modified" 3-clause license.
 */

#import "UltimateWorkoutClockAppDelegate.h"
#import "MainViewController.h"


@implementation UltimateWorkoutClockAppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;

- (BOOL)
application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Register default preferences
    NSDictionary *appDefaults = [[NSDictionary alloc]
                                 initWithObjectsAndKeys: [NSNumber numberWithInteger:0], @"prefs_clock_type",
                                                        [NSNumber numberWithInteger:30], @"prefs_clock_length",
                                                         [NSNumber numberWithInteger:0], @"prefs_clock_units",
                                                          [NSNumber numberWithBool:YES], @"prefs_play_sounds",
                                                          [NSNumber numberWithBool:YES], @"prefs_use_countdown",
                                                        [NSNumber numberWithInteger:10], @"prefs_countdown_length",
                                                        nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];

    // Add the main view controller's view to the window and display.
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)
applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)
applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)
applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)
applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)
applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

- (void)
dealloc
{
      [_window release];
      [_mainViewController release];
      [super dealloc];
}

@end
