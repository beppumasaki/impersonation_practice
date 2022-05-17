module ApplicationHelper
  def default_meta_tags
    {
      site: 'ものまねお -モノマネ測定アプリ',
      title: title,
      reverse: true,
      charset: 'utf-8',
      description: 'あなたのモノマネを点数化します！目指せモノマネ王（ものまねお）！',
      keywords: 'ものまねお,モノマネ,モノマネ王',
      canonical: request.original_url,
      separator: '|',
      viewport: 'width=device-width,initial-scale=1,viewport-fit=cover',
      icon: [
        { href: image_url('maneo_face.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' },
        { href: image_url('maneo_face.png'), rel: 'icon', sizes: '192x192', type: 'image/png' }
      ],
      og: {
        title: :site,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('monomaneo_card.png'),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image'
      }
    }
  end


  def page_title(page_title = '', admin = false)
      base_title = if admin
                      'ものまねお(管理画面)'
                    else
                      'ものまねお'
                    end
  
      page_title.empty? ? base_title : page_title + ' | ' + base_title
  end
end
