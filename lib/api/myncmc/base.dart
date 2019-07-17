/// 我的煤医的基础url
const String baseUrl = 'http://www.myncmc.com/zt_jda.aspx';

/// 获取session用的url
const String sessionUrl = baseUrl + '?yzm=type';

/// 登录验证码文本地址
const String validateCodeStringUrl = baseUrl + '?type=yzm';

/// 登录验证码图片地址
const String validateCodeUrl = baseUrl + '?type=yzm_x';

/// 登录地址
///
/// 参数：
/// zjh: 学号
/// mm: 密码
/// v_yzm: 验证码
const String loginUrl = baseUrl + '?type=login';

/// 获取学生基本信息
const String infoUrl = baseUrl + '?type=read&ch=info';

/// 准备成绩单
const String prepareUrl = baseUrl + '?type=read&ch=cjdq';

/// 成绩查询地址
const String scoreUrl = baseUrl + '?type=read&ch=cjjs';
