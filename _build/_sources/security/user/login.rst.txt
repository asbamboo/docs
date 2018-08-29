用户登录与登出
=====================

实现asbamboo\\security\\user\\UserInterface的类
--------------------------------------------------------

一个实现UserInterface的实例化对象表示，发起当前请求的用户。

security模块中内置两个实现了接口UserInterface的类：
    #. asbamboo\\security\\user\\AnonymousUser, 表示未登录状态下的用户
    #. asbamboo\\security\\user\\BaseUser, 标准用户类

您可以参考asbamboo\\security\\user\\BaseUser自定义实现UserInterface的类。


实现asbamboo\\security\\user\\provider\\UserProviderInterface的类
-----------------------------------------------------------------------------

实现UserProviderInterface的类用于用户登录时，通过loadByLoginName方法，使用登录的名获取一个实现UserInterface接口的对象。如果没有找到与客户端登录名相关的实现UserInterface的对象,那么loadByloginName应该返回null

security模块中内置asbamboo\\security\\user\\provider\\MemoryUserProvider。
    #. MemoryUserProvider是在程序运行时，访问系统的用户都存储在内存中。
    #. MemoryUserProvider的私有成员变量$users，存储所有用户列表。
    #. MemoryUserProvider的addUser方法用来像添加一个用户信息到变量$users
    #. MemoryUserProvider的loadByLoginName方法从变量$users查询并返回一个实现UserInterface的对象或者null。

如果你的用户信息存储于数据库中，你应该自定义一个实现了UserProviderInterface的类。loadByLoginName方法中处理从数据库中查询用户信息。

实现asbamboo\\security\\user\\token\\UserTokenInterface的类
-----------------------------------------------------------------------------

程序运行时通过实现UserTokenInterface的类，获取发起当前请求的用户信息。应该在切换用户的登录信息时调用该类的setUser方法，在需要获取当前用户信息时调用getUser方法。

security模块中内置asbamboo\\security\\user\\token\\UserToken。
    #. UserToken的setUser方法用户用户登录时，将用户信息写入session。
    #. 在用户已登录的情况下getUser方法将返回上一次setUser传入的值。
    #. 在用户未登录的情况下getUser方法将返回一个asbamboo\\security\\user\\AnonymousUser实例.

您可以参考asbamboo\\security\\user\\token\\UserToken自定义实现UserTokenInterface的类。

现在可以实现用户的登录、登出功能了
----------------------------------------------

#. 用户登录asbamboo\\security\\user\\login\\BaseUserLogin示例

    客户端HTML代码

    ::

        <html>
            <body>
                <form action="..." method="post">
                    <input type="text" name="login_name" placeholder="请输入登录名" />
                    <input type="password" name="login_password" placeholder="请输入密码" />
                    <input type="submit" />
                </form>
            </body>
        </html>

    服务端PHP代码
    
    ::

        <?php
        
        use asbamboo\session\Session;
        use asbamboo\http\ServerRequest;
        use asbamboo\security\user\provider\MemoryUserProvider;
        use asbamboo\security\user\token\UserToken;
        use asbamboo\security\user\login\BaseLogin;

        /*
         * 可以登录的用户
         */
        $MemoryUserProvider = new MemoryUserProvider();
        $MemoryUserProvider->addUser('user1', 'password1');
        $MemoryUserProvider->addUser('user2', 'password2');

        /*
         * userToken用于获取当前用户信息
         */
        $Session    = new Session();
        $UserToken  = new UserToken($Session);

        /*
         * 登录
         */
         $Request   = new ServerRequest();
         $BaseLogin = new BaseLogin($MemoryUserProvider, $UserToken);
         try{
            $BaseLogin->handler($Request);
            echo '登录成功';
         }catch(UserNotExistsException $e){
            echo '用户不存在';
         }catch(NotEqualPasswordException $e){
            echo '密码错误';
         }catch(Exception $e){
            echo '系统故障。';
         }

    
#. 退出登录asbamboo\\security\\user\\login\\BaseUserLogin示例

    ::

        <?php
        
        use asbamboo\session\Session;
        use asbamboo\http\ServerRequest;
        use asbamboo\security\user\token\UserToken;
        use asbamboo\security\user\login\BaseLogout;

        /*
         * userToken用于获取当前用户信息
         */
        $Session    = new Session();
        $UserToken  = new UserToken($Session);

        /*
         * 登录
         */
         $Request   = new ServerRequest();
         $BaseLogin = new BaseLogout($UserToken);
         try{
            $BaseLogin->handler($Request);
            echo '已退出登录';
         }catch(Exception $e){
            echo '系统故障。';
         }

用户登录、登出事件
----------------------

当用户登录或者登出成功时将触发相关的事件:
    #. security.user.login.success 用户登录成功时触发
    #. security.user.logout.success 用户退出登录成功时触发

 :doc:`点击查看事件的使用</event/index>`
