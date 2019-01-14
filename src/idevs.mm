//                       佛光普照
//                      / | | | \
//                     / | | | | \
//
//                       _oo0oo_
//                      o8888888o
//                      88" . "88
//                      (| -_- |)
//                      0\  =  /0
//                    ___/`---'\___
//                  .' \\|     |// '.
//                 / \\|||  :  |||// \
//                / _||||| -:- |||||- \
//               |   | \\\  -  /// |   |
//               | \_|  ''\---/''  |_/ |
//               \  .-\__  '-'  ___/-. /
//             ___'. .'  /--.--\  `. .'___
//          ."" '<  `.___\_<|>_/___.' >' "".
//         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//         \  \ `_.   \_ __\ /__ _/   .-` /  /
//     =====`-.____`.___ \_____/___.-`___.-'=====
//                       `=---='
//
//
//     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//               佛祖保佑    🙏    上线无BUG
//
//  idevs.mm
//  EasyMetal
//
//  modified by yyuser on 2019/1/9.
//  Copyright © 2018年 YudaMo.cn@gmail.com. All rights reserved.
//

#import "idevs.h"
#import <sys/utsname.h>
#import <CoreVideo/CoreVideo.h>
#import <iostream>
#import <map>
#import <string>

static const std::map<std::string, std::string> ios_machine_map_type = {
    // Simulator ...
    {"i386", "iPhone Simulator"},
    {"x86_64", "iPhone Simulator"},
    // iPhone ...
    {"iPhone1,1", "iPhone"},
    {"iPhone1,2", "iPhone 3G"},
    {"iPhone2,1", "iPhone 3GS"},
    {"iPhone3,1", "iPhone 4"},
    {"iPhone3,2", "iPhone 4 GSM Rev A"},
    {"iPhone3,3", "iPhone 4 CDMA"},
    {"iPhone4,1", "iPhone 4S"},
    {"iPhone5,1", "iPhone 5 (GSM)"},
    {"iPhone5,2", "iPhone 5 (GSM+CDMA)"},
    {"iPhone5,3", "iPhone 5C (GSM)"},
    {"iPhone5,4", "iPhone 5C (Global)"},
    {"iPhone6,1", "iPhone 5S (GSM)"},
    {"iPhone6,2", "iPhone 5S (Global)"},
    {"iPhone7,1", "iPhone 6 Plus"},
    {"iPhone7,2", "iPhone 6"},
    {"iPhone8,1", "iPhone 6s"},
    {"iPhone8,2", "iPhone 6s Plus"},
    {"iPhone8,3", "iPhone SE (GSM+CDMA)"},
    {"iPhone8,4", "iPhone SE (GSM)"},
    {"iPhone9,1", "iPhone 7"},
    {"iPhone9,2", "iPhone 7 Plus"},
    {"iPhone9,3", "iPhone 7"},
    {"iPhone9,4", "iPhone 7 Plus"},
    {"iPhone10,1", "iPhone 8"},
    {"iPhone10,2", "iPhone 8 Plus"},
    {"iPhone10,3", "iPhone X Global"},
    {"iPhone10,4", "iPhone 8"},
    {"iPhone10,5", "iPhone 8 Plus"},
    {"iPhone10,6", "iPhone X GSM"},
    {"iPhone11,2", "iPhone XS"},
    {"iPhone11,4", "iPhone XS Max China"},
    {"iPhone11,6", "iPhone XS Max"},
    {"iPhone11,8", "iPhone XR"},
    // iPod ...
    {"iPod1,1", "1st Gen iPod"},
    {"iPod2,1", "2nd Gen iPod"},
    {"iPod3,1", "3rd Gen iPod"},
    {"iPod4,1", "4th Gen iPod"},
    {"iPod5,1", "5th Gen iPod"},
    {"iPod7,1", "6th Gen iPod"},
    // iPad ...
    {"iPad1,1", "iPad"},
    {"iPad1,2", "iPad 3G"},
    {"iPad2,1", "2nd Gen iPad"},
    {"iPad2,2", "2nd Gen iPad GSM"},
    {"iPad2,3", "2nd Gen iPad CDMA"},
    {"iPad2,4", "2nd Gen iPad New Revision"},
    {"iPad3,1", "3rd Gen iPad"},
    {"iPad3,2", "3rd Gen iPad CDMA"},
    {"iPad3,3", "3rd Gen iPad GSM"},
    {"iPad2,5", "iPad mini"},
    {"iPad2,6", "iPad mini GSM+LTE"},
    {"iPad2,7", "iPad mini CDMA+LTE"},
    {"iPad3,4", "4th Gen iPad"},
    {"iPad3,5", "4th Gen iPad GSM+LTE"},
    {"iPad3,6", "4th Gen iPad CDMA+LTE"},
    {"iPad4,1", "iPad Air (WiFi)"},
    {"iPad4,2", "iPad Air (GSM+CDMA)"},
    {"iPad4,3", "1st Gen iPad Air (China)"},
    {"iPad4,4", "iPad mini Retina (WiFi)"},
    {"iPad4,5", "iPad mini Retina (GSM+CDMA)"},
    {"iPad4,6", "iPad mini Retina (China)"},
    {"iPad4,7", "iPad mini 3 (WiFi)"},
    {"iPad4,8", "iPad mini 3 (GSM+CDMA)"},
    {"iPad4,9", "iPad Mini 3 (China)"},
    {"iPad5,1", "iPad mini 4 (WiFi)"},
    {"iPad5,2", "4th Gen iPad mini (WiFi+Cellular)"},
    {"iPad5,3", "iPad Air 2 (WiFi)"},
    {"iPad5,4", "iPad Air 2 (Cellular)"},
    {"iPad6,3", "iPad Pro (9.7 inch, WiFi)"},
    {"iPad6,4", "iPad Pro (9.7 inch, WiFi+LTE)"},
    {"iPad6,7", "iPad Pro (12.9 inch, WiFi)"},
    {"iPad6,8", "iPad Pro (12.9 inch, WiFi+LTE)"},
    {"iPad6,11", "iPad (2017)"},
    {"iPad6,12", "iPad (2017)"},
    {"iPad7,1", "iPad Pro 2nd Gen (WiFi)"},
    {"iPad7,2", "iPad Pro 2nd Gen (WiFi+Cellular)"},
    {"iPad7,3", "iPad Pro 10.5-inch"},
    {"iPad7,4", "iPad Pro 10.5-inch"},
    {"iPad7,5", "iPad 6th Gen (WiFi)"},
    {"iPad7,6", "iPad 6th Gen (WiFi+Cellular)"},
    {"iPad8,1", "iPad Pro 3rd Gen (11 inch, WiFi)"},
    {"iPad8,2", "iPad Pro 3rd Gen (11 inch, 1TB, WiFi)"},
    {"iPad8,3", "iPad Pro 3rd Gen (11 inch, WiFi+Cellular)"},
    {"iPad8,4", "iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)"},
    {"iPad8,5", "iPad Pro 3rd Gen (12.9 inch, WiFi)"},
    {"iPad8,6", "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)"},
    {"iPad8,7", "iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)"},
    {"iPad8,8", "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)"},
    // Watch ..
    {"Watch1,1", "Apple Watch 38mm case"},
    {"Watch1,2", "Apple Watch 38mm case"},
    {"Watch2,6", "Apple Watch Series 1 38mm case"},
    {"Watch2,7", "Apple Watch Series 1 42mm case"},
    {"Watch2,3", "Apple Watch Series 2 38mm case"},
    {"Watch2,4", "Apple Watch Series 2 42mm case"},
    {"Watch3,1", "Apple Watch Series 3 38mm case (GPS+Cellular)"},
    {"Watch3,2", "Apple Watch Series 3 42mm case (GPS+Cellular)"},
    {"Watch3,3", "Apple Watch Series 3 38mm case (GPS)"},
    {"Watch3,4", "Apple Watch Series 3 42mm case (GPS)"},
    {"Watch4,1", "Apple Watch Series 4 40mm case (GPS)"},
    {"Watch4,2", "Apple Watch Series 4 44mm case (GPS)"},
    {"Watch4,3", "Apple Watch Series 4 40mm case (GPS+Cellular)"},
    {"Watch4,4", "Apple Watch Series 4 44mm case (GPS+Cellular)"},
};

