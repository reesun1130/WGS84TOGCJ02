//
//  WGS84TOGCJ02.h
//  boluoyou
//
//  Created by sunbb on 14-9-3.
//  Copyright (c) 2014年 yzdmtd. All rights reserved.
//

/**
 *
 *  WGS-84 坐标系，是GPS系统所采用的坐标系。一切正常工作的GPS或GPS芯片所返回的坐标值都是这个坐标系下的数值。Google地图采用的卫星图也是按照这坐标系摆
 *  放的。
 *
 ******************************************************************************************************************************
 *
 *  GCJ-02 坐标系，是我天朝政府搞出来的加密坐标系，也常常被称为 “火星坐标系”。包括（但可能不限于）高德地图在内的国内地图服务商采用它来绘制地图。Apple、
 *  Google 等国外公司在其道路地图中使用的也是高德的数据。BD-09 坐标系则是百度地图专用的坐标系。
 *
 ******************************************************************************************************************************
 *  
 * 本例子提供 标准坐标系和中国坐标系的相互转换,查看更多(https://github.com/reesun1130/WGS84TOGCJ02)
 *
 */

#import <Foundation/Foundation.h>

typedef struct
{
    double lat;
    double lng;
} Location;

Location LocationMake(double lat, double lng);

@interface WGS84TOGCJ02 : NSObject

/**
 *  判断是否已经超出中国范围
 *
 *  @param lat 纬度
 *  @param lon 经度
 *
 *  @return 0否 1是
 */
int outOfChina(double lat, double lng);

/**
 *  标准坐标-》中国坐标
 *
 *  @param wgLoc 标准坐标
 *
 *  @return 中国坐标
 */
Location transformFromWGSToGCJ(Location wgLoc);

/**
 *  中国坐标-》标准坐标
 *
 *  @param gcLoc 中国坐标
 *
 *  @return 标准坐标
 */
Location transformFromGCJToWGS(Location gcLoc);

/**
 *  标准坐标-》百度坐标
 *
 *  @param gcLoc 标准坐标
 *
 *  @return 百度坐标
 */
Location bd_encrypt(Location gcLoc);

/**
 *  百度坐标-》标准坐标
 *
 *  @param gcLoc 百度坐标
 *
 *  @return 标准坐标
 */
Location bd_decrypt(Location bdLoc);

@end
