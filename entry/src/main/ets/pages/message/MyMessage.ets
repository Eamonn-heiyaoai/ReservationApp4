import Message from './Message'

@Entry
@Component
struct MyMessage {
  @Provide('appNavStack') navPathStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.navPathStack) {
      Column() {
        Message()
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }
}
