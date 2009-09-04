<?php


// whitelisted ips
$any = array("*");

$productionMachine = array("123.45.67.000");

$developerMachines = array(
	"123.45.67.001",
	"123.45.67.002",
	"123.45.67.003",
	"123.45.67.004",
	"123.45.67.005"
);

// whitelisted game ids and the ips that have write access to them
$whitelist = array(
	"test1" => $any,
	"test2" => $any,

	"newGame001" => $developerMachines,
	"newGame002" => $developerMachines,
	"newGame003" => $developerMachines,

	"stableGame001" => $productionMachine,
	"stableGame002" => $productionMachine,
	"stableGame003" => $productionMachine,
	"stableGame004" => $productionMachine,
	"stableGame005" => $productionMachine,
);


?>