//
//  MPConnectionAgent.h
//  MPConnectionAgent
//
//  Created by Matt Patenaude on 2/20/08.
//  Copyright 2008 - 09 Matt Patenaude. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MPConnectionAgent : NSObject {
	id delegate;
}

+ (id)sharedConnectionAgent;

- (id)delegate;
- (void)setDelegate:(id)newDelegate;

- (void)beginConnectionWithRequest:(NSURLRequest *)request target:(id)target selector:(SEL)selector userInfo:(NSDictionary *)userInfo;

// Selector Format:
// - (void)doingSomethingWith:(NSData *)response userInfo:(NSDictionary *)userInfo;
@end

@interface NSObject (MPConnectionAgentDelegate)

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error userInfo:(NSDictionary *)userInfo;

@end