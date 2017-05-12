//
//  FeedViewController.m
//  Hitch for iOS
//
//  Created by Robert Crosby on 11/15/16.
//  Copyright © 2016 Robert Crosby. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

- (void)viewDidLoad {
    messagesView.frame = CGRectMake(-1*[References screenWidth], 0, [References screenWidth], messagesView.frame.size.height);
    cost = 5;
    statusBarLight = NO;
    searchToZip = 0;
    rides = [[NSArray alloc]init];
    dateChosen = [[NSArray alloc] init];
    dateFormatted = [[NSDateFormatter alloc] init];
    toLabel = requestToLabel.frame;
    toField = requestToField.frame;
    whenLabel = requestWhenLabel.frame;
    whenField = requestWhenField.frame;
    seatsLabel = requestSeatsLabel.frame;
    seatsField = requestSeatsField.frame;
    requestSeatsField.inputView = availableSeats;
    lastContentOffset = CGPointMake(0, 0);
    [startfield setValue:[UIColor blackColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    [destinationfield setValue:[UIColor blackColor]
              forKeyPath:@"_placeholderLabel.textColor"];
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    [References cornerRadius:postButton radius:5.0f];
    [NSTimer scheduledTimerWithTimeInterval:0.5f
                                     target:self
                                   selector:@selector(whereTo)
                                   userInfo:nil
                                    repeats:YES];
    line = [[UIView alloc] initWithFrame:CGRectMake(destinationfield.frame.origin.x, destinationfield.frame.origin.y+destinationfield.frame.size.height+7, 1000, 1)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    line.alpha = 0.5;
    [self.view addSubview:line];
    line2 = [[UIView alloc] initWithFrame:CGRectMake(0, tabBar.frame.origin.y, 1000, 1)];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    line2.alpha = 0.5;
    [self.view addSubview:line2];
    [self.view bringSubviewToFront:line2];
    [References cornerRadius:aroundMe radius:5.0f];
    [References cornerRadius:Me radius:5.0f];
    [References cornerRadius:postRide radius:5.0f];
    [References borderColor:Me color:[UIColor blackColor]];
    [References borderColor:postRide color:[UIColor blackColor]];
    [References borderColor:aroundMe color:[UIColor blackColor]];
    [postRide setBackgroundColor:[UIColor clearColor]];
    [Me setBackgroundColor:[UIColor clearColor]];
    [postRide setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Me setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [References cornerRadius:requestcard radius:5.0f];
    [References cornerRadius:costCard radius:5.0f];
    [References cornerRadius:incrementUp radius:incrementUp.frame.size.width/2];
    [References cornerRadius:incrementDown radius:incrementDown.frame.size.width/2];
    [postCardScroll setContentSize:CGSizeMake([References screenWidth], [References screenHeight])];
    [routeCardScroll setContentSize:CGSizeMake([References screenWidth], [References screenHeight])];
    routeCardScroll.frame = postCardScroll.frame;
    [References cornerRadius:routeView radius:5.0f];
    [References cornerRadius:routeCard radius:5.0f];
    [References cornerRadius:infoCost radius:5.0f];
    [References cornerRadius:infoMonth radius:5.0f];
    [References cornerRadius:infoDate radius:5.0f];
    [References cornerRadius:infoTime radius:5.0f];
    [References cornerRadius:infoTemperature radius:5.0f];
    [References cornerRadius:messageBox radius:5.0f];
    [References cornerRadius:sendButton radius:5.0f];
    [References cornerRadius:rideConfirm radius:5.0f];
    [References textFieldInset:messageBox];
    }

-(void)updateCost:(NSString*)how {
    if ([how isEqualToString:@"up"]) {
        cost++;
    } else {
        cost--;
    }
    costLabel.text = [NSString stringWithFormat:@"$%i",cost];
}

-(void)whereTo{
    if ([destinationfield.placeholder isEqualToString:@"Where To|" ]) {
        [destinationfield setPlaceholder:@"Where To"];
    } else if ([destinationfield.placeholder isEqualToString:@"Where To" ]){
        [destinationfield setPlaceholder:@"Where To|"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    //[References fadeIn:table];
    //[References fromoffscreen:card where:@"TOP"];
    //[References fromoffscreen:statusbar where:@"TOP"];
    //[References fromoffscreen:seperator where:@"TOP"];
    //[References fromoffscreen:destinationfield where:@"TOP"];
    //[References fromoffscreen:destinationbutton where:@"TOP"];
    //[References fromoffscreen:startfield where:@"TOP"];
    //[References fromoffscreen:startbutton where:@"TOP"];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (statusBarLight == YES) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag < 6) {
        if (textField.tag == 1) {
            /*
            [References moveBackDown:requestToField frame:toField];
            [References moveBackDown:requestToLabel frame:toLabel];
            [References moveBackDown:requestWhenField frame:whenField];
            [References moveBackDown:requestWhenLabel frame:whenLabel];
            [References moveBackDown:requestSeatsField frame:seatsField];
            [References moveBackDown:requestSeatsLabel frame:seatsLabel];
             */
        } else {
            /*
            [References moveBackDown:requestToField frame:toField];
            [References moveBackDown:requestToLabel frame:toLabel];
            [References moveBackDown:requestWhenField frame:whenField];
            [References moveBackDown:requestWhenLabel frame:whenLabel];
            [References moveBackDown:requestSeatsField frame:seatsField];
            [References moveBackDown:requestSeatsLabel frame:seatsLabel];
            [References fadeIn:requestFromField];
            [References fadeIn:requestFromLabel];
             */
        }
        if (textField.tag == 2) {
            // Look up by city or zip code
            CLGeocoder* geocoder = [CLGeocoder new];
            [geocoder geocodeAddressString:textField.text
                         completionHandler:^(NSArray* placemarks, NSError* error){
                             UIActionSheet* sheet = [[UIActionSheet alloc] init];
                             sheet.title = @"Is This Right?";
                             sheet.delegate = self;
                             CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             NSLog(@"the zipcode is %@",placemark.postalCode);
                             if (placemark.postalCode.integerValue > 100) {
                                 // FOUND ZIP CODE AND EVERYTHING
                                 NSString *toAddress = [NSString stringWithFormat:@"%@, %@ - %@", placemark.locality, placemark.administrativeArea, placemark.postalCode];
                                 toZip = placemark.postalCode.integerValue;
                                 [sheet addButtonWithTitle:toAddress];
                                 sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"None of these"];
                                 [sheet showInView:self.view];
                                 toCity = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
                                 // END FOUND ZIP CODE AND EVERYTHING
                             } else {
                                 
                                 // NO ZIP
                                 CLGeocoder* ageocoder = [CLGeocoder new];
                                 CLLocation* tempLocation = [[CLLocation alloc] initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];
                                 [ageocoder reverseGeocodeLocation:tempLocation completionHandler:^(NSArray *placemarks, NSError *error)
                                  {
                                      if (error == nil && [placemarks count] > 0)
                                      {
                                          
                                          CLPlacemark *aplacemark = [placemarks lastObject];
                                          NSString *toAddress = [NSString stringWithFormat:@"%@, %@ - %@", aplacemark.locality, aplacemark.administrativeArea, aplacemark.postalCode];
                                          toZip = aplacemark.postalCode.integerValue;
                                          [sheet addButtonWithTitle:toAddress];
                                          sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Not Quite"];
                                          [sheet showInView:self.view];
                                          toCity = [NSString stringWithFormat:@"%@, %@", aplacemark.locality, aplacemark.administrativeArea];
                                      }
                                  }];
                                 
                             }
                             
                             
                             
                         }];
        }
    }
    
    if (textField.tag == 6) {
        if (textField.text.length < 1) {
            [textField setPlaceholder:@"Where To|"];
        } else {
        // Initialize the progress view
        spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake([References screenWidth]/2-40, [References screenHeight]/2-40, 40, 40)];
        
        // Set the line width of the spinner
        spinnerView.lineWidth = 3.5f;
        [spinnerView setAlpha:0];
        // Set the tint color of the spinner
        spinnerView.tintColor = [UIColor paperColorGreen];
        
        [References fadeOut:table];
        [self.view addSubview:spinnerView];
        [References fadeIn:spinnerView];
        // Start & stop animations
        [spinnerView startAnimating];
        
        // DESTINATION CHANGED
        CLGeocoder* geocoder = [CLGeocoder new];
        [geocoder geocodeAddressString:textField.text
                     completionHandler:^(NSArray* placemarks, NSError* error){
                        CLPlacemark *placemark = [placemarks objectAtIndex:0];
                         NSLog(@"the zipcode is %@",placemark.postalCode);
                         if (placemark.postalCode.integerValue > 100) {
                             // FOUND ZIP CODE AND EVERYTHING
                             NSString *toAddress = [NSString stringWithFormat:@"%@", placemark.locality];
                             [destinationfield setText:toAddress];
                             searchToZip = placemark.postalCode.intValue;
                             
                             [self queryRide];
                             // END FOUND ZIP CODE AND EVERYTHING
                         } else {
                             NSLog(@"no zip");
                             // NO ZIP
                             CLGeocoder* ageocoder = [CLGeocoder new];
                             CLLocation* tempLocation = [[CLLocation alloc] initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];
                             [ageocoder reverseGeocodeLocation:tempLocation completionHandler:^(NSArray *placemarks, NSError *error)
                              {
                                  if (error == nil && [placemarks count] > 0)
                                  {
                                      
                                      CLPlacemark *aplacemark = [placemarks lastObject];
                                      NSString *toAddress = [NSString stringWithFormat:@"%@", placemark.locality];
                                      searchToZip = aplacemark.postalCode.intValue;
                                       [destinationfield setText:toAddress];
                                      [self queryRide];
                                  }
                              }];
                             
                         }
                         
                         
                         
                     }];
        }}
    if (textField.tag == 10) {
        [routeCardScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        if ([textField.text isEqualToString:@""]) {
            [textField setPlaceholder:@"Contact Driver"];
        } else {
            [self sendMessage:rideDriver message:textField.text];
        }
        
    }
    [textField resignFirstResponder];
    
    return YES;
}
             
-(void)sendMessage:(NSString*)driver message:(NSString*)message{
    NSURL *url = [NSURL URLWithString:[References backendAddress]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"sendMessage",
            @"reciever" : driver,
            @"sender" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user"],
            @"message" : message
            };
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   // Returned Error
                                   NSLog(@"Unknown Error Occured");
                               } else {
                                   NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"%@",responseBody);
                                   [messageBox setText:@""];
                                   [messageBox setPlaceholder:@"Message Sent!"];
                                   
                               }
                           }];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 6) {
        NSLog(@"hey");
        if (buttonIndex == 0) {
            NSArray *tempArray = [[actionSheet buttonTitleAtIndex:0] componentsSeparatedByString:@"-"];
            [destinationfield setText:[tempArray objectAtIndex:0]];
        }
    } else {
    if (buttonIndex == 0) {
        NSArray *tempArray = [[actionSheet buttonTitleAtIndex:0] componentsSeparatedByString:@"-"];
        [requestToField setText:[tempArray objectAtIndex:0]];
    }
    }
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        [textField setPlaceholder:@""];
    }
    if ((textField.tag == 2)) {
        /*
        int atoField = textField.frame.origin.y - requestFromField.frame.origin.y;
        int atoLabel = requestToLabel.frame.origin.y - requestFromLabel.frame.origin.y;
        [References moveUp:textField yChange:atoField];
        [References moveUp:requestToLabel yChange:atoLabel];
        [References fadeOut:requestFromField];
        [References fadeOut:requestFromLabel];
         */
    } else if ((textField.tag == 3) || (textField.tag == 4)) {
        /*
        int awhenLabel = requestWhenLabel.frame.origin.y - requestFromLabel.frame.origin.y;
        int awhenField = requestWhenField.frame.origin.y - requestFromField.frame.origin.y;
        int aseatsLabel = requestSeatsLabel.frame.origin.y - requestFromLabel.frame.origin.y;
        int aseatsField = requestSeatsField.frame.origin.y - requestFromField.frame.origin.y;
        [References moveUp:requestWhenLabel yChange:awhenLabel];
        [References moveUp:requestWhenField yChange:awhenField];
        [References moveUp:requestSeatsLabel yChange:aseatsLabel];
        [References moveUp:requestSeatsField yChange:aseatsField];
        [References fadeOut:requestFromField];
        [References fadeOut:requestFromLabel];
         */
    }
    if (textField.tag == 3) {
        
        UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], 44)];
        [toolBar setBarStyle:UIBarStyleDefault];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:@selector(seatsSelected:)];
        toolBar.items = @[flex, barButtonDone];
        barButtonDone.tintColor = [UIColor blackColor];
        
        whenDriving = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, toolBar.frame.size.height, [References screenWidth], 200)];
        
        [whenDriving addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], toolBar.frame.size.height + whenDriving.frame.size.height)];
        inputView.backgroundColor = [UIColor clearColor];
        [inputView addSubview:whenDriving];
        [inputView addSubview:toolBar];
        
        textField.inputView = inputView;
    }
    if (textField.tag == 4) {
        
        UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], 44)];
        [toolBar setBarStyle:UIBarStyleDefault];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:@selector(seatsSelected:)];
        toolBar.items = @[flex, barButtonDone];
        barButtonDone.tintColor = [UIColor blackColor];
        
        availableSeats = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolBar.frame.size.height, [References screenWidth], 200)];
        availableSeats.delegate = self;
        availableSeats.dataSource = self;
        availableSeats.showsSelectionIndicator = YES;
        
        
        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], toolBar.frame.size.height + availableSeats.frame.size.height)];
        inputView.backgroundColor = [UIColor clearColor];
        [inputView addSubview:availableSeats];
        [inputView addSubview:toolBar];
        
        textField.inputView = inputView;
    }
    if (textField.tag == 10) {
    [References fadeColor:sendButton color:[References colorFromHexString:@"#EE2B2A"]];
        [sendButton setTitle:@"STOP" forState:UIControlStateNormal];
        if ([References screenHeight] == 568) {
            [routeCardScroll setContentOffset:CGPointMake(0, 155) animated:YES];
        } else {
            
            [routeCardScroll setContentOffset:CGPointMake(0, 25) animated:YES];
        }
    }
    return YES;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [requestSeatsField setText:[NSString stringWithFormat:@"%ld",(long)[availableSeats selectedRowInComponent:0]]];
    seats = (int)[availableSeats selectedRowInComponent:0];
}


