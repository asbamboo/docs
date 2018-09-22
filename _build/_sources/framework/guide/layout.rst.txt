.. framework_guide_layout

修改html布局
=================

现在我们先创建后面视图模板使用到的公共部分。关于模板的配置方法请查阅 `模板的使用`_

添加公共的头部文件
-------------------

./view/_include/top.html.tpl

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
          </ul>
        </div>
    </nav>

添加公共的布局文件
------------------------------

./view/_layout/default.html.tpl 其中bootstrap css文件请自行下载到对应的路径。

::

    <!doctype html>
    <html lang="zh_CN">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>Asbamboo demo</title>
        {% block stylesheet %}
            <!-- Bootstrap core CSS -->
            <link href="/assets/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
        {% endblock %}
      </head>
      <body>
        {% block top %}{% include '_include/top.html.tpl' %}{% endblock %}
        {% block content %}{% endblock %}
      </body>
    </html>


修改原来的主页，套用模板
----------------------------------

./view/home/index.html.tpl

::

    {% extends '_layout/default.html.tpl' %}
    
    {% block content %}
    <div class="container">
    	Hello word!
    </div>
    {% endblock %}

好了，我们先看一下效果吧：在项目目录的public目录下执行

::

    php -S 127.0.0.1:8000


.. _`模板的使用`: template