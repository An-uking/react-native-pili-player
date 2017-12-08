#Pili PLPlayerKit React Native SDK

##Introduction

这是由七牛官方PLPlayer pili-react-native版本修改而来，增加一些功能函数，，集成到 iOS 和 Android 。
##注：
本人不会原生开发，所以参照其他组件修改和添加一些功能，如果有不对的地方请指正。

##Installation

#IOS:

在你的项目ios目录下面新建一个Profile文件:
```
    platform :ios, '8.0'
    target '你的项目名称' do
        pod 'yoga', path: '../node_modules/react-native/ReactCommon/yoga/'    
        pod 'React', path: '../node_modules/react-native/'    
        pod 'RCTPlayer', path: '../node_modules/react-native-pili-player/ios/'    
    end
```
然后在ios目录下 执行 pod install
然后把ios/Pods录下 Pods.xcodeproj添加到 Libraries下

3. 如果是 iOS 10 需要在 info 中额外添加如下权限:
```
    <key>NSCameraUsageDescription</key>    
    <string>cameraDesciption</string>

    <key>NSContactsUsageDescription</key>    
    <string>contactsDesciption</string>

    <key>NSMicrophoneUsageDescription</key>    
    <string>microphoneDesciption</string>
```    
ref: [iOS 10](http://www.jianshu.com/p/c212cde86877)


#### Android

make the following additions to the given files manually:

**android/settings.gradle**

```gradle
include ':react-native-pili-player'
project(':react-native-pili-player').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-pili-player/android')
```

**android/app/build.gradle**

```gradle
dependencies {
   ...
   compile project(':react-native-pili-player')
}
```

**MainApplication.java**

On top, where imports are:

```java
import com.pili.rnpili.PiliPackage;
```

Add the `ReactVideoPackage` class to your list of exported packages.

```java
@Override
protected List<ReactPackage> getPackages() {
    return Arrays.asList(
            new MainReactPackage(),
            new PiliPackage()
    );
}
```


##Usage
###1. 直播
```javascript
import {Player,Live} from 'react-native-pili-player';

          <Live
            ref={(ref) => {
              this.player = ref
            }} 
            source={{
            uri: "rtmp://live.hkstv.hk.lxdns.com/live/hks",
            timeout: 10 * 1000,
            hardCodec: false
          }}
          paused={false}
          aspectRatio={2}
          onLoading={})}
          onPaused={})}
          onStop={})}
          onError={})}
          onReady={}}
          onPlaying={})}
            onProg={({currentTime})=>{console.log(totalTime)}}
          />
```
###2. 点播
```javascript
import {Player,Live} from 'react-native-pili-player';

       <Player
          ref={(ref) => {
              this.player = ref
            }} 
          source={{            
            uri:'http://img.ksbbs.com/asset/Mon_1703/eb048d7839442d0.mp4',
            timeout: 10 * 1000,
            hardCodec: false
          }}
          paused={false}
          loop={false}
          aspectRatio={2}
          onLoading={})}
          onPaused={})}
          onStop={})}
          onError={})}
          onReady={}}
          onPlaying={})}
          onProg={({currentTime,totalTime})=>{console.log(currentTime)}}
       />
   
   this.player.seek(0.1)
```
##PLPlayer
- [x] Android: SDK v2.0.4
- [x] iOS: SDK v3.1.0
