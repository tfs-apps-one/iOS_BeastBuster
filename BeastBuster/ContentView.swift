//
//  ContentView.swift
//  BeastBuster
//
//  Created by 古川貴史 on 2024/08/13.
//

import SwiftUI
import AVFoundation
import GoogleMobileAds

struct ContentView: View {

    @State var status_text = ""
    @State var status_text_isRed:Bool = false;
    @State var isBellAct:Bool = false;
    @State var isEmerAct:Bool = false;
    @State var button_1_text = "PLAY"
    @State var button_2_text = "PLAY"
    
    @State var sound_1_text = "通常音: ---"
    @State var sound_1_select_value:Int = SettingsManager.shared.normalSoundSelection

    #if true
    var sound_1_select_moji = [
        NSLocalizedString("sound_bell_1", comment: ""),
        NSLocalizedString("sound_bell_2", comment: ""),
        NSLocalizedString("sound_bell_3", comment: ""),
        NSLocalizedString("sound_thunder_1", comment: ""),
        NSLocalizedString("sound_thunder_2", comment: ""),
        NSLocalizedString("sound_thunder_3", comment: ""),
        NSLocalizedString("sound_radio", comment: ""),
        NSLocalizedString("sound_firecrackers", comment: ""),]
    #else
    var sound_1_select_moji = [
        "通常音: 鈴音1","通常音: 鈴音2","通常音: 鈴音3",
        "通常音: 雷鳴1","通常音: 雷鳴2","通常音: 雷鳴3",
        "通常音: ラジオ","通常音: 爆竹"]
    #endif
    
    @State var interval_text = "再生間隔"
    @State var interval_select_value:Int = SettingsManager.shared.playbackInterval
    #if true
    var interval_select_moji = [
        NSLocalizedString("interval_0", comment: ""),
        NSLocalizedString("interval_5", comment: ""),
        NSLocalizedString("interval_10", comment: ""),
        NSLocalizedString("interval_15", comment: ""),
        NSLocalizedString("interval_random", comment: "")]
    #else
    var interval_select_moji = ["間隔: 0秒", "間隔: 5秒","間隔: 10秒","間隔: 15秒","ランダム"]
    #endif
    
    @State var sound_2_text = "緊急音: ---"
    @State var sound_2_select_value:Int = SettingsManager.shared.emergencySoundSelection
    #if true
    var sound_2_select_moji = [
        NSLocalizedString("e_sound_bell_1", comment: ""),
        NSLocalizedString("e_sound_bell_2", comment: ""),
        NSLocalizedString("e_sound_bell_3", comment: ""),
        NSLocalizedString("e_sound_thunder_1", comment: ""),
        NSLocalizedString("e_sound_thunder_2", comment: ""),
        NSLocalizedString("e_sound_thunder_3", comment: ""),
        NSLocalizedString("e_sound_radio", comment: ""),
        NSLocalizedString("e_sound_firecrackers", comment: ""),]
    #else
    var sound_2_select_moji = [
        "緊急音: 鈴音1","緊急音: 鈴音2","緊急音: 鈴音3",
        "緊急音: 雷鳴1","緊急音: 雷鳴2","緊急音: 雷鳴3",
        "緊急音: ラジオ","緊急音: 爆竹"]
    #endif
    
    @State var light_2_text = "OFF"
    @State var light_2_select_value:Int = SettingsManager.shared.lightBlinkingSetting
    #if true
    var light_2_select_moji = [
        NSLocalizedString("light_OFF", comment: ""),
        NSLocalizedString("light_Flashing", comment: "")
    ]
    #else
    var light_2_select_moji = ["OFF","ON(点滅)"]
    #endif
    
    
    @State private var SoundVolume:Double = SettingsManager.shared.volumeSetting

    //音声プレイヤー
    @State private var audioPlayer: AVAudioPlayer?
    @State private var audioPlayer_emer: AVAudioPlayer?
    //ライト
    @State private var isLightOn: Bool = false // ライトの状態を管理
    @State private var isBlinking: Bool = false // 点滅中かどうかを管理
    @State private var blinkTimer: Timer? // 点滅のためのタイマーを管理
    @State private var SoundContinueTimer: Timer?   //連続再生のためのタイマーを管理
    
