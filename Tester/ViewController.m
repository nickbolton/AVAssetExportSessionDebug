//
//  ViewController.m
//  Tester
//
//  Created by Nick Bolton on 12/20/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Bedrock.h"

static NSTimeInterval const kTestDuration = 3.0f;
static NSTimeInterval const kTestStartTime = 10.0f;

@interface ViewController ()

@property (nonatomic, strong) NSURL *sourceAudioURL;
@property (strong, nonatomic) AVPlayer *player;
@property (nonatomic) NSTimeInterval audioStartTime;
@property (nonatomic, nonatomic) AVPlayer *trimmedAudioPlayer;

@end

@implementation ViewController

- (void)setupMusicPlayer {
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance]
     setCategory:AVAudioSessionCategoryPlayback
     error:&error];
    
    if (error != nil) {
        PBLog(@"Error: %@", error);
    }
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    self.sourceAudioURL =
    [mainBundle URLForResource:@"SourceAudio" withExtension:@"mp3"];
    
    self.player = [AVPlayer playerWithURL:self.sourceAudioURL];
//    [self.player play];
}

- (void)setupGestures {
 
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(handleTap:)];
 
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMusicPlayer];
    [self setupGestures];
    [self exportSong];
}

#pragma mark - Gestures

- (void)handleTap:(UIGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.trimmedAudioPlayer != nil) {
            
            [self.trimmedAudioPlayer seekToTime:kCMTimeZero];
            [self.trimmedAudioPlayer play];
        }
    }
}

#pragma mark - Private

- (void)exportSong {

    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:self.sourceAudioURL options:nil];
    
    NSString* fileName =
    [NSString stringWithFormat:@"exported-audio-%@.m4a", [NSString uuidString]];
    
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    NSURL    *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    
    [self
     exportAsset:audioAsset
     audioStartTime:kTestStartTime
     duration:kTestDuration
     outputURL:exportUrl
     completion:^(NSURL *audioURL) {
         
         if (audioURL != nil) {
             self.trimmedAudioPlayer = [AVPlayer playerWithURL:audioURL];
             [self.trimmedAudioPlayer play];
         }
     }];
}

- (void)exportAsset:(AVAsset*)asset
     audioStartTime:(NSTimeInterval)audioStartTime
           duration:(NSTimeInterval)duration
          outputURL:(NSURL*)outputURL
         completion:(void(^)(NSURL *audioURL))completionBlock {
    
    //NSArray* availablePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    
    AVAssetExportSession* exporter = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    
    if (exporter == nil) {
        PBLog(@"Failed creating exporter!");
        
        if (completionBlock != nil) {
            completionBlock(nil);
        }
        return;
    }
    
    PBLog(@"Created exporter! %@", exporter);
    
    // Set output file type
    PBLog(@"Supported file types: %@", exporter.supportedFileTypes);
    for (NSString* filetype in exporter.supportedFileTypes) {
        if ([filetype isEqualToString:AVFileTypeAppleM4A]) {
            exporter.outputFileType = AVFileTypeAppleM4A;
            break;
        }
    }
    if (exporter.outputFileType == nil) {
        PBLog(@"Needed output file type not found? (%@)", AVFileTypeAppleM4A);
        if (completionBlock != nil) {
            completionBlock(nil);
        }
        return;
    }
    
    exporter.outputURL = outputURL;
    // Specify a time range in case only part of file should be exported
    
    AVAssetTrack *audioTrack = asset.tracks.firstObject;
    
    if (audioTrack == nil) {
        if (completionBlock != nil) {
            completionBlock(nil);
        }
        return;
    }
    
    AVAudioMix *mix = [AVAudioMix new];
    
    CMTimeRange audioTrackTimeRange = audioTrack.timeRange;
    CMTime startTime = CMTimeMakeWithSeconds(audioStartTime + CMTimeGetSeconds(audioTrackTimeRange.start), 1);
    CMTime durationTime = CMTimeMakeWithSeconds(duration, 1);
    
    PBLog(@"startTime: %f", CMTimeGetSeconds(startTime));
    PBLog(@"duration: %f", CMTimeGetSeconds(durationTime));
    exporter.timeRange = CMTimeRangeMake(startTime, durationTime);
    exporter.audioMix = mix;
    
    PBLog(@"Starting export! (%@)", exporter.outputURL);
    [exporter exportAsynchronouslyWithCompletionHandler:^(void) {
        // Export ended for some reason. Check in status
        NSString* message;
        switch (exporter.status) {
            case AVAssetExportSessionStatusFailed:
                
                message = [NSString stringWithFormat:@"Export failed. Error: %@", exporter.error.description];
                PBLog(@"%@", message);
                
                if (completionBlock != nil) {
                    completionBlock(nil);
                }

                break;
                
            case AVAssetExportSessionStatusCompleted: {
                
                message = [NSString stringWithFormat:@"Export completed: %@", outputURL.absoluteString];
                PBLog(@"%@", message);
                
                if (completionBlock != nil) {
                    completionBlock(outputURL);
                }

                break;
            }
                
            case AVAssetExportSessionStatusCancelled:
                
                message = [NSString stringWithFormat:@"Export cancelled!"];
                PBLog(@"%@", message);
                
                if (completionBlock != nil) {
                    completionBlock(nil);
                }

                break;
                
            default:
                PBLog(@"Export unhandled status: %ld", exporter.status);
                
                if (completionBlock != nil) {
                    completionBlock(nil);
                }

                break;
        }       
    }];
}

@end
