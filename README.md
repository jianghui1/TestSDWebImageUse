# TestSDWebImageUse
SDWebImage关于渐进式下载图片的使用

前段时间因为图片的加载导致了 app 的崩溃，总结下来有几个原因。

1. 自己使用 SDWebImage 失误导致了崩溃。
2. Xcode 没有给出合适的警告，没有察觉到自己的失误。
3. SDWebImage 老版本对渐进式图片加载处理不好。

首先，说下我是如何错误使用的，请看代码：
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageLowPriority | SDWebImageRetryFailed
                                                             progress:nil
                                                            completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                                                self.imgView.image = image;
                                                            }];

这里本该使用 `SDWebImageDownloaderOptions` 我却使用了 `SDWebImageOptions` ，导致最终我使用的是 `SDWebImageDownloaderLowPriority` 和 `SDWebImageDownloaderProgressiveDownload`，当使用渐进式加载大图时，app 就会出现闪退。Xcode 控制台会打印 Decoding failed with error code 7 信息。

然后，便是 Xcode 没有给出警告，导致我没有察觉的。但是，如果只设置一个值，Xcode 便会给出警告，请看下图。![图](https://github.com/jianghui1/jianghui1.github.io/blob/master/blogPics/sdwebimage.png?raw=true).

最后，便是 SDWebImage 使用渐进式加载图片时造成大量的内存占用，而没有进行立即释放，在加载大图时便容易造成 app 的崩溃。可以参考 [问题1](https://github.com/SDWebImage/SDWebImage/issues/2427) 和 [问题2](https://github.com/SDWebImage/SDWebImage/pull/2474)。

所幸新版本进行了修复。感兴趣的可以看下我的[demo](https://github.com/jianghui1/TestSDWebImageUse)。使用 `4.0.0` 版本时，运行 demo 会闪退，更严重可能会出现重启（反正我手机是直接重启了）。但是更新到 `5.0.0` 便可以正常加载了。

感兴趣的可以看看上面 问题1 和问题2 ，里面的整个过程记录了问题的发现到解决以及问题的原因，非常有意思。

ps：测试 demo 时，请使用真机。
