//
//  RequestsViewController.m
//  Hitch for iOS
//
//  Created by Robert Crosby on 4/26/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "RequestsViewController.h"

@interface RequestsViewController ()

@end

@implementation RequestsViewController

- (void)viewDidLoad {
        [References createLine:self.view view:line xPos:menuBar.frame.origin.x yPos:menuBar.frame.origin.y+menuBar.frame.size.height+7];
    [References createLine:self.view view:line2 xPos:0 yPos:_tabBar.frame.origin.y];
    [References cornerRadius:_donebutton radius:5.0f];
    [self getRide];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RequestTableViewCell";
    
    RequestTableViewCell *cell = (RequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RequestTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    [References cornerRadius:cell.image radius:cell.image.frame.size.width/2];
    cell.image.image = [UIImage imageNamed:@"driver.jpg"];
    rideObject *ride = myRequests[indexPath.row];
    cell.recipient.text = [ride valueForKey:@"applicant"];
    cell.time.text = [ride valueForKey:@"text"];
    [References cornerRadius:cell.card radius:5.0f];
    cell.card.frame = CGRectMake(16, cell.card.frame.origin.y, [References screenWidth]-32, cell.card.frame.size.height);
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.decline.frame = CGRectMake(16, cell.decline.frame.origin.y, cell.card.frame.size.width/2, cell.decline.frame.size.height);
    cell.confirm.frame = CGRectMake(cell.card.frame.size.width/2, cell.confirm.frame.origin.y, cell.card.frame.size.width/2, cell.confirm.frame.size.height);
    [cell.confirm setTag:indexPath.row];
    [cell.confirm addTarget:self
                   action:@selector(confirmApplicant:)
         forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return myRequestsCount;    //count number of row from counting array hear cataGorry is An Array
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 195;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)getRide{
    myRequests = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5000/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"myRequests",
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
                                   myRequests_raw = [responseBody componentsSeparatedByString:@"~"];
                                   myRequestsCount = [myRequests_raw[0] intValue];
                                   int a = 0;
                                   for (int b = 0; b <myRequestsCount; b++) {
                                       rideObject *ride = [[rideObject alloc] init];
                                       ride.applicant = myRequests_raw[a+1];
                                       ride.rideID = myRequests_raw[a+2];
                                       ride.text = myRequests_raw[a+3];
                                       [myRequests addObject:ride];
                                       [_table reloadData];
                                   }
                                   
                               }}];
    
}

-(void)confirmApplicant:(UIButton *)sender {
    rideObject *ride = myRequests[sender.tag];
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5000/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"confirmRequest",
            @"user"     : [[NSUserDefaults standardUserDefaults] objectForKey:@"user"],
            @"applicant"     :[ride valueForKey:@"applicant"],
            @"rideID"   : [ride valueForKey:@"rideID"]
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
                                   if (myRequestsCount == 1) {
                                       notfication = [NotificationView newView:@"Ride Confirmed" description:@"The passenger has been notified" backgroundColor:[UIColor paperColorLightGreenA400]];
                                       [self.view addSubview:notfication];
                                       [self.view bringSubviewToFront:notfication];
                                       [References fromoffscreen:notfication where:@"TOP"];
                                       notificationTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                                            target:self
                                                                                          selector:@selector(hideNotification)
                                                                                          userInfo:nil
                                                                                           repeats:NO];


                                   } else {
                                       notfication = [NotificationView newView:@"Ride Confirmed" description:@"The passenger has been notified" backgroundColor:[UIColor paperColorLightGreenA400]];
                                       [self.view addSubview:notfication];
                                       [self.view bringSubviewToFront:notfication];
                                       [References fromoffscreen:notfication where:@"TOP"];
                                       notificationTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                                            target:self
                                                                                          selector:@selector(hideNotification)
                                                                                          userInfo:nil
                                                                                           repeats:NO];

                                       [self getRide];
                                   }
                                   
                                   
                                   
                               }}];

}

-(void)hideNotification {
    [References justMoveOffScreen:notfication where:@"TOP"];
    [notificationTimer invalidate];
}

@end
