import pymysql
from graphviz import Digraph


class Node:
    def __init__(self, id, parent=None):
        self.id = id
        self.parent = parent
        self.children = []

    def add_child(self, child):
        self.children.append(child)


def build_tree(conn, user_id, referral_id=None):
    id_to_node = {}
    with conn.cursor() as cursor:
        if referral_id:
            cursor.execute("SELECT id, pid FROM TOP.bx_users WHERE referral_id=%s", (referral_id,))
        else:
            cursor.execute("SELECT id, pid FROM TOP.bx_users")
        for row in cursor:
            id, parent_id = row
            if id not in id_to_node:
                id_to_node[id] = Node(id)
            if parent_id not in id_to_node:
                id_to_node[parent_id] = Node(parent_id)
            node = id_to_node[id]
            parent = id_to_node[parent_id]
            node.parent = parent
            parent.add_child(node)
    return id_to_node[user_id]


def print_tree(node, level=0):
    dot.node(str(node.id), str(node.id))
    dot.edge(str(node.parent.id), str(node.id))
    #print(' ' * level + f'{node.id}')
    for child in node.children:
        print_tree(child, level + 1)


if __name__ == '__main__':
    # 请将下面的参数替换成你的数据
    dot = Digraph()
    db_config = {
        'host': 'localhost',
        'port': 3306,
        'user': 'Test_User',
        'password': '1234567890@',
        'database': 'TOP',
    }
    my_id = 300076
    referral_id = 1

    conn = pymysql.connect(**db_config)
    # 构建树状结构
    root = build_tree(conn, my_id)
    # 打印树状结构

    # 显示图像
    print_tree(root)
    dot.attr(layout='dot')
    dot.format = 'pdf'

    dot.render('Tree', view=True)

