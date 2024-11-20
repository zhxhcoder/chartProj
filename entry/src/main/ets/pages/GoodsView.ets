import { cart, MkDialogLoading, MkGoodsItem, MkGuess, MkNavbar } from '@mk/basic'
import { promptAction, router } from '@kit.ArkUI'
import { Goods } from '../models'
import { getGoodsAPI } from '../apis'
import { HmSku, Sku } from '@ohmos/sku'
import { Log } from '@abner/log'
import { CartKey } from '@mk/basic/src/main/ets/apis/cart'


@Component
export struct GoodsView {
  @StorageProp('safeBottom') safeBottom: number = 0
  @StorageProp(CartKey) cartCount: number = 0
  @State goods: Goods = {} as Goods
  // 高亮下标
  @State activeIndex: number = 0
  @State showSheet: boolean = false
  // 购买的商品数量
  @State count: number = 1
  @State loading: boolean = false
  // sku 对象，用于更新界面
  @State sku: HmSku = {} as HmSku
  // tabs 文字(锚点)
  tabs: string[] = ['商品', '评价', '详情', '推荐']
  // 滚动控制器
  scroller = new Scroller()
  // 自定义 loading 弹窗
  loadingDialog = new CustomDialogController({
    builder: MkDialogLoading({ message: '正在加载中...' }), // 自定义 loading 结构
    customStyle: true, // 自定义样式，干掉默认的白色背景和默认圆角
    alignment: DialogAlignment.Center, // 弹窗位置
  })

  aboutToAppear() {
    const params = router.getParams() as Goods
    if (params) {
      // 先保存页面参数，直接赋值给 goods，显示商品的基本信息
      this.goods = params
      // 发送网络请求获取商品详情信息
      this.getData()
    }
  }

  // 获取商品详情
  async getData() {
    // 打开 loading 弹窗
    this.loadingDialog.open()
    // 加载数据
    const res = await getGoodsAPI(this.goods.id)
    this.goods = res.data.result
    // 关闭 loading 弹窗
    this.loadingDialog.close()
  }

  // 加入购物袋
  async addToCart() {
    // 常见错误：空对象 {} 和 [] 都为 true，应该要判断对象/数组是否有某个属性
    // 非空
    if (!this.sku.id) {
      return promptAction.showToast({ message: '请选择商品规格' })
    }
    this.loading = true
    try {
      // 提交到服务器
      await cart.add({
        skuId: this.sku.id,
        count: this.count
      })
      // 服务器查询购物车数量
      cart.count()
      // 关闭弹出面板
      this.showSheet = false
      promptAction.showToast({ message: '加入成功' })
    } finally {
      // finally 不管成功还是失败，都执行
      this.loading = false
    }
  }

  @Builder
  CustomTitleBuilder() {
    // Tabs()
    Row({ space: 10 }) {
      ForEach(this.tabs, (item: string, index: number) => {
        Text(item)
          .fontSize(16)
          .fontColor(this.activeIndex === index ? $r('app.color.black') : $r('app.color.gray'))
          .onClick(() => {
            // 点击更新下标
            this.activeIndex = index
            // 点击自动滚动到对应下标的 ListItem
            this.scroller.scrollToIndex(index)
          })
      })
    }

    // 占满剩余空间，当父组件为Row/Column/Flex时生效
    Blank()
    // 分享图标
    Image($r('app.media.ic_public_shared'))
      .iconButton()
  }

