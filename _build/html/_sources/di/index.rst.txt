.. _di:

依赖注入容器模块[DI]
=========================

依赖注入容器模块是 `asbamboo/framework`_ 的基础模块，它知道怎样初始化并配置对象及其依赖的所有对象。 `Martin`_ 的文章 已经解释了 DI 容器为什么很有用。 这里我们仅介绍 `asbamboo/di`_ 模块的使用方法。


如何安装？
-------------------------

#. 通过 `composer`_ 安装::

    composer require asbamboo/di
    
#. 从 https://github.com/asbamboo/di 获取。

如何使用？
-------------------------

di模块主要有container容器和service服务这两样东西。service是一个类(class)的实例。container容器内容纳所有service。
在di模块中ServiceMapping类描述一个类在container中的 service id, class name 和 __construct方法的参数。

首先，我介绍一下service注册到容器的几种方法方法。

 * 通过 ServiceMappingCollection，在Container构造方法需要传递这个参数
 * 通过 Container::set 方法
 * 服务自动注册

#. 通过 ServiceMappingCollection 注册服务

    这是Container实例化的时候必须传递的参数，其中配置的服务映射关系为容器内初始的服务信息。

    ::
    
        <?php
    
            // ServiceMapping 是一个服务的关系映射信息
            // $ServiceMappingCollection 当然还可以继续
            // 使用ServiceMappingCollection::add方法添加多个服务映射关系的信息。
            $ServiceMappingCollection    = new ServiceMappingCollection();
            $ServiceMapping              = new ServiceMapping([
                'id'                     => 'service1' // 服务ID
                'class'                  => Service1::class // 服务class
                'init_params'            => ['p1', '@p2'] //像构造方法传递的参数
            ]);
            $ServiceMappingCollection->add($ServiceMapping);
    
            $Container  = new Container($ServiceMappingCollection);

#. 通过 Container::set 方法注册服务

    注意：container::set 方法和ServiceMappingCollection不一样，这个方法接收两个参数第一个是服务的唯一标示$id,第二个参数是服务的一个对象$service。

    ::
        <?php

        ...
        
        $Container  = new Container($ServiceMappingCollection);
        $Container->set('sevice2', new Service2('arg1','arg2'));

#. 自动注册的服务

    以上两种方式是显示的声明注册一个服务，还有一种系统自动注册的服务。
    系统自动注册的服务，是在调用Container::get方法时自动注册。
    当get的服务唯一标示$id， 等于类名（class_name）时，并且这个类不属于任何一个服务的ID 是，将自动注册该服务。

    ::
    
        <?php

        ...
        
        $Container->get(Service3::class);

我现在介绍一下服务的自动注入。

    使用了容器模块以后，你后续的代码不应该使用 new 关键是去实例化一个类。而应该统一使用Container::get的方式去从容器中查找并获取一个服务对象。
    当Container::get一个服务，该服务仅有ServiceMapping信息，还没有实例化对象时，该服务的构造方法的参数将自动注入。自动注入的规则：
    
    #. 如果需要传入的参数在ServiceMapping中找到 `init_params`_ 那么，不会发生自动注入。
    #. 如果参数有默认值，那么实例化的时候使用默认值。不会发生自动注入。
    #. 自动注入注入的规则是，首先去Container找与参数类型一致的服务。
        * 如果找到的服务数量超过一个，那么无法完成自动注入，程序会抛出异常[CannotInjectParamToServiceException]
        * 如果没有找到的服务，那么会尝试自动注册并且自动注入。自动注册的类（如果类型写的是Interface,那么会假设在同目录下有一个类，名字等于这个Interface名字截取掉后面的Interface字样。）
        * 如果在容器中找到且只找到一个服务和参数类型一致，那么该服务会自动注入。

    在 `asbamboo/framework-demo`_ 中有很多自动注入的例子。这里就偷懒不写出来了。
    

init_params
----------------------------------------

init_params是键值对应的数组[key=>value]。当value的第一个字符是'@'时，表示这个参数是一个服务,'@'后面更随的应该是服务ID。
init_parmas传入实例化类的构造方法时，按顺序有几个规则：

#. 如果init_parmas中的某个key的名字等于构造方法的参数名，那么这个key的value就是对应的参数。
#. 如果init_params中某个value的类型和构造方法的参数类型一致，那么这个value就是对应的参数。
#. 按照前面两个规则分配init_params后发现构造方法还有参数需要传递，并且init_params中的参数没有分配完，那么将init_params中剩余的参数按顺序分配给构造方法。

.. _composer: https://getcomposer.org/
.. _asbamboo/di: https://github.com/asbamboo/di
.. _asbamboo/framework: https://github.com/asbamboo/framework
.. _asbamboo/framework-demo: https://github.com/asbamboo/framework-demo
.. _Martin: https://martinfowler.com/articles/injection.html