from hcl2 import reverse_transform, writes


def to_hcl2(hcl_dict):
    ast = reverse_transform(hcl_dict)
    return writes(ast)


# noinspection PyMethodMayBeStatic
class FilterModule:
    def filters(self):
        return {
            "to_hcl2": to_hcl2,
        }
