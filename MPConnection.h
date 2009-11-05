//
//  MPConnection.h
//  MPConnectionAgent
//
//  Created by Matt Patenaude on 1/3/09.
//  Copyright 2009 Matt Patenaude. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MPConnection : NSObject {
	id delegate;
	NSURLRequest *theRequest;
	NSMutableArray *requestRuns;
}

// Initializers
- (id)initWithRequest:(NSURLRequest *)aRequest;
+ (id)connectionWithRequest:(NSURLRequest *)aRequest;

// Properties
- (NSURLRequest *)request;
- (id)delegate;
- (void)setDelegate:(id)theDelegate;

// Methods
- (void)beginRequestWithHandlerInvocation:(NSInvocation *)anInvocation;
- (void)beginRequestWithTarget:(id)theTarget selector:(SEL)theSelector userInfo:(NSDictionary *)theUserInfo;

@end

@interface NSObject (MPConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error userInfo:(NSDictionary *)userInfo;
@end
