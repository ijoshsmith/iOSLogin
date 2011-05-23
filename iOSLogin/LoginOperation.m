//
//  LoginOperation.m
//  LoginDemo
//
//  Created by Josh Smith on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginOperation.h"

@interface LoginOperation()

// Make these properties have private setters. They are declared readonly in the header file.
@property (nonatomic, copy, readwrite) NSString *authenticatedUsername;
@property (nonatomic, copy, readwrite) NSString *authenticatedPassword;

@end

@implementation LoginOperation

@synthesize delegate=_delegate;
@synthesize authenticatedUsername=_authenticatedUsername;
@synthesize authenticatedPassword=_authenticatedPassword;

- (void)beginAuthenticateUsername:(NSString *)username 
                         password:(NSString *)password
{
    if (_operationQueue)
    {
        NSLog(@"Cannot attempt to log in before the previous attempt completes.");
        return;
    }
    
    self.authenticatedUsername = nil;
    self.authenticatedPassword = nil;
    
    // Copy the credentials for later use.
    _username = [username copy];
    _password = [password copy];
    
    // Create an operation that will be executed async.
    _invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self 
                                                               selector:@selector(executeAsync) 
                                                                 object:nil];
    
    // Enqueue the operation so that it will be executed on a worker thread.
    _operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue addOperation:_invocationOperation];
}

- (BOOL)authenticateImpl:(NSString **)errorMessage
{
    NSLog(@"Classes derived from LoginOperation must override authenticateImpl:");
    return NO;
}

- (void)deleteAuthenticatedData
{
    self.authenticatedUsername = nil;
    self.authenticatedPassword = nil;
}

- (void)releaseReferences
{
    [_username release];
    [_password release];
    [_invocationOperation release];
    [_operationQueue release];
    
    _username = nil;
    _password = nil;
    _invocationOperation = nil;
    _operationQueue = nil;
    _errorMessage = nil;
}

- (void)executeAsync
{
    NSAssert(![NSThread currentThread].isMainThread, @"executeAsync should run on a worker thread.");
    
    // Let the child class perform the authentication.
    _result = [self authenticateImpl:&_errorMessage];    
    
    // Dispatch a call to the UI thread to notify the world of the authentication result.
    [self performSelectorOnMainThread:@selector(onCompleted) 
                           withObject:nil 
                        waitUntilDone:NO];
}

- (void)onCompleted
{
    if (_result)
    {
        self.authenticatedUsername = _username;
        self.authenticatedPassword = _password;
    }
    
    [self.delegate loginOperationCompleted:self 
                                withResult:_result 
                              errorMessage:_errorMessage];
    
    [self releaseReferences];
}

-(void)dealloc
{
    NSLog(@"[LoginOperation dealloc]");
    [self releaseReferences];
    self.delegate = nil;
    self.authenticatedPassword = nil;
    self.authenticatedUsername = nil;
    [super dealloc];
}

@end
