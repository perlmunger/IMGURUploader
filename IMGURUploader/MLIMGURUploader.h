//
//  MLIMGURUploader.h
//  IMGURUploader
//
//  Created by Matt Long on 3/17/13.
//  Copyright (c) 2013 Matt Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLIMGURUploader : NSObject

+ (void)uploadPhoto:(NSData*)imageData
              title:(NSString*)title
        description:(NSString*)description
      imgurClientID:(NSString*)clientID
        imgurAPIKey:(NSString*)apiKey
    completionBlock:(void(^)(NSString* result))completion
       failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock;

@end
