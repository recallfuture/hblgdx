import 'package:flutter/material.dart';

class FAQ {
  String question;
  String answer;

  FAQ(this.question, this.answer);
}

class FAQPage extends StatelessWidget {
  List<FAQ> _faqList = [
    FAQ(
      '登录失败怎么办？',
      '看看错误提示，大多数情况我已经提示好了，'
          '例外情况是如果有“Timeout”，那是学校服务器超时，'
          '稍等会再登录就进去了；如果没有，请截图并反馈',
    ),
    FAQ(
      '错误码都是什么意思？',
      '400是帐号密码错误，有时候也是因为登录后待了太久，系统自动下线，关闭重开应用就可以了；'
          '403是登陆失败次数过多，本日禁止访问，明天再查吧，去官网也一样；'
          '500是未知错误，情况很多，请先检查网络，不行的话就截图反馈给我',
    ),
    FAQ('课表怎么用不了？', '敬请期待（发出咕咕咕的声音）'),
    FAQ('成绩刷新经常出错怎么办？', '少刷新'),
    FAQ('怎么反馈给你？', '打开侧边栏的问题反馈，那里有说明'),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('常见问题'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: _buildFAQList(),
      ),
    );
  }

  Widget _buildFAQList() {
    return ListView(
      children: List.generate(
        _faqList.length,
        (index) => _buildFAQItem(_faqList[index]),
      ),
    );
  }

  Widget _buildFAQItem(FAQ faq) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '问：${faq.question}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text('答：${faq.answer}'),
          ],
        ),
      ),
    );
  }
}
