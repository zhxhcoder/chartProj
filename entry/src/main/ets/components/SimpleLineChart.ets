@Component
export struct SimpleLineChart {
  @State message: string = 'Hello World';
  lineList: string[] =
    ["0.00", "0.07", "0.12", "0.12", "0.15", "0.19", "0.25", "0.32", "0.43", "0.51", "0.57", "0.62", "0.69", "0.74",
      "0.87", "0.93", "0.98", "0.98", "1.03", "1.07", "1.16", "1.26", "1.34", "1.28", "1.36", "1.42", "1.45", "1.49",
      "1.54", "1.59", "1.61", "1.66", "1.70", "1.73", "1.76", "1.81", "1.89", "1.83", "1.86", "1.83", "1.85", "1.89",
      "1.93", "1.94", "1.65", "1.89", "1.91", "1.91", "1.97"]
  @State formatterLineList: number[][] = []
  @State fillList: number[][] = []
  @State canvasWidth: number = 100
  @State canvasHeight: number = 100

  aboutToAppear(): void {
    let list: number[][] = []
    this.lineList.forEach((item, index) => {
      list.push(
        [(index) * (100 / (this.lineList.length - 1)), (200 - Number(item) * 100) / 2]
      )
    })
    console.log('list-->', JSON.stringify(list), list.length)
    this.formatterLineList = list
    let newArr: number[][] = JSON.parse(JSON.stringify(list))
    newArr.push([100, 100])
    this.fillList = newArr
    console.log('newArr', JSON.stringify(newArr))
  }

  build() {
    Stack() {
      Polyline({ width: this.canvasWidth, height: this.canvasHeight })
        .points(this.formatterLineList)
        .stroke(Color.Red)
        .fillOpacity(0.0)
        .strokeWidth(1)
        .strokeLineJoin(LineJoinStyle.Round)
        .zIndex(1)

      Polygon({ width: this.canvasWidth, height: this.canvasHeight })
        .points(this.fillList)
        .stroke(Color.White)
        .fill(Color.Red)
        .fillOpacity(0.1)
    }
  }
}
