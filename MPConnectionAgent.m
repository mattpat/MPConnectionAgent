//
//  MPConnectionAgent.m
//  MPConnectionAgent
//
//  Created by Matt Patenaude on 2/20/08.
//  Copyright 2008 - 09 Matt Patenaude. All rights reserved.
//

#import "MPConnectionAgent.h"
#import "MPConnection.h"


@implementation MPConnectionAgent

+ (id)sharedConnectionAgent
{
	static id _sharedConnectionAgent = nil;
	if (!_sharedConnectionAgent)
		_sharedConnectionAgent = [[self alloc] init];
	
	return _sharedConnectionAgent;
}

- (id)delegate
{
	return delegate;
}
- (void)setDelegate:(id)newDelegate
{
	delegate = newDelegate;
}

- (void)beginConnectionWithRequest:(NSURLRequest *)request target:(id)target selector:(SEL)selector userInfo:(NSDictionary *)userInfo
{
	// changed 1/3/09: the MPConnectionAgent class is no longer necessary
	// all functionality is now handled within MPConnection
	// this is left for backwards compatibility
	
	MPConnection *c = [MPConnection connectionWithRequest:request];
	[c beginRequestWithTarget:target selector:selector userInfo:userInfo];
}

@end
