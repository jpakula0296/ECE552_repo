for i in range (0,8):
    for j in range(0,16):
        if(j>7):
            set = 1
        else:
            set = 0
        print("assign set"+str(i)+"["+str(j)+"] = DUT.instr_cache.metaDataArray"+str(set)+".Mblk["+str(set)+"].mc["+str(j%8)+"].q;")