-(void)seatsSelected:(id)sender
{
    
    /*
    [References moveBackDown:requestToField frame:toField];
    [References moveBackDown:requestToLabel frame:toLabel];
    [References moveBackDown:requestWhenField frame:whenField];
    [References moveBackDown:requestWhenLabel frame:whenLabel];
    [References moveBackDown:requestSeatsField frame:seatsField];
    [References moveBackDown:requestSeatsLabel frame:seatsLabel];
    [References fadeIn:requestFromField];
    [References fadeIn:requestFromLabel];
     */
    [requestSeatsField resignFirstResponder];
    [requestWhenField resignFirstResponder];
    
}

-(void)onDatePickerValueChanged:(id)sender
{
    NSDateFormatter *getDayName = [[NSDateFormatter alloc] init];
    NSDateFormatter *getDayNumber = [[NSDateFormatter alloc] init];
    NSDateFormatter *getDayMonth = [[NSDateFormatter alloc] init];
    NSDateFormatter *getDayTime = [[NSDateFormatter alloc] init];
    NSDateFormatter *getDayPeriod = [[NSDateFormatter alloc] init];
    [getDayName setDateFormat:@"eee"];
    [getDayNumber setDateFormat:@"d"];
    [getDayMonth setDateFormat:@"MMM"];
    [getDayTime setDateFormat:@"h"];
    [getDayPeriod setDateFormat:@"a"];
    int a = arc4random_uniform(3);
    if (a == 0) {
        [requestWhenField setText:[NSString stringWithFormat:@"%@, %@ %@ at like %@ %@",[getDayName stringFromDate:whenDriving.date],[getDayMonth stringFromDate:whenDriving.date],[getDayNumber stringFromDate:whenDriving.date],[getDayTime stringFromDate:whenDriving.date],[getDayPeriod stringFromDate:whenDriving.date]]];
    } else if (a == 1) {
        [requestWhenField setText:[NSString stringWithFormat:@"%@, %@ %@ around %@ %@",[getDayName stringFromDate:whenDriving.date],[getDayMonth stringFromDate:whenDriving.date],[getDayNumber stringFromDate:whenDriving.date],[getDayTime stringFromDate:whenDriving.date],[getDayPeriod stringFromDate:whenDriving.date]]];
    } else if (a == 2) {
        [requestWhenField setText:[NSString stringWithFormat:@"%@, %@ %@ close to %@ %@",[getDayName stringFromDate:whenDriving.date],[getDayMonth stringFromDate:whenDriving.date],[getDayNumber stringFromDate:whenDriving.date],[getDayTime stringFromDate:whenDriving.date],[getDayPeriod stringFromDate:whenDriving.date]]];
    }
    rideDateChosen = whenDriving.date;
    properTime = requestWhenField.text;
}

