# 华北理工大学综合查询APP

用flutter写的华北理工大学综合查询APP，查询结果爬取自华北理工大学教学系统和教务系统。

## 开始

把项目clone或下载到本地，然后用idea，vs code之类ide的打开即可，推荐用idea。

## 目录结构

```
.
├── android                             // 导出成安卓所需的配置文件夹
├── lib                                 // 主代码目录
│   ├── api                             // 封装访问网站并获取数据的一系列api
│   │   ├── jwxt                        // 教务系统的api
│   │   └── jxxt                        // 教学系统的api
│   ├── model                           // 实体类
│   └── utils                           // 工具类
├── pubspec.lock
├── pubspec.yaml
├── README.md
└── test                                // 测试代码目录
```

## 文档

### utils/request.dart

封装了dio常用操作，如get，post，还有直接获取响应文本的方法。

### utils/regex.dart

封装了常用的正则匹配方法。

### api/jxxt/base.dart

教学系统api的所用到的所有链接地址。

### api/jxxt/login.dart

教学系统的登录和注销方法，注意登录时需要post提交csrf token。
