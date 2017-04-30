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
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ForecastKit.h"

@interface MessageViewController : UIViewController <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate> {
    int isPanel;
    rideObject *selectedTrip;
    NSMutableArray *myTrips;
    int myRides;
    NSArray *myTrips_raw;
    NSMutableArray *arrayOfMessages;
    NSMutableArray *arrayOfTripMessages;
    UIView *line,*line2,*line3;
    BOOL statusBarLight;
    bool pulltoscroll;
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
    __weak IBOutlet UIScrollView *tripView;
    
    __weak IBOutlet UIScrollView *tripDetailView;
    
    
    // TRIP VIEW STUFF
    int fromZip,toZip,seats,searchToZip,postalCode,cost;
    NSString *fromCity, *toCity,*properTime,*applyRideID;
    MKRoute *pastOverlay;
    // Ride Info
    MKDirectionsRequest *directionsRequest;
    CLLocation *startPoint,*endPoint;
    MKMapItem *startItem,*endItem;
    NSArray *info;
    int temperature;
    NSString *weatherInfo,*weatherIcon;
    NSTimer *havePoints;
    NSString *rideNumber;
    __weak IBOutlet UILabel *tripfounder;
    __weak IBOutlet MKMapView *routeView;
    __weak IBOutlet UILabel *routeCard;
    __weak IBOutlet UILabel *infoFrom;
    __weak IBOutlet UILabel *infoTo;
    __weak IBOutlet UILabel *infoCost;
    __weak IBOutlet UIButton *infoCar;
    __weak IBOutlet UILabel *infoMonth;
    __weak IBOutlet UILabel *infoDate;
    __weak IBOutlet UILabel *infoTime;
    __weak IBOutlet UILabel *infoTemperature;
    NSString *rideDriver;
    __weak IBOutlet UILabel *messageHeader;
}
- (IBAction)Done:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hideView;
- (IBAction)hideView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *requestsButton;
- (IBAction)showRequests:(id)sender;

@end
