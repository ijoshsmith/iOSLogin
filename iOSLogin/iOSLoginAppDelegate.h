//
//  iOSLoginAppDelegate.h
//  iOSLogin
//
//  Created by Josh Smith on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LoginViewController.h" // imported for the LoginViewControllerDelegate protocol

@class MainViewController;

@interface iOSLoginAppDelegate : NSObject <UIApplicationDelegate, LoginViewControllerDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) MainViewController *mainViewController;

@end
