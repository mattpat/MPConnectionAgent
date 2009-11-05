//
//  AppController.m
//  MPConnectionAgent
//
//  Created by Matt Patenaude on 2/20/08.
//  Copyright 2008 - 09 Matt Patenaude. All rights reserved.
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
