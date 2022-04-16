import uuid
import random

LOG_CNT = 1000000  # 日志条数
USER_CNT_MAX = 10000  # 用户最大数量。若不限制则设为None

uname_list = []

def get_user():
    """
    生成一个用户ID
    """
    if (USER_CNT_MAX is None or 0 <= len(uname_list) < USER_CNT_MAX) \
        and (not uname_list or random.random() > 0.9):  # 生成新用户名
        uid = str(uuid.uuid4())[:8]
        uname_list.append(uid)
        return uid
    else:  # 从已有用户名中选择
        return random.choice(uname_list)

for i in range(LOG_CNT):
    user_id = get_user()
    print(user_id)

assert len(uname_list) == USER_CNT_MAX
