事件调度模块[Event]
=============================

事件调度模块的作用是使代码块易于扩展，在功能扩展时不需要对原有的代码进行修改，或者一段代码被其他人调用时，他们可以不修改代码的同时做出相应的扩展。
在使用说明中将介绍：利用事件调度模块为一个用户注册程序添加事件，使代码易于扩展。

如何安装？
-------------------------

#. 通过 `composer`_ 安装::

    composer require asbamboo/event
    
#. 从 https://github.com/asbamboo/event 获取。


如何使用？
-------------------------

#. 假设有一段用户注册代码::

    namespace app;

    class user
    {
        public function register()
        {
            .... //用户注册功能的代码 
        }
    }
 
#. 为了以后功能扩展我们为这段代码添加事件调度::

    namespace app;
    
    use asbamboo\event\EventScheduler;

    class user
    {
        public function register()
        {
            /**
             * @var object $user 注册成功后的用户
             */
            .... //用户注册功能的代码 
            
            EventScheduler::instance()->trigger('user.register.success', $user);
        }
    }

#. 创建了user.register.success事件触发器，以后用户注册成功需要做的功能扩展时，只需要绑定一个事件处理方法::

    EventScheduler::instance()->bind('user.register.success', function(object $user ){
        ... // 假设我们这次添加了用户注册成功时，发送优惠券的功能。
    });

#. 除了绑定function外，还可以绑定[object, method], 假如上一步的function处理代码是下面的sendByUserRegister方法::

    namespace app\event;
    
    class coupon
    {
        public function sendByUserRegister(object $user)
        {
            .... 发送优惠券的功能。
        }
    }
    
    // 这时可以把事件绑定写成::
    
    EventScheduler::instance()->bind('user.register.success', [new app\event\'coupon', 'sendByUserRegister']);

绑定事件处理代码的优先级
-------------------------

EventScheduler::instance()->bind 方法还有第三个参数，是int类型，表示绑定后执行顺序的优先级，数字大的方法优先执行。如果方法执行后返回false。那将跳出事件处理，不再执行其他事件

使用on简写事件绑定与事件触发
-------------------------------

之前说明的bind和trigger方法，可以使用on方法代替。
    #. on方法的第一个参数是事件名称。
    #. 如果on方法的第二个参数，is_callable判断等于true，那么等同于调用bind方法。这时如果还有第三个参数，那么第三个参数应该是INT类型，表示优先级。
    #. 如果on方法的第二个参数，is_callable判断等于false, 那么等同于调用trigger方法，其他参数将在事件触发时传给bind的方法。

例:

    用于注册方法中trigger修改为on：
    
::

    namespace app;
    
    use asbamboo\event\EventScheduler;
    
    class user
    {
        public function register()
        {
            /**
             * @var object $user 注册成功后的用户
             */
            .... //用户注册功能的代码
    
            EventScheduler::instance()->on('user.register.success', $user);
        }
    }

    bind方法修改为on：

::

    namespace app\event;
        
        class coupon
        {
            public function sendByUserRegister(object $user)
            {
                .... 发送优惠券的功能。
            }
        }
        
        // 这时可以把事件绑定写成::
        
        EventScheduler::instance()->on('user.register.success', [new app\event\'coupon', 'sendByUserRegister'], 0); // 0表示执行的优先级

 
使用EventListener注册事件监听器  
------------------------------------

之前使用的EventScheduler::bind方法绑定的可调用的对象，必须先将类实例化成一个对象，然后作为参数使用bind方法。即使后面的代码中没有触发这个事件，这些类也需要实例化对象。

如果使用了EventListener::set方法，那么这些需要bind的对象方法，只有受到EventScheduler::trigger触发时才会生成新的实例，这样可以减少内存占用。

我们现在将之前的bind修改为，使用EventListener::set:

::

    namespace app\event;

    class coupon
    {
        private $db;
        
        public __construct($db)
        {
            $this->db   = $db;
        }

        public function sendByUserRegister(object $user)
        {
            .... 发送优惠券的功能。
        }
    }
        
使用EventListener::set:

::

    // 第一个参数是事件名称
    // 第二个参数是方法名称
    // 第三个参数是类实例化时，__construct方法接收的参数
    // 第四个参数等同于bind方法的优先级
    EventListener::instance()->set('test.event.register', app\event\coupon', 'sendByUserRegister', [$db], 0);

.. _composer: https://getcomposer.org/