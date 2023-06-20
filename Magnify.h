@import Foundation;
#import <UIKit/UIKit.h>

@interface SBIconListGridLayoutConfiguration : NSObject
@property (readonly, nonatomic) NSUInteger numberOfPortraitRows;
@property (nonatomic) NSUInteger numberOfPortraitColumns;
@end

@interface SBIconListLayout : NSObject
@property (nonatomic) SBIconListGridLayoutConfiguration *layoutConfiguration ;
@end

@interface SBRootFolderDockIconListView : UIView
@property (readonly, nonatomic) SBIconListLayout *layout;
@property (nonatomic) NSUInteger maximumIconCount;
@end

@interface SBIconView : UIView
@property (nonatomic, assign) NSString *location ;
-(CGSize)iconImageSize ;
@end