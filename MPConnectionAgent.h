//
//  MPConnectionAgent.h
//  MPConnectionAgent
//
//  Created by Matt Patenaude on 2/20/08.
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