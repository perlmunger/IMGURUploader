//
//  MLViewController.h
//  IMGURUploader
//
//  Created by Matt Long on 3/17/13.
//  Copyright (c) 2013 Matt Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *titleTextField;
@property (nonatomic, weak) IBOutlet UITextField *descriptionTextField;
@property (nonatomic, weak) IBOutlet UITextView *linkTextView;

- (IBAction)didTapUploadButton:(id)sender;

@end
