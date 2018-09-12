.. _http:

HTTP消息模块 [HTTP]
=============================

HTTP模块是基于 https://www.php-fig.org/psr/psr-7/ 的实现。

如何安装？
-------------------------

#. 通过 `composer`_ 安装::

    composer require asbamboo/http
    
#. 从 https://github.com/asbamboo/http 获取。

说明
------------------------------

http模块里面有一个psr目录，该目录下文件是根据 `psr-7`_ 规范编写的基础的http-message类。然后在psr文件目录的外面，是psr基础上做了一些扩展的方法。主要扩展有：

#.  ServerRequest扩展了getCookieParam(获取cookie的某个键值)，getQueryParam（获取$_GET中的某个键值），getRequestParams（获取$_REQUEST值），getRequestParam（获取$_REQUEST某个键值），getPostParams（获取$_POST值），getPostParam（获取$_POST某个键值）

#. Response扩展了几个方法
    * addHeader 添加 header 信息 与withHeader区别是这个addHeader return $this;
    * setBody 设置 Body 信息 与withBody区别是这个setBody return $this;
    * sendHeaders 发送响应消息头
    * sendBody 发送响应消息主体
    * send 发送响应的消息头和消息主体

#. 添加了 RedirectResponse 返回一个目标跳转的消息，默认http_code 302。添加了 JsonResponse 返回一个消息内容是json字符串响应信息


.. _composer: https://getcomposer.org/
.. _psr-7: https://www.php-fig.org/psr/psr-7/