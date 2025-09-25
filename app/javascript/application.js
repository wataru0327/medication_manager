// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "./prescription_items"

// FullCalendar を読み込み
import { Calendar } from "@fullcalendar/core"
import dayGridPlugin from "@fullcalendar/daygrid"
import interactionPlugin from "@fullcalendar/interaction"
import jaLocale from "@fullcalendar/core/locales/ja"

// グローバルに使えるように window に登録
window.FullCalendar = { Calendar, dayGridPlugin, interactionPlugin, jaLocale }

