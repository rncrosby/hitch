//
//  MessageViewController.m
//  Hitch for iOS
//
//  Created by Robert Crosby on 12/9/16.
//  Copyright © 2016 Robert Crosby. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [References textFieldInset:messageField];
    arrayOfMessages = [[NSMutableArray alloc] init];
    arrayOfTripMessages = [[NSMutableArray alloc] init];
    [conversationView setContentSize:CGSizeMake([References screenWidth], [References screenHeight])];
    [References createLine:self.view view:line2 xPos:0 yPos:tabBar.frame.origin.y];
    if ([References screenHeight] == 568) {
            [References createLine:self.view view:line3 xPos:tripBar.frame.origin.x yPos:tripBar.frame.origin.y+tripBar.frame.size.height+0];
            [References createLine:self.view view:line xPos:menuBar.frame.origin.x yPos:menuBar.frame.origin.y+menuBar.frame.size.height+0];
    } else {
            [References createLine:self.view view:line3 xPos:tripBar.frame.origin.x yPos:tripBar.frame.origin.y+tripBar.frame.size.height+7];
            [References createLine:self.view view:line xPos:menuBar.frame.origin.x yPos:menuBar.frame.origin.y+menuBar.frame.size.height+7];
    }

    [References cornerRadius:Done radius:5.0f];
    [References borderColor:Done color:[UIColor blackColor]];
    [References cornerRadius:messageField radius:5.0f];
    conversations = [[NSMutableArray alloc] init];
    [References cornerRadius:routeView radius:5.0f];
    [References cornerRadius:routeCard radius:5.0f];
    [References cornerRadius:infoCost radius:5.0f];
    [References cornerRadius:infoMonth radius:5.0f];
    [References cornerRadius:infoDate radius:5.0f];
    [References cornerRadius:infoTime radius:5.0f];
    [References cornerRadius:infoTemperature radius:5.0f];
    [super viewDidLoad];
    tripDetailView.contentSize = CGSizeMake([References screenWidth]*2, 223);
    [tripDetailView setContentSize:CGSizeMake([References screenWidth]*2, 223)];
    [self getAllMessages];
    [self getRide];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [conversations count]-1;    //count number of row from counting array hear cataGorry is An Array
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (isPanel == 1) {
        [References moveUp:_hideView yChange:225];
        [References moveUp:messageField yChange:225];
        conversationView.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]-225);
    } else if (isPanel == 2) {
        [References moveUp:_hideView yChange:225];
        [References moveUp:messageField yChange:225];
        tripView.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]-225);
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (isPanel == 1) {
        [References moveDown:_hideView yChange:225];
        [References moveDown:messageField yChange:225];
        conversationView.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]);
        [textField resignFirstResponder];
        if (![textField.text isEqualToString:@""]) {
                    [self sendMessage:conversationOther.text message:textField.text];
        }
    } else if (isPanel == 2) {
        // SEND GROUP MESSAGE
        if (![textField.text isEqualToString:@""]) {
                [self sendGroupMessage:textField.text];
        }
        [References moveDown:_hideView yChange:225];
        [References moveDown:messageField yChange:225];
        tripView.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]);
        [textField resignFirstResponder];
    }
    return YES;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MessagesTableViewCell";
    
    MessagesTableViewCell *cell = (MessagesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessagesTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    [References cornerRadius:cell.card radius:5.0f];
    cell.card.frame = CGRectMake(16, cell.card.frame.origin.y, [References screenWidth]-32, cell.card.frame.size.height);
    NSLog(@"%@",conversations[indexPath.row]);
    
    NSArray *tempConversations = [conversations[indexPath.row] componentsSeparatedByString:@":"];
    if ([tempConversations[0] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]]) {
        cell.recipient.text = tempConversations[1];
    }
    if ([tempConversations[1] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]]) {
        cell.recipient.text = tempConversations[0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.card setBackgroundColor:[UIColor paperColorBlueA400]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 86;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    pulltoscroll = YES;
    isPanel = 1;
    NSArray *tempConversations = [conversations[indexPath.row] componentsSeparatedByString:@":"];
    [self getConversation:tempConversations[0] personB:tempConversations[1]];
    blackOverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], [References screenHeight])];
    [blackOverView setBackgroundColor:[UIColor blackColor]];
    [blackOverView setAlpha:0];
    [self.view addSubview:blackOverView];
    [self.view bringSubviewToFront:blackOverView];
    [self.view bringSubviewToFront:conversationView];
    [self.view bringSubviewToFront:messageField];
    [self.view bringSubviewToFront:_hideView];
    [References fade:blackOverView alpha:0.9f];
    if ([References screenHeight] == 568) {
        [References moveUp:conversationView yChange:568];
        [References moveUp:messageField yChange:568];
        [References moveUp:_hideView yChange:568];
    } else {
        [References moveUp:conversationView yChange:667];
        [References moveUp:messageField yChange:667];
        [References moveUp:_hideView yChange:667];
    }
    statusBarLight = YES;
    [UIView animateWithDuration:0.8 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return myRides;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TripCollectionViewCell *cell = (TripCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MyCustomCell" forIndexPath:indexPath];
    
    // configuring cell
    // cell.customLabel.text = [yourArray objectAtIndex:indexPath.row]; // comment this line if you do not want add label from storyboard
    
    // if you need to add label and other ui component programmatically
    cell.card.frame = CGRectMake(16, cell.card.frame.origin.y, [References screenWidth]-32, cell.card.frame.size.height);
    [References cornerRadius:cell.card radius:5.0f];
    [cell.driverpic setImage:[UIImage imageNamed:@"driver.jpg"]];
    [References cornerRadius:cell.driverpic radius:cell.driverpic.frame.size.width/2];
    rideObject *ride = myTrips[indexPath.row];
    cell.plaintext.text = [ride valueForKey:@"text"];
    cell.drivername.text = [ride valueForKey:@"founder"];
    cell.dateInfo.text = [ride valueForKey:@"fullText"];
    if ([[ride valueForKey:@"type"] isEqualToString:@"PENDING"]) {
        [cell.card setBackgroundColor:[References colorFromHexString:@"#FEC432"]];
        [cell.plaintext setTextColor:[[UIColor blackColor]colorWithAlphaComponent:0.2f]];
        [cell.drivername setTextColor:[UIColor blackColor]];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    rideObject *ride = myTrips[indexPath.row];
    [self getTrip:[ride valueForKey:@"rideID"]];
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

    isPanel = 2;
    blackOverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], [References screenHeight])];
    [blackOverView setBackgroundColor:[UIColor blackColor]];
    [blackOverView setAlpha:0];
    [self.view addSubview:blackOverView];
    [self.view bringSubviewToFront:blackOverView];
    [self.view bringSubviewToFront:tripView];
    [self.view bringSubviewToFront:messageField];
    [self.view bringSubviewToFront:_hideView];
    [References fade:blackOverView alpha:0.9f];
    if ([References screenHeight] == 568) {
        [References moveUp:tripView yChange:1136];
        [References moveUp:messageField yChange:568];
        [References moveUp:_hideView yChange:568];
    } else {
        [References moveUp:tripView yChange:1334];
        [References moveUp:messageField yChange:667];
        [References moveUp:_hideView yChange:667];
    }
    statusBarLight = YES;
    [UIView animateWithDuration:0.8 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (statusBarLight == YES) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
    
}

