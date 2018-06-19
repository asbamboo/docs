.. _autoload:

autoload自动加载器
=====================

autoload是实现通过psr-4命名规则自动加载类的工具。


如何安装？
-------------------------

#. 通过 `composer`_ 安装::

    composer require asbamboo/autoload
    
#. 从 https://github.com/asbamboo/autoload 获取。

如何使用？
-------------------------

#. 假如有个文件__DIR__/modal/demo-entity/DemoEntity.php::

    class DemoEntity
    {
        ....
    }

#. 初始化autoload::

    ....
    // 新建autoload实例，一个脚本只需要新建一次autoload实例
    $Autoload = new asbamboo/autoload/Autoload();

    // 设置命名空间于文件目录映射关系
    $Autoload->addMappingDir('modal', __DIR__ . '/modal');
    ....

#. 自动加载DemoEntity.php::

    ....
    $DemoEntity = new modal/demoEntity/DemoEntity();
    ....
    
    



.. _composer: https://getcomposer.org/