    /*------------------------------------------------------
        メイン画面
     ------------------------------------------------------*/
    var body: some View {
                
        VStack {
            //上下余白エリア確保
            Spacer()
                .frame(height: 10) // トップから10pxの余白
                        
            //ステータスエリア
            StatusArea

            //通常音エリア
            NormalSoundArea
            
            Spacer()
                .frame(height: 30) // トップから10pxの余白

            //緊急音エリア
            EmergencySoundArea
            
            //音量エリア
            VolumeArea

            //上下予約エリア確保
            Spacer()

            //広告
            BannerAdView()
//                .frame(width: 320, height: 50)  // バナー広告のサイズ
            .frame(width: GADAdSizeBanner.size.width, height:
                  GADAdSizeBanner.size.height)

            //上下予約エリア確保
            Spacer()
                .frame(height: 5)

        }
        .onAppear(){
            DataManegerLoading()
            setStatusArea()
        }
    }
        
    func setStatusArea() {
        if (audioPlayer != nil && audioPlayer?.isPlaying == true) ||
            (audioPlayer_emer != nil && audioPlayer_emer?.isPlaying == true) {
            status_text = NSLocalizedString("status_playing", comment: "")
         }
        else {
            //status_text = "通常音 or 緊急音を選択して「PLAY」をタップして下さい。"
            status_text = NSLocalizedString("status_pausing", comment: "")
        }
        
        sound_1_text = sound_1_select_moji[sound_1_select_value]
        interval_text = interval_select_moji[interval_select_value]
        sound_2_text = sound_2_select_moji[sound_2_select_value]
        light_2_text = light_2_select_moji[light_2_select_value]
    }
    
    
    /*------------------------------------------------------
        ボタン処理
     ------------------------------------------------------*/
    //再生ボタン処理
    func Button_1_Press(){
        if (audioPlayer == nil || audioPlayer?.isPlaying == false) && SoundContinueTimer == nil {
            button_1_text = "STOP"
            button_2_text = "PLAY"
            status_text_isRed = true
            self.playSound(type:0, filename: GetLoadSoundName(stype:sound_1_select_value), fileExtension: "wav")
            //緊急時のライトOFF
            stopBlinking()
            //isBellAct = true
        }
        else {
            button_1_text = "PLAY"
            button_2_text = "PLAY"
            status_text_isRed = false
            self.stopSound()
            //緊急時のライトOFF
            stopBlinking()
        }
        setStatusArea()
    }
    func Button_2_Press(){
        if audioPlayer_emer == nil || audioPlayer_emer?.isPlaying == false {
            button_1_text = "PLAY"
            button_2_text = "STOP"
            status_text_isRed = true
            self.playSound(type:1, filename: GetLoadSoundName(stype:sound_2_select_value), fileExtension: "wav")
            //ライトON
            startBlinking()
            //isEmerAct = true
        }
        else {
            button_1_text = "PLAY"
            button_2_text = "PLAY"
            status_text_isRed = false
            self.stopSound()
            //ライトOFF
            stopBlinking()
        }
        setStatusArea()
    }

