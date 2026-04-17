//导入主页组件
import Home from './Home';

@Entry//入口装饰器,表示可以渲染内容
@Component //为了其它组件直接通过路径调用
struct MyHome {
  build(){
    Row() {
      Home();
    }.width('100%')
    .height('100%')
  }

}