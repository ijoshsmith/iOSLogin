//
//  DemoLoginOperation.h
//  LoginDemo
//
//  Created by Josh Smith on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginOperation;

@interface DemoLoginOperation : LoginOperation <NSXMLParserDelegate> {
    BOOL _buildErrorMessage;
    NSMutableString *_errorMessageBuilder;
}

@end
