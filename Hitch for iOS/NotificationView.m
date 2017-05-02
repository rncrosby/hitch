//
//  NotificationView.m
//  Hitch for iOS
//
//  Created by Robert Crosby on 5/1/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "NotificationView.h"

@implementation NotificationView

+(UIView*)newView:(NSString*)title description:(NSString*)description{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(16, 26, [self screenWidth]-32, 50)];
    [view setBackgroundColor:[UIColor paperColorYellowA400]];
    [self cornerRadius:view radius:5.0f];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 3, [self screenWidth]-32, 30)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:26]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    [view bringSubviewToFront:titleLabel];
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 30, [self screenWidth]-32, 15)];
    [descriptionLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [descriptionLabel setTextColor:[UIColor whiteColor]];
    [descriptionLabel setText:description];
    [view addSubview:descriptionLabel];
    [view bringSubviewToFront:descriptionLabel];
    [view setHidden:YES];
    [References cardshadow:view];
    return view;
}

+(CGFloat)screenWidth {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat wid = screenSize.width;
    return wid;
}
                                                                
+(void)cornerRadius:(UIView *)view radius:(float)radius{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

                                                          
@end
