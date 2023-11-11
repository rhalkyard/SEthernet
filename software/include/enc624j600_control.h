enum {
    ENCReadReg = 0x7000,
    ENCWriteReg = 0x7001,
    ENCReadPhy = 0x7002,
    ENCWritePhy = 0x7003,
    ENCEnableLoopback = 0x7004,
    ENCDisableLoopback = 0x7005
};

struct ENCRegister {
    unsigned short reg;
    unsigned short value;
};
typedef struct ENCRegister ENCRegister;
