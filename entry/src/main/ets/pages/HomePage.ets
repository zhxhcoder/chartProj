import { SimpleLineChart } from '../widget/SimpleLineChart';
import { UpDownText } from '../widget/UpDownText';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct HomePage {
  chartDataList1: string[] =
    ["0.00", "2.86", "3.58", "-0.25", "0.97", "-0.60", "-1.82", "-4.89", "-1.77", "-10.53", "-10.88", "-16.07",
      "-17.80", "-27.07", "-15.98", "-9.41", "-7.31", "-5.43", "-3.31", "-6.63", "-8.51", "-14.72", "-12.95", "-12.80",
      "-8.46", "-11.88", "-9.26", "-12.81", "-10.95", "-11.71", "-6.08", "-9.12", "-9.79", "-4.13", "-5.62", "-9.66",
      "-9.45", "-17.63", "-16.52", "-15.60", "-19.75", "-21.82", "-22.76", "-23.31", "-12.42", "-1.26", "7.63", "8.72",
      "9.02"]
  chartDataList2: string[] =
    ["0.00", "0.07", "0.09", "0.11", "0.13", "0.19", "0.24", "0.37", "0.44", "0.51", "0.57", "0.63", "0.70", "0.82",
      "0.88", "0.93", "0.96", "0.98", "1.02", "1.08", "1.17", "1.25", "1.30", "1.31", "1.36", "1.40", "1.44", "1.49",
      "1.55", "1.57", "1.60", "1.66", "1.68", "1.72", "1.75", "1.81", "1.86", "1.81", "1.83", "1.77", "1.85", "1.87",
      "1.89", "1.89", "1.68", "1.90", "1.89", "1.91", "1.98"]
  controller: webview.WebviewController = new webview.WebviewController();
  scroller: Scroller = new Scroller()
  scrollY: number = 0;

  aboutToAppear(): void {
  }

  /**
   * 滚动事件
   * @param x
   * @param y
   */
  handleScroll() {
    this.scrollY = this.scroller.currentOffset().yOffset

    console.log('【handleScroll】--> ', this.scrollY)

  }

  build() {
    Column() {
      RelativeContainer() {
        Column() { //头部固定位置
          Row()
            .width('100%')

          RelativeContainer() {
            Image($r('app.media.icon_fund_back_white'))
              .width(22)
              .height(22)
              .margin({ left: 16 })
              .onClick(() => {
                // 点击返回按钮

              })
              .alignRules({
                center: { anchor: "__container__", align: VerticalAlign.Center },
                left: { anchor: "__container__", align: HorizontalAlign.Start }
              })

            Text('基金详情')
              .fontSize(20)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .alignRules({
                center: { anchor: "__container__", align: VerticalAlign.Center },
                middle: { anchor: "__container__", align: HorizontalAlign.Center },
              })
          }
          .width('100%')
          .height(56)
        }.backgroundColor('#FFF93A23').id('topBar').alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top },
        })

        Column() { //底部固定位置
          Row() {
            Text("购买费率:")
              .fontSize(12)
              .fontColor('#FF626C7A')

            Text("0.80%")
              .fontSize(12)
              .fontColor('#FF626C7A')

            Text("0.080%")
              .fontSize(12)
              .fontColor('#FFF93A23')
              .margin({ left: 3 })

            Text("10元起购")
              .fontSize(12)
              .fontColor('#FF626C7A')
              .margin({ left: 3 })

          }
          .height(28)
          .backgroundColor(Color.White)
          .alignItems(VerticalAlign.Center)

          Row() {
            Column() {
              Image($r('app.media.icon_fund_add'))
                .width(20)
                .height(20)

              Text("加自选")
                .fontSize(12)
                .fontColor('#FF626C7A')
            }.alignItems(HorizontalAlign.Center).width(56)

            Column() {
              Image($r('app.media.icon_fund_pk'))
                .width(20)
                .height(20)

              Text("对比")
                .fontSize(12)
                .fontColor('#FF626C7A')
            }.alignItems(HorizontalAlign.Center).width(56)

            Row() {
              Text("定投")
                .fontSize(16)
                .fontColor('#FFF93A23')
                .height('100%')
                .backgroundColor('#14F93A23')
                .layoutWeight(0.5)
                .textAlign(TextAlign.Center)

              Text("购买")
                .fontSize(16)
                .height('100%')
                .fontColor(Color.White)
                .backgroundColor('#FFF93A23')
                .layoutWeight(0.5)
                .textAlign(TextAlign.Center)

            }.layoutWeight(1)

          }.height(44).width('100%').backgroundColor(Color.White)
        }
        .alignRules({
          bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
        }).id('bottomBar')

        Scroll(this.scroller) {
          Column() {
            Row() {
              Text("item.labelName")
                .fontSize(13)
                .fontColor(Color.Red)
                .padding({
                  left: 4,
                  right: 4,
                  top: 2,
                  bottom: 2
                })
                .borderRadius(3)
                .borderColor(Color.Red)
                .borderWidth(1)
                .textAlign(TextAlign.Center)

              Text("item.title")
                .fontSize(16)
                .fontColor(Color.Black)
                .height(30)
                .margin({ left: 15 })

            }.alignItems(VerticalAlign.Center)
            .layoutWeight(1)

            Text("2年·VIP会员 3个月期·8GB·230mm·商品颜色")
              .width(200)// 设置最大行数
              .maxLines(1)// 文本超长显示
              .textOverflow({ overflow: TextOverflow.Ellipsis })// 文本超长显示省略号
              .ellipsisMode(EllipsisMode.END)// 设置断行规则WordBreak.BREAK_ALL后实现字母为单位进行截断
              .wordBreak(WordBreak.BREAK_ALL)
              .textAlign(TextAlign.JUSTIFY)
              .backgroundColor(Color.Green)
              .fontSize(16)
              .margin({ top: 5 })

            Row() {
              UpDownText({
                rate: '%888%'
              })
              UpDownText({
                rate: '+156%'
              })
            }.margin({ top: 5 })

            SimpleLineChart({
              canvasWidth: 200,
              canvasHeight: 100,
              canvasColor: Color.White,
              lineColor: Color.Red,
              chartDataList: this.chartDataList1
            }).margin({ top: 5 })

            SimpleLineChart({
              canvasWidth: 300,
              canvasHeight: 200,
              canvasColor: Color.White,
              lineColor: Color.Red,
              chartDataList: this.chartDataList2
            }).margin({ top: 5 })

            UpDownText({
              rate: "--------------"
            }).margin({ top: 300 })

          }.width('100%')

        }.width('100%').id('scroll').alignRules({
          bottom: { anchor: "bottomBar", align: VerticalAlign.Top },
          top: { anchor: "topBar", align: VerticalAlign.Bottom },
        })
        .onDidScroll(() => {
          this.handleScroll()
        })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}