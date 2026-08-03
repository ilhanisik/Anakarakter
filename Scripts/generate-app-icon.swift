import AppKit
import CoreGraphics

// Ana Karakter ikonu: sahne karanlığı + tepeden inen projektör huzmesi +
// ışığa giren kimliksiz bir silüet. Vaat "zenginlik" değil, "başrol olmak".
let S = 1024.0
let cs = CGColorSpaceCreateDeviceRGB()
guard let ctx = CGContext(data: nil, width: Int(S), height: Int(S), bitsPerComponent: 8,
                          bytesPerRow: 0, space: cs,
                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { exit(1) }
func rgb(_ r: Double,_ g: Double,_ b: Double,_ a: Double = 1) -> CGColor {
    CGColor(red: r, green: g, blue: b, alpha: a)
}
let gold = (0.98, 0.749, 0.353)

// 1) Sahne karanlığı
ctx.setFillColor(rgb(0.055, 0.047, 0.039))
ctx.fill(CGRect(x: 0, y: 0, width: S, height: S))

// 2) Projektör konisi — tepeden aşağı açılan, yumuşak kenarlı
ctx.saveGState()
let cone = CGMutablePath()
cone.move(to: CGPoint(x: S*0.36, y: S*1.02))
cone.addLine(to: CGPoint(x: S*0.10, y: S*0.12))
    cone.addLine(to: CGPoint(x: S*0.90, y: S*0.12))
cone.addLine(to: CGPoint(x: S*0.64, y: S*1.02))
cone.closeSubpath()
ctx.addPath(cone); ctx.clip()
if let g = CGGradient(colorsSpace: cs, colors: [
    rgb(gold.0, gold.1, gold.2, 0.34), rgb(gold.0, gold.1, gold.2, 0.10),
    rgb(gold.0, gold.1, gold.2, 0.0)] as CFArray, locations: [0, 0.55, 1]) {
    ctx.drawLinearGradient(g, start: CGPoint(x: S*0.5, y: S), end: CGPoint(x: S*0.5, y: S*0.12), options: [])
}
ctx.restoreGState()

// 3) Sahnedeki ışık havuzu — figürün üstünde durduğu elips
ctx.saveGState()
let pool = CGRect(x: S*0.14, y: S*0.10, width: S*0.72, height: S*0.20)
ctx.addEllipse(in: pool); ctx.clip()
if let g = CGGradient(colorsSpace: cs, colors: [
    rgb(gold.0, gold.1, gold.2, 0.55), rgb(gold.0, gold.1, gold.2, 0.0)] as CFArray, locations: [0, 1]) {
    ctx.drawRadialGradient(g, startCenter: CGPoint(x: S*0.5, y: S*0.20), startRadius: 0,
                           endCenter: CGPoint(x: S*0.5, y: S*0.20), endRadius: S*0.38, options: [])
}
ctx.restoreGState()

// 4) Silüet — baş, boyun, omuz, kollar ve bacaklar. Kollar olmadan
// figür manken gibi okunuyordu; asıl insanlık işareti kol boşluğu.
let cx = S*0.5
let headR  = S*0.058
let headCY = S*0.640
let shldY  = S*0.523
let shldX  = S*0.108
let hipX   = S*0.082
let hipY   = S*0.300
let footY  = S*0.150

// Gövde + bacaklar
let torso = CGMutablePath()
torso.move(to: CGPoint(x: cx - S*0.026, y: headCY - headR*0.85))
torso.addLine(to: CGPoint(x: cx - S*0.030, y: shldY + S*0.026))
torso.addCurve(to: CGPoint(x: cx - shldX, y: shldY),
               control1: CGPoint(x: cx - S*0.062, y: shldY + S*0.024),
               control2: CGPoint(x: cx - S*0.090, y: shldY + S*0.012))
torso.addLine(to: CGPoint(x: cx - hipX, y: hipY))
torso.addLine(to: CGPoint(x: cx - S*0.070, y: footY))
torso.addLine(to: CGPoint(x: cx - S*0.012, y: footY))
torso.addLine(to: CGPoint(x: cx, y: hipY - S*0.020))          // bacak arası çentik
torso.addLine(to: CGPoint(x: cx + S*0.012, y: footY))
torso.addLine(to: CGPoint(x: cx + S*0.070, y: footY))
torso.addLine(to: CGPoint(x: cx + hipX, y: hipY))
torso.addLine(to: CGPoint(x: cx + shldX, y: shldY))
torso.addCurve(to: CGPoint(x: cx + S*0.030, y: shldY + S*0.026),
               control1: CGPoint(x: cx + S*0.090, y: shldY + S*0.012),
               control2: CGPoint(x: cx + S*0.062, y: shldY + S*0.024))
torso.addLine(to: CGPoint(x: cx + S*0.026, y: headCY - headR*0.85))
torso.closeSubpath()

// Kollar — gövdeden ince bir boşlukla ayrı
func arm(_ sign: Double) -> CGPath {
    let a = CGMutablePath()
    let outer = cx + sign * S*0.126
    let inner = cx + sign * S*0.094
    a.move(to: CGPoint(x: outer, y: shldY - S*0.004))
    a.addLine(to: CGPoint(x: outer - sign * S*0.006, y: hipY + S*0.010))
    a.addLine(to: CGPoint(x: inner, y: hipY + S*0.010))
    a.addLine(to: CGPoint(x: inner, y: shldY - S*0.004))
    a.closeSubpath()
    return a
}

let figure = CGMutablePath()
figure.addEllipse(in: CGRect(x: cx - headR, y: headCY - headR, width: headR*2, height: headR*2.2))
figure.addPath(torso)
figure.addPath(arm(1))
figure.addPath(arm(-1))

// Kenar ışığı
ctx.saveGState()
ctx.addPath(figure)
ctx.setStrokeColor(rgb(gold.0, gold.1, gold.2, 0.92))
ctx.setLineWidth(7)
ctx.setLineJoin(.round)
ctx.strokePath()
ctx.restoreGState()

ctx.addPath(figure)
ctx.setFillColor(rgb(0.035, 0.030, 0.026))
ctx.fillPath()

// 5) Alt vinyet
if let g = CGGradient(colorsSpace: cs, colors: [
    rgb(0.03, 0.026, 0.022, 0.0), rgb(0.03, 0.026, 0.022, 0.9)] as CFArray, locations: [0, 1]) {
    ctx.drawLinearGradient(g, start: CGPoint(x: S*0.5, y: S*0.22), end: CGPoint(x: S*0.5, y: 0), options: [])
}

guard let image = ctx.makeImage(),
      let data = NSBitmapImageRep(cgImage: image).representation(using: .png, properties: [:])
else { exit(1) }
try data.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
print("üretildi")
