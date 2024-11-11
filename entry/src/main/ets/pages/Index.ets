@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Polyline({ width: 100, height: 100 })
        .points([[0, 100], [20, 80], [40, 60], [60, 45], [80, 10], [100, 0]])
        .fillOpacity(0)
        .stroke(Color.Blue)
        .strokeWidth(3)
        .strokeLineJoin(LineJoinStyle.Round)
        .fillOpacity(0.1)
        .backgroundColor(Color.Yellow)
        .fill(Color.Red)

      Polygon({ width: 100, height: 100 })
        .points([[0, 100], [20, 80], [40, 60], [60, 45], [80, 10], [100, 0]])
        .backgroundColor(Color.Yellow)
        .fill(Color.Red)
        .margin({ top: 30 })
    }
    .height('100%')
    .width('100%')
  }
}