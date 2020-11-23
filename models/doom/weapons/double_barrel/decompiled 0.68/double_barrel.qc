// Created by Crowbar 0.68

$modelname "doom\weapons\double_barrel\double_barrel.mdl"

$bodygroup "hands"
{
	studio "praetor.smd"
}
$bodygroup "shotgun"
{
	studio "double_barrel.smd"
}
$bodygroup "shell1"
{
	studio "shell1.smd"
}
$bodygroup "shell2"
{
	studio "shell2.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0 "camera"

$cdmaterials "{\"
$cdmaterials "models\doom\weapons\double_barrel\"
$cdmaterials ",\"
$cdmaterials "models\doom\weapons\shells\"
$cdmaterials ",\"
$cdmaterials "models\doom\player\praetor\"
$cdmaterials "}\"
$cdmaterials ""

$attachment "muzzle_left" "hinge" 24 0.7 2 rotate 0 0 0
$attachment "muzzle_right" "hinge" 24 -0.7 2 rotate 0 0 0
$attachment "camera" "camera" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -19.388 -28.759 -82.682 17.862 28.759 -0.149

$definebone "origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "camera" "origin" 11.672172 0 77.351295 0 0 0 0 0 0 0 0 0
$definebone "rightarm" "" -1.677544 -10.659462 69.106674 19.069033 -155.492398 146.630242 0 0 0 0 0 0
$definebone "rightforearm" "rightarm" -0.000126 -13.432232 -0.000286 0.000649 -43.000579 0.001569 0 0 0 0 0 0
$definebone "rightforearmroll" "rightforearm" 0.000048 -2.593814 0.000095 0.000278 -0.00005 -0.00015 0 0 0 0 0 0
$definebone "RightForeArmRoll1" "rightforearmroll" 0.000021 -2.593814 0.000042 0.000099 0.000294 -0.001538 0 0 0 0 0 0
$definebone "RightForeArmRoll2" "RightForeArmRoll1" 0.000004 -2.593816 -0.000031 0.000134 0.000321 0.000221 0 0 0 0 0 0
$definebone "RightForeArmRoll3" "RightForeArmRoll2" -0.000025 -2.593815 -0.000011 0.00008 0.000309 0.000211 0 0 0 0 0 0
$definebone "righthand" "RightForeArmRoll3" -0.000063 -2.964362 -0.000027 0.000061 -0.001559 0.000659 0 0 0 0 0 0
$definebone "righthandthumb1" "righthand" -1.204258 -0.926373 0.555836 55.767193 -72.659634 -40.852393 0 0 0 0 0 0
$definebone "righthandthumb2" "righthandthumb1" -0.000034 -2.501179 0.000072 0.000123 0.001064 -20.000988 0 0 0 0 0 0
$definebone "righthandthumb3" "righthandthumb2" 0.000019 -1.111628 -0.000038 -0.000092 -0.000878 -8.000577 0 0 0 0 0 0
$definebone "righthandindexroot" "righthand" -0.671543 -2.084377 0.000031 -0.000477 -4.998735 -0.000845 0 0 0 0 0 0
$definebone "righthandindex1" "righthandindexroot" -0.000034 -2.898994 -0.000076 -0.074518 -1.10231 -39.779435 0 0 0 0 0 0
$definebone "righthandindex2" "righthandindex1" 0.000051 -2.297398 0 -0.000993 -0.000107 -14.999396 0 0 0 0 0 0
$definebone "righthandindex3" "righthandindex2" -0.000078 -1.367512 0.000008 0.000206 0.000885 -15.000031 0 0 0 0 0 0
$definebone "righthandmiddleroot" "righthand" 0.000072 -2.084318 -0.000038 -0.000546 3.000625 -0.000745 0 0 0 0 0 0
$definebone "righthandmiddle1" "righthandmiddleroot" 0.000059 -2.953729 0.000031 0.000101 -0.999423 -39.999773 0 0 0 0 0 0
$definebone "righthandmiddle2" "righthandmiddle1" -0.000071 -2.352119 -0.000004 0.001011 0.000777 -24.000219 0 0 0 0 0 0
$definebone "righthandmiddle3" "righthandmiddle2" 0.000044 -1.421963 0.000015 0.000476 -0.000852 -15.999903 0 0 0 0 0 0
$definebone "righthandringroot" "righthand" 0.463287 -1.945367 -0.000004 -0.000423 14.001325 -0.00103 0 0 0 0 0 0
$definebone "righthandring1" "righthandringroot" -0.00008 -2.734946 0.000019 -1.142514 -2.238111 -39.745291 0 0 0 0 0 0
$definebone "righthandring2" "righthandring1" 0.000059 -2.078558 0 -0.001395 0.001429 -22.001262 0 0 0 0 0 0
$definebone "righthandring3" "righthandring2" -0.000071 -1.367489 -0.000019 0.000036 -0.000268 -14.999705 0 0 0 0 0 0
$definebone "righthandpinkyroot" "righthand" 0.926405 -1.713789 -0.000061 -0.000053 24.001063 -0.00068 0 0 0 0 0 0
$definebone "righthandpinky1" "righthandpinkyroot" -0.000015 -2.461454 0.000011 0.049604 -4.032162 -39.735063 0 0 0 0 0 0
$definebone "righthandpinky2" "righthandpinky1" 0.000027 -1.641005 0.000015 -0.000312 0.001025 -20.000338 0 0 0 0 0 0
$definebone "righthandpinky3" "righthandpinky2" -0.000023 -1.093956 0.000065 0.000495 -0.001274 -5.000051 0 0 0 0 0 0
$definebone "leftarm" "" -1.677539 10.659451 69.106644 -19.068408 -24.508491 -33.36793 0 0 0 0 0 0
$definebone "leftforearm" "leftarm" 0.000013 13.432259 -0.000046 -0.000878 -42.9999 -0.000524 0 0 0 0 0 0
$definebone "leftforearmroll" "leftforearm" 0.000008 2.593815 0.000019 0.000303 -0.000688 0.001302 0 0 0 0 0 0
$definebone "LeftForeArmRoll1" "leftforearmroll" -0.000013 2.593815 -0.000034 0 0.00061 -0.001316 0 0 0 0 0 0
$definebone "LeftForeArmRoll2" "LeftForeArmRoll1" 0.000006 2.593816 0.000034 -0.000014 0.000017 0.000012 0 0 0 0 0 0
$definebone "LeftForeArmRoll3" "LeftForeArmRoll2" 0.000013 2.593814 0.000027 0.000033 0.000266 0.000208 0 0 0 0 0 0
$definebone "lefthand" "LeftForeArmRoll3" 0.000019 2.964362 0 -0.000056 -0.000832 0.001105 0 0 0 0 0 0
$definebone "lefthandthumb1" "lefthand" 1.204262 0.926372 -0.555847 55.767357 -72.659532 -40.852393 0 0 0 0 0 0
$definebone "lefthandthumb2" "lefthandthumb1" 0.000004 2.501184 -0.000011 -0.000487 0.000225 -20.000279 0 0 0 0 0 0
$definebone "lefthandthumb3" "lefthandthumb2" 0 1.111629 0.000015 0.001681 0.000287 -7.999884 0 0 0 0 0 0
$definebone "lefthandindexroot" "lefthand" 0.6716 2.084322 -0.000034 -0.000402 -4.999125 -0.001079 0 0 0 0 0 0
$definebone "lefthandindex1" "lefthandindexroot" 0.000023 2.899046 0.000011 -0.075164 -1.102791 -39.777618 0 0 0 0 0 0
$definebone "lefthandindex2" "lefthandindex1" -0.000034 2.29735 -0.000057 0.000043 0.001057 -15.00061 0 0 0 0 0 0
$definebone "lefthandindex3" "lefthandindex2" 0.000002 1.367477 -0.000023 -0.000408 0.00017 -15.0011 0 0 0 0 0 0
$definebone "lefthandmiddleroot" "lefthand" -0.000021 2.084317 -0.000038 -0.000534 3.000902 -0.000516 0 0 0 0 0 0
$definebone "lefthandmiddle1" "lefthandmiddleroot" 0.000025 2.953743 -0.000004 0.000878 -1.000088 -40.000166 0 0 0 0 0 0
$definebone "lefthandmiddle2" "lefthandmiddle1" 0.000008 2.352057 -0.000011 0.000244 -0.000462 -23.9997 0 0 0 0 0 0
$definebone "lefthandmiddle3" "lefthandmiddle2" 0 1.42202 -0.000008 -0.000705 -0.000042 -16.000311 0 0 0 0 0 0
$definebone "lefthandringroot" "lefthand" -0.4632 1.945359 -0.000027 -0.000383 14.000955 -0.001209 0 0 0 0 0 0
$definebone "lefthandring1" "lefthandringroot" 0.000011 2.734952 0.000023 -1.143952 -2.237521 -39.745147 0 0 0 0 0 0
$definebone "lefthandring2" "lefthandring1" -0.000034 2.078569 -0.000031 -0.000253 0.000898 -22.001236 0 0 0 0 0 0
$definebone "lefthandring3" "lefthandring2" -0.000008 1.367466 0 0.000406 0.000677 -14.999599 0 0 0 0 0 0
$definebone "lefthandpinkyroot" "lefthand" -0.926374 1.713765 -0.000027 -0.00002 24.000004 0.000502 0 0 0 0 0 0
$definebone "lefthandpinky1" "lefthandpinkyroot" -0.000017 2.461452 -0.000031 0.050367 -4.030248 -39.736535 0 0 0 0 0 0
$definebone "lefthandpinky2" "lefthandpinky1" 0.000032 1.640984 -0.000004 0.000077 -0.001171 -19.999637 0 0 0 0 0 0
$definebone "lefthandpinky3" "lefthandpinky2" -0.000002 1.093979 -0.000004 0.000277 0.000277 -5.000146 0 0 0 0 0 0
$definebone "gunroot" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "base" "gunroot" -4.953621 0 -1.539214 0 0 0 0 0 0 0 0 0
$definebone "hinge" "base" 10.605598 0 1.744792 0 0 0 0 0 0 0 0 0
$definebone "buckle" "hinge" 15.484079 0 -0.334376 0 0 0 0 0 0 0 0 0
$definebone "handle" "base" 4.953621 0 1.539214 0 0 0 0 0 0 0 0 0
$definebone "trigger" "handle" -2.539417 0 -0.256252 0 0 0 0 0 0 0 0 0
$definebone "release" "handle" -2.430163 0 2.947667 -10.800023 0 0 0 0 0 0 0 0
$definebone "shellspent1" "handle" -0.581305 0 1.342401 0 0 0 0 0 0 0 0 0
$definebone "shellspent2" "handle" -0.581305 0 1.342401 0 0 0 0 0 0 0 0 0
$definebone "shell1" "handle" -0.581305 0 1.342401 0 0 0 0 0 0 0 0 0
$definebone "shell2" "handle" 0 0 0 0 0 0 0 0 0 0 0 0


$sectionframes 30 235

$animation "intro_a_corrective_animation" "double_barrel_anims\intro_a_corrective_animation.smd" {
}

$animation "shoot_reload_a_corrective_animation" "double_barrel_anims\shoot_reload_a_corrective_animation.smd" {
}

$animation "ref_a" "double_barrel_anims\ref_a.smd" {
	fps 30
}

$animation "intro_a" "double_barrel_anims\intro_a.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "intro_a_corrective_animation" 0
}

$animation "shoot_reload_a" "double_barrel_anims\shoot_reload_a.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "shoot_reload_a_corrective_animation" 0
}

$sequence "ref" {
	"double_barrel_anims\ref.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "bringup" {
	"double_barrel_anims\bringup.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "intro_layer" {
	"intro_a"
	delta
	fadein 0.2
	fadeout 0.2
}

$sequence "intro" {
	"double_barrel_anims\intro.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "intro_layer"
	fps 30
}

$sequence "shoot" {
	"double_barrel_anims\shoot.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "shootsingle" {
	"double_barrel_anims\shootsingle.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "shoot_reload_layer" {
	"shoot_reload_a"
	delta
	fadein 0.2
	fadeout 0.2
}

$sequence "shoot_reload" {
	"double_barrel_anims\shoot_reload.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "shoot_reload_layer"
	fps 30
}

$sequence "shoot_reload_out" {
	"double_barrel_anims\shoot_reload_out.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "melee_1" {
	"double_barrel_anims\melee_1.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}
