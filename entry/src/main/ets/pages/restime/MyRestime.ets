import Restime from './Restime';
/**
 * 导入预约时间
 */
@Entry
@Component
struct MyRestime{
  build(){
    Row() {
      Restime();
    }.width('100%')
    .height('100%')
  }
}