//
//  FeedViewController.h
//  Hitch for iOS
//
//  Created by Robert Crosby on 11/15/16.
//  Copyright © 2016 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "References.h"
#import <CoreGraphics/CoreGraphics.h>
#import "FeedTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "RKDropdownAlert.h"
#import "MMMaterialDesignSpinner.h"
#import "UIColor+BFPaperColors.h"
#import "ForecastKit.h"


@interface FeedViewController : UIViewController <UIActionSheetDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIPickerViewDelegate> {
    BOOL statusBarLight;
    UIView *blackOverView;
    MMMaterialDesignSpinner *spinnerView;
    NSArray *rides;
    int fromZip,toZip,seats,searchToZip,postalCode,cost;
    NSString *fromCity, *toCity,*properTime,*applyRideID;
    NSDateFormatter *dateFormatted;
    NSDate *rideDateChosen;
    NSArray *dateChosen;
    UIDatePicker *whenDriving;
    UIPickerView *availableSeats;
    CGRect seatsLabel,seatsField,whenLabel,whenField,toLabel,toField;
    CLLocation *currentLocation;
    CLLocationManager *locationManager;
    NSString *addressFinal;
    NSString *area;
    _Bool areoff;
    CGPoint lastContentOffset;
    UIView *line,*line2;
    
    
    // VIEWS
    __weak IBOutlet UILabel *menuBar;
    __weak IBOutlet UITextField *destinationfield;
    __weak IBOutlet UITextField *startfield;
    __weak IBOutlet UITableView *table;
    // REQUEST/START VIEWS
    __weak IBOutlet UILabel *requestcard;
    __weak IBOutlet UILabel *requestFromLabel;
    __weak IBOutlet UILabel *requestToLabel;
    __weak IBOutlet UILabel *requestWhenLabel;
    __weak IBOutlet UILabel *requestSeatsLabel;
    __weak IBOutlet UITextField *requestFromField;
    __weak IBOutlet UITextField *requestToField;
    __weak IBOutlet UITextField *requestWhenField;
    __weak IBOutlet UITextField *requestSeatsField;
    __weak IBOutlet UIButton *incrementDown;
    __weak IBOutlet UIButton *incrementUp;
    __weak IBOutlet UILabel *costCard;
    __weak IBOutlet UILabel *costLabel;
    __weak IBOutlet UIScrollView *postCardScroll;
    __weak IBOutlet UIButton *postButton;
    __weak IBOutlet UIButton *cancelButton;
    
    // Tab Bar
    __weak IBOutlet UILabel *tabBar;
    __weak IBOutlet UILabel *tabBarUpper;
    __weak IBOutlet UIButton *aroundMe;
    __weak IBOutlet UIButton *Me;
    __weak IBOutlet UIButton *postRide;
    
    __weak IBOutlet UIButton *profile;
    
    
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
    __weak IBOutlet MKMapView *routeView;
    __weak IBOutlet UIScrollView *routeCardScroll;
    __weak IBOutlet UILabel *routeCard;
    __weak IBOutlet UILabel *infoFrom;
    __weak IBOutlet UILabel *infoTo;
    __weak IBOutlet UILabel *infoCost;
    __weak IBOutlet UIButton *infoCar;
    __weak IBOutlet UILabel *infoMonth;
    __weak IBOutlet UILabel *infoDate;
    __weak IBOutlet UILabel *infoTime;
    __weak IBOutlet UILabel *infoTemperature;
    __weak IBOutlet UITextField *messageBox;
    __weak IBOutlet UIButton *sendButton;
    NSString *rideDriver;
    __weak IBOutlet UIView *messagesView;
    __weak IBOutlet UIButton *rideConfirm;
    
}
- (IBAction)aroundMe:(id)sender;
- (IBAction)showMessages:(id)sender;
- (IBAction)postButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)startPost:(id)sender;
- (IBAction)incUp:(id)sender;
- (IBAction)incDown:(id)sender;
- (IBAction)cancelRideView:(id)sender;
- (IBAction)rideConfirm:(id)sender;











@end
