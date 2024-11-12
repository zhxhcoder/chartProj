@Component
export struct SimpleLineChart {
  dataList: string[] =
    ["0.00", "2.86", "3.58", "-0.25", "0.97", "-0.60", "-1.82", "-4.89", "-1.77", "-10.53", "-10.88", "-16.07",
      "-17.80", "-27.07", "-15.98", "-9.41", "-7.31", "-5.43", "-3.31", "-6.63", "-8.51", "-14.72", "-12.95", "-12.80",
      "-8.46", "-11.88", "-9.26", "-12.81", "-10.95", "-11.71", "-6.08", "-9.12", "-9.79", "-4.13", "-5.62", "-9.66",
      "-9.45", "-17.63", "-16.52", "-15.60", "-19.75", "-21.82", "-22.76", "-23.31", "-12.42", "-1.26", "7.63", "8.72",
      "9.02"]
  @State pointList: number[][] = []
  @State fillList: number[][] = []
  @State canvasWidth: number = 100
  @State canvasHeight: number = 100

  aboutToAppear(): void {
    this.calcData()
  }

  calcData() {
    if (this.dataList == null || this.dataList.length <= 1) {
      return
    }

    let xStart = 0
    let yStart = this.canvasHeight

    let dataMax = Number.MIN_VALUE
    let dataMin = Number.MAX_VALUE

    let xGap = 0.0
    let yGap = 0.0

    this.dataList.forEach((item) => {
      if (Number(item) > dataMax) {
        dataMax = Number(item)
      }
      if (Number(item) < dataMin) {
        dataMin = Number(item)
      }
    })

    xGap = this.canvasWidth / (this.dataList.length - 1)
    yGap = this.canvasHeight / (dataMax - dataMin)

    let list: number[][] = []
    this.dataList.forEach((item, index) => {
      list.push([xStart + index * xGap, yStart - (Number(item) - dataMin) * yGap])
    })
    this.pointList = list
    let newArr: number[][] = JSON.parse(JSON.stringify(list))
    newArr.push([this.canvasWidth, this.canvasHeight])
    this.fillList = newArr
    console.log('newArr', JSON.stringify(newArr))
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
        .points(this.fillList)
        .fill(Color.Red)
        .fillOpacity(0.06)
    }
  }
}

