文档生成
==================================

# pip install Sphinx
# pip install jieba
# sphinx-quickstart
# conf.py 添加如下配置 
	# Language to be used for generating the HTML full-text search index.
	# Sphinx supports the following languages:
	#   'da', 'de', 'en', 'es', 'fi', 'fr', 'hu', 'it', 'ja'
	#   'nl', 'no', 'pt', 'ro', 'ru', 'sv', 'tr', 'zh'
	html_search_language = 'zh'
	
	# A dictionary with options for the search language support, empty by default.
	# 'ja' uses this config value.
	# 'zh' user can custom change `jieba` dictionary path.
	html_search_options = {'dict': os.getcwd() + 'dict.txt'}   # 根据需要设置jieba的词典路径
# sphinx-build -b html . _build


服务器运行
==========================================================
# docker build -t asbamboo/docs .
# docker run -d -v /www/docs/_build:/srv/asbamboo/docs/web -p80:80 --name=asbamboo_docs asbamboo/docs
# 通过浏览器 访问http://127.0.0.1