-(void)uploadImage{
    UIImage * myImage = [UIImage imageNamed: @"testImage.jpg"];
    NSString *imageString = [UIImagePNGRepresentation(myImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSURL *url = [NSURL URLWithString:[References backendAddress]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"imageUpload",
            @"imageString" : imageString,
            @"username" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user"]
            };
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   
                               } else {
                                   NSLog(@"uploaded");
                               }
                           }];

    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 8;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%li",(long)row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rides.count-1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FeedTableViewCell";
    
    FeedTableViewCell *cell = (FeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    [References cornerRadius:cell.card radius:5.0f];
    cell.card.frame = CGRectMake(16, cell.card.frame.origin.y, [References screenWidth]-32, cell.card.frame.size.height);
    cell.cost.frame = CGRectMake([References screenWidth] - 16 - cell.cost.frame.size.width, cell.cost.frame.origin.y, cell.cost.frame.size.width, cell.cost.frame.size.height);
     NSArray *rideInfo = [rides[indexPath.row] componentsSeparatedByString:@"~"];
    cell.stops.text = rideInfo[1];
    cell.when.text = rideInfo[2];
    //cell.rideID = rideInfo[3];
    cell.cost.text = [NSString stringWithFormat:@"$%@",rideInfo[4]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.card setBackgroundColor:[UIColor paperColorGreenA400]];
    /*
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = cell.card.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor paperColorGreenA200] CGColor], (id)[[UIColor paperColorGreenA400] CGColor], nil];
    [cell.card.layer insertSublayer:gradient atIndex:0];
     */
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    pullToScrollFirst = YES;
    [routeView removeAnnotations:routeView.annotations];
    startItem = nil;
    endItem = nil;
    directionsRequest = [MKDirectionsRequest new];
    havePoints = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                  target:self
                                                selector:@selector(getDirections)
                                                userInfo:nil
                                                 repeats:YES];
    routeView.delegate = self;
    NSArray *rideInfo = [rides[indexPath.row] componentsSeparatedByString:@"~"];
    rideDriver = rideInfo[0];
    NSString *rideID = rideInfo[3];
    applyRideID = rideID;
    [self getRide:rideID];
    /*
    RideViewController *rideView = (RideViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ride"];
    //menu is only an example
    rideView.rideNumber = rideID;
    [self presentViewController:rideView animated:YES completion:nil];
    */
    table.userInteractionEnabled = NO;
    [References moveUp:routeCardScroll yChange:667];
    /*
     [References moveUp:requestcard yChange:667];
     [References moveUp:requestFromLabel yChange:667];
     [References moveUp:requestToLabel yChange:667];
     [References moveUp:requestWhenLabel yChange:667];
     [References moveUp:requestSeatsLabel yChange:667];
     [References moveUp:requestFromField yChange:667];
     [References moveUp:requestToField yChange:667];
     [References moveUp:requestWhenField yChange:667];
     [References moveUp:requestSeatsField yChange:667];
     [References moveUp:postButton yChange:667];
     [References moveUp:cancelButton yChange:667];
     [References moveUp:costLabel yChange:667];
     [References moveUp:incrementUp yChange:667];
     [References moveUp:costCard yChange:667];
     [References moveUp:incrementDown yChange:667];
     [References moveUp:tabBar yChange:350];
     [References moveUp:aroundMe yChange:350];
     [References moveUp:Me yChange:350];
     [References moveUp:postRide yChange:350];
     [References moveUp:line2 yChange:350];
     */
    // fade stuff
    [References fade:table alpha:.6];
    postRide.userInteractionEnabled = NO;
    Me.userInteractionEnabled = NO;
    aroundMe.userInteractionEnabled = NO;
    [References fade:destinationfield alpha:.6];
    [References fade:startfield alpha:.6];
    [References fade:aroundMe alpha:.6];
    [References fade:Me alpha:.6];
    [References fade:postRide alpha:.6];
    [References fadeButtonTextColor:postRide color:[UIColor whiteColor]];
    [References fadeColor:aroundMe color:[UIColor clearColor]];
    [References fadeColor:postRide color:[UIColor blackColor]];
    
    [References fadeButtonTextColor:aroundMe color:[UIColor blackColor]];
    
    // deactivate stuff
    destinationfield.userInteractionEnabled = YES;
    startfield.userInteractionEnabled = YES;
    blackOverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], [References screenHeight])];
    [blackOverView setBackgroundColor:[UIColor blackColor]];
    [blackOverView setAlpha:0];
    [self.view addSubview:blackOverView];
    [self.view bringSubviewToFront:blackOverView];
    [self.view bringSubviewToFront:routeCardScroll];
    [References fade:blackOverView alpha:0.9f];
    statusBarLight = YES;
    [UIView animateWithDuration:0.8 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (IBAction)reload:(id)sender {
    
    
}

- (IBAction)aroundMe:(id)sender {
    }

-(IBAction)showMessages:(id)sender{
  }

- (IBAction)postButton:(id)sender {
    [self postRide];
}

- (IBAction)cancelButton:(id)sender {
    [self postDone];
    }

- (IBAction)startPost:(id)sender {
        pullToScrollFirst = YES;
    table.userInteractionEnabled = NO;
    [References moveUp:postCardScroll yChange:667];
    /*
    [References moveUp:requestcard yChange:667];
    [References moveUp:requestFromLabel yChange:667];
    [References moveUp:requestToLabel yChange:667];
    [References moveUp:requestWhenLabel yChange:667];
    [References moveUp:requestSeatsLabel yChange:667];
    [References moveUp:requestFromField yChange:667];
    [References moveUp:requestToField yChange:667];
    [References moveUp:requestWhenField yChange:667];
    [References moveUp:requestSeatsField yChange:667];
    [References moveUp:postButton yChange:667];
    [References moveUp:cancelButton yChange:667];
    [References moveUp:costLabel yChange:667];
    [References moveUp:incrementUp yChange:667];
    [References moveUp:costCard yChange:667];
    [References moveUp:incrementDown yChange:667];
    [References moveUp:tabBar yChange:350];
    [References moveUp:aroundMe yChange:350];
    [References moveUp:Me yChange:350];
    [References moveUp:postRide yChange:350];
    [References moveUp:line2 yChange:350];
    */
    // fade stuff
    [References fade:table alpha:.6];
    postRide.userInteractionEnabled = NO;
    Me.userInteractionEnabled = NO;
    aroundMe.userInteractionEnabled = NO;
    [References fade:destinationfield alpha:.6];
    [References fade:startfield alpha:.6];
    [References fade:aroundMe alpha:.6];
    [References fade:Me alpha:.6];
    [References fade:postRide alpha:.6];
    [References fadeButtonTextColor:postRide color:[UIColor whiteColor]];
    [References fadeColor:aroundMe color:[UIColor clearColor]];
    [References fadeColor:postRide color:[UIColor blackColor]];
    
    [References fadeButtonTextColor:aroundMe color:[UIColor blackColor]];
    
    // deactivate stuff
    destinationfield.userInteractionEnabled = YES;
    startfield.userInteractionEnabled = YES;
    blackOverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], [References screenHeight])];
    [blackOverView setBackgroundColor:[UIColor blackColor]];
    [blackOverView setAlpha:0];
    [self.view addSubview:blackOverView];
    [self.view bringSubviewToFront:blackOverView];
    [self.view bringSubviewToFront:postCardScroll];
    [References fade:blackOverView alpha:0.9f];
    statusBarLight = YES;
    [UIView animateWithDuration:0.8 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (IBAction)incUp:(id)sender {
    [self updateCost:@"up"];
}

- (IBAction)incDown:(id)sender {
     [self updateCost:@"down"];
}

- (IBAction)cancelRideView:(id)sender {
    table.userInteractionEnabled = YES;
    [References moveDown:routeCardScroll yChange:667];
    [References fade:table alpha:1];
    postRide.userInteractionEnabled = YES;
    Me.userInteractionEnabled = YES;
    aroundMe.userInteractionEnabled = YES;
    [References fade:destinationfield alpha:1];
    [References fade:startfield alpha:1];
    [References fade:aroundMe alpha:1];
    [References fade:Me alpha:1];
    [References fade:postRide alpha:1];
    [References fadeOut:blackOverView];
    [References fadeColor:aroundMe color:[UIColor blackColor]];
    [References fadeColor:postRide color:[UIColor clearColor]];
    [References fadeButtonTextColor:aroundMe color:[UIColor whiteColor]];
    [References fadeButtonTextColor:postRide color:[UIColor blackColor]];
    
    // deactivate stuff
    destinationfield.userInteractionEnabled = YES;
    startfield.userInteractionEnabled = YES;
    statusBarLight = NO;
    [UIView animateWithDuration:0.8 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
    [routeView removeOverlay:pastOverlay.polyline];
    [routeView removeAnnotations:routeView.annotations];
}

-(void)checkApply{
    NSURL *url = [NSURL URLWithString:[References backendAddress]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"didAlreadyApply",
            @"rider" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user"]
            };
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   
                               } else {
                                   NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   if ([responseBody isEqualToString:@"Y"]) {
                                       [References fadeButtonColor:rideConfirm color:[References colorFromHexString:@"#FEC432"]];
                                       [References fadeButtonTextColor:rideConfirm color:[UIColor blackColor]];
                                       [rideConfirm setUserInteractionEnabled:NO];
                                       [rideConfirm setTitle:@"Ride Application Pending" forState:UIControlStateNormal];
                                   } else {
                                       [References fadeButtonColor:rideConfirm color:[References colorFromHexString:@"#00E676"]];
                                       [References fadeButtonTextColor:rideConfirm color:[UIColor whiteColor]];
                                       [rideConfirm setUserInteractionEnabled:YES];
                                       [rideConfirm setTitle:@"Yes, I want this ride" forState:UIControlStateNormal];
                                   }
                               }
                           }];
}

