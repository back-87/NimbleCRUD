import SwiftUI

// SVG
struct DoubleTapPathView: View {

  static let shouldGrabAttentionOnAppear = true
    
  static let intrinsicSize = CGSize(width: 512, height: 512)
  static let tapMotionLinesAttentionGrabMovementAmount = 25.0
  static let animationSpeedFactor = 2.0
  static let attentionGrabAnimationDelayPerStep = 0.25 //seconds
    
  @State var grabbingAttention = false
  // Nested Groups and Shapes

  struct Group2: View {
      
    @Binding var grabbingAttentionInner: Bool
    // Group

    struct PathView1: View { // SVGPath

      struct PathShape1: Shape {

        func path(in rect: CGRect) -> Path {
          Path { path in
            path.move(to: CGPoint(x: 360.65, y: 234.91))
            path.addLine(to: CGPoint(x: 346.509, y: 234.91))
            path.addCurve(to: CGPoint(x: 334.849, y: 237.6248),
                          control1: CGPoint(x: 342.5207, y: 234.91),
                          control2: CGPoint(x: 338.4387, y: 235.8709))
            path.addCurve(to: CGPoint(x: 312.568, y: 218.9018),
                          control1: CGPoint(x: 333.0013, y: 227.0078),
                          control2: CGPoint(x: 323.708, y: 218.9018))
            path.addLine(to: CGPoint(x: 298.416, y: 218.9018))
            path.addCurve(to: CGPoint(x: 285.814, y: 222.7456),
                          control1: CGPoint(x: 293.7558, y: 218.9018),
                          control2: CGPoint(x: 289.416, y: 220.3198))
            path.addCurve(to: CGPoint(x: 264.486, y: 207.6796),
                          control1: CGPoint(x: 282.6968, y: 213.9761),
                          control2: CGPoint(x: 274.314, y: 207.6796))
            path.addLine(to: CGPoint(x: 250.334, y: 207.6796))
            path.addCurve(to: CGPoint(x: 239.025, y: 210.7108),
                          control1: CGPoint(x: 246.2207, y: 207.6796),
                          control2: CGPoint(x: 242.3535, y: 208.7851))
            path.addLine(to: CGPoint(x: 239.025, y: 128.2148))
            path.addCurve(to: CGPoint(x: 209.334, y: 98.5198),
                          control1: CGPoint(x: 239.025, y: 111.8478),
                          control2: CGPoint(x: 225.705, y: 98.5198))
            path.addCurve(to: CGPoint(x: 179.643, y: 128.2148),
                          control1: CGPoint(x: 192.967, y: 98.5198),
                          control2: CGPoint(x: 179.643, y: 111.8478))
            path.addLine(to: CGPoint(x: 179.643, y: 284.8348))
            path.addCurve(to: CGPoint(x: 162.291, y: 297.0148),
                          control1: CGPoint(x: 173.2953, y: 287.8543),
                          control2: CGPoint(x: 167.413, y: 291.9051))
            path.addLine(to: CGPoint(x: 150.701, y: 308.6168))
            path.addCurve(to: CGPoint(x: 150.701, y: 396.6088),
                          control1: CGPoint(x: 126.431, y: 332.8748),
                          control2: CGPoint(x: 126.431, y: 372.3468))
            path.addLine(to: CGPoint(x: 183.002, y: 428.9178))
            path.addCurve(to: CGPoint(x: 187.9747, y: 433.3631),
                          control1: CGPoint(x: 184.584, y: 430.5037),
                          control2: CGPoint(x: 186.252, y: 431.9725))
            path.addCurve(to: CGPoint(x: 241.8617, y: 464.4101),
                          control1: CGPoint(x: 198.7367, y: 451.9021),
                          control2: CGPoint(x: 218.8537, y: 464.4101))
            path.addLine(to: CGPoint(x: 321.0417, y: 464.4101))
            path.addCurve(to: CGPoint(x: 383.2607, y: 402.4411),
                          control1: CGPoint(x: 355.3507, y: 464.4101),
                          control2: CGPoint(x: 383.2607, y: 436.6131))
            path.addLine(to: CGPoint(x: 383.2607, y: 257.5311))
            path.addCurve(to: CGPoint(x: 360.6517, y: 234.9061),
                          control1: CGPoint(x: 383.2724, y: 245.0541),
                          control2: CGPoint(x: 373.1237, y: 234.9061))
            path.closeSubpath()

            path.move(to: CGPoint(x: 371.9527, y: 402.4361))
            path.addCurve(to: CGPoint(x: 321.0547, y: 453.0881),
                          control1: CGPoint(x: 371.9527, y: 430.3661),
                          control2: CGPoint(x: 349.1207, y: 453.0881))
            path.addLine(to: CGPoint(x: 241.8707, y: 453.0881))
            path.addCurve(to: CGPoint(x: 216.2807, y: 446.1623),
                          control1: CGPoint(x: 232.5426, y: 453.0881),
                          control2: CGPoint(x: 223.8117, y: 450.5451))
            path.addCurve(to: CGPoint(x: 196.7337, y: 425.7793),
                          control1: CGPoint(x: 210.0502, y: 442.4279),
                          control2: CGPoint(x: 203.1007, y: 437.0061))
            path.addCurve(to: CGPoint(x: 190.9642, y: 402.4353),
                          control1: CGPoint(x: 193.0618, y: 418.7871),
                          control2: CGPoint(x: 190.9642, y: 410.8533))
            path.addCurve(to: CGPoint(x: 185.308, y: 396.7791),
                          control1: CGPoint(x: 190.9642, y: 399.3103),
                          control2: CGPoint(x: 188.4369, y: 396.7791))
            path.addCurve(to: CGPoint(x: 179.6557, y: 402.4353),
                          control1: CGPoint(x: 182.1908, y: 396.7791),
                          control2: CGPoint(x: 179.6557, y: 399.3143))
            path.addCurve(to: CGPoint(x: 180.1362, y: 410.0291),
                          control1: CGPoint(x: 179.6557, y: 405.0173),
                          control2: CGPoint(x: 179.8237, y: 407.5408))
            path.addLine(to: CGPoint(x: 158.7022, y: 388.5951))
            path.addCurve(to: CGPoint(x: 158.7022, y: 316.6031),
                          control1: CGPoint(x: 138.8502, y: 368.7431),
                          control2: CGPoint(x: 138.8502, y: 336.4541))
            path.addLine(to: CGPoint(x: 170.2922, y: 305.0131))
            path.addCurve(to: CGPoint(x: 179.6516, y: 297.6693),
                          control1: CGPoint(x: 173.1555, y: 302.1576),
                          control2: CGPoint(x: 176.3039, y: 299.7397))
            path.addLine(to: CGPoint(x: 179.6516, y: 336.4113))
            path.addCurve(to: CGPoint(x: 185.3039, y: 342.0675),
                          control1: CGPoint(x: 179.6516, y: 339.5363),
                          control2: CGPoint(x: 182.1789, y: 342.0675))
            path.addCurve(to: CGPoint(x: 190.9601, y: 336.4113),
                          control1: CGPoint(x: 188.4328, y: 342.0675),
                          control2: CGPoint(x: 190.9601, y: 339.5323))
            path.addLine(to: CGPoint(x: 190.964, y: 128.2113))
            path.addCurve(to: CGPoint(x: 209.343, y: 109.8243),
                          control1: CGPoint(x: 190.964, y: 118.0783),
                          control2: CGPoint(x: 199.2023, y: 109.8243))
            path.addCurve(to: CGPoint(x: 227.734, y: 128.2113),
                          control1: CGPoint(x: 219.488, y: 109.8243),
                          control2: CGPoint(x: 227.734, y: 118.0743))
            path.addLine(to: CGPoint(x: 227.734, y: 273.5113))
            path.addCurve(to: CGPoint(x: 233.3863, y: 279.1636),
                          control1: CGPoint(x: 227.734, y: 276.6363),
                          control2: CGPoint(x: 230.2535, y: 279.1636))
            path.addCurve(to: CGPoint(x: 239.0386, y: 273.5113),
                          control1: CGPoint(x: 236.5035, y: 279.1636),
                          control2: CGPoint(x: 239.0386, y: 276.6363))
            path.addLine(to: CGPoint(x: 239.0386, y: 230.3043))
            path.addCurve(to: CGPoint(x: 250.3476, y: 218.9883),
                          control1: CGPoint(x: 239.0386, y: 224.0621),
                          control2: CGPoint(x: 244.1167, y: 218.9883))
            path.addLine(to: CGPoint(x: 264.4996, y: 218.9883))
            path.addCurve(to: CGPoint(x: 275.8086, y: 230.3043),
                          control1: CGPoint(x: 270.7418, y: 218.9883),
                          control2: CGPoint(x: 275.8086, y: 224.0625))
            path.addLine(to: CGPoint(x: 275.8086, y: 273.5743))
            path.addCurve(to: CGPoint(x: 281.4648, y: 279.2266),
                          control1: CGPoint(x: 275.8086, y: 276.6915),
                          control2: CGPoint(x: 278.3359, y: 279.2266))
            path.addCurve(to: CGPoint(x: 287.1171, y: 273.5743),
                          control1: CGPoint(x: 284.582, y: 279.2266),
                          control2: CGPoint(x: 287.1171, y: 276.6914))
            path.addLine(to: CGPoint(x: 287.1171, y: 241.5353))
            path.addCurve(to: CGPoint(x: 298.4261, y: 230.2193),
                          control1: CGPoint(x: 287.1171, y: 235.2931),
                          control2: CGPoint(x: 292.1952, y: 230.2193))
            path.addLine(to: CGPoint(x: 312.5781, y: 230.2193))
            path.addCurve(to: CGPoint(x: 323.8871, y: 241.5353),
                          control1: CGPoint(x: 318.8086, y: 230.2193),
                          control2: CGPoint(x: 323.8871, y: 235.2935))
            path.addLine(to: CGPoint(x: 323.8871, y: 273.5153))
            path.addCurve(to: CGPoint(x: 329.5394, y: 279.1676),
                          control1: CGPoint(x: 323.8871, y: 276.6403),
                          control2: CGPoint(x: 326.4262, y: 279.1676))
            path.addCurve(to: CGPoint(x: 335.1956, y: 273.5153),
                          control1: CGPoint(x: 332.6683, y: 279.1676),
                          control2: CGPoint(x: 335.1956, y: 276.6403))
            path.addLine(to: CGPoint(x: 335.1956, y: 253.0113))
            path.addCurve(to: CGPoint(x: 346.5156, y: 246.2261),
                          control1: CGPoint(x: 335.1956, y: 249.7144),
                          control2: CGPoint(x: 341.0081, y: 246.2261))
            path.addLine(to: CGPoint(x: 360.6566, y: 246.2261))
            path.addCurve(to: CGPoint(x: 371.9576, y: 257.5421),
                          control1: CGPoint(x: 366.8871, y: 246.2261),
                          control2: CGPoint(x: 371.9576, y: 251.3003))
            path.addLine(to: CGPoint(x: 371.9654, y: 402.4421))
            path.closeSubpath()
          }
        }
      }

