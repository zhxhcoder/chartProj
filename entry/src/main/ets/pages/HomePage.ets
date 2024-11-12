import { SimpleLineChart } from '../components/SimpleLineChart';

@Entry
@Component
struct HomePage {
  @State message: string = 'Hello World';

  build() {
    Column() {

      //lineChart 测试
      SimpleLineChart({
        canvasWidth: 100,
        canvasHeight: 100
      })
    }
    .height('100%')
    .width('100%')
  }
}