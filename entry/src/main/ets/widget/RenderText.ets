import { NodeController, FrameNode, RenderNode, DrawContext } from '@kit.ArkUI'
import { UIContext } from '@kit.ArkUI'
import { drawing } from '@kit.ArkGraphics2D'
import { text } from '@kit.ArkGraphics2D'
import { image } from '@kit.ImageKit'
import { common2D } from '@kit.ArkGraphics2D'




// 创建一个MyRenderNode类，并绘制文本。
class MyRenderNode extends RenderNode {

  async draw(context: DrawContext) {
    // ...
    // 创建画布canvas对象
    const canvas = context.canvas
    // 创建一个画笔Pen对象，Pen对象用于形状的边框线绘制
    let pen = new drawing.Pen()
    let pen_color : common2D.Color = { alpha: 0xFF, red: 0xFF, green: 0x00, blue: 0x00 }
    pen.setColor(pen_color)

    // 将Pen画笔设置到canvas中
    canvas.attachPen(pen)

    // 创建一个画刷Brush对象，Brush对象用于形状的填充
    let brush = new drawing.Brush()
    let brush_color : common2D.Color = { alpha: 0xFF, red: 0x00, green: 0xFF, blue: 0x00 }
    brush.setColor(brush_color)

    // 将Brush画刷设置到canvas中
    canvas.attachBrush(brush)

    //字体颜色，字重，字体大小等属性由此设置
    let myTextStyle: text.TextStyle = {
      color: { alpha: 255, red: 255, green: 0, blue: 0 },
    };
    //断词类型，换行策略，文本方向以及对齐方式由此设置
    let myParagraphStyle: text.ParagraphStyle = {
      textStyle: myTextStyle,
      align: 3,
      //wordBreak:text.WordBreak.NORMAL 文本断词类型
    };
    let fontCollection = new text.FontCollection();
    let ParagraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
    //更新文本样式
    ParagraphGraphBuilder.pushStyle(myTextStyle);
    //添加文本
    ParagraphGraphBuilder.addText("0123456789");
    //生成段落
    let paragraph = ParagraphGraphBuilder.build();
    // 布局
    paragraph.layoutSync(600);
    //绘制文本
    paragraph.paint(canvas, 0, 0);

  }
}