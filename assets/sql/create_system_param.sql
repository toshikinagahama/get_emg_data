CREATE TABLE "m_system_param" (
	"param_name"	TEXT NOT NULL UNIQUE,
	"param_value"	TEXT,
	PRIMARY KEY("param_name")
);