//
//  FeedTableViewCell.h
//  Hitch for iOS
//
//  Created by Robert Crosby on 11/18/16.
//  Copyright © 2016 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "References.h"

@interface FeedTableViewCell : UITableViewCell {
}
@property (weak, nonatomic) NSString *rideID;
@property (weak, nonatomic) IBOutlet UILabel *card;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *stops;
@property (weak, nonatomic) IBOutlet UILabel *when;
@property (weak, nonatomic) IBOutlet UILabel *seats;
@property (weak, nonatomic) IBOutlet UILabel *cost;
@property (weak, nonatomic) IBOutlet UILabel *sep;
@property (weak, nonatomic) IBOutlet UILabel *seatslabel;
@property (weak, nonatomic) IBOutlet UILabel *costlabel;




@end
