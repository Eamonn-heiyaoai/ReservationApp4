import Mine from './Mine';

@Entry
@Component
struct MyMine {
  @Provide('appNavStack') navPathStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.navPathStack) {
      Row() {
        Mine()
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }
}
