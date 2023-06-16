#include "Magnify.h"

NSUserDefaults *prefs;
BOOL enableTweak;

%group unlimitedDock

%hook SBIconListGridLayoutConfiguration
- (NSUInteger)numberOfPortraitColumns {
    NSUInteger rows = MSHookIvar<NSUInteger>(self, "_numberOfPortraitRows");
    if (rows == 1) {
        return 16;
    }
    return %orig;
}
%end

%end

void updatePrefs(){
	[prefs registerDefaults:@{
		@"enableTweak": @FALSE
	}];

	enableTweak = [[prefs objectForKey:@"enableTweak"] boolValue];
}

%ctor {
	prefs = [[NSUserDefaults alloc] initWithSuiteName:@"one.keycap.magnify"];
	updatePrefs();

	if(enableTweak){
		%init(unlimitedDock);
	}
}
