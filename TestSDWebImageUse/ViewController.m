//
//  ViewController.m
//  TestSDWebImageUse
//
//  Created by ys on 2019/6/21.
//  Copyright © 2019 mg. All rights reserved.
//

#import "ViewController.h"

#import <UIImageView+WebCache.h>
#import <SDImageCache.h>
#import <SDWebImageDownloader.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    NSURL *url = [NSURL URLWithString:@"http://ims.haiziguo.cn/qa/parent/6/201808/0bcc1bc2b2f4a246f1528c38479daa43.jpg"];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        // 1.
        [self.imgView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageProgressiveDownload];
        
        // 2.
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderProgressiveDownload
                                                             progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                                                 self.imgView.image = image;
                                                             }];

        // 3.
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageLowPriority
                                                             progress:nil
                                                            completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                                                self.imgView.image = image;
                                                            }];

        // 4.
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageLowPriority | SDWebImageRetryFailed
                                                             progress:nil
                                                            completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                                                self.imgView.image = image;
                                                            }];
    }];
}


@end
