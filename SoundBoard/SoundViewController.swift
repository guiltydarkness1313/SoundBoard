//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Paul Frank Pacheco Carpio on 5/2/18.
//  Copyright © 2018 ShibuyaXpress. All rights reserved.
//

import UIKit
import AVFoundation
class SoundViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    var audioRecorder:AVAudioRecorder?
    var audioPlayer:AVAudioPlayer?
    var audioURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playButton.isEnabled=false
        addButton.isEnabled=false
        // Do any additional setup after loading the view.
    }
    func setupRecorder(){
        do{
            //creando una sesion de audio
            let session=AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //Creando una direccion para el archivo de sonido
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL=NSURL.fileURL(withPathComponents: pathComponents)!
            print("+++++++++++++++++++++++++++++++++++++++++++++++")
            print(audioURL!)
            print("+++++++++++++++++++++++++++++++++++++++++++++++")
            //crear opciones para el grabador de audio
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey]=Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey]=44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey]=2 as AnyObject?
            
            //crear el objeto de grabacion de audio
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        }catch let error as NSError{
            print(error)
        
        }
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound=Sound(context:context)
        sound.name=nameTextField.text
        sound.audio=(NSData(contentsOf: audioURL!)! as Data)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated:true)
    }
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording{
            //detener la grabacion
            audioRecorder?.stop()
            //cambiar el texto del boton grabar
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled=true
            addButton.isEnabled=true
        }else{
            //empezar a grabar
            audioRecorder?.record()
            //cambiar el texto del boton
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer=AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        }catch{
        }
        
    }
    

}