-(void)getConversation:(NSString*)personA personB:(NSString*)personB{
    NSURL *url = [NSURL URLWithString:[References backendAddress]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"getMessages",
            @"personA" : personA,
            @"personB" : personB
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
                                   NSArray *allMessages = [responseBody componentsSeparatedByString:@"~"];
                                   int startY = conversationOther.frame.origin.y + conversationOther.frame.size.height+13;
                                   for (int x = 0; x<allMessages.count-1; x++) {
                                       NSArray *message = [allMessages[x] componentsSeparatedByString:@":"];
                                       NSString *messageData = message[1];
                                       NSString *sender = message[0];
                                       NSString *reciever = message[2];
                                       
                                       
                                       int lineHeight = 25;
                                       int lineCount = 1;
                                       if (messageData.length > 25) {
                                           lineCount = 2;
                                           if (messageData.length > 50) {
                                               lineCount = 3;
                                           }
                                       }
                                       int bubbleSize = lineCount * lineHeight;
                                       UILabel *messageText = [[UILabel alloc] initWithFrame:CGRectMake(16, startY, [References screenWidth]-32,bubbleSize+6)];
                                       startY = messageText.frame.origin.y+15+bubbleSize;
                                       [messageText setNumberOfLines:lineCount];
                                       NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                                       style.alignment = NSTextAlignmentJustified;
                                       style.firstLineHeadIndent = 10.0f;
                                       style.headIndent = 10.0f;
                                       style.tailIndent = -10.0f;
                                       
                                       NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:messageData attributes:@{ NSParagraphStyleAttributeName : style}];
                                       
                                       messageText.attributedText = attrText;
                                       
                                       [messageText setFont:[UIFont boldSystemFontOfSize:20.0f]];
                                       if ([sender isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]]) {
                                           conversationOther.text = reciever;
                                           [messageText setBackgroundColor:[UIColor paperColorBlueA400]];
                                           [messageText setTextColor:[UIColor whiteColor]];
                                       } else {
                                           conversationOther.text = sender;
                                           [messageText setBackgroundColor:[UIColor paperColorGray100]];
                                           [messageText setTextColor:[UIColor blackColor]];
                                       }
                                       [arrayOfMessages addObject:messageText];
                                       [References cornerRadius:messageText radius:5.0f];
                                       [conversationView addSubview:messageText];
                                   }
                                   
                               }
                           }];
    
}

