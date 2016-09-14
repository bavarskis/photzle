//
//  BMPuzzleCollectionViewLayout.m
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 15/01/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import "BMPuzzleCollectionViewLayout.h"
#import "BMPuzzleCollectionViewLayoutAttributes.h"
#import "NSMutableArray+Shuffling.h"

@interface BMCellCoordinateIndexObject : NSObject

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) NSUInteger index;

@end

@implementation BMCellCoordinateIndexObject
@end

@interface BMPuzzleCollectionViewLayout() <UIDynamicAnimatorDelegate> {
    NSMutableDictionary *_originalIndexCoordinateMapping;
    NSMutableArray *_indexesWithCoordinatesArray;
    NSArray *_currentAttributes;
    UIDynamicAnimator *_dynamicAnimator;
    CGFloat _cellSize;
    
    BOOL _didEndShuffleAnimation;
    void(^_shuffleCompletionBlock)(void);
    NSUInteger _selectedCellIndex;
    BOOL _isDraggingCell;
}

@end

@implementation BMPuzzleCollectionViewLayout

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    _dynamicAnimator.delegate = self;
    [_dynamicAnimator removeAllBehaviors];
    
    _originalIndexCoordinateMapping = [NSMutableDictionary dictionary];
    _indexesWithCoordinatesArray = [NSMutableArray array];
    
}

#pragma mark -
#pragma mark Layout

+ (Class)layoutAttributesClass {
    return [BMPuzzleCollectionViewLayoutAttributes class];
}

- (void)prepareLayout {
    [super prepareLayout];
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    if (_dynamicAnimator.behaviors.count > 0) {
        return [_dynamicAnimator itemsInRect:rect];
    }
    
    if (_didEndShuffleAnimation) {
        return _currentAttributes;
    }

    return [self inititalAttributesInRect:rect];
}

- (NSArray *)inititalAttributesInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    
    CGFloat contentMinSize = MIN(self.collectionViewContentSize.width, self.collectionViewContentSize.height);
    CGFloat contentMaxSize = MAX(self.collectionViewContentSize.width, self.collectionViewContentSize.height);
    CGFloat offsetX = contentMinSize == self.collectionViewContentSize.width ? 0.0 : (contentMaxSize - contentMinSize) / 2;
    CGFloat offsetY = contentMinSize == self.collectionViewContentSize.width ? (contentMaxSize - contentMinSize) / 2 : 0.0;
    _cellSize = contentMinSize / _numberOfRows;
    
    NSUInteger cellNum = 0;
    for (int i = 0; i < _numberOfRows; i++) {
        for (int j = 0; j < _numberOfRows; j++) {
            CGRect cellRect = CGRectMake(_cellSize* j + offsetX, _cellSize * i + offsetY, _cellSize, _cellSize);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellNum inSection:0];
            BMPuzzleCollectionViewLayoutAttributes *cellAttributes = (BMPuzzleCollectionViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:indexPath];
            cellAttributes.frame = cellRect;
            cellAttributes.currentIndex = cellNum;
            
            _originalIndexCoordinateMapping[@(cellNum)] = [NSValue valueWithCGPoint:cellAttributes.center];
            
            BMCellCoordinateIndexObject *coordinateIndex = [[BMCellCoordinateIndexObject alloc] init];
            coordinateIndex.point = cellAttributes.center;
            coordinateIndex.index = cellNum;
            _indexesWithCoordinatesArray[cellNum] = coordinateIndex;
            [attributes addObject:cellAttributes];
            
            cellNum++;
        }
    }
    _currentAttributes = attributes;
    return attributes;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}
                                                         
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_dynamicAnimator.behaviors.count > 0) {
        return (BMPuzzleCollectionViewLayoutAttributes *)[_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    }
    BMPuzzleCollectionViewLayoutAttributes *attributes = [BMPuzzleCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    return attributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

#pragma mark -
#pragma mark Public methods

- (void)shuffleCollectionViewCellsWithCompletion:(void (^)(void))completion {
    _shuffleCompletionBlock = [completion copy];
    [self invalidateLayout];
    if (_dynamicAnimator.behaviors.count == 0) {
        
        [_indexesWithCoordinatesArray shuffle];
        [_currentAttributes enumerateObjectsUsingBlock:^(BMPuzzleCollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BMCellCoordinateIndexObject *coordinateIndex = _indexesWithCoordinatesArray[idx];
            obj.currentIndex = coordinateIndex.index;
            UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:obj snapToPoint:coordinateIndex.point];
            snapBehavior.damping = 0.9;
            [_dynamicAnimator addBehavior:snapBehavior];
        }];
    }
}

- (void)didLongPressCollectionViewCell:(BMPuzzleCollectionViewCell *)cell inView:(UIView *)view sender:(UILongPressGestureRecognizer *)sender completion:(void (^)(void))completion {
    
    CGPoint point = [sender locationInView:view];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            // Start animating
            NSLog(@"state began");

            NSUInteger index = cell.index;
            _selectedCellIndex = index;
            [self animateExpandingCellAtIndex:index point:point];

            
            
            break;
        case UIGestureRecognizerStateChanged:
            // animate dragging
            [self animateDraggingCellAtIndex:cell.index toPoint:point];
            break;
        case UIGestureRecognizerStateEnded:
            // finish dragging
            NSLog(@"state ended");
            [self animateCellShrinkAtIndex:cell.index];
            _isDraggingCell = NO;
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"state cancelled");
            _isDraggingCell = NO;
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"state failed");
            _isDraggingCell = NO;
            break;
        default:
            break;
    }
}

