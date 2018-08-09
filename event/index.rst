事件调度模块[Event]
==================

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
-----------------------
--
 
 #. 使用eventListener注册事件监听器  