    //リスト選択（再生音）
    func SelectSound_1_Press(index:Int){
        if audioPlayer?.isPlaying == true || audioPlayer_emer?.isPlaying == true || SoundContinueTimer != nil {
            return
        }
        switch index {
        case 0:
            sound_1_text = sound_1_select_moji[0]
            break
        case 1:
            sound_1_text = sound_1_select_moji[1]
            break
        case 2:
            sound_1_text = sound_1_select_moji[2]
            break
        case 3:
            sound_1_text = sound_1_select_moji[3]
            break
        case 4:
            sound_1_text = sound_1_select_moji[4]
            break
        case 5:
            sound_1_text = sound_1_select_moji[5]
            break
        case 6:
            sound_1_text = sound_1_select_moji[6]
            break
        case 7:
            sound_1_text = sound_1_select_moji[7]
            break
        default:
            break
        }
        self.sound_1_select_value = index;
        DataManegerSaveing()
    }
    //リスト選択（再生間隔）
    func SelectIntervalPress(index:Int){
        if audioPlayer?.isPlaying == true || audioPlayer_emer?.isPlaying == true || SoundContinueTimer != nil {
            return
        }
        switch index {
        case 0:
            interval_text = interval_select_moji[0]
            break
        case 1:
            interval_text = interval_select_moji[1]
            break
        case 2:
            interval_text = interval_select_moji[2]
            break
        case 3:
            interval_text = interval_select_moji[3]
            break
        case 4:
            interval_text = interval_select_moji[4]
            break
        /*
        case 5:
            interval_text = interval_select_moji[5]
            break
        case 6:
            interval_text = interval_select_moji[6]
            break
         */
        default:
            self.interval_select_value = 0;
            break
        }
        self.interval_select_value = index
        DataManegerSaveing()
    }
    
    //リスト選択（再生音）
    func SelectSound_2_Press(index:Int){
        if audioPlayer?.isPlaying == true || audioPlayer_emer?.isPlaying == true || SoundContinueTimer != nil {
            return
        }
        switch index {
        case 0:
            sound_2_text = sound_2_select_moji[0]
            break
        case 1:
            sound_2_text = sound_2_select_moji[1]
            break
        case 2:
            sound_2_text = sound_2_select_moji[2]
            break
        case 3:
            sound_2_text = sound_2_select_moji[3]
            break
        case 4:
            sound_2_text = sound_2_select_moji[4]
            break
        case 5:
            sound_2_text = sound_2_select_moji[5]
            break
        case 6:
            sound_2_text = sound_2_select_moji[6]
            break
        case 7:
            sound_2_text = sound_2_select_moji[7]
            break

        default:
            break
        }
        self.sound_2_select_value = index;
        DataManegerSaveing()
    }
    //リスト選択（ライト）
    func SelectLight_2_Press(index:Int){
        if audioPlayer?.isPlaying == true || audioPlayer_emer?.isPlaying == true || SoundContinueTimer != nil {
            return
        }
        switch index {
        case 0:
            light_2_text = light_2_select_moji[0]
            break
        case 1:
            light_2_text = light_2_select_moji[1]
            break
        case 2:
            light_2_text = light_2_select_moji[2]
            break
        default:
            break
        }
        self.light_2_select_value = index;
        DataManegerSaveing()
    }

    //設定ボタン
    func SettingParam(){
        // 設定画面へジャンプ
    }
    
    /*------------------------------------------------------
        再生間隔で連続再生
     ------------------------------------------------------*/
    func playSoundContinue(){
        
        var tmp_interval:Double = 0
        
        //とりあえず停止
        stopSound()
        
        switch interval_select_value {
        case 0: tmp_interval = 0.0
            break
        case 1: tmp_interval = 5.0
            break
        case 2: tmp_interval = 10.0
            break
        case 3: tmp_interval = 15.0
            break
        case 4: tmp_interval = TimeInterval.random(in: 5...15)
            break
        default:
            break
        }

        isBellAct = true
        audioPlayer?.volume = Float(SoundVolume)
        audioPlayer?.play()
        SoundContinueTimer = Timer.scheduledTimer(withTimeInterval: tmp_interval, repeats: true) { _ in
            self.playSoundContinue()
        }
    }
    /*------------------------------------------------------
        音声ロード処理
     ------------------------------------------------------*/
    func playSound(type: Int, filename: String, fileExtension: String) {
        //とりあえず停止
        stopSound()
        
        if let soundAsset = NSDataAsset(name: filename){
            if type == 0 {
                do {
                    audioPlayer = try AVAudioPlayer(data: soundAsset.data, fileTypeHint: fileExtension)
                    
                    if interval_select_value == 0 {
                        isBellAct = true
                        audioPlayer?.numberOfLoops = -1 //無限ループ再生
                        audioPlayer?.volume = Float(SoundVolume)
                        audioPlayer?.play()
                    }
                    else {
                        playSoundContinue()
                    }
                } catch {
                    print("Error: Could not play sound file.")
                }
            }
            else {
                do {
                    audioPlayer_emer = try AVAudioPlayer(data: soundAsset.data, fileTypeHint: fileExtension)
                    
                    isEmerAct = true
                    audioPlayer_emer?.numberOfLoops = -1 //無限ループ再生
                    audioPlayer_emer?.volume = Float(SoundVolume)
                    audioPlayer_emer?.play()
                } catch {
                    print("Error: Could not play sound file.")
                }
            }
        } else {
            print("Error: Sound asset not found.")
        }
    }

