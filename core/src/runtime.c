/* Newlib hooks normally supplied by crt0, replaced here by ST's startup.
 * __libc_init_array still walks the constructor arrays in the linker script.
 */
void _init(void)
{
}

void _fini(void)
{
}
