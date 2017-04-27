//
//  TripCollectionViewCell.h
//  Hitch for iOS
//
//  Created by Robert Crosby on 4/26/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripCollectionViewCell : UICollectionViewCell {
    
}
@property (weak, nonatomic) IBOutlet UILabel *card;
@property (weak, nonatomic) IBOutlet UIImageView *driverpic;
@property (weak, nonatomic) IBOutlet UILabel *plaintext;
@property (weak, nonatomic) IBOutlet UILabel *drivername;
@property (weak, nonatomic) IBOutlet UIImageView *passenger1;
@property (weak, nonatomic) IBOutlet UIImageView *passenger2;
@property (weak, nonatomic) IBOutlet UIImageView *passenger3;
@end
