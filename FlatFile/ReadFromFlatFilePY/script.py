
def get_csv(textaslist, norows):
    content = textaslist
    extracted_content = []
    index = 0
    temp_content = []
    while index < len(content):
        first_four_bytes = bytearray(content[index:index+4])
        print first_four_bytes[0]
        data_start = index+4
        data_length = first_four_bytes[0]
        data = content[data_start:data_start+data_length]
        index = data_start+data_length
        temp_content.append(data)
        if len(temp_content) == norows:
            extracted_content.append(temp_content)
            temp_content = []


if __name__ == "__main__":
    content = open("./Data/c_ecolids_regular_csv.txt._1_of_2").read()
    get_csv(content, 9)