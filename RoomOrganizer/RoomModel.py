from dataclasses import dataclass
from typing import List, Any, TypeVar, Callable, Type, cast


T = TypeVar("T")


def from_list(f: Callable[[Any], T], x: Any) -> List[T]:
    assert isinstance(x, list)
    return [f(y) for y in x]


def from_int(x: Any) -> int:
    assert isinstance(x, int) and not isinstance(x, bool)
    return x


def from_str(x: Any) -> str:
    assert isinstance(x, str)
    return x


def to_class(c: Type[T], x: Any) -> dict:
    assert isinstance(x, c)
    return cast(Any, x).to_dict()


@dataclass
class Doors:
    doors_dimensions: List[int]
    doors_positions: List[List[int]]

    @staticmethod
    def from_dict(obj: Any) -> 'Doors':
        assert isinstance(obj, dict)
        doors_dimensions = from_list(from_int, obj.get("DoorsDimensions"))
        doors_positions = from_list(lambda x: from_list(from_int, x), obj.get("DoorsPositions"))
        return Doors(doors_dimensions, doors_positions)

    def to_dict(self) -> dict:
        result: dict = {}
        result["DoorsDimensions"] = from_list(from_int, self.doors_dimensions)
        result["DoorsPositions"] = from_list(lambda x: from_list(from_int, x), self.doors_positions)
        return result


@dataclass
class Furniture:
    dimensions: List[List[int]]
    keywords: List[str]

    @staticmethod
    def from_dict(obj: Any) -> 'Furniture':
        assert isinstance(obj, dict)
        dimensions = from_list(lambda x: from_list(from_int, x), obj.get("Dimensions"))
        keywords = from_list(from_str, obj.get("keywords"))
        return Furniture(dimensions, keywords)

    def to_dict(self) -> dict:
        result: dict = {}
        result["Dimensions"] = from_list(lambda x: from_list(from_int, x), self.dimensions)
        result["keywords"] = from_list(from_str, self.keywords)
        return result


@dataclass
class Windows:
    windows_dimensions: List[int]
    windows_positions: List[List[int]]

    @staticmethod
    def from_dict(obj: Any) -> 'Windows':
        assert isinstance(obj, dict)
        windows_dimensions = from_list(from_int, obj.get("windowsDimensions"))
        windows_positions = from_list(lambda x: from_list(from_int, x), obj.get("Windows Positions"))
        return Windows(windows_dimensions, windows_positions)

    def to_dict(self) -> dict:
        result: dict = {}
        result["windowsDimensions"] = from_list(from_int, self.windows_dimensions)
        result["Windows Positions"] = from_list(lambda x: from_list(from_int, x), self.windows_positions)
        return result


@dataclass
class RoomToBeUsed:
    furniture: Furniture
    room_dimensions: List[int]
    windows: Windows
    doors: Doors

    @staticmethod
    def from_dict(obj: Any) -> 'RoomToBeUsed':
        assert isinstance(obj, dict)
        furniture = Furniture.from_dict(obj.get("Furniture"))
        room_dimensions = from_list(from_int, obj.get("RoomDimensions"))
        windows = Windows.from_dict(obj.get("Windows"))
        doors = Doors.from_dict(obj.get("Doors"))
        return RoomToBeUsed(furniture, room_dimensions, windows, doors)

    def to_dict(self) -> dict:
        result: dict = {}
        result["Furniture"] = to_class(Furniture, self.furniture)
        result["RoomDimensions"] = from_list(from_int, self.room_dimensions)
        result["Windows"] = to_class(Windows, self.windows)
        result["Doors"] = to_class(Doors, self.doors)
        return result


def room_from_dict(s: Any) -> RoomToBeUsed:
    return RoomToBeUsed.from_dict(s)


def room_to_dict(x: RoomToBeUsed) -> Any:
    return to_class(RoomToBeUsed, x)
