//
//  MLIMGURUploader.m
//  IMGURUploader
//
//  Created by Matt Long on 3/17/13.
//  Copyright (c) 2013 Matt Long. All rights reserved.
//

#import "MLIMGURUploader.h"

@implementation MLIMGURUploader

+ (void)uploadPhoto:(NSData*)imageData
              title:(NSString*)title
        description:(NSString*)description
      imgurClientID:(NSString*)clientID
        imgurAPIKey:(NSString*)apiKey
    completionBlock:(void(^)(NSString* result))completion
       failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock
{
  NSAssert(imageData, @"Image data is required");
  NSAssert(clientID, @"Client ID is required");
  NSAssert(apiKey, @"API key is required");
  
  NSString *urlString = @"https://api.imgur.com/3/upload.json";
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
  [request setURL:[NSURL URLWithString:urlString]];
  [request setHTTPMethod:@"POST"];
  
  NSMutableData *requestBody = [[NSMutableData alloc] init];
  
  NSString *boundary = @"---------------------------0983745982375409872438752038475287";
  
  NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
  [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
  
  // Add client ID as authrorization header
  [request addValue:[NSString stringWithFormat:@"Client-ID %@", clientID] forHTTPHeaderField:@"Authorization"];
  
  // Image File Data
  [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [requestBody appendData:[@"Content-Disposition: attachment; name=\"image\"; filename=\".tiff\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  
  [requestBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [requestBody appendData:[NSData dataWithData:imageData]];
  [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  
  // API Key Parameter
  [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"key\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
  [requestBody appendData:[apiKey dataUsingEncoding:NSUTF8StringEncoding]];
  [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  
  // Title parameter
  if (title) {
    [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[title dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  }
  
  // Description parameter
  if (title) {
    [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[description dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  }
  
  [requestBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  
  [request setHTTPBody:requestBody];
  
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([responseDictionary valueForKeyPath:@"data.error"]) {
      if (failureBlock) {
        if (!error) {
          error = [NSError errorWithDomain:@"avatarstudio" code:10000 userInfo:@{NSLocalizedFailureReasonErrorKey : [responseDictionary valueForKeyPath:@"data.error"]}];
        }
        failureBlock(response, error, [[responseDictionary valueForKey:@"status"] intValue]);
      }
    } else {
      if (completion) {
        completion([responseDictionary valueForKeyPath:@"data.link"]);
      }
      
    }
    
  }];
}

@end
