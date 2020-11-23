// Created by Crowbar 0.68

$modelname "doom_eternal\weapons\supershotgun\supershotgun.mdl"

$bodygroup "hands1"
{
	studio "marine_LOD0.smd"
}
$bodygroup "hands2"
{
	studio "marine2_LOD0.smd"
}
$bodygroup "shotgun"
{
	studio "double_barrel_LOD0.smd"
}
$bodygroup "shotgun_barrel"
{
	studio "double_barrel_2_LOD0.smd"
}
$bodygroup "shells"
{
	studio "shells_LOD0.smd"
}
$bodygroup "meathook"
{
	studio "meathook_LOD0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0.217 -8.378 28.101

$cdmaterials "models\doom_eternal\weapons\supershotgun\"
$cdmaterials "models\doom_eternal\weapons\shells\"
$cdmaterials "models\doom_eternal\player\"
$cdmaterials ""

$attachment "muzzle_left" "defaultmod_barrel_md" 18 1 2.5 rotate 0 0 0
$attachment "muzzle_right" "defaultmod_barrel_md" 18 -1 2.5 rotate 0 0 0
$attachment "hooktip_part01_md" "hooktip_part01_md" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -7.626 -24.307 -4.551 24.382 24.74 60.752

$definebone "origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "lefthandattach" "origin" 22.288496 0 48.291744 0 0 0 0 0 0 0 0 0
$definebone "LeftHand" "lefthandattach" -7.875734 18.434181 -0.15144 -36.402815 -69.553831 -11.275325 0 0 0 0 0 0
$definebone "LeftHandThumb1" "LeftHand" 0.965834 0.74295 -0.445778 55.767747 -72.659587 -40.852031 0 0 0 0 0 0
$definebone "LeftHandThumb2" "LeftHandThumb1" 0.000004 2.005969 -0.000008 0.000171 0.000102 -20.000064 0 0 0 0 0 0
$definebone "LeftHandThumb3" "LeftHandThumb2" -0.000004 0.89154 0.000002 -0.00048 -0.00034 -8.000116 0 0 0 0 0 0
$definebone "lefthandindexroot" "LeftHand" 0.538637 1.671639 -0.000015 -0.000143 -4.999944 -0.000141 0 0 0 0 0 0
$definebone "LeftHandIndex1" "lefthandindexroot" 0.000002 2.325056 -0.000004 -0.075582 -1.101098 -39.779343 0 0 0 0 0 0
$definebone "LeftHandIndex2" "LeftHandIndex1" 0.000015 1.842497 0.000011 0.000225 0.000079 -14.99979 0 0 0 0 0 0
$definebone "LeftHandIndex3" "LeftHandIndex2" 0.000004 1.096722 -0.000008 0.00032 -0.000073 -14.999891 0 0 0 0 0 0
$definebone "lefthandmiddleroot" "LeftHand" -0.000004 1.671637 -0.000011 0.000032 2.999775 -0.000045 0 0 0 0 0 0
$definebone "LeftHandMiddle1" "lefthandmiddleroot" -0.000011 2.36893 -0.000011 -0.0001 -0.999907 -40.000098 0 0 0 0 0 0
$definebone "LeftHandMiddle2" "LeftHandMiddle1" -0.000006 1.886374 -0.000004 -0.000265 0.000343 -24.000117 0 0 0 0 0 0
$definebone "LeftHandMiddle3" "LeftHandMiddle2" 0.000008 1.140472 0 0.000241 -0.000091 -15.999942 0 0 0 0 0 0
$definebone "lefthandringroot" "LeftHand" -0.371477 1.560193 -0.000015 -0.000241 14.000182 -0.000498 0 0 0 0 0 0
$definebone "LeftHandRing1" "lefthandringroot" 0.000004 2.19345 0 -1.143616 -2.236638 -39.746414 0 0 0 0 0 0
$definebone "LeftHandRing2" "LeftHandRing1" 0.000006 1.667011 0.000008 -0.000113 -0.00012 -22.000224 0 0 0 0 0 0
$definebone "LeftHandRing3" "LeftHandRing2" -0.000004 1.096722 0.000008 -0.000212 0.000223 -14.999934 0 0 0 0 0 0
$definebone "lefthandpinkyroot" "LeftHand" -0.74295 1.374455 -0.000015 -0.000158 24.000129 -0.000427 0 0 0 0 0 0
$definebone "LeftHandPinky1" "lefthandpinkyroot" 0 1.974107 -0.000004 0.049565 -4.032209 -39.735425 0 0 0 0 0 0
$definebone "LeftHandPinky2" "LeftHandPinky1" 0 1.316065 -0.000004 -0.000131 0.00022 -20.000071 0 0 0 0 0 0
$definebone "LeftHandPinky3" "LeftHandPinky2" 0.000004 0.87738 -0.000004 -0.000053 -0.000055 -5.000083 0 0 0 0 0 0
$definebone "leftforearmroll3" "LeftHand" 0.000004 -2.377438 0.000008 0.000004 -0.000003 0.000001 0 0 0 0 0 0
$definebone "leftforearmroll2" "leftforearmroll3" 0.000004 -2.080258 0.000011 0.000022 -0.000044 -0.000006 0 0 0 0 0 0
$definebone "leftforearmroll1" "leftforearmroll2" 0.000006 -2.080257 0.000008 0.000009 0.000007 -0.000005 0 0 0 0 0 0
$definebone "LeftForeArmRoll" "leftforearmroll1" 0.000006 -2.080256 0.000011 -0.000021 0.00005 0 0 0 0 0 0 0
$definebone "LeftForeArm" "LeftForeArmRoll" 0.000002 -2.08026 0.000015 0.000011 -0.00002 0.000006 0 0 0 0 0 0
$definebone "LeftArm" "LeftForeArm" 7.34704 -7.878683 0.000076 0.000272 43.000166 0.000287 0 0 0 0 0 0
$definebone "weapon_base" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "defaultmod_barrel_md" "weapon_base" 4.590301 0.000002 -0.351 0 0 0 0 0 0 0 0 0
$definebone "hooktip_part01_md" "weapon_base" 13.712703 0.000002 -0.953064 0 0 0 0 0 0 0 0 0
$definebone "righthandattach" "origin" 22.288496 0 48.291744 0 0 0 0 0 0 0 0 0
$definebone "RightHand" "righthandattach" -7.875734 -18.434179 -0.15144 36.402658 -110.446153 168.724688 0 0 0 0 0 0
$definebone "RightHandThumb1" "RightHand" -0.965832 -0.74295 0.445774 56.093625 -71.981895 -40.290268 0 0 0 0 0 0
$definebone "RightHandThumb2" "RightHandThumb1" -0.00005 -2.005967 0.000053 -0.00021 -0.000248 -20.00016 0 0 0 0 0 0
$definebone "RightHandThumb3" "RightHandThumb2" 0.000011 -0.891537 -0.000023 -0.000205 -0.000111 -8.000088 0 0 0 0 0 0
$definebone "righthandindexroot" "RightHand" -0.538607 -1.67168 0.000004 -0.000112 -4.999945 -0.00013 0 0 0 0 0 0
$definebone "RightHandIndex1" "righthandindexroot" 0 -2.325011 -0.000038 -0.075655 -1.101191 -39.779373 0 0 0 0 0 0
$definebone "RightHandIndex2" "RightHandIndex1" 0.000034 -1.842539 0.000011 -0.000188 0.000212 -15.000081 0 0 0 0 0 0
$definebone "RightHandIndex3" "RightHandIndex2" -0.000069 -1.096746 0 0.000795 -0.00017 -14.999608 0 0 0 0 0 0
$definebone "righthandmiddleroot" "RightHand" 0.00004 -1.671639 -0.00005 0.000035 2.999777 -0.000047 0 0 0 0 0 0
$definebone "RightHandMiddle1" "righthandmiddleroot" 0.000048 -2.368912 0.000042 -0.000236 -0.999915 -40.000132 0 0 0 0 0 0
$definebone "RightHandMiddle2" "RightHandMiddle1" -0.000063 -1.886425 0.000004 -0.000302 0.000351 -24.000141 0 0 0 0 0 0
$definebone "RightHandMiddle3" "RightHandMiddle2" 0.000048 -1.140427 0.000015 0.000413 -0.000152 -15.999875 0 0 0 0 0 0
$definebone "righthandringroot" "RightHand" 0.371548 -1.560202 -0.000004 -0.000255 14.000198 -0.000528 0 0 0 0 0 0
$definebone "RightHandRing1" "righthandringroot" -0.000048 -2.19344 0.000027 -1.143248 -2.237089 -39.746452 0 0 0 0 0 0
$definebone "RightHandRing2" "RightHandRing1" 0.000021 -1.667009 -0.000023 -0.000746 -0.000147 -22.000195 0 0 0 0 0 0
$definebone "RightHandRing3" "RightHandRing2" -0.000034 -1.096733 -0.000011 -0.000072 0.000159 -14.999917 0 0 0 0 0 0
$definebone "righthandpinkyroot" "RightHand" 0.742964 -1.374479 -0.000042 -0.000182 24.000149 -0.000474 0 0 0 0 0 0
$definebone "RightHandPinky1" "righthandpinkyroot" -0.000008 -1.974101 0.000008 0.049514 -4.032302 -39.735466 0 0 0 0 0 0
$definebone "RightHandPinky2" "RightHandPinky1" 0.000025 -1.31609 0.000004 -0.000205 0.000227 -20.00001 0 0 0 0 0 0
$definebone "RightHandPinky3" "RightHandPinky2" -0.000004 -0.877369 0.000055 0.000005 -0.000084 -5.00011 0 0 0 0 0 0
$definebone "rightforearmroll3" "RightHand" 0.000019 2.377439 0.000008 -0.000085 0 0 0 0 0 0 0 0
$definebone "rightforearmroll2" "rightforearmroll3" -0.000004 2.080262 -0.000011 -0.000066 -0.000009 -0.000004 0 0 0 0 0 0
$definebone "rightforearmroll1" "rightforearmroll2" -0.000013 2.08026 -0.000008 -0.000109 -0.000003 0.000001 0 0 0 0 0 0
$definebone "RightForeArmRoll" "rightforearmroll1" -0.00001 2.080257 -0.000015 -0.000123 -0.000014 0.000002 0 0 0 0 0 0
$definebone "RightForeArm" "RightForeArmRoll" -0.000038 2.080258 -0.000046 -0.000267 -0.000005 0.000008 0 0 0 0 0 0
$definebone "RightArm" "RightForeArm" -7.346998 7.878686 -0.000008 0.000372 42.999869 0.00067 0 0 0 0 0 0
$definebone "defaultmod_grip_md" "weapon_base" 4.590301 0.000002 -0.351 0 0 0 0 0 0 0 0 0
$definebone "defaultmod_lever_md" "defaultmod_grip_md" -6.162398 -0.000002 2.89841 -13.600017 0 0 0 0 0 0 0 0
$definebone "defaultmod_ejector_md" "defaultmod_barrel_md" -1.784316 0 1.900359 0 0 0 0 0 0 0 0 0
$definebone "defaultmod_leftshell_md" "defaultmod_barrel_md" -1.577046 1.031867 2.421292 0 0 0 0 0 0 0 0 0
$definebone "defaultmod_leftshell_md_spent" "defaultmod_barrel_md" -1.577046 1.031867 2.421292 0 0 0 0 0 0 0 0 0
$definebone "defaultmod_rightshell_md" "defaultmod_barrel_md" -1.577046 -1.03187 2.421292 0 0 0 0 0 0 0 0 0
$definebone "defaultmod_rightshell_md_spent" "defaultmod_barrel_md" -1.577046 -1.03187 2.421292 0 0 0 0 0 0 0 0 0
$definebone "hookcog_coglatch_md" "defaultmod_grip_md" -5.788826 -0.00009 3.126382 0 0 0 0 0 0 0 0 0
$definebone "hookcog_cog_md" "defaultmod_grip_md" -4.147793 0 2.112881 0 0 0 0 0 0 0 0 0
$definebone "hookcog_slider_md" "defaultmod_barrel_md" 14.127916 0 3.092144 0 0 0 0 0 0 0 0 0
$definebone "hookbase_part01_md" "weapon_base" 11.356549 0.000002 -1.047372 0 0 0 0 0 0 0 0 0
$definebone "hooktip_hooktipleft_md" "hooktip_part01_md" 1.225849 1.994671 0.474444 0 0 0 0 0 0 0 0 0
$definebone "hooktip_hooktipright_md" "hooktip_part01_md" 1.225848 -1.994674 0.474444 0 0 0 0 0 0 0 0 0


$sectionframes 30 174

$weightlist "weights_meathook_into_layer" {
	 "origin" 0
	 "lefthandattach" 0
	 "LeftHand" 0
	 "LeftHandThumb1" 0
	 "LeftHandThumb2" 0
	 "LeftHandThumb3" 0
	 "lefthandindexroot" 0
	 "LeftHandIndex1" 0
	 "LeftHandIndex2" 0
	 "LeftHandIndex3" 0
	 "lefthandmiddleroot" 0
	 "LeftHandMiddle1" 0
	 "LeftHandMiddle2" 0
	 "LeftHandMiddle3" 0
	 "lefthandringroot" 0
	 "LeftHandRing1" 0
	 "LeftHandRing2" 0
	 "LeftHandRing3" 0
	 "lefthandpinkyroot" 0
	 "LeftHandPinky1" 0
	 "LeftHandPinky2" 0
	 "LeftHandPinky3" 0
	 "leftforearmroll3" 0
	 "leftforearmroll2" 0
	 "leftforearmroll1" 0
	 "LeftForeArmRoll" 0
	 "LeftForeArm" 0
	 "LeftArm" 0
	 "weapon_base" 0
	 "defaultmod_barrel_md" 0
	 "hooktip_part01_md" 1
	 "righthandattach" 0
	 "RightHand" 0
	 "RightHandThumb1" 0
	 "RightHandThumb2" 0
	 "RightHandThumb3" 0
	 "righthandindexroot" 0
	 "RightHandIndex1" 0
	 "RightHandIndex2" 0
	 "RightHandIndex3" 0
	 "righthandmiddleroot" 0
	 "RightHandMiddle1" 0
	 "RightHandMiddle2" 0
	 "RightHandMiddle3" 0
	 "righthandringroot" 0
	 "RightHandRing1" 0
	 "RightHandRing2" 0
	 "RightHandRing3" 0
	 "righthandpinkyroot" 0
	 "RightHandPinky1" 0
	 "RightHandPinky2" 0
	 "RightHandPinky3" 0
	 "rightforearmroll3" 0
	 "rightforearmroll2" 0
	 "rightforearmroll1" 0
	 "RightForeArmRoll" 0
	 "RightForeArm" 0
	 "RightArm" 0
	 "defaultmod_grip_md" 0
	 "defaultmod_lever_md" 0
	 "defaultmod_ejector_md" 0
	 "defaultmod_leftshell_md" 0
	 "defaultmod_leftshell_md_spent" 0
	 "defaultmod_rightshell_md" 0
	 "defaultmod_rightshell_md_spent" 0
	 "hookcog_coglatch_md" 0
	 "hookcog_cog_md" 0
	 "hookcog_slider_md" 0
	 "hookbase_part01_md" 0
	 "hooktip_hooktipleft_md" 1
	 "hooktip_hooktipright_md" 1
}

$animation "intro_a_corrective_animation" "supershotgun_anims\intro_a_corrective_animation.smd" {
}

$animation "shoot_reload_a_corrective_animation" "supershotgun_anims\shoot_reload_a_corrective_animation.smd" {
}

$animation "meathook_into_a_corrective_animation" "supershotgun_anims\meathook_into_a_corrective_animation.smd" {
}

$animation "meathook_out_a_corrective_animation" "supershotgun_anims\meathook_out_a_corrective_animation.smd" {
}

$animation "ref_a" "supershotgun_anims\ref_a.smd" {
	fps 30
}

$animation "intro_a" "supershotgun_anims\intro_a.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "intro_a_corrective_animation" 0
}

