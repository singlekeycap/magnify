#include "Magnify.h"

NSUserDefaults *prefs;
BOOL enableTweak;
int maxIcons = 5;

%group unlimitedDock

%hook SBIconListGridLayoutConfiguration

- (unsigned long long)numberOfPortraitColumns {
    unsigned long long o = %orig;
    if ([self numberOfPortraitRows] == 1 && o == 4) {
        return maxIcons;
    }
    return o;
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
