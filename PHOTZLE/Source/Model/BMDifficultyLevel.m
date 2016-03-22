//
//  BMDifficultyLevel.m
//  FlipAPic
//
//  Created by Aurimas Bavarskis on 18/08/2013.
//  Copyright (c) 2013 Bavarskis Media Studio. All rights reserved.
//

#import "BMDifficultyLevel.h"

NSString *const BMDifficultyLevelCellHorizontalKey = @"horizontalCells";
NSString *const BMDifficultyLevelCellVerticalKey = @"verticalCells";


@implementation BMDifficultyLevel

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _difficultyLevel = [decoder decodeObjectForKey:@"difficulty"];
        _difficultyLevelType = [decoder decodeIntegerForKey:@"type"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_difficultyLevel forKey:@"difficulty"];
    [encoder encodeInteger:_difficultyLevelType forKey:@"type"];
}

- (void)setLevelWithType:(BMDifficultyLevelType)type
{
    _difficultyLevelType = type;
    
    switch (type) {
        case BMDifficultyLevelTypeBeginner:
            _difficultyLevel = [NSDictionary dictionaryWithObjectsAndKeys:
                                @(3), BMDifficultyLevelCellHorizontalKey,
                                @(3), BMDifficultyLevelCellVerticalKey, nil];
            break;
        case BMDifficultyLevelTypeMedior:
            _difficultyLevel = [NSDictionary dictionaryWithObjectsAndKeys:
                                @(4), BMDifficultyLevelCellHorizontalKey,
                                @(4), BMDifficultyLevelCellVerticalKey, nil];
            break;
        case BMDifficultyLevelTypeSenior:
            _difficultyLevel = [NSDictionary dictionaryWithObjectsAndKeys:
                                @(6), BMDifficultyLevelCellHorizontalKey,
                                @(6), BMDifficultyLevelCellVerticalKey, nil];
            break;
            
        default:
            break;
    }
}

@end