- (IBAction)rideConfirm:(id)sender {
    NSURL *url = [NSURL URLWithString:[References backendAddress]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"applyRide",
            @"rideID" : applyRideID,
            @"rider" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user"]
            };
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   
                               } else {
                                   [References fadeButtonColor:rideConfirm color:[References colorFromHexString:@"#FEC432"]];
                                   [References fadeButtonTextColor:rideConfirm color:[UIColor blackColor]];
                                   [rideConfirm setUserInteractionEnabled:NO];
                                   [rideConfirm setTitle:@"Ride Application Pending" forState:UIControlStateNormal];
                               }
                           }];
}

- (IBAction)cancelMessage:(id)sender {
    [messageBox resignFirstResponder];
    [routeCardScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [References fadeColor:sendButton color:[References colorFromHexString:@"#175FC7"]];
    [sendButton setTitle:@"SEND" forState:UIControlStateNormal];
    if ([messageBox.text isEqualToString:@""]) {
        [messageBox setPlaceholder:@"Contact Driver"];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    currentLocation = newLocation;
    if (newLocation != oldLocation) {
        CLLocation* eventLocation = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
        
        [self getAddressFromLocation:eventLocation complationBlock:^(NSString * address) {
            if(address) {
                addressFinal = address;
                [startfield setText:area];
                NSLog(@"%i",postalCode);
                [self queryRide];
            }
        }];
         [locationManager stopUpdatingLocation];
        
    }
   
}

typedef void(^addressCompletion)(NSString *);

-(void)getAddressFromLocation:(CLLocation *)location complationBlock:(addressCompletion)completionBlock
{
    __block CLPlacemark* placemark;
    __block NSString *address = nil;
    
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             address = [NSString stringWithFormat:@"%@, %@", placemark.name, placemark.locality];
             NSString *secondFormat = [NSString stringWithFormat:@"%@, %@ - %@", placemark.locality, placemark.administrativeArea, placemark.postalCode];
             
            
             fromCity = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
             requestFromField.text = [NSString stringWithFormat:@"%@, %@",placemark.locality,placemark.administrativeArea];
             area = placemark.locality;
             postalCode = [placemark.postalCode integerValue];
             fromZip = postalCode;
             completionBlock(secondFormat);
         }
     }];
}