-(void)getAllMessages{
    NSURL *url = [NSURL URLWithString:[References backendAddress]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"getConversations",
            @"currentUser" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user"]
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
                                   NSArray *tempConversations = [responseBody componentsSeparatedByString:@"~"];
                                   for (int x = 0; x < tempConversations.count; x++) {
                                       if (conversations.count == 0) {
                                           [conversations addObject:tempConversations[x]];
                                           //NSLog(@"%@",tempConversations[x]);
                                       } else if (![conversations containsObject:tempConversations[x]]) {
                                           [conversations addObject:tempConversations[x]];
                                           //NSLog(@"%@",tempConversations[x]);
                                       }
                                   }
                                   [table reloadData];
                                   
                                   
                               }
                           }];
    
}

- (IBAction)Done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)hideView:(id)sender {
    [References fadeOut:blackOverView];
    if (isPanel == 1) {
        if ([References screenHeight] == 568) {
            [References moveDown:conversationView yChange:568];
        } else {
            [References moveDown:conversationView yChange:667];
        }
        for (int x = 0; x<=arrayOfMessages.count-1; x++) {
            [arrayOfMessages[x] removeFromSuperview];
        }
    } else if (isPanel == 2) {
        if ([References screenHeight] == 568) {
            [References moveDown:tripView yChange:1136];
        } else {
            [References moveDown:tripView yChange:1334];
        }
        for (int x = 0; x<=arrayOfTripMessages.count-1; x++) {
            [arrayOfTripMessages[x] removeFromSuperview];
        }
    }
    if ([References screenHeight] == 568) {
        [References moveDown:messageField yChange:568];
        [References moveDown:_hideView yChange:568];
    } else {
        [References moveDown:messageField yChange:667];
        [References moveDown:_hideView yChange:667];
    }
    [messageField setText:@""];
    statusBarLight = NO;
    [UIView animateWithDuration:0.8 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];

}

- (IBAction)ShowRequests:(id)sender {
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
                                   [self getConversation:driver personB:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
                               }
                           }];
    
}


-(void)getRide{
    myTrips = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:[References backendAddress]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"myTrips",
            @"user"     : [[NSUserDefaults standardUserDefaults] objectForKey:@"user"]
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
                                   myTrips_raw = [responseBody componentsSeparatedByString:@"~"];
                                   myRides = [myTrips_raw[1] intValue];
                                   if ([myTrips_raw[0] isEqualToString:@"Y"]) {
                                       [References fadeIn:_requestsButton];
                                   }
                                   int a = 1;
                                   for (int b = 0; b <myRides; b++) {
                                       rideObject *ride = [[rideObject alloc] init];
                                       ride.founder = myTrips_raw[a+1];
                                       ride.text = myTrips_raw[a+2];
                                       ride.from = myTrips_raw[a+3];
                                       ride.seats = myTrips_raw[a+8];
                                       ride.rideID = myTrips_raw[a+9];
                                       ride.type = myTrips_raw[a+11];
                                       ride.passengers = myTrips_raw[a+10];
                                       ride.fullText =myTrips_raw[a+3];
                                       [myTrips addObject:ride];
                                       a = 12;
                                       [tripcollection reloadData];
                                       
                                   }
                                   
                               }}];
                               
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


