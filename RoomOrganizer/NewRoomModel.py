from dataclasses import dataclass
from typing import Any, List, Optional, TypeVar, Callable, Type, cast


T = TypeVar("T")


def from_float(x: Any) -> float:
    assert isinstance(x, (float, int)) and not isinstance(x, bool)
    return float(x)


def to_float(x: Any) -> float:
    assert isinstance(x, float)
    return x


def from_str(x: Any) -> str:
    assert isinstance(x, str)
    return x


def from_list(f: Callable[[Any], T], x: Any) -> List[T]:
    assert isinstance(x, list)
    return [f(y) for y in x]


def to_class(c: Type[T], x: Any) -> dict:
    assert isinstance(x, c)
    return cast(Any, x).to_dict()


def from_int(x: Any) -> int:
    assert isinstance(x, int) and not isinstance(x, bool)
    return x


def from_bool(x: Any) -> bool:
    assert isinstance(x, bool)
    return x


def from_none(x: Any) -> Any:
    assert x is None
    return x


def from_union(fs, x):
    for f in fs:
        try:
            return f(x)
        except:
            pass
    assert False


@dataclass
class ObjectScale:
    x: float
    y: float
    z: float

    @staticmethod
    def from_dict(obj: Any) -> 'ObjectScale':
        assert isinstance(obj, dict)
        x = from_float(obj.get("x"))
        y = from_float(obj.get("y"))
        z = from_float(obj.get("z"))
        return ObjectScale(x, y, z)

    def to_dict(self) -> dict:
        result: dict = {}
        result["x"] = to_float(self.x)
        result["y"] = to_float(self.y)
        result["z"] = to_float(self.z)
        return result


@dataclass
class Object:
    id: str
    confidence: str
    transform: List[float]
    category: str
    scale: ObjectScale

    @staticmethod
    def from_dict(obj: Any) -> 'Object':
        assert isinstance(obj, dict)
        id = from_str(obj.get("id"))
        confidence = from_str(obj.get("confidence"))
        transform = from_list(from_float, obj.get("transform"))
        category = from_str(obj.get("category"))
        scale = ObjectScale.from_dict(obj.get("scale"))
        return Object(id, confidence, transform, category, scale)

    def to_dict(self) -> dict:
        result: dict = {}
        result["id"] = from_str(self.id)
        result["confidence"] = from_str(self.confidence)
        result["transform"] = from_list(to_float, self.transform)
        result["category"] = from_str(self.category)
        result["scale"] = to_class(ObjectScale, self.scale)
        return result


@dataclass
class SurfaceScale:
    x: float
    y: float
    z: int

    @staticmethod
    def from_dict(obj: Any) -> 'SurfaceScale':
        assert isinstance(obj, dict)
        x = from_float(obj.get("x"))
        y = from_float(obj.get("y"))
        z = from_int(obj.get("z"))
        return SurfaceScale(x, y, z)

    def to_dict(self) -> dict:
        result: dict = {}
        result["x"] = to_float(self.x)
        result["y"] = to_float(self.y)
        result["z"] = from_int(self.z)
        return result


@dataclass
class Surface:
    id: str
    edges: List[bool]
    confidence: str
    transform: List[float]
    category: str
    scale: SurfaceScale
    is_open: Optional[bool] = None

    @staticmethod
    def from_dict(obj: Any) -> 'Surface':
        assert isinstance(obj, dict)
        id = from_str(obj.get("id"))
        edges = from_list(from_bool, obj.get("edges"))
        confidence = from_str(obj.get("confidence"))
        transform = from_list(from_float, obj.get("transform"))
        category = from_str(obj.get("category"))
        scale = SurfaceScale.from_dict(obj.get("scale"))
        is_open = from_union([from_bool, from_none], obj.get("isOpen"))
        return Surface(id, edges, confidence, transform, category, scale, is_open)

    def to_dict(self) -> dict:
        result: dict = {}
        result["id"] = from_str(self.id)
        result["edges"] = from_list(from_bool, self.edges)
        result["confidence"] = from_str(self.confidence)
        result["transform"] = from_list(to_float, self.transform)
        result["category"] = from_str(self.category)
        result["scale"] = to_class(SurfaceScale, self.scale)
        if self.is_open is not None:
            result["isOpen"] = from_union([from_bool, from_none], self.is_open)
        return result


@dataclass
class Room:
    surfaces: List[Surface]
    objects: List[Object]

    @staticmethod
    def from_dict(obj: Any) -> 'Room':
        assert isinstance(obj, dict)
        surfaces = from_list(Surface.from_dict, obj.get("surfaces"))
        objects = from_list(Object.from_dict, obj.get("objects"))
        return Room(surfaces, objects)

    def to_dict(self) -> dict:
        result: dict = {}
        result["surfaces"] = from_list(lambda x: to_class(Surface, x), self.surfaces)
        result["objects"] = from_list(lambda x: to_class(Object, x), self.objects)
        return result


def room_from_dict(s: Any) -> Room:
    return Room.from_dict(s)


def room_to_dict(x: Room) -> Any:
    return to_class(Room, x)
