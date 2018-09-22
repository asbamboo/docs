.. framework_guide_login

用户登录与注销登录
================================

用户登录与注销 `asbamboo/security`_ 通过模块实现。该模块实现用户登录与注销需要:
    * 实现 asbamboo\\security\\user\\UserInterface 的类
    * 实现 asbamboo\\security\\user\\provider\\UserProviderInterface 的类
    * 将自定义的UserInterface和UserProviderInterface写入配置信息

实现asbamboo\\security\\user\\UserInterface类
----------------------------------------------------

我们的demo中是将 asbamboo\\frameworkStandard\\model\\user\\UserEntity 改造并且实现UserInterface
    * 继承 asbamboo\\security\\user\\BaseUser
    * 修改和补全UserInterface需要的方法

::

    <?php
    namespace asbamboo\frameworkStandard\model\user;
    
    use asbamboo\security\user\BaseUser;
    
    /**
     * @Entity
     * @Table(name="t_user")
     */
    class UserEntity extends BaseUser
    {
        /**
         * @var int
         *
         * @Id
         * @Column(type="integer")
         * @GeneratedValue
         */
        private $user_seq;
    
        /**
         * @var string
         *
         * @Column(type="string", unique=true)
         */
        private $user_id;
    
        /**
         * @var string
         *
         * @Column(type="string")
         */
        private $user_password;
    
        /**
         * @var int
         *
         * @Column(type="integer")
         */
        private $user_type;
    
        /**
         *
         * @return number
         */
        public function getUserSeq()
        {
            return $this->user_seq;
        }
    
        /**
         *
         * @param string $user_id
         * @return \asbamboo\frameworkStandard\model\user\UserEntity
         */
        public function setUserId(string $user_id)
        {
            $this->user_id = $user_id;
            $this->setLoginName($user_id);
            return $this;
        }
    
        /**
         *
         * @return string
         */
        public function getUserId()
        {
            return $this->user_id;
        }
    
        /**
         *
         * @param string $user_password
         * @return \asbamboo\frameworkStandard\model\user\UserEntity
         */
        public function setUserPassword(string $user_password)
        {
            $user_password          = $this->encodePassword($user_password);
            $this->user_password    = $user_password;
            $this->setLoginPassword($user_password, true);
            return $this;
        }
    
        /**
         *
         * @return string
         */
        public function getUserPassword()
        {
            return $this->user_password;
        }
    
        /**
         *
         * {@inheritDoc}
         * @see \asbamboo\security\user\BaseUser::getLoginName()
         */
        public function getLoginName() : string
        {
            return $this->getUserId();
        }
    
        /**
         *
         * {@inheritDoc}
         * @see \asbamboo\security\user\BaseUser::getLoginPassword()
         */
        public function getLoginPassword(): ?string
        {
            return $this->getUserPassword();
        }
    
        /**
         *
         * @param string $user_type
         * @return \asbamboo\frameworkStandard\model\user\UserEntity
         */
        public function setUserType(string $user_type)
        {
            $this->user_type    = $user_type;
            $this->setRoles([$user_type]);
            return $this;
        }
    
        /**
         *
         * @return number
         */
        public function getUserType()
        {
            return $this->user_type;
        }
    
        /**
         * {@inheritDoc}
         * @see \asbamboo\security\user\UserInterface::getRoles()
         */
        public function getRoles(): array
        {
            $roles  = [];
            if($this->getUserType() == Constant::TYPE_ADMIN){
                $roles[]    = 'admin';
            }
            if($this->getUserType() == Constant::TYPE_USER){
                $roles[]    = 'user';
            }
            return $roles;
        }
    }

实现 asbamboo\\security\\user\\provider\\UserProviderInterface 的类
------------------------------------------------------------------------------

