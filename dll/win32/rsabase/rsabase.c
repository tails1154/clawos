#include <stdarg.h>

#include "windef.h"
#include "winbase.h"
#include "winerror.h"
#include "wincrypt.h"

BOOL WINAPI CPAcquireContext(HCRYPTPROV *phProv, LPSTR pszContainer, DWORD dwFlags, PVTableProvStruc pVTable)
{
    UNREFERENCED_PARAMETER(phProv);
    UNREFERENCED_PARAMETER(pszContainer);
    UNREFERENCED_PARAMETER(dwFlags);
    UNREFERENCED_PARAMETER(pVTable);

    SetLastError(NTE_BAD_KEYSET);
    return FALSE;
}

BOOL WINAPI CPReleaseContext(HCRYPTPROV hProv, DWORD dwFlags)
{
    UNREFERENCED_PARAMETER(hProv);
    UNREFERENCED_PARAMETER(dwFlags);
    return TRUE;
}