      var body: some View {
        PathShape1()
          .fill(Color.black)
      }
    }

    struct PathView2: View { // SVGPath

      struct PathShape2: Shape {

        func path(in rect: CGRect) -> Path {
          Path { path in
            path.move(to: CGPoint(x: 301.96, y: 400.53))
            path.addLine(to: CGPoint(x: 260.948, y: 400.53))
            path.addCurve(to: CGPoint(x: 255.2957, y: 394.8777),
                          control1: CGPoint(x: 257.8308, y: 400.53),
                          control2: CGPoint(x: 255.2957, y: 397.9948))
            path.addCurve(to: CGPoint(x: 277.0147, y: 369.3507),
                          control1: CGPoint(x: 255.2957, y: 384.4477),
                          control2: CGPoint(x: 265.8467, y: 377.1117))
            path.addCurve(to: CGPoint(x: 296.2957, y: 349.4447),
                          control1: CGPoint(x: 286.0577, y: 363.0734),
                          control2: CGPoint(x: 296.2957, y: 355.9557))
            path.addCurve(to: CGPoint(x: 281.4597, y: 334.7807),
                          control1: CGPoint(x: 296.2957, y: 339.3707),
                          control2: CGPoint(x: 288.6043, y: 334.7807))
            path.addCurve(to: CGPoint(x: 266.6117, y: 346.4447),
                          control1: CGPoint(x: 273.4128, y: 334.7807),
                          control2: CGPoint(x: 266.6117, y: 340.1205))
            path.addCurve(to: CGPoint(x: 260.9555, y: 352.1009),
                          control1: CGPoint(x: 266.6117, y: 349.5697),
                          control2: CGPoint(x: 264.0844, y: 352.1009))
            path.addCurve(to: CGPoint(x: 255.3032, y: 346.4447),
                          control1: CGPoint(x: 257.8383, y: 352.1009),
                          control2: CGPoint(x: 255.3032, y: 349.5657))
            path.addCurve(to: CGPoint(x: 281.4592, y: 323.4717),
                          control1: CGPoint(x: 255.3032, y: 333.7727),
                          control2: CGPoint(x: 267.0332, y: 323.4717))
            path.addCurve(to: CGPoint(x: 307.6152, y: 349.4447),
                          control1: CGPoint(x: 296.3692, y: 323.4717),
                          control2: CGPoint(x: 307.6152, y: 334.6437))
            path.addCurve(to: CGPoint(x: 283.4632, y: 378.6397),
                          control1: CGPoint(x: 307.6152, y: 361.8707),
                          control2: CGPoint(x: 295.3492, y: 370.3937))
            path.addCurve(to: CGPoint(x: 269.8732, y: 389.2177),
                          control1: CGPoint(x: 278.7327, y: 381.9327),
                          control2: CGPoint(x: 273.2642, y: 385.7374))
            path.addLine(to: CGPoint(x: 301.9552, y: 389.2177))
            path.addCurve(to: CGPoint(x: 307.6114, y: 394.8739),
                          control1: CGPoint(x: 305.0724, y: 389.2177),
                          control2: CGPoint(x: 307.6114, y: 391.7529))
            path.addCurve(to: CGPoint(x: 301.9591, y: 400.5301),
                          control1: CGPoint(x: 307.6192, y: 397.9989),
                          control2: CGPoint(x: 305.0802, y: 400.5301))
            path.closeSubpath()
          }
        }
      }

