import { FinancingLineChart } from '../components/FinancingLineChart';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {

      // lineChart 测试
      FinancingLineChart({
        canvasWidth: 100,
        canvasHeight: 100
      })
    }
    .height('100%')
    .width('100%')
  }
}