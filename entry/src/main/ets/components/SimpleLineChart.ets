/*
共用的简单折线图
      SimpleLineChart({
        canvasWidth: 52,
        canvasHeight: 45,
        canvasColor: Color.White,
        lineColor: Color.Red,
        chartDataList: this.chartDataList
      })
 */
@Component
export struct SimpleLineChart {
  @State chartDataList: string[] = []
  @State pointList: number[][] = []
  @State angleList: number[][] = []
  @State canvasWidth: number = 0
  @State canvasHeight: number = 0
  @State canvasColor: Color = Color.White
  @State lineColor: Color = Color.Red
  @State gradientColor: Color = 0x1Aff0000

  aboutToAppear(): void {
    this.calcData()
  }

  calcData() {
    if (this.chartDataList == null || this.chartDataList.length <= 1) {
      return
    }

    let dataMax = Number.MIN_VALUE
    let dataMin = Number.MAX_VALUE

    let xGap = 0.0
    let yGap = 0.0

    this.chartDataList.forEach((item) => {
      if (Number(item) > dataMax) {
        dataMax = Number(item)
      }
      if (Number(item) < dataMin) {
        dataMin = Number(item)
      }
    })

    xGap = this.canvasWidth / (this.chartDataList.length - 1)
    yGap = this.canvasHeight / (dataMax - dataMin)

    let tempPoints: number[][] = []
    this.chartDataList.forEach((item, index) => {
      tempPoints.push([index * xGap, this.canvasHeight - (Number(item) - dataMin) * yGap])
    })
    this.pointList = tempPoints

    let tempAngles: number[][] = []
    tempAngles.push([0, 0])
    tempPoints.forEach((item) => {
      tempAngles.push(item)
    })
    tempAngles.push([this.canvasWidth, 0])

    this.angleList = tempAngles
    console.log('newArr', JSON.stringify(tempAngles))
  }

  build() {
    Stack() {
      Polyline({ width: this.canvasWidth, height: this.canvasHeight })
        .points(this.pointList)
        .stroke(this.lineColor)
        .fillOpacity(0.0)
        .strokeWidth(1)
        .strokeLineJoin(LineJoinStyle.Round)
        .zIndex(1)

      Polygon({ width: this.canvasWidth, height: this.canvasHeight })
        .points(this.angleList)
        .fill(this.canvasColor)
        .fillOpacity(1)

    }.linearGradient({
      direction: GradientDirection.Bottom,
      repeating: false,
      colors: [[this.gradientColor, 0.0], [this.canvasColor, 1.0]]
    })
    .backgroundColor(this.canvasColor)
  }
}