      var body: some View {
        PathShape2()
          .fill(Color.black)
      }
    }

    struct PathView3: View { // SVGPath

      struct PathShape3: Shape {

        func path(in rect: CGRect) -> Path {
          Path { path in
            path.move(to: CGPoint(x: 209.34, y: 87.188))
            path.addCurve(to: CGPoint(x: 203.6877, y: 81.5357),
                          control1: CGPoint(x: 206.2228, y: 87.188),
                          control2: CGPoint(x: 203.6877, y: 84.6607))
            path.addLine(to: CGPoint(x: 203.6877, y: 53.2587))
            path.addCurve(to: CGPoint(x: 209.34, y: 47.6064),
                          control1: CGPoint(x: 203.6877, y: 50.1337),
                          control2: CGPoint(x: 206.215, y: 47.6064))
            path.addCurve(to: CGPoint(x: 214.9923, y: 53.2587),
                          control1: CGPoint(x: 212.4689, y: 47.6064),
                          control2: CGPoint(x: 214.9923, y: 50.1337))
            path.addLine(to: CGPoint(x: 214.9923, y: 81.5357))
            path.addCurve(to: CGPoint(x: 209.34, y: 87.188),
                          control1: CGPoint(x: 214.9884, y: 84.6607),
                          control2: CGPoint(x: 212.4689, y: 87.188))
            path.closeSubpath()
          }
        }
      }