-(void)postRide{
    if ((requestWhenField.text.length <1) || (requestToField.text.length <1) || (requestFromField.text.length <1)|| (requestSeatsField.text.length <1)) {
        [RKDropdownAlert title:@"Uh Oh..." message:@"Looks like you left one of the fields empty" backgroundColor:[UIColor paperColorRed500] textColor:[UIColor whiteColor] time:3];
    } else {
    NSTimeInterval seconds = [rideDateChosen timeIntervalSince1970];
    NSInteger time = round(seconds);
    NSURL *url = [NSURL URLWithString:[References backendAddress]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"postDrive",
            @"from" : @(fromZip),
            @"rideID" : [References randomStringWithLength:10],
            @"to" : @(toZip),
            @"username" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user"],
            @"date" : [NSString stringWithFormat:@"%ld",(long)time],
            @"seats" : @(seats),
            @"cost" : @(cost),
            @"text" : [NSString stringWithFormat:@"%@ to %@", fromCity,toCity],
            @"time" : [NSString stringWithFormat:@"%@",properTime]
            };
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   
                               } else {
                                   [self postDone];
                                   notfication = [NotificationView newView:@"Ride Posted" description:@"Thanks for using Hitch!" backgroundColor:[UIColor paperColorYellowA400]];
                                   [self.view addSubview:notfication];
                                   [self.view bringSubviewToFront:notfication];
                                   [References fromoffscreen:notfication where:@"TOP"];
                                   notificationTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                    target:self
                                                                  selector:@selector(hideNotification)
                                                                  userInfo:nil
                                                                   repeats:NO];
                                   [self queryRide];
                               }
                           }];
    }
}

