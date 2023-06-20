#include "Magnify.h"

NSUserDefaults *prefs;
BOOL enableTweak;
int maxIcons = 12;
int currentIcons = 5;

%group unlimitedDock

%hook SBIconListGridLayoutConfiguration

- (NSUInteger) numberOfPortraitColumns {
    NSUInteger o = %orig;

    if ([self numberOfPortraitRows] == 1) {
        if (currentIcons > maxIcons) {
            return maxIcons;
        }
        return currentIcons;
    }
    return o;
}

%end

%hook SBRootFolderDockIconListView

// THIS IS BROKEN, SAFE MODES WHEN YOU ADD/REMOVE AN ICON TO THE DOCK
- (NSUInteger) maximumIconCount {
    if (currentIcons > maxIcons) {
        return maxIcons;
    }
    return currentIcons;
}

- (void) iconList: (id)arg0 didAddIcon: (id) arg1 {
    %orig;
    if ((self.subviews.count + 1) == self.layout.layoutConfiguration.numberOfPortraitColumns) {
        currentIcons = self.subviews.count + 2;
    }
}

- (void) iconList: (id)arg0 didRemoveIcon: (id) arg1 {
    %orig;
    if ((self.subviews.count + 1) == self.layout.layoutConfiguration.numberOfPortraitColumns) {
        currentIcons = self.subviews.count;
    }
}

- (void) layoutSubviews {
    %orig;
    int dockWidth = self.superview.subviews[0].frame.size.width;
    int iconWidth = (dockWidth - ((dockWidth / 6.0) + ((dockWidth / 48.0) * [@(self.subviews.count) floatValue]))) / [@(self.subviews.count + 1) floatValue];
    if (iconWidth > 60) {
        iconWidth = 60;
    }

    for (SBIconView *iconView in self.subviews) {
        iconView.frame = CGRectMake(iconView.frame.origin.x, iconView.frame.origin.y, iconWidth, iconWidth);
        iconView.bounds = CGRectMake(0, 0, iconWidth, iconWidth);
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
