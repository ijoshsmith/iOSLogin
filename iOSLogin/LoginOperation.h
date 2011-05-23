//
//  LoginOperation.h
//  LoginDemo
//
//  Created by Josh Smith on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Base class for an object that authenticates user credentials with a server.
@class LoginOperation;

// Delegate that responds to completion of a login attempt.
@protocol LoginOperationDelegate <NSObject>

// Invoked after a login attempt completes.
- (void)loginOperationCompleted:(LoginOperation *)loginOperation 
                     withResult:(BOOL)successfulLogin 
                   errorMessage:(NSString *)errorMessage;

@end 


// Base class for an operation that asynchronously 
// verifies user credentials against a server.
@interface LoginOperation : NSObject {
@protected
    NSString *_username;
    NSString *_password;
@private
    NSInvocationOperation *_invocationOperation;
    NSOperationQueue *_operationQueue;
    BOOL _result;
    NSString *_errorMessage;
}

// An object that is informed when an attempt to log in completes.
@property (nonatomic, assign) id<LoginOperationDelegate> delegate;

// Returns the username that was successfully authenticated.
@property (nonatomic, copy, readonly) NSString *authenticatedUsername;

// Returns the password that was successfully authenticated.
@property (nonatomic, copy, readonly) NSString *authenticatedPassword;

// Invoke this method to start an asynchronous attempt to login.
- (void)beginAuthenticateUsername:(NSString *)username 
                         password:(NSString *)password;

// Derived classes override this method to perform a synchronous/blocking
// call to a server that verifies the supplied user credentials.
// Returns YES if the authentication succeeded, or NO if it failed.
// This method executes on a worker thread.
// Do not call the base implementation.
- (BOOL)authenticateImpl:(NSString **)errorMessage;

// Invoke this method to throw away the values stored by authenticatedUsername and authenticatedPassword.
- (void)deleteAuthenticatedData;

@end
