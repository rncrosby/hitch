//
//  MessageViewController.h
//  Hitch for iOS
//
//  Created by Robert Crosby on 12/9/16.
//  Copyright © 2016 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "References.h"
#import "MessagesTableViewCell.h"
#import "UIColor+BFPaperColors.h"
#import "TripCollectionViewCell.h"
#import "rideObject.h"

@interface MessageViewController : UIViewController <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegate> {
    NSMutableArray *myTrips;
    int myRides;
    NSArray *myTrips_raw;
    NSMutableArray *arrayOfMessages;
    UIView *line,*line2,*line3;
    BOOL statusBarLight;
    __weak IBOutlet UILabel *tabBar;
    __weak IBOutlet UIButton *Done;
    __weak IBOutlet UILabel *menuBar;
    __weak IBOutlet UILabel *tripBar;
    __weak IBOutlet UITableView *table;
    NSMutableArray *conversations;
    __weak IBOutlet UICollectionView *tripcollection;
    UIView *blackOverView;
    __weak IBOutlet UIScrollView *conversationView;
    __weak IBOutlet UILabel *conversationOther;
    __weak IBOutlet UITextField *messageField;
}
- (IBAction)Done:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hideView;
- (IBAction)hideView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *requestsButton;
- (IBAction)showRequests:(id)sender;

@end
