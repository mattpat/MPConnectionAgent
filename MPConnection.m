//
//  MPConnection.m
//  MPConnectionAgent
//
//  Created by Matt Patenaude on 1/3/09.
//  Copyright (C) 2008 - 10 Matt Patenaude.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "MPConnection.h"


static NSMutableArray *__MPConnectionActiveList = nil;

@interface MPConnection()
// Private methods
- (void)_beginRequestWithHandlerInvocation:(NSInvocation *)theInvocation userInfo:(NSDictionary *)userInfo;
- (NSDictionary *)_runForConnection:(NSURLConnection *)theConnection;
@end

@implementation MPConnection

#pragma mark Initializers
+ (void)initialize
{
	__MPConnectionActiveList = [[NSMutableArray alloc] init];
}
- (id)init
{
	return [self initWithRequest:nil];
}
- (id)initWithRequest:(NSURLRequest *)aRequest
{
	if (self = [super init])
	{
		if (aRequest == nil)
		{
			NSLog(@"MPConnection: warning, cannot init with nil request, nil was returned");
			[self release];
			return nil;
		}
		
		theRequest = [aRequest retain];
		requestRuns = [[NSMutableArray alloc] init];
	}
	return self;
}
+ (id)connectionWithRequest:(NSURLRequest *)aRequest
{
	return [[[self alloc] initWithRequest:aRequest] autorelease];
}

#pragma mark Deallocator
- (void)dealloc
{
	[theRequest release];
	
	NSEnumerator *rns = [requestRuns objectEnumerator];
	NSDictionary *run;
	while (run = [rns nextObject])
		[[run objectForKey:@"NSURLConnection"] cancel];
	
	[requestRuns release];
	[super dealloc];
}

#pragma mark Properties
- (NSURLRequest *)request
{
	return theRequest;
}
- (id)delegate
{
	return delegate;
}
- (void)setDelegate:(id)theDelegate
{
	delegate = theDelegate;
}

#pragma mark Methods
- (void)beginRequestWithHandlerInvocation:(NSInvocation *)theInvocation
{
	[self _beginRequestWithHandlerInvocation:theInvocation userInfo:nil];
}
- (void)beginRequestWithTarget:(id)theTarget selector:(SEL)theSelector userInfo:(NSDictionary *)theUserInfo
{
	if (!theSelector)
	{
		NSLog(@"MPConnection: warning, nil selector specified, cannot begin request, cancelling");
		return;
	}
	
	NSInvocation *theInvocation = [NSInvocation invocationWithMethodSignature:[theTarget methodSignatureForSelector:theSelector]];
	[theInvocation setTarget:theTarget];
	[theInvocation setSelector:theSelector];
	[theInvocation setArgument:&theUserInfo atIndex:3];
	[theInvocation retainArguments];
	
	[self _beginRequestWithHandlerInvocation:theInvocation userInfo:theUserInfo];
}

#pragma mark Private methods
- (void)_beginRequestWithHandlerInvocation:(NSInvocation *)theInvocation userInfo:(NSDictionary *)userInfo
{
	if (!theInvocation)
	{
		NSLog(@"MPConnection: warning, nil invocation provided, cannot begin request, cancelling");
		return;
	}
	
	if (![__MPConnectionActiveList containsObject:self])
		[__MPConnectionActiveList addObject:self];
	
	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:theInvocation forKey:@"NSInvocation"];
	[info setObject:[NSMutableData data] forKey:@"NSMutableData"];
	if (userInfo)
		[info setObject:userInfo forKey:@"userInfo"];
	[requestRuns addObject:info];
	
	NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
	[info setObject:theConnection forKey:@"NSURLConnection"];
	[info release];
}
- (NSDictionary *)_runForConnection:(NSURLConnection *)theConnection
{
	NSEnumerator *rns = [requestRuns objectEnumerator];
	NSDictionary *run;
	while (run = [rns nextObject])
	{
		if ([run objectForKey:@"NSURLConnection"] == theConnection)
			return run;
	}
	return nil;
}

#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSDictionary *run = [self _runForConnection:connection];
	[[run objectForKey:@"NSMutableData"] setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSDictionary *run = [self _runForConnection:connection];
	[[run objectForKey:@"NSMutableData"] appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{	
	NSDictionary *run = [self _runForConnection:connection];
	
	if ([delegate respondsToSelector:@selector(connection:didFailWithError:userInfo:)])
	{
		NSDictionary *userInfo = ([[run allKeys] containsObject:@"userInfo"]) ? [run objectForKey:@"userInfo"] : nil;
		[delegate connection:connection didFailWithError:error userInfo:userInfo];
	}
	
	// clean-up
	[requestRuns removeObject:run];
	if ([requestRuns count] < 1)
		[__MPConnectionActiveList removeObject:self];
	
	NSLog(@"Uh oh, an error: %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSDictionary *run = [self _runForConnection:connection];
	
	NSData *data = [run objectForKey:@"NSMutableData"];
	NSInvocation *theInvocation = [run objectForKey:@"NSInvocation"];
	[theInvocation setArgument:&data atIndex:2];
	
	[theInvocation invoke];
	
	// clean-up
	[requestRuns removeObject:run];
	if ([requestRuns count] < 1)
		[__MPConnectionActiveList removeObject:self];
}

@end
