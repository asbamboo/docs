.. _template:

视图模板模块[template]
=========================

视图模板template模块是建立在 `twig`_ 基础上继续扩展开发的一个模块。在 `twig`_ 说明文档在template模块中同样适用。

如何安装？
-------------------------

#. 通过 `composer`_ 安装::

    composer require asbamboo/template
    
#. 从 https://github.com/asbamboo/template 获取。

如何使用？
-------------------------

::

        <?php
        use asbamboo\template\Template;

        ...
        
        $Template   = new Template($view_path, $cache_path);
        $content    = $Template->render('test.html.twig', ['test' => 'test']);

        ...

asbamboo\\template\\Template拥有所有Twig_Environment类中的方法
------------------------------------------------------------------------

asbamboo\\template\\Template不是继承Twig_Environment，但可以调用所有Twig_Environment中的方法。这时因为asbamboo\\template\\Template中魔术方法__call的作用。当访问的方法在asbamboo\\template\\Template中不存在时，会调用Twig_Environment中名字相同的方法。

扩展Extension
-----------------------------------
template支持使用addExtension方式进行扩展。

:doc:`TemplateExtension <extension/template>`

::

    <?php
    
    $Extension = new TemplateExtension;
    $this->addExtension($Extension);

.. toctree::
    :hidden:

    extension/template

.. _composer: https://getcomposer.org/
.. _twig: https://github.com/twigphp/twig
