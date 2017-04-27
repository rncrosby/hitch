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
    [conversationView setContentSize:CGSizeMake([References screenWidth], [References screenHeight])];
    [References createLine:self.view view:line xPos:menuBar.frame.origin.x yPos:menuBar.frame.origin.y+menuBar.frame.size.height+7];
    [References createLine:self.view view:line2 xPos:0 yPos:tabBar.frame.origin.y];
    [References createLine:self.view view:line3 xPos:tripBar.frame.origin.x yPos:tripBar.frame.origin.y+tripBar.frame.size.height+7];
    [References cornerRadius:Done radius:5.0f];
    [References borderColor:Done color:[UIColor blackColor]];
    [References cornerRadius:messageField radius:5.0f];
    conversations = [[NSMutableArray alloc] init];
    [super viewDidLoad];
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
    [References moveUp:_hideView yChange:225];
    [References moveUp:messageField yChange:225];
    conversationView.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]-225);
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [References moveDown:_hideView yChange:225];
    [References moveDown:messageField yChange:225];
    conversationView.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]);
    [textField resignFirstResponder];
    [self sendMessage:conversationOther.text message:textField.text];
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
    [References moveUp:conversationView yChange:667];
    [References moveUp:messageField yChange:667];
    [References moveUp:_hideView yChange:667];
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
    cell.plaintext.text = [ride valueForKey:@"fullText"];
    cell.drivername.text = [ride valueForKey:@"founder"];
    [References cornerRadius:cell.passenger1 radius:cell.passenger1.frame.size.height/2];
    [References cornerRadius:cell.passenger2 radius:cell.passenger2.frame.size.height/2];
    [References cornerRadius:cell.passenger3 radius:cell.passenger3.frame.size.height/2];
    if ([[ride valueForKey:@"type"] isEqualToString:@"PENDING"]) {
        [cell.card setBackgroundColor:[References colorFromHexString:@"#FEC432"]];
        [cell.plaintext setTextColor:[[UIColor blackColor]colorWithAlphaComponent:0.2f]];
        [cell.drivername setTextColor:[UIColor blackColor]];
    }
    return cell;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (statusBarLight == YES) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
    
}

-(void)getConversation:(NSString*)personA personB:(NSString*)personB{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5000/"];
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
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5000/"];
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
    [References moveDown:conversationView yChange:667];
    [References moveDown:messageField yChange:667];
    [References moveDown:_hideView yChange:667];
    for (int x = 0; x<=arrayOfMessages.count-1; x++) {
        [arrayOfMessages[x] removeFromSuperview];
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
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5000/"];
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
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5000/"];
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
                                       ride.to = myTrips_raw[a+4];
                                       double seconds = [myTrips_raw[a+5] doubleValue];
                                       NSTimeInterval timeInterval = (NSTimeInterval)seconds;
                                       NSDate *rideDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                                       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                       [formatter setDateFormat:@"LLL"];
                                       NSString *dateText = [formatter stringFromDate:rideDate];
                                       [formatter setDateFormat:@"d"];
                                       NSString *dateTime = [formatter stringFromDate:rideDate];
                                       [formatter setDateFormat:@"h:m a"];
                                       NSString *dateHour = [formatter stringFromDate:rideDate];
                                       ride.month = dateText;
                                       ride.time = dateHour;
                                       ride.day = dateTime;
                                       ride.cost = myTrips_raw[a+6];
                                       ride.seats = myTrips_raw[a+7];
                                       ride.rideID = myTrips_raw[a+8];
                                       ride.type = myTrips_raw[a+11];
                                       ride.passengers = nil;
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
                                       ride.fullText = [NSString stringWithFormat:@"%@, %@ %@ around %@ %@",[getDayName stringFromDate:rideDate],[getDayMonth stringFromDate:rideDate],[getDayNumber stringFromDate:rideDate],[getDayTime stringFromDate:rideDate],[getDayPeriod stringFromDate:rideDate]];
                                       [myTrips addObject:ride];
                                       [tripcollection reloadData];
                                   }
                                   
                               }}];
                               
}


- (IBAction)showRequests:(id)sender {
}
@end
