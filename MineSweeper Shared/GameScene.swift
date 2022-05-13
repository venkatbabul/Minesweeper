//
//  GameScene.swift
//  MineSweeper Shared
//
//  Created by Venkatram G V on 06/05/22.
//

import SpriteKit

class GameScene: SKScene {
    
    let interactor = Interactor()
    
    var board: GameBoard!
    let timerNode: SKLabelNode = SKLabelNode(fontNamed: "Copperplate-Bold")
    var mouseDownCount = 0
    var time: Int = 0
    {
        didSet{
            if (board.isGameFinished == false){
                if (time >= 10){
                    timerNode.text = "Timer : \(time)"
                    insertData(score: "\(time)")
                }else{
                    timerNode.text = "Timer : 0\(time)"
                }
            }else{
                endGame()
            }
        }
    }
    
    private func countDown(){
        time += 1
    }
    
    private func endGame(){
        let endTransition = SKTransition.fade(with: .gray, duration: 3)
        let endScene = EndGameScene()
        endScene.isFinished = board.isFinished
        endScene.totalTime = time
        endScene.highScore = Int(interactor.fetchFromCoreData())!
        endScene.size = CGSize(width: frame.width, height: frame.height)
        endScene.scaleMode = .fill
        self.view?.presentScene(endScene, transition: endTransition)
    }
    
    class func newGameScene() -> GameScene {

        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        Resources.initialize()
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        //interactor.deleteAllData(entity: "Score")
        board = GameBoard(size: 10)
        addChild(board.node)
        repositionBoard()
    }
    
    func repositionBoard(){
        guard board != nil else {return}
        let dimension = 600
        board.repositionBoard(to: CGSize(width: dimension, height: dimension))
    }
    
    func insertData(score: String){
        interactor.saveToCoreData(score: score)
    }
    func fetchData(){
        
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        repositionBoard()
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()

    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
        }
    }
    
}


#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {
    
    override func mouseDown(with event: NSEvent) {
        mouseDownCount += 1
        var position = event.location(in: board.node)
        position.y += 8
        board.revealTile(at: position)
        if mouseDownCount == 1{
            addChild(timerNode)
            timerNode.fontSize = 50
            timerNode.position = CGPoint(x: frame.midX, y: 350)
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run(countDown),SKAction.wait(forDuration: 1)])))
        }
        
    }
    
    
    
    override func rightMouseDown(with event: NSEvent) {
        var position = event.location(in: board.node)
        position.y += 8
        board.toggleFlag(at: position)
    }
    
    override func mouseDragged(with event: NSEvent) {
    }
    
    override func mouseUp(with event: NSEvent) {
        var position = event.location(in: board.node)
        position.y += 8
        board.revealTile(at: position)
    }
    
}
#endif

