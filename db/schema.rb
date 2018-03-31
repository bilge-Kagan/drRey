# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170610132025) do

  create_table "anlik_veris", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "dktr_id", null: false
    t.bigint "hastane_id", null: false
    t.integer "hastane_servisi", default: 0, null: false
    t.integer "hasta_sayisi"
    t.integer "rey_kullanan"
    t.decimal "rey_puani", precision: 6, scale: 3, default: "0.0"
    t.decimal "memnuniyet", precision: 6, scale: 3, default: "0.0"
    t.virtual "rey_kullanim_orani", type: :decimal, precision: 6, scale: 3, as: "((`rey_kullanan` / `hasta_sayisi`) * 100)", stored: true
    t.index ["dktr_id"], name: "index_anlik_veris_on_dktr_id"
    t.index ["hastane_id"], name: "index_anlik_veris_on_hastane_id"
  end

  create_table "baz_puans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "rey_puani", precision: 6, scale: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "pozitif_katsayi", type: :decimal, precision: 6, scale: 3, as: "(100 / (100 - `rey_puani`))", stored: true
    t.virtual "negatif_katsayi", type: :decimal, precision: 6, scale: 3, as: "(100 / (`rey_puani` - 0))", stored: true
  end

  create_table "dktrs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "tc"
    t.string "isim"
    t.string "soyisim"
    t.bigint "hastane_id", null: false
    t.bigint "hastane_servisleri_id", null: false
    t.decimal "rey_puani", precision: 6, scale: 3, default: "0.0"
    t.integer "band_verisi", default: 0
    t.integer "rey_katilim", default: 0
    t.index ["hastane_id"], name: "index_dktrs_on_hastane_id"
    t.index ["hastane_servisleri_id"], name: "index_dktrs_on_hastane_servisleri_id"
    t.index ["tc"], name: "index_dktrs_on_tc", unique: true
  end

  create_table "donemlik_basaris", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "dktr_id", null: false
    t.bigint "hastane_id", null: false
    t.integer "hastane_servisi", default: 0, null: false
    t.integer "hasta_sayisi", default: 0
    t.integer "rey_kullanan", default: 0
    t.decimal "rey_puani", precision: 6, scale: 3, default: "0.0"
    t.decimal "hasta_sayisi_degisim", precision: 6, scale: 3
    t.decimal "rey_puani_degisim", precision: 6, scale: 3
    t.decimal "memnuniyet", precision: 6, scale: 3, default: "0.0"
    t.virtual "rey_kullanim_orani", type: :decimal, precision: 6, scale: 3, as: "((`rey_kullanan` / greatest(`hasta_sayisi`,1)) * 100)", stored: true
    t.index ["dktr_id"], name: "index_donemlik_basaris_on_dktr_id"
    t.index ["hastane_id"], name: "index_donemlik_basaris_on_hastane_id"
  end

  create_table "donems", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "baslangic"
    t.datetime "bitis"
    t.index ["baslangic", "bitis"], name: "index_donems_on_baslangic_and_bitis", unique: true
  end

  create_table "gecmis_veris", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "dktr_id", null: false
    t.bigint "hastane_id", null: false
    t.bigint "donem_id", null: false
    t.integer "hastane_servisi", default: 0, null: false
    t.integer "hasta_sayisi"
    t.integer "rey_kullanan"
    t.decimal "rey_puani", precision: 6, scale: 3, default: "0.0"
    t.decimal "memnuniyet", precision: 6, scale: 3, default: "0.0"
    t.integer "band"
    t.virtual "rey_kullanim_orani", type: :decimal, precision: 6, scale: 3, as: "((`rey_kullanan` / `hasta_sayisi`) * 100)", stored: true
    t.index ["dktr_id"], name: "index_gecmis_veris_on_dktr_id"
    t.index ["donem_id"], name: "index_gecmis_veris_on_donem_id"
    t.index ["hastane_id"], name: "index_gecmis_veris_on_hastane_id"
  end

  create_table "hast_as", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "tc"
    t.string "isim"
    t.string "soyisim"
    t.string "eposta"
    t.integer "rey_odulu", default: 0
    t.index ["tc"], name: "index_hast_as_on_tc", unique: true
  end

  create_table "hasta_rey_istatistiks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "hast_a_id", null: false
    t.integer "toplam_muayene_sayisi", default: 0
    t.integer "toplam_rey_kullanimi", default: 0
    t.decimal "rey_puani", precision: 6, scale: 3, default: "0.0"
    t.decimal "memnuniyet", precision: 6, scale: 3, default: "0.0"
    t.virtual "rey_kullanim_orani", type: :decimal, precision: 6, scale: 3, as: "((`toplam_rey_kullanimi` / greatest(`toplam_muayene_sayisi`,1)) * 100)", stored: true
    t.index ["hast_a_id"], name: "index_hasta_rey_istatistiks_on_hast_a_id"
  end

  create_table "hastane_gecmis_veris", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "hastane_id", null: false
    t.bigint "donem_id", null: false
    t.integer "hasta_sayisi"
    t.integer "rey_kullanan"
    t.decimal "rey_puani", precision: 6, scale: 3
    t.decimal "memnuniyet", precision: 6, scale: 3
    t.virtual "rey_kullanim_orani", type: :decimal, precision: 6, scale: 3, as: "((`rey_kullanan` / `hasta_sayisi`) * 100)", stored: true
    t.index ["donem_id"], name: "index_hastane_gecmis_veris_on_donem_id"
    t.index ["hastane_id"], name: "index_hastane_gecmis_veris_on_hastane_id"
  end

  create_table "hastane_servisleris", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "isim"
    t.index ["isim"], name: "index_hastane_servisleris_on_isim", unique: true
  end

  create_table "hastanes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "isim"
    t.string "kurum_kodu"
    t.bigint "il_id", null: false
    t.bigint "ilce_id", null: false
    t.decimal "son_rey_puani", precision: 6, scale: 3, default: "0.0"
    t.decimal "rey_puan_degisim", precision: 6, scale: 3
    t.decimal "ortalama_rey_puani", precision: 6, scale: 3, default: "0.0"
    t.decimal "memnuniyet", precision: 6, scale: 3, default: "0.0"
    t.index ["il_id"], name: "index_hastanes_on_il_id"
    t.index ["ilce_id"], name: "index_hastanes_on_ilce_id"
    t.index ["isim", "kurum_kodu"], name: "index_hastanes_on_isim_and_kurum_kodu", unique: true
  end

  create_table "ilces", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "isim"
    t.bigint "il_id", null: false
    t.decimal "son_rey_puani", precision: 6, scale: 3, default: "0.0"
    t.decimal "rey_puan_degisim", precision: 6, scale: 3
    t.decimal "ortalama_rey_puani", precision: 6, scale: 3, default: "0.0"
    t.decimal "memnuniyet", precision: 6, scale: 3, default: "0.0"
    t.index ["il_id"], name: "index_ilces_on_il_id"
  end

  create_table "ils", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "isim"
    t.decimal "son_rey_puani", precision: 6, scale: 3, default: "0.0"
    t.decimal "rey_puan_degisim", precision: 6, scale: 3
    t.decimal "ortalama_rey_puani", precision: 6, scale: 3, default: "0.0"
    t.decimal "memnuniyet", precision: 6, scale: 3, default: "0.0"
    t.index ["isim"], name: "index_ils_on_isim", unique: true
  end

  create_table "mail_lists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "muayene_id"
    t.string "hst_isim"
    t.string "hst_soyisim"
    t.string "hst_tc"
    t.string "e_posta"
    t.integer "random_pass", default: 0
    t.index ["muayene_id"], name: "index_mail_lists_on_muayene_id"
  end

  create_table "muayenes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "donem_id", null: false
    t.bigint "hastane_id", null: false
    t.bigint "hast_a_id", null: false
    t.bigint "dktr_id", null: false
    t.boolean "rey_kullanim_durumu", default: false
    t.boolean "rey_kullanim_hakki", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dktr_id"], name: "index_muayenes_on_dktr_id"
    t.index ["donem_id"], name: "index_muayenes_on_donem_id"
    t.index ["hast_a_id"], name: "index_muayenes_on_hast_a_id"
    t.index ["hastane_id"], name: "index_muayenes_on_hastane_id"
  end

  create_table "rey_kayitlaris", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "muayene_id", null: false
    t.integer "soru_1"
    t.integer "soru_2"
    t.integer "soru_3"
    t.integer "soru_4"
    t.integer "soru_5"
    t.text "yorum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "toplam_puan", type: :decimal, precision: 6, scale: 3, as: "((((`soru_1` + `soru_2`) + `soru_3`) + `soru_4`) + `soru_5`)", stored: true
    t.index ["muayene_id"], name: "index_rey_kayitlaris_on_muayene_id"
  end

  create_table "rey_skts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "muayene_id", null: false
    t.integer "baslangic"
    t.integer "bitis"
    t.boolean "sms", default: false
    t.index ["muayene_id"], name: "index_rey_skts_on_muayene_id"
  end

  create_table "ulke_gecmis_veris", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "donem_id", null: false
    t.integer "hasta_sayisi"
    t.integer "rey_kullanan"
    t.decimal "rey_puani", precision: 6, scale: 3
    t.decimal "memnuniyet", precision: 6, scale: 3
    t.decimal "baz_puan", precision: 6, scale: 3
    t.virtual "rey_kullanim_orani", type: :decimal, precision: 6, scale: 3, as: "((`rey_kullanan` / `hasta_sayisi`) * 100)", stored: true
    t.index ["donem_id"], name: "index_ulke_gecmis_veris_on_donem_id"
  end

  add_foreign_key "anlik_veris", "dktrs"
  add_foreign_key "anlik_veris", "hastanes"
  add_foreign_key "dktrs", "hastane_servisleris"
  add_foreign_key "dktrs", "hastanes"
  add_foreign_key "donemlik_basaris", "dktrs"
  add_foreign_key "donemlik_basaris", "hastanes"
  add_foreign_key "gecmis_veris", "dktrs"
  add_foreign_key "gecmis_veris", "donems"
  add_foreign_key "gecmis_veris", "hastanes"
  add_foreign_key "hasta_rey_istatistiks", "hast_as"
  add_foreign_key "hastane_gecmis_veris", "donems"
  add_foreign_key "hastane_gecmis_veris", "hastanes"
  add_foreign_key "hastanes", "ilces"
  add_foreign_key "hastanes", "ils"
  add_foreign_key "ilces", "ils"
  add_foreign_key "mail_lists", "muayenes"
  add_foreign_key "muayenes", "dktrs"
  add_foreign_key "muayenes", "donems"
  add_foreign_key "muayenes", "hast_as"
  add_foreign_key "muayenes", "hastanes"
  add_foreign_key "rey_kayitlaris", "muayenes"
  add_foreign_key "rey_skts", "muayenes"
  add_foreign_key "ulke_gecmis_veris", "donems"
end
