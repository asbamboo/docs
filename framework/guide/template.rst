.. framework_guide_template

视图模板使用说明
============================

在 `asbamboo/framework-strandard`_ 中，视图模板依赖asbamboo\\framework\\template\\Template服务。使用这个服务需要通过配置文件指定模板存放的目录:

::

    <?php
    use asbamboo\framework\template\Template;
    
    return [

        ...
        
        Template::class             => ['init_params' => ['template_dir' => [dirname(__DIR__) . DIRECTORY_SEPARATOR . 'view']]],
    ];
    
这个template继承组件 `asbamboo/template`_

asbamboo/framework中模板的扩展
----------------------------------
在框架中，为模板提供了几个扩展方法可以在模板中使用。

扩展的方法：

* has_roles(...$roles) 用于在模板中判断当前用户是否拥有这些角色
* path($route_id, $params = null) 用于在模板中根据route_id生成一个url path
* is_current($route_id) 用于在模板中判断一个route id是否是当前请求的route

扩展的变量:

* app.user 当前访问的用户 一个 asbamboo\\security\\user\\UserInterface实例
* app.request 当前请求信息 一个 asbamboo\\http\\ServerRequestInterface
* app.is_debug 是否是debug模式

自定义扩展
-------------------------------------

框架允许你可以添加自定义模板的扩展方法或变量需要修改配置信息如下:

::

    <?php
    use asbamboo\framework\template\Template;
    
    return [

        ...
        
        Template::class             => ['init_params' => ['template_dir' => [dirname(__DIR__) . DIRECTORY_SEPARATOR . 'view'], 'extensions' => [TemplateExtensions::class]]],
    ];

然后编写扩展类其中:

::
    
    <?php
    use asbamboo\template\Extension;
    use asbamboo\template\Functions;
    use asbamboo\template\ExtensionGlobalsInterface;

    
    class TemplateExtensions extends Extension implements ExtensionGlobalsInterface
    {

        /**
         * 添加模板中全局变量
         * 
         * @return \asbamboo\framework\template\extension\GlobalExtension[][]|string[][]
         */
        public function getGlobals()
        {
            return ['app'=>[
                'custom'      => 'custom',
            ]];
        }
        
        /**
         * 添加模板中可用的方法 
         *
         * {@inheritDoc}
         * @see Extension::getFunctions()
         */
        public function getFunctions()
        {
            return [
                new Functions('test_extension', [$this, 'testExtension']),
            ];
        }
    
        public function testExtension()
        {
            echo 'testExtension';
        }
    }


.. _asbamboo/framework-strandard: https://github.com/asbamboo/framework-strandard
.. _asbamboo/template: ../../template/index