//
//  AppController.h
//  MPConnectionAgent
//
//  Created by Matt Patenaude on 2/20/08.
//  Copyright 2008 - 09 Matt Patenaude. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	IBOutlet NSImageView *imageView;
	IBOutlet NSTextField *imageURL;
}

- (IBAction)fetchImage:(id)sender;
- (IBAction)fetchImageOld:(id)sender;
- (void)setImage:(NSData *)imageData userInfo:(NSDictionary *)userInfo;

@end
