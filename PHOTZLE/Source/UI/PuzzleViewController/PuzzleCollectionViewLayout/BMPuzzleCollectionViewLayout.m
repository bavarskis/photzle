//
//  BMPuzzleCollectionViewLayout.m
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 15/01/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import "BMPuzzleCollectionViewLayout.h"

@interface BMPuzzleCollectionViewLayout()

@end

@implementation BMPuzzleCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
                                                         
    
    
    return attributes;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return self.collectionView.bounds.size.width != newBound.size.width;
}
                                                         
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes * attributes;
    
    return attributes;
}


@end
