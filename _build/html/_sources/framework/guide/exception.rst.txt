.. framework_guide_exception

自定义异常处理页面
===============================

asbamboo/framework默认是用框架内部自带的异常处理页面。
    * 如何在你的视图模板目录中找到了_exception目录, 将在你自定义目录中查找异常处理模板
    * 优先使用 _exception/{error code}.html.tpl，如果没有的话使用_exception/exception.html.tpl
    * 没有找到自定义模板的情况下使用系统内置的异常处理模板
    * 模板文件中变量 Exception 是一个 Throwable实例

创建通用exception模板
-------------------------------

./view/_exception/exception.html.tpl

::

    {% extends '_layout/default.html.tpl' %}
    {% block content %}
        <div class="container">
            <hr/>
            <h1>服务端无法处理您的请求</h1>
            <h2>{{ Exception.getMessage() }}</h2>
            <a href="javascript:history.back()">返回</a>
            {% if app.is_debug %}
                <div>
                    <pre>{{ Exception.__toString() }}</pre>
                </div>
            {% endif %}
        </div>
    {% endblock %}


创建针对某个异常code的exception模板（如没有访问权限）
---------------------------------------------------------

./view/_exception/403.html.tpl

::

    {% extends '_layout/default.html.tpl' %}
    {% block content %}
        <div class="container">
            <div>
                <a href="javascript:history.back()" class="btn btn-link">你没有权限访问此页面！点此返回上一页。</a>
            </div>
        </div>
    {% endblock %}
    