const char * getMachineNameFull(void) {
    struct utsname systemInfo;
    int ret = uname(&systemInfo);
    if (ret != 0) {
        return NULL;
    }
    std::string machine = systemInfo.machine;
    std::string name = ios_machine_map_type.at(machine);
    return name.c_str();
}

static const std::map<std::string, std::string> ios_machine_map_cpu = {
    // Simulator ...
    {"i386", "UnKnow"},
    {"x86_64", "UnKnow"},
    // iPhone ...
    {"iPhone1,1", "Unknow"},
    {"iPhone1,2", "Unknow"},
    {"iPhone2,1", "Unknow"},
    {"iPhone3,1", "A4"},
    {"iPhone3,2", "A4"},
    {"iPhone3,3", "A4"},
    {"iPhone4,1", "A5"},
    {"iPhone5,1", "A6"},
    {"iPhone5,2", "A6"},
    {"iPhone5,3", "A6"},
    {"iPhone5,4", "A6"},
    {"iPhone6,1", "A7"},
    {"iPhone6,2", "A7"},
    {"iPhone7,1", "A8"},
    {"iPhone7,2", "A8"},
    {"iPhone8,1", "A9"},
    {"iPhone8,2", "A9"},
    {"iPhone8,3", "A9"},
    {"iPhone8,4", "A9"},
    {"iPhone9,1", "A10"},
    {"iPhone9,2", "A10"},
    {"iPhone9,3", "A10"},
    {"iPhone9,4", "A10"},
    {"iPhone10,1", "A11"},
    {"iPhone10,2", "A11"},
    {"iPhone10,3", "A11"},
    {"iPhone10,4", "A11"},
    {"iPhone10,5", "A11"},
    {"iPhone10,6", "A11"},
    {"iPhone11,2", "A12"},
    {"iPhone11,4", "A12"},
    {"iPhone11,6", "A12"},
    {"iPhone11,8", "A12"},
    // iPod ...
    {"iPod1,1", "Unknow"},
    {"iPod2,1", "Unknow"},
    {"iPod3,1", "Unknow"},
    {"iPod4,1", "Unknow"},
    {"iPod5,1", "Unknow"},
    {"iPod7,1", "Unknow"},
    // iPad ...
    {"iPad1,1", "iPad"},
    {"iPad1,2", "iPad 3G"},
    {"iPad2,1", "2nd Gen iPad"},
    {"iPad2,2", "2nd Gen iPad GSM"},
    {"iPad2,3", "2nd Gen iPad CDMA"},
    {"iPad2,4", "2nd Gen iPad New Revision"},
    {"iPad3,1", "3rd Gen iPad"},
    {"iPad3,2", "3rd Gen iPad CDMA"},
    {"iPad3,3", "3rd Gen iPad GSM"},
    {"iPad2,5", "iPad mini"},
    {"iPad2,6", "iPad mini GSM+LTE"},
    {"iPad2,7", "iPad mini CDMA+LTE"},
    {"iPad3,4", "4th Gen iPad"},
    {"iPad3,5", "4th Gen iPad GSM+LTE"},
    {"iPad3,6", "4th Gen iPad CDMA+LTE"},
    {"iPad4,1", "iPad Air (WiFi)"},
    {"iPad4,2", "iPad Air (GSM+CDMA)"},
    {"iPad4,3", "1st Gen iPad Air (China)"},
    {"iPad4,4", "iPad mini Retina (WiFi)"},
    {"iPad4,5", "iPad mini Retina (GSM+CDMA)"},
    {"iPad4,6", "iPad mini Retina (China)"},
    {"iPad4,7", "iPad mini 3 (WiFi)"},
    {"iPad4,8", "iPad mini 3 (GSM+CDMA)"},
    {"iPad4,9", "iPad Mini 3 (China)"},
    {"iPad5,1", "iPad mini 4 (WiFi)"},
    {"iPad5,2", "4th Gen iPad mini (WiFi+Cellular)"},
    {"iPad5,3", "iPad Air 2 (WiFi)"},
    {"iPad5,4", "iPad Air 2 (Cellular)"},
    {"iPad6,3", "iPad Pro (9.7 inch, WiFi)"},
    {"iPad6,4", "iPad Pro (9.7 inch, WiFi+LTE)"},
    {"iPad6,7", "iPad Pro (12.9 inch, WiFi)"},
    {"iPad6,8", "iPad Pro (12.9 inch, WiFi+LTE)"},
    {"iPad6,11", "iPad (2017)"},
    {"iPad6,12", "iPad (2017)"},
    {"iPad7,1", "iPad Pro 2nd Gen (WiFi)"},
    {"iPad7,2", "iPad Pro 2nd Gen (WiFi+Cellular)"},
    {"iPad7,3", "iPad Pro 10.5-inch"},
    {"iPad7,4", "iPad Pro 10.5-inch"},
    {"iPad7,5", "iPad 6th Gen (WiFi)"},
    {"iPad7,6", "iPad 6th Gen (WiFi+Cellular)"},
    {"iPad8,1", "iPad Pro 3rd Gen (11 inch, WiFi)"},
    {"iPad8,2", "iPad Pro 3rd Gen (11 inch, 1TB, WiFi)"},
    {"iPad8,3", "iPad Pro 3rd Gen (11 inch, WiFi+Cellular)"},
    {"iPad8,4", "iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)"},
    {"iPad8,5", "iPad Pro 3rd Gen (12.9 inch, WiFi)"},
    {"iPad8,6", "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)"},
    {"iPad8,7", "iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)"},
    {"iPad8,8", "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)"},
    // Watch ..
    {"Watch1,1", "S1"},
    {"Watch1,2", "S1"},
    {"Watch2,6", "S1P"},
    {"Watch2,7", "S1P"},
    {"Watch2,3", "S2"},
    {"Watch2,4", "S2"},
    {"Watch3,1", "S3"},
    {"Watch3,2", "S3"},
    {"Watch3,3", "S3"},
    {"Watch3,4", "S3"},
    {"Watch4,1", "S4"},
    {"Watch4,2", "S4"},
    {"Watch4,3", "S4"},
    {"Watch4,4", "S4"},
};

