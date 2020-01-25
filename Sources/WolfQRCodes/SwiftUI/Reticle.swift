//
//  Reticle.swift
//  CryptoWallet
//
//  Created by Wolf McNally on 1/19/20.
//  Copyright © 2020 Blockchain Commons. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

public struct Reticle: View {
    let color: Color

    public init(color: Color = Color.primary.opacity(0.3)) {
        self.color = color
    }

    public var body: some View {
        GeometryReader { proxy in
            return ReticleShape()
                .stroke(self.color, lineWidth: ReticleShape.lineWidth(for: proxy.size.width))
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

#if DEBUG
struct Reticle_Previews: PreviewProvider {
    static var previews: some View {
        Reticle()
            .frame(width: 200)
    }
}
#endif

public struct ReticleShape: Shape {
    static func lineWidth(for width: CGFloat) -> CGFloat {
        return width * 0.1
    }

    public func path(in rect: CGRect) -> Path {
        func makeCorner() -> Path {
            let space = rect.width * 0.15
            let cornerRadius = rect.width * 0.15
            let lineWidth = Self.lineWidth(for: rect.width)
            let halfLineWidth = lineWidth / 2
            let insetRect = rect.insetBy(dx: halfLineWidth, dy: halfLineWidth)
            var path = Path()
            let p1 = CGPoint(x: insetRect.minX, y: insetRect.midY - space)
            let p2 = CGPoint(x: insetRect.minX, y: insetRect.minY + cornerRadius)
            let p3 = CGPoint(x: insetRect.minX, y: insetRect.minY)
            let p4 = CGPoint(x: insetRect.midX, y: insetRect.minY)
            let p5 = CGPoint(x: insetRect.midX - space, y: insetRect.minY)
            path.move(to: p1)
            path.addLine(to: p2)
            path.addArc(tangent1End: p3, tangent2End: p4, radius: cornerRadius)
            path.addLine(to: p5)
            return path
        }

        func makeTwoCorners() -> Path {
            let corner = makeCorner()
            var result = Path()
            result.addPath(corner)
            let transform = CGAffineTransform(rotationAngle: CGFloat.pi).translated(by: CGVector(dx: -rect.width, dy: -rect.height))
            result.addPath(corner, transform: transform)
            return result
        }

        func makeAllCorners() -> Path {
            let twoCorners = makeTwoCorners()
            var result = Path()
            result.addPath(twoCorners)
            let transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2).translated(by: CGVector(dx: 0, dy: -rect.height))
            result.addPath(twoCorners, transform: transform)
            return result
        }

        return makeAllCorners()
    }
}

#endif
