import Know from './Know'

@Entry
@Component
struct MyKnow {
  @Provide('appNavStack') navPathStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.navPathStack) {
      Column() {
        Know()
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }
}
