class Lure < ApplicationRecord
  belongs_to :user
  has_many :catch_records, dependent: :nullify

  enum :lure_type, { spoon: 0, crankbait: 1, minnow: 2, other: 3 }

  BUOYANCY_LABELS = {
    0 => "ハイフロート",
    1 => "フローティング",
    2 => "スローフローティング",
    3 => "サスペンド",
    4 => "スローシンキング",
    5 => "シンキング"
  }.freeze

  LURE_TYPE_LABELS = {
    "spoon"     => "スプーン",
    "crankbait" => "クランクベイト",
    "minnow"    => "ミノー",
    "other"     => "その他"
  }.freeze

  MANUFACTURERS = {
    "Rodeo Craft" => {
      spoon:     ["ノア", "ノアL", "ノアJr", "ジキル", "ジキルL", "ブラインドフランカー", "キューム", "ドリフトスピン"],
      crankbait: ["モカ", "プチモカ", "ウッサ", "ウッサXS", "ワプラジュニア"],
      minnow:    ["ポーリー", "ベビーシャッド"],
      other:     ["にゃんプップ", "にゃんプップラトル", "シャドウアタッカー"]
    },
    "TIMON" => {
      spoon:     ["ティーグラベル", "レクセ", "アピード", "ティアロ"],
      crankbait: ["パニクラ", "ちびパニクラ", "キビパニ", "ペピーノ"],
      minnow:    ["ブリブリミノー", "ちびブリブリミノー", "TCレイゲン", "スライドオン"],
      other:     ["デカミッツドライ", "ミッツドライ", "タップダンサー", "ちびタップダンサー", "デカブング", "ブング", "メタルクロボール", "クロボールベータ"]
    },
    "Forest" => {
      spoon:     ["ミュー", "パル", "ファクター", "チェイサー"],
      crankbait: [],
      minnow:    [],
      other:     []
    },
    "ValkeIN" => {
      spoon:     ["ハイバースト", "サーヴァントスピア", "ブラックブラスト", "ギガバースト", "シャイラ", "シャイラナノ"],
      crankbait: ["クーガ", "クーガナノ", "ヘイズ", "ヘイズDD"],
      minnow:    ["ハイドラム", "ハイドラムナノ", "スウェーバー"],
      other:     ["シャインライド", "シャインライドナノ", "ヴァルキャノン"]
    },
    "HMKL" => {
      spoon:     [],
      crankbait: [],
      minnow:    ["ザッガー", "ザッガーB1", "ハンクルシャッド", "K-1ミノー", "K-2ミノー", "ボーダーミノー", "パワーミノー", "ダイイングミノー"],
      other:     []
    },
    "Smith" => {
      spoon:     ["クリスタル S", "AR-S"],
      crankbait: ["ピュア"],
      minnow:    ["スティル", "スティルエリアチューン", "パニッシュ", "DDパニッシュ", "Dコンタクト", "クリッパー", "リアライズ", "アレキサンドラ"],
      other:     ["カディス", "パペットサーフェス"]
    },
    "Nories" => {
      spoon:     ["ティーチ", "ウィーパー", "チュール", "ロキ"],
      crankbait: [],
      minnow:    ["ペリカンミノー"],
      other:     ["ボトムチョッパー", "トラウトZX"]
    },
    "Displout" => {
      spoon:     ["ポディウム"],
      crankbait: ["ガメクラ", "ピコイーグルプレーヤー", "チャタクラ"],
      minnow:    ["イーグルプレーヤー", "イーグルプレーヤーGJ", "フタラ"],
      other:     ["リアクションジャバー", "ベルオーガ", "ライズマーカー"]
    },
    "Lucky Craft" => {
      spoon:     [],
      crankbait: ["ワウ", "アンフェア", "クラピー", "マイクロクラピー", "ボトムクラピー", "マグナムクラピー"],
      minnow:    [],
      other:     ["パームボール"]
    },
    "Rob Lure" => {
      spoon:     [],
      crankbait: ["バービー", "バービーロング", "ママバービー", "ジャコ", "ブランキー"],
      minnow:    [],
      other:     ["バベル", "バベルWZ", "パンチメンター"]
    },
    "Mukai" => {
      spoon:     [],
      crankbait: ["ザンム", "トレモ", "トレモスリム", "スマッシュ"],
      minnow:    ["蓮"],
      other:     ["ポゴ", "リトルポゴ", "ポゴビーン", "ハイスタンプ"]
    },
    "Naburaya" => {
      spoon:     ["アキュラシー", "エクシード", "ヴィーナス"],
      crankbait: [],
      minnow:    [],
      other:     ["2win"]
    },
    "Jackson" => {
      spoon:     [],
      crankbait: [],
      minnow:    ["メテオーラ"],
      other:     ["バブルマジック", "ダートマジック", "ヘコヘコマジック"]
    },
    "Daiwa" => {
      spoon:     [],
      crankbait: [],
      minnow:    ["ダブルクラッチ", "ダブルクラッチSHF"],
      other:     []
    },
    "Shimano" => {
      spoon:     [],
      crankbait: [],
      minnow:    ["ダイバライズ"],
      other:     []
    },
    "OSP" => {
      spoon:     [],
      crankbait: ["メロ", "ロマンス"],
      minnow:    ["ダーガ"],
      other:     []
    },
    "Tackle House" => {
      spoon:     [],
      crankbait: ["ミニシカダ", "エルフィン", "グラスホッパー"],
      minnow:    ["バフェット"],
      other:     []
    },
    "iJetlink" => {
      spoon:     ["ピット", "デカピット", "脇差", "アイジェットソード"],
      crankbait: [],
      minnow:    ["ブラストイット"],
      other:     []
    },
    "Halcyon System" => {
      spoon:     [],
      crankbait: [],
      minnow:    ["フィンガーサック", "リズモラプス", "ムーンワーム"],
      other:     []
    },
    "ValleyHill" => {
      spoon:     [],
      crankbait: ["グレイシー", "ブリリア"],
      minnow:    ["イフリート"],
      other:     ["フェザージグ", "ボトムワン"]
    },
    "Velvet Arts" => {
      spoon:     ["フォルテ"],
      crankbait: [],
      minnow:    [],
      other:     ["ゴーレム"]
    },
    "Deep Paradox" => {
      spoon:     ["キッド", "キッドダディ", "グラビティ"],
      crankbait: [],
      minnow:    [],
      other:     []
    },
    "New Drawer" => {
      spoon:     ["ハント", "ハントグランデ", "バンナ"],
      crankbait: [],
      minnow:    [],
      other:     []
    },
    "FPB LURES" => {
      spoon:     ["ベリーズ", "ビーハート"],
      crankbait: [],
      minnow:    [],
      other:     ["ナイアス"]
    },
    "Waterland" => {
      spoon:     ["アルミン", "ディープダイヤ"],
      crankbait: [],
      minnow:    [],
      other:     []
    },
    "SAURIBU" => {
      spoon:     ["シャース", "シャースピー", "マーカス"],
      crankbait: [],
      minnow:    [],
      other:     []
    },
    "Yarie" => {
      spoon:     ["マイクロデクスター"],
      crankbait: [],
      minnow:    [],
      other:     []
    },
    "RIDEMARVEL" => {
      spoon:     ["スイッチバック"],
      crankbait: [],
      minnow:    [],
      other:     []
    },
    "YUMIN" => {
      spoon:     [],
      crankbait: ["ココニョロ", "ココニョロチビ"],
      minnow:    [],
      other:     []
    },
    "Ikekura" => {
      spoon:     [],
      crankbait: ["餌ニョロ"],
      minnow:    [],
      other:     []
    },
    "1089 Workshop" => {
      spoon:     [],
      crankbait: ["逆さニョロ"],
      minnow:    [],
      other:     []
    },
    "KarteLLas" => {
      spoon:     [],
      crankbait: ["ウルキ"],
      minnow:    [],
      other:     []
    },
    "Zactcraft" => {
      spoon:     [],
      crankbait: [],
      minnow:    [],
      other:     ["セニョールトルネード"]
    },
    "X-lure" => {
      spoon:     [],
      crankbait: [],
      minnow:    [],
      other:     ["Xスティック", "ぐるぐるX"]
    },
    "Office Eucalyptus" => {
      spoon:     [],
      crankbait: [],
      minnow:    [],
      other:     ["Bスパーク", "Bクラッシュ"]
    },
    "Ivy Line" => {
      spoon:     [],
      crankbait: [],
      minnow:    [],
      other:     ["ハビー"]
    },
    "Deps" => {
      spoon:     [],
      crankbait: [],
      minnow:    [],
      other:     ["サーキットバイブ"]
    },
    "God Hands" => {
      spoon:     [],
      crankbait: [],
      minnow:    [],
      other:     ["スタッカーバイブ"]
    },
    "Alfred" => {
      spoon:     [],
      crankbait: [],
      minnow:    [],
      other:     ["ギロチン"]
    },
    "Rapala" => {
      spoon:     [],
      crankbait: [],
      minnow:    ["カウントダウン"],
      other:     []
    },
    "Trout Spoons Lab" => {
      spoon:     ["サギクエスト"],
      crankbait: [],
      minnow:    [],
      other:     []
    },
    "KHOR" => {
      spoon:     ["フレア"],
      crankbait: [],
      minnow:    [],
      other:     []
    },
  }.freeze

  # メーカー名一覧（セレクトボックス用）
  MANUFACTURER_NAMES = MANUFACTURERS.keys.sort.freeze

  validates :name,         presence: true
  validates :manufacturer, length: { maximum: 255 }, allow_blank: true
  validates :lure_type,    presence: true
  validates :buoyancy,     inclusion: { in: 0..5 }, allow_nil: true
  validates :color_front,  format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "は有効なカラーコードを入力してください" }
  validates :color_back,   format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "は有効なカラーコードを入力してください" }

  def buoyancy_label
    BUOYANCY_LABELS[buoyancy]
  end

  def lure_type_label
    LURE_TYPE_LABELS[lure_type]
  end

  # メーカー＋種別からルアー名一覧を取得
  def self.lure_names_for(manufacturer:, lure_type:)
    MANUFACTURERS.dig(manufacturer, lure_type.to_sym) || []
  end
end