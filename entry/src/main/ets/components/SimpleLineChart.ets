@Component
export struct SimpleLineChart {
  @State chartDataList: string[] = []
  @State pointList: number[][] = []
  @State angleList: number[][] = []
  @State canvasWidth: number = 0
  @State canvasHeight: number = 0

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
    tempAngles.push([0, this.canvasHeight])
    tempPoints.forEach((item) => {
      tempAngles.push(item)
    })
    tempAngles.push([this.canvasWidth, this.canvasHeight])

    this.angleList = tempAngles
    console.log('newArr', JSON.stringify(tempAngles))
  }

  build() {
    Stack() {
      Polyline({ width: this.canvasWidth, height: this.canvasHeight })
        .points(this.pointList)
        .stroke(Color.Red)
        .fillOpacity(0.0)
        .strokeWidth(1)
        .strokeLineJoin(LineJoinStyle.Round)
        .zIndex(1)

      Polygon({ width: this.canvasWidth, height: this.canvasHeight })
        .points(this.angleList)
        .fill(Color.Red)
        .fillOpacity(0.06)
    }
  }
}

