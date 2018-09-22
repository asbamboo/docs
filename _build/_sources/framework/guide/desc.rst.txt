.. framework_guide_desc

本指南准备实现的demo说明
===========================

本demo只是为了说明 `asbamboo/framework`_ 的使用， 你可能会觉得代码有很多的逻辑、安全、或者异常处理方面的问题，请见谅。

我们将做一个具有如下功能的demo
--------------------------------

#. 通过命令行工具可以在服务端添加超级管理员 
#. 超级管理员可以登录后添加一般管理员
#. 一般管理员，和超级管理员都能工发布和编辑文章
#. 匿名用户可以通过http请求查看到发布的文章信息

开始
----------------------

:doc:`建立数据模型 <model>`

:doc:`创建init命令 <initcmd>`

:doc:`创建admin命令 <admincmd>`

:doc:`修改html皮肤布局 <layout>`

:doc:`创建用户管理程序 <user>`

:doc:`创建文章管理程序 <post>`

:doc:`主页显示文章列表 <home>`

:doc:`登录与注销 <login>`

:doc:`配置权限<auth>`

:doc:`创建自定义异常处理页面 <exception>`



通过本指南你会了解
---------------------------

:doc:`命令行程序的使用 <command>`

:doc:`配置文件 <configure>`

:doc:`使用路由 <route>`

:doc:`数据操作 <database>`

:doc:`视图模板的使用 <template>`

:doc:`事件监听 <../../event/index>`



.. _asbamboo/framework: https://github.com/asbamboo/framework