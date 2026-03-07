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

# 既存ユーザーも含めた全ユーザーリスト（IDの昇順）
seed_users = User.order(:id).to_a

# ===== 施設データ =====
facilities_data = [
  # ─── 関東 ───────────────────────────────────────────────────────────────────
  {
    name: "フィッシングエリア オービット",
    address: "埼玉県秩父市荒川久那1456",
    latitude: 35.9536092, longitude: 139.0589836,
    prefecture: "埼玉県",
    description: "秩父の山あいを流れる荒川支流を利用した管理釣り場。スプーンからクランクまで幅広いルアーが有効。放流量が多く初心者にも人気。",
    is_verified: true
  },
  {
    name: "芦ノ湖フィッシングセンター",
    address: "神奈川県足柄下郡箱根町元箱根164",
    latitude: 35.241195, longitude: 138.991719,
    prefecture: "神奈川県",
    description: "富士山と芦ノ湖を背景にした絶景の釣り場。大型レインボーが狙える。ミノーでの釣果が多い。",
    is_verified: true
  },
  {
    name: "管釣りパーク 那須高原",
    address: "栃木県那須郡那須町高久乙593",
    latitude: 37.03904, longitude: 140.015256,
    prefecture: "栃木県",
    description: "那須高原の清流を利用した管理釣り場。水温が低く魚の活性が高い。ブラウントラウトも放流。",
    is_verified: true
  },
  {
    name: "フィッシングランド BLUE LAKE",
    address: "千葉県市原市新田483",
    latitude: 35.484686, longitude: 140.084249,
    prefecture: "千葉県",
    description: "千葉県内最大級の管理釣り場。複数のポンドがあり、難易度別に楽しめる。定期的に大型魚を放流。",
    is_verified: false
  },
  {
    name: "丹沢湖フィッシングパーク",
    address: "神奈川県足柄上郡山北町中川868",
    latitude: 35.472224, longitude: 139.064276,
    prefecture: "神奈川県",
    description: "丹沢山地の麓にある渓流系の管理釣り場。ヤマメ・イワナ・ニジマスが狙える。ドライフライも有効。",
    is_verified: true
  },
  {
    name: "奥多摩フィッシングセンター",
    address: "東京都西多摩郡奥多摩町小丹波225",
    latitude: 35.825085, longitude: 139.144895,
    prefecture: "東京都",
    description: "多摩川上流の清流を利用した管理釣り場。ニジマスをはじめヤマメ・イワナも放流。都心から90分で自然に囲まれた釣り体験ができる。",
    is_verified: true
  },
  {
    name: "アルクスポンド東京",
    address: "東京都八王子市川口町3333",
    latitude: 35.697016, longitude: 139.273805,
    prefecture: "東京都",
    description: "八王子の山間に広がるエリアトラウト専門ポンド。複数エリアで難易度別に楽しめる。定期的なビッグウェイト放流も魅力。",
    is_verified: true
  },
  {
    name: "フォレストスプリングス",
    address: "群馬県吾妻郡東吾妻町松谷1369",
    latitude: 36.578412, longitude: 138.729182,
    prefecture: "群馬県",
    description: "山間の湧水を利用した清澄な管理釣り場。スプーンの名手が集まる関東屈指のエリア。放流魚の平均サイズが大きく釣りごたえ十分。",
    is_verified: true
  },
  {
    name: "川場フィッシングプラザ",
    address: "群馬県利根郡川場村川場湯原401",
    latitude: 36.746648, longitude: 139.132253,
    prefecture: "群馬県",
    description: "川場村の清流沿いに展開する自然豊かな管理釣り場。ヤマメ・ニジマス・ブラウンを放流。渓流雰囲気の中でエリアフィッシングを楽しめる。",
    is_verified: true
  },
  {
    name: "ノースランド管理釣り場",
    address: "群馬県利根郡みなかみ町月夜野1744",
    latitude: 36.693817, longitude: 138.977795,
    prefecture: "群馬県",
    description: "水上・月夜野エリアに位置する老舗の管理釣り場。清流を活かした自然環境で魚の活性が高い。スプーン・クランク問わず釣果が上がりやすい。",
    is_verified: false
  },
  {
    name: "ドリームフィールズ",
    address: "埼玉県日高市高萩1191",
    latitude: 35.897611, longitude: 139.378008,
    prefecture: "埼玉県",
    description: "埼玉西部に位置するエリアトラウト専門フィールド。都心からのアクセスが良く週末の家族連れにも人気。ビギナー向けポンドあり。",
    is_verified: true
  },
  {
    name: "スプリングフィールド トラウトエリア",
    address: "栃木県鹿沼市入粟野1701",
    latitude: 36.589235, longitude: 139.573836,
    prefecture: "栃木県",
    description: "鹿沼の山間に湧く冷水を利用。ニジマスを中心にイトウも放流される人気エリア。スプーンからボトムまで多彩な釣りが楽しめる。",
    is_verified: true
  },
  {
    name: "那珂川フィッシングエリア",
    address: "栃木県那須郡那珂川町小川912",
    latitude: 36.767234, longitude: 140.126659,
    prefecture: "栃木県",
    description: "那珂川の支流を活かした渓流系エリア。ヤマメ・イワナの放流量が多く、ドライフライも有効。渓流気分を満喫できる穴場スポット。",
    is_verified: false
  },
  {
    name: "プレステージフィッシングエリア",
    address: "茨城県常陸大宮市小瀬3234",
    latitude: 36.608847, longitude: 140.324768,
    prefecture: "茨城県",
    description: "茨城の山間部に位置する本格エリアトラウト施設。大型ニジマスの放流で知られ、ランカーを狙うアングラーが集う。複数ポンドで難易度別に対応。",
    is_verified: true
  },
  # ─── 中部 ───────────────────────────────────────────────────────────────────
  {
    name: "道志の森フィッシング",
    address: "山梨県南都留郡道志村9341",
    latitude: 35.527784, longitude: 139.033445,
    prefecture: "山梨県",
    description: "道志川の源流域に広がる渓流エリア。東京・神奈川から2時間以内でアクセス可能。ヤマメ・イワナ・ニジマスを自然渓流で狙える。",
    is_verified: true
  },
  {
    name: "コスタフォレスト",
    address: "山梨県上野原市棡原2801",
    latitude: 35.677904, longitude: 139.091817,
    prefecture: "山梨県",
    description: "山梨県内随一のエリアトラウト施設。複数の管理池でビギナーから上級者まで対応。カフェ・キャンプも併設でファミリーに人気。",
    is_verified: true
  },
  {
    name: "山梨フィッシングリゾート ノースフォーク",
    address: "山梨県北杜市長坂町大八田3012",
    latitude: 35.833105, longitude: 138.383849,
    prefecture: "山梨県",
    description: "八ヶ岳の麓、標高700mに位置する高原管理釣り場。夏でも涼しく魚の活性が高い。富士山・南アルプスを望む絶景エリア。",
    is_verified: true
  },
  {
    name: "信州ロッキーフィッシング",
    address: "長野県佐久市臼田2513",
    latitude: 36.200162, longitude: 138.475763,
    prefecture: "長野県",
    description: "佐久平の清冽な水を引き込んだ管理釣り場。高地特有の低水温でニジマスの活性が高く、年間を通じて安定した釣果。スプーンが特に有効。",
    is_verified: true
  },
  {
    name: "戸隠フィッシングエリア",
    address: "長野県長野市戸隠3506",
    latitude: 36.732473, longitude: 138.075875,
    prefecture: "長野県",
    description: "戸隠山の湧水を利用した高原フィッシングエリア。神秘的な自然の中でトラウトフィッシングを楽しめる。ミノー・スプーン両方に実績あり。",
    is_verified: false
  },
  {
    name: "越後フィッシングパーク 魚沼",
    address: "新潟県魚沼市井口新田1023",
    latitude: 37.231799, longitude: 138.972022,
    prefecture: "新潟県",
    description: "魚沼の清流を活かした管理釣り場。豊富な雪解け水で水量・水温が安定。ニジマス・ブラウンを中心に大型魚の放流が多い。",
    is_verified: true
  },
  {
    name: "富士山麓フィッシングエリア",
    address: "静岡県裾野市須山703",
    latitude: 35.251579, longitude: 138.847588,
    prefecture: "静岡県",
    description: "富士山の湧水を利用した絶景管理釣り場。富士山を望みながらトラウトフィッシングが楽しめる。水質抜群でニジマスのコンディションが良い。",
    is_verified: true
  },
  {
    name: "郡上フライフィッシングリゾート",
    address: "岐阜県郡上市八幡町島谷1023",
    latitude: 35.746715, longitude: 136.95764,
    prefecture: "岐阜県",
    description: "長良川支流を利用した本格フライ・ルアー専用エリア。ヤマメ・アマゴ・ニジマスが狙える清流フィッシング。渓流釣り師に人気の名所。",
    is_verified: true
  },
  {
    name: "奥飛騨フィッシングパーク",
    address: "岐阜県高山市奥飛騨温泉郷一重ヶ根512",
    latitude: 36.220239, longitude: 137.557011,
    prefecture: "岐阜県",
    description: "飛騨山脈の清流を引き込んだ高原管理釣り場。標高900m超で夏でも快適な釣り環境。イワナ・ヤマメ・ニジマスを放流。",
    is_verified: false
  },
  {
    name: "愛知フィッシングエリア 設楽",
    address: "愛知県北設楽郡設楽町田峯字村西23",
    latitude: 35.112588, longitude: 137.468654,
    prefecture: "愛知県",
    description: "奥三河の秘境に位置するトラウトエリア。豊川の源流域を利用した清流フィッシング。都市部から離れた自然環境で釣り漬けになれる。",
    is_verified: false
  },
  # ─── 近畿 ───────────────────────────────────────────────────────────────────
  {
    name: "びわ湖フィッシングガーデン",
    address: "滋賀県大津市伊香立途中町1821",
    latitude: 35.173633, longitude: 135.861207,
    prefecture: "滋賀県",
    description: "比良山系の麓に広がるエリアトラウト施設。びわ湖を見下ろすロケーションが自慢。ニジマス・ブラウンを豊富に放流。",
    is_verified: true
  },
  {
    name: "京都フィッシングエリア 美山",
    address: "京都府南丹市美山町安掛下16",
    latitude: 35.275919, longitude: 135.587281,
    prefecture: "京都府",
    description: "かやぶきの里・美山の清流沿いに整備された管理釣り場。アクセスは少し遠いが水質は抜群。ヤマメ・ニジマスが高活性で楽しめる。",
    is_verified: true
  },
  {
    name: "兵庫フィッシングパーク 三田",
    address: "兵庫県三田市福島1001",
    latitude: 34.914255, longitude: 135.21733,
    prefecture: "兵庫県",
    description: "阪神・阪急からのアクセスが良い関西圏随一のエリアトラウト施設。初心者向けから上級者向けまで複数ポンドを完備。",
    is_verified: true
  },
  # ─── 中国・四国 ─────────────────────────────────────────────────────────────
  {
    name: "岡山フィッシングエリア 津山",
    address: "岡山県津山市加茂町中原921",
    latitude: 35.171541, longitude: 134.050852,
    prefecture: "岡山県",
    description: "中国山地の清流を引き込んだ西日本屈指のトラウトエリア。中四国のエリアフィッシャーが集まるランドマーク的存在。大型ニジマス放流で有名。",
    is_verified: true
  },
  {
    name: "広島フィッシングパーク 三次",
    address: "広島県三次市作木町口羽351",
    latitude: 34.871821, longitude: 132.722272,
    prefecture: "広島県",
    description: "江の川支流を活かした中国地方の名門管理釣り場。ヤマメ・ニジマス・ブラウンを放流。スプーン・ミノー問わず安定した釣果が望める。",
    is_verified: false
  },
  # ─── 東北 ───────────────────────────────────────────────────────────────────
  {
    name: "猪苗代フィッシングエリア",
    address: "福島県耶麻郡猪苗代町蚕養3074",
    latitude: 37.602343, longitude: 140.211738,
    prefecture: "福島県",
    description: "猪苗代湖畔に位置する東北有数の管理釣り場。会津の清冽な水で育ったトラウトは引きが強烈。磐梯山を望む景色も最高。",
    is_verified: true
  },
  {
    name: "仙台フィッシングエリア 広瀬川",
    address: "宮城県仙台市青葉区芋沢字大竹3",
    latitude: 38.283149, longitude: 140.791309,
    prefecture: "宮城県",
    description: "仙台市内から車で30分の好立地。広瀬川の源流域を利用した清流エリア。ニジマス・ヤマメを多数放流。初心者歓迎のレンタルタックルあり。",
    is_verified: true
  },
  # ─── 九州 ───────────────────────────────────────────────────────────────────
  {
    name: "福岡フィッシングセンター 糸島",
    address: "福岡県糸島市二丈吉井3012",
    latitude: 33.483016, longitude: 130.078687,
    prefecture: "福岡県",
    description: "糸島の山間部に位置する九州最大級のエリアトラウト施設。ニジマス・ブラウン・ヤマメを放流。福岡市内から1時間以内の好アクセス。",
    is_verified: true
  },
  {
    name: "阿蘇フィッシングリゾート",
    address: "熊本県阿蘇市小里1534",
    latitude: 32.978356, longitude: 131.050744,
    prefecture: "熊本県",
    description: "阿蘇の伏流水を利用した九州南部の名門管理釣り場。年間を通じて水温が安定し魚のコンディションが良好。カルデラを望む絶景が広がる。",
    is_verified: true
  },
  # ─── 北海道 ─────────────────────────────────────────────────────────────────
  {
    name: "ニセコフィッシングエリア",
    address: "北海道虻田郡倶知安町字三島82",
    latitude: 42.902304, longitude: 140.756501,
    prefecture: "北海道",
    description: "羊蹄山の麓、ニセコの清冽な湧水を利用した北海道最高峰のトラウトエリア。降雪期以外はほぼ年間営業。大型ブラウン・ニジマスが揃う。",
    is_verified: true
  },
  {
    name: "千歳川フィッシングエリア",
    address: "北海道千歳市支笏湖温泉番外地",
    latitude: 42.776586, longitude: 141.401698,
    prefecture: "北海道",
    description: "支笏湖から流れ出る千歳川沿いの管理釣り場。日本一の透明度を誇る支笏湖の恩恵を受けた超清澄な水でトラウトのコンディションが別格。",
    is_verified: true
  },
  # ─── 追加施設（全国） ────────────────────────────────────────────────────────
  { name: "洞爺湖フィッシングエリア",         address: "北海道虻田郡洞爺湖町洞爺湖温泉142",    prefecture: "北海道",  latitude: 42.56604,   longitude: 140.819118, is_verified: true  },
  { name: "支笏湖フィッシングエリア",         address: "北海道千歳市支笏湖温泉",               prefecture: "北海道",  latitude: 42.772749,  longitude: 141.404134, is_verified: true  },
  { name: "フィッシングエリアウキウキランド", address: "青森県三戸郡新郷村戸来上栃棚森ノ下58-1", prefecture: "青森県",  latitude: 40.439086,  longitude: 141.108003, is_verified: true  },
  { name: "岩洞湖レジャーランド",             address: "岩手県盛岡市繋字岩洞",                prefecture: "岩手県",  latitude: 39.675955,  longitude: 141.019831, is_verified: true  },
  { name: "蔵王フィッシングエリア",           address: "宮城県刈田郡蔵王町遠刈田温泉",         prefecture: "宮城県",  latitude: 38.112195,  longitude: 140.531038, is_verified: true  },
  { name: "猫魔フィッシングエリア",           address: "福島県耶麻郡北塩原村桧原剣ヶ峯",       prefecture: "福島県",  latitude: 37.663004,  longitude: 140.076376, is_verified: true  },
  { name: "裏磐梯フィッシングエリア",         address: "福島県耶麻郡北塩原村大字桧原字剣ヶ峯",  prefecture: "福島県",  latitude: 37.663004,  longitude: 140.076376, is_verified: true  },
  { name: "北浦フィッシングエリア",           address: "茨城県行方市芹沢4145",                prefecture: "茨城県",  latitude: 36.140387,  longitude: 140.435984, is_verified: false },
  { name: "日光フィッシングエリア",           address: "栃木県日光市土沢1571",                prefecture: "栃木県",  latitude: 36.696841,  longitude: 139.726884, is_verified: true  },
  { name: "ハーブの里フィッシングエリア",     address: "群馬県吾妻郡中之条町大字入山1507",     prefecture: "群馬県",  latitude: 36.665719,  longitude: 138.658941, is_verified: true  },
  { name: "彩の国フィッシングビレッジ",       address: "埼玉県飯能市赤沢817-1",               prefecture: "埼玉県",  latitude: 35.857859,  longitude: 139.208148, is_verified: true  },
  { name: "つり堀センター泉",                address: "埼玉県入間郡越生町大字黒岩156",         prefecture: "埼玉県",  latitude: 35.96789,   longitude: 139.290481, is_verified: false },
  { name: "秋川国際マス釣場",                address: "東京都あきる野市小中野213",             prefecture: "東京都",  latitude: 35.726522,  longitude: 139.208565, is_verified: true  },
  { name: "フィッシングサンクチュアリ",       address: "神奈川県相模原市緑区牧野4145",          prefecture: "神奈川県", latitude: 35.58208,  longitude: 139.152805, is_verified: true  },
  { name: "宮ヶ瀬フィッシングエリア",         address: "神奈川県愛甲郡清川村宮ヶ瀬",           prefecture: "神奈川県", latitude: 35.49643,  longitude: 139.208949, is_verified: true  },
  { name: "東山湖フィッシングエリア",         address: "山梨県富士吉田市新屋1936",             prefecture: "山梨県",  latitude: 35.45782,   longitude: 138.803518, is_verified: true  },
  { name: "白馬アルプスフィッシングエリア",   address: "長野県北安曇郡白馬村大字北城6313",     prefecture: "長野県",  latitude: 36.695879,  longitude: 137.862865, is_verified: true  },
  { name: "千曲フィッシングセンター",         address: "長野県佐久市臼田1050",                prefecture: "長野県",  latitude: 36.200162,  longitude: 138.475763, is_verified: true  },
  { name: "乗鞍フィッシングパーク",           address: "長野県松本市安曇4311",                prefecture: "長野県",  latitude: 36.214076,  longitude: 137.645517, is_verified: true  },
  { name: "伊豆フィッシングエリア",           address: "静岡県伊豆市湯ヶ島892",               prefecture: "静岡県",  latitude: 34.869173,  longitude: 138.920765, is_verified: true  },
  { name: "庄川フィッシングエリア",           address: "富山県砺波市庄川町小牧73",             prefecture: "富山県",  latitude: 36.554081,  longitude: 137.008849, is_verified: false },
  { name: "バレーフォレストフィッシングエリア", address: "滋賀県米原市山室48",                prefecture: "滋賀県",  latitude: 35.358004,  longitude: 136.331288, is_verified: true  },
  { name: "大阪フィッシングエリア 能勢",      address: "大阪府豊能郡能勢町倉垣1146",          prefecture: "大阪府",  latitude: 34.973326,  longitude: 135.463933, is_verified: true  },
  { name: "日高フィッシングエリア",           address: "和歌山県日高郡日高川町高津尾",         prefecture: "和歌山県", latitude: 33.973958, longitude: 135.30408,  is_verified: false },
  { name: "庄原フィッシングエリア",           address: "広島県庄原市口和町宮内",              prefecture: "広島県",  latitude: 34.956164,  longitude: 132.912496, is_verified: false },
  { name: "四国フィッシングエリア 仁淀川",    address: "高知県吾川郡いの町清水上分",           prefecture: "高知県",  latitude: 33.701491,  longitude: 133.339122, is_verified: true  },
  { name: "日田フィッシングエリア",           address: "大分県日田市大山町西大山2900",         prefecture: "大分県",  latitude: 33.23206,   longitude: 130.968784, is_verified: true  },
  { name: "南阿蘇フィッシングエリア",         address: "熊本県阿蘇郡南阿蘇村河陰",            prefecture: "熊本県",  latitude: 32.82262,   longitude: 131.009148, is_verified: true  },
  { name: "綾フィッシングエリア",             address: "宮崎県東諸県郡綾町南俣",              prefecture: "宮崎県",  latitude: 32.025303,  longitude: 131.170319, is_verified: false },
]

