import UpdateTest from './Update.test'
import localUnitTest from './LocalUnit.test';

export default function testsuite() {
  localUnitTest();
  UpdateTest()
}