      var body: some View {
        PathShape3()
          .fill(Color.black)
      }
    }

    struct PathView4: View { // SVGPath

      struct PathShape4: Shape {

        func path(in rect: CGRect) -> Path {
          Path { path in
            path.move(to: CGPoint(x: 186.01, y: 93.445))
            path.addCurve(to: CGPoint(x: 181.1116, y: 90.613),
                          control1: CGPoint(x: 184.0608, y: 93.445),
                          control2: CGPoint(x: 182.1506, y: 92.4294))
            path.addLine(to: CGPoint(x: 166.9706, y: 66.125))
            path.addCurve(to: CGPoint(x: 169.0409, y: 58.3945),
                          control1: CGPoint(x: 165.4003, y: 63.4219),
                          control2: CGPoint(x: 166.33, y: 59.9609))
            path.addCurve(to: CGPoint(x: 176.7636, y: 60.4687),
                          control1: CGPoint(x: 171.7401, y: 56.832),
                          control2: CGPoint(x: 175.2011, y: 57.7578))
            path.addLine(to: CGPoint(x: 190.9046, y: 84.9567))
            path.addCurve(to: CGPoint(x: 188.8343, y: 92.6833),
                          control1: CGPoint(x: 192.4749, y: 87.6598),
                          control2: CGPoint(x: 191.5452, y: 91.1208))
            path.addCurve(to: CGPoint(x: 186.0101, y: 93.445),
                          control1: CGPoint(x: 187.9437, y: 93.2028),
                          control2: CGPoint(x: 186.9749, y: 93.445))
            path.closeSubpath()
          }
        }
      }

