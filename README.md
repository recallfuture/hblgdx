# 华北理工大学综合查询APP

用flutter写的华北理工大学综合查询APP，查询结果爬取自华北理工大学教学系统和教务系统还有我的煤医，地址如下：

- http://elearning.ncst.edu.cn/
- http://xjw1.ncst.edu.cn/
- http://www.myncmc.com/zt_jda.aspx

## 功能

- [ x ] 一键登录教学系统和教务系统
- [ x ] 查询未完成作业（来自教学系统）
- [ ] 课程表
- [ x ] 查询课程资源并下载到本地（来自教学系统）
- [ x ] 查询本学期的成绩（来自我的煤医）

## 开始

把项目clone或下载到本地，然后用idea，vs code之类ide的打开即可，推荐用idea。

## 目录结构

```
.
├── android                             // 导出成安卓所需的配置文件夹
├── assets                              // （图片）资源文件目录
├── lib                                 // 主代码目录
│   ├── api                             // 封装访问网站并获取数据的一系列api
│   │   ├── jwxt                        // 教务系统的api
│   │   └── jxxt                        // 教学系统的api
│   ├── components                      // 页面所用到的组件
│   ├── model                           // 实体类
│   ├── pages                           // 页面类
│   └── utils                           // 工具类
├── pubspec.lock
├── pubspec.yaml
├── README.md
└── test                                // 测试代码目录
```

## 使用的插件

- dio: 网络请求
- gbk2utf8: 编码转换
- cookie_jar: cookie解析和存储
- shared_preferences: 本地存储
- html: 解析dom树
- flutter_html: 可以展示html的Widget
- json_annotation: json编解码库
- oktoast: 显示悬浮在内容上的通知
- permission_handler: 用来检测和获取权限
- open_file: 用其他应用打开文件
- downloads_path_provider: 获取外置存储上的下载目录

## 待优化

- 课程表
- 更好的错误处理（少判断null，多用throw）
- 更好的组件化

## 注意事项

### 教学系统

- 页面都是gbk编码
- 登录时需要先从页面上获取csrf token，再同表单一起发送过去
- 登录失败五次的话会锁账号，隔日解除

### 教务系统

- 页面都是gbk编码
- 登录时需要先获取验证码，展示给用户并等待其提交表单数据和验证码，再一起发送过去

### 我的煤医（成绩学分查询）

- 可以自动获取验证码
- 页面和接口数据是utf8格式的
- 使用接口前需要先访问一个地址以获得必须的session
- 登录的时候可以通过它的接口实现免验证码登录
- 获取验证码的接口有时候会超时
- 学分查询不需要做教师评估也可以得到结果

## 开源协议

MIT
