# frozen_string_literal: true

# db/seeds.rb
# 冪等に実行できるシードデータ

puts "🌱 シードデータを投入中..."

# ===== テストユーザー =====
user = User.find_or_create_by!(email: "test@example.com") do |u|
  u.username = "テスト太郎"
  u.password = "password123"
  u.password_confirmation = "password123"
end
puts "  ✅ ユーザー: #{user.email} (#{user.username})"

# ===== マスターユーザー（共通ルアー管理用） =====
master_user = User.find_or_create_by!(email: "master@example.com") do |u|
  u.username = "マスター"
  u.password = SecureRandom.hex(16)
end

# ===== 施設データ =====
puts "🌱 全国の管理釣り場データを投入中..."

facilities_data = [
  # --- 北海道 ---
  { name: "ニセコフィッシングエリア",         address: "北海道虻田郡倶知安町字三島82",              prefecture: "北海道", latitude: 42.902304, longitude: 140.756501, is_verified: true, description: "羊蹄山の麓、ニセコの清冽な湧水を利用した北海道最高峰のトラウトエリア。" },
  { name: "千歳川フィッシングエリア",         address: "北海道千歳市支笏湖温泉番外地",              prefecture: "北海道", latitude: 42.776586, longitude: 141.401698, is_verified: true, description: "支笏湖から流れ出る千歳川沿いの管理釣り場。超清澄な水でトラウトのコンディションが別格。" },
  { name: "洞爺湖フィッシングエリア",         address: "北海道虻田郡洞爺湖町洞爺湖温泉142",         prefecture: "北海道", latitude: 42.566040, longitude: 140.819118, is_verified: true },
  { name: "支笏湖フィッシングエリア",         address: "北海道千歳市支笏湖温泉",                    prefecture: "北海道", latitude: 42.772749, longitude: 141.404134, is_verified: true },
  # --- 東北 ---
  { name: "フィッシングエリアウキウキランド", address: "青森県三戸郡新郷村戸来上栃棚森ノ下58-1",    prefecture: "青森県", latitude: 40.439086, longitude: 141.108003, is_verified: true },
  { name: "岩洞湖レジャーランド",             address: "岩手県盛岡市繋字岩洞",                      prefecture: "岩手県", latitude: 39.675955, longitude: 141.019831, is_verified: true },
  { name: "蔵王フィッシングエリア",           address: "宮城県刈田郡蔵王町遠刈田温泉",              prefecture: "宮城県", latitude: 38.112195, longitude: 140.531038, is_verified: true },
  { name: "仙台フィッシングエリア 広瀬川",   address: "宮城県仙台市青葉区芋沢字大竹3",             prefecture: "宮城県", latitude: 38.283149, longitude: 140.791309, is_verified: true, description: "広瀬川の源流域を利用した清流エリア。初心者歓迎のレンタルタックルあり。" },
  { name: "猪苗代フィッシングエリア",         address: "福島県耶麻郡猪苗代町蚕養3074",              prefecture: "福島県", latitude: 37.602343, longitude: 140.211738, is_verified: true, description: "猪苗代湖畔に位置。会津の清冽な水で育ったトラウトは引きが強烈。" },
  { name: "猫魔フィッシングエリア",           address: "福島県耶麻郡北塩原村桧原剣ヶ峯",            prefecture: "福島県", latitude: 37.663004, longitude: 140.076376, is_verified: true },
  { name: "裏磐梯フィッシングエリア",         address: "福島県耶麻郡北塩原村大字桧原字剣ヶ峯",      prefecture: "福島県", latitude: 37.663004, longitude: 140.076376, is_verified: true },
  # --- 関東 ---
  { name: "川場フィッシングプラザ",           address: "群馬県利根郡川場村川場湯原401",              prefecture: "群馬県", latitude: 36.746648, longitude: 139.132253, is_verified: true, description: "川場村の清流沿いに展開。初心者でも釣りやすく、ヤマメ・ニジマス・ブラウンを放流。" },
  { name: "朝霞ガーデン",                     address: "埼玉県朝霞市田島2-8-1",                      prefecture: "埼玉県", is_verified: true,                                               description: "「管釣りの東大」として知られる超テクニカルな名門エリア。" },
  { name: "フィッシングエリア オービット",   address: "埼玉県秩父市荒川久那1456",                   prefecture: "埼玉県", latitude: 35.953609, longitude: 139.058984, is_verified: true, description: "秩父の荒川支流を利用。スプーンからクランクまで幅広いルアーが有効。" },
  { name: "那須高原管釣りパーク",             address: "栃木県那須郡那須町高久乙593",                prefecture: "栃木県", latitude: 37.039040, longitude: 140.015256, is_verified: true, description: "那須高原の清流を利用。水温が低く魚の活性が高い。" },
  { name: "アルクスポンド東京",               address: "東京都八王子市川口町3333",                   prefecture: "東京都", latitude: 35.697016, longitude: 139.273805, is_verified: true, description: "エリアトラウト専門ポンド。定期的なビッグウェイト放流も魅力。" },
  { name: "フィッシングサンクチュアリ",       address: "神奈川県相模原市緑区牧野4145",               prefecture: "神奈川県", latitude: 35.582080, longitude: 139.152805, is_verified: true },
  { name: "プレステージフィッシングエリア",   address: "茨城県常陸大宮市小瀬3234",                   prefecture: "茨城県", latitude: 36.608847, longitude: 140.324768, is_verified: true, description: "大型ニジマスの放流で知られ、ランカーを狙うアングラーが集う。" },
  # --- 中部・甲信越 ---
  { name: "小坂なリバーベース",               address: "岐阜県下呂市小坂町大洞",                    prefecture: "岐阜県", is_verified: true,                                               description: "日本トップクラスの透明度を誇り、サイトフィッシングに最適。" },
  { name: "吉ヶ平フィッシングパーク",         address: "新潟県三条市守門川",                         prefecture: "新潟県", is_verified: true,                                               description: "自然の川をそのまま利用。コンディションの良いイワナやヤマメを狙える。" },
  { name: "東山湖フィッシングエリア",         address: "静岡県御殿場市東山1077",                     prefecture: "静岡県", latitude: 35.297441, longitude: 138.948281, is_verified: true, description: "日本最大級のポンドを誇る聖地。富士山を望む絶景の中で釣りが楽しめる。" },
  { name: "信州ロッキーフィッシング",         address: "長野県佐久市臼田2513",                       prefecture: "長野県", latitude: 36.200162, longitude: 138.475763, is_verified: true, description: "高地特有の低水温で活性が高く、年間を通じて安定した釣果。" },
  { name: "富士山麓フィッシングエリア",       address: "静岡県裾野市須山703",                        prefecture: "静岡県", latitude: 35.251579, longitude: 138.847588, is_verified: true },
  # --- 近畿 ---
  { name: "びわ湖フィッシングガーデン",       address: "滋賀県大津市伊香立途中町1821",               prefecture: "滋賀県", latitude: 35.173633, longitude: 135.861207, is_verified: true, description: "びわ湖を見下ろすロケーション。ニジマス・ブラウンを豊富に放流。" },
  { name: "フィッシングパーク 高島の泉",     address: "滋賀県高島市新旭町藁園2250",                 prefecture: "滋賀県", is_verified: true,                                               description: "湧水を利用した年中釣りが可能なポンド。大型のコンディションが良い。" },
  { name: "大阪フィッシングエリア 能勢",     address: "大阪府豊能郡能勢町倉垣1146",                 prefecture: "大阪府", latitude: 34.973326, longitude: 135.463933, is_verified: true },
  # --- 中国・四国 ---
  { name: "岡山フィッシングエリア 津山",     address: "岡山県津山市加茂町中原921",                  prefecture: "岡山県", latitude: 35.171541, longitude: 134.050852, is_verified: true, description: "西日本屈指のトラウトエリア。大型ニジマス放流で有名。" },
  { name: "四国フィッシングエリア 仁淀川",   address: "高知県吾川郡いの町清水上分",                 prefecture: "高知県", latitude: 33.701491, longitude: 133.339122, is_verified: true },
  # --- 九州 ---
  { name: "フィッシングパークひらの",         address: "佐賀県佐賀市富士町上無津呂",                 prefecture: "佐賀県", is_verified: true,                                               description: "九州のエリアトラウトをリードする施設。養殖場を併設したスポーツフィッシングの場。" },
  { name: "阿蘇フィッシングリゾート",         address: "熊本県阿蘇市小里1534",                       prefecture: "熊本県", latitude: 32.978356, longitude: 131.050744, is_verified: true, description: "阿蘇の伏流水を利用。カルデラを望む絶景が広がる。" },
  { name: "福岡フィッシングセンター 糸島",   address: "福岡県糸島市二丈吉井3012",                   prefecture: "福岡県", latitude: 33.483016, longitude: 130.078687, is_verified: true }
]