::

    <?php
    namespace asbamboo\frameworkStandard\model\user;
    
    use asbamboo\security\user\UserInterface;
    use asbamboo\security\user\provider\UserProviderInterface;
    use asbamboo\di\ContainerAwareTrait;
    use asbamboo\database\FactoryInterface;
    
    /**
     *
     * @author 李春寅 <licy2013@aliyun.com>
     * @since 2018年8月30日
     */
    class UserProvider implements UserProviderInterface
    {
        use ContainerAwareTrait;
    
        /**
         *
         * @var FactoryInterface
         */
        private $Db;
    
        /**
         *
         * @param FactoryInterface $Db
         */
        public function __construct(FactoryInterface $Db)
        {
            $this->Db   = $Db;
        }
    
        /**
         *
         * {@inheritDoc}
         * @see \asbamboo\security\user\provider\UserProviderInterface::loadByLoginName()
         */
        public function loadByLoginName(string $login_name) : ? UserInterface
        {
            $criteria   = [
                'user_id' => $login_name,
            ];
            $Manager    = $this->Db->getManager();
            return $Manager->getRepository(UserEntity::class)->findOneBy($criteria);
        }
    }

将自定义的UserInterface和UserProviderInterface写入配置信息
----------------------------------------------------------

./config/config.php

::

    <?php
    use asbamboo\framework\config\RouterConfig;
    use asbamboo\framework\template\Template;
    use asbamboo\framework\config\DbConfig;
    use asbamboo\frameworkStandard\model\user\UserProvider;
    use asbamboo\security\user\login\Login;
    
    return [
        DbConfig::class             => ['init_params' => ['configs' => include __DIR__ . DIRECTORY_SEPARATOR . 'db.php']],
        RouterConfig::class         => ['init_params' => ['configs' => include __DIR__ . DIRECTORY_SEPARATOR . 'router.php']],
        UserProvider::class         => ['class' => UserProvider::class],
        Login::class                => ['init_params' => ['UserProvider' => '@'.UserProvider::class]],
        Template::class             => ['init_params' => ['template_dir' => [dirname(__DIR__) . DIRECTORY_SEPARATOR . 'view']]],
    ];

创建用户登录成功时的事件监听器，为了页面跳转
------------------------------------------------------

创建监听器

::

    <?php
    namespace asbamboo\frameworkStandard\listener;
    
    use asbamboo\security\user\token\UserTokenInterface;
    use asbamboo\http\RedirectResponse;
    use asbamboo\router\RouterInterface;
    
    class LoginListener
    {
        /**
         *
         * @var RouterInterface
         */
        private $Router;
    
        /**
         *
         * @param RouterInterface $Router
         */
        public function __construct(RouterInterface $Router)
        {
            $this->Router = $Router;
        }
    
        /**
         * 登录成功页面跳回主页
         *
         * @param UserTokenInterface $UserToken
         */
        public function onLoginSuccess(UserTokenInterface $UserToken)
        {
            $redirect_url   = $this->Router->generateUrl('home');
            return (new RedirectResponse($redirect_url))->send();
        }
    }


./config/listener.php

::

    <?php
    use asbamboo\security\Event;
    use asbamboo\frameworkStandard\listener\LoginListener;
    use asbamboo\router\RouterInterface;
    
    return [
        ['name' => Event::LOGIN_SUCCESS, 'class' => LoginListener::class, 'method' => 'onLoginSuccess', 'construct_params' => ['@'.RouterInterface::class]],
    ];

./config/config.php

::

    <?php
    use asbamboo\framework\config\EventListenerConfig;
    
    return [
    
        ...
        
        EventListenerConfig::class  => ['init_params' => ['configs' => include __DIR__ . DIRECTORY_SEPARATOR . 'listener.php']],
    ];


添加login controller
--------------------------------------
控制器中注销所使用的服务 LogoutInterface 并没有在什么地方注册，这时因为在asbamboo/framework中，服务是可以自动注册的。

