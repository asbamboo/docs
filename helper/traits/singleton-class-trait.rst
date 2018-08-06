单例模式的公共trait
=================

类名：asbamboo\\helper\\traits\\SingletonClassTrait

是为了后来使用单例模式开发时，不要每次重复定义那几个基本的方法::

    namespace asbamboo\helper\traits;
    
    trait SingletonClassTrait
    {
        /**
         * 类的实例
         * @var object
         */
        protected static $instance;
    
        /**
         * 使类不能被初始化
         */
        protected function __construct(){}
    
        /**
         * 创建并获取类的实例
         * @return object
         */
        public static function instance() : object
        {
            if(! static::$instance){
                static::$instance    = new static();
            }
            return static::$instance;
        }
    
        /**
         * 不允许将类的实例序列化后存储
         */
        final private function __sleep(){}
    
        /**
         * 不允许将类的实例的序列化值反序列化
         */
        final private function __wakeup(){}
    
        /**
         * 不允许复制类的实例
         */
        final private function __clone(){}
    }
    
如何使用(ex)？::

    namespace demo;
    
    use asbamboo\helper\traits\SingletonClassTrait;
    
    class Demo
    {
        use SingletonClassTrait;
        ....
    }