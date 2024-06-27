
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
   0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
   1:	31 c0                	xor    %eax,%eax
{
   3:	89 e5                	mov    %esp,%ebp
   5:	53                   	push   %ebx
   6:	8b 4d 08             	mov    0x8(%ebp),%ecx
   9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
   c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  10:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  14:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  17:	83 c0 01             	add    $0x1,%eax
  1a:	84 d2                	test   %dl,%dl
  1c:	75 f2                	jne    10 <strcpy+0x10>
    ;
  return os;
}
  1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  21:	89 c8                	mov    %ecx,%eax
  23:	c9                   	leave
  24:	c3                   	ret
  25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000030 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	53                   	push   %ebx
  34:	8b 55 08             	mov    0x8(%ebp),%edx
  37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  3a:	0f b6 02             	movzbl (%edx),%eax
  3d:	84 c0                	test   %al,%al
  3f:	75 17                	jne    58 <strcmp+0x28>
  41:	eb 3a                	jmp    7d <strcmp+0x4d>
  43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  47:	90                   	nop
  48:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  4c:	83 c2 01             	add    $0x1,%edx
  4f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  52:	84 c0                	test   %al,%al
  54:	74 1a                	je     70 <strcmp+0x40>
    p++, q++;
  56:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  58:	0f b6 19             	movzbl (%ecx),%ebx
  5b:	38 c3                	cmp    %al,%bl
  5d:	74 e9                	je     48 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  5f:	29 d8                	sub    %ebx,%eax
}
  61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  64:	c9                   	leave
  65:	c3                   	ret
  66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  6d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
  70:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  74:	31 c0                	xor    %eax,%eax
  76:	29 d8                	sub    %ebx,%eax
}
  78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  7b:	c9                   	leave
  7c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  7d:	0f b6 19             	movzbl (%ecx),%ebx
  80:	31 c0                	xor    %eax,%eax
  82:	eb db                	jmp    5f <strcmp+0x2f>
  84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8f:	90                   	nop

00000090 <strlen>:

uint
strlen(const char *s)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  96:	80 3a 00             	cmpb   $0x0,(%edx)
  99:	74 15                	je     b0 <strlen+0x20>
  9b:	31 c0                	xor    %eax,%eax
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  a0:	83 c0 01             	add    $0x1,%eax
  a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  a7:	89 c1                	mov    %eax,%ecx
  a9:	75 f5                	jne    a0 <strlen+0x10>
    ;
  return n;
}
  ab:	89 c8                	mov    %ecx,%eax
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret
  af:	90                   	nop
  for(n = 0; s[n]; n++)
  b0:	31 c9                	xor    %ecx,%ecx
}
  b2:	5d                   	pop    %ebp
  b3:	89 c8                	mov    %ecx,%eax
  b5:	c3                   	ret
  b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bd:	8d 76 00             	lea    0x0(%esi),%esi

000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	89 d7                	mov    %edx,%edi
  cf:	fc                   	cld
  d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  d5:	89 d0                	mov    %edx,%eax
  d7:	c9                   	leave
  d8:	c3                   	ret
  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000e0 <strchr>:

char*
strchr(const char *s, char c)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ea:	0f b6 10             	movzbl (%eax),%edx
  ed:	84 d2                	test   %dl,%dl
  ef:	75 12                	jne    103 <strchr+0x23>
  f1:	eb 1d                	jmp    110 <strchr+0x30>
  f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f7:	90                   	nop
  f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  fc:	83 c0 01             	add    $0x1,%eax
  ff:	84 d2                	test   %dl,%dl
 101:	74 0d                	je     110 <strchr+0x30>
    if(*s == c)
 103:	38 d1                	cmp    %dl,%cl
 105:	75 f1                	jne    f8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 110:	31 c0                	xor    %eax,%eax
}
 112:	5d                   	pop    %ebp
 113:	c3                   	ret
 114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 11f:	90                   	nop

00000120 <gets>:

char*
gets(char *buf, int max)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 125:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 128:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 129:	31 db                	xor    %ebx,%ebx
{
 12b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 12e:	eb 27                	jmp    157 <gets+0x37>
    cc = read(0, &c, 1);
 130:	83 ec 04             	sub    $0x4,%esp
 133:	6a 01                	push   $0x1
 135:	56                   	push   %esi
 136:	6a 00                	push   $0x0
 138:	e8 1e 01 00 00       	call   25b <read>
    if(cc < 1)
 13d:	83 c4 10             	add    $0x10,%esp
 140:	85 c0                	test   %eax,%eax
 142:	7e 1d                	jle    161 <gets+0x41>
      break;
    buf[i++] = c;
 144:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 148:	8b 55 08             	mov    0x8(%ebp),%edx
 14b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 14f:	3c 0a                	cmp    $0xa,%al
 151:	74 10                	je     163 <gets+0x43>
 153:	3c 0d                	cmp    $0xd,%al
 155:	74 0c                	je     163 <gets+0x43>
  for(i=0; i+1 < max; ){
 157:	89 df                	mov    %ebx,%edi
 159:	83 c3 01             	add    $0x1,%ebx
 15c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 15f:	7c cf                	jl     130 <gets+0x10>
 161:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 16a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16d:	5b                   	pop    %ebx
 16e:	5e                   	pop    %esi
 16f:	5f                   	pop    %edi
 170:	5d                   	pop    %ebp
 171:	c3                   	ret
 172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000180 <stat>:

int
stat(const char *n, struct stat *st)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	56                   	push   %esi
 184:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 185:	83 ec 08             	sub    $0x8,%esp
 188:	6a 00                	push   $0x0
 18a:	ff 75 08             	push   0x8(%ebp)
 18d:	e8 f1 00 00 00       	call   283 <open>
  if(fd < 0)
 192:	83 c4 10             	add    $0x10,%esp
 195:	85 c0                	test   %eax,%eax
 197:	78 27                	js     1c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 199:	83 ec 08             	sub    $0x8,%esp
 19c:	ff 75 0c             	push   0xc(%ebp)
 19f:	89 c3                	mov    %eax,%ebx
 1a1:	50                   	push   %eax
 1a2:	e8 f4 00 00 00       	call   29b <fstat>
  close(fd);
 1a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1aa:	89 c6                	mov    %eax,%esi
  close(fd);
 1ac:	e8 ba 00 00 00       	call   26b <close>
  return r;
 1b1:	83 c4 10             	add    $0x10,%esp
}
 1b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b7:	89 f0                	mov    %esi,%eax
 1b9:	5b                   	pop    %ebx
 1ba:	5e                   	pop    %esi
 1bb:	5d                   	pop    %ebp
 1bc:	c3                   	ret
 1bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1c5:	eb ed                	jmp    1b4 <stat+0x34>
 1c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ce:	66 90                	xchg   %ax,%ax

000001d0 <atoi>:

int
atoi(const char *s)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	53                   	push   %ebx
 1d4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d7:	0f be 02             	movsbl (%edx),%eax
 1da:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1dd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 1e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 1e5:	77 1e                	ja     205 <atoi+0x35>
 1e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ee:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 1f0:	83 c2 01             	add    $0x1,%edx
 1f3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 1f6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 1fa:	0f be 02             	movsbl (%edx),%eax
 1fd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 200:	80 fb 09             	cmp    $0x9,%bl
 203:	76 eb                	jbe    1f0 <atoi+0x20>
  return n;
}
 205:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 208:	89 c8                	mov    %ecx,%eax
 20a:	c9                   	leave
 20b:	c3                   	ret
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000210 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	8b 45 10             	mov    0x10(%ebp),%eax
 217:	8b 55 08             	mov    0x8(%ebp),%edx
 21a:	56                   	push   %esi
 21b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 21e:	85 c0                	test   %eax,%eax
 220:	7e 13                	jle    235 <memmove+0x25>
 222:	01 d0                	add    %edx,%eax
  dst = vdst;
 224:	89 d7                	mov    %edx,%edi
 226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 230:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 231:	39 f8                	cmp    %edi,%eax
 233:	75 fb                	jne    230 <memmove+0x20>
  return vdst;
}
 235:	5e                   	pop    %esi
 236:	89 d0                	mov    %edx,%eax
 238:	5f                   	pop    %edi
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret

0000023b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 23b:	b8 01 00 00 00       	mov    $0x1,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret

00000243 <exit>:
SYSCALL(exit)
 243:	b8 02 00 00 00       	mov    $0x2,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret

0000024b <wait>:
SYSCALL(wait)
 24b:	b8 03 00 00 00       	mov    $0x3,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret

00000253 <pipe>:
SYSCALL(pipe)
 253:	b8 04 00 00 00       	mov    $0x4,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret

0000025b <read>:
SYSCALL(read)
 25b:	b8 05 00 00 00       	mov    $0x5,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret

00000263 <write>:
SYSCALL(write)
 263:	b8 10 00 00 00       	mov    $0x10,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret

0000026b <close>:
SYSCALL(close)
 26b:	b8 15 00 00 00       	mov    $0x15,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret

00000273 <kill>:
SYSCALL(kill)
 273:	b8 06 00 00 00       	mov    $0x6,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret

0000027b <exec>:
SYSCALL(exec)
 27b:	b8 07 00 00 00       	mov    $0x7,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <open>:
SYSCALL(open)
 283:	b8 0f 00 00 00       	mov    $0xf,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <mknod>:
SYSCALL(mknod)
 28b:	b8 11 00 00 00       	mov    $0x11,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <unlink>:
SYSCALL(unlink)
 293:	b8 12 00 00 00       	mov    $0x12,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <fstat>:
SYSCALL(fstat)
 29b:	b8 08 00 00 00       	mov    $0x8,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <link>:
SYSCALL(link)
 2a3:	b8 13 00 00 00       	mov    $0x13,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <mkdir>:
SYSCALL(mkdir)
 2ab:	b8 14 00 00 00       	mov    $0x14,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <chdir>:
SYSCALL(chdir)
 2b3:	b8 09 00 00 00       	mov    $0x9,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <dup>:
SYSCALL(dup)
 2bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <getpid>:
SYSCALL(getpid)
 2c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <sbrk>:
SYSCALL(sbrk)
 2cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <sleep>:
SYSCALL(sleep)
 2d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <uptime>:
SYSCALL(uptime)
 2db:	b8 0e 00 00 00       	mov    $0xe,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <symlink>:
SYSCALL(symlink)
 2e3:	b8 16 00 00 00       	mov    $0x16,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret
 2eb:	66 90                	xchg   %ax,%ax
 2ed:	66 90                	xchg   %ax,%ax
 2ef:	90                   	nop

