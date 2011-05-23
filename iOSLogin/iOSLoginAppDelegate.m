//
//  iOSLoginAppDelegate.m
//  iOSLogin
//
//  Created by Josh Smith on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iOSLoginAppDelegate.h"
#import "LoginViewController.h"
#import "DemoLoginOperation.h"
#import "MainViewController.h"

@implementation iOSLoginAppDelegate

@synthesize window=_window;
@synthesize loginViewController=_loginViewController;
@synthesize mainViewController=_mainViewController;

- (BOOL)            application:(UIApplication *)application 
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Fetch the name of the nib file to use for the login view from the 
    // LoginDemo-Info.plist file. The two possible values in this demo 
    // are: 'LoginViewController' and 'DemoLoginView'
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *loginViewNib = [info objectForKey:@"Login nib file base name"];
    self.loginViewController = [[[LoginViewController alloc] initWithNibName:loginViewNib bundle:nil] autorelease];
    self.loginViewController.delegate = self;
    self.loginViewController.loginOperation = [[[DemoLoginOperation alloc] init] autorelease];
    
    // Add the main view to the window.
    self.mainViewController = [[[MainViewController alloc] init] autorelease];
    [self.window addSubview:self.mainViewController.view];
    
    // Show the login view modally. When the user logs in, we dismiss the modal dialog.
    [self.loginViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.mainViewController presentModalViewController:self.loginViewController animated:NO];
    
    // Show the window.
    [self.window makeKeyAndVisible];
    return YES;
}

// Invoked when the user is successfully logged in.
- (void)loginViewControllerLoggedIn:(LoginViewController *)loginViewController
{
    [self.mainViewController dismissModalViewControllerAnimated:YES];
    
    LoginOperation *loginOp = loginViewController.loginOperation;
    
    NSLog(@"Logged in. User Name='%@' Password='%@'", 
          loginOp.authenticatedUsername, 
          loginOp.authenticatedPassword);
    
    [loginOp deleteAuthenticatedData];
    
    self.loginViewController = nil;
}

- (void)dealloc
{
    [_window release];
    self.loginViewController = nil;
    self.mainViewController = nil;
    [super dealloc];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