  // 半模态弹窗
  @Builder
  AddCartBuilder() {
    Column() {
      Text('已选: ' + (this.sku.specsText || ''))
        .fontWeight(300)
        .width('100%')
        .fontColor($r('app.color.black'))
        .fontSize(14)
        .padding({ bottom: 10, right: 50 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row({ space: 10 }) {
        Image(this.sku.picture || this.goods.mainPictures?.[0])
          .alt($r('app.media.ic_sku_img'))
          .width(80)
          .height(80)
          .backgroundColor($r('app.color.under'))
          .borderRadius(4)
        Column() {
          Row() {
            Text('现价¥')
              .fontSize(14)
              .fontColor($r('app.color.black'))
              .offset({ y: -4 })
            Text(this.sku.price || this.goods.price)
              .fontSize(24)
              .fontColor($r('app.color.black'))
              .fontWeight(500)
            Text('原价¥' + (this.sku.oldPrice || this.goods.price))
              .fontSize(12)
              .fontColor($r('app.color.gray'))
              .margin({ left: 10 })
              .offset({ y: -4 })
              .decoration({
                type: TextDecorationType.LineThrough,
                color: $r('app.color.gray')
              })
          }
          .alignItems(VerticalAlign.Bottom)

          Row({ space: 10 }) {
            // 计数器组件
            Counter() {
              Text(this.count.toString())
            }
            .enableDec(this.count > 1) // 减少: 不能小于 1
            .enableInc(this.count < (this.sku.inventory || this.goods.inventory)) // 增加: 不能超过库存
            // 点击加号
            .onInc(() => {
              this.count++
            })
            // 点击减号
            .onDec(() => {
              this.count--
            })
            // 默认是 100vp 宽度，超过 4 位数就放不下，自己修复
            .width(100 + this.count.toString()
              .length * 5)

            Text(`库存充足` + (this.sku.inventory || this.goods.inventory))
              .fontSize(12)
              .fontColor($r('app.color.gray'))
          }
        }
        .height(80)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')

      Divider()
        .strokeWidth(4)
        .color($r('app.color.under'))
        .margin({ left: -8, right: -8, top: 13 })

      List() {
        ListItem() {
          Sku({
            // specs 和 skus 都是后端返回的 商品数据
            // 补充：
            //   1. 不同的后端，返回的 商品规格(specs) 和 库存量单位(skus) 信息可能会有差异。如果类型不同，需要按 Sku 组件的类型处理后端返回的数据
            //   2. 不同设计师设计的 SKU 界面会有差异，下载 Sku 模块后，可自行修改组件外观
            specs: this.goods.specs,
            skus: this.goods.skus,
            onSkuChange: (sku: HmSku) => {
              // 控制台输出当前选中的 SKU 信息，备用
              this.sku = sku
            }
          })
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      Row() {
        Button(this.loading ? '加入中...' : '加入购物袋')
          .buyButton($r('app.color.black'), true)
          .onClick(() => {
            // 加入购物袋
            this.addToCart()
          })
        Button('立即购买')
          .buyButton($r('app.color.red'), false)
      }
      .width('100%')
    }
    .height(600)
    .padding({
      left: 16,
      right: 16,
      top: 16,
      bottom: this.safeBottom || 16
    })
  }

  build() {
    Column() {
      // 自定义导航组件(自己封装)
      MkNavbar({
        // 显示右侧图标
        showRightIcon: true,
        // 中间标题部份
        customTitle: () => {
          this.CustomTitleBuilder()
        }
      })
      Column() {
        // 列表组件
        // 指南：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-layout-development-create-list-V5
        List({ scroller: this.scroller }) {
          // 0
          ListItem() {
            // 商品信息
            GoodsInfoComp({ goods: this.goods, showSheet: this.showSheet })
          }

          // 1
          ListItem() {
            // 评论 目前无评论数据
            GoodsCommentComp({ goods: this.goods })
          }

          // 2
          ListItem() {
            // 商品详情
            GoodsDetailComp({ goods: this.goods })
          }

          // 3
          ListItem() {
            // 猜你喜欢
            MkGuess()
          }

          ListItem() {
            Button('点击返回顶部')
              .onClick(() => {
                // 点击返回顶部
                // 补充：Grid、List、WaterFlow 组件都支持
                this.scroller.scrollToIndex(0)
              })
          }
        }
        // 滚动到 ListItem 的时候，会自动触发 onScrollIndex，形参可获取到 index 下标
        .onScrollIndex((index) => {
          // 更新 activeIndex 实现 tabs 锚点的联动效果
          this.activeIndex = index
        })
        .scrollBar(BarState.Off)
        .width('100%')
        .height('100%')
      }
      .layoutWeight(1)
      .backgroundColor($r('app.color.under'))

      Row() {
        Image($r('app.media.ic_public_like'))
          .iconButton()
        Image($r('app.media.ic_public_comment'))
          .iconButton()
        // 角标
        Badge({
          count: this.cartCount,
          style: {},
          position: { x: 30, y: 4 }
        }) {
          Image($r('app.media.ic_public_cart'))
            .iconButton()
            .onClick(() => {
              // 返回首页，并切换 Tabs 到购物袋
              router.back({ url: 'pages/Index', params: { index: 2 } })
            })
        }

        Row() {
          Button('加入购物袋')
            .buyButton($r('app.color.black'), true)
            .onClick(() => this.showSheet = true)
          Button('立即购买')
            .buyButton($r('app.color.red'), false)
            .onClick(() => this.showSheet = true)
        }
        .layoutWeight(1)
        .padding({ right: 16, left: 6 })
      }
      .height(54)
      .width('100%')
      .margin({ bottom: this.safeBottom })
    }
    .height('100%')
    .bindSheet($$this.showSheet, this.AddCartBuilder(),
      { height: SheetSize.FIT_CONTENT, backgroundColor: $r('app.color.white') })
  }
}

@Extend(Image)
function iconButton() {
  .width(24)
  .aspectRatio(1)
  .margin(13)
  .fillColor($r('app.color.black'))
}

@Extend(Button)
function buyButton(color: ResourceStr, isLeft: boolean) {
  .fontSize(14)
  .height(36)
  .type(ButtonType.Normal)
  .layoutWeight(1)
  .backgroundColor(color)
  .borderRadius({
    topLeft: isLeft ? 18 : 0,
    bottomLeft: isLeft ? 18 : 0,
    topRight: isLeft ? 0 : 18,
    bottomRight: isLeft ? 0 : 18
  })
  .pixelRound({
    end: PixelRoundCalcPolicy.FORCE_CEIL,
    start: PixelRoundCalcPolicy.FORCE_FLOOR
  })
}

@Component
struct GoodsInfoComp {
  @Prop goods: Goods = {} as Goods
  @Link showSheet: boolean

  build() {
    Column() {
      // 有 多张图片显示轮播图
      if (this.goods.mainPictures && this.goods.mainPictures.length) {
        Swiper() {
          ForEach(this.goods.mainPictures, (src: string) => {
            Image(src)
          })
        }
        .cachedCount(5)
        .indicator(Indicator.digit()
          .right(10)
          .bottom(6))
        .width('100%')
        .aspectRatio(1)
      } else {
        // 没有展示主图片
        Image(this.goods.picture)
          .width('100%')
          .aspectRatio(1)
      }

      Column() {
        Text() {
          Span('¥ ')
          Span(this.goods.price.toString())
            .fontSize(24)
        }
        .width('100%')
        .fontWeight(500)
        .fontColor($r('app.color.black'))
        .margin({ bottom: 8, top: 8 })

        Text(this.goods.name)
          .width('100%')
          .fontColor($r('app.color.text'))
          .margin({ bottom: 8 })
        Text(this.goods.desc)
          .fontSize(13)
          .width('100%')
          .fontColor($r('app.color.gray'))
          .margin({ bottom: 8 })

        Column() {
          Row({ space: 8 }) {
            Text('商品规格')
              .fontSize(13)
              .fontWeight(500)
              .fontColor($r('app.color.black'))
            Text('请选择')
              .fontSize(13)
              .fontColor($r('app.color.gray'))
            Blank()
            Image($r('app.media.ic_public_right'))
              .width(20)
              .aspectRatio(1)
              .fillColor($r('app.color.gray'))
          }
          .width('100%')
          .height(40)
          .onClick(() => this.showSheet = true)

          Row() {
            Text('无忧退货 · 快速退款 · 免费包邮')
              .fontColor($r('app.color.text'))
              .fontSize(13)
            Blank()
            Image($r('app.media.ic_public_right'))
              .width(20)
              .aspectRatio(1)
              .fillColor($r('app.color.gray'))
          }
          .width('100%')
          .height(40)
          .border({
            width: { top: 0.5 },
            color: $r('app.color.under')
          })
        }
      }
      .backgroundColor($r('app.color.white'))
      .borderRadius(8)
      .margin(8)
      .padding(8)
    }
  }
}

@Component
struct GoodsCommentComp {
  goods: MkGoodsItem = {} as MkGoodsItem

  build() {
    Column() {
      Row() {
        Text('商品评价')
          .fontSize(13)
          .fontWeight(700)
          .fontColor($r('app.color.black'))
          .margin({ right: 8 })
        Text('(100+)')
          .fontSize(13)
          .fontColor($r('app.color.gray'))
        Blank()
        Text('查看全部')
          .fontSize(13)
          .fontColor($r('app.color.gray'))
        Image($r('app.media.ic_public_right'))
          .width(20)
          .aspectRatio(1)
          .fillColor($r('app.color.gray'))
      }
      .width('100%')
      .height(40)

      ForEach(new Array(2).fill(0), () => {
        Column({ space: 8 }) {
          Row() {
            Image($r('app.media.goods_avatar'))
              .width(24)
              .aspectRatio(1)
              .margin({ right: 8 })
            Text('匿名用户1259')
              .fontColor($r('app.color.black'))
              .fontSize(14)
          }
          .width('100%')

          Row() {
            Text('黑色·公开版·128G')
              .fontColor($r('app.color.gray'))
              .fontSize(12)
            Blank()
            Text('昨天23.45')
              .fontColor($r('app.color.gray'))
              .fontSize(12)
          }
          .width('100%')

          Text('HUAWEI Pura 70 Ultra 创新性采用超聚光伸缩主摄，搭载1英寸大底传感器、以及1英寸传感器中最大的F1.6物理光圈，带来业界最大的主摄进光量。')
            .fontColor($r('app.color.text'))
            .fontSize(13)

          Row({ space: 8 }) {
            ForEach(new Array(3).fill(0), () => {
              Image(this.goods.picture)
                .width(80)
                .aspectRatio(1)
            })
          }
          .width('100%')
        }
        .margin({ top: 16 })
      })
    }
    .backgroundColor($r('app.color.white'))
    .borderRadius(8)
    .margin({ left: 8, right: 8, bottom: 8 })
    .padding(8)
  }
}

@Component
struct GoodsDetailComp {
  @Prop goods: Goods = {} as Goods

  build() {
    Column() {
      Row() {
        Text('商品详情')
          .fontSize(13)
          .fontWeight(700)
          .fontColor($r('app.color.black'))
          .margin({ left: 16 })
      }
      .width('100%')
      .height(50)

      ForEach(this.goods.details?.pictures, (src: string) => {
        Image(src)
          .width('100%')
      })
    }
    .backgroundColor($r('app.color.white'))
    .margin({ bottom: 8 })
  }
}