facilities_data.each do |data|
  Facility.find_or_create_by!(name: data[:name]) do |f|
    f.assign_attributes(data)
  end
end

puts "✅ 施設データの投入が完了しました（#{Facility.count}件）"

# ===== ルアーデータ =====
# enum :lure_type, { spoon: 0, crankbait: 1, minnow: 2, other: 3 }
lures_data = [
  # ───── スプーン（spoon: 0） ─────
  { name: "キッド",              manufacturer: "Deep Paradox",     lure_type: :spoon },
  { name: "キッドダディ",        manufacturer: "Deep Paradox",     lure_type: :spoon },
  { name: "フォルテ",            manufacturer: "Velvet Arts",      lure_type: :spoon },
  { name: "グラビティ",          manufacturer: "Deep Paradox",     lure_type: :spoon },
  { name: "ハント",              manufacturer: "New Drawer",       lure_type: :spoon },
  { name: "ハントグランデ",      manufacturer: "New Drawer",       lure_type: :spoon },
  { name: "バンナ",              manufacturer: "New Drawer",       lure_type: :spoon },
  { name: "ノア",                manufacturer: "Rodeo Craft",      lure_type: :spoon },
  { name: "ノアL",               manufacturer: "Rodeo Craft",      lure_type: :spoon },
  { name: "ノアJr",             manufacturer: "Rodeo Craft",      lure_type: :spoon },
  { name: "ジキル",              manufacturer: "Rodeo Craft",      lure_type: :spoon },
  { name: "ジキルL",             manufacturer: "Rodeo Craft",      lure_type: :spoon },
  { name: "ブラインドフランカー", manufacturer: "Rodeo Craft",     lure_type: :spoon },
  { name: "キューム",            manufacturer: "Rodeo Craft",      lure_type: :spoon },
  { name: "ミュー",              manufacturer: "Forest",           lure_type: :spoon },
  { name: "パル",                manufacturer: "Forest",           lure_type: :spoon },
  { name: "ファクター",          manufacturer: "Forest",           lure_type: :spoon },
  { name: "チェイサー",          manufacturer: "Forest",           lure_type: :spoon },
  { name: "ドーナ",              manufacturer: "Angler's System",  lure_type: :spoon },
  { name: "ブレイブ",            manufacturer: "Angler's System",  lure_type: :spoon },
  { name: "アルミン",            manufacturer: "Waterland",        lure_type: :spoon },
  { name: "ディープダイヤ",      manufacturer: "Waterland",        lure_type: :spoon },
  { name: "ハイバースト",        manufacturer: "ValkeIN",          lure_type: :spoon },
  { name: "サーヴァントスピア",  manufacturer: "ValkeIN",          lure_type: :spoon },
  { name: "ブラックブラスト",    manufacturer: "ValkeIN",          lure_type: :spoon },
  { name: "ギガバースト",        manufacturer: "ValkeIN",          lure_type: :spoon },
  { name: "シャイラ",            manufacturer: "ValkeIN",          lure_type: :spoon },
  { name: "シャイラナノ",        manufacturer: "ValkeIN",          lure_type: :spoon },
  { name: "アキュラシー",        manufacturer: "Naburaya",         lure_type: :spoon },
  { name: "エクシード",          manufacturer: "Naburaya",         lure_type: :spoon },
  { name: "ヴィーナス",          manufacturer: "Naburaya",         lure_type: :spoon },
  { name: "ティーグラベル",      manufacturer: "TIMON",            lure_type: :spoon },
  { name: "レクセ",              manufacturer: "TIMON",            lure_type: :spoon },
  { name: "アピード",            manufacturer: "TIMON",            lure_type: :spoon },
  { name: "ティアロ",            manufacturer: "TIMON",            lure_type: :spoon },
  { name: "シャース",            manufacturer: "SAURIBU",          lure_type: :spoon },
  { name: "シャースピー",        manufacturer: "SAURIBU",          lure_type: :spoon },
  { name: "マーカス",            manufacturer: "SAURIBU",          lure_type: :spoon },
  { name: "ピット",              manufacturer: "iJetlink",         lure_type: :spoon },
  { name: "デカピット",          manufacturer: "iJetlink",         lure_type: :spoon },
  { name: "脇差",                manufacturer: "iJetlink",         lure_type: :spoon },
  { name: "アイジェットソード",  manufacturer: "iJetlink",         lure_type: :spoon },
  { name: "ベリーズ",            manufacturer: "FPB LURES",        lure_type: :spoon },
  { name: "ビーハート",          manufacturer: "FPB LURES",        lure_type: :spoon },
  { name: "マイクロデクスター",  manufacturer: "Yarie",            lure_type: :spoon },
  { name: "ティーチ",            manufacturer: "Nories",           lure_type: :spoon },
  { name: "ウィーパー",          manufacturer: "Nories",           lure_type: :spoon },
  { name: "チュール",            manufacturer: "Nories",           lure_type: :spoon },
  { name: "ロキ",                manufacturer: "Nories",           lure_type: :spoon },
  { name: "スイッチバック",      manufacturer: "RIDEMARVEL",       lure_type: :spoon },
  { name: "ポディウム",          manufacturer: "Displout",         lure_type: :spoon },
  { name: "ドリフトスピン",      manufacturer: "Rodeo Craft",      lure_type: :spoon },
  { name: "サギクエスト",        manufacturer: "Trout Spoons Lab", lure_type: :spoon },
  { name: "フレア",              manufacturer: "KHOR",             lure_type: :spoon },

  # ───── クランクベイト（crankbait: 1） ─────
  { name: "パニクラ",            manufacturer: "TIMON",            lure_type: :crankbait },
  { name: "ちびパニクラ",        manufacturer: "TIMON",            lure_type: :crankbait },
  { name: "キビパニ",            manufacturer: "TIMON",            lure_type: :crankbait },
  { name: "ペピーノ",            manufacturer: "TIMON",            lure_type: :crankbait },
  { name: "モカ",                manufacturer: "Rodeo Craft",      lure_type: :crankbait },
  { name: "プチモカ",            manufacturer: "Rodeo Craft",      lure_type: :crankbait },
  { name: "ウッサ",              manufacturer: "Rodeo Craft",      lure_type: :crankbait },
  { name: "ウッサXS",           manufacturer: "Rodeo Craft",      lure_type: :crankbait },
  { name: "ワウ",                manufacturer: "Lucky Craft",      lure_type: :crankbait },
  { name: "アンフェア",          manufacturer: "Lucky Craft",      lure_type: :crankbait },
  { name: "クラピー",            manufacturer: "Lucky Craft",      lure_type: :crankbait },
  { name: "マイクロクラピー",    manufacturer: "Lucky Craft",      lure_type: :crankbait },
  { name: "ボトムクラピー",      manufacturer: "Lucky Craft",      lure_type: :crankbait },
  { name: "マグナムクラピー",    manufacturer: "Lucky Craft",      lure_type: :crankbait },
  { name: "ガメクラ",            manufacturer: "Displout",         lure_type: :crankbait },
  { name: "ピコイーグルプレーヤー", manufacturer: "Displout",      lure_type: :crankbait },
  { name: "チャタクラ",          manufacturer: "Displout",         lure_type: :crankbait },
  { name: "バービー",            manufacturer: "Rob Lure",         lure_type: :crankbait },
  { name: "バービーロング",      manufacturer: "Rob Lure",         lure_type: :crankbait },
  { name: "ママバービー",        manufacturer: "Rob Lure",         lure_type: :crankbait },
  { name: "ジャコ",              manufacturer: "Rob Lure",         lure_type: :crankbait },
  { name: "ブランキー",          manufacturer: "Rob Lure",         lure_type: :crankbait },
  { name: "ザンム",              manufacturer: "Mukai",            lure_type: :crankbait },
  { name: "トレモ",              manufacturer: "Mukai",            lure_type: :crankbait },
  { name: "トレモスリム",        manufacturer: "Mukai",            lure_type: :crankbait },
  { name: "スマッシュ",          manufacturer: "Mukai",            lure_type: :crankbait },
  { name: "ココニョロ",          manufacturer: "YUMIN",            lure_type: :crankbait },
  { name: "ココニョロチビ",      manufacturer: "YUMIN",            lure_type: :crankbait },
  { name: "餌ニョロ",            manufacturer: "Ikekura",          lure_type: :crankbait },
  { name: "逆さニョロ",          manufacturer: "1089 Workshop",    lure_type: :crankbait },
  { name: "クーガ",              manufacturer: "ValkeIN",          lure_type: :crankbait },
  { name: "クーガナノ",          manufacturer: "ValkeIN",          lure_type: :crankbait },
  { name: "ヘイズ",              manufacturer: "ValkeIN",          lure_type: :crankbait },
  { name: "ヘイズDD",           manufacturer: "ValkeIN",          lure_type: :crankbait },
  { name: "メロ",                manufacturer: "OSP",              lure_type: :crankbait },
  { name: "ロマンス",            manufacturer: "OSP",              lure_type: :crankbait },
  { name: "ウルキ",              manufacturer: "KarteLLas",        lure_type: :crankbait },
  { name: "へのじファイター",    manufacturer: "メーカー不明",     lure_type: :crankbait },
  { name: "ミニシカダ",          manufacturer: "Tackle House",     lure_type: :crankbait },
  { name: "エルフィン",          manufacturer: "Tackle House",     lure_type: :crankbait },
  { name: "グラスホッパー",      manufacturer: "Tackle House",     lure_type: :crankbait },
  { name: "スナック",            manufacturer: "Mukai",            lure_type: :crankbait },
  { name: "ワプラジュニア",      manufacturer: "Rodeo Craft",      lure_type: :crankbait },

  # ───── ミノー（minnow: 2） ─────
  { name: "ザッガー",            manufacturer: "HMKL",             lure_type: :minnow, buoyancy: 5 },
  { name: "ザッガーB1",         manufacturer: "HMKL",             lure_type: :minnow, buoyancy: 1 },
  { name: "ハイドラム",          manufacturer: "ValkeIN",          lure_type: :minnow, buoyancy: 3 },
  { name: "ハイドラムナノ",      manufacturer: "ValkeIN",          lure_type: :minnow, buoyancy: 3 },
  { name: "ダブルクラッチ",      manufacturer: "Daiwa",            lure_type: :minnow, buoyancy: 3 },
  { name: "ダブルクラッチSHF",  manufacturer: "Daiwa",            lure_type: :minnow, buoyancy: 0 },
  { name: "イーグルプレーヤー",  manufacturer: "Displout",         lure_type: :minnow, buoyancy: 1 },
  { name: "イーグルプレーヤーGJ", manufacturer: "Displout",       lure_type: :minnow, buoyancy: 3 },
  { name: "ポーリー",            manufacturer: "Rodeo Craft",      lure_type: :minnow, buoyancy: 5 },
  { name: "スティル",            manufacturer: "Smith",            lure_type: :minnow, buoyancy: 3 },
  { name: "スティルエリアチューン", manufacturer: "Smith",         lure_type: :minnow, buoyancy: 5 },
  { name: "ハンクルシャッド",    manufacturer: "HMKL",             lure_type: :minnow, buoyancy: 5 },
  { name: "ブリブリミノー",      manufacturer: "TIMON",            lure_type: :minnow, buoyancy: 3 },
  { name: "ちびブリブリミノー",  manufacturer: "TIMON",            lure_type: :minnow, buoyancy: 3 },
  { name: "ダイバライズ",        manufacturer: "Shimano",          lure_type: :minnow, buoyancy: 5 },
  { name: "パニッシュ",          manufacturer: "Smith",            lure_type: :minnow, buoyancy: 1 },
  { name: "DDパニッシュ",       manufacturer: "Smith",            lure_type: :minnow, buoyancy: 5 },
  { name: "ペリカンミノー",      manufacturer: "Nories",           lure_type: :minnow, buoyancy: 2 },
  { name: "TCレイゲン",         manufacturer: "TIMON",            lure_type: :minnow, buoyancy: 5 },
  { name: "K-2ミノー",          manufacturer: "HMKL",             lure_type: :minnow, buoyancy: 3 },
  { name: "ボーダーミノー",      manufacturer: "HMKL",             lure_type: :minnow, buoyancy: 1 },
  { name: "ダーガ",              manufacturer: "OSP",              lure_type: :minnow, buoyancy: 5 },
  { name: "フィンガーサック",    manufacturer: "Halcyon System",   lure_type: :minnow, buoyancy: 3 },
  { name: "Dコンタクト",        manufacturer: "Smith",            lure_type: :minnow, buoyancy: 5 },
  { name: "ベビーシャッド",      manufacturer: "Rodeo Craft",      lure_type: :minnow, buoyancy: 5 },
  { name: "スライドオン",        manufacturer: "TIMON",            lure_type: :minnow, buoyancy: 3 },
  { name: "スウェーバー",        manufacturer: "ValkeIN",          lure_type: :minnow, buoyancy: 5 },
  { name: "蓮",                  manufacturer: "Mukai",            lure_type: :minnow, buoyancy: 1 },
  { name: "クリッパー",          manufacturer: "Smith",            lure_type: :minnow, buoyancy: 3 },
  { name: "パワーミノー",        manufacturer: "HMKL",             lure_type: :minnow, buoyancy: 5 },
  { name: "リズモラプス",        manufacturer: "Halcyon System",   lure_type: :minnow, buoyancy: 3 },
  { name: "ムーンワーム",        manufacturer: "Halcyon System",   lure_type: :minnow, buoyancy: 0 },
  { name: "ブラストイット",      manufacturer: "iJetlink",         lure_type: :minnow, buoyancy: 5 },
  { name: "メテオーラ",          manufacturer: "Jackson",          lure_type: :minnow, buoyancy: 5 },
  { name: "フタラ",              manufacturer: "Displout",         lure_type: :minnow, buoyancy: 3 },
  { name: "バフェット",          manufacturer: "Tackle House",     lure_type: :minnow, buoyancy: 1 },
  { name: "ダイイングミノー",    manufacturer: "HMKL",             lure_type: :minnow, buoyancy: 2 },
  { name: "カウントダウン",      manufacturer: "Rapala",           lure_type: :minnow, buoyancy: 5 },
  { name: "K-1ミノー",          manufacturer: "HMKL",             lure_type: :minnow, buoyancy: 3 },
  { name: "グリム",              manufacturer: "メーカー不明",     lure_type: :minnow, buoyancy: 3 },

  # ───── その他（other: 3） ─────
  { name: "デカミッツドライ",      manufacturer: "TIMON",             lure_type: :other },
  { name: "ミッツドライ",          manufacturer: "TIMON",             lure_type: :other },
  { name: "カディス",              manufacturer: "Smith",             lure_type: :other },
  { name: "にゃんプップ",          manufacturer: "Rodeo Craft",       lure_type: :other },
  { name: "にゃんプップラトル",    manufacturer: "Rodeo Craft",       lure_type: :other },
  { name: "2win",                  manufacturer: "Naburaya",          lure_type: :other },
  { name: "タップダンサー",        manufacturer: "TIMON",             lure_type: :other },
  { name: "ちびタップダンサー",    manufacturer: "TIMON",             lure_type: :other },
  { name: "ポゴ",                  manufacturer: "Mukai",             lure_type: :other },
  { name: "リトルポゴ",            manufacturer: "Mukai",             lure_type: :other },
  { name: "ポゴビーン",            manufacturer: "Mukai",             lure_type: :other },
  { name: "シャインライド",        manufacturer: "ValkeIN",           lure_type: :other },
  { name: "シャインライドナノ",    manufacturer: "ValkeIN",           lure_type: :other },
  { name: "セニョールトルネード",  manufacturer: "Zactcraft",         lure_type: :other },
  { name: "Xスティック",          manufacturer: "X-lure",            lure_type: :other },
  { name: "ぐるぐるX",            manufacturer: "X-lure",            lure_type: :other },
  { name: "バベル",                manufacturer: "Rob Lure",          lure_type: :other },
  { name: "バベルWZ",             manufacturer: "Rob Lure",          lure_type: :other },
  { name: "デカブング",            manufacturer: "TIMON",             lure_type: :other },
  { name: "ブング",                manufacturer: "TIMON",             lure_type: :other },
  { name: "Bスパーク",            manufacturer: "Office Eucalyptus", lure_type: :other },
  { name: "ヴァルキャノン",        manufacturer: "ValkeIN",           lure_type: :other },
  { name: "ナイアス",              manufacturer: "FPB LURES",         lure_type: :other },
  { name: "メタルクロボール",      manufacturer: "TIMON",             lure_type: :other },
  { name: "クロボールベータ",      manufacturer: "TIMON",             lure_type: :other },
  { name: "ハビー",                manufacturer: "Ivy Line",          lure_type: :other },
  { name: "サーキットバイブ",      manufacturer: "Deps",              lure_type: :other },
  { name: "パームボール",          manufacturer: "Lucky Craft",       lure_type: :other },
  { name: "パンチメンター",        manufacturer: "Rob Lure",          lure_type: :other },
  { name: "スタッカーバイブ",      manufacturer: "God Hands",         lure_type: :other },
  { name: "ボトムチョッパー",      manufacturer: "Nories",            lure_type: :other },
  { name: "Bクラッシュ",          manufacturer: "Office Eucalyptus", lure_type: :other },
  { name: "ゴーレム",              manufacturer: "Velvet Arts",       lure_type: :other },
  { name: "ギロチン",              manufacturer: "Alfred",            lure_type: :other },
  { name: "ハイスタンプ",          manufacturer: "Mukai",             lure_type: :other },
  { name: "トラウトZX",           manufacturer: "Nories",            lure_type: :other },
  { name: "リアクションジャバー",  manufacturer: "Displout",          lure_type: :other },
  { name: "シャドウアタッカー",    manufacturer: "Rodeo Craft",       lure_type: :other },
  { name: "ベルオーガ",            manufacturer: "Displout",          lure_type: :other },
  { name: "ライズマーカー",        manufacturer: "Displout",          lure_type: :other },
  { name: "パペットサーフェス",    manufacturer: "Smith",             lure_type: :other },
  { name: "バブルマジック",        manufacturer: "Jackson",           lure_type: :other },
  { name: "ダートマジック",        manufacturer: "Jackson",           lure_type: :other },
  { name: "ヘコヘコマジック",      manufacturer: "Jackson",           lure_type: :other }
]

