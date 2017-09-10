//
//  ViewController.swift
//  maze
//
//  Created by Eduardo Herrera on 10/26/16.
//  Copyright © 2016 Eduardo Herrera. All rights reserved.
//

import UIKit

class mazeViewController: UIViewController {
    
    var brain = modeloLaberinto()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.construir()
        maze.size = 5
        maze.fila = brain.fila
        maze.setNeedsDisplay()
    }
    
    @IBOutlet private weak var maze: pizarraView!
    
    @IBOutlet private weak var level: UILabel!
    
    @IBAction private func moverValor(_ sender: UISlider) {
        let size = Int(sender.value)
        level.text = String(size)
        brain.size = size
        brain.construir()
        maze.size = size
        maze.fila = brain.fila
        maze.setNeedsDisplay()
    }
    
}

