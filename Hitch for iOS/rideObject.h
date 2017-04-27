//
//  rideObject.h
//  Hitch for iOS
//
//  Created by Robert Crosby on 4/26/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rideObject : NSObject
@property NSString *founder, *applicant, *rideID,*from, *fullText, *text, *to, *day, *cost, *seats, *time, *month, *type;
@property NSArray *passengers;
@end