    func stopSound() {
        isBellAct = false
        isEmerAct = false
        audioPlayer?.pause()
        audioPlayer_emer?.pause()
        
        SoundContinueTimer?.invalidate() // タイマーを無効化
        SoundContinueTimer = nil
    }

    func setVolume() {
        audioPlayer?.volume = Float(SoundVolume)
        audioPlayer_emer?.volume = Float(SoundVolume)
        DataManegerSaveing()
    }
    func setVolumeLevel(level: Float) {
        audioPlayer?.volume = level
        audioPlayer_emer?.volume = level
        DataManegerSaveing()
    }
    
    /*------------------------------------------------------
        再生する音声の取得
     ------------------------------------------------------*/
    func GetLoadSoundName(stype:Int) -> String {
        var tmp_name = ""
        
        switch (stype){
        case 0: tmp_name = "bell_1"
            break
        case 1: tmp_name = "bell_2"
            break
        case 2: tmp_name = "bell_3"
            break
        case 3: tmp_name = "thunder_1"
            break
        case 4: tmp_name = "thunder_2"
            break
        case 5: tmp_name = "thunder_3"
            break
        case 6: tmp_name = "radio"
            break
        case 7: tmp_name = "firecracker"
            break
        default:
            tmp_name = ""
            break
        }
        return tmp_name
    }
 
    /*------------------------------------------------------
        ライト関連
     ------------------------------------------------------*/
    func startBlinking() {
        if light_2_select_value == 1 {
            isBlinking = true
            blinkTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                toggleLight()
            }
        }
        /*
        else if light_2_select_value == 2 {
            toggleLight()
        }
        */
        else {
            //消灯のため何もしない
        }
    }

    func stopBlinking() {
        isBlinking = false
        blinkTimer?.invalidate() // タイマーを無効化
        blinkTimer = nil
        turnOffLight() // 点滅を止めたらライトを消灯
    }

    func toggleLight() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else {
            print("Device has no torch")
            return
        }

        do {
            try device.lockForConfiguration()
            if isLightOn {
                device.torchMode = .off
            } else {
                try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            }
            isLightOn.toggle()
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }

    func turnOffLight() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else {
            print("Device has no torch")
            return
        }

        do {
            try device.lockForConfiguration()
            device.torchMode = .off
            isLightOn = false
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }

    /*------------------------------------------------------
        DB処理
     ------------------------------------------------------*/
    func DataManegerLoading() {  //ロード
        //通常音　選択音
        self.sound_1_select_value = SettingsManager.shared.normalSoundSelection
        //通常音　再生間隔
        self.interval_select_value = SettingsManager.shared.playbackInterval
        //緊急音　選択音
        self.sound_2_select_value = SettingsManager.shared.emergencySoundSelection
        //ライト　点滅間隔
        self.light_2_select_value = SettingsManager.shared.lightBlinkingSetting
        //音量
        self.SoundVolume = SettingsManager.shared.volumeSetting
    }
    func DataManegerSaveing() {  //セーブ
        //通常音　選択音
        SettingsManager.shared.normalSoundSelection = self.sound_1_select_value
        //通常音　再生間隔
        SettingsManager.shared.playbackInterval = self.interval_select_value
        //緊急音　選択音
        SettingsManager.shared.emergencySoundSelection = self.sound_2_select_value
        //ライト　点滅間隔
        SettingsManager.shared.lightBlinkingSetting = self.light_2_select_value
        //音量
        SettingsManager.shared.volumeSetting = self.SoundVolume
    }
    
}

