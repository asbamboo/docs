.. framework_guide_start

Hello word
================================

#. 安装 `asbamboo/framework-standard`_

    ::

        composer create-project asbamboo/framework-standard asbamboo-study --prefer-source -s dev

    asbamboo-study的目录结构:

        * AppKernel.php [一个应用的核心]
        * bin [用来存放终端可执行脚本的目录]
            * console [命令行程序入口文件]
        * config [配置文件目录]
            * config.php [配置主文件，其他配置文件都被加载到这里]
            * router.php [路由配置文件]
        * controller [控制器目录]
            * Home.php [控制器]
        * public [http请求跟目录]
            * index.php [http入口文件]
        * vendor [这个目录其实是由composer生成。框架的代码和其他第三方的代码都在这里]
            * ...
        * view [视图目录]
            * home [控制器Home的视图目录]
                * index.html.tpl [控制器Home中method为index的视图文件]
                
    `特别说明`：这只是一种标准的目录结构，并不是说使用 `asbamboo/framework`_ 就一定要保持这个目录接口，在 `asbamboo/framework`_ 几乎所有的事情都是灵活的(可以完全按照你的意思去配置)。

#. 运行Hello word程序

    这个asbamboo-study已经配置好了Hello word 代码,在asbamboo-study目录下执行:

    ::

        cd public && php -S 127.0.0.1:8000

    在浏览器中输入http://127.0.0.1:8000，程序运行过程：
    
    #. index.php 中代码说明了使用http请求的方式执行AppKernel
    #. AppKernel中指定了配置主文件，和项目根目录。
    #. 主配置文件又加载了配置文件router，并且还指定了视图模板的文件目录
    #. AppKernel根据router配置中找到了控制器[Home:index]
    #. 控制器又去读取视图文件返回一个response给AppKernel
    #. AppKernel响应response信息。

#. 运行命令行程序[console]

    这个asbamboo-study也配置好了入口文件,在asbamboo-study目录下执行:

    ::

        ./bin/console

    可以看到终端输出了几行系统内置的命令

    ::
        asbamboo:console:lists 列出所有命令
        asbamboo:console:help  获取帮助信息
        ...
     
    这是因为./bin/console不带参数的情况下，默认执行asbamboo:console:lists命令

.. _asbamboo/framework-standard: https://github.com/asbamboo/framework-standard
.. _asbamboo/framework: https://github.com/asbamboo/framework