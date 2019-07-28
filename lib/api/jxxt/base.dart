/// 教学系统的基础url
/// 不能用在dio里初始化，因为还有教务系统，他们的baseUrl不同
const String baseUrl = 'http://elearning.ncst.edu.cn/meol/';

/// 登录地址
const String loginUrl = baseUrl + 'loginCheck.do';

/// 注销地址
const String logoutUrl = baseUrl + 'homepage/V8/include/logout.jsp';

/// 未完成作业的列表地址
const String reminderListUrl =
    baseUrl + 'welcomepage/student/interaction_reminder_v8.jsp';

/// 进入课程页面的地址
///
/// 参数：
/// courseId
const String courseUrl = baseUrl + 'jpk/course/layout/newpage/index.jsp';

/// 作业列表地址
const String homeworkListUrl = baseUrl + 'common/hw/student/hwtask.jsp';

/// 作业详情地址
///
/// 参数：
/// hwtid
const String homeworkDetailUrl = baseUrl + 'common/hw/student/hwtask.view.jsp';

/// 所有课程列表的地址
const String courseListUrl = baseUrl + 'welcomepage/student/course_list_v8.jsp';

/// 课程资源列表地址
///
/// 参数：
/// lid
/// folderid
const String resourceListUrl = baseUrl + 'common/script/listview.jsp';

/// 资源下载地址
///
/// 参数：
/// fileid
/// lid
/// folderid
const String resourceDownloadUrl = baseUrl + 'common/script/download.jsp';

/// 资源下载地址
///
/// 参数：
/// fileid
/// lid
/// resid
const String resourceDownloadPreviewUrl = baseUrl +
    'common/script/preview/download_preview.jsp';
