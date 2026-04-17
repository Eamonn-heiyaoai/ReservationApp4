//导入场运动常识组件，直接在此网页中单独渲染
import Know from './Know'

//通过路由直接打开的页面
@Entry
  //Entry组件装饰器,直接渲染内容
@Component
  //自定义组件装饰器
struct MyKnow {
  //生成UI
  build() {
    //最外层必须有一个布局容器组件
    Column() {
      //使用Know组件
      Know();
    }
  }
}