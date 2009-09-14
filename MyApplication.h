//
//  MyApplication.h
//  iVoicer
//
//  Created by Jason Toy on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.

#import <Cocoa/Cocoa.h>
#import "HotKeyManager.h"

@interface MyApplication : NSApplication
{
	HotKeyManager* hotkey;
}

- (void)registerHotKey:(int)keyCode modifierFlags:(int)modFlags;
- (void)unregisterHotKey;

@end
