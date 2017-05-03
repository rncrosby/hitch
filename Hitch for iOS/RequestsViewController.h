//
//  RequestsViewController.h
//  Hitch for iOS
//
//  Created by Robert Crosby on 4/26/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestTableViewCell.h"
#import "References.h"
#import "rideObject.h"
#import "NotificationView.h"

@interface RequestsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSArray *myRequests_raw;
    NSMutableArray *myRequests;
    int myRequestsCount;
    UIView *line,*line2;
    __weak IBOutlet UILabel *menuBar;
    UIView *notfication;
    NSTimer *notificationTimer;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *donebutton;
@property (weak, nonatomic) IBOutlet UILabel *tabBar;

@end
