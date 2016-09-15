//
//  BMPuzzleCollectionViewLayoutAttributes.h
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 02/05/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMPuzzleCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isHoveredOn;


@end