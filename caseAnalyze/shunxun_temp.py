import connectDB as db
import json

policy_numbers = db.get_shuxun_temp_policy_number()
print(policy_numbers)
for policy_number in policy_numbers:
    print("_______________________")
    # print(policy_number[0])
    # share_rate = db.get_shuxun_temp_share_rate(policy_number[0])
    # print(share_rate)
    # 解析json 获取share_rate
    policy_number = policy_number[0]
    share_rate = db.get_shuxun_temp_share_rate(str(policy_number))
    # print(policy_number)
    # print(policy_number[0])
    share_rate = share_rate[0][0]
    share = json.loads(str(share_rate))
    # print(share[1]['user_id'])
    name = ''
    for i in share:
        print("WOWID:" + str(i['user_id']))
        print("Name: " + db.get_agent_list_name(i['user_id']))
        print("Share Rate: " + i['share_rate'])
        name += db.get_agent_list_name(i['user_id']) + ':' + str(i['share_rate']) + '%, '
    name = name[:-2]
    print(name)
    db.update_shuxun_temp_split_agent(policy_number, name)
