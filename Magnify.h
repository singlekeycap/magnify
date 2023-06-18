@import Foundation;
#import <UIKit/UIKit.h>

@interface SBIconListGridLayoutConfiguration : NSObject
@property (nonatomic) NSUInteger numberOfPortraitRows;
- (NSUInteger) numberOfPortraitColumns ;
@end

@interface SBRootFolderDockIconListView : UIView
@end

@interface SBIconView : UIView
@property (nonatomic, assign) NSString *location ;
- (CGSize) iconImageSize ;
@end