/*------------------------------------------------------
    表示エリア
 ------------------------------------------------------*/
//ステータスエリア
extension ContentView {

    @ViewBuilder
    private var StatusArea : some View {
        HStack() {
            Text(status_text)
                .bold()
                .font(.title3)
                .foregroundColor(status_text_isRed ? .red : .black)
//                    .background(status_text_isRed ? Color.black : Color.white)
                .shadow(color:status_text_isRed ? Color.red : Color.gray, radius: 3, x: 5, y: 0)
                .frame(maxWidth: .infinity, minHeight: 80)
        }
        .padding()
    }
}
//通常音エリア
extension ContentView {
    
    @ViewBuilder
    private var NormalSoundArea : some View {
        
        if #available(iOS 16.0, *) {
            
            HStack {
                Image(systemName: "bell.square.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(isBellAct ? .cyan : .gray)
                    .shadow(color: isBellAct ? Color.cyan : Color.gray, radius: 15, x: 0, y: 5)
                
                Spacer()
                
                Button(button_1_text) {
                    Button_1_Press()
                }
                .font(.system(size:40))
                .frame(maxWidth: .infinity, minHeight: 100)
                .foregroundColor(.white)
                .background(Color.cyan)
                .cornerRadius(15)
                .shadow(color: Color.cyan, radius: 15, x: 0, y: 5)
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Image(systemName: "music.note.list")
                    .padding(.leading, 10) //左端から10pxの余白
                
                Menu(sound_1_text) {
                    Button(sound_1_select_moji[0]) {
                        SelectSound_1_Press(index:0)
                    }
                    Button(sound_1_select_moji[1]) {
                        SelectSound_1_Press(index:1)
                    }
                    Button(sound_1_select_moji[2]) {
                        SelectSound_1_Press(index:2)
                    }
                    Button(sound_1_select_moji[3]) {
                        SelectSound_1_Press(index:3)
                    }
                    Button(sound_1_select_moji[4]) {
                        SelectSound_1_Press(index:4)
                    }
                    Button(sound_1_select_moji[5]) {
                        SelectSound_1_Press(index:5)
                    }
                    Button(sound_1_select_moji[6]) {
                        SelectSound_1_Press(index:6)
                    }
                    Button(sound_1_select_moji[7]) {
                        SelectSound_1_Press(index:7)
                    }
                }
                Spacer()
                
                Image(systemName: "clock.fill")
                    .font(.title2)
                
                Menu(interval_text) {
                    Button(interval_select_moji[0]) {
                        SelectIntervalPress(index:0)
                    }
                    Button(interval_select_moji[1]) {
                        SelectIntervalPress(index:1)
                    }
                    Button(interval_select_moji[2]) {
                        SelectIntervalPress(index:2)
                    }
                    Button(interval_select_moji[3]) {
                        SelectIntervalPress(index:3)
                    }
                    Button(interval_select_moji[4]) {
                        SelectIntervalPress(index:4)
                    }
                }
                .padding(.trailing, 10) // 右端から10pxの余白
                
            }
            .foregroundColor((isEmerAct || isBellAct) ? .gray : .blue)
            .bold()
            .font(.title3)
            .padding()
        }
        else{
            
            HStack {
                Image(systemName: "bell.square.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(isBellAct ? .blue : .gray)
                    .shadow(color: isBellAct ? Color.blue : Color.gray, radius: 15, x: 0, y: 5)
                
                Spacer()
                
                Button(button_1_text) {
                    Button_1_Press()
                }
                .font(.system(size:40))
                .frame(maxWidth: .infinity, minHeight: 100)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(15)
                .shadow(color: Color.blue, radius: 15, x: 0, y: 5)
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Image(systemName: "music.note.list")
                    .padding(.leading, 10) //左端から10pxの余白
                
                Menu(sound_1_text) {
                    Button(sound_1_select_moji[0]) {
                        SelectSound_1_Press(index:0)
                    }
                    Button(sound_1_select_moji[1]) {
                        SelectSound_1_Press(index:1)
                    }
                    Button(sound_1_select_moji[2]) {
                        SelectSound_1_Press(index:2)
                    }
                    Button(sound_1_select_moji[3]) {
                        SelectSound_1_Press(index:3)
                    }
                    Button(sound_1_select_moji[4]) {
                        SelectSound_1_Press(index:4)
                    }
                    Button(sound_1_select_moji[5]) {
                        SelectSound_1_Press(index:5)
                    }
                    Button(sound_1_select_moji[6]) {
                        SelectSound_1_Press(index:6)
                    }
                    Button(sound_1_select_moji[7]) {
                        SelectSound_1_Press(index:7)
                    }
                }
                Spacer()
                
                Image(systemName: "clock.fill")
                    .font(.title2)
                
                Menu(interval_text) {
                    Button(interval_select_moji[0]) {
                        SelectIntervalPress(index:0)
                    }
                    Button(interval_select_moji[1]) {
                        SelectIntervalPress(index:1)
                    }
                    Button(interval_select_moji[2]) {
                        SelectIntervalPress(index:2)
                    }
                    Button(interval_select_moji[3]) {
                        SelectIntervalPress(index:3)
                    }
                    Button(interval_select_moji[4]) {
                        SelectIntervalPress(index:4)
                    }
                }
                .padding(.trailing, 10) // 右端から10pxの余白
                
            }
            .foregroundColor((isEmerAct || isBellAct) ? .gray : .blue)
//            .bold()
            .font(.title3)
            .padding()
        }
    }
}
//緊急音エリア
extension ContentView {
    
