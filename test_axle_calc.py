import pytest
from axle_calc import AxleLoadCalculator, InvalidAxleConfigurationError, CargoOutOfBoundsException

# Common configurations
# 2+3: 2-axle tractor + 3-axle trailer
# 3+3: 3-axle tractor + 3-axle trailer

@pytest.fixture
def calc_2_3():
    return AxleLoadCalculator(
        wheelbase=3.6,
        fifth_wheel_offset=0.6,
        kingpin_to_bogie=9.0,
        front_to_kingpin=1.6,
        trailer_length=13.6,
        tractor_unladen_front=5.0,
        tractor_unladen_rear=3.0,
        trailer_unladen_weight=7.0,
        trailer_unladen_cog=6.8,
        tractor_axles=2,
        trailer_axles=3
    )

@pytest.fixture
def calc_3_3():
    return AxleLoadCalculator(
        wheelbase=4.0,
        fifth_wheel_offset=0.8,
        kingpin_to_bogie=9.0,
        front_to_kingpin=1.6,
        trailer_length=13.6,
        tractor_unladen_front=5.5,
        tractor_unladen_rear=4.0,
        trailer_unladen_weight=7.5,
        trailer_unladen_cog=6.8,
        tractor_axles=3,
        trailer_axles=3
    )

@pytest.mark.parametrize("config_name, cargo_weight, cargo_pos", [
    ("calc_2_3", 15.0, 9.0),  # Positioned to avoid overload
    ("calc_3_3", 20.0, 8.5),
])
def test_standard_configurations(request, config_name, cargo_weight, cargo_pos):
    calc = request.getfixturevalue(config_name)
    result = calc.calculate(cargo_weight, cargo_pos)
    assert "total_mass" in result
    assert len(result["axles"]) == 3
    assert not result["has_overload"]

def test_boundary_centered(calc_2_3):
    # Nominal load, perfectly centered
    result = calc_2_3.calculate(20.0, 6.8)
    # Total trailer = 7 + 20 = 27
    # Cog = (7*6.8 + 20*6.8)/27 = 6.8
    # Rel to KP = 6.8 - 1.6 = 5.2
    # Bogie = 27 * 5.2 / 9.0 = 15.6
    # KP = 27 - 15.6 = 11.4
    # Front = 5.0 + 11.4 * 0.6/3.6 = 5.0 + 1.9 = 6.9
    # Rear = 3.0 + 11.4 * (3.0/3.6) = 3.0 + 9.5 = 12.5 (Overload for 4x2)
    assert result["axles"][1]["status"] == "overload"

def test_boundary_front(calc_2_3):
    # Cargo at the very front board
    result = calc_2_3.calculate(15.0, 0.0)
    # More load on kingpin, less on bogie
    # Resulting loads on tractor should be higher than centered
    centered_result = calc_2_3.calculate(15.0, 6.8)
    assert result["axles"][0]["load"] > centered_result["axles"][0]["load"]

def test_boundary_rear(calc_2_3):
    # Cargo at the very rear
    result = calc_2_3.calculate(15.0, 13.6)
    # More load on bogie
    centered_result = calc_2_3.calculate(15.0, 6.8)
    assert result["axles"][2]["load"] > centered_result["axles"][2]["load"]

@pytest.mark.parametrize("overload_factor, expected_status", [
    (0.90, "ok"),        # 10% below - ok
    (0.94, "ok"),        # 6% below - ok
    (0.96, "warning"),   # 4% below - warning (>95%)
    (0.99, "warning"),   # 1% below - warning
    (1.001, "overload"), # Barely over - overload
    (1.05, "overload"),  # 5% over - overload
    (1.10, "overload"),  # 10% over - overload
    (1.20, "overload"),  # 20% over - overload
])
def test_stress_overload_flags(calc_3_3, overload_factor, expected_status):
    # We want to target the drive bogie (limit 16.0)
    # Wheelbase = 4.0, Offset = 0.8.
    # RearAddition = kingpin_load * (4.0 - 0.8) / 4.0 = 0.8 * kingpin_load
    # RearTotal = 4.0 + 0.8 * kingpin_load
    limit = 16.0
    target_load = limit * overload_factor
    kp_needed = (target_load - 4.0) / 0.8

    # kingpin_load = (trailer_unladen + cargo) - bogie_load
    # bogie_load = m_empty / kp_to_bogie  (if cargo is at KP)
    m_empty = 7.5 * (6.8 - 1.6)
    bogie_load = m_empty / 9.0

    cargo = kp_needed + bogie_load - 7.5

    result = calc_3_3.calculate(cargo, 1.6) # Positioned at Kingpin (X=1.6)
    assert result["axles"][1]["status"] == expected_status

def test_negative_weight(calc_2_3):
    with pytest.raises(ValueError, match="Cargo weight cannot be negative"):
        calc_2_3.calculate(-100, 5.0)

def test_zero_distances():
    with pytest.raises(InvalidAxleConfigurationError):
        AxleLoadCalculator(0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3)

def test_out_of_bounds(calc_2_3):
    with pytest.raises(CargoOutOfBoundsException):
        calc_2_3.calculate(1000, 15.0) # Length is 13.6
