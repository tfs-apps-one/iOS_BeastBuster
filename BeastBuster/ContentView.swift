//
//  ContentView.swift
//  BeastBuster
//
//  Created by 古川貴史 on 2024/08/13.
//

import SwiftUI
import AVFoundation

struct ContentView: View {

    @State var status_text = ""
    @State var status_text_isRed:Bool = false;
    @State var isBellAct:Bool = false;
    @State var isEmerAct:Bool = false;
    @State var button_1_text = "PLAY"
    @State var button_2_text = "PLAY"
    
    @State var sound_1_text = "通常音: 鈴音1"
    @State var sound_1_select_value = 0
    var sound_1_select_moji = [
        "通常音: 鈴音1","通常音: 鈴音2","通常音: 鈴音3",
        "通常音: 雷鳴1","通常音: 雷鳴2","通常音: 雷鳴3",
        "通常音: ラジオ","通常音: 爆竹"]

    @State var light_1_text = "ライト"
    @State var light_1_select_value = 0
    var light_1_select_moji = ["消灯","点滅","常灯"]

    @State var sound_2_text = "緊急音: 雷鳴1"
    @State var sound_2_select_value = 3
    var sound_2_select_moji = [
        "緊急音: 鈴音1","緊急音: 鈴音2","緊急音: 鈴音3",
        "緊急音: 雷鳴1","緊急音: 雷鳴2","緊急音: 雷鳴3",
        "緊急音: ラジオ","緊急音: 爆竹"]

    @State var light_2_text = "OFF"
    @State var light_2_select_value = 0
    var light_2_select_moji = ["OFF","ON(点滅)"]

    @State var SoundVolume:Double = 3
    
    //音声プレイヤー
    @State private var audioPlayer: AVAudioPlayer?
    @State private var audioPlayer_emer: AVAudioPlayer?
    
    //ライト
    @State private var isLightOn: Bool = false // ライトの状態を管理
    @State private var isBlinking: Bool = false // 点滅中かどうかを管理
    @State private var blinkTimer: Timer? // 点滅のためのタイマーを管理
    
    

    /*------------------------------------------------------
        メイン画面
     ------------------------------------------------------*/
    var body: some View {
                
        VStack {
            //上下余白エリア確保
            Spacer()
                .frame(height: 10) // トップから10pxの余白
                        
            //ステータスエリア
            HStack() {
                Text(status_text)
                    .bold()
                    .font(.title3)
                    .foregroundColor(status_text_isRed ? .red : .black)
//                    .background(status_text_isRed ? Color.black : Color.white)
                    .shadow(color:status_text_isRed ? Color.red : Color.gray, radius: 3, x: 5, y: 0)
                    .frame(maxWidth: .infinity, minHeight: 80)
                
                /*
                Button(action: {
                    // ボタンがタップされた時のアクションをここに記述
                }) {
                    Image(systemName: "gearshape.fill")                            .resizable()
                        .frame(width:30, height: 30)
                        .foregroundColor(.gray) // 画像の色を変更
                }
                 */
            }
            .padding()

            //通常音エリア
            VStack{
                HStack() {
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
                
                HStack{
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
                    /*
                    Image(systemName: "lightbulb.fill")
                        .font(.title2)
                    
                    Menu(light_1_text) {
                        Button(light_1_select_moji[0]) {
                            SelectLight_1_Press(index:0)
                        }
                        Button(light_1_select_moji[1]) {
                            SelectLight_1_Press(index:1)
                        }
                        Button(light_1_select_moji[2]) {
                            SelectLight_1_Press(index:2)
                        }
                    }
                    .padding(.trailing, 10) // 右端から10pxの余白
                     */
                }
                .foregroundColor((isEmerAct || isBellAct) ? .gray : .blue)
                .bold()
                .font(.title3)
                .padding()
            }
            
            Spacer()
                .frame(height: 30) // トップから10pxの余白

            //緊急音エリア
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

            HStack{
                Text("音量: \(Int(SoundVolume))")
                    .padding()
                if #available(iOS 17.0, *) {
                    Slider(value: $SoundVolume, in: 0...15, step:1){
                        Text("Volume")
                    }
                    .padding()
                    .onChange(of: SoundVolume, setVolume)
                } else {
                    Slider(value: $SoundVolume, in: 0...15, step:1){
                        Text("Volume")
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

            //上下予約エリア確保
            Spacer()
        }
        .onAppear(){
            setStatusArea()
        }
    }
        
    func setStatusArea() {
        if (audioPlayer != nil && audioPlayer?.isPlaying == true) ||
            (audioPlayer_emer != nil && audioPlayer_emer?.isPlaying == true) {
            status_text = "＊＊注意＊＊ アプリを閉じても再生は継続します。停止する場合は「STOP」をタップして下さい。"
        }
        else {
            status_text = "通常音 or 緊急音を選択して「PLAY」をタップして下さい。"
        }
    }
    
    
    /*------------------------------------------------------
        ボタン処理
     ------------------------------------------------------*/
    //再生ボタン処理
    func Button_1_Press(){
        if audioPlayer == nil || audioPlayer?.isPlaying == false {
            button_1_text = "STOP"
            button_2_text = "PLAY"
            status_text_isRed = true
            self.playSound(type:0, filename: GetLoadSoundName(stype:sound_1_select_value), fileExtension: "wav")
            //緊急時のライトOFF
            stopBlinking()
            isBellAct = true
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
            isEmerAct = true
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
        if audioPlayer?.isPlaying == true || audioPlayer_emer?.isPlaying == true {
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
    }
    //リスト選択（ライト）
    func SelectLight_1_Press(index:Int){
        if audioPlayer?.isPlaying == true || audioPlayer_emer?.isPlaying == true {
            return
        }
        switch index {
        case 0:
            light_1_text = light_1_select_moji[0]
            break
        case 1:
            light_1_text = light_1_select_moji[1]
            break
        case 2:
            light_1_text = light_1_select_moji[2]
            break
        default:
            break
        }
        self.light_1_select_value = index;
    }
    
    //リスト選択（再生音）
    func SelectSound_2_Press(index:Int){
        if audioPlayer?.isPlaying == true || audioPlayer_emer?.isPlaying == true {
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
    }
    //リスト選択（ライト）
    func SelectLight_2_Press(index:Int){
        if audioPlayer?.isPlaying == true || audioPlayer_emer?.isPlaying == true {
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
    }

    //設定ボタン
    func SettingParam(){
        // 設定画面へジャンプ
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
                    audioPlayer?.numberOfLoops = -1 //無限ループ再生
                    audioPlayer?.volume = Float(SoundVolume)
                    audioPlayer?.play()
                } catch {
                    print("Error: Could not play sound file.")
                }
            }
            else {
                do {
                    audioPlayer_emer = try AVAudioPlayer(data: soundAsset.data, fileTypeHint: fileExtension)
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
    }

    func setVolume() {
        audioPlayer?.volume = Float(SoundVolume)
        audioPlayer_emer?.volume = Float(SoundVolume)
    }
    func setVolumeLevel(level: Float) {
        audioPlayer?.volume = level
        audioPlayer_emer?.volume = level
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
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
