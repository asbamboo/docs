.. _test:

测试[test]
=====================

test 模块是asbamboo开源代码库的测试工具。

有什么用？
-----------

#. test模块能是测试asbamboo代码库本身是否正常运行的工具。
#. 通过test模块中对应的代码，能帮助你理解asbamboo代码库中各个模块的使用方法。

如何安装？
-------------------------

#. 通过 `composer`_ 安装::

    composer require asbamboo/test
    
#. 从 https://github.com/asbamboo/test 获取。

如何使用？
-------------------------

#. 将目录切换到test模块根目录。
#. 运行composer install。
#. 运行./vender/bin/phpunit 


.. _composer: https://getcomposer.org/