000002f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	56                   	push   %esi
 2f5:	53                   	push   %ebx
 2f6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 2f8:	89 d1                	mov    %edx,%ecx
{
 2fa:	83 ec 3c             	sub    $0x3c,%esp
 2fd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 300:	85 d2                	test   %edx,%edx
 302:	0f 89 80 00 00 00    	jns    388 <printint+0x98>
 308:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 30c:	74 7a                	je     388 <printint+0x98>
    x = -xx;
 30e:	f7 d9                	neg    %ecx
    neg = 1;
 310:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 315:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 318:	31 f6                	xor    %esi,%esi
 31a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 320:	89 c8                	mov    %ecx,%eax
 322:	31 d2                	xor    %edx,%edx
 324:	89 f7                	mov    %esi,%edi
 326:	f7 f3                	div    %ebx
 328:	8d 76 01             	lea    0x1(%esi),%esi
 32b:	0f b6 92 18 07 00 00 	movzbl 0x718(%edx),%edx
 332:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 336:	89 ca                	mov    %ecx,%edx
 338:	89 c1                	mov    %eax,%ecx
 33a:	39 da                	cmp    %ebx,%edx
 33c:	73 e2                	jae    320 <printint+0x30>
  if(neg)
 33e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 341:	85 c0                	test   %eax,%eax
 343:	74 07                	je     34c <printint+0x5c>
    buf[i++] = '-';
 345:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
 34a:	89 f7                	mov    %esi,%edi
 34c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 34f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 352:	01 df                	add    %ebx,%edi
 354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  while(--i >= 0)
    putc(fd, buf[i]);
 358:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 35b:	83 ec 04             	sub    $0x4,%esp
 35e:	88 45 d7             	mov    %al,-0x29(%ebp)
 361:	8d 45 d7             	lea    -0x29(%ebp),%eax
 364:	6a 01                	push   $0x1
 366:	50                   	push   %eax
 367:	56                   	push   %esi
 368:	e8 f6 fe ff ff       	call   263 <write>
  while(--i >= 0)
 36d:	89 f8                	mov    %edi,%eax
 36f:	83 c4 10             	add    $0x10,%esp
 372:	83 ef 01             	sub    $0x1,%edi
 375:	39 d8                	cmp    %ebx,%eax
 377:	75 df                	jne    358 <printint+0x68>
}
 379:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37c:	5b                   	pop    %ebx
 37d:	5e                   	pop    %esi
 37e:	5f                   	pop    %edi
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret
 381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 388:	31 c0                	xor    %eax,%eax
 38a:	eb 89                	jmp    315 <printint+0x25>
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000390 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	53                   	push   %ebx
 396:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 399:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 39c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 39f:	0f b6 1e             	movzbl (%esi),%ebx
 3a2:	83 c6 01             	add    $0x1,%esi
 3a5:	84 db                	test   %bl,%bl
 3a7:	74 67                	je     410 <printf+0x80>
 3a9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3ac:	31 d2                	xor    %edx,%edx
 3ae:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 3b1:	eb 34                	jmp    3e7 <printf+0x57>
 3b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3b7:	90                   	nop
 3b8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 3bb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 3c0:	83 f8 25             	cmp    $0x25,%eax
 3c3:	74 18                	je     3dd <printf+0x4d>
  write(fd, &c, 1);
 3c5:	83 ec 04             	sub    $0x4,%esp
 3c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3cb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 3ce:	6a 01                	push   $0x1
 3d0:	50                   	push   %eax
 3d1:	57                   	push   %edi
 3d2:	e8 8c fe ff ff       	call   263 <write>
 3d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 3da:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 3dd:	0f b6 1e             	movzbl (%esi),%ebx
 3e0:	83 c6 01             	add    $0x1,%esi
 3e3:	84 db                	test   %bl,%bl
 3e5:	74 29                	je     410 <printf+0x80>
    c = fmt[i] & 0xff;
 3e7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3ea:	85 d2                	test   %edx,%edx
 3ec:	74 ca                	je     3b8 <printf+0x28>
      }
    } else if(state == '%'){
 3ee:	83 fa 25             	cmp    $0x25,%edx
 3f1:	75 ea                	jne    3dd <printf+0x4d>
      if(c == 'd'){
 3f3:	83 f8 25             	cmp    $0x25,%eax
 3f6:	0f 84 24 01 00 00    	je     520 <printf+0x190>
 3fc:	83 e8 63             	sub    $0x63,%eax
 3ff:	83 f8 15             	cmp    $0x15,%eax
 402:	77 1c                	ja     420 <printf+0x90>
 404:	ff 24 85 c0 06 00 00 	jmp    *0x6c0(,%eax,4)
 40b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 40f:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 410:	8d 65 f4             	lea    -0xc(%ebp),%esp
 413:	5b                   	pop    %ebx
 414:	5e                   	pop    %esi
 415:	5f                   	pop    %edi
 416:	5d                   	pop    %ebp
 417:	c3                   	ret
 418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41f:	90                   	nop
  write(fd, &c, 1);
 420:	83 ec 04             	sub    $0x4,%esp
 423:	8d 55 e7             	lea    -0x19(%ebp),%edx
 426:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 42a:	6a 01                	push   $0x1
 42c:	52                   	push   %edx
 42d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 430:	57                   	push   %edi
 431:	e8 2d fe ff ff       	call   263 <write>
 436:	83 c4 0c             	add    $0xc,%esp
 439:	88 5d e7             	mov    %bl,-0x19(%ebp)
 43c:	6a 01                	push   $0x1
 43e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 441:	52                   	push   %edx
 442:	57                   	push   %edi
 443:	e8 1b fe ff ff       	call   263 <write>
        putc(fd, c);
 448:	83 c4 10             	add    $0x10,%esp
      state = 0;
 44b:	31 d2                	xor    %edx,%edx
 44d:	eb 8e                	jmp    3dd <printf+0x4d>
 44f:	90                   	nop
        printint(fd, *ap, 16, 0);
 450:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 453:	83 ec 0c             	sub    $0xc,%esp
 456:	b9 10 00 00 00       	mov    $0x10,%ecx
 45b:	8b 13                	mov    (%ebx),%edx
 45d:	6a 00                	push   $0x0
 45f:	89 f8                	mov    %edi,%eax
        ap++;
 461:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 464:	e8 87 fe ff ff       	call   2f0 <printint>
        ap++;
 469:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 46c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 46f:	31 d2                	xor    %edx,%edx
 471:	e9 67 ff ff ff       	jmp    3dd <printf+0x4d>
 476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47d:	8d 76 00             	lea    0x0(%esi),%esi
        s = (char*)*ap;
 480:	8b 45 d0             	mov    -0x30(%ebp),%eax
 483:	8b 18                	mov    (%eax),%ebx
        ap++;
 485:	83 c0 04             	add    $0x4,%eax
 488:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 48b:	85 db                	test   %ebx,%ebx
 48d:	0f 84 9d 00 00 00    	je     530 <printf+0x1a0>
        while(*s != 0){
 493:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 496:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 498:	84 c0                	test   %al,%al
 49a:	0f 84 3d ff ff ff    	je     3dd <printf+0x4d>
 4a0:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4a3:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4a6:	89 de                	mov    %ebx,%esi
 4a8:	89 d3                	mov    %edx,%ebx
 4aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 4b0:	83 ec 04             	sub    $0x4,%esp
 4b3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 4b6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 4b9:	6a 01                	push   $0x1
 4bb:	53                   	push   %ebx
 4bc:	57                   	push   %edi
 4bd:	e8 a1 fd ff ff       	call   263 <write>
        while(*s != 0){
 4c2:	0f b6 06             	movzbl (%esi),%eax
 4c5:	83 c4 10             	add    $0x10,%esp
 4c8:	84 c0                	test   %al,%al
 4ca:	75 e4                	jne    4b0 <printf+0x120>
      state = 0;
 4cc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 4cf:	31 d2                	xor    %edx,%edx
 4d1:	e9 07 ff ff ff       	jmp    3dd <printf+0x4d>
 4d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4e0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4e3:	83 ec 0c             	sub    $0xc,%esp
 4e6:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4eb:	8b 13                	mov    (%ebx),%edx
 4ed:	6a 01                	push   $0x1
 4ef:	e9 6b ff ff ff       	jmp    45f <printf+0xcf>
 4f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 4f8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 4fb:	83 ec 04             	sub    $0x4,%esp
 4fe:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 501:	8b 03                	mov    (%ebx),%eax
        ap++;
 503:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 506:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 509:	6a 01                	push   $0x1
 50b:	52                   	push   %edx
 50c:	57                   	push   %edi
 50d:	e8 51 fd ff ff       	call   263 <write>
        ap++;
 512:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 515:	83 c4 10             	add    $0x10,%esp
      state = 0;
 518:	31 d2                	xor    %edx,%edx
 51a:	e9 be fe ff ff       	jmp    3dd <printf+0x4d>
 51f:	90                   	nop
  write(fd, &c, 1);
 520:	83 ec 04             	sub    $0x4,%esp
 523:	88 5d e7             	mov    %bl,-0x19(%ebp)
 526:	8d 55 e7             	lea    -0x19(%ebp),%edx
 529:	6a 01                	push   $0x1
 52b:	e9 11 ff ff ff       	jmp    441 <printf+0xb1>
 530:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 535:	bb b8 06 00 00       	mov    $0x6b8,%ebx
 53a:	e9 61 ff ff ff       	jmp    4a0 <printf+0x110>
 53f:	90                   	nop

00000540 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 540:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 541:	a1 90 09 00 00       	mov    0x990,%eax
{
 546:	89 e5                	mov    %esp,%ebp
 548:	57                   	push   %edi
 549:	56                   	push   %esi
 54a:	53                   	push   %ebx
 54b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 54e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 558:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 55a:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 55c:	39 ca                	cmp    %ecx,%edx
 55e:	73 30                	jae    590 <free+0x50>
 560:	39 c1                	cmp    %eax,%ecx
 562:	72 04                	jb     568 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 564:	39 c2                	cmp    %eax,%edx
 566:	72 f0                	jb     558 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 568:	8b 73 fc             	mov    -0x4(%ebx),%esi
 56b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 56e:	39 f8                	cmp    %edi,%eax
 570:	74 2e                	je     5a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 572:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 575:	8b 42 04             	mov    0x4(%edx),%eax
 578:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 57b:	39 f1                	cmp    %esi,%ecx
 57d:	74 38                	je     5b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 57f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 581:	5b                   	pop    %ebx
  freep = p;
 582:	89 15 90 09 00 00    	mov    %edx,0x990
}
 588:	5e                   	pop    %esi
 589:	5f                   	pop    %edi
 58a:	5d                   	pop    %ebp
 58b:	c3                   	ret
 58c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 590:	39 c1                	cmp    %eax,%ecx
 592:	72 d0                	jb     564 <free+0x24>
 594:	eb c2                	jmp    558 <free+0x18>
 596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 59d:	8d 76 00             	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 5a0:	03 70 04             	add    0x4(%eax),%esi
 5a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a6:	8b 02                	mov    (%edx),%eax
 5a8:	8b 00                	mov    (%eax),%eax
 5aa:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ad:	8b 42 04             	mov    0x4(%edx),%eax
 5b0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5b3:	39 f1                	cmp    %esi,%ecx
 5b5:	75 c8                	jne    57f <free+0x3f>
    p->s.size += bp->s.size;
 5b7:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 5ba:	89 15 90 09 00 00    	mov    %edx,0x990
    p->s.size += bp->s.size;
 5c0:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5c3:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5c6:	89 0a                	mov    %ecx,(%edx)
}
 5c8:	5b                   	pop    %ebx
 5c9:	5e                   	pop    %esi
 5ca:	5f                   	pop    %edi
 5cb:	5d                   	pop    %ebp
 5cc:	c3                   	ret
 5cd:	8d 76 00             	lea    0x0(%esi),%esi

000005d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
 5d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 5dc:	8b 15 90 09 00 00    	mov    0x990,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e2:	8d 78 07             	lea    0x7(%eax),%edi
 5e5:	c1 ef 03             	shr    $0x3,%edi
 5e8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 5eb:	85 d2                	test   %edx,%edx
 5ed:	0f 84 8d 00 00 00    	je     680 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5f5:	8b 48 04             	mov    0x4(%eax),%ecx
 5f8:	39 f9                	cmp    %edi,%ecx
 5fa:	73 64                	jae    660 <malloc+0x90>
  if(nu < 4096)
 5fc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 601:	39 df                	cmp    %ebx,%edi
 603:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 606:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 60d:	eb 0a                	jmp    619 <malloc+0x49>
 60f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 610:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 612:	8b 48 04             	mov    0x4(%eax),%ecx
 615:	39 f9                	cmp    %edi,%ecx
 617:	73 47                	jae    660 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 619:	89 c2                	mov    %eax,%edx
 61b:	39 05 90 09 00 00    	cmp    %eax,0x990
 621:	75 ed                	jne    610 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 623:	83 ec 0c             	sub    $0xc,%esp
 626:	56                   	push   %esi
 627:	e8 9f fc ff ff       	call   2cb <sbrk>
  if(p == (char*)-1)
 62c:	83 c4 10             	add    $0x10,%esp
 62f:	83 f8 ff             	cmp    $0xffffffff,%eax
 632:	74 1c                	je     650 <malloc+0x80>
  hp->s.size = nu;
 634:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 637:	83 ec 0c             	sub    $0xc,%esp
 63a:	83 c0 08             	add    $0x8,%eax
 63d:	50                   	push   %eax
 63e:	e8 fd fe ff ff       	call   540 <free>
  return freep;
 643:	8b 15 90 09 00 00    	mov    0x990,%edx
      if((p = morecore(nunits)) == 0)
 649:	83 c4 10             	add    $0x10,%esp
 64c:	85 d2                	test   %edx,%edx
 64e:	75 c0                	jne    610 <malloc+0x40>
        return 0;
  }
}
 650:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 653:	31 c0                	xor    %eax,%eax
}
 655:	5b                   	pop    %ebx
 656:	5e                   	pop    %esi
 657:	5f                   	pop    %edi
 658:	5d                   	pop    %ebp
 659:	c3                   	ret
 65a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 660:	39 cf                	cmp    %ecx,%edi
 662:	74 4c                	je     6b0 <malloc+0xe0>
        p->s.size -= nunits;
 664:	29 f9                	sub    %edi,%ecx
 666:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 669:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 66c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 66f:	89 15 90 09 00 00    	mov    %edx,0x990
}
 675:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 678:	83 c0 08             	add    $0x8,%eax
}
 67b:	5b                   	pop    %ebx
 67c:	5e                   	pop    %esi
 67d:	5f                   	pop    %edi
 67e:	5d                   	pop    %ebp
 67f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 680:	c7 05 90 09 00 00 94 	movl   $0x994,0x990
 687:	09 00 00 
    base.s.size = 0;
 68a:	b8 94 09 00 00       	mov    $0x994,%eax
    base.s.ptr = freep = prevp = &base;
 68f:	c7 05 94 09 00 00 94 	movl   $0x994,0x994
 696:	09 00 00 
    base.s.size = 0;
 699:	c7 05 98 09 00 00 00 	movl   $0x0,0x998
 6a0:	00 00 00 
    if(p->s.size >= nunits){
 6a3:	e9 54 ff ff ff       	jmp    5fc <malloc+0x2c>
 6a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6af:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 6b0:	8b 08                	mov    (%eax),%ecx
 6b2:	89 0a                	mov    %ecx,(%edx)
 6b4:	eb b9                	jmp    66f <malloc+0x9f>
