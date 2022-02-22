//
//  NJOutputKeyPress.m
//  Enjoy
//
//  Created by Sam McCall on 5/05/09.
//

#import "NJOutputKeyPress.h"
#include <Carbon/Carbon.h>

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
    return _firstKeyCode != NJKeyInputFieldEmpty && _secondKeyCode != NJKeyInputFieldEmpty && _thirdKeyCode != NJKeyInputFieldEmpty && _fourthKeyCode != NJKeyInputFieldEmpty && _firstKeyCode != 0 && _secondKeyCode != 0 &&  _thirdKeyCode != 0 && _fourthKeyCode != 0;
}

- (void)trigger {
	NSLog(@"trig");
    if (![self empty]) {
		NSLog(@"not empty");
        [self trigger:_firstKeyCode];
        [self trigger:_secondKeyCode];
        [self trigger:_thirdKeyCode];
        [self trigger:_fourthKeyCode];
    }
}

- (void) trigger:(CGKeyCode )key {
    if (key != NJKeyInputFieldEmpty && key != 0) {
        switch (key) {
            case kVK_Shift:
            case kVK_RightShift:
                _flags = _flags | kCGEventFlagMaskShift;
                break;
            case kVK_Command:
            case kVK_RightCommand:
                _flags = _flags | kCGEventFlagMaskCommand;
                break;
            case kVK_Control:
            case kVK_RightControl:
                _flags = _flags | kCGEventFlagMaskControl;
                break;
            case kVK_Option:
            case kVK_RightOption:
                _flags = _flags | kCGEventFlagMaskAlternate;
                break;
            case kVK_CapsLock:
                _flags = _flags | kCGEventFlagMaskAlphaShift;
                break;
            case kVK_Help:
                _flags = _flags | kCGEventFlagMaskHelp;
                break;
            case kVK_Function:
                _flags = _flags | kCGEventFlagMaskSecondaryFn;
                break;
            default:
                NSLog(@"event keydown sent %d %llu", key, _flags);
                CGEventRef keyDown = CGEventCreateKeyboardEvent(NULL, key, YES);
                CGEventSetFlags(keyDown, self.flags);
                CGEventPost(kCGHIDEventTap, keyDown);
                CFRelease(keyDown);
                break;
        }
    }
}

- (void) untrigger:(CGKeyCode )key {
    if (
        key != NJKeyInputFieldEmpty &&
        key != 0 &&
        key != kVK_Shift &&
        key != kVK_RightShift &&
        key != kVK_Command &&
        key != kVK_RightCommand &&
        key != kVK_Control &&
        key != kVK_RightControl &&
        key != kVK_Option &&
        key != kVK_RightOption &&
        key != kVK_CapsLock &&
        key != kVK_Help &&
        key != kVK_Function
        ) {
        CGEventRef keyUp = CGEventCreateKeyboardEvent(NULL, key, NO);
        CGEventSetFlags(keyUp, self.flags);
        CGEventPost(kCGHIDEventTap, keyUp);
        NSLog(@"event keyup sent %d", key);
        CFRelease(keyUp);
    }
}

- (void)untrigger {
	NSLog(@"untrig");
    [self untrigger:_fourthKeyCode];
    [self untrigger:_thirdKeyCode];
    [self untrigger:_secondKeyCode];
    [self untrigger:_firstKeyCode];
    self.flags = 0;
}

@end
