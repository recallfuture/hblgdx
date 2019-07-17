/// 教务系统的基础url
/// 同时也是登录页面地址
/// 不能用在dio里初始化，因为还有教学系统，他们的baseUrl不同
const String baseUrl = 'http://xjw1.ncst.edu.cn/';

/// 登录验证码地址
const String validateCodeUrl = baseUrl + 'validateCodeAction.do';

/// 登录post地址
const String loginUrl = baseUrl + 'loginAction.do';

/// 注销地址
const String logoutUrl = baseUrl + 'logout.do';

/// 全部及格成绩查询地址
const String jgScoreUrl = baseUrl + 'gradeLnAllAction.do?type=ln&oper=qb';

/// 不及格成绩查询地址
const String bjgScoreUrl = baseUrl + 'gradeLnAllAction.do?type=ln&oper=bjg';