lures_data.each do |data|
  Lure.find_or_create_by!(name: data[:name], manufacturer: data[:manufacturer], user: master_user) do |l|
    l.lure_type = data[:lure_type]
    l.buoyancy  = data[:buoyancy] if data.key?(:buoyancy)
  end
end

puts "✅ ルアーデータの投入が完了しました"
puts "   スプーン:       #{Lure.spoon.count}本"
puts "   クランクベイト: #{Lure.crankbait.count}本"
puts "   ミノー:         #{Lure.minnow.count}本"
puts "   その他:         #{Lure.other.count}本"

# ===== 釣果データ =====
catch_records_base = [
  {
    facility_name: "ニセコフィッシングエリア",
    lure_name:     "ノア",
    fish_species:  "レインボートラウト",
    size_cm: 32.5, depth_m: 1.5,
    memo:          "朝イチの放流直後、スプーンのただ巻きで連発！表層を意識して巻くのがコツだった。",
    caught_at:     2.days.ago.change(hour: 8,  min: 30),
    stocking_time: "08:00"
  },
  {
    facility_name: "ニセコフィッシングエリア",
    lure_name:     "パニクラ",
    fish_species:  "レインボートラウト",
    size_cm: 28.0, depth_m: 0.8,
    memo:          "スプーンに反応なし、クランクに変えたら即ヒット。ゆっくり一定速度で引くとよかった。",
    caught_at:     2.days.ago.change(hour: 10, min: 15),
    stocking_time: "08:00"
  },
  {
    facility_name: "東山湖フィッシングエリア",
    lure_name:     "Dコンタクト",
    fish_species:  "ブラウントラウト",
    size_cm: 41.0, depth_m: 2.0,
    memo:          "ミノーのトゥイッチングで大型ブラウンをゲット！富士山バックの写真が最高だった。",
    caught_at:     5.days.ago.change(hour: 14, min: 20),
    stocking_time: "12:00"
  },
  {
    facility_name: "那須高原管釣りパーク",
    lure_name:     "ティアロ",
    fish_species:  "レインボートラウト",
    size_cm: 35.5, depth_m: 1.2,
    memo:          "チャートスプーンが爆発。高原の気温が低く魚が元気でファイトが激しかった。",
    caught_at:     10.days.ago.change(hour: 9, min: 45),
    stocking_time: "09:00"
  },
  {
    facility_name: "朝霞ガーデン",
    lure_name:     "モカ",
    fish_species:  "ヤマメ",
    size_cm: 25.0, depth_m: 0.5,
    memo:          "クランクで表層引き。ヤマメは朝夕の低光量時が狙い目。小さいがきれいな魚体だった。",
    caught_at:     1.week.ago.change(hour: 7, min: 0),
    stocking_time: "06:30"
  }
]

catch_records_base.each do |base|
  facility = Facility.find_by!(name: base[:facility_name])
  lure     = Lure.find_by(name: base[:lure_name], user: master_user)

  CatchRecord.find_or_create_by!(
    user:      user,
    facility:  facility,
    caught_at: base[:caught_at]
  ) do |r|
    r.fish_species  = base[:fish_species]
    r.size_cm       = base[:size_cm]
    r.depth_m       = base[:depth_m]
    r.memo          = base[:memo]
    r.stocking_time = base[:stocking_time]
    r.lure          = lure
  end
  puts "  ✅ 釣果: #{base[:fish_species]} #{base[:size_cm]}cm @ #{base[:facility_name]}"
end

puts ""
puts "🎣 シードデータ投入完了！"
puts "   ユーザー: #{User.count}名"
puts "   施設:     #{Facility.count}件"
puts "   ルアー:   #{Lure.count}本"
puts "   釣果:     #{CatchRecord.count}件"
puts ""
puts "📱 ログイン情報:"
puts "   メール:     test@test.com"
puts "   パスワード: testtest1029"