-(void)hideNotification {
    [References justMoveOffScreen:notfication where:@"TOP"];
    [notificationTimer invalidate];
}

-(void)queryRide{
        NSURL *url = [NSURL URLWithString:[References backendAddress]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        // NSError *actualerror = [[NSError alloc] init];
        // Parameters
        NSDictionary *tmp = [[NSDictionary alloc] init];
        tmp = @{
                @"type"     : @"queryRides",
                @"from" : @(fromZip),
                @"to" : @(searchToZip)
                };
        
        NSError *error;
        NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        [request setHTTPBody:postdata];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *error) {
                                   if (error) {
                                       // Returned Error
                                       NSLog(@"Unknown Error Occured");
                                        } else {
                                       NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                            NSLog(@"ayy %@",responseBody);
                                       rides = [responseBody componentsSeparatedByString:@"%"];
                                            [table reloadData];
                                           
                                            
                                            [spinnerView stopAnimating];
                                            [References fadeIn:table];
                                    }
                               }];
    
    }


-(void)postDone{
    table.userInteractionEnabled = YES;
    [References moveDown:postCardScroll yChange:667];
    /*
     [References moveDown:requestcard yChange:667];
     [References moveDown:requestFromLabel yChange:667];
     [References moveDown:requestToLabel yChange:667];
     [References moveDown:requestWhenLabel yChange:667];
     [References moveDown:requestSeatsLabel yChange:667];
     [References moveDown:requestFromField yChange:667];
     [References moveDown:requestToField yChange:667];
     [References moveDown:requestWhenField yChange:667];
     [References moveDown:requestSeatsField yChange:667];
     [References moveDown:postButton yChange:667];
     [References moveDown:cancelButton yChange:667];
     [References moveDown:costLabel yChange:667];
     [References moveDown:incrementUp yChange:667];
     [References moveDown:costCard yChange:667];
     [References moveDown:incrementDown yChange:667];
     
     [References moveDown:tabBar yChange:550];
     [References moveDown:aroundMe yChange:550];
     [References moveDown:Me yChange:550];
     [References moveDown:postRide yChange:550];
     [References moveDown:line yChange:550];
     */
    // fade stuff
    [References fade:table alpha:1];
    postRide.userInteractionEnabled = YES;
    Me.userInteractionEnabled = YES;
    aroundMe.userInteractionEnabled = YES;
    [References fade:destinationfield alpha:1];
    [References fade:startfield alpha:1];
    [References fade:aroundMe alpha:1];
    [References fade:Me alpha:1];
    [References fade:postRide alpha:1];
    [References fadeOut:blackOverView];
    [References fadeColor:aroundMe color:[UIColor blackColor]];
    [References fadeColor:postRide color:[UIColor clearColor]];
    [References fadeButtonTextColor:aroundMe color:[UIColor whiteColor]];
    [References fadeButtonTextColor:postRide color:[UIColor blackColor]];
    
    // deactivate stuff
    destinationfield.userInteractionEnabled = YES;
    startfield.userInteractionEnabled = YES;
    statusBarLight = NO;
    [UIView animateWithDuration:0.8 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

-(void)getDirections{
    if ((startItem) && (endItem)) {
        // REQUEST DIRECTION
        [havePoints invalidate];
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            // Now handle the result
            if (error) {
                NSLog(@"There was an error getting your directions");
                return;
            }
            
            // So there wasn't an error - let's plot those routes
            [self plotRouteOnMap:[response.routes firstObject]];
        }];
        // REQUEST WEATHER
        ForecastKit *forecast = [[ForecastKit alloc] initWithAPIKey:@"a9c6314513fed53054145f28852a3388"];
        
        [forecast getCurrentConditionsForLatitude:endPoint.coordinate.latitude longitude:endPoint.coordinate.longitude success:^(NSMutableDictionary *responseDict) {
            
            temperature = [[responseDict objectForKey:@"temperature"] intValue];
            weatherInfo = [responseDict objectForKey:@"summary"];
            weatherIcon = [responseDict objectForKey:@"icon"];
            infoTemperature.text = [NSString stringWithFormat:@"%iº",temperature];
            
        } failure:^(NSError *error){
            
            NSLog(@"Currently %@", error.description);
            
        }];
        
    }
}

