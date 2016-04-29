//
//  BMPuzzleCollectionViewLayout.h
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 15/01/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMPuzzleCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, strong) UIImage *puzzleImage;
@property (nonatomic, assign) NSUInteger numberOfRows;

- (void)shuffleCollectionViewCellsWithCompletion:(void (^)(void))completion;


@end
