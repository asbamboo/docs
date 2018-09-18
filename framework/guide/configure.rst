.. framework_guide_configure


配置
=======

其实这一个章节说明的配置方法，并不是说你一定要这样做。如果你对php很熟悉并且掌握了 `asbamboo/framework`_ 的编程思想的话，你应该有多种读取配置信息的方式。

使用 `asbamboo/framework`_ 开发一个web应用系统，第一步应该创建一个实现asbamboo\\framework\\kernel\\KernelInterface的类，在 `asbamboo/framework`_ 中内置了抽象类asbamboo\\framework\\kernel\\KernelAbstract帮助快速创建这个类。本指南假定我们的系统基于KernelAbstract进行下一步开发。


指定配置文件
-------------------

如果基于KernelAbstract实现这个类的话需要添加两个方法getProjectDir返回当前项目的根目录，getConfigPath返回主配置文件路径。

::

    <?php
    namespace asbamboo\frameworkStandard;
    
    use asbamboo\framework\kernel\KernelAbstract;
    
    class AppKernel extends KernelAbstract
    {
        /**
         *
         * 项目根目录
         */
        public function getProjectDir(): string
        {
            return __DIR__;
        }
    
        /**
         * 主配置文件
         */
        public function getConfigPath() : string
        {
            return __DIR__ . '/config/config.php' ;
        }
    }

配置文件说明
------------------

AppKernel::getConfigPath() 返回的配置文件需要返回一个数组该数组被用来生成一个asbamboo\\di\\S\erviceMappingCollection对象，作为容器[ `asbamboo/di`_ ]的基础service信息。配置信息示例:

::

    use asbamboo\framework\config\RouterConfig;
    use asbamboo\framework\template\Template;
    
    return [
        RouterConfig::class         => ['init_params' => ['configs' => include __DIR__ . DIRECTORY_SEPARATOR . 'router.php']],
        Template::class             => ['init_params' => ['template_dir' => [dirname(__DIR__) . DIRECTORY_SEPARATOR . 'view']]],
    ];

根据数组的每一行生成一个asbamboo\\di\\ServiceMapping信息, 配置信息说明：
    * 数组的值id表示服务的唯一标识
    * 数组的值class表示服务对应的类
    * 数组的值init_params服务初始化时构造方法接收的参数
    * 数组的键如果是一个自定义的字符串，并且数组的值没有id这个键，那么这个数组的键等于id
    * 数组的键正好是一个class的名字，同时数组的值没有class这个键，那么这个数组的键等于class
    * 数组的值class实现了asbamboo\\framework\\config\\ConfigInterface那么读取配置信息时，系统会执行它的configure方法。


.. _asbamboo/framework: https://github.com/asbamboo/framework

.. _asbamboo/di: https://github.com/asbamboo/di