const char * getMachineCPU(void) {
    struct utsname systemInfo;
    int ret = uname(&systemInfo);
    if (ret != 0) {
        return NULL;
    }
    std::string machine = systemInfo.machine;
    std::string name = ios_machine_map_cpu.at(machine);
    return name.c_str();
}

const char * getMachineName(void) {
    struct utsname systemInfo;
    int ret = uname(&systemInfo);
    if (ret != 0) {
        return NULL;
    }
    // iPhone
    if (0 == strcmp(systemInfo.machine, "iPhone1,1")) return "iPhone 2G";
    if (0 == strcmp(systemInfo.machine, "iPhone1,2")) return "iPhone 3G";
    if (0 == strcmp(systemInfo.machine, "iPhone2,1")) return "iPhone 3GS";
    if (0 == strcmp(systemInfo.machine, "iPhone3,1")) return "iPhone 4";
    if (0 == strcmp(systemInfo.machine, "iPhone3,2")) return "iPhone 4";
    if (0 == strcmp(systemInfo.machine, "iPhone3,3")) return "iPhone 4";
    if (0 == strcmp(systemInfo.machine, "iPhone4,1")) return "iPhone 4S";
    if (0 == strcmp(systemInfo.machine, "iPhone5,1")) return "iPhone 5";
    if (0 == strcmp(systemInfo.machine, "iPhone5,2")) return "iPhone 5";
    if (0 == strcmp(systemInfo.machine, "iPhone5,3")) return "iPhone 5c";
    if (0 == strcmp(systemInfo.machine, "iPhone5,4")) return "iPhone 5c";
    if (0 == strcmp(systemInfo.machine, "iPhone6,1")) return "iPhone 5s";
    if (0 == strcmp(systemInfo.machine, "iPhone6,2")) return "iPhone 5s";
    if (0 == strcmp(systemInfo.machine, "iPhone7,1")) return "iPhone 6 Plus";
    if (0 == strcmp(systemInfo.machine, "iPhone7,2")) return "iPhone 6";
    if (0 == strcmp(systemInfo.machine, "iPhone8,1")) return "iPhone 6s";
    if (0 == strcmp(systemInfo.machine, "iPhone8,2")) return "iPhone 6s Plus";
    if (0 == strcmp(systemInfo.machine, "iPhone8,4")) return "iPhone SE";
    if (0 == strcmp(systemInfo.machine, "iPhone9,1")) return "iPhone 7";
    if (0 == strcmp(systemInfo.machine, "iPhone9,2")) return "iPhone 7 Plus";
    if (0 == strcmp(systemInfo.machine, "iPhone9,3")) return "iPhone 7";
    if (0 == strcmp(systemInfo.machine, "iPhone9,4")) return "iPhone 7 Plus";
    if (0 == strcmp(systemInfo.machine, "iPhone10,1")) return "iPhone 8";
    if (0 == strcmp(systemInfo.machine, "iPhone10,2")) return "iPhone 8 Plus";
    if (0 == strcmp(systemInfo.machine, "iPhone10,3")) return "iPhone X";
    if (0 == strcmp(systemInfo.machine, "iPhone10,4")) return "iPhone 8";
    if (0 == strcmp(systemInfo.machine, "iPhone10,5")) return "iPhone 8 Plus";
    if (0 == strcmp(systemInfo.machine, "iPhone10,6")) return "iPhone X";
    if (0 == strcmp(systemInfo.machine, "iPhone11,2")) return "iPhone XS";
    if (0 == strcmp(systemInfo.machine, "iPhone11,4")) return "iPhone XS Max";
    if (0 == strcmp(systemInfo.machine, "iPhone11,6")) return "iPhone XS Max";
    if (0 == strcmp(systemInfo.machine, "iPhone11,8")) return "iPhone XR";
    //iPad
    if (0 == strcmp(systemInfo.machine, "iPod1,1")) return "iPod Touch 1G";
    if (0 == strcmp(systemInfo.machine, "iPod2,1")) return "iPod Touch 2G";
    if (0 == strcmp(systemInfo.machine, "iPod3,1")) return "iPod Touch 3G";
    if (0 == strcmp(systemInfo.machine, "iPod4,1")) return "iPod Touch 4G";
    if (0 == strcmp(systemInfo.machine, "iPod5,1")) return "iPod Touch 5G";
    if (0 == strcmp(systemInfo.machine, "iPad1,1")) return "iPad 1G";
    if (0 == strcmp(systemInfo.machine, "iPad2,1")) return "iPad 2";
    if (0 == strcmp(systemInfo.machine, "iPad2,2")) return "iPad 2";
    if (0 == strcmp(systemInfo.machine, "iPad2,3")) return "iPad 2";
    if (0 == strcmp(systemInfo.machine, "iPad2,4")) return "iPad 2";
    if (0 == strcmp(systemInfo.machine, "iPad2,5")) return "iPad Mini 1G";
    if (0 == strcmp(systemInfo.machine, "iPad2,6")) return "iPad Mini 1G";
    if (0 == strcmp(systemInfo.machine, "iPad2,7")) return "iPad Mini 1G";
    if (0 == strcmp(systemInfo.machine, "iPad3,1")) return "iPad 3";
    if (0 == strcmp(systemInfo.machine, "iPad3,2")) return "iPad 3";
    if (0 == strcmp(systemInfo.machine, "iPad3,3")) return "iPad 3";
    if (0 == strcmp(systemInfo.machine, "iPad3,4")) return "iPad 4";
    if (0 == strcmp(systemInfo.machine, "iPad3,5")) return "iPad 4";
    if (0 == strcmp(systemInfo.machine, "iPad3,6")) return "iPad 4";
    if (0 == strcmp(systemInfo.machine, "iPad4,1")) return "iPad Air";
    if (0 == strcmp(systemInfo.machine, "iPad4,2")) return "iPad Air";
    if (0 == strcmp(systemInfo.machine, "iPad4,3")) return "iPad Air";
    if (0 == strcmp(systemInfo.machine, "iPad4,4")) return "iPad Mini 2G";
    if (0 == strcmp(systemInfo.machine, "iPad4,5")) return "iPad Mini 2G";
    if (0 == strcmp(systemInfo.machine, "iPad4,6")) return "iPad Mini 2G";
    //Mac or Simulator
    if (0 == strcmp(systemInfo.machine, "i386")) return "iPhone Simulator";
    if (0 == strcmp(systemInfo.machine, "x86_64")) return "iPhone Simulator";
    return NULL;
}