-(void)getTrip:(NSString*)queryNumber{
    pulltoscroll = YES;
    NSLog(@"ride id: %@",queryNumber);
    NSURL *url = [NSURL URLWithString:[References backendAddress]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"getTripPage",
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
                                   UIButton *imageLabel = [self.view viewWithTag:51];
                                   UILabel *namelabel = [self.view viewWithTag:52];
                                   UILabel *typeLabel = [self.view viewWithTag:53];
                                   int ridersCount = 4 + 1;
                                   for (int a = 1; a < ridersCount; a++) {
                                       int distancetomove = 200 * a;
                                       UIButton *newImageLabel = [[UIButton alloc] initWithFrame:CGRectMake(imageLabel.frame.origin.x + distancetomove, imageLabel.frame.origin.y, imageLabel.frame.size.width, imageLabel.frame.size.height)];
                                       [newImageLabel setBackgroundColor:[UIColor whiteColor]];
                                       [References cornerRadius:newImageLabel radius:newImageLabel.frame.size.width/2];
                                       UILabel *newNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(namelabel.frame.origin.x + distancetomove, namelabel.frame.origin.y, namelabel.frame.size.width, namelabel.frame.size.height)];
                                       [newNameLabel setFont:namelabel.font];
                                       [newNameLabel setText:@"Test Name"];
                                       [newNameLabel setTextColor:[UIColor whiteColor]];
                                       UILabel *mewTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(typeLabel.frame.origin.x + distancetomove, typeLabel.frame.origin.y, typeLabel.frame.size.width, typeLabel.frame.size.height)];
                                       [mewTypeLabel setFont:typeLabel.font];
                                       [mewTypeLabel setText:@"Passenger"];
                                       [mewTypeLabel setTextColor:[UIColor whiteColor]];
                                    [tripPeopleView addSubview:newImageLabel];
                                    [tripPeopleView addSubview:newNameLabel];
                                    [tripPeopleView addSubview:mewTypeLabel];
                                   }
                                   int frameSize = 200 * ridersCount;
                                   tripPeopleView.contentSize = CGSizeMake(frameSize, 47);
                                   
                                   selectedTrip = [[rideObject alloc] init];
                                   NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   info = [responseBody componentsSeparatedByString:@"~"];
                                   tripfounder.text = @"Test Name";//info[0];
                                   [References cornerRadius:imageLabel radius:imageLabel.frame.size.width/2];
                                   selectedTrip.cost =[NSString stringWithFormat:@"$%@",info[5]];
                                   selectedTrip.rideID = queryNumber;
                                   infoCost.text =[NSString stringWithFormat:@"$%@",info[5]];
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
                                   selectedTrip.month = dateText;
                                   selectedTrip.day = dateTime;
                                   selectedTrip.time = dateHour;
                                   infoMonth.text = dateText;
                                   infoTime.text = dateHour;
                                   infoDate.text = dateTime;
                                   selectedTrip.messages = info[6];
                                   NSArray *riders = [info[7] componentsSeparatedByString:@"%"];
                                   selectedTrip.passengers = riders;
                                   NSArray *ridemessages = [info[6] componentsSeparatedByString:@"%"];
                                   selectedTrip.messages = ridemessages;
                                   int messagesHeight = 0;
                                   // messages part
                                   int startY = messageHeader.frame.origin.y + messageHeader.frame.size.height;
                                   for (int x = 0; x<ridemessages.count-1; x++) {
                                       NSArray *message = [ridemessages[x] componentsSeparatedByString:@"&&"];
                                       NSString *messageData = message[0];
                                       NSString *sender = message[1];
                                       
                                       
                                       int lineHeight = 25;
                                       int lineCount = 1;
                                       if (messageData.length > 25) {
                                           lineCount = 2;
                                           if (messageData.length > 50) {
                                               lineCount = 3;
                                           }
                                       }
                                       int bubbleSize = lineCount * lineHeight;
                                       UILabel *messageText = [[UILabel alloc] initWithFrame:CGRectMake(16, startY, [References screenWidth]-32,bubbleSize+6)];
                                       startY = messageText.frame.origin.y+15+bubbleSize;
                                       [messageText setNumberOfLines:lineCount];
                                       NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                                       style.alignment = NSTextAlignmentJustified;
                                       style.firstLineHeadIndent = 10.0f;
                                       style.headIndent = 10.0f;
                                       style.tailIndent = -10.0f;
                                       
                                       NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:messageData attributes:@{ NSParagraphStyleAttributeName : style}];
                                       
                                       messageText.attributedText = attrText;
                                       
                                       [messageText setFont:[UIFont boldSystemFontOfSize:20.0f]];
                                       if ([sender isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]]) {
                                           [messageText setBackgroundColor:[UIColor paperColorBlueA400]];
                                           [messageText setTextColor:[UIColor whiteColor]];
                                       } else {
                                           [messageText setBackgroundColor:[UIColor paperColorGray100]];
                                           [messageText setTextColor:[UIColor blackColor]];
                                       }
                                       if (x > 1) {
                                           messagesHeight = messagesHeight + (int)messageText.frame.size.height;
                                       }
                                       [arrayOfTripMessages addObject:messageText];
                                       [References cornerRadius:messageText radius:5.0f];
                                       [tripView addSubview:messageText];
                                   }
                                   tripView.contentSize = CGSizeMake([References screenWidth], tripView.frame.size.height + messagesHeight - 50);
                                   // directions part
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

