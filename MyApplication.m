//
//  MyApplication.m
//  iVoicer
//
//  Created by Jason Toy on 9/13/09.

#import "MyApplication.h"

@interface NSObject (MyApplicationDelegate)
- (void)applicationDidReceiveHotKey:(id)sender;
@end


@implementation MyApplication


- (void)dealloc
{
	[hotkey release];
	[super dealloc];
}

- (void)sendEvent:(NSEvent *)e
{
	if ([e type] == 14 && [e subtype] == 6) {
		if ([[self delegate] respondsToSelector:@selector(applicationDidReceiveHotKey:)]) {
			[[self delegate] applicationDidReceiveHotKey:self];
		}
	}
	
	[super sendEvent:e];
}

- (void)registerHotKey:(int)keyCode modifierFlags:(int)modFlags
{
	if (!hotkey) {
		hotkey = [HotKeyManager new];
	}
	[hotkey registerHotKeyCode:keyCode withModifier:modFlags];
}

- (void)unregisterHotKey
{
	if (hotkey) {
		[hotkey unregisterHotKey];
	}
}

@end
