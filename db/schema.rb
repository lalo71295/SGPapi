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

ActiveRecord::Schema.define(version: 2018_04_06_223301) do

  create_table "Usuarios", primary_key: "idUsuarios", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nombreUser", limit: 50
    t.string "apellidos", limit: 100
    t.string "password", limit: 20
    t.integer "tipo", null: false
  end

  create_table "cities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "nombre"
    t.string "abreviacion"
    t.integer "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classifications", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "nombre"
    t.string "logo"
    t.text "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "concepts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.integer "tipo"
    t.integer "clasificacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status"
    t.index ["clasificacion"], name: "fk_rails_b3b1cf3b3b"
  end

  create_table "configs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "clave"
    t.string "parametro"
    t.text "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contracts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.integer "tipo_contrato"
    t.date "fecha_inicio"
    t.date "fecha_fin"
    t.integer "estado"
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "costs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.date "fecha"
    t.decimal "monto", precision: 10
    t.integer "project_id"
    t.integer "concept_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "facturado"
    t.boolean "facturable"
    t.boolean "rembolsable"
    t.boolean "rembolsado"
    t.date "fecha_rembolso"
    t.boolean "prorrateable"
    t.integer "status"
    t.integer "usuult"
    t.integer "employees_id"
    t.integer "invoices_gots_id"
    t.index ["employees_id"], name: "index_costs_on_employees_id"
    t.index ["invoices_gots_id"], name: "index_costs_on_invoices_gots_id"
  end

  create_table "costs_employees", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "costs_id"
    t.integer "employees_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["costs_id"], name: "index_costs_employees_on_costs_id"
    t.index ["employees_id"], name: "index_costs_employees_on_employees_id"
  end

  create_table "departments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "nombre"
    t.string "apellido_paterno"
    t.string "apellido_materno"
    t.date "fecha_nacimiento"
    t.text "direccion"
    t.string "telefono"
    t.string "celular"
    t.string "email_personal"
    t.string "carrera"
    t.date "fecha_ingreso"
    t.date "fecha_egreso"
    t.decimal "costoxhora", precision: 10
    t.string "foto"
    t.integer "city_id"
    t.integer "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status"
    t.string "cover_file_name"
    t.string "cover_content_type"
    t.integer "cover_file_size"
    t.datetime "cover_updated_at"
  end

  create_table "employees_projects_rols", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "employee_id"
    t.integer "projects_rol_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employees_projects_rols_on_employee_id"
    t.index ["projects_rol_id"], name: "index_employees_projects_rols_on_projects_rol_id"
  end

  create_table "employees_rols", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "employee_id"
    t.integer "rol_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "periods_projects_employee_id"
    t.integer "concept_id"
    t.date "fecha"
    t.decimal "monto", precision: 10
    t.string "comentarios"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "expenses_header_id"
    t.integer "project_id"
    t.boolean "prorrateable"
    t.boolean "facturable"
    t.boolean "rembolsado"
    t.date "fecha_rembolso"
    t.integer "usuult"
    t.integer "invoices_gots_id"
    t.boolean "rembolsable"
    t.integer "refund_id"
    t.string "referencia"
    t.datetime "fecha_cobro"
    t.index ["concept_id"], name: "index_expenses_on_concept_id"
    t.index ["expenses_header_id"], name: "index_expenses_on_expenses_header_id"
    t.index ["invoices_gots_id"], name: "index_expenses_on_invoices_gots_id"
    t.index ["periods_projects_employee_id"], name: "index_expenses_on_periods_projects_employee_id"
    t.index ["project_id"], name: "index_expenses_on_project_id"
    t.index ["refund_id"], name: "index_expenses_on_refund_id"
  end

  create_table "expenses_attachments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "expense_id"
    t.string "archivo"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "archivo_file_name"
    t.string "archivo_content_type"
    t.integer "archivo_file_size"
    t.datetime "archivo_updated_at"
    t.integer "tipo"
    t.index ["expense_id"], name: "index_expenses_attachments_on_expense_id"
  end

  create_table "expenses_employees", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "expense_id"
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_expenses_employees_on_employees_id"
    t.index ["expense_id"], name: "index_expenses_employees_on_expenses_id"
  end

  create_table "expenses_employees_generals", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "expenses_general_id"
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_expenses_employees_generals_on_employees_id"
    t.index ["expenses_general_id"], name: "index_expenses_employees_generals_on_expenses_id"
  end

  create_table "expenses_generals", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "periods_projects_employee_id"
    t.integer "invoices_gots_id"
    t.integer "refund_id"
    t.integer "concept_id"
    t.integer "project_id"
    t.integer "period_id"
    t.date "fecha"
    t.decimal "monto", precision: 10
    t.string "comentarios"
    t.boolean "prorrateable"
    t.boolean "facturable"
    t.boolean "rembolsable"
    t.boolean "rembolsado"
    t.date "fecha_rembolso"
    t.integer "status"
    t.text "comentarios_header"
    t.datetime "fecha_autorizacion"
    t.integer "usuario_autorizo"
    t.datetime "updated_at", null: false
    t.integer "usuult"
    t.datetime "created_at", null: false
    t.index ["concept_id"], name: "index_expenses_generals_on_concept_id"
    t.index ["invoices_gots_id"], name: "index_expenses_generals_on_invoices_gots_id"
    t.index ["period_id"], name: "index_expenses_generals_on_period_id"
    t.index ["periods_projects_employee_id"], name: "index_expenses_generals_on_periods_projects_employee_id"
    t.index ["project_id"], name: "index_expenses_generals_on_project_id"
    t.index ["refund_id"], name: "index_expenses_generals_on_refund_id"
  end

  create_table "expenses_generals_attachments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "expenses_general_id"
    t.string "archivo"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "archivo_file_name"
    t.string "archivo_content_type"
    t.integer "archivo_file_size"
    t.datetime "archivo_updated_at"
    t.integer "tipo"
    t.index ["expenses_general_id"], name: "index_expenses_generals_attachments_on_expenses_general_id"
  end

  create_table "expenses_headers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "period_id"
    t.integer "employee_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comentarios"
    t.datetime "fecha_autorizacion"
    t.integer "usuario_autorizo"
    t.integer "usuult"
    t.boolean "administrativo", default: false
    t.index ["employee_id"], name: "index_expenses_headers_on_employee_id"
    t.index ["period_id"], name: "index_expenses_headers_on_period_id"
  end

  create_table "expenses_references", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "expense_id"
    t.integer "reference_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_expenses_references_on_expense_id"
    t.index ["reference_id"], name: "index_expenses_references_on_reference_id"
  end

  create_table "hours", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.date "fecha"
    t.integer "horas"
    t.integer "periods_projects_employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.index ["periods_projects_employee_id"], name: "index_hours_on_periods_projects_employee_id"
    t.index ["project_id"], name: "index_hours_on_project_id"
  end

  create_table "hours_detail", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "id_header", null: false
    t.integer "id_proyecto", null: false
    t.date "fecha", null: false
    t.integer "horas", null: false
    t.boolean "facturable", null: false
  end

  create_table "hours_header", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "period_id", null: false
    t.integer "total_horas", null: false
    t.string "status", limit: 50, null: false, collation: "utf8_spanish_ci"
    t.text "comentarios"
    t.index ["employee_id"], name: "fk_rails_ddb669d1ef"
  end

  create_table "incomes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "fecha"
    t.string "monto"
    t.integer "concept_id"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices_gots", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "folio", limit: 30
    t.string "serie", limit: 30
    t.datetime "fecha"
    t.string "forma_de_pago", limit: 60
    t.string "condiciones_de_pago"
    t.string "no_certificado", limit: 20
    t.decimal "subtotal", precision: 11, scale: 2, null: false
    t.decimal "total", precision: 11, scale: 2, null: false
    t.string "moneda", limit: 20, default: ""
    t.string "metodo_de_pago", limit: 30
    t.string "tipo_de_comprobante", limit: 30
    t.string "num_cta_pago", limit: 20
    t.string "emisor_rfc", limit: 13, null: false
    t.string "emisor_razon_social", null: false
    t.text "emisor_datos"
    t.string "receptor_rfc", limit: 13, null: false
    t.string "receptor_razon_social", null: false
    t.text "receptor_datos"
    t.text "conceptos", null: false
    t.decimal "total_impuestos_trasladados", precision: 11, scale: 2
    t.decimal "total_impuestos_retenidos", precision: 11, scale: 2
    t.text "impuestos"
    t.text "sello_cfd"
    t.datetime "fecha_timbrado"
    t.string "uuid", limit: 36
    t.string "no_certificado_sat", limit: 20
    t.text "sello_sat"
    t.integer "status"
    t.text "xml"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "archivoxml_file_name"
    t.string "archivoxml_content_type"
    t.integer "archivoxml_file_size"
    t.datetime "archivoxml_updated_at"
    t.decimal "descuento", precision: 10
    t.string "texto_validacion"
    t.string "pdf"
    t.integer "status_sat"
  end

  create_table "milestones", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.date "fecha"
    t.integer "orden"
    t.string "nombre"
    t.text "descripcion"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "periods", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "anio"
    t.date "fecha_inicio"
    t.date "fecha_fin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "especial", default: false
    t.boolean "bloqueado", default: false
    t.integer "semana"
  end

  create_table "periods_projects_employees", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "employee_id"
    t.integer "period_id"
    t.integer "status"
    t.string "notas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_periods_projects_employees_on_employee_id"
    t.index ["period_id"], name: "index_periods_projects_employees_on_period_id"
  end

  create_table "permissions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "controlador"
    t.string "accion"
    t.text "descripcion"
    t.integer "padre"
    t.integer "orden"
    t.string "menu_alias"
    t.string "menu_categoria"
    t.string "ruta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "clave"
    t.string "nombre"
    t.text "descripcion"
    t.date "fecha_inicio"
    t.date "fecha_fin"
    t.integer "company_id"
    t.decimal "presupuesto_ingresos", precision: 10
    t.decimal "presupuesto_egresos", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.integer "tasks_count", default: 0
  end

  create_table "projects_rols", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "project_id"
    t.integer "rol_id"
    t.integer "horas_presupuestadas"
    t.decimal "costo_hora", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "references", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "folio"
    t.datetime "fecha"
    t.decimal "monto", precision: 10
    t.decimal "iva", precision: 10
    t.decimal "total", precision: 10
    t.boolean "pagado"
  end

  create_table "refunds", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.date "fecha"
    t.integer "forma_de_pago"
    t.integer "cuenta_origen"
    t.string "cuenta_destino"
    t.string "archivo"
    t.integer "usuult"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "monto", precision: 10
    t.integer "employee_id"
    t.string "archivo_file_name"
    t.string "archivo_content_type"
    t.integer "archivo_file_size"
    t.datetime "archivo_updated_at"
    t.index ["employee_id"], name: "index_refunds_on_employee_id"
  end

  create_table "rols", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.string "funciones"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rols_permissions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "rol_id"
    t.integer "permission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_rols_permissions_on_permission_id"
    t.index ["rol_id"], name: "index_rols_permissions_on_rol_id"
  end

  create_table "sessions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data", limit: 4294967295
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "states", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "nombre"
    t.string "abreviacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_durations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "minutos"
    t.datetime "fecha"
    t.integer "employee_id"
    t.integer "task_id"
    t.text "retro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_task_durations_on_employee_id"
    t.index ["task_id"], name: "index_task_durations_on_task_id"
  end

  create_table "tasks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "asunto"
    t.text "descripcion"
    t.datetime "fecha"
    t.integer "status"
    t.integer "prioridad"
    t.string "folio_alterno"
    t.integer "classification_id"
    t.integer "project_id"
    t.integer "asignador_id"
    t.integer "tarea_padre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "fecha_compromiso"
    t.text "motivo_cancelacion"
    t.integer "usuario_cancelacion"
    t.text "notas"
    t.index ["classification_id"], name: "index_tasks_on_classification_id"
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "tasks_employees", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "task_id"
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["employee_id"], name: "index_tasks_employees_on_employee_id"
    t.index ["task_id"], name: "index_tasks_employees_on_task_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "employee_id"
    t.boolean "approved", default: false, null: false
    t.integer "role"
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_id"], name: "index_users_on_employee_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "users_rols", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci", force: :cascade do |t|
    t.integer "user_id"
    t.integer "rol_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rol_id"], name: "index_users_rols_on_rol_id"
    t.index ["user_id"], name: "index_users_rols_on_user_id"
  end

  add_foreign_key "concepts", "classifications", column: "clasificacion"
  add_foreign_key "costs", "employees", column: "employees_id"
  add_foreign_key "costs", "invoices_gots", column: "invoices_gots_id"
  add_foreign_key "costs_employees", "costs", column: "costs_id"
  add_foreign_key "costs_employees", "employees", column: "employees_id"
  add_foreign_key "employees_projects_rols", "employees"
  add_foreign_key "employees_projects_rols", "projects_rols"
  add_foreign_key "expenses", "concepts"
  add_foreign_key "expenses", "expenses_headers"
  add_foreign_key "expenses", "invoices_gots", column: "invoices_gots_id"
  add_foreign_key "expenses", "periods_projects_employees"
  add_foreign_key "expenses", "projects"
  add_foreign_key "expenses", "refunds"
  add_foreign_key "expenses_attachments", "expenses"
  add_foreign_key "expenses_employees", "employees"
  add_foreign_key "expenses_employees", "expenses"
  add_foreign_key "expenses_headers", "employees"
  add_foreign_key "expenses_headers", "periods"
  add_foreign_key "expenses_references", "expenses"
  add_foreign_key "expenses_references", "references"
  add_foreign_key "hours", "periods_projects_employees"
  add_foreign_key "hours", "projects"
  add_foreign_key "periods_projects_employees", "employees"
  add_foreign_key "periods_projects_employees", "periods"
  add_foreign_key "refunds", "employees"
  add_foreign_key "rols_permissions", "permissions"
  add_foreign_key "rols_permissions", "rols"
  add_foreign_key "task_durations", "employees"
  add_foreign_key "task_durations", "tasks"
  add_foreign_key "tasks", "classifications"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks_employees", "employees"
  add_foreign_key "tasks_employees", "tasks"
  add_foreign_key "users", "employees"
  add_foreign_key "users_rols", "rols"
  add_foreign_key "users_rols", "users"
end