-(void)sendGroupMessage:(NSString*)message{
    NSURL *url = [NSURL URLWithString:[References backendAddress]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"sendGroupMessage",
            @"rideID" : [selectedTrip valueForKey:@"rideID"],
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
                                   for (int a = 0; a <arrayOfTripMessages.count; a++) {
                                       [arrayOfTripMessages[a] removeFromSuperview];
                                   }
                                   NSArray *ridemessages = [responseBody componentsSeparatedByString:@"%"];
                                   selectedTrip.messages = ridemessages;
                                   int messagesHeight = 0;
                                   // messages part
                                   int startY = messageHeader.frame.origin.y + messageHeader.frame.size.height;
                                   for (int x = 0; x<ridemessages.count-1; x++) {
                                       NSArray *message = [ridemessages[x] componentsSeparatedByString:@"&&"];
                                       NSString *messageData = message[0];
                                       NSString *sender = message[1];
                                       
                                       
                                       int lineHeight = 25;
                                       int lineCount = 1;
                                       if (messageData.length > 25) {
                                           lineCount = 2;
                                           if (messageData.length > 50) {
                                               lineCount = 3;
                                           }
                                       }
                                       int bubbleSize = lineCount * lineHeight;
                                       UILabel *messageText = [[UILabel alloc] initWithFrame:CGRectMake(16, startY, [References screenWidth]-32,bubbleSize+6)];
                                       startY = messageText.frame.origin.y+15+bubbleSize;
                                       [messageText setNumberOfLines:lineCount];
                                       NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                                       style.alignment = NSTextAlignmentJustified;
                                       style.firstLineHeadIndent = 10.0f;
                                       style.headIndent = 10.0f;
                                       style.tailIndent = -10.0f;
                                       
                                       NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:messageData attributes:@{ NSParagraphStyleAttributeName : style}];
                                       
                                       messageText.attributedText = attrText;
                                       
                                       [messageText setFont:[UIFont boldSystemFontOfSize:20.0f]];
                                       if ([sender isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]]) {
                                           [messageText setBackgroundColor:[UIColor paperColorBlueA400]];
                                           [messageText setTextColor:[UIColor whiteColor]];
                                       } else {
                                           [messageText setBackgroundColor:[UIColor paperColorGray100]];
                                           [messageText setTextColor:[UIColor blackColor]];
                                       }
                                       if (x > 1) {
                                           messagesHeight = messagesHeight + (int)messageText.frame.size.height;
                                       }
                                       [arrayOfTripMessages addObject:messageText];
                                       [References cornerRadius:messageText radius:5.0f];
                                       [tripView addSubview:messageText];
                                   }
                                   tripView.contentSize = CGSizeMake([References screenWidth], tripView.frame.size.height + messagesHeight - 50);
                                   [messageField setText:@""];
                                   [messageField setPlaceholder:@"Message Sent!"];
                               }
                           }];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float scrollOffsetY = scrollView.contentOffset.y;
    if((scrollOffsetY <= -100) && (pulltoscroll == YES))
    {
        [messageField setPlaceholder:@"Message"];
        pulltoscroll = NO;
        [References fadeOut:blackOverView];
        if (isPanel == 1) {
            if ([References screenHeight] == 568) {
                [References moveDown:conversationView yChange:568];
            } else {
                [References moveDown:conversationView yChange:667];
            }
            for (int x = 0; x<=arrayOfMessages.count-1; x++) {
                [arrayOfMessages[x] removeFromSuperview];
            }
        } else if (isPanel == 2) {
            if ([References screenHeight] == 568) {
                [References moveDown:tripView yChange:1136];
            } else {
                [References moveDown:tripView yChange:1334];
            }
            [routeView removeOverlay:pastOverlay.polyline];
            [routeView removeAnnotations:routeView.annotations];
            if (arrayOfTripMessages.count > 0) {
                for (int x = 0; x<=arrayOfTripMessages.count-1; x++) {
                    [arrayOfTripMessages[x] removeFromSuperview];
                }
            }

        }
        if ([References screenHeight] == 568) {
            [References moveDown:messageField yChange:568];
            [References moveDown:_hideView yChange:568];
        } else {
            [References moveDown:messageField yChange:667];
            [References moveDown:_hideView yChange:667];
        }
        [messageField setText:@""];
        statusBarLight = NO;
        [UIView animateWithDuration:0.8 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];

            }
}


- (IBAction)showRequests:(id)sender {
}
@end
