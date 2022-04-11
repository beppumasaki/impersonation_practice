module ApplicationHelper

    def page_title(page_title = '', admin = false)
        base_title = if admin
                       '学習用掲示板(管理画面)'
                     else
                       '学習用掲示板'
                     end
   
        page_title.empty? ? base_title : page_title + ' | ' + base_title
      end
end
