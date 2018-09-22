.. framework_guide_auth

权限配置
=====================================

asbamboo/framework中权限的配置，使用 `asbamboo/security`_ 模块实现。

配置authorization服务
------------------------------------------------

创建权限配置文件 ./config/authorization.php

::

    <?php
    use asbamboo\security\gurad\authorization\Rule;
    use asbamboo\security\gurad\authorization\RuleCollection;
    use asbamboo\security\user\Role;
    
    $RuleCollection    = new RuleCollection();
    $RuleCollection->addRule(new Rule('strncasecmp("/user", $request->getUri()->getPath(), "5") === 0 ? in_array("admin", $user->getRoles()) : true'));
    $RuleCollection->addRule(new Rule('strncasecmp("/post", $request->getUri()->getPath(), "5") === 0 ? !in_array("' . Role::ANONYMOUS . '", $user->getRoles()) : true'));
    return $RuleCollection;
    

修改主配置文件 ./config/config.php

::

    <?php
    use asbamboo\framework\config\RouterConfig;
    use asbamboo\framework\template\Template;
    use asbamboo\framework\config\DbConfig;
    use asbamboo\frameworkStandard\model\user\UserProvider;
    use asbamboo\security\user\login\Login;
    use asbamboo\framework\config\EventListenerConfig;
    use asbamboo\security\gurad\authorization\Authenticator;
    
    return [
        ...
        
        Authenticator::class        => ['init_params' => ['RuleCollection' => include __DIR__ . DIRECTORY_SEPARATOR . 'authorization.php']],
    ];


在模板的导航菜单中把没有权限的菜单隐藏
-----------------------------------------------------------

暂时扩展模板中缺少权限验证功能的方法，目前只能使用has_roles判断用户是否具有该角色。 后期打算添加一个is_granted方法专门验证用户是否有这个url的权限。

::

    <nav class="navbar navbar-expand-lg navbar-light bg-light rounded">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample10" aria-controls="navbarsExample10" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-md-center" id="navbarsExample10">
          <ul class="navbar-nav">
            <li class="nav-item {% if is_current('home') %}active{% endif %}">
                <a class="nav-link" href="{{ path('home') }}">asbamboo demo{% if is_current('home') %}<span class="sr-only">(current)</span>{% endif %}</a>
            </li>
            {% if has_roles('user', 'admin') %}
                <li class="nav-item {% if is_current('post') %}active{% endif %}">
                    <a class="nav-link" href="{{ path('post') }}">文章管理{% if is_current('post') %}<span class="sr-only">(current)</span>{% endif %}</a>
                </li>
            {% endif %}
            {% if has_roles('admin') %}
                <li class="nav-item {% if is_current('user') %}active{% endif %}">
                    <a class="nav-link" href="{{ path('user') }}">人员管理{% if is_current('user') %}<span class="sr-only">(current)</span>{% endif %}</a>
                </li>
            {% endif %}
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


    
    

.. _`asbamboo/security`: ../../security/gurad/authorization


