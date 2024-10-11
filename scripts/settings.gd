extends Node2D

func _ready():
	pass
	
var settings = {
	"worlds": {
		"world_1": {
			"num": 1,
			"name": "MISSION BEGGINS",
			"num_abilities": 1,
		},
		"world_2": {
			"num": 2,
			"name": "SIGN OF HOPE",
			"num_abilities": 1,
		},
		"world_3": {
			"num": 3,
			"name": "REACTION",
			"num_abilities": 1,
		},
		"world_4": {
			"num": 4,
			"name": "TACTICS",
			"num_abilities": 2,
		},
		"world_5": {
			"num": 5,
			"name": "NO ERRORS",
			"num_abilities": 3,
		},
	},
	"ability_tree": {
		"base": {
			"name": "Essentials",
			"prenode": "",
			"icon_name": "Icon.6_88.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"additional_general_damage_percentage": 1.05,
					"additional_life_points": 100,
					"damage_received_reduction": 20,
				},
				2 : {
					"additional_general_damage_percentage": 1.1,
					"additional_life_points": 200,
					"damage_received_reduction": 40,
				},
				3 : {
					"additional_general_damage_percentage": 1.15,
					"additional_life_points": 300,
					"damage_received_reduction": 60,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Increase damage by 5%, life points by 100, reduce damage received by 20."
				},
				2: {
					"description" : "Increase damage by 10%, life points by 200,  reduce damage received by 40."
				},
				3: {
					"description" : "Increase damage by 15%, life points by 300,  reduce damage received by 60."
				}
			}
		},
		"1d": {
			"name": "Destroyer",
			"prenode": "base",
			"icon_name": "Icon.2_77.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"additional_general_damage_percentage": 1.1
				},
				2 : {
					"additional_general_damage_percentage": 1.2
				},
				3 : {
					"additional_general_damage_percentage": 1.3
				}
			},
			"description_per_level": {
				1: {
					"description" : "Increase damage by 10%"
				},
				2: {
					"description" : "Increase damage by 20%"
				},
				3: {
					"description" : "Increase damage by 30%"
				}
			}
		},
		"2d": {
			"name": "Frenetic",
			"prenode": "6d",
			"icon_name": "Icon.1_45.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"additional_attack_speed_percentage": 0.9,
				},
				2 : {
					"additional_attack_speed_percentage": 0.8,
				},
				3 : {
					"additional_attack_speed_percentage": 0.7,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Increase attack speed by 10%"
				},
				2: {
					"description" : "Increase attack speed by 20%"
				},
				3: {
					"description" : "Increase attack speed by 30%"
				}
			}
		},
		"3d": {
			"name": "Collateral",
			"prenode": "1d",
			"icon_name": "Icon.4_93.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"additional_area_damage_percentage": 1.1,
				},
				2 : {
					"additional_area_damage_percentage": 1.2,
				},
				3 : {
					"additional_area_damage_percentage": 1.3,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Increase area damage by 10%"
				},
				2: {
					"description" : "Increase area damage by 20%"
				},
				3: {
					"description" : "Increase area damage by 30%"
				}
			}
		},
		"4d": {
			"name": "Annihilator",
			"prenode": "2d",
			"icon_name": "Icon.1_16.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"additional_life_points_percentage_damage": 0.01,
				},
				2 : {
					"additional_life_points_percentage_damage": 0.02,
				},
				3 : {
					"additional_life_points_percentage_damage": 0.03,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Reduce 1% enemy life points per attack"
				},
				2: {
					"description" : "Reduce 2% enemy life points per attack"
				},
				3: {
					"description" : "Reduce 3% enemy life points per attack"
				}
			}
		},
		"5d": {
			"name": "Stealer",
			"prenode": "2d",
			"icon_name": "Icon.2_02.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"laser_life_steal": 0.02,
				},
				2 : {
					"laser_life_steal": 0.04,
				},
				3 : {
					"laser_life_steal": 0.06,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Heal 2% of the damage inflicted by your laser"
				},
				2: {
					"description" : "Heal 4% of the damage inflicted by your laser"
				},
				3: {
					"description" : "Heal 6% of the damage inflicted by your laser"
				}
			}
		},
		"6d": {
			"name": "Shooter",
			"prenode": "base",
			"icon_name": "Icon.3_70.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"laser_damage": 40
				},
				2 : {
					"laser_damage": 80
				},
				3 : {
					"laser_damage": 120
				}
			},
			"description_per_level": {
				1: {
					"description" : "Increase laser damage by 40"
				},
				2: {
					"description" : "Increase laser damage by 80"
				},
				3: {
					"description" : "Increase laser damage by 120"
				}
			}
		},
		"1r": {
			"name": "Tenacious",
			"prenode": "base",
			"icon_name": "Icon.1_88.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"debuff_duration": 0.9,
				},
				2 : {
					"debuff_duration": 0.8,
				},
				3 : {
					"debuff_duration": 0.7,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Reduce debuff duration by 10%"
				},
				2: {
					"description" : "Reduce debuff duration by 20%"
				},
				3: {
					"description" : "Reduce debuff duration by 30%"
				}
			}
		},
		"2r": {
			"name": "Shield",
			"prenode": "1r",
			"icon_name": "Icon.5_26.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"damage_received_reduction": 30,
				},
				2 : {
					"damage_received_reduction": 60,
				},
				3 : {
					"damage_received_reduction": 90,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Reduce damage received by 30"
				},
				2: {
					"description" : "Reduce damage received by 60"
				},
				3: {
					"description" : "Reduce damage received by 90"
				}
			}
		},
		"3r": {
			"name": "Protector",
			"prenode": "1r",
			"icon_name": "Icon.5_75.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"damage_received_reduction_percentage": 0.9,
				},
				2 : {
					"damage_received_reduction_percentage": 0.8,
				},
				3 : {
					"damage_received_reduction_percentage": 0.7,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Reduce damage received by 10%"
				},
				2: {
					"description" : "Reduce damage received by 20%"
				},
				3: {
					"description" : "Reduce damage received by 30%"
				}
			}
		},
		"4r": {
			"name": "Unreachable",
			"prenode": "1r",
			"icon_name": "Icon.2_56.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"additional_speed_percentage": 1.1,
				},
				2 : {
					"additional_speed_percentage": 1.2,
				},
				3 : {
					"additional_speed_percentage": 1.3,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Increased speed by 10%"
				},
				2: {
					"description" : "Increased speed by 20%"
				},
				3: {
					"description" : "Increased speed by 30%"
				}
			}
		},
		"1c": {
			"name": "Brave",
			"prenode": "base",
			"icon_name": "Icon.6_83.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"additional_life_points": 150,
				},
				2 : {
					"additional_life_points": 300,
				},
				3 : {
					"additional_life_points": 450,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Increased life points by 150"
				},
				2: {
					"description" : "Increased life points by 300"
				},
				3: {
					"description" : "Increased life points by 450"
				}
			}
		},
		"2c": {
			"name": "Hopeful",
			"prenode": "1c",
			"icon_name": "Icon.6_86.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"additional_healing_percentage": 1.15,
				},
				2 : {
					"additional_healing_percentage": 1.30,
				},
				3 : {
					"additional_healing_percentage": 1.45,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Increased all healing by 15%"
				},
				2: {
					"description" : "Increased all healing by 30%"
				},
				3: {
					"description" : "Increased all healing by 45%"
				}
			}
		},
		"3c": {
			"name": "Persistent",
			"prenode": "1c",
			"icon_name": "Icon.5_69.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"missing_life_regeneration_percentage": 0.01,
				},
				2 : {
					"missing_life_regeneration_percentage": 0.02,
				},
				3 : {
					"missing_life_regeneration_percentage": 0.03,
				}
			},
			"description_per_level": {
				1: {
					"description" : "regenerates 1% of missing life per second"
				},
				2: {
					"description" : "regenerates 2% of missing life per second"
				},
				3: {
					"description" : "regenerates 3% of missing life per second"
				}
			}
		},
		"4c": {
			"name": "Tank",
			"prenode": "1c",
			"icon_name": "Icon.7_12.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"additional_life_points_percentage": 1.15,
				},
				2 : {
					"additional_life_points_percentage": 1.3,
				},
				3 : {
					"additional_life_points_percentage": 1.45,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Increase life points by 15%"
				},
				2: {
					"description" : "Increase life points by 30%"
				},
				3: {
					"description" : "Increase life points by 45%"
				}
			}
		},
		"1e": {
			"name": "Skilled",
			"prenode": "base",
			"icon_name": "Icon.2_98.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"ability_cooldown_reduction_percentage": 0.9,
				},
				2 : {
					"ability_cooldown_reduction_percentage": 0.8,
				},
				3 : {
					"ability_cooldown_reduction_percentage": 0.7,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Reduce ability cooldown by 10%"
				},
				2: {
					"description" : "Reduce ability cooldown by 20%"
				},
				3: {
					"description" : "Reduce ability cooldown by 30%"
				}
			}
		},
		"2e": {
			"name": "Engineer",
			"prenode": "1e",
			"icon_name": "Icon.3_53.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"drone_additional_life_percentage": 1.15,
					"drone_additional_damage_percentage": 1.15,
					"drone_damage_reduced_percentage": 0.85,
				},
				2 : {
					"drone_additional_life_percentage": 1.30,
					"drone_additional_damage_percentage": 1.30,
					"drone_damage_reduced_percentage": 0.7,
				},
				3 : {
					"drone_additional_life_percentage": 1.45,
					"drone_additional_damage_percentage": 1.45,
					"drone_damage_reduced_percentage": 0.55,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Increase drone life points by 15%, drone damage by 15% and reduce drone damage received by 15%"
				},
				2: {
					"description" : "Increase drone life points by 30%, drone damage by 30% and reduce drone damage received by 30%"
				},
				3: {
					"description" : "Increase drone life points by 45%, drone damage by 45% and reduce drone damage received by 45%"
				}
			}
		},
		"3e": {
			"name": "Focussed",
			"prenode": "1e",
			"icon_name": "Icon.3_01.png",
			"levels": 3,
			"stats_per_level": {
				1 : {
					"additional_ability_duration_percentage": 1.1,
				},
				2 : {
					"additional_ability_duration_percentage": 1.2,
				},
				3 : {
					"additional_ability_duration_percentage": 1.3,
				}
			},
			"description_per_level": {
				1: {
					"description" : "Increase ability duration by 10%"
				},
				2: {
					"description" : "Increase ability duration by 20%"
				},
				3: {
					"description" : "Increase ability duration by 30%"
				}
			}
		},
	},
	"enemies": {
		"astropajo": {
			"gold": 5,
		},
		"cosmic_chimera": {
			"gold": 10,
		},
		"settler": {
			"gold": 100,
		},
		"fore_front": {
			"gold": 50,
		},
		"insect": {
			"gold": 2,
		},
		"snow_cruise": {
			"gold": 35,
		}
	},
	"items": {
		"ability_point": {
			"name": "Ability point",
			"description": "Additional skill point that you can assign in your skill tree.",
			"video": "ability_example",
			"cost":
				[
				1000,
				1300,
				1690,
				2197,
				2856,
				3712,
				4825,
				6272,
				8153,
				10598,
				13777,
				17910,
				23283,
				30267,
				39347,
				51151,
				66496,
				86444,
				112377,
				146090,
				189917,
				246892,
				320959,
				417246,
				542419,
				705144,
				916687,
				1191693,
				1549200,
				2013960,
				2618148,
				3403592,
				4424669,
				5752069,
				7477689,
				]
		},
		"super_shoot": {
			"name": "Super Shoot",
			"description": "Launches a lightning bolt that continuously inflicts area damage to your enemies.",
			"cost": 100,
			"video": "super_shoot_example",
		},
		"shield": {
			"name": "Shield",
			"description": "Generates a shield that protects you from damage and at the end heals a percentage of the absorbed damage.",
			"cost": 1000,
			"video": "shield_example",
		},
		"attack_drone": {
			"name": "Attack Drone",
			"description": "Generates a drone that helps you destroy enemies.",
			"cost": 2000,
			"video": "attack_drone_example",
		},
		"energy_burst": {
			"name": "Energy Burst",
			"description": "Generates an energy field around your ship that increases your speed and inflicts area damage to nearby enemies.",
			"cost": 3000,
			"video": "energy_burst_example",
		},
		"doble_shoot": {
			"name": "Double Shoot",
			"description": "Power up your lasers by launching double shots with increased damage and speed.",
			"cost": 8000,
			"video": "double_shoot_example",
		},
	}
}

func get_key(key : String):
	return settings[key]
