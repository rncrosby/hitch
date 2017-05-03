//
//  ViewController.m
//  Hitch for iOS
//
//  Created by Robert Crosby on 11/15/16.
//  Copyright © 2016 Robert Crosby. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [emailfield setText:@""];
    [passwordfield setText:@""];
    [References cardshadow:accessResult];
    [References textFieldInset:emailfield];
    [References textFieldInset:passwordfield];
    [References justMoveOffScreen:accessResult where:@"BOTTOM"];
    [super viewDidLoad];
    [References createLine:self.view view:line xPos:descrip.frame.origin.x yPos:descrip.frame.origin.y+descrip.frame.size.height];
    [line setBackgroundColor:[UIColor whiteColor]];
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    bgVideo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], [References screenHeight])];
    //Set up player
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"vid" ofType:@"mp4"]];
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [bgVideo.layer addSublayer:avPlayerLayer];
    [self.view addSubview:bgVideo];
    [self.view sendSubviewToBack:bgVideo];
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    [References cornerRadius:card radius:5.0f];
    [References cornerRadius:accessResult radius:5.0f];
}


-(void)viewDidAppear:(BOOL)animated{
    [References fadeIn:emailfield];
    [References fadeIn:signinbutton];
    [References fadeIn:signupbutton];
    [References fadeIn:passwordfield];
    [References fadeIn:firsttime];
    [References fadeIn:titl];
    [References fadeIn:descrip];
    [self.avplayer play];
    [emailfield setValue:[UIColor whiteColor]
              forKeyPath:@"_placeholderLabel.textColor"];
    [passwordfield setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    [References textFieldInset:emailfield];
    [References textFieldInset:passwordfield];
//    AUTO SIGN IN
    [emailfield setText:@"rob"];
    [passwordfield setText:@"pass"];
    [self signin:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)playerStartPlaying
{
    [self.avplayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (IBAction)signin:(id)sender {
    if ((emailfield.text.length < 1) || (passwordfield.text.length <1)) {
        [References justMoveOnScreen:accessResult where:@"BOTTOM"];
        // ERROR SIGNING UP
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Here your non-main thread.
            [NSThread sleepForTimeInterval:1.0f];
            dispatch_async(dispatch_get_main_queue(), ^{
                //Here you returns to main thread.
                [References fadeThenMove:accessResult where:@"BOTTOM"];
            });
        });
    } else {
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5000/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"type"     : @"signin",
            @"username" : emailfield.text,
            @"password" : passwordfield.text
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
                                   accessResult.text = @"Unknown Error Occured";
                                   [References justMoveOnScreen:accessResult where:@"BOTTOM"];
                                   
                                   // ERROR SIGNING UP
                                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                       //Here your non-main thread.
                                       [NSThread sleepForTimeInterval:1.0f];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           //Here you returns to main thread.
                                           [References fadeThenMove:accessResult where:@"BOTTOM"];
                                       });
                                   });
                               } else {
                                   
                                   // Success, get return text
                                   NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"%@",responseBody);
                                   accessResult.text = responseBody;
                                   [References justMoveOnScreen:accessResult where:@"BOTTOM"];
                                   
                                   if ([responseBody characterAtIndex:0] != 'S') {
                                       // ERROR SIGNING IN
                                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                           //Here your non-main thread.
                                           [NSThread sleepForTimeInterval:1.0f];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               //Here you returns to main thread.
                                               [References fadeThenMove:accessResult where:@"BOTTOM"];
                                           });
                                       });
                                       
                                   } else {
                                       [[NSUserDefaults standardUserDefaults] setObject:emailfield.text forKey:@"user"];
                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       // SUCCESS SIGNING IN
                                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                           //Here your non-main thread.
                                           [NSThread sleepForTimeInterval:1.0f];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               //Here you returns to main thread.
                                               [References fadeOut:titl];
                                               [References fadeOut:descrip];
                                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                   //Here your non-main thread.
                                                   [NSThread sleepForTimeInterval:0.5f];
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       //Here you returns to main thread.
                                                       [References fromonscreen:firsttime where:@"TOP"];
                                                       [References fromonscreen:card where:@"TOP"];
                                                       [References fromonscreen:accessResult where:@"TOP"];
                                                       [References fromonscreen:emailfield where:@"TOP"];
                                                       [References fromonscreen:passwordfield where:@"TOP"];
                                                       [References fromonscreen:signinbutton where:@"TOP"];
                                                       [References fromonscreen:signupbutton where:@"TOP"];
                                                       [References fromonscreen:signupbutton where:@"TOP"];
                                                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                           //Here your non-main thread.
                                                           [NSThread sleepForTimeInterval:1.0f];
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               //Here you returns to main thread.
                                                               NSString * storyboardName = @"Main";
                                                               UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                                                               UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"Feed"];
                                                               [self presentViewController:vc animated:NO completion:nil];
                                                           });
                                                       });
                                                   });
                                               });
                                               
                                           });
                                       });
                                       // END SUCCESS SIGNING IN
                                   }
                                   
                               }
                           }];
    }
}

