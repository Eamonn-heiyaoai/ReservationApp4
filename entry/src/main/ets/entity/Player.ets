/**
 * 健身报名实体类：需要锻炼用户
 * 用户状态设置：请简化判断
 */
function setState(resDate: string) { //类外边声明方法
  //用户报名时日期
  let temp1 = new Date(resDate);
  const ryear = temp1.getFullYear();
  const rmonth = temp1.getMonth();
  const rdate = temp1.getDate();
  //今天的日期
  let temp2 = new Date();
  const nyear = temp2.getFullYear();
  const nmonth = temp2.getMonth();
  const ndate = temp2.getDate();
  ////生成比较对象,不太准确：2024-6-29要大于2024-12-1，要分别如下比较年，月，日才行
  if (ryear > nyear) { //先比较年份
    return '预约中'
  } else if (ryear == nyear) { //先比较年份
    if (rmonth > nmonth) {
      return '预约中'
    } else if (rmonth < nmonth) {
      return '已结束'
    } else {
      if (rdate > ndate) {
        return '预约中'
      } else if (rdate == ndate) {
        return '进行中'
      } else {
        return '已结束';
      }
    }
  } else { //比较年份
    return '已结束';
  }
}
//实体类
export default class Player {
  //报名用户名称
  name: string;
  gender: string;
  //由手机号惟一识别用户
  mobile: string;
  //预约的场馆
  venue: string;
  //预约日期
  pdate: string;
  //预约状态：进行中，已结束，已预约
  state: string = '预约中';

  constructor(name: string, gender: string, mobile: string, venue: string, pdate: string) {
    this.name = name;
    this.gender = gender;
    this.mobile = mobile;
    this.venue = venue;
    this.pdate = pdate;
    this.state = setState(pdate);
  }
}