- (void)animateDraggingCellAtIndex:(NSUInteger)index toPoint:(CGPoint)point {
    CGRect currentRect = [(BMPuzzleCollectionViewLayoutAttributes*)_currentAttributes[index] frame];
    [(BMPuzzleCollectionViewLayoutAttributes*)_currentAttributes[index] setFrame:CGRectMake(currentRect.origin.x, currentRect.origin.y, currentRect.size.width, currentRect.size.height)];
    [(BMPuzzleCollectionViewLayoutAttributes*)_currentAttributes[index] setCenter:point];
    
    [self hoveredCellAtIndex:index point:point];
    
    [self invalidateLayout];
}

- (NSUInteger)hoveredCellAtIndex:(NSUInteger)index point:(CGPoint)point {
    
    // set only once
    BMPuzzleCollectionViewLayoutAttributes *draggingCellAttributes = _currentAttributes[index];
    CGRect draggingCellInitialRect = draggingCellAttributes.frame;
    
    NSLog(@"%@, %@", NSStringFromCGRect(draggingCellInitialRect), NSStringFromCGPoint(point));
    
    // check for which cell is hovered only when outside of current cell area
    if (CGRectContainsPoint(draggingCellInitialRect, point)) {

    }
    else {
        [_currentAttributes enumerateObjectsUsingBlock:^(BMPuzzleCollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (CGRectContainsPoint(attributes.frame, point)) {
                if (index !=idx && !attributes.isHoveredOn) {
                    [self animateExpandingCellAtIndex:idx point:attributes.center];
                    attributes.isHoveredOn = YES;
                }
            }
            
        }];
    }
    

    
    return 0;
}

- (void)animateExpandingCellAtIndex:(NSUInteger)index point:(CGPoint)point {
    
    if (index == _selectedCellIndex) {
        [self sendToFrontCellAtIndex:index];
    }
    
    
    BMPuzzleCollectionViewLayoutAttributes *attributes = (BMPuzzleCollectionViewLayoutAttributes*)_currentAttributes[index];
    __block CGRect currentFrame = [attributes frame];
    
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        currentFrame = CGRectInset(currentFrame, -currentFrame.size.width/30, -currentFrame.size.height/30);
        [(BMPuzzleCollectionViewLayoutAttributes*)_currentAttributes[index] setFrame:currentFrame];
        [(BMPuzzleCollectionViewLayoutAttributes*)_currentAttributes[index] setCenter:point];
        [self invalidateLayout];
    } completion:^(BOOL finished) {
        _isDraggingCell = YES;
    }];
}

- (void)sendToFrontCellAtIndex:(NSUInteger)index {
    NSLog(@"asdasdasd");
    [_currentAttributes enumerateObjectsUsingBlock:^(BMPuzzleCollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            attributes.zIndex = NSIntegerMax - 1;
        }
        else {
            attributes.zIndex = 1000 + idx;
        }
    }];
}

- (void)animateCellShrinkAtIndex:(NSUInteger)index {
    __block CGRect currentFrame = [(BMPuzzleCollectionViewLayoutAttributes*)_currentAttributes[index] frame];
    __block CGPoint originalPoint = [(BMCellCoordinateIndexObject*)_indexesWithCoordinatesArray[index] point];
    
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect rect = CGRectMake(currentFrame.origin.x, currentFrame.origin.y, _cellSize, _cellSize);
        
        [(BMPuzzleCollectionViewLayoutAttributes*)_currentAttributes[index] setFrame:rect];
        [(BMPuzzleCollectionViewLayoutAttributes*)_currentAttributes[index] setCenter:originalPoint];
        [self invalidateLayout];
    } completion:^(BOOL finished) {
        _isDraggingCell = NO;
    }];
}

#pragma mark -
#pragma mark Animator delegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    _didEndShuffleAnimation = YES;
    [_dynamicAnimator removeAllBehaviors];
    _shuffleCompletionBlock();
}


@end
