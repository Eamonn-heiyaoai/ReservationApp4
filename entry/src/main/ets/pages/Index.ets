//导入App.ets
import App from './app/App';
@Entry//能够直接加载运行的页面组件
@Component
struct Index {
  //生成UI
  build() {
    //列布局
     Column(){
       //使用导入的主组件
       App();
    }
    .height('100%')
    .width('100%')
     //水平居中
    .alignItems(HorizontalAlign.Center)
  }
}