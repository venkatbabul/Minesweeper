import SpriteKit

class EndGameScene: SKScene{
    
    let interactor = Interactor()
    var isFinished: Bool = false
    var totalTime: Int = 0
    var highScore: Int = 0
    
    override public func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 93, green: 60, blue: 29, alpha: 0)
        
        if isFinished{
            let scoreNode: SKLabelNode = SKLabelNode(fontNamed: "Copperplate-Bold")
            scoreNode.position.x = frame.midX
            scoreNode.position.y = frame.midY + 100
            scoreNode.fontSize = 100
            scoreNode.text = "Score : \(totalTime)"
            
            let highScoreNode: SKLabelNode = SKLabelNode(fontNamed: "Copperplate-Bold")
            highScoreNode.fontSize = 100
            highScoreNode.position.x = frame.midX
            highScoreNode.position.y = frame.midY - 200
            highScoreNode.text = "High Score : \(highScore)"
            
            addChild(scoreNode)
            addChild(highScoreNode)
        }
        let endNode: SKLabelNode = SKLabelNode(fontNamed: "Copperplate-Bold")
        endNode.position.x = frame.midX
        endNode.position.y = frame.midY
        endNode.fontSize = 100
        endNode.text = "Game Over"
        
        let restartNode: SKLabelNode = SKLabelNode(fontNamed: "Copperplate-Bold")
        restartNode.fontSize = 100
        restartNode.position.x = frame.midX
        restartNode.position.y = frame.midY - 100
        restartNode.text = "Double Tap To Restart"
                
        
                
        addChild(restartNode)
        addChild(endNode)
        
        
    }
    override func mouseDown(with event: NSEvent) {
        if event.clickCount == 2{
            restart()
        }
    }

    private func restart(){
        let transition = SKTransition.fade(with: .gray, duration: 2)
        let restartScene = GameScene()
        restartScene.position.x = frame.minX
        restartScene.position.y = frame.minY
        restartScene.size = CGSize(width: 400, height: 400)
        self.view?.presentScene(restartScene, transition: transition)
    }
}