- (IBAction)signup:(id)sender {
    if ((emailfield.text.length < 1) || (passwordfield.text.length <1)) {
        [References justMoveOnScreen:accessResult where:@"BOTTOM"];
        // ERROR SIGNING UP
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Here your non-main thread.
            [NSThread sleepForTimeInterval:1.0f];
            dispatch_async(dispatch_get_main_queue(), ^{
                //Here you returns to main thread.
                [References fadeThenMove:accessResult where:@"BOTTOM"];
            });
        });
    } else {
        NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5000/"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        // NSError *actualerror = [[NSError alloc] init];
        // Parameters
        NSDictionary *tmp = [[NSDictionary alloc] init];
        tmp = @{
                @"type"     : @"signup",
                @"username" : emailfield.text,
                @"password" : passwordfield.text
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
                                       accessResult.text = @"Unknown Error Occured";
                                       [References justMoveOnScreen:accessResult where:@"BOTTOM"];
                                       // ERROR SIGNING UP
                                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                           //Here your non-main thread.
                                           [NSThread sleepForTimeInterval:1.0f];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               //Here you returns to main thread.
                                               [References fadeThenMove:accessResult where:@"BOTTOM"];
                                           });
                                       });
                                   } else {
                                       // Success, get return text
                                       NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"%@",responseBody);
                                       accessResult.text = responseBody;
                                       [References justMoveOnScreen:accessResult where:@"BOTTOM"];
                                       if ([responseBody characterAtIndex:0] != 'T') {
                                           // ERROR SIGNING UP
                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                               //Here your non-main thread.
                                               [NSThread sleepForTimeInterval:1.0f];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   //Here you returns to main thread.
                                                   [References fadeThenMove:accessResult where:@"BOTTOM"];
                                               });
                                           });
                                           
                                       } else {
                                           // SUCCESS SIGNING UP
                                           [[NSUserDefaults standardUserDefaults] setObject:emailfield.text forKey:@"user"];
                                           [[NSUserDefaults standardUserDefaults] synchronize];
                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                               //Here your non-main thread.
                                               [NSThread sleepForTimeInterval:1.0f];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   //Here you returns to main thread.
                                                   [References fadeOut:titl];
                                                   [References fadeOut:descrip];
                                                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                       //Here your non-main thread.
                                                       [NSThread sleepForTimeInterval:0.5f];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           //Here you returns to main thread.
                                                           [References fromonscreen:card where:@"TOP"];
                                                           [References fromonscreen:firsttime where:@"TOP"];
                                                           [References fromonscreen:accessResult where:@"TOP"];
                                                           [References fromonscreen:emailfield where:@"TOP"];
                                                           [References fromonscreen:passwordfield where:@"TOP"];
                                                           [References fromonscreen:signinbutton where:@"TOP"];
                                                           [References fromonscreen:signupbutton where:@"TOP"];
                                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                               //Here your non-main thread.
                                                               [NSThread sleepForTimeInterval:1.0f];
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   //Here you returns to main thread.
                                                                   NSString * storyboardName = @"Main";
                                                                   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                                                                   UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"Feed"];
                                                                   [self presentViewController:vc animated:YES completion:nil];
                                                               });
                                                           });
                                                       });
                                                   });
                                               });
                                           });
                                           // END SIGNING UP
                                       }
                                   }
                               }];
    }
    
}

-(bool)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 1) {
        [textField resignFirstResponder];
        [self signin:self];
    } else {
        UITextField *field = [self.view viewWithTag:1];
        [field becomeFirstResponder];
    }
    return YES;
}

@end
