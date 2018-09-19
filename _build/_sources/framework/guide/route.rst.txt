.. framework_guide_route

路由配置
========================

路由配置：配置http请求的url与应用程序之间的关系。在 `asbamboo/framework-standard`_ 里面路由配置信息是 ./config/router.php中返回的一个数组:

::

    <?php
    return  [
        ['id' => 'home', 'path' => '/' , 'callback' => 'asbamboo\\frameworkStandard\\controller\\Home:index'],
    ];

配置文件解释
------------

数组中键的含义如下:

    * id: 路由的唯一标识
    * path: url请求的path
    * callback: 执行http请求的方法
    * default_params: callback方法的默认值
    * options: 其他选项信息

这个路由配置文件被加载到主配置文件中，其中的配置信息被当做服务asbamboo\\framework\\config\\RouterConfig的构造方法的参数使用。

./config/config.php

::

    <?php
    use asbamboo\framework\config\RouterConfig;
    use asbamboo\framework\template\Template;
    
    return [
        RouterConfig::class         => ['init_params' => ['configs' => include __DIR__ . DIRECTORY_SEPARATOR . 'router.php']],
        Template::class             => ['init_params' => ['template_dir' => [dirname(__DIR__) . DIRECTORY_SEPARATOR . 'view']]],
    ];

RouterConfig解析器的作用是，通过给定的配置信息为到服务 asbamboo\\router\\interface 生成路由集合信息。

执行http请求的方法[callback]
-------------------------------

配置信息中callback键指定的并不是一个callable类型的值，而应该传递一个字符串(格式为class:method),因为这个配置信息是用asbamboo\\framework\\config\\RouterConfig去解析的。


url请求的path
----------------------------

url请求的path被允许设置变量值如:

::

    <?php
    return  [
        ...
        ['id' => 'user_update', 'path' => '/{user_id}/user-update' , 'callback' => 'asbamboo\\frameworkDemo\\controller\\User:update'],
    ...
    ];

其中user_id是一个变量，是update方法的一个参数

::

    <?php
    namespace asbamboo\frameworkDemo\controller;

    class User extends ControllerAbstract
    {
        /**
         *
         * @return ResponseInterface
         */
        public function update($user_id) : ResponseInterface
        {
           ...
        }
    }

callback方法的默认值[default_params]
------------------------------------------

下面我们尝试将user_id设置一个默认值:

::

    <?php
    return  [
        ...
        ['id' => 'user_update', 'path' => '/{user_id}/user-update' , 'callback' => 'asbamboo\\frameworkDemo\\controller\\User:update', 'default_params'=>['user_id'=>1]],
    ...
    ];

这样当我们调用asbamboo\\router\\Router::generateUrl('user_update')没有传递$params参数是会根据默认值生成的url为: /1/user_update


其他选项信息 options
------------------------------------

暂时,在asbamboo内部还没有使用options信息

url生成器
-----------------------

关于url的匹配可能都是在框架内部执行，但是url生成，你可能会经常碰到。这里给出 `asbamboo/framework-demo`_ 中的两个例子:

第一个是controller中的使用

::

    <?php
    namespace asbamboo\framework\controller;
    
    abstract class ControllerAbstract implements ControllerInterface
    {
        ...
        
        protected function redirect(string $route_id, array $route_params = null)
        {
            $Router     = $this->Container->get(RouterInterface::class);
            $target_uri = $Router->generateUrl($route_id, $route_params);
            return new RedirectResponse($target_uri);
        }
    }

另一个是是view中的使用（/asbamboo/framework-demo/view/_include/top.html.tpl）

::
    
    <nav class="navbar navbar-expand-lg navbar-light bg-light rounded">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample10" aria-controls="navbarsExample10" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-md-center" id="navbarsExample10">
          <ul class="navbar-nav">
            <li class="nav-item {% if is_current('home') %}active{% endif %}">
                <a class="nav-link" href="{{ path('home') }}">asbamboo demo{% if is_current('home') %}<span class="sr-only">(current)</span>{% endif %}</a>
            </li>
            {% if has_roles('user', 'admin') %}
                <li class="nav-item {% if is_current('post') %}active{% endif %}">
                    <a class="nav-link" href="{{ path('post') }}">文章管理{% if is_current('post') %}<span class="sr-only">(current)</span>{% endif %}</a>
                </li>
            {% endif %}
            {% if has_roles('admin') %}
                <li class="nav-item {% if is_current('user') %}active{% endif %}">
                    <a class="nav-link" href="{{ path('user') }}">人员管理{% if is_current('user') %}<span class="sr-only">(current)</span>{% endif %}</a>
                </li>
            {% endif %}
            {% if 'anonymous' in app.user.getRoles() %}
                <li class="nav-item">
                    <a class="nav-link" href="{{ path('login') }}">登陆</a>
                </li>
            {% else %}
                <li class="nav-item">
                    <a class="nav-link" href="#">当前用户:{{ app.user.getLoginName() }}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="{{ path('logout') }}">注销</a>
                </li>
            {% endif %}
          </ul>
        </div>
    </nav>


.. _asbamboo/framework-standard: https://github.com/asbamboo/framework-standard
.. _asbamboo/framework-demo: https://github.com/asbamboo/framework-demo