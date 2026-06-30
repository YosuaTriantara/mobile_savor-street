from enum import Enum


class TableStatus(str, Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"


class MenuStatus(str, Enum):
    AVAILABLE = "available"
    UNAVAILABLE = "unavailable"


class MenuCategory(str, Enum):
    RICE = "Rice"
    NOODLES = "Noodles"
    SIDE_DISH = "Side Dish"
    BEVERAGE = "Beverage"


class OptionType(str, Enum):
    SPICY_LEVEL = "spicy_level"
    PORTION_SIZE = "portion_size"
    TOPPING = "topping"


class OptionStatus(str, Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"


class OrderStatus(str, Enum):
    ORDERED = "ordered"
    BILL_REQUESTED = "bill_requested"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


class InvoiceStatus(str, Enum):
    REQUESTED = "requested"
    PAID = "paid"
    CANCELLED = "cancelled"


class CashierStatus(str, Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"