::

    <?php
    namespace asbamboo\frameworkStandard\controller;
    
    use asbamboo\framework\controller\ControllerAbstract;
    use asbamboo\http\ResponseInterface;
    use asbamboo\security\exception\UserNotExistsException;
    use asbamboo\security\exception\NotEqualPasswordException;
    use asbamboo\http\ServerRequestInterface;
    use asbamboo\security\user\login\LoginInterface;
    use asbamboo\security\user\login\LogoutInterface;
    
    /**
     *
     * @author 李春寅 <licy2013@aliyun.com>
     * @since 2018年7月30日
     */
    class Login extends ControllerAbstract
    {
        /**
         *
         * @var ServerRequestInterface
         * @var LoginInterface
         * @var LogoutInterface
         */
        private $Request, $Login, $Logout;
    
        /**
         *
         * @param ServerRequestInterface $Request
         * @param LoginInterface $Login
         * @param LogoutInterface $Logout
         */
        public function __construct(ServerRequestInterface $Request, LoginInterface $Login, LogoutInterface $Logout)
        {
            $this->Request  = $Request;
            $this->Login    = $Login;
            $this->Logout   = $Logout;
        }
    
        /**
         * 登陆表单
         *
         * @return \asbamboo\http\ResponseInterface
         */
        public function form() : ResponseInterface
        {
            $error_message    = '';
            try
            {
                /**
                 * 登录成功后通过事件处理页面跳转。
                 */
                if($this->Request->getMethod() == 'POST'){
                    $this->Login->handler($this->Request);
                }
            }catch(UserNotExistsException $e){
                $error_message    = '用户名或者密码错误';
            }catch(NotEqualPasswordException $e){
                $error_message    = '用户名或者密码错误';
            }catch(\Exception $e){
                $error_message    = '系统异常。';
            }
            return $this->view(['error_message' => $error_message]);
        }
    
        /**
         * 注销
         *
         * @return \asbamboo\http\ResponseInterface
         */
        public function logout()
        {
            $this->Logout->handler($this->Request);
            return $this->redirect('home');
        }
    }

创建登录表单模板文件
-------------------------------------------------------

./view/login/form.html.tpl

::

    {% extends '_layout/default.html.tpl' %}

    {% block stylesheet %}
        {{ parent() }}
        <style>
            .form-signin {
              width: 100%;
              max-width: 330px;
              padding: 15px;
              margin: 0 auto;
            }
            .form-signin .checkbox {
              font-weight: 400;
            }
            .form-signin .form-control {
              position: relative;
              box-sizing: border-box;
              height: auto;
              padding: 10px;
              font-size: 16px;
            }
            .form-signin .form-control:focus {
              z-index: 2;
            }
            .form-signin input[type="email"] {
              margin-bottom: -1px;
              border-bottom-right-radius: 0;
              border-bottom-left-radius: 0;
            }
            .form-signin input[type="password"] {
              margin-bottom: 10px;
              border-top-left-radius: 0;
              border-top-right-radius: 0;
            }
        </style>
    {% endblock %}
    
    {% block content %}
        {% if error_message %}
            <div class="alert alert-danger" role="alert">{{ error_message }}</div>
        {% endif %}
        <form class="form-signin" method="post">
          <h1 class="h3 mb-3 font-weight-normal">请登陆</h1>
          <label for="login_name" class="sr-only">ID</label>
          <input type="text" id="login_name" name="login_name" class="form-control" placeholder="请输入用户ID" required autofocus>
          <label for="login_password" class="sr-only">密码</label>
          <input type="password" id="login_password" name="login_password" class="form-control" placeholder="请输入用户密码" required>
          <button class="btn btn-lg btn-primary btn-block" type="submit">登录</button>
        </form>
    {% endblock %}

将登录和登出url注册到路由信息
----------------------------------------------

./config/router.php

::

    <?php
    return  [
        ...
        
        ['id' => 'login', 'path' => '/login' , 'callback' => 'asbamboo\\frameworkStandard\\controller\\Login:form'],
        ['id' => 'logout', 'path' => '/logout' , 'callback' => 'asbamboo\\frameworkStandard\\controller\\Login:logout'],
        
        ...
    ];

将登录和注销相关url添加到头部文件
----------------------------------------

./view/_include/top.html.tpl

::

    <nav class="navbar navbar-expand-lg navbar-light bg-light rounded">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample10" aria-controls="navbarsExample10" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-md-center" id="navbarsExample10">
          <ul class="navbar-nav">
          
            ... 
            
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

试一试
---------------------------------------

第一个管理员，可以只用命令行工具 ./bin/console admin 添加，然后可以输入刚刚添加的账号密码测试一下。

.. _`asbamboo/security`: ../../security/user/login