facilities_data.each do |data|
  facility = Facility.find_or_create_by!(name: data[:name]) do |f|
    f.assign_attributes(data)
  end
  puts "  ✅ 施設: #{facility.name} (#{facility.prefecture})"
end

# ===== ルアーデータ =====
lures_data = [
  { name: "ノア 1.6g シルバー",         lure_type: :spoon,    color_front: "#C0C0C0", color_back: "#FFD700", weight: 1.6, buoyancy: 5 },
  { name: "ペレット 2.4g チャート",      lure_type: :spoon,    color_front: "#FFFF00", color_back: "#FF6B00", weight: 2.4, buoyancy: 5 },
  { name: "クレスト 3.5g ピンク",        lure_type: :spoon,    color_front: "#FF69B4", color_back: "#FF1493", weight: 3.5, buoyancy: 4 },
  { name: "ティアラ F チャートリュース", lure_type: :crankbait, color_front: "#ADFF2F", color_back: "#7CFC00", weight: 2.1, buoyancy: 1 },
  { name: "バベルコーン 2.2g オリーブ",  lure_type: :crankbait, color_front: "#808000", color_back: "#556B2F", weight: 2.2, buoyancy: 3 },
  { name: "ドクターミノー 50SP ナチュラル", lure_type: :minnow, color_front: "#87CEEB", color_back: "#4169E1", weight: 3.0, buoyancy: 3 },
  { name: "モカ MR-SS マット系",         lure_type: :minnow,   color_front: "#8B4513", color_back: "#A0522D", weight: 2.8, buoyancy: 2 },
  { name: "プレッソ ロール スワール 1.4g", lure_type: :other,  color_front: "#FF4500", color_back: "#FF6347", weight: 1.4, buoyancy: 4 }
]

