import Home from './Home';

@Entry
@Component
struct MyHome {
  @Provide('appNavStack') navPathStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.navPathStack) {
      Row() {
        Home()
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }
}
