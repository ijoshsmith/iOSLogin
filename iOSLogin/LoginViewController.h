//
//  LoginViewController.h
//  LoginDemo
//
//  Created by Josh Smith on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginOperation.h"

@class LoginViewController;

// Describes an object that is notified when the user credentials have been authenticated.
@protocol LoginViewControllerDelegate <NSObject>

// Invoked when the user credentials have been successfully authenticated.
// Check the LoginViewController's loginOperation to get the authenticated username and password.
- (void)loginViewControllerLoggedIn:(LoginViewController *)loginViewController;

@end

// This controller is responsible for driving a login screen, using a LoginOperation object 
// to authenticate user credentials, and notify its delegate when the user has logged in.
// The default View associated with this controller can be replaced by specifying a different
// View to the initWithNibName:bundle: initializer.
@interface LoginViewController : UIViewController <LoginOperationDelegate, UITextFieldDelegate> {

}

// Properties
@property (nonatomic, assign) id<LoginViewControllerDelegate>    delegate;
@property (nonatomic, retain) LoginOperation                    *loginOperation;

// Outlets
@property (nonatomic, retain) IBOutlet UITextField              *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField              *passwordTextField;
@property (nonatomic, retain) IBOutlet UIButton                 *submitButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *waitIndicator;
@property (nonatomic, retain) IBOutlet UITextView               *errorMessageTextView;

// Actions
- (IBAction)submit:(id)sender;

@end
