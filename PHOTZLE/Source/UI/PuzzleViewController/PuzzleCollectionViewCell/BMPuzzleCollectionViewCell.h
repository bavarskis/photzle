//
//  BMPuzzleCollectionViewCell.h
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 15/01/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMPuzzleCollectionViewCellDelegate;

@interface BMPuzzleCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) NSInteger index;

@property (nonatomic, weak) id <BMPuzzleCollectionViewCellDelegate> delegate;

@end

@protocol BMPuzzleCollectionViewCellDelegate <NSObject>

- (void)didLongPressCollectionViewCell:(BMPuzzleCollectionViewCell *)cell sender:(UILongPressGestureRecognizer *)sender;

@end
