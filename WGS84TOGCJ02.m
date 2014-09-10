//
//  WGS84TOGCJ02.m
//  boluoyou
//
//  Created by sunbb on 14-9-3.
//  Copyright (c) 2014年 yzdmtd. All rights reserved.
//

#import "WGS84TOGCJ02.h"

const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const double pi = 3.14159265358979324;

@implementation WGS84TOGCJ02

int outOfChina(double lat, double lng)
{
    if (lng < 72.004 || lng > 137.8347)
        return 1;
    
    if (lat < 0.8293 || lat > 55.8271)
        return 1;
    
    return 0;
}

double transformLat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(x > 0 ? x:-x);
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    
    return ret;
}

double transformLon(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(x > 0 ? x:-x);
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    
    return ret;
}

Location LocationMake(double lat, double lng)
{
    Location loc;
    loc.lat = lat, loc.lng = lng;
    
    return loc;
}

/**
 *  标准坐标-》中国坐标
 */
Location transformFromWGSToGCJ(Location wgLoc)
{
    Location mgLoc;
    if (outOfChina(wgLoc.lat, wgLoc.lng))
    {
        mgLoc = wgLoc;
        return mgLoc;
    }
    double dLat = transformLat(wgLoc.lng - 105.0, wgLoc.lat - 35.0);
    double dLon = transformLon(wgLoc.lng - 105.0, wgLoc.lat - 35.0);
    double radLat = wgLoc.lat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    mgLoc.lat = wgLoc.lat + dLat;
    mgLoc.lng = wgLoc.lng + dLon;
    
    return mgLoc;
}

/**
 *  中国坐标-》标准坐标
 */
Location transformFromGCJToWGS(Location gcLoc)
{
    Location wgLoc = gcLoc;
    Location currGcLoc, dLoc;
    while (1) {
        currGcLoc = transformFromWGSToGCJ(wgLoc);
        dLoc.lat = gcLoc.lat - currGcLoc.lat;
        dLoc.lng = gcLoc.lng - currGcLoc.lng;
        if (fabs(dLoc.lat) < 1e-7 && fabs(dLoc.lng) < 1e-7) {  // 1e-7 ~ centimeter level accuracy
            // Result of experiment:
            //   Most of the time 2 iterations would be enough for an 1e-8 accuracy (milimeter level).
            //
            return wgLoc;
        }
        wgLoc.lat += dLoc.lat;
        wgLoc.lng += dLoc.lng;
    }
    
    return wgLoc;
}

///
///  Transform GCJ-02 to BD-09
///
Location bd_encrypt(Location gcLoc)
{
    return LocationMake(gcLoc.lat + 0.006,gcLoc.lng + 0.0065);
}

///
///  Transform BD-09 to GCJ-02
///
Location bd_decrypt(Location bdLoc)
{
    return LocationMake(bdLoc.lat - 0.006,bdLoc.lng - 0.0065);
}

@end