    @ViewBuilder
    private var EmergencySoundArea : some View {
        
        if #available(iOS 16.0, *) {
            HStack() {
                Image(systemName: "sos.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(isEmerAct ? Color.red : Color.gray)
                    .shadow(color: isEmerAct ? Color.red : Color.gray, radius: 15, x: 0, y: 5)
                Spacer()
                
                Button(button_2_text) {
                    Button_2_Press()
                }
                .font(.system(size:40))
                .frame(maxWidth: .infinity, minHeight: 100)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(15)
                .shadow(color: Color.red, radius: 15, x: 0, y: 5)
                Spacer()
            }
            .padding(.horizontal)
            
            HStack{
                Image(systemName: "music.note.list")
                    .font(.title2)
                    .padding(.leading, 10) //左端から10pxの余白
                
                Menu(sound_2_text) {
                    Button(sound_2_select_moji[0]) {
                        SelectSound_2_Press(index:0)
                    }
                    Button(sound_2_select_moji[1]) {
                        SelectSound_2_Press(index:1)
                    }
                    Button(sound_2_select_moji[2]) {
                        SelectSound_2_Press(index:2)
                    }
                    Button(sound_2_select_moji[3]) {
                        SelectSound_2_Press(index:3)
                    }
                    Button(sound_2_select_moji[4]) {
                        SelectSound_2_Press(index:4)
                    }
                    Button(sound_2_select_moji[5]) {
                        SelectSound_2_Press(index:5)
                    }
                    Button(sound_2_select_moji[6]) {
                        SelectSound_2_Press(index:6)
                    }
                    Button(sound_2_select_moji[7]) {
                        SelectSound_2_Press(index:7)
                    }
                }
                Spacer()
                Image(systemName: "lightbulb.fill")
                    .font(.title2)
                
                Menu(light_2_text) {
                    Button(light_2_select_moji[0]) {
                        SelectLight_2_Press(index:0)
                    }
                    Button(light_2_select_moji[1]) {
                        SelectLight_2_Press(index:1)
                    }
                    /*
                     Button(light_2_select_moji[2]) {
                     SelectLight_2_Press(index:2)
                     }
                     */
                }
                .padding(.trailing, 10) // 右端から10pxの余白
            }
            .foregroundColor((isEmerAct || isBellAct) ? .gray : .red)
            .bold()
            .font(.title3)
            .padding()
        }
        else{
            HStack() {
                Image(systemName: "sos.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(isEmerAct ? Color.red : Color.gray)
                    .shadow(color: isEmerAct ? Color.red : Color.gray, radius: 15, x: 0, y: 5)
                Spacer()
                
                Button(button_2_text) {
                    Button_2_Press()
                }
                .font(.system(size:40))
                .frame(maxWidth: .infinity, minHeight: 100)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(15)
                .shadow(color: Color.red, radius: 15, x: 0, y: 5)
                Spacer()
            }
            .padding(.horizontal)
            
            HStack{
                Image(systemName: "music.note.list")
                    .font(.title2)
                    .padding(.leading, 10) //左端から10pxの余白
                
                Menu(sound_2_text) {
                    Button(sound_2_select_moji[0]) {
                        SelectSound_2_Press(index:0)
                    }
                    Button(sound_2_select_moji[1]) {
                        SelectSound_2_Press(index:1)
                    }
                    Button(sound_2_select_moji[2]) {
                        SelectSound_2_Press(index:2)
                    }
                    Button(sound_2_select_moji[3]) {
                        SelectSound_2_Press(index:3)
                    }
                    Button(sound_2_select_moji[4]) {
                        SelectSound_2_Press(index:4)
                    }
                    Button(sound_2_select_moji[5]) {
                        SelectSound_2_Press(index:5)
                    }
                    Button(sound_2_select_moji[6]) {
                        SelectSound_2_Press(index:6)
                    }
                    Button(sound_2_select_moji[7]) {
                        SelectSound_2_Press(index:7)
                    }
                }
                Spacer()
                Image(systemName: "lightbulb.fill")
                    .font(.title2)
                
                Menu(light_2_text) {
                    Button(light_2_select_moji[0]) {
                        SelectLight_2_Press(index:0)
                    }
                    Button(light_2_select_moji[1]) {
                        SelectLight_2_Press(index:1)
                    }
                    /*
                     Button(light_2_select_moji[2]) {
                     SelectLight_2_Press(index:2)
                     }
                     */
                }
                .padding(.trailing, 10) // 右端から10pxの余白
            }
            .foregroundColor((isEmerAct || isBellAct) ? .gray : .red)
 //           .bold()
            .font(.title3)
            .padding()
        }
    }
}
//音量エリア
extension ContentView {
    