- (void)plotRouteOnMap:(MKRoute *)route
{
    
    // Add it to the map
    [routeView addOverlay:route.polyline];
    pastOverlay = route;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [[UIColor paperColorBlueA400] colorWithAlphaComponent:0.5];
    renderer.lineWidth = 4.0;
    MKCoordinateRegion region = [self regionForAnnotations:[routeView annotations]];
    [routeView setRegion:region animated:YES];
    return  renderer;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    if ([[annotation title] isEqualToString:@"End"]) {
        annView.pinColor = MKPinAnnotationColorGreen;
    } else {
        annView.pinColor = MKPinAnnotationColorRed;
    }
    
    return annView;
}

-(void)createAbbreviation:(NSString*)city label:(UILabel*)label{
    NSArray *words = [city componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([words count] == 1) {
        NSString *shortened =[words[0] substringToIndex:3];
        label.text = [shortened uppercaseString];
    } else if ([city isEqualToString:@"San Francisco"]) {
        label.text = @"SFO";
    }
    else if ([words count] == 2) {
        NSString *shortened = [NSString stringWithFormat:@"%@%@",[words[0] substringToIndex:1],[words[1] substringToIndex:1]];
        label.text = [shortened uppercaseString];
    } else {
        NSString *shortened = [NSString stringWithFormat:@"%@%@%@",[words[0] substringToIndex:1],[words[1] substringToIndex:1],[words[2] substringToIndex:1]];
        label.text = [shortened uppercaseString];
    }
    
}

- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations
{
    MKCoordinateRegion region;
    
    if ([annotations count] == 0)
    {
        region = MKCoordinateRegionMakeWithDistance(routeView.userLocation.coordinate, 1000, 1000);
    }
    
    else if ([annotations count] == 1)
    {
        id <MKAnnotation> annotation = [annotations lastObject];
        region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000);
    } else {
        CLLocationCoordinate2D topLeftCoord;
        topLeftCoord.latitude = -135;
        topLeftCoord.longitude = 225;
        
        CLLocationCoordinate2D bottomRightCoord;
        bottomRightCoord.latitude = 135;
        bottomRightCoord.longitude = -225;
        
        for (id <MKAnnotation> annotation in annotations)
        {
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        }
        
        const double extraSpace = 1.62;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2.0;
        region.center.longitude = topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2.0;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace;
        region.span.longitudeDelta = fabs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace;
    }
    
    return [routeView regionThatFits:region];
}

