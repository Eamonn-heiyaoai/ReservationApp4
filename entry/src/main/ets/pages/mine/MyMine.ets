import Mine from './Mine';

@Entry
@Component
struct MyMine{
  build(){
    Row() {
      Mine();
    }.width('100%')
    .height('100%')
  }
}