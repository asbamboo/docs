.. _router:

路由模块[router]
=============================

路由模块控制http请求的url，与处理这个url的回调方法之间的对应关系。每一个请求url都应该有一个对应的路由标识符（router id），router模块的主要功能是：
    * 通过给定的router id和一些参数生成一个url（这个url可以使用在html a标签上）
    * 匹配当前request的callback方法，并且执行callback。

如何安装？
-------------------------

#. 通过 `composer`_ 安装::

    composer require asbamboo/router
    
#. 从 https://github.com/asbamboo/router 获取。


如何使用？
------------------------

本代码示例演示了Router组件如何实现经典的输出Hello Word程序。 

::

    <?php
    use asbamboo\router\Route;
    use asbamboo\router\RouteCollection;
    use asbamboo\router\Router;
    use asbamboo\http\Response;
    use asbamboo\http\Stream;
        

    $RouteCollection   = new RouteCollection();
    $RouteCollection->add(new Route('home', '/', function(){
        $Body       = new Stream('php://temp', 'w+b');
        $Body->write('hello word.');
        return new Response($Body);
    }));

    $RouteCollection->add(new Route('hello', '/hello/{name}', function($name){
        $Body       = new Stream('php://temp', 'w+b');
        $Body->write('hello' . $name);
        return new Response($Body);
    }, 'XX先生'));

    $Router             = new Router($RouteCollection);

    $Router->matchRequest()->send();


使用Router生成url
------------------------------------------

使用router组件生成url很简单

::

<?php

    ... 

    // 如果省略的部分代码是Hello Word演示中的部分代码
    // 生成的url 结果为 /hello/X%E5%A5%B3%E5%A3%AB
    $Router->generateUrl('hello', ['name' => 'X女士']);

使用一组数组信息生成RouteCollection
-------------------------------------------------

Router模块内有一个 asbamboo\\router\\loader\\LoaderByArray 类被用来将一组数组信息转化成 RouteCollection

::

    <?php 
    
    use asbamboo\router\RouteCollection;
    use asbamboo\router\loader\LoaderByArray;

    // 这个示例中路由test2的callback传递的是一个字符串(格式为"类名:方法名")
    // 这样的callback参数等同于 [new TestClass, 'main'];
    $resource           = [
        ['id' => 'test_id1', 'path' => '/test1', 'callback' => function(){}],
        ['id' => 'test_id2', 'path' => '/test2', 'callback' => 'TestClass:main'],
    ];
    $Loader             = new LoaderByArray();
    $RouteCollection    = $Loader->load($resource);

Router::matchRequest的参数匹配规则说明
-----------------------------------------------------------------

这里假设/hell/{name}是 (`如何使用？`_) 的路由信息，url path 大括号的部分表示方法的一个参数名如/hello/{name}, 其中的name是callback的参数$name。

生成url的时候如果没传参数"$Router->generateUrl('hello')" 那么name等于默认值"XX先生"
回调方法callback上面的参数值的查找顺序。

#. 从url的大括号部分，如/hello/张山. 这时$name 等于 张山
#. 如果url不带参数，如

    ::
    
        $RouteCollection->add(new Route('hello', '/hello', function($name = 'default'){
            $Body       = new Stream('php://temp', 'w+b');
            $Body->write('hello' . $name);
            return new Response($Body);
        }));
        
    这时参数$name是$_REQUEST['name']
#. 如果!isset($_REQUEST['name'])，这时$name等于默认值（default）；



.. _composer: https://getcomposer.org/