const bool getGPUAvaliableFlag(void) {
    if (@available(iOS 10.0, *)) {
        struct utsname systemInfo;
        int ret = uname(&systemInfo);
        if (ret != 0) {
            return NULL;
        }
        if (0 == strcmp(systemInfo.machine, "iPhone7,1"))   return true;
        if (0 == strcmp(systemInfo.machine, "iPhone7,2"))   return true;
        if (0 == strcmp(systemInfo.machine, "iPhone8,1"))   return true;
        if (0 == strcmp(systemInfo.machine, "iPhone8,2"))   return true;
        if (0 == strcmp(systemInfo.machine, "iPhone8,4"))   return true;
        if (0 == strcmp(systemInfo.machine, "iPhone9,1"))   return true;
        if (0 == strcmp(systemInfo.machine, "iPhone9,2"))   return true;
        if (0 == strcmp(systemInfo.machine, "iPhone9,3"))   return true;
        if (0 == strcmp(systemInfo.machine, "iPhone9,4"))   return true;
        if (0 == strcmp(systemInfo.machine, "iPhone10,1"))  return true;
        if (0 == strcmp(systemInfo.machine, "iPhone10,2"))  return true;
        if (0 == strcmp(systemInfo.machine, "iPhone10,3"))  return true;
        if (0 == strcmp(systemInfo.machine, "iPhone10,4"))  return true;
        if (0 == strcmp(systemInfo.machine, "iPhone10,5"))  return true;
        if (0 == strcmp(systemInfo.machine, "iPhone10,6"))  return true;
        if (0 == strcmp(systemInfo.machine, "iPhone11,2"))  return true;
        if (0 == strcmp(systemInfo.machine, "iPhone11,4"))  return true;
        if (0 == strcmp(systemInfo.machine, "iPhone11,6"))  return true;
        if (0 == strcmp(systemInfo.machine, "iPhone11,8"))  return true;
    }
    return false;
}
