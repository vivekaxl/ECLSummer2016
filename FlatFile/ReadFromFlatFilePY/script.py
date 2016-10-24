import sys
def get_csv(textaslist):
    content = textaslist
    extracted_content = []
    index = 0
    while index <= len(content):
        print index, content[index], sys.getsizeof(content[index])
        index += 1
        import pdb
        pdb.set_trace()
        raw_input()



if  __name__ == "__main__":
    content = open("./Data/c_ecolids_regular_csv.txt._1_of_2").read()
    get_csv(content)