      var body: some View {
        PathShape4()
          .fill(Color.black)
      }
    }

    struct PathView5: View { // SVGPath

      struct PathShape5: Shape {

        func path(in rect: CGRect) -> Path {
          Path { path in
            path.move(to: CGPoint(x: 168.92, y: 110.53))
            path.addCurve(to: CGPoint(x: 166.088, y: 109.7722),
                          control1: CGPoint(x: 167.9512, y: 110.53),
                          control2: CGPoint(x: 166.9786, y: 110.2839))
            path.addLine(to: CGPoint(x: 141.6, y: 95.6312))
            path.addCurve(to: CGPoint(x: 139.5297, y: 87.9046),
                          control1: CGPoint(x: 138.893, y: 94.0687),
                          control2: CGPoint(x: 137.9711, y: 90.6117))
            path.addCurve(to: CGPoint(x: 147.2602, y: 85.8343),
                          control1: CGPoint(x: 141.0922, y: 85.1976),
                          control2: CGPoint(x: 144.5492, y: 84.2757))
            path.addLine(to: CGPoint(x: 171.7482, y: 99.9753))
            path.addCurve(to: CGPoint(x: 173.8185, y: 107.7019),
                          control1: CGPoint(x: 174.4552, y: 101.5378),
                          control2: CGPoint(x: 175.3771, y: 104.9987))
            path.addCurve(to: CGPoint(x: 168.9201, y: 110.53),
                          control1: CGPoint(x: 172.7716, y: 109.5144),
                          control2: CGPoint(x: 170.8732, y: 110.53))
            path.closeSubpath()
          }
        }
      }

      var body: some View {
        PathShape5()
          .fill(Color.black)
      }
    }

    struct PathView6: View { // SVGPath

      struct PathShape6: Shape {

        func path(in rect: CGRect) -> Path {
          Path { path in
            path.move(to: CGPoint(x: 162.66, y: 133.87))
            path.addLine(to: CGPoint(x: 134.394, y: 133.87))
            path.addCurve(to: CGPoint(x: 128.7378, y: 128.2138),
                          control1: CGPoint(x: 131.2651, y: 133.87),
                          control2: CGPoint(x: 128.7378, y: 131.3348))
            path.addCurve(to: CGPoint(x: 134.394, y: 122.5615),
                          control1: CGPoint(x: 128.7378, y: 125.0888),
                          control2: CGPoint(x: 131.2651, y: 122.5615))
            path.addLine(to: CGPoint(x: 162.66, y: 122.5615))
            path.addCurve(to: CGPoint(x: 168.3162, y: 128.2138),
                          control1: CGPoint(x: 165.7772, y: 122.5615),
                          control2: CGPoint(x: 168.3162, y: 125.0888))
            path.addCurve(to: CGPoint(x: 162.66, y: 133.87),
                          control1: CGPoint(x: 168.3162, y: 131.3349),
                          control2: CGPoint(x: 165.7771, y: 133.87))
            path.closeSubpath()
          }
        }
      }

      var body: some View {
        PathShape6()
          .fill(Color.black)
      }
    }

    struct PathView7: View { // SVGPath

      struct PathShape7: Shape {

