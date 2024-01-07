CREATE TABLE "measure_timeseries_local" (
	"id" Integer primary key autoincrement,
	"measure_id"	Integer,
	"measure_server_id"	Integer,
	"num"	Integer,
	"time"	Real,
	"wam_r_50khz"	Real,
	"wam_x_50khz"	Real,
	"ppg"	Real
);