//
//  MLViewController.m
//  IMGURUploader
//
//  Created by Matt Long on 3/17/13.
//  Copyright (c) 2013 Matt Long. All rights reserved.
//

#import "MLViewController.h"
#import "MLIMGURUploader.h"

@interface MLViewController ()

@end

@implementation MLViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

}

- (IBAction)didTapUploadButton:(id)sender
{
  NSString *clientID = @"YOUR_CLIENT_ID_HERE";
  NSString *apiKey = @"YOUR_API_KEY_HERE";

  NSString *title = [[self titleTextField] text];
  NSString *description = [[self descriptionTextField] text];
  
  __weak MLViewController *weakSelf = self;
  // Load the image data up in the background so we don't block the UI
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *image = [UIImage imageNamed:@"balloons.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [MLIMGURUploader uploadPhoto:imageData title:title description:description imgurClientID:clientID imgurAPIKey:apiKey completionBlock:^(NSString *result) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [[weakSelf linkTextView] setText:result];
      });
    } failureBlock:^(NSURLResponse *response, NSError *error, NSInteger status) {
      dispatch_async(dispatch_get_main_queue(), ^{
      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      [[[UIAlertView alloc] initWithTitle:@"Upload Failed"
                                  message:[NSString stringWithFormat:@"%@ (Status code %d)", [error localizedDescription], status]
                                 delegate:nil
                        cancelButtonTitle:nil
                        otherButtonTitles:@"OK", nil] show];
      });
    }];
    
  });
}

@end
