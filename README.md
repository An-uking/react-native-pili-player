#Pili player React Native SDK

##Introduction

这是七牛官方PLPlayerKit pili-react-native版本，集成到 iOS 和 Android 。


##Installation

#IOS:

在你的项目ios目录下面新建一个Profile文件:
```
    platform :ios, '8.0'
    target '你的项目名称' do
        pod 'yoga', path: '../node_modules/react-native/ReactCommon/yoga/'    
        pod 'React', path: '../node_modules/react-native/'    
        pod 'RCTPlayer', path: '../node_modules/react-native-uking-pili/ios/'    
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


###Android
1. Open android use Android Studio
2. Just run your project

##TODO
- [x] Android Player
- [x] Android Streaming
- [x] iOS Player
- [x] iOS Streaming
- [ ] 美颜和水印支持

##Usage
###1. 直播(待修改)
```javascript
<LivePlayer
    //uri: "rtmp://live.hkstv.hk.lxdns.com/live/hks",
    uri={"rtmp://pili-publish.pilitest.qiniucdn.com/pilitest/demo_test?key=6eeee8a82246636e"}
    style={{
        height:400,
        width:400,
    }}
    zoom={1} //zoom 
    muted={true} //muted
    focus={false} //focus
    profile={{  //video and audio profile
       video:{
         fps:30,
         bps:1000 * 1024,
         maxFrameInterval:48
       },
       audio:{
         rate:44100,
         bitrate:96 * 1024
       },
    started={false} //streaming status
    onReady={()=>{}} //onReady event
    onConnecting={()=>{}} //onConnecting event
    onStreaming={()=>{}} //onStreaming event
    onShutdown={()=>{}} //onShutdown event
    onIOError={()=>{}} //onIOError event
    onDisconnected={()=>{}} //onDisconnected event
    />
```
###2. 点播
```javascript

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
          onShutdown={})}
          onError={})}
          onReady={}}
          onPlaying={})}
          onProg={({currentTime,totalTime})=>{console.log(currentTime)}}
       />
   
   this.player.seek(0.1)
```
##Release Note
##3.0.10
- [x] Android Player
- [x] iOS Player
