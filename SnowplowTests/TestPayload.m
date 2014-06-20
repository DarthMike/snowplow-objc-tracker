//
//  TestPayload.m
//  SnowplowTests
//
//  Copyright (c) 2013-2014 Snowplow Analytics Ltd. All rights reserved.
//
//  This program is licensed to you under the Apache License Version 2.0,
//  and you may not use this file except in compliance with the Apache License
//  Version 2.0. You may obtain a copy of the Apache License Version 2.0 at
//  http://www.apache.org/licenses/LICENSE-2.0.
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the Apache License Version 2.0 is distributed on
//  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
//  express or implied. See the Apache License Version 2.0 for the specific
//  language governing permissions and limitations there under.
//
//  Authors: Jonathan Almeida
//  Copyright: Copyright (c) 2013-2014 Snowplow Analytics Ltd
//  License: Apache License Version 2.0
//

#import <XCTest/XCTest.h>
#import "SnowplowPayload.h"

@interface TestPayload : XCTestCase

@end

@implementation TestPayload

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInit
{
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] init];
   
    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          [[NSDictionary alloc] init],
                          @"Payload is not initilized to null on init");

}

- (void)testInitWithNSDictionary
{
    NSDictionary *sample_dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Value1", @"Key1",
                                 @"Value2", @"Key2", nil];
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] initWithNSDictionary:sample_dict];

    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          sample_dict,
                          @"Payload is not initialized with the correct JSON or NSDictionary");

}

- (void)testInitWithWrongDictionary
{
    NSDictionary *sample_dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Value1", @"Key1",
                                 @"Value2", @"Key2", nil];
    NSDictionary *sample_dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"Value1", @"Key2",
                                  @"Value2", @"Key1", nil];
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] initWithNSDictionary:sample_dict];
    
    XCTAssertNotEqualObjects(sample_payload.getPayloadAsDictionary,
                             sample_dict2,
                             @"Payload is not initialized with the correct JSON or NSDictionary");
}

- (void)testInitWithNullDictionary
{
    NSDictionary *sample_dict = nil;
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] initWithNSDictionary:sample_dict];
    
    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          [[NSDictionary alloc] init],
                          @"Payload should be initialized to an empty NSDictionary");
}

- (void)testAddValueToPayload
{
    NSDictionary *sample_dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Value1", @"Key1", nil];
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] init];
    [sample_payload addValueToPayload:@"Value1" forKey:@"Key1"];
    
    
    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          sample_dict,
                          @"Payload should have the correctly added payload");
}

- (void)testAddValueToPayload2
{
    NSDictionary *sample_dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Value2", @"Key2", nil];
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] init];
    [sample_payload addValueToPayload:@"Value1" forKey:@"Key1"];
    
    
    XCTAssertNotEqualObjects(sample_payload.getPayloadAsDictionary,
                          sample_dict,
                          @"Payload should not be the same as sample_dict");
}

- (void)testAddValueToPayload3
{
    NSDictionary *sample_dict_init = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Value1", @"Key1", nil];
    NSDictionary *sample_dict_final = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Value1", @"Key1",
                                 @"Value2", @"Key2", nil];
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] initWithNSDictionary:sample_dict_init];
    [sample_payload addValueToPayload:@"Value2" forKey:@"Key2"];
    
    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          sample_dict_final,
                          @"Payload should have the same data as sample_dict_final");
}

- (void)testAddDictToPayload
{
    NSDictionary *sample_dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"Value1", @"Key1", nil];
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] init];
    [sample_payload addDictionaryToPayload:sample_dic];
    
    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          sample_dic,
                          @"Payload should contain the exact same contents added from sample_dic");
}

- (void)testAddDictToPayload2
{
    NSDictionary *sample_dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"Value1", @"Key1", nil];
    NSDictionary *sample_dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"Value2", @"Key2", nil];
    NSDictionary *sample_dict_final = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       @"Value1", @"Key1",
                                       @"Value2", @"Key2", nil];
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] initWithNSDictionary:sample_dic];
    [sample_payload addDictionaryToPayload:sample_dic2];

    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          sample_dict_final,
                          @"Payload should contain the exact same contents added from sample_dic_final");
}

- (void)testJsonToPayload
{
    // {"Key1":"Value1"} -> eyJLZXkxIjoiVmFsdWUxIn0=

    NSDictionary *sample_dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"Value1", @"Key1", nil];
    NSDictionary *sample_enc = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"eyJLZXkxIjoiVmFsdWUxIn0=", @"type_enc", nil];
    // NSDictionary conversion to JSON string
    NSData *somedata = [NSJSONSerialization dataWithJSONObject:sample_dic options:0 error:0];
    
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] init];
    [sample_payload addJsonToPayload:somedata base64Encoded:true
                     typeWhenEncoded:@"type_enc" typeWhenNotEncoded:@"type_notenc"];
    
    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          sample_enc,
                          @"Payload doesn't match sample_enc, might be a b64 encoding problem.");
}

- (void)testJsonToPayload2
{
    // {"Key1":"Value1"} -> eyJLZXkxIjoiVmFsdWUxIn0=

    NSDictionary *sample_dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"Value1", @"Key1", nil];
    NSDictionary *sample_enc = [[NSDictionary alloc] initWithObjectsAndKeys:
                                sample_dic, @"type_notenc", nil];
    // NSDictionary conversion to JSON string
    NSData *somedata = [NSJSONSerialization dataWithJSONObject:sample_dic options:0 error:0];
    
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] init];
    [sample_payload addJsonToPayload:somedata base64Encoded:false
                     typeWhenEncoded:@"type_enc" typeWhenNotEncoded:@"type_notenc"];
    
    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          sample_enc,
                          @"Payload doesn't match sample_enc, might be a b64 encoding problem.");
}

- (void)testJsonStringToPayload
{
    // {"Key1":"Value1"} -> eyJLZXkxIjoiVmFsdWUxIn0=

    NSDictionary *sample_enc = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @{@"Key1": @"Value1"}, @"type_notenc", nil];
    NSString *json_str = @"{\"Key1\":\"Value1\"}";
    
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] init];
    [sample_payload addJsonStringToPayload:json_str base64Encoded:false
                           typeWhenEncoded:@"type_enc" typeWhenNotEncoded:@"type_notenc"];
    
    
    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          sample_enc,
                          @"Payload doesn't match sample_enc, might be a b64 encoding problem.");
}

- (void)testJsonStringToPayload2
{
    // {"Key1":"Value1"} -> eyJLZXkxIjoiVmFsdWUxIn0=

    NSDictionary *sample_enc = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"eyJLZXkxIjoiVmFsdWUxIn0=", @"type_enc", nil];
    NSString *json_str = @"{\"Key1\":\"Value1\"}";
    
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] init];
    [sample_payload addJsonStringToPayload:json_str base64Encoded:true
                           typeWhenEncoded:@"type_enc" typeWhenNotEncoded:@"type_notenc"];
    
    
    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          sample_enc,
                          @"Payload doesn't match sample_enc, might be a b64 encoding problem.");
}

- (void)testgetPayloadAsDictionary
{
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] init];
    
    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          [[NSDictionary alloc] init],
                          @"Payload should be initialized to an empty dictionary");
}

- (void)testgetPayloadAsDictionary2
{
    NSDictionary *sample_dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Value1", @"Key1", nil];
    SnowplowPayload *sample_payload = [[SnowplowPayload alloc] initWithNSDictionary:@{@"Key1": @"Value1"}];
    
    XCTAssertEqualObjects(sample_payload.getPayloadAsDictionary,
                          sample_dict,
                          @"Payload should be initialized to an empty dictionary");
}

@end