-(void)getRide:(NSString*)queryNumber{
    
    NSURL *url = [NSURL URLWithString:[References backendAddress]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"getRide",
            @"ID" : queryNumber
            };
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   // Returned Error
                                   NSLog(@"Unknown Error Occured");
                               } else {
                                   [self checkApply];
                                   NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   info = [responseBody componentsSeparatedByString:@"~"];
                                   NSString *icost = [NSString stringWithFormat:@"$%@",info[5]];
                                   infoCost.text = icost;
                                   double seconds = [info[4] doubleValue];
                                   NSLog(@"%f",seconds);
                                   NSTimeInterval timeInterval = (NSTimeInterval)seconds;
                                   NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                                   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                   [formatter setDateFormat:@"LLL"];
                                   NSString *dateText = [formatter stringFromDate:date];
                                   [formatter setDateFormat:@"d"];
                                   NSString *dateTime = [formatter stringFromDate:date];
                                   [formatter setDateFormat:@"h:m a"];
                                   NSString *dateHour = [formatter stringFromDate:date];
                                   infoMonth.text = dateText;
                                   infoDate.text = dateTime;
                                   infoTime.text = dateHour;
                                   CLGeocoder* geocoder = [CLGeocoder new];
                                   [geocoder geocodeAddressString:info[2]
                                                completionHandler:^(NSArray* placemarks, NSError* error){
                                                    CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                                    [self createAbbreviation:placemark.locality label:infoFrom];
                                                    startPoint = placemark.location;
                                                    MKPlacemark *place = [[MKPlacemark alloc] initWithPlacemark:placemark];
                                                    startItem = [[MKMapItem alloc]initWithPlacemark:place];
                                                    [directionsRequest setSource:startItem];
                                                    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                                                    point.coordinate = placemark.location.coordinate;
                                                    point.title = @"Start";
                                                    [routeView addAnnotation:point];
                                                }];
                                   CLGeocoder* geocoder2 = [CLGeocoder new];
                                   [geocoder2 geocodeAddressString:info[3]
                                                 completionHandler:^(NSArray* placemarks, NSError* error){
                                                     CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                                     [self createAbbreviation:placemark.locality label:infoTo];
                                                     endPoint = placemark.location;
                                                     MKPlacemark *place = [[MKPlacemark alloc] initWithPlacemark:placemark];
                                                     endItem = [[MKMapItem alloc]initWithPlacemark:place];
                                                     [directionsRequest setDestination:endItem];
                                                     MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                                                     point.coordinate = placemark.location.coordinate;
                                                     point.title = @"End";
                                                     [routeView addAnnotation:point];
                                                 }];
                                   
                               }
                           }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float scrollOffsetY = scrollView.contentOffset.y;
    NSLog(@"%f",scrollOffsetY);
    if((scrollOffsetY <= -100) && (pullToScrollFirst == YES))
    {
        if (routeCardScroll.frame.origin.y == 0) {
            pullToScrollFirst = NO;
            table.userInteractionEnabled = YES;
            [References moveDown:routeCardScroll yChange:667];
            [References fade:table alpha:1];
            postRide.userInteractionEnabled = YES;
            Me.userInteractionEnabled = YES;
            aroundMe.userInteractionEnabled = YES;
            [References fade:destinationfield alpha:1];
            [References fade:startfield alpha:1];
            [References fade:aroundMe alpha:1];
            [References fade:Me alpha:1];
            [References fade:postRide alpha:1];
            [References fadeOut:blackOverView];
            [References fadeColor:aroundMe color:[UIColor blackColor]];
            [References fadeColor:postRide color:[UIColor clearColor]];
            [References fadeButtonTextColor:aroundMe color:[UIColor whiteColor]];
            [References fadeButtonTextColor:postRide color:[UIColor blackColor]];
            
            // deactivate stuff
            destinationfield.userInteractionEnabled = YES;
            startfield.userInteractionEnabled = YES;
            statusBarLight = NO;
            [UIView animateWithDuration:0.8 animations:^{
                [self setNeedsStatusBarAppearanceUpdate];
            }];
            [routeView removeOverlay:pastOverlay.polyline];
            [routeView removeAnnotations:routeView.annotations];
        } else if (postCardScroll.frame.origin.y == 0) {
            pullToScrollFirst = NO;
            [self postDone];
        }
    }
}


@end