seed_users.each do |seed_user|
  lures_data.each do |data|
    lure = Lure.find_or_create_by!(user: seed_user, name: data[:name]) do |l|
      l.assign_attributes(data.merge(user: seed_user))
    end
    puts "  ✅ ルアー[#{seed_user.username}]: #{lure.name}"
  end
end

# ===== 釣果データ定義 =====
facilities = Facility.all.to_a

catch_records_base = [
  {
    facility_idx: 0,
    lure_name: "ノア 1.6g シルバー",
    fish_species: "レインボートラウト",
    size_cm: 32.5, depth_m: 1.5,
    latitude: 35.8760, longitude: 139.6540,
    memo: "朝イチの放流直後、スプーンのただ巻きで連発！表層を意識して巻くのがコツだった。",
    caught_at: 2.days.ago.change(hour: 8, min: 30),
    stocking_time: "08:00"
  },
  {
    facility_idx: 0,
    lure_name: "ティアラ F チャートリュース",
    fish_species: "レインボートラウト",
    size_cm: 28.0, depth_m: 0.8,
    latitude: 35.8762, longitude: 139.6542,
    memo: "スプーンに反応なし、クランクに変えたら即ヒット。ゆっくり一定速度で引くとよかった。",
    caught_at: 2.days.ago.change(hour: 10, min: 15),
    stocking_time: "08:00"
  },
  {
    facility_idx: 1,
    lure_name: "ドクターミノー 50SP ナチュラル",
    fish_species: "ブラウントラウト",
    size_cm: 41.0, depth_m: 2.0,
    latitude: 35.2008, longitude: 139.0207,
    memo: "ミノーのトゥイッチングで大型ブラウンをゲット！富士山バックの写真が最高だった。",
    caught_at: 5.days.ago.change(hour: 14, min: 20),
    stocking_time: "12:00"
  },
  {
    facility_idx: 2,
    lure_name: "ペレット 2.4g チャート",
    fish_species: "レインボートラウト",
    size_cm: 35.5, depth_m: 1.2,
    latitude: 37.0510, longitude: 140.0629,
    memo: "チャートスプーンが爆発。高原の気温が低く魚が元気でファイトが激しかった。",
    caught_at: 10.days.ago.change(hour: 9, min: 45),
    stocking_time: "09:00"
  },
  {
    facility_idx: 0,
    lure_name: "モカ MR-SS マット系",
    fish_species: "ヤマメ",
    size_cm: 25.0, depth_m: 0.5,
    latitude: 35.8758, longitude: 139.6538,
    memo: "ミノーで表層引き。ヤマメは朝夕の低光量時が狙い目。サイズは小さいがきれいな魚体だった。",
    caught_at: 1.week.ago.change(hour: 7, min: 0),
    stocking_time: "06:30"
  }
]

seed_users.each do |seed_user|
  catch_records_base.each do |base|
    facility = facilities[base[:facility_idx]]
    lure     = Lure.find_by(user: seed_user, name: base[:lure_name])

    record = CatchRecord.find_or_create_by!(
      user: seed_user,
      facility: facility,
      caught_at: base[:caught_at]
    ) do |r|
      r.fish_species  = base[:fish_species]
      r.size_cm       = base[:size_cm]
      r.depth_m       = base[:depth_m]
      r.latitude      = base[:latitude]
      r.longitude     = base[:longitude]
      r.memo          = base[:memo]
      r.stocking_time = base[:stocking_time]
      r.lure          = lure
    end
    puts "  ✅ 釣果[#{seed_user.username}]: #{record.fish_species} #{record.size_cm}cm @ #{facility.name}"
  end
end

puts ""
puts "🎣 シードデータ投入完了！"
puts "   ユーザー: #{User.count}名"
puts "   施設:     #{Facility.count}件"
puts "   ルアー:   #{Lure.count}本"
puts "   釣果:     #{CatchRecord.count}件"
puts ""
puts "📱 ログイン情報:"
puts "   メール: test@example.com"
puts "   パスワード: password123"
