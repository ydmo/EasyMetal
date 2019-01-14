# EasyMetal
In the process of developing iOS SDKs, then, you want to use Metal's gpu-data-parallel compute processing abilities in .c/.cpp files, you may scream (*Φ皿Φ*) : Why Metal must be used in .m/.mm(objective-c/c++) file!? WTF!?
EasyMetal a iOS framework to wrap Metal Data-Parallel Compute Processing APIs from objective-c/c++ to c/c++. Using this framework, cpp files in iOS SDKs can call the metal's APIs, and the SDK(only contains .cpp files) can be powered by the abilities of "Metal Data-Parallel Compute Processing" easily and flexibly.
    
## Requirements
    1. Apple A8 series processors or above.
    2. iOS 10.0 or above.
    3. Metal.framework (Shader Language Version >= 1.2).

## Demos
    See how to use in files 
    [./easymetal/xcodeproj/EasyMetal/EasyMetal/EMTestMetal.h]
    [./easymetal/xcodeproj/EasyMetal/EasyMetal/EMTestMetal.cpp].

## Report Bugs
If you've found some bugs, please send an email to yudamo.cn@gmail.com(or moyuda@yy.com), I'll fix them as fast as possible. Thank you!

## License
Copyright © 2018年 YudaMo.cn@gmail.com. All rights reserved.
