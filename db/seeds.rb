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
  {
    name: "フィッシングエリア オービット",
    address: "埼玉県さいたま市緑区大崎3444",
    latitude: 35.8763,
    longitude: 139.6544,
    prefecture: "埼玉県",
    phone_number: "048-XXX-XXXX",
    website_url: "https://example.com/orbit",
    description: "都心から近い管理釣り場。スプーンからクランクまで幅広いルアーが有効。放流量が多く初心者にも人気。",
    is_verified: true
  },
  {
    name: "芦ノ湖フィッシングセンター",
    address: "神奈川県足柄下郡箱根町元箱根164",
    latitude: 35.2006,
    longitude: 139.0205,
    prefecture: "神奈川県",
    phone_number: "0460-XX-XXXX",
    website_url: "https://example.com/ashinoko",
    description: "富士山と芦ノ湖を背景にした絶景の釣り場。大型レインボーが狙える。ミノーでの釣果が多い。",
    is_verified: true
  },
  {
    name: "管釣りパーク 那須高原",
    address: "栃木県那須郡那須町高久乙593",
    latitude: 37.0512,
    longitude: 140.0631,
    prefecture: "栃木県",
    phone_number: "0287-XX-XXXX",
    website_url: "https://example.com/nasu",
    description: "那須高原の清流を利用した管理釣り場。水温が低く魚の活性が高い。ブラウントラウトも放流。",
    is_verified: true
  },
  {
    name: "フィッシングランド BLUE LAKE",
    address: "千葉県市原市新田483",
    latitude: 35.4521,
    longitude: 140.1234,
    prefecture: "千葉県",
    phone_number: "0436-XX-XXXX",
    description: "千葉県内最大級の管理釣り場。複数のポンドがあり、難易度別に楽しめる。定期的に大型魚を放流。",
    is_verified: false
  },
  {
    name: "丹沢湖フィッシングパーク",
    address: "神奈川県足柄上郡山北町中川868",
    latitude: 35.4234,
    longitude: 139.0312,
    prefecture: "神奈川県",
    phone_number: "0465-XX-XXXX",
    description: "丹沢山地の麓にある渓流系の管理釣り場。ヤマメ・イワナ・ニジマスが狙える。ドライフライも有効。",
    is_verified: true
  }
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
