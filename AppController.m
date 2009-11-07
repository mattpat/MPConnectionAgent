//
//  AppController.m
//  MPConnectionAgent
//
//  Created by Matt Patenaude on 2/20/08.
//  Copyright 2008 - 2009 Matt Patenaude. All rights reserved.
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

#import "AppController.h"
#import "MPConnection.h"
#import "MPConnectionAgent.h"


@implementation AppController

- (IBAction)fetchImage:(id)sender
{
	NSURL *myURL = [NSURL URLWithString:[imageURL stringValue]];
	NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
	
	// this is the new (and correct) way to use MPConnectionAgent
	// the MPConnectionAgent class is no longer necessary; instead,
	// everything is done with the new MPConnection class
	MPConnection *c = [MPConnection connectionWithRequest:request];
	[c beginRequestWithTarget:self selector:@selector(setImage:userInfo:) userInfo:nil];
}
- (IBAction)fetchImageOld:(id)sender
{
	NSURL *myURL = [NSURL URLWithString:[imageURL stringValue]];
	NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
	
	// this is the old way to use MPConnectionAgent
	// it still works, but is only for backwards compatibility
	// new code should use fetchImage: as a reference
	[[MPConnectionAgent sharedConnectionAgent] beginConnectionWithRequest:request target:self selector:@selector(setImage:userInfo:) userInfo:nil];
}

- (void)setImage:(NSData *)imageData userInfo:(NSDictionary *)userInfo
{
	NSImage *myImage = [[[NSImage alloc] initWithData:imageData] autorelease];
	[imageView setImage:myImage];
}

@end