    @ViewBuilder
    private var VolumeArea : some View {
         let vol_tmp = NSLocalizedString("volume_title", comment: "")

        if #available(iOS 16.0, *) {
            HStack{
                Text(vol_tmp + "\(Int(SoundVolume))")
                    .padding()
                if #available(iOS 17.0, *) {
                    Slider(value: $SoundVolume, in: 0...15, step:1){
                        //Text("Volume")
                    }
                    .padding()
                    .onChange(of: SoundVolume, setVolume)
                } else {
                    Slider(value: $SoundVolume, in: 0...15, step:1){
                        //Text("Volume")
                    }
                    .padding()
                    .onChange(of: SoundVolume){ _ in
                        setVolumeLevel(level: Float(SoundVolume))
                    }
                }
                //                .onChange(of: SoundVolume){ _ in
                //                    setVolume(level: Float(SoundVolume))
                //                }
            }
            .bold()
            .font(.title3)
        }
        else{
            HStack{
                Image(systemName: "speaker.wave.2.circle.fill")
                    .font(.title)
                Text(vol_tmp + "\(Int(SoundVolume))")
                    .padding()
                if #available(iOS 17.0, *) {
                    Slider(value: $SoundVolume, in: 0...15, step:1){
                        //Text("Volume")
                    }
                    .padding()
                    .onChange(of: SoundVolume, setVolume)
                } else {
                    Slider(value: $SoundVolume, in: 0...15, step:1){
                        //Text("Volume")
                    }
                    .padding()
                    .onChange(of: SoundVolume){ _ in
                        setVolumeLevel(level: Float(SoundVolume))
                    }
                }
                //                .onChange(of: SoundVolume){ _ in
                //                    setVolume(level: Float(SoundVolume))
                //                }
            }
//            .bold()
            .font(.title3)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

