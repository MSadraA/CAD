	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"TestBench"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"1 us"
#	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/array_mult_8bit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Datapath.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/In_RAM.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/out_ram.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/shift_register_16bit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/shift_register_32bit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Subtractor.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/TopModule.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/up_counter_3bit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Up_Counter_4bit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/TopModule.v
	# vlog 	+acc -incr -source  +define+SIM 	$inc_path/implementation_option.vh
		
	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/uut/*	
	add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	