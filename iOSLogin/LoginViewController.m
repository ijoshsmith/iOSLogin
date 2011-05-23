//
//  LoginViewController.m
//  LoginDemo
//
//  Created by Josh Smith on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

#pragma mark - Properties
@synthesize delegate=_delegate;
@synthesize usernameTextField=_usernameTextField;
@synthesize passwordTextField=_passwordTextField;
@synthesize submitButton=_submitButton;
@synthesize waitIndicator=_waitIndicator;
@synthesize errorMessageTextView=_errorMessageTextView;

// Custom setter, which sets the 'delegate' property of the login operation
@synthesize loginOperation=_loginOperation;
- (void) setLoginOperation:(LoginOperation *)loginOperation
{
    [loginOperation retain];
    [_loginOperation release];
    _loginOperation = loginOperation;
    
    if (_loginOperation)
        _loginOperation.delegate = self;
}

#pragma mark - Helper methods
- (void)releaseOutlets
{
    self.usernameTextField = nil;
    self.passwordTextField = nil;
    self.submitButton = nil;
    self.waitIndicator = nil;
    self.errorMessageTextView = nil;
}

- (void)setIsWaiting:(BOOL)waiting
{
    if (waiting)
    {
        [self.waitIndicator startAnimating];
        self.submitButton.enabled = NO;
    }
    else
    {
        [self.waitIndicator stopAnimating];
        self.submitButton.enabled = YES;
    }
}

#pragma mark - Actions
- (IBAction)submit:(id)sender 
{
    if (!self.loginOperation)
        return;
    
    NSString *username = self.usernameTextField.text;
    if (!username || [username length] == 0)
        return;
    
    NSString *password = self.passwordTextField.text;
    if (!password || [password length] == 0)
        return;
    
    [self setIsWaiting:YES];
    
    [self.loginOperation beginAuthenticateUsername:username 
                                          password:password];
}

#pragma mark - LoginOperationDelegate members
- (void)loginOperationCompleted:(LoginOperation *)loginOperation 
                     withResult:(BOOL)successfulLogin 
                   errorMessage:(NSString *)errorMessage
{
    [self setIsWaiting:NO];
    
    if (successfulLogin)
    {
        self.errorMessageTextView.text = nil;
        
        // Let this object's delegate know that the login was a success.
        [self.delegate loginViewControllerLoggedIn:self];
    }
    else
    {
        self.errorMessageTextView.text = errorMessage;
    }
}

#pragma mark - UITextFieldDelegate members
// Called when the 'return' key is pressed. Return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField)
    {
        // Move input focus to the password field.
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        // Simulate clicking the Submit button.
        [self submit:nil];
    }
    return NO;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Get rid of any design-time placeholder text.
    self.errorMessageTextView.text = nil;
    
    // Configure the animated icon that is displayed
    // while the user's credentials are being verified.
    self.waitIndicator.hidden = YES;
    self.waitIndicator.hidesWhenStopped = YES;
    
    // Set this object as the delegate for the text fields, so that
    // when the user hits the RETURN key we can perform custom logic.
    self.passwordTextField.delegate = self;
    self.usernameTextField.delegate = self;
    
    // Give input focus to the username field.
    [self.usernameTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self releaseOutlets];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for either portrait orientation, but NO for landscape.
	return interfaceOrientation == UIInterfaceOrientationPortrait 
        || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
}

- (void)dealloc
{
    [self releaseOutlets];
    self.delegate = nil;
    self.loginOperation = nil;
    [super dealloc];
}

@end
