from typing import List, Dict, Union
from dataclasses import dataclass

class InvalidAxleConfigurationError(Exception):
    """Raised when vehicle configuration is physically impossible or invalid."""
    pass

class CargoOutOfBoundsException(Exception):
    """Raised when cargo is placed outside the trailer boundaries."""
    pass

@dataclass
class AxleGroup:
    label: str
    limit: float
    unladen_weight: float
    num_axles: int

class AxleLoadCalculator:
    def __init__(
        self,
        wheelbase: float,  # Distance from front axle to rear axle (or tandem center)
        fifth_wheel_offset: float,  # Distance from rear axle center to fifth wheel (positive = ahead)
        kingpin_to_bogie: float,  # Distance from kingpin to trailer bogie center
        front_to_kingpin: float,  # Distance from trailer front board to kingpin
        trailer_length: float,
        tractor_unladen_front: float,
        tractor_unladen_rear: float,
        trailer_unladen_weight: float,
        trailer_unladen_cog: float,  # Center of gravity of empty trailer from front board
        tractor_axles: int,  # 2 or 3
        trailer_axles: int   # 3 or 4
    ):
        if wheelbase <= 0 or kingpin_to_bogie <= 0 or trailer_length <= 0:
            raise InvalidAxleConfigurationError("Distances must be positive")

        self.wheelbase = wheelbase
        self.fifth_wheel_offset = fifth_wheel_offset
        self.kingpin_to_bogie = kingpin_to_bogie
        self.front_to_kingpin = front_to_kingpin
        self.trailer_length = trailer_length
        self.tractor_unladen_front = tractor_unladen_front
        self.tractor_unladen_rear = tractor_unladen_rear
        self.trailer_unladen_weight = trailer_unladen_weight
        self.trailer_unladen_cog = trailer_unladen_cog
        self.tractor_axles = tractor_axles
        self.trailer_axles = trailer_axles

    def calculate(self, cargo_weight: float, cargo_position: float) -> Dict:
        """
        Calculates axle loads.
        cargo_position: distance from trailer front board in meters.
        """
        if cargo_weight < 0:
            raise ValueError("Cargo weight cannot be negative")

        if cargo_position < 0 or cargo_position > self.trailer_length:
            raise CargoOutOfBoundsException(f"Cargo position {cargo_position} is outside trailer [0, {self.trailer_length}]")

        # 1. Distribution of trailer weight (Unladen + Cargo) between Kingpin and Bogie
        total_trailer_weight = self.trailer_unladen_weight + cargo_weight

        # Moment about Kingpin for empty trailer
        m_empty = self.trailer_unladen_weight * (self.trailer_unladen_cog - self.front_to_kingpin)
        # Moment about Kingpin for cargo
        m_cargo = cargo_weight * (cargo_position - self.front_to_kingpin)

        # Sum of moments = 0 about Kingpin: m_empty + m_cargo = BogieLoad * kingpin_to_bogie
        bogie_load = (m_empty + m_cargo) / self.kingpin_to_bogie
        kingpin_load = total_trailer_weight - bogie_load

        # 2. Distribution of Kingpin load to tractor axles
        # FrontAddition = KingpinLoad * offset / L
        # RearAddition = KingpinLoad * (L - offset) / L

        front_addition = kingpin_load * self.fifth_wheel_offset / self.wheelbase
        rear_addition = kingpin_load * (self.wheelbase - self.fifth_wheel_offset) / self.wheelbase

        total_front = self.tractor_unladen_front + front_addition
        total_rear = self.tractor_unladen_rear + rear_addition

        # 3. Define limits (Simplified RU 2200)
        limit_front = 10.0
        limit_rear = 16.0 if self.tractor_axles == 3 else 10.0
        limit_trailer = 26.0 if self.trailer_axles == 4 else 21.0

        axles = [
            {
                "label": "Рулевая ось",
                "load": round(total_front, 4),
                "limit": limit_front,
                "status": self._get_status(total_front, limit_front)
            },
            {
                "label": "Ведущая группа" if self.tractor_axles == 3 else "Ведущая ось",
                "load": round(total_rear, 4),
                "limit": limit_rear,
                "status": self._get_status(total_rear, limit_rear)
            },
            {
                "label": f"Тележка полуприцепа ({self.trailer_axles} осей)",
                "load": round(bogie_load, 4),
                "limit": limit_trailer,
                "status": self._get_status(bogie_load, limit_trailer)
            }
        ]

        return {
            "total_mass": round(self.tractor_unladen_front + self.tractor_unladen_rear + total_trailer_weight, 4),
            "axles": axles,
            "has_overload": any(a["status"] == "overload" for a in axles)
        }

    def _get_status(self, load: float, limit: float) -> str:
        # Using a small epsilon for float comparison
        if load > limit + 1e-7:
            return "overload"
        if load > limit * 0.95 - 1e-7:
            return "warning"
        return "ok"
