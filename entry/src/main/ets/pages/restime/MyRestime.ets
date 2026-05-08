import Restime from './Restime';

@Entry
@Component
struct MyRestime {
  @Provide('appNavStack') navPathStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.navPathStack) {
      Row() {
        Restime()
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }
}
