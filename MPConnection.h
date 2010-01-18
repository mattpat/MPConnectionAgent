//
//  MPConnection.h
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

#import <Foundation/Foundation.h>


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