        func path(in rect: CGRect) -> Path {
          Path { path in
            path.move(to: CGPoint(x: 144.43, y: 171.35))
            path.addCurve(to: CGPoint(x: 139.5316, y: 168.518),
                          control1: CGPoint(x: 142.4808, y: 171.35),
                          control2: CGPoint(x: 140.5784, y: 170.3344))
            path.addCurve(to: CGPoint(x: 141.6019, y: 160.7914),
                          control1: CGPoint(x: 137.9691, y: 165.8149),
                          control2: CGPoint(x: 138.891, y: 162.3539))
            path.addLine(to: CGPoint(x: 166.0819, y: 146.6504))
            path.addCurve(to: CGPoint(x: 173.8124, y: 148.7246),
                          control1: CGPoint(x: 168.7889, y: 145.084),
                          control2: CGPoint(x: 172.2499, y: 146.0137))
            path.addCurve(to: CGPoint(x: 171.7421, y: 156.4512),
                          control1: CGPoint(x: 175.3749, y: 151.4277),
                          control2: CGPoint(x: 174.453, y: 154.8848))
            path.addLine(to: CGPoint(x: 147.2621, y: 170.5882))
            path.addCurve(to: CGPoint(x: 144.4301, y: 171.3499),
                          control1: CGPoint(x: 146.3715, y: 171.1038),
                          control2: CGPoint(x: 145.3988, y: 171.3499))
            path.closeSubpath()
          }
        }
      }

      var body: some View {
        PathShape7()
          .fill(Color.black)
      }
    }

    struct PathView8: View { // SVGPath

      struct PathShape8: Shape {

        func path(in rect: CGRect) -> Path {
          Path { path in
            path.move(to: CGPoint(x: 274.25, y: 171.35))
            path.addCurve(to: CGPoint(x: 271.4297, y: 170.5922),
                          control1: CGPoint(x: 273.2891, y: 171.35),
                          control2: CGPoint(x: 272.3203, y: 171.1039))
            path.addLine(to: CGPoint(x: 246.9417, y: 156.4592))
            path.addCurve(to: CGPoint(x: 244.8714, y: 148.7326),
                          control1: CGPoint(x: 244.2347, y: 154.8967),
                          control2: CGPoint(x: 243.3011, y: 151.4397))
            path.addCurve(to: CGPoint(x: 252.6019, y: 146.6584),
                          control1: CGPoint(x: 246.4339, y: 146.0256),
                          control2: CGPoint(x: 249.8831, y: 145.0959))
            path.addLine(to: CGPoint(x: 277.0819, y: 160.7954))
            path.addCurve(to: CGPoint(x: 279.1522, y: 168.522),
                          control1: CGPoint(x: 279.7889, y: 162.3579),
                          control2: CGPoint(x: 280.7225, y: 165.8149))
            path.addCurve(to: CGPoint(x: 274.2499, y: 171.3501),
                          control1: CGPoint(x: 278.1014, y: 170.3345),
                          control2: CGPoint(x: 276.203, y: 171.3501))
            path.closeSubpath()
          }
        }
      }

      var body: some View {
        PathShape8()
          .fill(Color.black)
      }
    }

    struct PathView9: View { // SVGPath

      struct PathShape9: Shape {

        func path(in rect: CGRect) -> Path {
          Path { path in
            path.move(to: CGPoint(x: 256.02, y: 133.87))
            path.addCurve(to: CGPoint(x: 250.3638, y: 128.2177),
                          control1: CGPoint(x: 252.9028, y: 133.87),
                          control2: CGPoint(x: 250.3677, y: 131.3427))
            path.addCurve(to: CGPoint(x: 256.02, y: 122.5615),
                          control1: CGPoint(x: 250.3638, y: 125.0927),
                          control2: CGPoint(x: 252.9029, y: 122.5615))
            path.addLine(to: CGPoint(x: 284.297, y: 122.5576))
            path.addCurve(to: CGPoint(x: 289.9493, y: 128.2099),
                          control1: CGPoint(x: 287.4142, y: 122.5576),
                          control2: CGPoint(x: 289.9493, y: 125.0849))
            path.addCurve(to: CGPoint(x: 284.297, y: 133.8661),
                          control1: CGPoint(x: 289.961, y: 131.3271),
                          control2: CGPoint(x: 287.422, y: 133.8622))
            path.closeSubpath()
          }
        }
      }