$animation "shoot_reload_a" "supershotgun_anims\shoot_reload_a.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "shoot_reload_a_corrective_animation" 0
}

$animation "meathook_into_a" "supershotgun_anims\meathook_into_a.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "meathook_into_a_corrective_animation" 0
	weightlist "weights_meathook_into_layer"
}

$animation "meathook_out_a" "supershotgun_anims\meathook_out_a.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "meathook_out_a_corrective_animation" 0
	weightlist "weights_meathook_into_layer"
}

$sequence "ref" {
	"supershotgun_anims\ref.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "bringup" {
	"supershotgun_anims\bringup.smd"
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
	"supershotgun_anims\intro.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "intro_layer"
	fps 30
}

$sequence "shoot" {
	"supershotgun_anims\shoot.smd"
	fadein 0.2
	fadeout 0.2
	snap
	fps 30
}

$sequence "shootsingle" {
	"supershotgun_anims\shootsingle.smd"
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
	"supershotgun_anims\shoot_reload.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "shoot_reload_layer"
	fps 30
}

$sequence "shoot_reload_out" {
	"supershotgun_anims\shoot_reload_out.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "meathook_into_layer" {
	"meathook_into_a"
	delta
	fadein 0.2
	fadeout 0.2
	snap
}

$sequence "meathook_into" {
	"supershotgun_anims\meathook_into.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "meathook_into_layer"
	snap
	fps 30
}

$sequence "meathook_out_layer" {
	"meathook_out_a"
	delta
	fadein 0.2
	fadeout 0.2
	snap
}

$sequence "meathook_out" {
	"supershotgun_anims\meathook_out.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "meathook_out_layer"
	fps 30
}
