//
//  TCXMLParser.h
//  TCVideoPlayer
//
//  Created by Tolga Caner on 24/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCXMLParser : NSObject <NSXMLParserDelegate>

- (void)parseXML:(NSString *)url ;

@property (retain,nonatomic) NSString* mediaFileURL;
@property (retain,nonatomic) NSString* firstImpressionURL;
@property (retain,nonatomic) NSString* midPointImpressionURL;

@end
