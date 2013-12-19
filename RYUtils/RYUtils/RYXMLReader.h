//
//  RYXMLReader.h
//  p_yl_sz_ios
//
//  Created by Ryan on 13-10-31.
//  Copyright (c) 2013年 YuLong. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 ------------------------------How to Use!-------------------------------
 注：返回的xml数据中不要有与kXMLReaderTextNodeKey相同的key值，如果返回有相同，更改kXMLReaderTextNodeKey值，默认
 为：@“text”
 
 使用方法：
 NSError *parseError = nil;
 NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:testXMLString error:&parseError];
 
 ---------------转换之前的 xml 数据
 
  testXMLString =
     <items>
         <item id=”0001″ type=”donut”>
             <name>Cake</name>
             <ppu>0.55</ppu>
             <batters>
                 <batter id=”1001″>Regular</batter>
                 <batter id=”1002″>Chocolate</batter>
                 <batter id=”1003″>Blueberry</batter>
             </batters>
             <topping id=”5001″>None</topping>
             <topping id=”5002″>Glazed</topping>
             <topping id=”5005″>Sugar</topping>
         </item>
     </items>
 
 ---------------转换之后的 NSDictionary 数据
 
  xmlDictionary = {
     items = {
         item = {
             id = 0001;
             type = donut;
             name = {
                 text = Cake;
             };
             ppu = {
                 text = 0.55;
             };
             batters = {
                 batter = (
                     {
                         id = 1001;
                         text = Regular;
                     },
                     {
                         id = 1002;
                         text = Chocolate;
                     },
                     {
                         id = 1003;
                         text = Blueberry;
                     }
                 );
             };
             topping = (
                 {
                     id = 5001;
                     text = None;
                 },
                 {
                     id = 5002;
                     text = Glazed;
                 },
                 {
                     id = 5005;
                     text = Sugar;
                 }
             );
         };
      };
  }
 */

extern NSString *const kXMLReaderTextNodeKey;

@interface RYXMLReader : NSObject<NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
}

/**
	将xml data 转换成dictionary，失败返回nil，错误信息封装在当前RYXMLReader里，转换错误会有相关log
	@param data xml data 数据
	@returns 返回转换之后的NSDictionary对象，转换失败返回nil
 */
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data;

/**
	将xml string转换成dictionary，失败返回nil，错误信息封装在当前RYXMLReader里，转换错误会有相关log
	@param string xml string 数据
	@returns 返回转换之后的NSDictionary对象，转换失败返回nil
 */
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string;


@end