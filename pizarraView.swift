//
//  pizarraView.swift
//  maze
//
//  Created by Eduardo Herrera on 10/26/16.
//  Copyright © 2016 Eduardo Herrera. All rights reserved.
//

import UIKit

class pizarraView: UIView {
    
    var size = 5
    var fila = [[(true,true,true,true)]]
    
    override func draw(_ rect: CGRect) {
        
        let maxX = self.bounds.maxX
        let sizePared = CGFloat( maxX / CGFloat(size + 2) )
        let largo = CGFloat(size) * sizePared
        
        let fsizePared = CGFloat(sizePared)
        let maxIntentos = size * size
        
        // Pintar Linea
        func pintarLinea ( color : UIColor, p1 : CGPoint,  p2 : CGPoint) {
            let linea = UIBezierPath.init()
            linea.move(to: p1)
            linea.addLine(to: p2)
            linea.lineWidth = 1.0
            color.setStroke()
            linea.stroke()
        }
        
        // azar
        func azar (n : Int) -> Int {
            let n32 = UInt32(n)
            return Int(arc4random_uniform(n32))
        }
        
        let xCoord  = Int((maxX - largo)/2)
        let yCoord  = Int(sizePared)
        var puntoInicial = CGPoint(x : xCoord, y: yCoord)
        
        let puntoCero = puntoInicial
        
         func pintarBorde(x : Int, y: Int, borde : Int) {
            var p1 = CGPoint(x: puntoCero.x + CGFloat(x) * sizePared, y:  puntoCero.y + (CGFloat(y) * sizePared))
            var p2 = p1
            
            switch borde {
            case 0:
                p2.x += fsizePared
            case 3:
                p2.y += fsizePared
                
            case 1:
                p1.x += fsizePared
                p2.x += fsizePared
                p2.y += fsizePared
                
            case 2:
                p1.y += fsizePared
                p2.x += fsizePared
                p2.y += fsizePared
                
            default:
                print ("Error")
            }
            pintarLinea(color: .black, p1: p1, p2: p2)
        }
        
        for i in 0..<size {
            for j in 0..<size {
                if fila[i][j].0 == true { pintarBorde(x: i, y: j, borde: 0) }
                if fila[i][j].1 == true { pintarBorde(x: i, y: j, borde: 1) }
            }
            if fila[i][size - 1].2 == true { pintarBorde(x: i, y: size - 1, borde: 2) }
            if fila[0][i].3 == true { pintarBorde(x: 0, y: i, borde: 3) }
        }
    }  //Cerrar draw
} // Cerrar View


