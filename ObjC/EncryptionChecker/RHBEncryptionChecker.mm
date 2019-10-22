#import "RHBEncryptionChecker.h"

#import <dlfcn.h>
#import <mach-o/dyld.h>

template <typename THEADER, typename CRYPT_CMD, int CMD_ENC> bool isEncryptedBase(const void *pDliBase) {
    
    const THEADER *header = (THEADER *)pDliBase;
    
    const load_command *cmd = (load_command *)(header+1);
    
    for (int i = 0; cmd && i < header->ncmds; ++i) {
        
        /* Encryption info segment */
        if (cmd->cmd == CMD_ENC) {
            
            const CRYPT_CMD *crypt_cmd = (CRYPT_CMD *)cmd;
            return (crypt_cmd->cryptid > 0);
        }
        cmd = (load_command *)((uint8_t *)cmd + cmd->cmdsize);
    }
    
    return false;
}

bool isEncryptedMainPointer(const void *pMain) {
    
    /* Fetch the dlinfo for main() */
    Dl_info dlinfo;
    if (!dladdr(pMain, &dlinfo)) {
        
        return false;
    }
    
    const uint32_t *pBase = (uint32_t *)dlinfo.dli_fbase;
    if (!pBase) {
        
        return false;
    }
    
    return *pBase == MH_MAGIC_64 ?
    isEncryptedBase<mach_header_64, encryption_info_command_64, LC_ENCRYPTION_INFO_64>(pBase) :
    isEncryptedBase<mach_header, encryption_info_command, LC_ENCRYPTION_INFO>(pBase);
}

@implementation RHBEncryptionChecker

+ (BOOL)isEncrypted:(int(int, char **))main {
    
    return isEncryptedMainPointer((void*)main);
}

@end
