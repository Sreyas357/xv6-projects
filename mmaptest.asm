
_mmaptest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#define MAP_FAILED ((char *) -1)

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  mmap_test();
  11:	e8 7a 01 00 00       	call   190 <mmap_test>
  fork_test();
  16:	e8 25 07 00 00       	call   740 <fork_test>
  printf(1,"mmaptest: all tests succeeded\n");
  1b:	83 ec 08             	sub    $0x8,%esp
  1e:	68 e0 0f 00 00       	push   $0xfe0
  23:	6a 01                	push   $0x1
  25:	e8 f6 0b 00 00       	call   c20 <printf>
  exit();
  2a:	e8 94 0a 00 00       	call   ac3 <exit>
  2f:	90                   	nop

00000030 <err>:

char *testname = "???";

void
err(char *why)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	83 ec 08             	sub    $0x8,%esp
  printf(1,"mmaptest: %s failed: %s, pid=%d\n", testname, why, getpid());
  36:	e8 08 0b 00 00       	call   b43 <getpid>
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	50                   	push   %eax
  3f:	ff 75 08             	push   0x8(%ebp)
  42:	ff 35 ac 16 00 00    	push   0x16ac
  48:	68 48 0f 00 00       	push   $0xf48
  4d:	6a 01                	push   $0x1
  4f:	e8 cc 0b 00 00       	call   c20 <printf>
  exit();
  54:	83 c4 20             	add    $0x20,%esp
  57:	e8 67 0a 00 00       	call   ac3 <exit>
  5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000060 <_v1>:
