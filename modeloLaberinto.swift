//
//  modeloLaberinto.swift
//  maze
//
//  Created by Eduardo Herrera on 11/13/16.
//  Copyright © 2016 Eduardo Herrera. All rights reserved.
//

import Foundation

class modeloLaberinto
{
    var size = 5
    var fila = [[(true,true,true,true)]]
    
    // azar
    private func azar (n : Int) -> Int {
        let n32 = UInt32(n)
        return Int(arc4random_uniform(n32))
    }

    private func eliminarPared (x : Int, y: Int, borde : Int) {
        switch borde {
        case 0:
            fila[x][y].0 = false
            fila[x][y - 1].2 = false
        case 3:
            fila[x][y].3 = false
            fila[x - 1][y].1 = false
        case 1:
            fila[x][y].1 = false
            fila[x + 1][y].3 = false
        case 2:
            fila[x][y].2 = false
            fila[x][y + 1].0 = false
        default:
            print ("Error")
        }
    }

    
    func construir() {
    // Iniciar Laberinto
         var cantidadCaminos = 1
         let tuplas = (true, true, true, true)
        
        var col = [tuplas]
        for _ in 1..<size {
            col.append(tuplas)
        }
        fila = [col]
        for _ in 1..<size {
            fila.append(col)
        }
        
        fila[0][0].3 = false
        fila[size - 1][size - 1].1 = false
        
        // Matriz
        var paredesVerticales  = [0]
        for _ in 1..<size { paredesVerticales.append(0) }
        var matrix = [paredesVerticales]
        for _ in 1..<size {
            matrix.append(paredesVerticales)
        }
        

        var opciones = [(0,0,0)]
        var opciones0 = [(0,0)]
        var porAvanzar = size * size
        
        let dentro = (size - 2)
        var iX = azar(n: dentro)+1
        var iY = azar(n: dentro)+1
        var dir = azar(n: 4)
        
        var nX = iX
        var nY = iY
        
        func evaluarOpciones() {
            opciones.removeAll()
            var tX = 0
            var tY = 0
            for i  in 0...3 {
                tX = iX
                tY = iY
                switch i {
                case 0:
                    tY = iY - 1
                case 1:
                    tX = iX + 1
                case 2:
                    tY = iY + 1
                case 3:
                    tX = iX - 1
                default:
                    break
                }
                if tX < size && tX >= 0 && tY >= 0 && tY < size {
                    if matrix[tX][tY] == 0 { opciones.append((tX,tY,i)) }
                    
                }
            }
        }
        
        func buscar0() {
            opciones0.removeAll()
            for i in 0..<size {
                for j in 0..<size {
                    if matrix[i][j] == 0 { opciones0.append((i, j)) }
                } }
        }
        
        func unirCaminos (camino1: Int, camino2 : Int, x: Int, y : Int, direccion : Int) {
            eliminarPared(x: x, y: y, borde: direccion)
            
            for i in 0..<size {
                //var tempMatrix = matrix[i].filter { $0 == camino2 }
                //let tempMatrix2 = matrix[i].filter { $0 != camino2 }
                //tempMatrix = tempMatrix.map {$0 * 0 + camino1}
                //matrix[i] = tempMatrix + tempMatrix2
                
                for j in 0..<size {
                    if matrix[i][j] == camino2 {matrix[i][j] = camino1}
                }
            }
            cantidadCaminos -= 1
        }
        
        func printMatrix(){
            for j in 0..<size {
                for i in 0..<size {
                    print(matrix[i][j], terminator: "")
                }
                print(" ")
            }
        }
        
        
        buscar0()
        
        let indice = iX * iY
        iX = opciones0[indice].0
        iY = opciones0[indice].1
        opciones0.remove(at: indice)
        
        while porAvanzar > 1 {
            matrix[iX][iY] = cantidadCaminos
            nX = iX
            nY = iY
            
            switch dir {
            case 0:
                nY = iY - 1
                fila[iX][iY].0 = false
                fila[nX][nY].2 = false
            case 1:
                nX = iX + 1
                fila[iX][iY].1 = false
                fila[nX][nY].3 = false
            case 2:
                nY = iY + 1
                fila[iX][iY].2 = false
                fila[nX][nY].0 = false
            case 3:
                nX = iX - 1
                fila[iX][iY].3 = false
                fila[nX][nY].1 = false
            default:
                break
            }
            
            eliminarPared(x: iX, y: iY, borde: dir)
            porAvanzar -= 1
            
            var cantidadOpciones = 0
            while cantidadOpciones == 0 {
                iX = nX // Nueva partida
                iY = nY // Nueva partida
                evaluarOpciones()
                cantidadOpciones = opciones.count
                if cantidadOpciones > 0 {
                    let opcion = azar(n: cantidadOpciones)
                    dir = opciones[opcion].2
                    var tX = iX
                    var tY = iY
                    switch dir {
                    case 0:
                        tX = iX
                        tY = iY - 1
                    case 1:
                        tX = iX + 1
                        tY = iY
                    case 2:
                        tX = iX
                        tY = iY + 1
                    case 3:
                        tX = iX - 1
                        tY = iY
                    default:
                        break
                    }
                    let tempIndice = opciones0.index(where: {($0,$1) == (tX,tY)})!
                    opciones0.remove(at: tempIndice)
                 }
                else {
                    matrix[nX][nY] = cantidadCaminos
                    cantidadCaminos += 1
                    let cantidad0 = opciones0.count
                    if cantidad0 > 0 {
                        let opcion = azar(n: cantidad0)
                        nX = opciones0[opcion].0
                        nY = opciones0[opcion].1
                        opciones0.remove(at: opcion)
                    }
                    else { porAvanzar = 1
                        break}
                }
            }
            
        }
        cantidadCaminos -= 1
        var matrix2 = [(0,0)]
        matrix2.removeAll()
        for i in 0..<size {
            for j in 0..<size {
                matrix2.append((i,j))
            }
        }
        
        while cantidadCaminos > 1 {
            let sizeMatrix2 = matrix2.count
            let azarIndice = azar(n : sizeMatrix2)
            let azarX = matrix2[azarIndice].0
            let azarY = matrix2[azarIndice].1
            var azarDir = azar(n : 4)
            
            if azarX == 0 && azarDir == 3 {azarDir = 1}
            if azarX == (size - 1) && azarDir == 1 {azarDir = 3}
            if azarY == 0 && azarDir == 0 {azarDir = 2}
            if azarY == (size - 1) && azarDir == 2 {azarDir = 0}
            
            let yo = matrix[azarX][azarY]
            var vecino = yo
            switch azarDir {
            case 0:
                vecino = matrix[azarX][azarY - 1]
            case 1:
                vecino = matrix[azarX + 1][azarY]
            case 2:
                vecino = matrix[azarX][azarY + 1]
            case 3:
                vecino = matrix[azarX - 1][azarY]
            default:
                break
            }
            
            if yo != vecino {
                matrix2.remove(at: azarIndice)
                unirCaminos (camino1: yo,camino2: vecino,x: azarX,y: azarY,direccion: azarDir)
            }
        }
    }
}
