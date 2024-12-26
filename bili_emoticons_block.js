// ==UserScript==
// @name         干掉b站写评论时的指定表情包
// @namespace    http://tampermonkey.net/
// @version      1.0.4
// @description  干掉b站写评论的时候的指定表情包，比如2024年度表情，以让自己的爱音大头表情包显示在第一页
// @author       betterer
// @match        *://*.bilibili.com/*
// @icon         https://i0.hdslb.com/bfs/garb/item/1127259479f9d680a8fe8f2bcf7361bad409bc97.png
// @license      MIT
// @grant        none
// @run-at       document-start
// ==/UserScript==

(function () {
  'use strict';

  // 做不出用户界面，只能手动去下面的removeTexts数组里面修改需要移除的表情包
  // @grant        GM_getValue
  // @grant        GM_setValue
  // @grant        GM_registerMenuCommand
  // // Default texts to remove
  // const removeTexts = GM_getValue('removeTexts', ["2024年度表情"]);
  // // Register a menu command for editing the removal list
  // GM_registerMenuCommand("修改过滤关键词列表", function() {
  //   const userInput = prompt(
  //     '编辑需要过滤的关键词列表\n（不同关键词之间使用 "|" 分隔，例如：关键词1|关键词2|关键词3）',
  //     removalList.join('|')
  //   );
  //   if (userInput !== null) {
  //     const updatedList = userInput.split('|').map(v => v.trim());
  //     GM_setValue('removalList', updatedList);
  //     alert('修改成功，刷新页面后生效');
  //   }
  // });

  // 默认需要移除的表情包
  const removeTexts = ['2024年度表情', '颜文字', 'tv_小电视', '热词系列一', '小黄脸'];

  // 保存原始fetch函数
  const originalFetch = window.fetch;

  // 重写fetch函数
  window.fetch = async function (input, init) {
    if (typeof input === 'string' && input.includes('api.bilibili.com/x/emote/user/panel/web?business=reply&web_location=')) {
      console.log(removeTexts);
      const response = await originalFetch(input, init);
      const clonedResponse = response.clone();

      // 修改响应数据
      return await clonedResponse.json().then(data => {
        if (data && data.data && Array.isArray(data.data.packages)) {
          data.data.packages = data.data.packages.filter(pkg => !removeTexts.includes(pkg.text));
        }
        return new Response(JSON.stringify(data), {
          status: response.status,
          statusText: response.statusText,
          headers: response.headers
        });
      });
    }

    return originalFetch(input, init);
  };
})();
