//
//  SOSViewController.m
//  Orientation
//
//  Created by Maxim Veksler on 5/3/14.
//  Copyright (c) 2014 Sugar So Studio. All rights reserved.
//

@import AssetsLibrary;
@import AVFoundation;

#import "SOSViewController.h"

@interface SOSViewController ()

@end

@implementation SOSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.playPosition = 0;
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //NSLog(@"GROUP %@", group);
        NSString *albumName = [group valueForProperty:ALAssetsGroupPropertyName];
        
        if(group) {
            if([albumName isEqualToString:@"Test"]) {
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    NSLog(@"ASSET %@", result);

                    ALAssetRepresentation *assetRepresentation = result.defaultRepresentation;
                    NSURL *assetUrl = assetRepresentation.url;
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                        NSDictionary *options = @{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES };
                        AVAsset *videoAsset = [AVURLAsset URLAssetWithURL:assetUrl options:options];
                        AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
                        printTransformForName(@"AVAssetVideoTrack", clipVideoTrack.preferredTransform, clipVideoTrack.naturalSize);
                    } else if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:assetUrl]];
                        printOrientationForName(@"UIImage", image.imageOrientation);
                    } else {
                        NSLog(@"Asset type WTF %@", [result valueForProperty:ALAssetPropertyType]);
                    }
                }];
            }
        } else {
            NSLog(@"Reached end of the line.");
            // [self playNext];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"failureBlock");
    }];
}

void printTransformForName(NSString *name, CGAffineTransform prefferedTransform, CGSize size) {
    NSLog(@"%@ %@ %@", name, NSStringFromCGAffineTransform(prefferedTransform), NSStringFromCGSize(size));
}

void printOrientationForName(NSString *name, UIImageOrientation imageOrientation) {
    NSLog(@"%@ %@", name, NSStringFromUIImageOrientation(imageOrientation));
}

NSString *NSStringFromUIImageOrientation(UIImageOrientation imageOrientation)
{
    switch (imageOrientation) {
        case UIImageOrientationDown:
            return [NSString stringWithFormat:@"%@ [%ld]", @"UIImageOrientationDown", UIImageOrientationDown];
        case UIImageOrientationDownMirrored:
            return [NSString stringWithFormat:@"%@ [%ld]", @"UIImageOrientationDownMirrored", UIImageOrientationDownMirrored];
        case UIImageOrientationLeft:
            return [NSString stringWithFormat:@"%@ [%ld]", @"UIImageOrientationLeft", UIImageOrientationLeft];
        case UIImageOrientationLeftMirrored:
            return [NSString stringWithFormat:@"%@ [%ld]", @"UIImageOrientationLeftMirrored", UIImageOrientationLeftMirrored];
        case UIImageOrientationUp:
            return [NSString stringWithFormat:@"%@ [%ld]", @"UIImageOrientationUp", UIImageOrientationUp];
        case UIImageOrientationUpMirrored:
            return [NSString stringWithFormat:@"%@ [%ld]", @"UIImageOrientationUpMirrored", UIImageOrientationUpMirrored];
        case UIImageOrientationRight:
            return [NSString stringWithFormat:@"%@ [%ld]", @"UIImageOrientationRight", UIImageOrientationRight];
        case UIImageOrientationRightMirrored:
            return [NSString stringWithFormat:@"%@ [%ld]", @"UIImageOrientationRightMirrored", UIImageOrientationRightMirrored];
        default:
            NSLog(@"WTF %ld!!", imageOrientation);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