//
// check the content of the two mapped pages.
//
void
_v1(char *p)
{
  60:	55                   	push   %ebp
  int i;
  for (i = 0; i < PGSIZE*2; i++) {
  61:	31 c0                	xor    %eax,%eax
{
  63:	89 e5                	mov    %esp,%ebp
  65:	83 ec 08             	sub    $0x8,%esp
  68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  6f:	90                   	nop
    if (i < PGSIZE + (PGSIZE/2)) {
      if (p[i] != 'A') {
  70:	0f be 14 01          	movsbl (%ecx,%eax,1),%edx
    if (i < PGSIZE + (PGSIZE/2)) {
  74:	3d ff 17 00 00       	cmp    $0x17ff,%eax
  79:	7f 13                	jg     8e <_v1+0x2e>
      if (p[i] != 'A') {
  7b:	80 fa 41             	cmp    $0x41,%dl
  7e:	75 1e                	jne    9e <_v1+0x3e>
  for (i = 0; i < PGSIZE*2; i++) {
  80:	83 c0 01             	add    $0x1,%eax
      if (p[i] != 'A') {
  83:	0f be 14 01          	movsbl (%ecx,%eax,1),%edx
    if (i < PGSIZE + (PGSIZE/2)) {
  87:	3d ff 17 00 00       	cmp    $0x17ff,%eax
  8c:	7e ed                	jle    7b <_v1+0x1b>
        printf(1,"mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
        err("v1 mismatch (1)");
      }
    } else {
      if (p[i] != 0) {
  8e:	84 d2                	test   %dl,%dl
  90:	75 26                	jne    b8 <_v1+0x58>
  for (i = 0; i < PGSIZE*2; i++) {
  92:	83 c0 01             	add    $0x1,%eax
  95:	3d 00 20 00 00       	cmp    $0x2000,%eax
  9a:	75 d4                	jne    70 <_v1+0x10>
        printf(1,"mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
        err("v1 mismatch (2)");
      }
    }
  }
}
  9c:	c9                   	leave
  9d:	c3                   	ret
        printf(1,"mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
  9e:	52                   	push   %edx
  9f:	50                   	push   %eax
  a0:	68 6c 0f 00 00       	push   $0xf6c
  a5:	6a 01                	push   $0x1
  a7:	e8 74 0b 00 00       	call   c20 <printf>
        err("v1 mismatch (1)");
  ac:	c7 04 24 ff 0f 00 00 	movl   $0xfff,(%esp)
  b3:	e8 78 ff ff ff       	call   30 <err>
        printf(1,"mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
  b8:	52                   	push   %edx
  b9:	50                   	push   %eax
  ba:	68 94 0f 00 00       	push   $0xf94
  bf:	6a 01                	push   $0x1
  c1:	e8 5a 0b 00 00       	call   c20 <printf>
        err("v1 mismatch (2)");
  c6:	c7 04 24 0f 10 00 00 	movl   $0x100f,(%esp)
  cd:	e8 5e ff ff ff       	call   30 <err>
  d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000e0 <makefile>:
// create a file to be mapped, containing
// 1.5 pages of 'A' and half a page of zeros.
//
void
makefile(const char *f)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	56                   	push   %esi
  e4:	53                   	push   %ebx
  e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;
  int n = PGSIZE/BSIZE;

  unlink(f);
  e8:	83 ec 0c             	sub    $0xc,%esp
  eb:	53                   	push   %ebx
  ec:	e8 22 0a 00 00       	call   b13 <unlink>
  int fd = open(f, O_WRONLY | O_CREATE);
  f1:	58                   	pop    %eax
  f2:	5a                   	pop    %edx
  f3:	68 01 02 00 00       	push   $0x201
  f8:	53                   	push   %ebx
  f9:	e8 05 0a 00 00       	call   b03 <open>
  if (fd == -1)
  fe:	83 c4 10             	add    $0x10,%esp
 101:	83 f8 ff             	cmp    $0xffffffff,%eax
 104:	74 69                	je     16f <makefile+0x8f>
    err("open");
  memset(buf, 'A', BSIZE);
 106:	83 ec 04             	sub    $0x4,%esp
 109:	89 c6                	mov    %eax,%esi
 10b:	bb 0c 00 00 00       	mov    $0xc,%ebx
 110:	68 00 02 00 00       	push   $0x200
 115:	6a 41                	push   $0x41
 117:	68 c0 16 00 00       	push   $0x16c0
 11c:	e8 1f 08 00 00       	call   940 <memset>
 121:	83 c4 10             	add    $0x10,%esp
 124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  // write 1.5 page
  for (i = 0; i < n + n/2; i++) {
    if (write(fd, buf, BSIZE) != BSIZE)
 128:	83 ec 04             	sub    $0x4,%esp
 12b:	68 00 02 00 00       	push   $0x200
 130:	68 c0 16 00 00       	push   $0x16c0
 135:	56                   	push   %esi
 136:	e8 a8 09 00 00       	call   ae3 <write>
 13b:	83 c4 10             	add    $0x10,%esp
 13e:	3d 00 02 00 00       	cmp    $0x200,%eax
 143:	75 1d                	jne    162 <makefile+0x82>
  for (i = 0; i < n + n/2; i++) {
 145:	83 eb 01             	sub    $0x1,%ebx
 148:	75 de                	jne    128 <makefile+0x48>
      err("write 0 makefile");
  }
  if (close(fd) == -1)
 14a:	83 ec 0c             	sub    $0xc,%esp
 14d:	56                   	push   %esi
 14e:	e8 98 09 00 00       	call   aeb <close>
 153:	83 c4 10             	add    $0x10,%esp
 156:	83 f8 ff             	cmp    $0xffffffff,%eax
 159:	74 21                	je     17c <makefile+0x9c>
    err("close");
}
 15b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 15e:	5b                   	pop    %ebx
 15f:	5e                   	pop    %esi
 160:	5d                   	pop    %ebp
 161:	c3                   	ret
      err("write 0 makefile");
 162:	83 ec 0c             	sub    $0xc,%esp
 165:	68 24 10 00 00       	push   $0x1024
 16a:	e8 c1 fe ff ff       	call   30 <err>
    err("open");
 16f:	83 ec 0c             	sub    $0xc,%esp
 172:	68 1f 10 00 00       	push   $0x101f
 177:	e8 b4 fe ff ff       	call   30 <err>
    err("close");
 17c:	83 ec 0c             	sub    $0xc,%esp
 17f:	68 35 10 00 00       	push   $0x1035
 184:	e8 a7 fe ff ff       	call   30 <err>
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <mmap_test>:

void
mmap_test(void)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	56                   	push   %esi
 195:	53                   	push   %ebx
 196:	83 ec 34             	sub    $0x34,%esp
  int fd;
  int i;
  const char * const f = "mmap.dur";
  printf(1,"mmap_test starting\n");
 199:	68 3b 10 00 00       	push   $0x103b
 19e:	6a 01                	push   $0x1
 1a0:	e8 7b 0a 00 00       	call   c20 <printf>
  testname = "mmap_test";
 1a5:	c7 05 ac 16 00 00 4f 	movl   $0x104f,0x16ac
 1ac:	10 00 00 
  //
  // create a file with known content, map it into memory, check that
  // the mapped memory has the same bytes as originally written to the
  // file.
  //
  makefile(f);
 1af:	c7 04 24 59 10 00 00 	movl   $0x1059,(%esp)
 1b6:	e8 25 ff ff ff       	call   e0 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
 1bb:	59                   	pop    %ecx
 1bc:	5b                   	pop    %ebx
 1bd:	6a 00                	push   $0x0
 1bf:	68 59 10 00 00       	push   $0x1059
 1c4:	e8 3a 09 00 00       	call   b03 <open>
 1c9:	83 c4 10             	add    $0x10,%esp
 1cc:	83 f8 ff             	cmp    $0xffffffff,%eax
 1cf:	0f 84 c3 04 00 00    	je     698 <mmap_test+0x508>
    err("open");

  printf(1,"test mmap f\n");
 1d5:	83 ec 08             	sub    $0x8,%esp
 1d8:	89 c6                	mov    %eax,%esi
 1da:	68 62 10 00 00       	push   $0x1062
 1df:	6a 01                	push   $0x1
 1e1:	e8 3a 0a 00 00       	call   c20 <printf>
  // same file (of course in this case updates are prohibited
  // due to PROT_READ). the fifth argument is the file descriptor
  // of the file to be mapped. the last argument is the starting
  // offset in the file.
  //
  char *p = (char*)mmap(0, PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
 1e6:	58                   	pop    %eax
 1e7:	5a                   	pop    %edx
 1e8:	6a 00                	push   $0x0
 1ea:	56                   	push   %esi
 1eb:	6a 02                	push   $0x2
 1ed:	6a 01                	push   $0x1
 1ef:	68 00 20 00 00       	push   $0x2000
 1f4:	6a 00                	push   $0x0
 1f6:	e8 68 09 00 00       	call   b63 <mmap>
  
  
  if (p == MAP_FAILED){
 1fb:	83 c4 20             	add    $0x20,%esp
  char *p = (char*)mmap(0, PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
 1fe:	89 c3                	mov    %eax,%ebx
  if (p == MAP_FAILED){
 200:	83 f8 ff             	cmp    $0xffffffff,%eax
 203:	0f 84 ea 04 00 00    	je     6f3 <mmap_test+0x563>
    
    err("mmap (1)");
  }
  _v1(p);
 209:	83 ec 0c             	sub    $0xc,%esp
 20c:	50                   	push   %eax
 20d:	e8 4e fe ff ff       	call   60 <_v1>
  if (munmap(p, PGSIZE*2) == -1){
 212:	5f                   	pop    %edi
 213:	58                   	pop    %eax
 214:	68 00 20 00 00       	push   $0x2000
 219:	53                   	push   %ebx
 21a:	e8 4c 09 00 00       	call   b6b <munmap>
 21f:	83 c4 10             	add    $0x10,%esp
 222:	83 f8 ff             	cmp    $0xffffffff,%eax
 225:	0f 84 bb 04 00 00    	je     6e6 <mmap_test+0x556>
    err("munmap (1)");
  }

  printf(1,"test mmap f: OK\n");
 22b:	83 ec 08             	sub    $0x8,%esp
 22e:	68 83 10 00 00       	push   $0x1083
 233:	6a 01                	push   $0x1
 235:	e8 e6 09 00 00       	call   c20 <printf>
    
  printf(1,"test mmap private\n");
 23a:	58                   	pop    %eax
 23b:	5a                   	pop    %edx
 23c:	68 94 10 00 00       	push   $0x1094
 241:	6a 01                	push   $0x1
 243:	e8 d8 09 00 00       	call   c20 <printf>
  // should be able to map file opened read-only with private writable
  // mapping
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
 248:	59                   	pop    %ecx
 249:	5b                   	pop    %ebx
 24a:	6a 00                	push   $0x0
 24c:	56                   	push   %esi
 24d:	6a 02                	push   $0x2
 24f:	6a 03                	push   $0x3
 251:	68 00 20 00 00       	push   $0x2000
 256:	6a 00                	push   $0x0
 258:	e8 06 09 00 00       	call   b63 <mmap>
  if (p == MAP_FAILED)
 25d:	83 c4 20             	add    $0x20,%esp
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
 260:	89 c3                	mov    %eax,%ebx
  if (p == MAP_FAILED)
 262:	83 f8 ff             	cmp    $0xffffffff,%eax
 265:	0f 84 6e 04 00 00    	je     6d9 <mmap_test+0x549>
    err("mmap (2)");
  if (close(fd) == -1)
 26b:	83 ec 0c             	sub    $0xc,%esp
 26e:	56                   	push   %esi
 26f:	e8 77 08 00 00       	call   aeb <close>
 274:	83 c4 10             	add    $0x10,%esp
 277:	83 f8 ff             	cmp    $0xffffffff,%eax
 27a:	0f 84 4c 04 00 00    	je     6cc <mmap_test+0x53c>
    err("close");
  _v1(p);
 280:	83 ec 0c             	sub    $0xc,%esp
 283:	53                   	push   %ebx
 284:	e8 d7 fd ff ff       	call   60 <_v1>
  for (i = 0; i < PGSIZE*2; i++)
 289:	89 d8                	mov    %ebx,%eax
 28b:	8d 93 00 20 00 00    	lea    0x2000(%ebx),%edx
 291:	83 c4 10             	add    $0x10,%esp
 294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p[i] = 'Z';
 298:	c6 00 5a             	movb   $0x5a,(%eax)
  for (i = 0; i < PGSIZE*2; i++)
 29b:	83 c0 01             	add    $0x1,%eax
 29e:	39 c2                	cmp    %eax,%edx
 2a0:	75 f6                	jne    298 <mmap_test+0x108>
  if (munmap(p, PGSIZE*2) == -1)
 2a2:	83 ec 08             	sub    $0x8,%esp
 2a5:	68 00 20 00 00       	push   $0x2000
 2aa:	53                   	push   %ebx
 2ab:	e8 bb 08 00 00       	call   b6b <munmap>
 2b0:	83 c4 10             	add    $0x10,%esp
 2b3:	83 f8 ff             	cmp    $0xffffffff,%eax
 2b6:	0f 84 6b 04 00 00    	je     727 <mmap_test+0x597>
    err("munmap (2)");

  printf(1,"test mmap private: OK\n");
 2bc:	83 ec 08             	sub    $0x8,%esp
 2bf:	68 bb 10 00 00       	push   $0x10bb
 2c4:	6a 01                	push   $0x1
 2c6:	e8 55 09 00 00       	call   c20 <printf>
    
  printf(1,"test mmap read-only\n");
 2cb:	59                   	pop    %ecx
 2cc:	5b                   	pop    %ebx
 2cd:	68 d2 10 00 00       	push   $0x10d2
 2d2:	6a 01                	push   $0x1
 2d4:	e8 47 09 00 00       	call   c20 <printf>
    
  // check that mmap doesn't allow read/write mapping of a
  // file opened read-only.
  if ((fd = open(f, O_RDONLY)) == -1)
 2d9:	5e                   	pop    %esi
 2da:	5f                   	pop    %edi
 2db:	6a 00                	push   $0x0
 2dd:	68 59 10 00 00       	push   $0x1059
 2e2:	e8 1c 08 00 00       	call   b03 <open>
 2e7:	83 c4 10             	add    $0x10,%esp
 2ea:	89 c3                	mov    %eax,%ebx
 2ec:	83 f8 ff             	cmp    $0xffffffff,%eax
 2ef:	0f 84 a3 03 00 00    	je     698 <mmap_test+0x508>
    err("open");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
 2f5:	83 ec 08             	sub    $0x8,%esp
 2f8:	6a 00                	push   $0x0
 2fa:	50                   	push   %eax
 2fb:	6a 01                	push   $0x1
 2fd:	6a 03                	push   $0x3
 2ff:	68 00 30 00 00       	push   $0x3000
 304:	6a 00                	push   $0x0
 306:	e8 58 08 00 00       	call   b63 <mmap>
  if (p != MAP_FAILED)
 30b:	83 c4 20             	add    $0x20,%esp
 30e:	83 f8 ff             	cmp    $0xffffffff,%eax
 311:	0f 85 03 04 00 00    	jne    71a <mmap_test+0x58a>
    err("mmap call should have failed");
  if (close(fd) == -1)
 317:	83 ec 0c             	sub    $0xc,%esp
 31a:	53                   	push   %ebx
 31b:	e8 cb 07 00 00       	call   aeb <close>
 320:	83 c4 10             	add    $0x10,%esp
 323:	83 f8 ff             	cmp    $0xffffffff,%eax
 326:	0f 84 a0 03 00 00    	je     6cc <mmap_test+0x53c>
    err("close");

  printf(1,"test mmap read-only: OK\n");
 32c:	83 ec 08             	sub    $0x8,%esp
 32f:	68 04 11 00 00       	push   $0x1104
 334:	6a 01                	push   $0x1
 336:	e8 e5 08 00 00       	call   c20 <printf>
    
  printf(1,"test mmap read/write\n");
 33b:	5e                   	pop    %esi
 33c:	5f                   	pop    %edi
 33d:	68 1d 11 00 00       	push   $0x111d
 342:	6a 01                	push   $0x1
 344:	e8 d7 08 00 00       	call   c20 <printf>
  
  // check that mmap does allow read/write mapping of a
  // file opened read/write.
  if ((fd = open(f, O_RDWR)) == -1)
 349:	58                   	pop    %eax
 34a:	5a                   	pop    %edx
 34b:	6a 02                	push   $0x2
 34d:	68 59 10 00 00       	push   $0x1059
 352:	e8 ac 07 00 00       	call   b03 <open>
 357:	83 c4 10             	add    $0x10,%esp
 35a:	89 c6                	mov    %eax,%esi
 35c:	83 f8 ff             	cmp    $0xffffffff,%eax
 35f:	0f 84 33 03 00 00    	je     698 <mmap_test+0x508>
    err("open");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
 365:	83 ec 08             	sub    $0x8,%esp
 368:	6a 00                	push   $0x0
 36a:	50                   	push   %eax
 36b:	6a 01                	push   $0x1
 36d:	6a 03                	push   $0x3
 36f:	68 00 30 00 00       	push   $0x3000
 374:	6a 00                	push   $0x0
 376:	e8 e8 07 00 00       	call   b63 <mmap>
  if (p == MAP_FAILED)
 37b:	83 c4 20             	add    $0x20,%esp
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
 37e:	89 c3                	mov    %eax,%ebx
  if (p == MAP_FAILED)
 380:	83 f8 ff             	cmp    $0xffffffff,%eax
 383:	0f 84 84 03 00 00    	je     70d <mmap_test+0x57d>
    err("mmap (3)");
  if (close(fd) == -1)
 389:	83 ec 0c             	sub    $0xc,%esp
 38c:	56                   	push   %esi
 38d:	e8 59 07 00 00       	call   aeb <close>
 392:	83 c4 10             	add    $0x10,%esp
 395:	83 f8 ff             	cmp    $0xffffffff,%eax
 398:	0f 84 2e 03 00 00    	je     6cc <mmap_test+0x53c>
    err("close");

  // check that the mapping still works after close(fd).
  _v1(p);
 39e:	83 ec 0c             	sub    $0xc,%esp
 3a1:	8d bb 00 20 00 00    	lea    0x2000(%ebx),%edi
 3a7:	53                   	push   %ebx
 3a8:	e8 b3 fc ff ff       	call   60 <_v1>

  // write the mapped memory.
  for (i = 0; i < PGSIZE*2; i++)
 3ad:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 3b0:	89 d8                	mov    %ebx,%eax
 3b2:	83 c4 10             	add    $0x10,%esp
 3b5:	8d 76 00             	lea    0x0(%esi),%esi
    p[i] = 'Z';
 3b8:	c6 00 5a             	movb   $0x5a,(%eax)
  for (i = 0; i < PGSIZE*2; i++)
 3bb:	83 c0 01             	add    $0x1,%eax
 3be:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
 3c1:	75 f5                	jne    3b8 <mmap_test+0x228>

  // unmap just the first two of three pages of mapped memory.
  if (munmap(p, PGSIZE*2) == -1)
 3c3:	83 ec 08             	sub    $0x8,%esp
 3c6:	68 00 20 00 00       	push   $0x2000
 3cb:	53                   	push   %ebx
 3cc:	e8 9a 07 00 00       	call   b6b <munmap>
 3d1:	83 c4 10             	add    $0x10,%esp
 3d4:	83 f8 ff             	cmp    $0xffffffff,%eax
 3d7:	0f 84 23 03 00 00    	je     700 <mmap_test+0x570>
    err("munmap (3)");
  
  printf(1,"test mmap read/write: OK\n");
 3dd:	83 ec 08             	sub    $0x8,%esp
 3e0:	68 47 11 00 00       	push   $0x1147
 3e5:	6a 01                	push   $0x1
 3e7:	e8 34 08 00 00       	call   c20 <printf>
  
  printf(1,"test mmap dirty\n");
 3ec:	58                   	pop    %eax
 3ed:	5a                   	pop    %edx
 3ee:	68 61 11 00 00       	push   $0x1161
 3f3:	6a 01                	push   $0x1
 3f5:	e8 26 08 00 00       	call   c20 <printf>
  
  // check that the writes to the mapped memory were
  // written to the file.
  if ((fd = open(f, O_RDWR)) == -1)
 3fa:	59                   	pop    %ecx
 3fb:	5b                   	pop    %ebx
 3fc:	6a 02                	push   $0x2
 3fe:	68 59 10 00 00       	push   $0x1059
 403:	e8 fb 06 00 00       	call   b03 <open>
 408:	83 c4 10             	add    $0x10,%esp
 40b:	89 c6                	mov    %eax,%esi
 40d:	83 f8 ff             	cmp    $0xffffffff,%eax
 410:	0f 84 82 02 00 00    	je     698 <mmap_test+0x508>
 416:	bb 00 18 00 00       	mov    $0x1800,%ebx
 41b:	8d 7d e7             	lea    -0x19(%ebp),%edi
 41e:	66 90                	xchg   %ax,%ax
    err("open");
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){
    char b;
    if (read(fd, &b, 1) != 1)
 420:	83 ec 04             	sub    $0x4,%esp
 423:	6a 01                	push   $0x1
 425:	57                   	push   %edi
 426:	56                   	push   %esi
 427:	e8 af 06 00 00       	call   adb <read>
 42c:	83 c4 10             	add    $0x10,%esp
 42f:	83 f8 01             	cmp    $0x1,%eax
 432:	0f 85 eb 01 00 00    	jne    623 <mmap_test+0x493>
      err("read (1)");
    if (b != 'Z')
 438:	80 7d e7 5a          	cmpb   $0x5a,-0x19(%ebp)
 43c:	0f 85 ee 01 00 00    	jne    630 <mmap_test+0x4a0>
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){
 442:	83 eb 01             	sub    $0x1,%ebx
 445:	75 d9                	jne    420 <mmap_test+0x290>
      err("file does not contain modifications");
  }
  if (close(fd) == -1)
 447:	83 ec 0c             	sub    $0xc,%esp
 44a:	56                   	push   %esi
 44b:	e8 9b 06 00 00       	call   aeb <close>
 450:	83 c4 10             	add    $0x10,%esp
 453:	83 f8 ff             	cmp    $0xffffffff,%eax
 456:	0f 84 70 02 00 00    	je     6cc <mmap_test+0x53c>
    err("close");

  printf(1,"test mmap dirty: OK\n");
 45c:	83 ec 08             	sub    $0x8,%esp
 45f:	68 7b 11 00 00       	push   $0x117b
 464:	6a 01                	push   $0x1
 466:	e8 b5 07 00 00       	call   c20 <printf>

  printf(1,"test not-mapped unmap\n");
 46b:	59                   	pop    %ecx
 46c:	5b                   	pop    %ebx
 46d:	68 90 11 00 00       	push   $0x1190
 472:	6a 01                	push   $0x1
 474:	e8 a7 07 00 00       	call   c20 <printf>
  
  // unmap the rest of the mapped memory.
  if (munmap(p+PGSIZE*2, PGSIZE) == -1)
 479:	5e                   	pop    %esi
 47a:	5f                   	pop    %edi
 47b:	68 00 10 00 00       	push   $0x1000
 480:	ff 75 d4             	push   -0x2c(%ebp)
 483:	e8 e3 06 00 00       	call   b6b <munmap>
 488:	83 c4 10             	add    $0x10,%esp
 48b:	83 f8 ff             	cmp    $0xffffffff,%eax
 48e:	0f 84 a9 01 00 00    	je     63d <mmap_test+0x4ad>
    err("munmap (4)");

  printf(1,"test not-mapped unmap: OK\n");
 494:	83 ec 08             	sub    $0x8,%esp
 497:	68 b2 11 00 00       	push   $0x11b2
 49c:	6a 01                	push   $0x1
 49e:	e8 7d 07 00 00       	call   c20 <printf>
    
  printf(1,"test mmap two files\n");
 4a3:	5e                   	pop    %esi
 4a4:	5f                   	pop    %edi
 4a5:	68 cd 11 00 00       	push   $0x11cd
 4aa:	6a 01                	push   $0x1
 4ac:	e8 6f 07 00 00       	call   c20 <printf>
  
  //
  // mmap two files at the same time.
  //
  int fd1;
  if((fd1 = open("mmap1", O_RDWR|O_CREATE)) < 0)
 4b1:	58                   	pop    %eax
 4b2:	5a                   	pop    %edx
 4b3:	68 02 02 00 00       	push   $0x202
 4b8:	68 f9 11 00 00       	push   $0x11f9
 4bd:	e8 41 06 00 00       	call   b03 <open>
 4c2:	83 c4 10             	add    $0x10,%esp
 4c5:	89 c3                	mov    %eax,%ebx
 4c7:	85 c0                	test   %eax,%eax
 4c9:	0f 88 88 01 00 00    	js     657 <mmap_test+0x4c7>
    err("open mmap1");
  if(write(fd1, "12345", 5) != 5)
 4cf:	83 ec 04             	sub    $0x4,%esp
 4d2:	6a 05                	push   $0x5
 4d4:	68 ed 11 00 00       	push   $0x11ed
 4d9:	50                   	push   %eax
 4da:	e8 04 06 00 00       	call   ae3 <write>
 4df:	83 c4 10             	add    $0x10,%esp
 4e2:	83 f8 05             	cmp    $0x5,%eax
 4e5:	0f 85 5f 01 00 00    	jne    64a <mmap_test+0x4ba>
    err("write mmap1");
  char *p1 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
 4eb:	83 ec 08             	sub    $0x8,%esp
 4ee:	6a 00                	push   $0x0
 4f0:	53                   	push   %ebx
 4f1:	6a 02                	push   $0x2
 4f3:	6a 01                	push   $0x1
 4f5:	68 00 10 00 00       	push   $0x1000
 4fa:	6a 00                	push   $0x0
 4fc:	e8 62 06 00 00       	call   b63 <mmap>
  if(p1 == MAP_FAILED)
 501:	83 c4 20             	add    $0x20,%esp
  char *p1 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
 504:	89 c7                	mov    %eax,%edi
  if(p1 == MAP_FAILED)
 506:	83 f8 ff             	cmp    $0xffffffff,%eax
 509:	0f 84 7c 01 00 00    	je     68b <mmap_test+0x4fb>
    err("mmap mmap1");
  close(fd1);
 50f:	83 ec 0c             	sub    $0xc,%esp
 512:	53                   	push   %ebx
 513:	e8 d3 05 00 00       	call   aeb <close>
  unlink("mmap1");
 518:	c7 04 24 f9 11 00 00 	movl   $0x11f9,(%esp)
 51f:	e8 ef 05 00 00       	call   b13 <unlink>

  int fd2;
  if((fd2 = open("mmap2", O_RDWR|O_CREATE)) < 0)
 524:	59                   	pop    %ecx
 525:	5b                   	pop    %ebx
 526:	68 02 02 00 00       	push   $0x202
 52b:	68 21 12 00 00       	push   $0x1221
 530:	e8 ce 05 00 00       	call   b03 <open>
 535:	83 c4 10             	add    $0x10,%esp
 538:	89 c6                	mov    %eax,%esi
 53a:	85 c0                	test   %eax,%eax
 53c:	0f 88 3c 01 00 00    	js     67e <mmap_test+0x4ee>
    err("open mmap2");
  if(write(fd2, "67890", 5) != 5)
 542:	83 ec 04             	sub    $0x4,%esp
 545:	6a 05                	push   $0x5
 547:	68 15 12 00 00       	push   $0x1215
 54c:	50                   	push   %eax
 54d:	e8 91 05 00 00       	call   ae3 <write>
 552:	83 c4 10             	add    $0x10,%esp
 555:	83 f8 05             	cmp    $0x5,%eax
 558:	0f 85 13 01 00 00    	jne    671 <mmap_test+0x4e1>
    err("write mmap2");
  char *p2 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
 55e:	83 ec 08             	sub    $0x8,%esp
 561:	6a 00                	push   $0x0
 563:	56                   	push   %esi
 564:	6a 02                	push   $0x2
 566:	6a 01                	push   $0x1
 568:	68 00 10 00 00       	push   $0x1000
 56d:	6a 00                	push   $0x0
 56f:	e8 ef 05 00 00       	call   b63 <mmap>
  if(p2 == MAP_FAILED)
 574:	83 c4 20             	add    $0x20,%esp
  char *p2 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
 577:	89 c3                	mov    %eax,%ebx
  if(p2 == MAP_FAILED)
 579:	83 f8 ff             	cmp    $0xffffffff,%eax
 57c:	0f 84 e2 00 00 00    	je     664 <mmap_test+0x4d4>
    err("mmap mmap2");
  close(fd2);
 582:	83 ec 0c             	sub    $0xc,%esp
 585:	56                   	push   %esi
 586:	e8 60 05 00 00       	call   aeb <close>
  unlink("mmap2");
 58b:	c7 04 24 21 12 00 00 	movl   $0x1221,(%esp)
 592:	e8 7c 05 00 00       	call   b13 <unlink>

  if(strcmp(p1, "12345") != 0)
 597:	58                   	pop    %eax
 598:	5a                   	pop    %edx
 599:	68 ed 11 00 00       	push   $0x11ed
 59e:	57                   	push   %edi
 59f:	e8 0c 03 00 00       	call   8b0 <strcmp>
 5a4:	83 c4 10             	add    $0x10,%esp
 5a7:	85 c0                	test   %eax,%eax
 5a9:	0f 85 10 01 00 00    	jne    6bf <mmap_test+0x52f>
    err("mmap1 mismatch");
  if(strcmp(p2, "67890") != 0)
 5af:	83 ec 08             	sub    $0x8,%esp
 5b2:	68 15 12 00 00       	push   $0x1215
 5b7:	53                   	push   %ebx
 5b8:	e8 f3 02 00 00       	call   8b0 <strcmp>
 5bd:	83 c4 10             	add    $0x10,%esp
 5c0:	85 c0                	test   %eax,%eax
 5c2:	0f 85 ea 00 00 00    	jne    6b2 <mmap_test+0x522>
    err("mmap2 mismatch");

  munmap(p1, PGSIZE);
 5c8:	83 ec 08             	sub    $0x8,%esp
 5cb:	68 00 10 00 00       	push   $0x1000
 5d0:	57                   	push   %edi
 5d1:	e8 95 05 00 00       	call   b6b <munmap>
  if(strcmp(p2, "67890") != 0)
 5d6:	5e                   	pop    %esi
 5d7:	5f                   	pop    %edi
 5d8:	68 15 12 00 00       	push   $0x1215
 5dd:	53                   	push   %ebx
 5de:	e8 cd 02 00 00       	call   8b0 <strcmp>
 5e3:	83 c4 10             	add    $0x10,%esp
 5e6:	85 c0                	test   %eax,%eax
 5e8:	0f 85 b7 00 00 00    	jne    6a5 <mmap_test+0x515>
    err("mmap2 mismatch (2)");
  munmap(p2, PGSIZE);
 5ee:	83 ec 08             	sub    $0x8,%esp
 5f1:	68 00 10 00 00       	push   $0x1000
 5f6:	53                   	push   %ebx
 5f7:	e8 6f 05 00 00       	call   b6b <munmap>
  
  printf(1,"test mmap two files: OK\n");
 5fc:	58                   	pop    %eax
 5fd:	5a                   	pop    %edx
 5fe:	68 63 12 00 00       	push   $0x1263
 603:	6a 01                	push   $0x1
 605:	e8 16 06 00 00       	call   c20 <printf>
  
  printf(1,"mmap_test: ALL OK\n");
 60a:	59                   	pop    %ecx
 60b:	5b                   	pop    %ebx
 60c:	68 7c 12 00 00       	push   $0x127c
 611:	6a 01                	push   $0x1
 613:	e8 08 06 00 00       	call   c20 <printf>
}
 618:	83 c4 10             	add    $0x10,%esp
 61b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61e:	5b                   	pop    %ebx
 61f:	5e                   	pop    %esi
 620:	5f                   	pop    %edi
 621:	5d                   	pop    %ebp
 622:	c3                   	ret
      err("read (1)");
 623:	83 ec 0c             	sub    $0xc,%esp
 626:	68 72 11 00 00       	push   $0x1172
 62b:	e8 00 fa ff ff       	call   30 <err>
      err("file does not contain modifications");
 630:	83 ec 0c             	sub    $0xc,%esp
 633:	68 bc 0f 00 00       	push   $0xfbc
 638:	e8 f3 f9 ff ff       	call   30 <err>
    err("munmap (4)");
 63d:	83 ec 0c             	sub    $0xc,%esp
 640:	68 a7 11 00 00       	push   $0x11a7
 645:	e8 e6 f9 ff ff       	call   30 <err>
    err("write mmap1");
 64a:	83 ec 0c             	sub    $0xc,%esp
 64d:	68 f3 11 00 00       	push   $0x11f3
 652:	e8 d9 f9 ff ff       	call   30 <err>
    err("open mmap1");
 657:	83 ec 0c             	sub    $0xc,%esp
 65a:	68 e2 11 00 00       	push   $0x11e2
 65f:	e8 cc f9 ff ff       	call   30 <err>
    err("mmap mmap2");
 664:	83 ec 0c             	sub    $0xc,%esp
 667:	68 27 12 00 00       	push   $0x1227
 66c:	e8 bf f9 ff ff       	call   30 <err>
    err("write mmap2");
 671:	83 ec 0c             	sub    $0xc,%esp
 674:	68 1b 12 00 00       	push   $0x121b
 679:	e8 b2 f9 ff ff       	call   30 <err>
    err("open mmap2");
 67e:	83 ec 0c             	sub    $0xc,%esp
 681:	68 0a 12 00 00       	push   $0x120a
 686:	e8 a5 f9 ff ff       	call   30 <err>
    err("mmap mmap1");
 68b:	83 ec 0c             	sub    $0xc,%esp
 68e:	68 ff 11 00 00       	push   $0x11ff
 693:	e8 98 f9 ff ff       	call   30 <err>
    err("open");
 698:	83 ec 0c             	sub    $0xc,%esp
 69b:	68 1f 10 00 00       	push   $0x101f
 6a0:	e8 8b f9 ff ff       	call   30 <err>
    err("mmap2 mismatch (2)");
 6a5:	83 ec 0c             	sub    $0xc,%esp
 6a8:	68 50 12 00 00       	push   $0x1250
 6ad:	e8 7e f9 ff ff       	call   30 <err>
    err("mmap2 mismatch");
 6b2:	83 ec 0c             	sub    $0xc,%esp
 6b5:	68 41 12 00 00       	push   $0x1241
 6ba:	e8 71 f9 ff ff       	call   30 <err>
    err("mmap1 mismatch");
 6bf:	83 ec 0c             	sub    $0xc,%esp
 6c2:	68 32 12 00 00       	push   $0x1232
 6c7:	e8 64 f9 ff ff       	call   30 <err>
    err("close");
 6cc:	83 ec 0c             	sub    $0xc,%esp
 6cf:	68 35 10 00 00       	push   $0x1035
 6d4:	e8 57 f9 ff ff       	call   30 <err>
    err("mmap (2)");
 6d9:	83 ec 0c             	sub    $0xc,%esp
 6dc:	68 a7 10 00 00       	push   $0x10a7
 6e1:	e8 4a f9 ff ff       	call   30 <err>
    err("munmap (1)");
 6e6:	83 ec 0c             	sub    $0xc,%esp
 6e9:	68 78 10 00 00       	push   $0x1078
 6ee:	e8 3d f9 ff ff       	call   30 <err>
    err("mmap (1)");
 6f3:	83 ec 0c             	sub    $0xc,%esp
 6f6:	68 6f 10 00 00       	push   $0x106f
 6fb:	e8 30 f9 ff ff       	call   30 <err>
    err("munmap (3)");
 700:	83 ec 0c             	sub    $0xc,%esp
 703:	68 3c 11 00 00       	push   $0x113c
 708:	e8 23 f9 ff ff       	call   30 <err>
    err("mmap (3)");
 70d:	83 ec 0c             	sub    $0xc,%esp
 710:	68 33 11 00 00       	push   $0x1133
 715:	e8 16 f9 ff ff       	call   30 <err>
    err("mmap call should have failed");
 71a:	83 ec 0c             	sub    $0xc,%esp
 71d:	68 e7 10 00 00       	push   $0x10e7
 722:	e8 09 f9 ff ff       	call   30 <err>
    err("munmap (2)");
 727:	83 ec 0c             	sub    $0xc,%esp
 72a:	68 b0 10 00 00       	push   $0x10b0
 72f:	e8 fc f8 ff ff       	call   30 <err>
 734:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 73b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop

00000740 <fork_test>:
// mmap a file, then fork.
// check that the child sees the mapped file.
//
void
fork_test(void)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	56                   	push   %esi
 744:	53                   	push   %ebx
  int fd;
  int pid;
  const char * const f = "mmap.dur";
  
  printf(1,"fork_test starting\n");
 745:	83 ec 08             	sub    $0x8,%esp
 748:	68 8f 12 00 00       	push   $0x128f
 74d:	6a 01                	push   $0x1
 74f:	e8 cc 04 00 00       	call   c20 <printf>
  testname = "fork_test";
 754:	c7 05 ac 16 00 00 a3 	movl   $0x12a3,0x16ac
 75b:	12 00 00 
  
  // mmap the file twice.
  makefile(f);
 75e:	c7 04 24 59 10 00 00 	movl   $0x1059,(%esp)
 765:	e8 76 f9 ff ff       	call   e0 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
 76a:	58                   	pop    %eax
 76b:	5a                   	pop    %edx
 76c:	6a 00                	push   $0x0
 76e:	68 59 10 00 00       	push   $0x1059
 773:	e8 8b 03 00 00       	call   b03 <open>
 778:	83 c4 10             	add    $0x10,%esp
 77b:	83 f8 ff             	cmp    $0xffffffff,%eax
 77e:	0f 84 98 00 00 00    	je     81c <fork_test+0xdc>
    err("open");
  unlink(f);
 784:	83 ec 0c             	sub    $0xc,%esp
 787:	89 c3                	mov    %eax,%ebx
 789:	68 59 10 00 00       	push   $0x1059
 78e:	e8 80 03 00 00       	call   b13 <unlink>
  char *p1 = (char*)mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
 793:	5e                   	pop    %esi
 794:	58                   	pop    %eax
 795:	6a 00                	push   $0x0
 797:	53                   	push   %ebx
 798:	6a 01                	push   $0x1
 79a:	6a 01                	push   $0x1
 79c:	68 00 20 00 00       	push   $0x2000
 7a1:	6a 00                	push   $0x0
 7a3:	e8 bb 03 00 00       	call   b63 <mmap>
  if (p1 == MAP_FAILED)
 7a8:	83 c4 20             	add    $0x20,%esp
  char *p1 = (char*)mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
 7ab:	89 c6                	mov    %eax,%esi
  if (p1 == MAP_FAILED)
 7ad:	83 f8 ff             	cmp    $0xffffffff,%eax
 7b0:	0f 84 b5 00 00 00    	je     86b <fork_test+0x12b>
    err("mmap (4)");
  char *p2 = (char*)mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
 7b6:	83 ec 08             	sub    $0x8,%esp
 7b9:	6a 00                	push   $0x0
 7bb:	53                   	push   %ebx
 7bc:	6a 01                	push   $0x1
 7be:	6a 01                	push   $0x1
 7c0:	68 00 20 00 00       	push   $0x2000
 7c5:	6a 00                	push   $0x0
 7c7:	e8 97 03 00 00       	call   b63 <mmap>
  if (p2 == MAP_FAILED)
 7cc:	83 c4 20             	add    $0x20,%esp
  char *p2 = (char*)mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
 7cf:	89 c3                	mov    %eax,%ebx
  if (p2 == MAP_FAILED)
 7d1:	83 f8 ff             	cmp    $0xffffffff,%eax
 7d4:	0f 84 84 00 00 00    	je     85e <fork_test+0x11e>
    err("mmap (5)");

  // read just 2nd page.
  if(*(p1+PGSIZE) != 'A')
 7da:	80 be 00 10 00 00 41 	cmpb   $0x41,0x1000(%esi)
 7e1:	75 6e                	jne    851 <fork_test+0x111>
    err("fork mismatch (1)");

  if((pid = fork()) < 0)
 7e3:	e8 d3 02 00 00       	call   abb <fork>
 7e8:	85 c0                	test   %eax,%eax
 7ea:	78 58                	js     844 <fork_test+0x104>
    err("fork");
  if (pid == 0) {
 7ec:	74 3b                	je     829 <fork_test+0xe9>
    munmap(p1, PGSIZE); // just the first page
    exit(); // tell the parent that the mapping looks OK.
  }

  int status = -1;
  wait();
 7ee:	e8 d8 02 00 00       	call   acb <wait>


  // check that the parent's mappings are still there.
  _v1(p1);
 7f3:	83 ec 0c             	sub    $0xc,%esp
 7f6:	56                   	push   %esi
 7f7:	e8 64 f8 ff ff       	call   60 <_v1>
  _v1(p2);
 7fc:	89 1c 24             	mov    %ebx,(%esp)
 7ff:	e8 5c f8 ff ff       	call   60 <_v1>

  printf(1,"fork_test OK\n");
 804:	58                   	pop    %eax
 805:	5a                   	pop    %edx
 806:	68 d6 12 00 00       	push   $0x12d6
 80b:	6a 01                	push   $0x1
 80d:	e8 0e 04 00 00       	call   c20 <printf>
}
 812:	83 c4 10             	add    $0x10,%esp
 815:	8d 65 f8             	lea    -0x8(%ebp),%esp
 818:	5b                   	pop    %ebx
 819:	5e                   	pop    %esi
 81a:	5d                   	pop    %ebp
 81b:	c3                   	ret
    err("open");
 81c:	83 ec 0c             	sub    $0xc,%esp
 81f:	68 1f 10 00 00       	push   $0x101f
 824:	e8 07 f8 ff ff       	call   30 <err>
    _v1(p1);
 829:	83 ec 0c             	sub    $0xc,%esp
 82c:	56                   	push   %esi
 82d:	e8 2e f8 ff ff       	call   60 <_v1>
    munmap(p1, PGSIZE); // just the first page
 832:	59                   	pop    %ecx
 833:	5b                   	pop    %ebx
 834:	68 00 10 00 00       	push   $0x1000
 839:	56                   	push   %esi
 83a:	e8 2c 03 00 00       	call   b6b <munmap>
    exit(); // tell the parent that the mapping looks OK.
 83f:	e8 7f 02 00 00       	call   ac3 <exit>
    err("fork");
 844:	83 ec 0c             	sub    $0xc,%esp
 847:	68 d1 12 00 00       	push   $0x12d1
 84c:	e8 df f7 ff ff       	call   30 <err>
    err("fork mismatch (1)");
 851:	83 ec 0c             	sub    $0xc,%esp
 854:	68 bf 12 00 00       	push   $0x12bf
 859:	e8 d2 f7 ff ff       	call   30 <err>
    err("mmap (5)");
 85e:	83 ec 0c             	sub    $0xc,%esp
 861:	68 b6 12 00 00       	push   $0x12b6
 866:	e8 c5 f7 ff ff       	call   30 <err>
    err("mmap (4)");
 86b:	83 ec 0c             	sub    $0xc,%esp
 86e:	68 ad 12 00 00       	push   $0x12ad
 873:	e8 b8 f7 ff ff       	call   30 <err>
 878:	66 90                	xchg   %ax,%ax
 87a:	66 90                	xchg   %ax,%ax
 87c:	66 90                	xchg   %ax,%ax
 87e:	66 90                	xchg   %ax,%ax

00000880 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 880:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 881:	31 c0                	xor    %eax,%eax
{
 883:	89 e5                	mov    %esp,%ebp
 885:	53                   	push   %ebx
 886:	8b 4d 08             	mov    0x8(%ebp),%ecx
 889:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 88c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 890:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 894:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 897:	83 c0 01             	add    $0x1,%eax
 89a:	84 d2                	test   %dl,%dl
 89c:	75 f2                	jne    890 <strcpy+0x10>
    ;
  return os;
}
 89e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8a1:	89 c8                	mov    %ecx,%eax
 8a3:	c9                   	leave
 8a4:	c3                   	ret
 8a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	53                   	push   %ebx
 8b4:	8b 55 08             	mov    0x8(%ebp),%edx
 8b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 8ba:	0f b6 02             	movzbl (%edx),%eax
 8bd:	84 c0                	test   %al,%al
 8bf:	75 17                	jne    8d8 <strcmp+0x28>
 8c1:	eb 3a                	jmp    8fd <strcmp+0x4d>
 8c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8c7:	90                   	nop
 8c8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 8cc:	83 c2 01             	add    $0x1,%edx
 8cf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 8d2:	84 c0                	test   %al,%al
 8d4:	74 1a                	je     8f0 <strcmp+0x40>
    p++, q++;
 8d6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 8d8:	0f b6 19             	movzbl (%ecx),%ebx
 8db:	38 c3                	cmp    %al,%bl
 8dd:	74 e9                	je     8c8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 8df:	29 d8                	sub    %ebx,%eax
}
 8e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8e4:	c9                   	leave
 8e5:	c3                   	ret
 8e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ed:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 8f0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 8f4:	31 c0                	xor    %eax,%eax
 8f6:	29 d8                	sub    %ebx,%eax
}
 8f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8fb:	c9                   	leave
 8fc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 8fd:	0f b6 19             	movzbl (%ecx),%ebx
 900:	31 c0                	xor    %eax,%eax
 902:	eb db                	jmp    8df <strcmp+0x2f>
 904:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 90b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 90f:	90                   	nop

00000910 <strlen>:

uint
strlen(const char *s)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 916:	80 3a 00             	cmpb   $0x0,(%edx)
 919:	74 15                	je     930 <strlen+0x20>
 91b:	31 c0                	xor    %eax,%eax
 91d:	8d 76 00             	lea    0x0(%esi),%esi
 920:	83 c0 01             	add    $0x1,%eax
 923:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 927:	89 c1                	mov    %eax,%ecx
 929:	75 f5                	jne    920 <strlen+0x10>
    ;
  return n;
}
 92b:	89 c8                	mov    %ecx,%eax
 92d:	5d                   	pop    %ebp
 92e:	c3                   	ret
 92f:	90                   	nop
  for(n = 0; s[n]; n++)
 930:	31 c9                	xor    %ecx,%ecx
}
 932:	5d                   	pop    %ebp
 933:	89 c8                	mov    %ecx,%eax
 935:	c3                   	ret
 936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 93d:	8d 76 00             	lea    0x0(%esi),%esi

00000940 <memset>:

void*
memset(void *dst, int c, uint n)
{
 940:	55                   	push   %ebp
 941:	89 e5                	mov    %esp,%ebp
 943:	57                   	push   %edi
 944:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 947:	8b 4d 10             	mov    0x10(%ebp),%ecx
 94a:	8b 45 0c             	mov    0xc(%ebp),%eax
 94d:	89 d7                	mov    %edx,%edi
 94f:	fc                   	cld
 950:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 952:	8b 7d fc             	mov    -0x4(%ebp),%edi
 955:	89 d0                	mov    %edx,%eax
 957:	c9                   	leave
 958:	c3                   	ret
 959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000960 <strchr>:

char*
strchr(const char *s, char c)
{
 960:	55                   	push   %ebp
 961:	89 e5                	mov    %esp,%ebp
 963:	8b 45 08             	mov    0x8(%ebp),%eax
 966:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 96a:	0f b6 10             	movzbl (%eax),%edx
 96d:	84 d2                	test   %dl,%dl
 96f:	75 12                	jne    983 <strchr+0x23>
 971:	eb 1d                	jmp    990 <strchr+0x30>
 973:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 977:	90                   	nop
 978:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 97c:	83 c0 01             	add    $0x1,%eax
 97f:	84 d2                	test   %dl,%dl
 981:	74 0d                	je     990 <strchr+0x30>
    if(*s == c)
 983:	38 d1                	cmp    %dl,%cl
 985:	75 f1                	jne    978 <strchr+0x18>
      return (char*)s;
  return 0;
}
 987:	5d                   	pop    %ebp
 988:	c3                   	ret
 989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 990:	31 c0                	xor    %eax,%eax
}
 992:	5d                   	pop    %ebp
 993:	c3                   	ret
 994:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 99b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 99f:	90                   	nop

000009a0 <gets>:

char*
gets(char *buf, int max)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	57                   	push   %edi
 9a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 9a5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 9a8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 9a9:	31 db                	xor    %ebx,%ebx
{
 9ab:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 9ae:	eb 27                	jmp    9d7 <gets+0x37>
    cc = read(0, &c, 1);
 9b0:	83 ec 04             	sub    $0x4,%esp
 9b3:	6a 01                	push   $0x1
 9b5:	56                   	push   %esi
 9b6:	6a 00                	push   $0x0
 9b8:	e8 1e 01 00 00       	call   adb <read>
    if(cc < 1)
 9bd:	83 c4 10             	add    $0x10,%esp
 9c0:	85 c0                	test   %eax,%eax
 9c2:	7e 1d                	jle    9e1 <gets+0x41>
      break;
    buf[i++] = c;
 9c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 9c8:	8b 55 08             	mov    0x8(%ebp),%edx
 9cb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 9cf:	3c 0a                	cmp    $0xa,%al
 9d1:	74 10                	je     9e3 <gets+0x43>
 9d3:	3c 0d                	cmp    $0xd,%al
 9d5:	74 0c                	je     9e3 <gets+0x43>
  for(i=0; i+1 < max; ){
 9d7:	89 df                	mov    %ebx,%edi
 9d9:	83 c3 01             	add    $0x1,%ebx
 9dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 9df:	7c cf                	jl     9b0 <gets+0x10>
 9e1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 9e3:	8b 45 08             	mov    0x8(%ebp),%eax
 9e6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 9ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9ed:	5b                   	pop    %ebx
 9ee:	5e                   	pop    %esi
 9ef:	5f                   	pop    %edi
 9f0:	5d                   	pop    %ebp
 9f1:	c3                   	ret
 9f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000a00 <stat>:

int
stat(const char *n, struct stat *st)
{
 a00:	55                   	push   %ebp
 a01:	89 e5                	mov    %esp,%ebp
 a03:	56                   	push   %esi
 a04:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 a05:	83 ec 08             	sub    $0x8,%esp
 a08:	6a 00                	push   $0x0
 a0a:	ff 75 08             	push   0x8(%ebp)
 a0d:	e8 f1 00 00 00       	call   b03 <open>
  if(fd < 0)
 a12:	83 c4 10             	add    $0x10,%esp
 a15:	85 c0                	test   %eax,%eax
 a17:	78 27                	js     a40 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 a19:	83 ec 08             	sub    $0x8,%esp
 a1c:	ff 75 0c             	push   0xc(%ebp)
 a1f:	89 c3                	mov    %eax,%ebx
 a21:	50                   	push   %eax
 a22:	e8 f4 00 00 00       	call   b1b <fstat>
  close(fd);
 a27:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 a2a:	89 c6                	mov    %eax,%esi
  close(fd);
 a2c:	e8 ba 00 00 00       	call   aeb <close>
  return r;
 a31:	83 c4 10             	add    $0x10,%esp
}
 a34:	8d 65 f8             	lea    -0x8(%ebp),%esp
 a37:	89 f0                	mov    %esi,%eax
 a39:	5b                   	pop    %ebx
 a3a:	5e                   	pop    %esi
 a3b:	5d                   	pop    %ebp
 a3c:	c3                   	ret
 a3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 a40:	be ff ff ff ff       	mov    $0xffffffff,%esi
 a45:	eb ed                	jmp    a34 <stat+0x34>
 a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a4e:	66 90                	xchg   %ax,%ax

00000a50 <atoi>:

int
atoi(const char *s)
{
 a50:	55                   	push   %ebp
 a51:	89 e5                	mov    %esp,%ebp
 a53:	53                   	push   %ebx
 a54:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 a57:	0f be 02             	movsbl (%edx),%eax
 a5a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 a5d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 a60:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 a65:	77 1e                	ja     a85 <atoi+0x35>
 a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a6e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 a70:	83 c2 01             	add    $0x1,%edx
 a73:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 a76:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 a7a:	0f be 02             	movsbl (%edx),%eax
 a7d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 a80:	80 fb 09             	cmp    $0x9,%bl
 a83:	76 eb                	jbe    a70 <atoi+0x20>
  return n;
}
 a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 a88:	89 c8                	mov    %ecx,%eax
 a8a:	c9                   	leave
 a8b:	c3                   	ret
 a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000a90 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 a90:	55                   	push   %ebp
 a91:	89 e5                	mov    %esp,%ebp
 a93:	57                   	push   %edi
 a94:	8b 45 10             	mov    0x10(%ebp),%eax
 a97:	8b 55 08             	mov    0x8(%ebp),%edx
 a9a:	56                   	push   %esi
 a9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 a9e:	85 c0                	test   %eax,%eax
 aa0:	7e 13                	jle    ab5 <memmove+0x25>
 aa2:	01 d0                	add    %edx,%eax
  dst = vdst;
 aa4:	89 d7                	mov    %edx,%edi
 aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 aad:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 ab0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 ab1:	39 f8                	cmp    %edi,%eax
 ab3:	75 fb                	jne    ab0 <memmove+0x20>
  return vdst;
}
 ab5:	5e                   	pop    %esi
 ab6:	89 d0                	mov    %edx,%eax
 ab8:	5f                   	pop    %edi
 ab9:	5d                   	pop    %ebp
 aba:	c3                   	ret

00000abb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 abb:	b8 01 00 00 00       	mov    $0x1,%eax
 ac0:	cd 40                	int    $0x40
 ac2:	c3                   	ret

00000ac3 <exit>:
SYSCALL(exit)
 ac3:	b8 02 00 00 00       	mov    $0x2,%eax
 ac8:	cd 40                	int    $0x40
 aca:	c3                   	ret

00000acb <wait>:
SYSCALL(wait)
 acb:	b8 03 00 00 00       	mov    $0x3,%eax
 ad0:	cd 40                	int    $0x40
 ad2:	c3                   	ret

00000ad3 <pipe>:
SYSCALL(pipe)
 ad3:	b8 04 00 00 00       	mov    $0x4,%eax
 ad8:	cd 40                	int    $0x40
 ada:	c3                   	ret

00000adb <read>:
SYSCALL(read)
 adb:	b8 05 00 00 00       	mov    $0x5,%eax
 ae0:	cd 40                	int    $0x40
 ae2:	c3                   	ret

00000ae3 <write>:
SYSCALL(write)
 ae3:	b8 10 00 00 00       	mov    $0x10,%eax
 ae8:	cd 40                	int    $0x40
 aea:	c3                   	ret

00000aeb <close>:
SYSCALL(close)
 aeb:	b8 15 00 00 00       	mov    $0x15,%eax
 af0:	cd 40                	int    $0x40
 af2:	c3                   	ret

00000af3 <kill>:
SYSCALL(kill)
 af3:	b8 06 00 00 00       	mov    $0x6,%eax
 af8:	cd 40                	int    $0x40
 afa:	c3                   	ret

00000afb <exec>:
SYSCALL(exec)
 afb:	b8 07 00 00 00       	mov    $0x7,%eax
 b00:	cd 40                	int    $0x40
 b02:	c3                   	ret

00000b03 <open>:
SYSCALL(open)
 b03:	b8 0f 00 00 00       	mov    $0xf,%eax
 b08:	cd 40                	int    $0x40
 b0a:	c3                   	ret

00000b0b <mknod>:
SYSCALL(mknod)
 b0b:	b8 11 00 00 00       	mov    $0x11,%eax
 b10:	cd 40                	int    $0x40
 b12:	c3                   	ret

00000b13 <unlink>:
SYSCALL(unlink)
 b13:	b8 12 00 00 00       	mov    $0x12,%eax
 b18:	cd 40                	int    $0x40
 b1a:	c3                   	ret

00000b1b <fstat>:
SYSCALL(fstat)
 b1b:	b8 08 00 00 00       	mov    $0x8,%eax
 b20:	cd 40                	int    $0x40
 b22:	c3                   	ret

00000b23 <link>:
SYSCALL(link)
 b23:	b8 13 00 00 00       	mov    $0x13,%eax
 b28:	cd 40                	int    $0x40
 b2a:	c3                   	ret

00000b2b <mkdir>:
SYSCALL(mkdir)
 b2b:	b8 14 00 00 00       	mov    $0x14,%eax
 b30:	cd 40                	int    $0x40
 b32:	c3                   	ret

00000b33 <chdir>:
SYSCALL(chdir)
 b33:	b8 09 00 00 00       	mov    $0x9,%eax
 b38:	cd 40                	int    $0x40
 b3a:	c3                   	ret

00000b3b <dup>:
SYSCALL(dup)
 b3b:	b8 0a 00 00 00       	mov    $0xa,%eax
 b40:	cd 40                	int    $0x40
 b42:	c3                   	ret

00000b43 <getpid>:
SYSCALL(getpid)
 b43:	b8 0b 00 00 00       	mov    $0xb,%eax
 b48:	cd 40                	int    $0x40
 b4a:	c3                   	ret

00000b4b <sbrk>:
SYSCALL(sbrk)
 b4b:	b8 0c 00 00 00       	mov    $0xc,%eax
 b50:	cd 40                	int    $0x40
 b52:	c3                   	ret

00000b53 <sleep>:
SYSCALL(sleep)
 b53:	b8 0d 00 00 00       	mov    $0xd,%eax
 b58:	cd 40                	int    $0x40
 b5a:	c3                   	ret

00000b5b <uptime>:
SYSCALL(uptime)
 b5b:	b8 0e 00 00 00       	mov    $0xe,%eax
 b60:	cd 40                	int    $0x40
 b62:	c3                   	ret

00000b63 <mmap>:
SYSCALL(mmap)
 b63:	b8 16 00 00 00       	mov    $0x16,%eax
 b68:	cd 40                	int    $0x40
 b6a:	c3                   	ret

00000b6b <munmap>:
SYSCALL(munmap)
 b6b:	b8 17 00 00 00       	mov    $0x17,%eax
 b70:	cd 40                	int    $0x40
 b72:	c3                   	ret
 b73:	66 90                	xchg   %ax,%ax
 b75:	66 90                	xchg   %ax,%ax
 b77:	66 90                	xchg   %ax,%ax
 b79:	66 90                	xchg   %ax,%ax
 b7b:	66 90                	xchg   %ax,%ax
 b7d:	66 90                	xchg   %ax,%ax
 b7f:	90                   	nop

00000b80 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 b80:	55                   	push   %ebp
 b81:	89 e5                	mov    %esp,%ebp
 b83:	57                   	push   %edi
 b84:	56                   	push   %esi
 b85:	53                   	push   %ebx
 b86:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 b88:	89 d1                	mov    %edx,%ecx
{
 b8a:	83 ec 3c             	sub    $0x3c,%esp
 b8d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 b90:	85 d2                	test   %edx,%edx
 b92:	0f 89 80 00 00 00    	jns    c18 <printint+0x98>
 b98:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 b9c:	74 7a                	je     c18 <printint+0x98>
    x = -xx;
 b9e:	f7 d9                	neg    %ecx
    neg = 1;
 ba0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 ba5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 ba8:	31 f6                	xor    %esi,%esi
 baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 bb0:	89 c8                	mov    %ecx,%eax
 bb2:	31 d2                	xor    %edx,%edx
 bb4:	89 f7                	mov    %esi,%edi
 bb6:	f7 f3                	div    %ebx
 bb8:	8d 76 01             	lea    0x1(%esi),%esi
 bbb:	0f b6 92 48 13 00 00 	movzbl 0x1348(%edx),%edx
 bc2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 bc6:	89 ca                	mov    %ecx,%edx
 bc8:	89 c1                	mov    %eax,%ecx
 bca:	39 da                	cmp    %ebx,%edx
 bcc:	73 e2                	jae    bb0 <printint+0x30>
  if(neg)
 bce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 bd1:	85 c0                	test   %eax,%eax
 bd3:	74 07                	je     bdc <printint+0x5c>
    buf[i++] = '-';
 bd5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
 bda:	89 f7                	mov    %esi,%edi
 bdc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 bdf:	8b 75 c0             	mov    -0x40(%ebp),%esi
 be2:	01 df                	add    %ebx,%edi
 be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  while(--i >= 0)
    putc(fd, buf[i]);
 be8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 beb:	83 ec 04             	sub    $0x4,%esp
 bee:	88 45 d7             	mov    %al,-0x29(%ebp)
 bf1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 bf4:	6a 01                	push   $0x1
 bf6:	50                   	push   %eax
 bf7:	56                   	push   %esi
 bf8:	e8 e6 fe ff ff       	call   ae3 <write>
  while(--i >= 0)
 bfd:	89 f8                	mov    %edi,%eax
 bff:	83 c4 10             	add    $0x10,%esp
 c02:	83 ef 01             	sub    $0x1,%edi
 c05:	39 d8                	cmp    %ebx,%eax
 c07:	75 df                	jne    be8 <printint+0x68>
}
 c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
 c0c:	5b                   	pop    %ebx
 c0d:	5e                   	pop    %esi
 c0e:	5f                   	pop    %edi
 c0f:	5d                   	pop    %ebp
 c10:	c3                   	ret
 c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 c18:	31 c0                	xor    %eax,%eax
 c1a:	eb 89                	jmp    ba5 <printint+0x25>
 c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c20 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 c20:	55                   	push   %ebp
 c21:	89 e5                	mov    %esp,%ebp
 c23:	57                   	push   %edi
 c24:	56                   	push   %esi
 c25:	53                   	push   %ebx
 c26:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c29:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 c2c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 c2f:	0f b6 1e             	movzbl (%esi),%ebx
 c32:	83 c6 01             	add    $0x1,%esi
 c35:	84 db                	test   %bl,%bl
 c37:	74 67                	je     ca0 <printf+0x80>
 c39:	8d 4d 10             	lea    0x10(%ebp),%ecx
 c3c:	31 d2                	xor    %edx,%edx
 c3e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 c41:	eb 34                	jmp    c77 <printf+0x57>
 c43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 c47:	90                   	nop
 c48:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 c4b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 c50:	83 f8 25             	cmp    $0x25,%eax
 c53:	74 18                	je     c6d <printf+0x4d>
  write(fd, &c, 1);
 c55:	83 ec 04             	sub    $0x4,%esp
 c58:	8d 45 e7             	lea    -0x19(%ebp),%eax
 c5b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 c5e:	6a 01                	push   $0x1
 c60:	50                   	push   %eax
 c61:	57                   	push   %edi
 c62:	e8 7c fe ff ff       	call   ae3 <write>
 c67:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 c6a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 c6d:	0f b6 1e             	movzbl (%esi),%ebx
 c70:	83 c6 01             	add    $0x1,%esi
 c73:	84 db                	test   %bl,%bl
 c75:	74 29                	je     ca0 <printf+0x80>
    c = fmt[i] & 0xff;
 c77:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 c7a:	85 d2                	test   %edx,%edx
 c7c:	74 ca                	je     c48 <printf+0x28>
      }
    } else if(state == '%'){
 c7e:	83 fa 25             	cmp    $0x25,%edx
 c81:	75 ea                	jne    c6d <printf+0x4d>
      if(c == 'd'){
 c83:	83 f8 25             	cmp    $0x25,%eax
 c86:	0f 84 24 01 00 00    	je     db0 <printf+0x190>
 c8c:	83 e8 63             	sub    $0x63,%eax
 c8f:	83 f8 15             	cmp    $0x15,%eax
 c92:	77 1c                	ja     cb0 <printf+0x90>
 c94:	ff 24 85 f0 12 00 00 	jmp    *0x12f0(,%eax,4)
 c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 c9f:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 ca3:	5b                   	pop    %ebx
 ca4:	5e                   	pop    %esi
 ca5:	5f                   	pop    %edi
 ca6:	5d                   	pop    %ebp
 ca7:	c3                   	ret
 ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 caf:	90                   	nop
  write(fd, &c, 1);
 cb0:	83 ec 04             	sub    $0x4,%esp
 cb3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 cb6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 cba:	6a 01                	push   $0x1
 cbc:	52                   	push   %edx
 cbd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 cc0:	57                   	push   %edi
 cc1:	e8 1d fe ff ff       	call   ae3 <write>
 cc6:	83 c4 0c             	add    $0xc,%esp
 cc9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 ccc:	6a 01                	push   $0x1
 cce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 cd1:	52                   	push   %edx
 cd2:	57                   	push   %edi
 cd3:	e8 0b fe ff ff       	call   ae3 <write>
        putc(fd, c);
 cd8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 cdb:	31 d2                	xor    %edx,%edx
 cdd:	eb 8e                	jmp    c6d <printf+0x4d>
 cdf:	90                   	nop
        printint(fd, *ap, 16, 0);
 ce0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 ce3:	83 ec 0c             	sub    $0xc,%esp
 ce6:	b9 10 00 00 00       	mov    $0x10,%ecx
 ceb:	8b 13                	mov    (%ebx),%edx
 ced:	6a 00                	push   $0x0
 cef:	89 f8                	mov    %edi,%eax
        ap++;
 cf1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 cf4:	e8 87 fe ff ff       	call   b80 <printint>
        ap++;
 cf9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 cfc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 cff:	31 d2                	xor    %edx,%edx
 d01:	e9 67 ff ff ff       	jmp    c6d <printf+0x4d>
 d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 d0d:	8d 76 00             	lea    0x0(%esi),%esi
        s = (char*)*ap;
 d10:	8b 45 d0             	mov    -0x30(%ebp),%eax
 d13:	8b 18                	mov    (%eax),%ebx
        ap++;
 d15:	83 c0 04             	add    $0x4,%eax
 d18:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 d1b:	85 db                	test   %ebx,%ebx
 d1d:	0f 84 9d 00 00 00    	je     dc0 <printf+0x1a0>
        while(*s != 0){
 d23:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 d26:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 d28:	84 c0                	test   %al,%al
 d2a:	0f 84 3d ff ff ff    	je     c6d <printf+0x4d>
 d30:	8d 55 e7             	lea    -0x19(%ebp),%edx
 d33:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 d36:	89 de                	mov    %ebx,%esi
 d38:	89 d3                	mov    %edx,%ebx
 d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 d40:	83 ec 04             	sub    $0x4,%esp
 d43:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 d46:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 d49:	6a 01                	push   $0x1
 d4b:	53                   	push   %ebx
 d4c:	57                   	push   %edi
 d4d:	e8 91 fd ff ff       	call   ae3 <write>
        while(*s != 0){
 d52:	0f b6 06             	movzbl (%esi),%eax
 d55:	83 c4 10             	add    $0x10,%esp
 d58:	84 c0                	test   %al,%al
 d5a:	75 e4                	jne    d40 <printf+0x120>
      state = 0;
 d5c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 d5f:	31 d2                	xor    %edx,%edx
 d61:	e9 07 ff ff ff       	jmp    c6d <printf+0x4d>
 d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 d6d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 d70:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 d73:	83 ec 0c             	sub    $0xc,%esp
 d76:	b9 0a 00 00 00       	mov    $0xa,%ecx
 d7b:	8b 13                	mov    (%ebx),%edx
 d7d:	6a 01                	push   $0x1
 d7f:	e9 6b ff ff ff       	jmp    cef <printf+0xcf>
 d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 d88:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 d8b:	83 ec 04             	sub    $0x4,%esp
 d8e:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 d91:	8b 03                	mov    (%ebx),%eax
        ap++;
 d93:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 d96:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 d99:	6a 01                	push   $0x1
 d9b:	52                   	push   %edx
 d9c:	57                   	push   %edi
 d9d:	e8 41 fd ff ff       	call   ae3 <write>
        ap++;
 da2:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 da5:	83 c4 10             	add    $0x10,%esp
      state = 0;
 da8:	31 d2                	xor    %edx,%edx
 daa:	e9 be fe ff ff       	jmp    c6d <printf+0x4d>
 daf:	90                   	nop
  write(fd, &c, 1);
 db0:	83 ec 04             	sub    $0x4,%esp
 db3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 db6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 db9:	6a 01                	push   $0x1
 dbb:	e9 11 ff ff ff       	jmp    cd1 <printf+0xb1>
 dc0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 dc5:	bb e8 12 00 00       	mov    $0x12e8,%ebx
 dca:	e9 61 ff ff ff       	jmp    d30 <printf+0x110>
 dcf:	90                   	nop

00000dd0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 dd0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 dd1:	a1 c0 18 00 00       	mov    0x18c0,%eax
{
 dd6:	89 e5                	mov    %esp,%ebp
 dd8:	57                   	push   %edi
 dd9:	56                   	push   %esi
 dda:	53                   	push   %ebx
 ddb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 dde:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 de8:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 dea:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 dec:	39 ca                	cmp    %ecx,%edx
 dee:	73 30                	jae    e20 <free+0x50>
 df0:	39 c1                	cmp    %eax,%ecx
 df2:	72 04                	jb     df8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 df4:	39 c2                	cmp    %eax,%edx
 df6:	72 f0                	jb     de8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 df8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 dfb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 dfe:	39 f8                	cmp    %edi,%eax
 e00:	74 2e                	je     e30 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 e02:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 e05:	8b 42 04             	mov    0x4(%edx),%eax
 e08:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 e0b:	39 f1                	cmp    %esi,%ecx
 e0d:	74 38                	je     e47 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 e0f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 e11:	5b                   	pop    %ebx
  freep = p;
 e12:	89 15 c0 18 00 00    	mov    %edx,0x18c0
}
 e18:	5e                   	pop    %esi
 e19:	5f                   	pop    %edi
 e1a:	5d                   	pop    %ebp
 e1b:	c3                   	ret
 e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e20:	39 c1                	cmp    %eax,%ecx
 e22:	72 d0                	jb     df4 <free+0x24>
 e24:	eb c2                	jmp    de8 <free+0x18>
 e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 e2d:	8d 76 00             	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 e30:	03 70 04             	add    0x4(%eax),%esi
 e33:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 e36:	8b 02                	mov    (%edx),%eax
 e38:	8b 00                	mov    (%eax),%eax
 e3a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 e3d:	8b 42 04             	mov    0x4(%edx),%eax
 e40:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 e43:	39 f1                	cmp    %esi,%ecx
 e45:	75 c8                	jne    e0f <free+0x3f>
    p->s.size += bp->s.size;
 e47:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 e4a:	89 15 c0 18 00 00    	mov    %edx,0x18c0
    p->s.size += bp->s.size;
 e50:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 e53:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 e56:	89 0a                	mov    %ecx,(%edx)
}
 e58:	5b                   	pop    %ebx
 e59:	5e                   	pop    %esi
 e5a:	5f                   	pop    %edi
 e5b:	5d                   	pop    %ebp
 e5c:	c3                   	ret
 e5d:	8d 76 00             	lea    0x0(%esi),%esi

00000e60 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 e60:	55                   	push   %ebp
 e61:	89 e5                	mov    %esp,%ebp
 e63:	57                   	push   %edi
 e64:	56                   	push   %esi
 e65:	53                   	push   %ebx
 e66:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e69:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 e6c:	8b 15 c0 18 00 00    	mov    0x18c0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e72:	8d 78 07             	lea    0x7(%eax),%edi
 e75:	c1 ef 03             	shr    $0x3,%edi
 e78:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 e7b:	85 d2                	test   %edx,%edx
 e7d:	0f 84 8d 00 00 00    	je     f10 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e83:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 e85:	8b 48 04             	mov    0x4(%eax),%ecx
 e88:	39 f9                	cmp    %edi,%ecx
 e8a:	73 64                	jae    ef0 <malloc+0x90>
  if(nu < 4096)
 e8c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 e91:	39 df                	cmp    %ebx,%edi
 e93:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 e96:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 e9d:	eb 0a                	jmp    ea9 <malloc+0x49>
 e9f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ea0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 ea2:	8b 48 04             	mov    0x4(%eax),%ecx
 ea5:	39 f9                	cmp    %edi,%ecx
 ea7:	73 47                	jae    ef0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ea9:	89 c2                	mov    %eax,%edx
 eab:	39 05 c0 18 00 00    	cmp    %eax,0x18c0
 eb1:	75 ed                	jne    ea0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 eb3:	83 ec 0c             	sub    $0xc,%esp
 eb6:	56                   	push   %esi
 eb7:	e8 8f fc ff ff       	call   b4b <sbrk>
  if(p == (char*)-1)
 ebc:	83 c4 10             	add    $0x10,%esp
 ebf:	83 f8 ff             	cmp    $0xffffffff,%eax
 ec2:	74 1c                	je     ee0 <malloc+0x80>
  hp->s.size = nu;
 ec4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 ec7:	83 ec 0c             	sub    $0xc,%esp
 eca:	83 c0 08             	add    $0x8,%eax
 ecd:	50                   	push   %eax
 ece:	e8 fd fe ff ff       	call   dd0 <free>
  return freep;
 ed3:	8b 15 c0 18 00 00    	mov    0x18c0,%edx
      if((p = morecore(nunits)) == 0)
 ed9:	83 c4 10             	add    $0x10,%esp
 edc:	85 d2                	test   %edx,%edx
 ede:	75 c0                	jne    ea0 <malloc+0x40>
        return 0;
  }
}
 ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 ee3:	31 c0                	xor    %eax,%eax
}
 ee5:	5b                   	pop    %ebx
 ee6:	5e                   	pop    %esi
 ee7:	5f                   	pop    %edi
 ee8:	5d                   	pop    %ebp
 ee9:	c3                   	ret
 eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 ef0:	39 cf                	cmp    %ecx,%edi
 ef2:	74 4c                	je     f40 <malloc+0xe0>
        p->s.size -= nunits;
 ef4:	29 f9                	sub    %edi,%ecx
 ef6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 ef9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 efc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 eff:	89 15 c0 18 00 00    	mov    %edx,0x18c0
}
 f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 f08:	83 c0 08             	add    $0x8,%eax
}
 f0b:	5b                   	pop    %ebx
 f0c:	5e                   	pop    %esi
 f0d:	5f                   	pop    %edi
 f0e:	5d                   	pop    %ebp
 f0f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 f10:	c7 05 c0 18 00 00 c4 	movl   $0x18c4,0x18c0
 f17:	18 00 00 
    base.s.size = 0;
 f1a:	b8 c4 18 00 00       	mov    $0x18c4,%eax
    base.s.ptr = freep = prevp = &base;
 f1f:	c7 05 c4 18 00 00 c4 	movl   $0x18c4,0x18c4
 f26:	18 00 00 
    base.s.size = 0;
 f29:	c7 05 c8 18 00 00 00 	movl   $0x0,0x18c8
 f30:	00 00 00 
    if(p->s.size >= nunits){
 f33:	e9 54 ff ff ff       	jmp    e8c <malloc+0x2c>
 f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 f3f:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 f40:	8b 08                	mov    (%eax),%ecx
 f42:	89 0a                	mov    %ecx,(%edx)
 f44:	eb b9                	jmp    eff <malloc+0x9f>
