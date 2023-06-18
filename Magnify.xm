#include "Magnify.h"

NSUserDefaults *prefs;
BOOL enableTweak;
int maxIcons = 6;

%group unlimitedDock

%hook SBIconListGridLayoutConfiguration

- (NSUInteger)numberOfPortraitColumns {
    NSUInteger o = %orig;

    if ([self numberOfPortraitRows] == 1) {
        return maxIcons;
    }
    return o;
}

%end

%hook SBRootFolderDockIconListView
- (void) layoutSubviews {
    %orig;
    int dockWidth = self.superview.subviews[0].frame.size.width;
    //int dockHeight = self.superview.subviews[0].frame.size.height;
    //int index = 0;

    for (SBIconView *iconView in self.subviews) {
        iconView.frame = CGRectMake(iconView.frame.origin.x, iconView.frame.origin.y, dockWidth * (1.0 / ((13.0/9.0) * self.subviews.count)), dockWidth * (1.0 / ((13.0/9.0) * self.subviews.count)));
        iconView.bounds = CGRectMake(0, 0, dockWidth * (1.0 / ((13.0/9.0) * self.subviews.count)), dockWidth * (1.0 / ((13.0/9.0) * self.subviews.count)));
        iconView.location = @"Dock";
    }
}
%end

%hook SBIconView

%property (nonatomic, assign) NSString *location;

- (CGSize) iconImageSize {
    if ([self.location isEqual:@"Dock"]) {
        return CGSizeMake(self.frame.size.width, self.frame.size.height);
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