      var body: some View {
        PathShape9()
          .fill(Color.black)
      }
    }

    struct PathView10: View { // SVGPath

      struct PathShape10: Shape {

        func path(in rect: CGRect) -> Path {
          Path { path in
            path.move(to: CGPoint(x: 249.77, y: 110.54))
            path.addCurve(to: CGPoint(x: 244.8716, y: 107.7119),
                          control1: CGPoint(x: 247.8208, y: 110.54),
                          control2: CGPoint(x: 245.9184, y: 109.5244))
            path.addCurve(to: CGPoint(x: 246.9419, y: 99.9814),
                          control1: CGPoint(x: 243.3091, y: 105.0049),
                          control2: CGPoint(x: 244.231, y: 101.5478))
            path.addLine(to: CGPoint(x: 271.4299, y: 85.8334))
            path.addCurve(to: CGPoint(x: 279.1526, y: 87.9037),
                          control1: CGPoint(x: 274.1291, y: 84.2709),
                          control2: CGPoint(x: 277.5901, y: 85.1967))
            path.addCurve(to: CGPoint(x: 277.0823, y: 95.6303),
                          control1: CGPoint(x: 280.7229, y: 90.6029),
                          control2: CGPoint(x: 279.7932, y: 94.0678))
            path.addLine(to: CGPoint(x: 252.6023, y: 109.7783))
            path.addCurve(to: CGPoint(x: 249.7703, y: 110.54),
                          control1: CGPoint(x: 251.7117, y: 110.2939),
                          control2: CGPoint(x: 250.7312, y: 110.54))
            path.closeSubpath()
          }
        }
      }

      var body: some View {
        PathShape10()
          .fill(Color.black)
      }
    }

    struct PathView11: View { // SVGPath

      struct PathShape11: Shape {

        func path(in rect: CGRect) -> Path {
          Path { path in
            path.move(to: CGPoint(x: 232.68, y: 93.445))
            path.addCurve(to: CGPoint(x: 229.8597, y: 92.6911),
                          control1: CGPoint(x: 231.7191, y: 93.445),
                          control2: CGPoint(x: 230.7503, y: 93.2028))
            path.addCurve(to: CGPoint(x: 227.7816, y: 84.9645),
                          control1: CGPoint(x: 227.1527, y: 91.1286),
                          control2: CGPoint(x: 226.2191, y: 87.6677))
            path.addLine(to: CGPoint(x: 241.9226, y: 60.4725))
            path.addCurve(to: CGPoint(x: 249.6531, y: 58.3983),
                          control1: CGPoint(x: 243.4851, y: 57.7655),
                          control2: CGPoint(x: 246.9421, y: 56.8358))
            path.addCurve(to: CGPoint(x: 251.7234, y: 66.1249),
                          control1: CGPoint(x: 252.3601, y: 59.9647),
                          control2: CGPoint(x: 253.282, y: 63.4217))
            path.addLine(to: CGPoint(x: 237.5904, y: 90.6249))
            path.addCurve(to: CGPoint(x: 232.6802, y: 93.4452),
                          control1: CGPoint(x: 236.5396, y: 92.4374),
                          control2: CGPoint(x: 234.6412, y: 93.4452))
            path.closeSubpath()
          }
        }
      }

