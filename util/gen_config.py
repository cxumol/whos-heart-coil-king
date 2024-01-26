import glob
import json

_dir = "../data/"
add_dir = lambda y:[_dir+x for x in y]
input_files = ["character_meta.json","map_meta.json"]
output_files = ["character_config.json","map_config.json"]

input_files =add_dir(input_files)
output_files =add_dir(output_files)

def scan_dir(name, dir_path, prefix, ext):
    files = glob.glob(f'../{dir_path}/**/{prefix}*{name}*', recursive=True)
    for file in files:
        if file.endswith(tuple(ext)):
            return f'res://{file}'.replace('\\','/').replace('../','')

def gen(input_data):
    output_data = []
    for id, name in enumerate(input_data['name']):
        res_path = {}
        for res_type, res_info in input_data['res'].items():
            res_path[res_type] = scan_dir(name, res_info['dir'], res_info['prefix'], res_info['ext'])
        output_data.append({
            'ID': id,
            'Name': name,
            'ResPath': res_path
        })
    # print(json.dumps(output_data, indent=4, ensure_ascii=False))
    return output_data

def main(input_file,output_file):
    f1,f2=open(input_file, encoding='utf8'),open(output_file, 'w', encoding='utf8')
    json.dump(gen(json.load(f1)),f2,ensure_ascii=False)
    f1.close()
    f1.close()

if __name__ == '__main__':
    for i in range(len(input_files)):
        main(input_files[i], output_files[i])