//
//  NJOutputKeyPress.m
//  Enjoy
//
//  Created by Sam McCall on 5/05/09.
//

#import "NJOutputKeyPress.h"

#import "NJKeyInputField.h"

@implementation NJOutputKeyPress

+ (NSString *)serializationCode {
    return @"key press";
}

- (NSDictionary *)serialize {
    return ![self empty]
    ? @{ @"type": self.class.serializationCode, @"first": @(_firstKeyCode), @"second": @(_secondKeyCode), @"third": @(_thirdKeyCode), @"fourth": @(_fourthKeyCode) }
        : nil;
}

+ (NJOutput *)outputWithSerialization:(NSDictionary *)serialization {
	NSLog(@"keypress outputw");
    NJOutputKeyPress *output = [[NJOutputKeyPress alloc] init];
    output.firstKeyCode = [serialization[@"first"] unsignedShortValue];
    output.secondKeyCode = [serialization[@"second"] unsignedShortValue];
    output.thirdKeyCode = [serialization[@"third"] unsignedShortValue];
    output.fourthKeyCode = [serialization[@"fourth"] unsignedShortValue];
    return output;
}

- (Boolean)empty {
    return _firstKeyCode != NJKeyInputFieldEmpty && _secondKeyCode != NJKeyInputFieldEmpty && _thirdKeyCode != NJKeyInputFieldEmpty && _fourthKeyCode != NJKeyInputFieldEmpty;
}

- (void)trigger {
	NSLog(@"trig");
    if (![self empty]) {
		NSLog(@"not empty");
        [NJOutputKeyPress trigger:_firstKeyCode];
        [NJOutputKeyPress trigger:_secondKeyCode];
        [NJOutputKeyPress trigger:_thirdKeyCode];
        [NJOutputKeyPress trigger:_fourthKeyCode];
    }
}

+ (void) trigger:(CGKeyCode )key {
    if (key != NJKeyInputFieldEmpty) {
        CGEventRef keyDown = CGEventCreateKeyboardEvent(NULL, key, YES);
        CGEventPost(kCGHIDEventTap, keyDown);
        NSLog(@"event keydown sent");
        CFRelease(keyDown);
    }
}

+ (void) untrigger:(CGKeyCode )key {
    if (key != NJKeyInputFieldEmpty) {
        CGEventRef keyUp = CGEventCreateKeyboardEvent(NULL, key, NO);
        CGEventPost(kCGHIDEventTap, keyUp);
        CFRelease(keyUp);
    }
}

- (void)untrigger {
	NSLog(@"untrig");
    [NJOutputKeyPress untrigger:_firstKeyCode];
    [NJOutputKeyPress untrigger:_secondKeyCode];
    [NJOutputKeyPress untrigger:_thirdKeyCode];
    [NJOutputKeyPress untrigger:_fourthKeyCode];
}

@end
