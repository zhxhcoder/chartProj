@Component
export struct UpDownText {
  @State rate: string = '';
  @State bigSize: number = 19;
  @State smallSize: number = 13;

  aboutToAppear(): void {

  }

  build() {
    Row() {
      Text(this.rate.substring(0, this.rate.length))
        .fontSize(this.bigSize)
        .fontColor(UpDownText.getRateColor(this.rate))

      if (this.rate != null && this.rate.endsWith('%')) {
        Text('%')
          .fontSize(this.smallSize)
          .fontColor(UpDownText.getRateColor(this.rate))
          .margin({ bottom: (this.bigSize - this.smallSize) / 3 })
      }
    }
    .alignItems(VerticalAlign.Bottom)
  }

  /*
 获取涨跌幅颜色
  */
  public static getRateColor(rate?: string): string {
    let colorRed = "#ED3E3E"
    let colorGreen = "#00945E"
    let colorEven = "#232733"

    if (rate == null || rate.trim() == "") {
      return colorEven
    }
    if (rate.startsWith("+") || parseFloat(rate.replace("%", "")) > 0) {
      return colorRed
    } else if (rate.startsWith("-")) {
      return colorGreen
    }
    return colorEven
  }
}