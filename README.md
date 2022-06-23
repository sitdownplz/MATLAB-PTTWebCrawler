# MATLAB-PTTWebCrawler  
<p>[MATLAB 進階課程練習範例 - PTT爬蟲]</p>

此練習程式碼用於爬取PTT版上文章資訊，文本分析工具箱的需求單純用來移除html tag

若是使用者不具備文本分析工具箱，可用一般文字處理手法移除

- 2022/06/23 更新<br>
增加一般文字處理 通用表達式置換(regexprep)，移除HTML標籤程式碼

<img src='https://i.imgur.com/fwCU3LX.png' alt="script snapshot" width="600" height="500">

### MATLAB工具箱需求 (MATLAB Toolbox Requirement)
###### \*建議安裝文本分析工具箱 (Text Analytics Toolbox)
* 無 None


### 使用說明 Syntax
函式語法

    output_Table = PTTCrawler(爬取看板名,是否輸出csv檔)
    
    - 爬取看板名: 字元或字串變數(e.g. 'Gossiping', "Tech_Job", ...)
    - 是否輸出csv檔: 邏輯變數(true/false)

無任何輸入，預設會抓取八卦版

    without_input = PTTCrawler
輸入爬取看板

    with_site = PTTCrawler('Tech_Job') % char
    with_site = PTTCrawler("Tech_Job") % string
輸入爬取看板與是否輸出檔案

    with_siteNflag = PTTCrawler('Tech_Job',true)
    
#### MATLAB 支援版本
    - R2020b
    - R2021a
    - R2021b
    - R2022a