      var body: some View {
        PathShape11()
          .fill(Color.black)
      }
    }

      
    var body: some View {
        
      ZStack(alignment: .topLeading) {
        Group {
         //touch motion lines are pathview 3->11 ... they'll be animated to "grab attention"
          PathView1()
          PathView2()
          PathView3().offset(y: grabbingAttentionInner ? -tapMotionLinesAttentionGrabMovementAmount : 0)
                .animation(
                    .spring().speed(animationSpeedFactor),
                    value: grabbingAttentionInner)
            
          PathView4().offset(x: grabbingAttentionInner ? -(tapMotionLinesAttentionGrabMovementAmount/2) : 0,
                             y: grabbingAttentionInner ? -(tapMotionLinesAttentionGrabMovementAmount) : 0)
                .animation(
                    .spring().speed(animationSpeedFactor),
                    value: grabbingAttentionInner)
            
          PathView5().offset(x: grabbingAttentionInner ? -(tapMotionLinesAttentionGrabMovementAmount) : 0,
                             y: grabbingAttentionInner ? -(tapMotionLinesAttentionGrabMovementAmount/2) : 0)
                .animation(
                    .spring().speed(animationSpeedFactor),
                    value: grabbingAttentionInner)
            
          PathView6().offset(x: grabbingAttentionInner ? -tapMotionLinesAttentionGrabMovementAmount : 0)
                .animation(
                    .spring().speed(animationSpeedFactor),
                    value: grabbingAttentionInner)
            
          PathView7().offset(x: grabbingAttentionInner ? (-tapMotionLinesAttentionGrabMovementAmount) : 0,
                             y: grabbingAttentionInner ? (tapMotionLinesAttentionGrabMovementAmount/2) : 0)
                .animation(
                    .spring().speed(animationSpeedFactor),
                    value: grabbingAttentionInner)
            
          PathView8().offset(x: grabbingAttentionInner ? (tapMotionLinesAttentionGrabMovementAmount) : 0,
                             y: grabbingAttentionInner ? (tapMotionLinesAttentionGrabMovementAmount/2) : 0)
                .animation(
                    .spring().speed(animationSpeedFactor),
                    value: grabbingAttentionInner)
            
          PathView9().offset(x: grabbingAttentionInner ? tapMotionLinesAttentionGrabMovementAmount : 0)
                .animation(
                    .spring().speed(animationSpeedFactor),
                    value: grabbingAttentionInner)
            
        }
        Group {
          PathView10().offset(x: grabbingAttentionInner ? (tapMotionLinesAttentionGrabMovementAmount) : 0,
                              y: grabbingAttentionInner ? (-tapMotionLinesAttentionGrabMovementAmount/2) : 0)
                 .animation(
                     .spring().speed(animationSpeedFactor),
                     value: grabbingAttentionInner)
            
          PathView11().offset(x: grabbingAttentionInner ? (tapMotionLinesAttentionGrabMovementAmount/2) : 0,
                              y: grabbingAttentionInner ? (-tapMotionLinesAttentionGrabMovementAmount) : 0)
                 .animation(
                     .spring().speed(animationSpeedFactor),
                     value: grabbingAttentionInner)
        }
      }
    }
  }

  var isResizable = true
  func resizable() -> Self { Self(isResizable: true) }
    
  var body: some View {
            
    if isResizable {
      GeometryReader { proxy in
          Group2(grabbingAttentionInner: $grabbingAttention)
          .frame(width: 512, height: 512,
                 alignment: .topLeading)
          .scaleEffect(x: proxy.size.width  / 512,
                       y: proxy.size.height / 512)
          .frame(width: proxy.size.width, height: proxy.size.height).onAppear {
              if(DoubleTapPathView.shouldGrabAttentionOnAppear) {
                  grabbingAttention = true
                  DispatchQueue.main.asyncAfter(deadline: .now() + DoubleTapPathView.attentionGrabAnimationDelayPerStep) {
                      grabbingAttention = false
                      DispatchQueue.main.asyncAfter(deadline: .now() + DoubleTapPathView.attentionGrabAnimationDelayPerStep) {
                          grabbingAttention = true
                          DispatchQueue.main.asyncAfter(deadline: .now() + DoubleTapPathView.attentionGrabAnimationDelayPerStep) {
                              grabbingAttention = false
                          }
                      }
                  }
              }
      }
    }
    }
    else {
        Group2(grabbingAttentionInner: $grabbingAttention)
        .frame(width: 512, height: 512)
    }
  }
}

struct DoubleTapPathView_Previews: PreviewProvider {

  static var previews: some View {
    VStack {
        DoubleTapPathView()
        .resizable()
        .frame(width  : DoubleTapPathView.intrinsicSize.width,
               height : DoubleTapPathView.intrinsicSize.height)
        .background(Color.clear.border(Color.green))
        .padding()
      Text("Size: 512.0x512.0").padding(.bottom)
    }
  }
}
