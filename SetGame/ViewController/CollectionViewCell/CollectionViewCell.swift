//
//  CollectionViewCell.swift
//  SetGame
//
//  Created by Дмитрий Садырев on 04.01.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var borderColor: UIColor?
    private var model: Card?
    
    private var sizeForm: CGFloat {
        layer.frame.size.width / 5
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.height * 0.1)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = roundedRect.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = borderColor?.cgColor
        shapeLayer.lineWidth = 3
        self.layer.addSublayer(shapeLayer)
        
        guard let model = self.model else { return }
        
        var startPoint = getStartPoint(for: model)
        for _ in 0..<model.numberCharacters {
            let path = getPath(for: model, and: startPoint)
            startPoint.x += sizeForm * 1.5
            let shapeLayer = getShapeLayer(for: model, and: path)
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    // MARK: - Methods
    
    func setup(_ value: (card: Card, borderColor: UIColor?)) {
        self.model = value.card
        self.borderColor = value.borderColor
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    // MARK: - Private methods
    
    private func getStartPoint(for model: Card) -> CGPoint {
        if model.form == .circle {
            let x = sizeForm + 0.75 * (3 - CGFloat(model.numberCharacters)) * sizeForm
            let y = layer.frame.size.height / 2
            return CGPoint(x: x, y: y)
        } else {
            let x = sizeForm / 2 + 0.75 * (3 - CGFloat(model.numberCharacters)) * sizeForm
            let y = layer.frame.size.height / 2 + sizeForm / 2
            return CGPoint(x: x, y: y)
        }
    }
    
    private func getPath(for model: Card, and startPoint: CGPoint) -> UIBezierPath {
        var path = UIBezierPath()
        switch model.form {
        case .circle:
            path = UIBezierPath(arcCenter: startPoint, radius: sizeForm / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        case .square:
            path = UIBezierPath()
            path.move(to: startPoint)
            path.addLine(to: CGPoint(x: startPoint.x + sizeForm, y: startPoint.y))
            path.addLine(to: CGPoint(x: startPoint.x + sizeForm, y: startPoint.y - sizeForm))
            path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y - sizeForm))
            path.close()
        case .triangle:
            path = UIBezierPath()
            path.move(to: startPoint)
            path.addLine(to: CGPoint(x: startPoint.x + sizeForm, y: startPoint.y))
            path.addLine(to: CGPoint(x: startPoint.x + sizeForm / 2, y: startPoint.y - sizeForm))
            path.close()
        }
        return path
    }
    
    private func getShapeLayer(for model: Card, and path: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        var color = UIColor.clear.cgColor
        switch model.color {
        case .green:
            color = UIColor.green.cgColor
        case .red:
            color = UIColor.red.cgColor
        case .blue:
            color = UIColor.blue.cgColor
        }
        var alpha: CGFloat = 0.0
        switch model.fillingType {
        case .filled:
            alpha = 1.0
        case .translucent:
            alpha = 0.3
        case .empty:
            alpha = 0.0
        }
        shapeLayer.strokeColor = color
        shapeLayer.fillColor = color.copy(alpha: alpha)
        return shapeLayer
    }
}
