//
//  NotificationView.h
//  Hitch for iOS
//
//  Created by Robert Crosby on 5/1/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "UIColor+BFPaperColors.h"
#import "References.h"


@interface NotificationView : NSObject

+(UIView*)newView:(NSString*)title description:(NSString*)description;
+(CGFloat)screenWidth;
@end
