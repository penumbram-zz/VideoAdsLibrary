//
//  TCXMLParser.m
//  TCVideoPlayer
//
//  Created by Tolga Caner on 24/10/15.
//  Copyright © 2015 Tolga Caner. All rights reserved.
//

#import "TCXMLParser.h"

@interface TCXMLParser ()

@property (nonatomic,strong) NSString* currentString;

@end

@implementation TCXMLParser


-(void)parseXML:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [xmlparser setDelegate:self];
    [xmlparser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
{
    if ([elementName isEqualToString:@"MediaFile"]) {
        NSString * str = [attributeDict objectForKey:@"bitrate"];
        if ([str isEqualToString:@"1472"]) {
            [self setCurrentString:elementName];
            return;
        }
    }
    
    if ([elementName isEqualToString:@"Impression"])
    {
        NSString * str = [attributeDict objectForKey:@"id"];
        if ([str isEqualToString:@"LR"])
        {
            [self setCurrentString:elementName];
            return;
        }
    }
    
    if ([elementName isEqualToString:@"Tracking"])
    {
        NSString * str = [attributeDict objectForKey:@"event"];
        if ([str isEqualToString:@"midpoint"])
        {
            [self setCurrentString:elementName];
            return;
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([[self currentString] isEqualToString:@"MediaFile"]) {
        [self setMediaFileURL:string];
        [self setCurrentString:@""];
    }
    else if ([[self currentString] isEqualToString:@"Impression"]){
        [self setFirstImpressionURL:string];
        [self setCurrentString:@""];
    }
    else if ([[self currentString] isEqualToString:@"Tracking"]){
        [self setMidPointImpressionURL:string];
        [self setCurrentString:@""];
    }
}

@end
