
_symlinktest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
static void concur(void);
static void cleanup(void);

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 34             	sub    $0x34,%esp
}

static void
cleanup(void)
{
  unlink("/testsymlink/a");
  14:	68 c8 0c 00 00       	push   $0xcc8
  19:	e8 85 08 00 00       	call   8a3 <unlink>
  unlink("/testsymlink/b");
  1e:	c7 04 24 d7 0c 00 00 	movl   $0xcd7,(%esp)
  25:	e8 79 08 00 00       	call   8a3 <unlink>
  unlink("/testsymlink/c");
  2a:	c7 04 24 e6 0c 00 00 	movl   $0xce6,(%esp)
  31:	e8 6d 08 00 00       	call   8a3 <unlink>
  unlink("/testsymlink/1");
  36:	c7 04 24 f5 0c 00 00 	movl   $0xcf5,(%esp)
  3d:	e8 61 08 00 00       	call   8a3 <unlink>
  unlink("/testsymlink/2");
  42:	c7 04 24 04 0d 00 00 	movl   $0xd04,(%esp)
  49:	e8 55 08 00 00       	call   8a3 <unlink>
  unlink("/testsymlink/3");
  4e:	c7 04 24 13 0d 00 00 	movl   $0xd13,(%esp)
  55:	e8 49 08 00 00       	call   8a3 <unlink>
  unlink("/testsymlink/4");
  5a:	c7 04 24 22 0d 00 00 	movl   $0xd22,(%esp)
  61:	e8 3d 08 00 00       	call   8a3 <unlink>
  unlink("/testsymlink/z");
  66:	c7 04 24 31 0d 00 00 	movl   $0xd31,(%esp)
  6d:	e8 31 08 00 00       	call   8a3 <unlink>
  unlink("/testsymlink/y");
  72:	c7 04 24 40 0d 00 00 	movl   $0xd40,(%esp)
  79:	e8 25 08 00 00       	call   8a3 <unlink>
  unlink("/testsymlink");
  7e:	c7 04 24 4f 0d 00 00 	movl   $0xd4f,(%esp)
  85:	e8 19 08 00 00       	call   8a3 <unlink>
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
  char c = 0, c2 = 0;
  struct stat st;
    
  printf(1,"Start: test symlinks\n");
  8a:	58                   	pop    %eax
  8b:	5a                   	pop    %edx
  8c:	68 5c 0d 00 00       	push   $0xd5c
  91:	6a 01                	push   $0x1
  char buf[4] = {'a', 'b', 'c', 'd'};
  93:	c7 45 d0 61 62 63 64 	movl   $0x64636261,-0x30(%ebp)
  char c = 0, c2 = 0;
  9a:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
  9e:	c6 45 cf 00          	movb   $0x0,-0x31(%ebp)
  printf(1,"Start: test symlinks\n");
  a2:	e8 f9 08 00 00       	call   9a0 <printf>

  mkdir("/testsymlink");
  a7:	c7 04 24 4f 0d 00 00 	movl   $0xd4f,(%esp)
  ae:	e8 08 08 00 00       	call   8bb <mkdir>

  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
  b3:	59                   	pop    %ecx
  b4:	5b                   	pop    %ebx
  b5:	68 02 02 00 00       	push   $0x202
  ba:	68 c8 0c 00 00       	push   $0xcc8
  bf:	e8 cf 07 00 00       	call   893 <open>
  if(fd1 < 0) fail("failed to open a");
  c4:	83 c4 10             	add    $0x10,%esp
  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
  c7:	89 c3                	mov    %eax,%ebx
  if(fd1 < 0) fail("failed to open a");
  c9:	85 c0                	test   %eax,%eax
  cb:	0f 88 9d 02 00 00    	js     36e <main+0x36e>


  r = symlink("/testsymlink/a", "/testsymlink/b");
  d1:	83 ec 08             	sub    $0x8,%esp
  d4:	68 d7 0c 00 00       	push   $0xcd7
  d9:	68 c8 0c 00 00       	push   $0xcc8
  de:	e8 10 08 00 00       	call   8f3 <symlink>
  if(r < 0)
  e3:	83 c4 10             	add    $0x10,%esp
  e6:	85 c0                	test   %eax,%eax
  e8:	0f 88 ac 02 00 00    	js     39a <main+0x39a>
    fail("symlink b -> a failed");


  if(write(fd1, buf, sizeof(buf)) != 4)
  ee:	50                   	push   %eax
  ef:	8d 45 d0             	lea    -0x30(%ebp),%eax
  f2:	6a 04                	push   $0x4
  f4:	50                   	push   %eax
  f5:	53                   	push   %ebx
  f6:	e8 78 07 00 00       	call   873 <write>
  fb:	83 c4 10             	add    $0x10,%esp
  fe:	83 f8 04             	cmp    $0x4,%eax
 101:	0f 84 af 00 00 00    	je     1b6 <main+0x1b6>
    fail("failed to write to a");
 107:	50                   	push   %eax
 108:	50                   	push   %eax
 109:	68 24 0f 00 00       	push   $0xf24
 10e:	6a 01                	push   $0x1
 110:	e8 8b 08 00 00       	call   9a0 <printf>
 115:	83 c4 10             	add    $0x10,%esp
  int r, fd1 = -1, fd2 = -1;
 118:	83 ce ff             	or     $0xffffffff,%esi
  if(c!=c2)
    fail("Value read from 4 differed from value written to 1\n");

  printf(1,"test symlinks: ok\n");
done:
  close(fd1);
 11b:	83 ec 0c             	sub    $0xc,%esp
 11e:	53                   	push   %ebx
 11f:	e8 57 07 00 00       	call   87b <close>
  close(fd2);
 124:	89 34 24             	mov    %esi,(%esp)
 127:	e8 4f 07 00 00       	call   87b <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf(1,"Start: test concurrent symlinks\n");
 12c:	5e                   	pop    %esi
 12d:	5f                   	pop    %edi
 12e:	68 c0 10 00 00       	push   $0x10c0
 133:	6a 01                	push   $0x1
 135:	e8 66 08 00 00       	call   9a0 <printf>
    
  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
 13a:	58                   	pop    %eax
 13b:	5a                   	pop    %edx
 13c:	68 02 02 00 00       	push   $0x202
 141:	68 31 0d 00 00       	push   $0xd31
 146:	e8 48 07 00 00       	call   893 <open>
  if(fd < 0) {
 14b:	83 c4 10             	add    $0x10,%esp
 14e:	85 c0                	test   %eax,%eax
 150:	0f 88 34 04 00 00    	js     58a <main+0x58a>
    printf(1,"FAILED: open failed");
    exit();
  }
  close(fd);
 156:	83 ec 0c             	sub    $0xc,%esp
 159:	50                   	push   %eax
 15a:	e8 1c 07 00 00       	call   87b <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
 15f:	e8 e7 06 00 00       	call   84b <fork>
    if(pid < 0){
 164:	83 c4 10             	add    $0x10,%esp
 167:	85 c0                	test   %eax,%eax
 169:	0f 88 2e 04 00 00    	js     59d <main+0x59d>
      printf(1,"FAILED: fork failed\n");
      exit();
    }
    if(pid == 0) {
 16f:	0f 84 3e 02 00 00    	je     3b3 <main+0x3b3>
    pid = fork();
 175:	e8 d1 06 00 00       	call   84b <fork>
    if(pid < 0){
 17a:	85 c0                	test   %eax,%eax
 17c:	0f 88 1b 04 00 00    	js     59d <main+0x59d>
    if(pid == 0) {
 182:	0f 84 2b 02 00 00    	je     3b3 <main+0x3b3>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    r = wait();
 188:	e8 ce 06 00 00       	call   85b <wait>
    if(r < 0) {
 18d:	85 c0                	test   %eax,%eax
 18f:	0f 88 1b 04 00 00    	js     5b0 <main+0x5b0>
    r = wait();
 195:	e8 c1 06 00 00       	call   85b <wait>
    if(r < 0) {
 19a:	85 c0                	test   %eax,%eax
 19c:	0f 88 0e 04 00 00    	js     5b0 <main+0x5b0>
      printf(1,"test concurrent symlinks: failed %d \n",r);
      exit();
    }
  }
  printf(1,"test concurrent symlinks: ok\n");
 1a2:	83 ec 08             	sub    $0x8,%esp
 1a5:	68 e5 0e 00 00       	push   $0xee5
 1aa:	6a 01                	push   $0x1
 1ac:	e8 ef 07 00 00       	call   9a0 <printf>
  exit();
 1b1:	e8 9d 06 00 00       	call   853 <exit>
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
 1b6:	57                   	push   %edi
 1b7:	57                   	push   %edi
 1b8:	68 00 01 00 00       	push   $0x100
 1bd:	68 d7 0c 00 00       	push   $0xcd7
 1c2:	e8 cc 06 00 00       	call   893 <open>
  if(fd < 0)
 1c7:	83 c4 10             	add    $0x10,%esp
 1ca:	85 c0                	test   %eax,%eax
 1cc:	0f 88 74 02 00 00    	js     446 <main+0x446>
  if(fstat(fd, st) != 0)
 1d2:	8d 55 d4             	lea    -0x2c(%ebp),%edx
 1d5:	56                   	push   %esi
 1d6:	56                   	push   %esi
 1d7:	52                   	push   %edx
 1d8:	50                   	push   %eax
 1d9:	e8 cd 06 00 00       	call   8ab <fstat>
 1de:	83 c4 10             	add    $0x10,%esp
 1e1:	85 c0                	test   %eax,%eax
 1e3:	0f 85 5d 02 00 00    	jne    446 <main+0x446>
  if(st.type != T_SYMLINK)
 1e9:	66 83 7d d4 04       	cmpw   $0x4,-0x2c(%ebp)
 1ee:	0f 85 90 01 00 00    	jne    384 <main+0x384>
  fd2 = open("/testsymlink/b", O_RDWR);
 1f4:	50                   	push   %eax
 1f5:	50                   	push   %eax
 1f6:	6a 02                	push   $0x2
 1f8:	68 d7 0c 00 00       	push   $0xcd7
 1fd:	e8 91 06 00 00       	call   893 <open>
  if(fd2 < 0)
 202:	83 c4 10             	add    $0x10,%esp
  fd2 = open("/testsymlink/b", O_RDWR);
 205:	89 c6                	mov    %eax,%esi
  if(fd2 < 0)
 207:	85 c0                	test   %eax,%eax
 209:	0f 88 63 02 00 00    	js     472 <main+0x472>
  read(fd2, &c, 1);
 20f:	8d 7d ce             	lea    -0x32(%ebp),%edi
 212:	50                   	push   %eax
 213:	6a 01                	push   $0x1
 215:	57                   	push   %edi
 216:	56                   	push   %esi
 217:	e8 4f 06 00 00       	call   86b <read>
  if (c != 'a')
 21c:	83 c4 10             	add    $0x10,%esp
 21f:	80 7d ce 61          	cmpb   $0x61,-0x32(%ebp)
 223:	0f 85 33 02 00 00    	jne    45c <main+0x45c>
  unlink("/testsymlink/a");
 229:	83 ec 0c             	sub    $0xc,%esp
 22c:	68 c8 0c 00 00       	push   $0xcc8
 231:	e8 6d 06 00 00       	call   8a3 <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
 236:	59                   	pop    %ecx
 237:	58                   	pop    %eax
 238:	6a 02                	push   $0x2
 23a:	68 d7 0c 00 00       	push   $0xcd7
 23f:	e8 4f 06 00 00       	call   893 <open>
 244:	83 c4 10             	add    $0x10,%esp
 247:	85 c0                	test   %eax,%eax
 249:	0f 89 39 02 00 00    	jns    488 <main+0x488>
  r = symlink("/testsymlink/b", "/testsymlink/a");
 24f:	50                   	push   %eax
 250:	50                   	push   %eax
 251:	68 c8 0c 00 00       	push   $0xcc8
 256:	68 d7 0c 00 00       	push   $0xcd7
 25b:	e8 93 06 00 00       	call   8f3 <symlink>
  if(r < 0)
 260:	83 c4 10             	add    $0x10,%esp
 263:	85 c0                	test   %eax,%eax
 265:	0f 88 49 02 00 00    	js     4b4 <main+0x4b4>
  r = open("/testsymlink/b", O_RDWR);
 26b:	50                   	push   %eax
 26c:	50                   	push   %eax
 26d:	6a 02                	push   $0x2
 26f:	68 d7 0c 00 00       	push   $0xcd7
 274:	e8 1a 06 00 00       	call   893 <open>
  if(r >= 0)
 279:	83 c4 10             	add    $0x10,%esp
 27c:	85 c0                	test   %eax,%eax
 27e:	0f 89 1a 02 00 00    	jns    49e <main+0x49e>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
 284:	50                   	push   %eax
 285:	50                   	push   %eax
 286:	68 e6 0c 00 00       	push   $0xce6
 28b:	68 df 0d 00 00       	push   $0xddf
 290:	e8 5e 06 00 00       	call   8f3 <symlink>
  if(r != 0)
 295:	83 c4 10             	add    $0x10,%esp
 298:	85 c0                	test   %eax,%eax
 29a:	0f 85 2a 02 00 00    	jne    4ca <main+0x4ca>
  r = symlink("/testsymlink/2", "/testsymlink/1");
 2a0:	51                   	push   %ecx
 2a1:	51                   	push   %ecx
 2a2:	68 f5 0c 00 00       	push   $0xcf5
 2a7:	68 04 0d 00 00       	push   $0xd04
 2ac:	e8 42 06 00 00       	call   8f3 <symlink>
  if(r) fail("Failed to link 1->2");
 2b1:	83 c4 10             	add    $0x10,%esp
 2b4:	85 c0                	test   %eax,%eax
 2b6:	0f 85 24 02 00 00    	jne    4e0 <main+0x4e0>
  r = symlink("/testsymlink/3", "/testsymlink/2");
 2bc:	50                   	push   %eax
 2bd:	50                   	push   %eax
 2be:	68 04 0d 00 00       	push   $0xd04
 2c3:	68 13 0d 00 00       	push   $0xd13
 2c8:	e8 26 06 00 00       	call   8f3 <symlink>
  if(r) fail("Failed to link 2->3");
 2cd:	83 c4 10             	add    $0x10,%esp
 2d0:	85 c0                	test   %eax,%eax
 2d2:	0f 85 1e 02 00 00    	jne    4f6 <main+0x4f6>
  r = symlink("/testsymlink/4", "/testsymlink/3");
 2d8:	50                   	push   %eax
 2d9:	50                   	push   %eax
 2da:	68 13 0d 00 00       	push   $0xd13
 2df:	68 22 0d 00 00       	push   $0xd22
 2e4:	e8 0a 06 00 00       	call   8f3 <symlink>
  if(r) fail("Failed to link 3->4");
 2e9:	83 c4 10             	add    $0x10,%esp
 2ec:	85 c0                	test   %eax,%eax
 2ee:	0f 85 80 02 00 00    	jne    574 <main+0x574>
  close(fd1);
 2f4:	83 ec 0c             	sub    $0xc,%esp
 2f7:	53                   	push   %ebx
 2f8:	e8 7e 05 00 00       	call   87b <close>
  close(fd2);
 2fd:	89 34 24             	mov    %esi,(%esp)
 300:	e8 76 05 00 00       	call   87b <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
 305:	5b                   	pop    %ebx
 306:	58                   	pop    %eax
 307:	68 02 02 00 00       	push   $0x202
 30c:	68 22 0d 00 00       	push   $0xd22
 311:	e8 7d 05 00 00       	call   893 <open>
  if(fd1<0) fail("Failed to create 4\n");
 316:	83 c4 10             	add    $0x10,%esp
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
 319:	89 c3                	mov    %eax,%ebx
  if(fd1<0) fail("Failed to create 4\n");
 31b:	85 c0                	test   %eax,%eax
 31d:	0f 88 3b 02 00 00    	js     55e <main+0x55e>
  fd2 = open("/testsymlink/1", O_RDWR);
 323:	52                   	push   %edx
 324:	52                   	push   %edx
 325:	6a 02                	push   $0x2
 327:	68 f5 0c 00 00       	push   $0xcf5
 32c:	e8 62 05 00 00       	call   893 <open>
  if(fd2<0) fail("Failed to open 1\n");
 331:	83 c4 10             	add    $0x10,%esp
  fd2 = open("/testsymlink/1", O_RDWR);
 334:	89 c6                	mov    %eax,%esi
  if(fd2<0) fail("Failed to open 1\n");
 336:	85 c0                	test   %eax,%eax
 338:	0f 88 0a 02 00 00    	js     548 <main+0x548>
  r = write(fd2, &c, 1);
 33e:	50                   	push   %eax
 33f:	6a 01                	push   $0x1
 341:	57                   	push   %edi
 342:	56                   	push   %esi
  c = '#';
 343:	c6 45 ce 23          	movb   $0x23,-0x32(%ebp)
  r = write(fd2, &c, 1);
 347:	e8 27 05 00 00       	call   873 <write>
  if(r!=1) fail("Failed to write to 1\n");
 34c:	83 c4 10             	add    $0x10,%esp
 34f:	83 e8 01             	sub    $0x1,%eax
 352:	0f 84 b4 01 00 00    	je     50c <main+0x50c>
 358:	50                   	push   %eax
 359:	50                   	push   %eax
 35a:	68 3c 10 00 00       	push   $0x103c
 35f:	6a 01                	push   $0x1
 361:	e8 3a 06 00 00       	call   9a0 <printf>
 366:	83 c4 10             	add    $0x10,%esp
 369:	e9 ad fd ff ff       	jmp    11b <main+0x11b>
  if(fd1 < 0) fail("failed to open a");
 36e:	50                   	push   %eax
 36f:	50                   	push   %eax
 370:	68 72 0d 00 00       	push   $0xd72
 375:	6a 01                	push   $0x1
 377:	e8 24 06 00 00       	call   9a0 <printf>
 37c:	83 c4 10             	add    $0x10,%esp
 37f:	e9 94 fd ff ff       	jmp    118 <main+0x118>
    fail("b isn't a symlink");
 384:	52                   	push   %edx
 385:	52                   	push   %edx
 386:	68 a8 0d 00 00       	push   $0xda8
 38b:	6a 01                	push   $0x1
 38d:	e8 0e 06 00 00       	call   9a0 <printf>
 392:	83 c4 10             	add    $0x10,%esp
 395:	e9 7e fd ff ff       	jmp    118 <main+0x118>
    fail("symlink b -> a failed");
 39a:	50                   	push   %eax
  int r, fd1 = -1, fd2 = -1;
 39b:	83 ce ff             	or     $0xffffffff,%esi
    fail("symlink b -> a failed");
 39e:	50                   	push   %eax
 39f:	68 04 0f 00 00       	push   $0xf04
 3a4:	6a 01                	push   $0x1
 3a6:	e8 f5 05 00 00       	call   9a0 <printf>
 3ab:	83 c4 10             	add    $0x10,%esp
 3ae:	e9 68 fd ff ff       	jmp    11b <main+0x11b>
  int r, fd1 = -1, fd2 = -1;
 3b3:	be 64 00 00 00       	mov    $0x64,%esi
 3b8:	bb 61 00 00 00       	mov    $0x61,%ebx
  if(fstat(fd, st) != 0)
 3bd:	8d 7d d4             	lea    -0x2c(%ebp),%edi
 3c0:	eb 54                	jmp    416 <main+0x416>
 3c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          symlink("/testsymlink/z", "/testsymlink/y");
 3c8:	83 ec 08             	sub    $0x8,%esp
 3cb:	68 40 0d 00 00       	push   $0xd40
 3d0:	68 31 0d 00 00       	push   $0xd31
 3d5:	e8 19 05 00 00       	call   8f3 <symlink>
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
 3da:	58                   	pop    %eax
 3db:	5a                   	pop    %edx
 3dc:	68 00 01 00 00       	push   $0x100
 3e1:	68 40 0d 00 00       	push   $0xd40
 3e6:	e8 a8 04 00 00       	call   893 <open>
  if(fd < 0)
 3eb:	83 c4 10             	add    $0x10,%esp
 3ee:	85 c0                	test   %eax,%eax
 3f0:	78 1f                	js     411 <main+0x411>
  if(fstat(fd, st) != 0)
 3f2:	83 ec 08             	sub    $0x8,%esp
 3f5:	57                   	push   %edi
 3f6:	50                   	push   %eax
 3f7:	e8 af 04 00 00       	call   8ab <fstat>
 3fc:	83 c4 10             	add    $0x10,%esp
 3ff:	85 c0                	test   %eax,%eax
 401:	75 0e                	jne    411 <main+0x411>
            if(st.type != T_SYMLINK) {
 403:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
 407:	66 83 f8 04          	cmp    $0x4,%ax
 40b:	0f 85 b2 01 00 00    	jne    5c3 <main+0x5c3>
      for(i = 0; i < 100; i++){
 411:	83 ee 01             	sub    $0x1,%esi
 414:	74 2b                	je     441 <main+0x441>
        x = x * 1103515245 + 12345;
 416:	69 db 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%ebx
 41c:	81 c3 39 30 00 00    	add    $0x3039,%ebx
 422:	69 c3 ab aa aa aa    	imul   $0xaaaaaaab,%ebx,%eax
        if((x % 3) == 0) {
 428:	3d 55 55 55 55       	cmp    $0x55555555,%eax
 42d:	76 99                	jbe    3c8 <main+0x3c8>
          unlink("/testsymlink/y");
 42f:	83 ec 0c             	sub    $0xc,%esp
 432:	68 40 0d 00 00       	push   $0xd40
 437:	e8 67 04 00 00       	call   8a3 <unlink>
 43c:	83 c4 10             	add    $0x10,%esp
 43f:	eb d0                	jmp    411 <main+0x411>
      exit();
 441:	e8 0d 04 00 00       	call   853 <exit>
    fail("failed to stat b");
 446:	51                   	push   %ecx
 447:	51                   	push   %ecx
 448:	68 8d 0d 00 00       	push   $0xd8d
 44d:	6a 01                	push   $0x1
 44f:	e8 4c 05 00 00       	call   9a0 <printf>
 454:	83 c4 10             	add    $0x10,%esp
 457:	e9 bc fc ff ff       	jmp    118 <main+0x118>
    fail("failed to read bytes from b");
 45c:	50                   	push   %eax
 45d:	50                   	push   %eax
 45e:	68 44 0f 00 00       	push   $0xf44
 463:	6a 01                	push   $0x1
 465:	e8 36 05 00 00       	call   9a0 <printf>
 46a:	83 c4 10             	add    $0x10,%esp
 46d:	e9 a9 fc ff ff       	jmp    11b <main+0x11b>
    fail("failed to open b");
 472:	50                   	push   %eax
 473:	50                   	push   %eax
 474:	68 c4 0d 00 00       	push   $0xdc4
 479:	6a 01                	push   $0x1
 47b:	e8 20 05 00 00       	call   9a0 <printf>
 480:	83 c4 10             	add    $0x10,%esp
 483:	e9 93 fc ff ff       	jmp    11b <main+0x11b>
    fail("Should not be able to open b after deleting a");
 488:	52                   	push   %edx
 489:	52                   	push   %edx
 48a:	68 6c 0f 00 00       	push   $0xf6c
 48f:	6a 01                	push   $0x1
 491:	e8 0a 05 00 00       	call   9a0 <printf>
 496:	83 c4 10             	add    $0x10,%esp
 499:	e9 7d fc ff ff       	jmp    11b <main+0x11b>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
 49e:	50                   	push   %eax
 49f:	50                   	push   %eax
 4a0:	68 c4 0f 00 00       	push   $0xfc4
 4a5:	6a 01                	push   $0x1
 4a7:	e8 f4 04 00 00       	call   9a0 <printf>
 4ac:	83 c4 10             	add    $0x10,%esp
 4af:	e9 67 fc ff ff       	jmp    11b <main+0x11b>
    fail("symlink a -> b failed");
 4b4:	50                   	push   %eax
 4b5:	50                   	push   %eax
 4b6:	68 a4 0f 00 00       	push   $0xfa4
 4bb:	6a 01                	push   $0x1
 4bd:	e8 de 04 00 00       	call   9a0 <printf>
 4c2:	83 c4 10             	add    $0x10,%esp
 4c5:	e9 51 fc ff ff       	jmp    11b <main+0x11b>
    fail("Symlinking to nonexistent file should succeed\n");
 4ca:	57                   	push   %edi
 4cb:	57                   	push   %edi
 4cc:	68 00 10 00 00       	push   $0x1000
 4d1:	6a 01                	push   $0x1
 4d3:	e8 c8 04 00 00       	call   9a0 <printf>
 4d8:	83 c4 10             	add    $0x10,%esp
 4db:	e9 3b fc ff ff       	jmp    11b <main+0x11b>
  if(r) fail("Failed to link 1->2");
 4e0:	52                   	push   %edx
 4e1:	52                   	push   %edx
 4e2:	68 f8 0d 00 00       	push   $0xdf8
 4e7:	6a 01                	push   $0x1
 4e9:	e8 b2 04 00 00       	call   9a0 <printf>
 4ee:	83 c4 10             	add    $0x10,%esp
 4f1:	e9 25 fc ff ff       	jmp    11b <main+0x11b>
  if(r) fail("Failed to link 2->3");
 4f6:	50                   	push   %eax
 4f7:	50                   	push   %eax
 4f8:	68 16 0e 00 00       	push   $0xe16
 4fd:	6a 01                	push   $0x1
 4ff:	e8 9c 04 00 00       	call   9a0 <printf>
 504:	83 c4 10             	add    $0x10,%esp
 507:	e9 0f fc ff ff       	jmp    11b <main+0x11b>
  r = read(fd1, &c2, 1);
 50c:	50                   	push   %eax
 50d:	8d 45 cf             	lea    -0x31(%ebp),%eax
 510:	6a 01                	push   $0x1
 512:	50                   	push   %eax
 513:	53                   	push   %ebx
 514:	e8 52 03 00 00       	call   86b <read>
  if(r!=1) fail("Failed to read from 4\n");
 519:	83 c4 10             	add    $0x10,%esp
 51c:	83 e8 01             	sub    $0x1,%eax
 51f:	0f 85 c6 00 00 00    	jne    5eb <main+0x5eb>
  if(c!=c2)
 525:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
 529:	38 45 ce             	cmp    %al,-0x32(%ebp)
 52c:	0f 84 a3 00 00 00    	je     5d5 <main+0x5d5>
    fail("Value read from 4 differed from value written to 1\n");
 532:	57                   	push   %edi
 533:	57                   	push   %edi
 534:	68 80 10 00 00       	push   $0x1080
 539:	6a 01                	push   $0x1
 53b:	e8 60 04 00 00       	call   9a0 <printf>
 540:	83 c4 10             	add    $0x10,%esp
 543:	e9 d3 fb ff ff       	jmp    11b <main+0x11b>
  if(fd2<0) fail("Failed to open 1\n");
 548:	50                   	push   %eax
 549:	50                   	push   %eax
 54a:	68 70 0e 00 00       	push   $0xe70
 54f:	6a 01                	push   $0x1
 551:	e8 4a 04 00 00       	call   9a0 <printf>
 556:	83 c4 10             	add    $0x10,%esp
 559:	e9 bd fb ff ff       	jmp    11b <main+0x11b>
  if(fd1<0) fail("Failed to create 4\n");
 55e:	51                   	push   %ecx
 55f:	51                   	push   %ecx
 560:	68 52 0e 00 00       	push   $0xe52
 565:	6a 01                	push   $0x1
 567:	e8 34 04 00 00       	call   9a0 <printf>
 56c:	83 c4 10             	add    $0x10,%esp
 56f:	e9 a7 fb ff ff       	jmp    11b <main+0x11b>
  if(r) fail("Failed to link 3->4");
 574:	50                   	push   %eax
 575:	50                   	push   %eax
 576:	68 34 0e 00 00       	push   $0xe34
 57b:	6a 01                	push   $0x1
 57d:	e8 1e 04 00 00       	call   9a0 <printf>
 582:	83 c4 10             	add    $0x10,%esp
 585:	e9 91 fb ff ff       	jmp    11b <main+0x11b>
    printf(1,"FAILED: open failed");
 58a:	53                   	push   %ebx
 58b:	53                   	push   %ebx
 58c:	68 9f 0e 00 00       	push   $0xe9f
 591:	6a 01                	push   $0x1
 593:	e8 08 04 00 00       	call   9a0 <printf>
    exit();
 598:	e8 b6 02 00 00       	call   853 <exit>
      printf(1,"FAILED: fork failed\n");
 59d:	51                   	push   %ecx
 59e:	51                   	push   %ecx
 59f:	68 b3 0e 00 00       	push   $0xeb3
 5a4:	6a 01                	push   $0x1
 5a6:	e8 f5 03 00 00       	call   9a0 <printf>
      exit();
 5ab:	e8 a3 02 00 00       	call   853 <exit>
      printf(1,"test concurrent symlinks: failed %d \n",r);
 5b0:	52                   	push   %edx
 5b1:	50                   	push   %eax
 5b2:	68 e4 10 00 00       	push   $0x10e4
 5b7:	6a 01                	push   $0x1
 5b9:	e8 e2 03 00 00       	call   9a0 <printf>
      exit();
 5be:	e8 90 02 00 00       	call   853 <exit>
              printf("FAILED: not a symbolic link\n", st.type);
 5c3:	51                   	push   %ecx
 5c4:	51                   	push   %ecx
 5c5:	50                   	push   %eax
 5c6:	68 c8 0e 00 00       	push   $0xec8
 5cb:	e8 d0 03 00 00       	call   9a0 <printf>
              exit();
 5d0:	e8 7e 02 00 00       	call   853 <exit>
  printf(1,"test symlinks: ok\n");
 5d5:	51                   	push   %ecx
 5d6:	51                   	push   %ecx
 5d7:	68 8c 0e 00 00       	push   $0xe8c
 5dc:	6a 01                	push   $0x1
 5de:	e8 bd 03 00 00       	call   9a0 <printf>
 5e3:	83 c4 10             	add    $0x10,%esp
 5e6:	e9 30 fb ff ff       	jmp    11b <main+0x11b>
  if(r!=1) fail("Failed to read from 4\n");
 5eb:	50                   	push   %eax
 5ec:	50                   	push   %eax
 5ed:	68 5c 10 00 00       	push   $0x105c
 5f2:	6a 01                	push   $0x1
 5f4:	e8 a7 03 00 00       	call   9a0 <printf>
 5f9:	83 c4 10             	add    $0x10,%esp
 5fc:	e9 1a fb ff ff       	jmp    11b <main+0x11b>
 601:	66 90                	xchg   %ax,%ax
 603:	66 90                	xchg   %ax,%ax
 605:	66 90                	xchg   %ax,%ax
 607:	66 90                	xchg   %ax,%ax
 609:	66 90                	xchg   %ax,%ax
 60b:	66 90                	xchg   %ax,%ax
 60d:	66 90                	xchg   %ax,%ax
 60f:	90                   	nop

00000610 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 610:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 611:	31 c0                	xor    %eax,%eax
{
 613:	89 e5                	mov    %esp,%ebp
 615:	53                   	push   %ebx
 616:	8b 4d 08             	mov    0x8(%ebp),%ecx
 619:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 620:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 624:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 627:	83 c0 01             	add    $0x1,%eax
 62a:	84 d2                	test   %dl,%dl
 62c:	75 f2                	jne    620 <strcpy+0x10>
    ;
  return os;
}
 62e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 631:	89 c8                	mov    %ecx,%eax
 633:	c9                   	leave
 634:	c3                   	ret
 635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000640 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	53                   	push   %ebx
 644:	8b 55 08             	mov    0x8(%ebp),%edx
 647:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 64a:	0f b6 02             	movzbl (%edx),%eax
 64d:	84 c0                	test   %al,%al
 64f:	75 17                	jne    668 <strcmp+0x28>
 651:	eb 3a                	jmp    68d <strcmp+0x4d>
 653:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 657:	90                   	nop
 658:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 65c:	83 c2 01             	add    $0x1,%edx
 65f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 662:	84 c0                	test   %al,%al
 664:	74 1a                	je     680 <strcmp+0x40>
    p++, q++;
 666:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 668:	0f b6 19             	movzbl (%ecx),%ebx
 66b:	38 c3                	cmp    %al,%bl
 66d:	74 e9                	je     658 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 66f:	29 d8                	sub    %ebx,%eax
}
 671:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 674:	c9                   	leave
 675:	c3                   	ret
 676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 680:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 684:	31 c0                	xor    %eax,%eax
 686:	29 d8                	sub    %ebx,%eax
}
 688:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 68b:	c9                   	leave
 68c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 68d:	0f b6 19             	movzbl (%ecx),%ebx
 690:	31 c0                	xor    %eax,%eax
 692:	eb db                	jmp    66f <strcmp+0x2f>
 694:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 69f:	90                   	nop

000006a0 <strlen>:

uint
strlen(const char *s)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 6a6:	80 3a 00             	cmpb   $0x0,(%edx)
 6a9:	74 15                	je     6c0 <strlen+0x20>
 6ab:	31 c0                	xor    %eax,%eax
 6ad:	8d 76 00             	lea    0x0(%esi),%esi
 6b0:	83 c0 01             	add    $0x1,%eax
 6b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 6b7:	89 c1                	mov    %eax,%ecx
 6b9:	75 f5                	jne    6b0 <strlen+0x10>
    ;
  return n;
}
 6bb:	89 c8                	mov    %ecx,%eax
 6bd:	5d                   	pop    %ebp
 6be:	c3                   	ret
 6bf:	90                   	nop
  for(n = 0; s[n]; n++)
 6c0:	31 c9                	xor    %ecx,%ecx
}
 6c2:	5d                   	pop    %ebp
 6c3:	89 c8                	mov    %ecx,%eax
 6c5:	c3                   	ret
 6c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6cd:	8d 76 00             	lea    0x0(%esi),%esi

000006d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 6d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6da:	8b 45 0c             	mov    0xc(%ebp),%eax
 6dd:	89 d7                	mov    %edx,%edi
 6df:	fc                   	cld
 6e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 6e2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 6e5:	89 d0                	mov    %edx,%eax
 6e7:	c9                   	leave
 6e8:	c3                   	ret
 6e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000006f0 <strchr>:

char*
strchr(const char *s, char c)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	8b 45 08             	mov    0x8(%ebp),%eax
 6f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 6fa:	0f b6 10             	movzbl (%eax),%edx
 6fd:	84 d2                	test   %dl,%dl
 6ff:	75 12                	jne    713 <strchr+0x23>
 701:	eb 1d                	jmp    720 <strchr+0x30>
 703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 707:	90                   	nop
 708:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 70c:	83 c0 01             	add    $0x1,%eax
 70f:	84 d2                	test   %dl,%dl
 711:	74 0d                	je     720 <strchr+0x30>
    if(*s == c)
 713:	38 d1                	cmp    %dl,%cl
 715:	75 f1                	jne    708 <strchr+0x18>
      return (char*)s;
  return 0;
}
 717:	5d                   	pop    %ebp
 718:	c3                   	ret
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 720:	31 c0                	xor    %eax,%eax
}
 722:	5d                   	pop    %ebp
 723:	c3                   	ret
 724:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 72b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 72f:	90                   	nop

00000730 <gets>:

char*
gets(char *buf, int max)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 735:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 738:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 739:	31 db                	xor    %ebx,%ebx
{
 73b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 73e:	eb 27                	jmp    767 <gets+0x37>
    cc = read(0, &c, 1);
 740:	83 ec 04             	sub    $0x4,%esp
 743:	6a 01                	push   $0x1
 745:	56                   	push   %esi
 746:	6a 00                	push   $0x0
 748:	e8 1e 01 00 00       	call   86b <read>
    if(cc < 1)
 74d:	83 c4 10             	add    $0x10,%esp
 750:	85 c0                	test   %eax,%eax
 752:	7e 1d                	jle    771 <gets+0x41>
      break;
    buf[i++] = c;
 754:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 758:	8b 55 08             	mov    0x8(%ebp),%edx
 75b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 75f:	3c 0a                	cmp    $0xa,%al
 761:	74 10                	je     773 <gets+0x43>
 763:	3c 0d                	cmp    $0xd,%al
 765:	74 0c                	je     773 <gets+0x43>
  for(i=0; i+1 < max; ){
 767:	89 df                	mov    %ebx,%edi
 769:	83 c3 01             	add    $0x1,%ebx
 76c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 76f:	7c cf                	jl     740 <gets+0x10>
 771:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 773:	8b 45 08             	mov    0x8(%ebp),%eax
 776:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 77a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 77d:	5b                   	pop    %ebx
 77e:	5e                   	pop    %esi
 77f:	5f                   	pop    %edi
 780:	5d                   	pop    %ebp
 781:	c3                   	ret
 782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000790 <stat>:

int
stat(const char *n, struct stat *st)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	56                   	push   %esi
 794:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 795:	83 ec 08             	sub    $0x8,%esp
 798:	6a 00                	push   $0x0
 79a:	ff 75 08             	push   0x8(%ebp)
 79d:	e8 f1 00 00 00       	call   893 <open>
  if(fd < 0)
 7a2:	83 c4 10             	add    $0x10,%esp
 7a5:	85 c0                	test   %eax,%eax
 7a7:	78 27                	js     7d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 7a9:	83 ec 08             	sub    $0x8,%esp
 7ac:	ff 75 0c             	push   0xc(%ebp)
 7af:	89 c3                	mov    %eax,%ebx
 7b1:	50                   	push   %eax
 7b2:	e8 f4 00 00 00       	call   8ab <fstat>
  close(fd);
 7b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 7ba:	89 c6                	mov    %eax,%esi
  close(fd);
 7bc:	e8 ba 00 00 00       	call   87b <close>
  return r;
 7c1:	83 c4 10             	add    $0x10,%esp
}
 7c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 7c7:	89 f0                	mov    %esi,%eax
 7c9:	5b                   	pop    %ebx
 7ca:	5e                   	pop    %esi
 7cb:	5d                   	pop    %ebp
 7cc:	c3                   	ret
 7cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 7d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 7d5:	eb ed                	jmp    7c4 <stat+0x34>
 7d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7de:	66 90                	xchg   %ax,%ax

000007e0 <atoi>:

int
atoi(const char *s)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	53                   	push   %ebx
 7e4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7e7:	0f be 02             	movsbl (%edx),%eax
 7ea:	8d 48 d0             	lea    -0x30(%eax),%ecx
 7ed:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 7f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 7f5:	77 1e                	ja     815 <atoi+0x35>
 7f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7fe:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 800:	83 c2 01             	add    $0x1,%edx
 803:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 806:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 80a:	0f be 02             	movsbl (%edx),%eax
 80d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 810:	80 fb 09             	cmp    $0x9,%bl
 813:	76 eb                	jbe    800 <atoi+0x20>
  return n;
}
 815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 818:	89 c8                	mov    %ecx,%eax
 81a:	c9                   	leave
 81b:	c3                   	ret
 81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000820 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	57                   	push   %edi
 824:	8b 45 10             	mov    0x10(%ebp),%eax
 827:	8b 55 08             	mov    0x8(%ebp),%edx
 82a:	56                   	push   %esi
 82b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 82e:	85 c0                	test   %eax,%eax
 830:	7e 13                	jle    845 <memmove+0x25>
 832:	01 d0                	add    %edx,%eax
  dst = vdst;
 834:	89 d7                	mov    %edx,%edi
 836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 83d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 840:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 841:	39 f8                	cmp    %edi,%eax
 843:	75 fb                	jne    840 <memmove+0x20>
  return vdst;
}
 845:	5e                   	pop    %esi
 846:	89 d0                	mov    %edx,%eax
 848:	5f                   	pop    %edi
 849:	5d                   	pop    %ebp
 84a:	c3                   	ret

0000084b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 84b:	b8 01 00 00 00       	mov    $0x1,%eax
 850:	cd 40                	int    $0x40
 852:	c3                   	ret

00000853 <exit>:
SYSCALL(exit)
 853:	b8 02 00 00 00       	mov    $0x2,%eax
 858:	cd 40                	int    $0x40
 85a:	c3                   	ret

0000085b <wait>:
SYSCALL(wait)
 85b:	b8 03 00 00 00       	mov    $0x3,%eax
 860:	cd 40                	int    $0x40
 862:	c3                   	ret

00000863 <pipe>:
SYSCALL(pipe)
 863:	b8 04 00 00 00       	mov    $0x4,%eax
 868:	cd 40                	int    $0x40
 86a:	c3                   	ret

0000086b <read>:
SYSCALL(read)
 86b:	b8 05 00 00 00       	mov    $0x5,%eax
 870:	cd 40                	int    $0x40
 872:	c3                   	ret

00000873 <write>:
SYSCALL(write)
 873:	b8 10 00 00 00       	mov    $0x10,%eax
 878:	cd 40                	int    $0x40
 87a:	c3                   	ret

0000087b <close>:
SYSCALL(close)
 87b:	b8 15 00 00 00       	mov    $0x15,%eax
 880:	cd 40                	int    $0x40
 882:	c3                   	ret

00000883 <kill>:
SYSCALL(kill)
 883:	b8 06 00 00 00       	mov    $0x6,%eax
 888:	cd 40                	int    $0x40
 88a:	c3                   	ret

0000088b <exec>:
SYSCALL(exec)
 88b:	b8 07 00 00 00       	mov    $0x7,%eax
 890:	cd 40                	int    $0x40
 892:	c3                   	ret

00000893 <open>:
SYSCALL(open)
 893:	b8 0f 00 00 00       	mov    $0xf,%eax
 898:	cd 40                	int    $0x40
 89a:	c3                   	ret

0000089b <mknod>:
SYSCALL(mknod)
 89b:	b8 11 00 00 00       	mov    $0x11,%eax
 8a0:	cd 40                	int    $0x40
 8a2:	c3                   	ret

000008a3 <unlink>:
SYSCALL(unlink)
 8a3:	b8 12 00 00 00       	mov    $0x12,%eax
 8a8:	cd 40                	int    $0x40
 8aa:	c3                   	ret

000008ab <fstat>:
SYSCALL(fstat)
 8ab:	b8 08 00 00 00       	mov    $0x8,%eax
 8b0:	cd 40                	int    $0x40
 8b2:	c3                   	ret

000008b3 <link>:
SYSCALL(link)
 8b3:	b8 13 00 00 00       	mov    $0x13,%eax
 8b8:	cd 40                	int    $0x40
 8ba:	c3                   	ret

000008bb <mkdir>:
SYSCALL(mkdir)
 8bb:	b8 14 00 00 00       	mov    $0x14,%eax
 8c0:	cd 40                	int    $0x40
 8c2:	c3                   	ret

000008c3 <chdir>:
SYSCALL(chdir)
 8c3:	b8 09 00 00 00       	mov    $0x9,%eax
 8c8:	cd 40                	int    $0x40
 8ca:	c3                   	ret

000008cb <dup>:
SYSCALL(dup)
 8cb:	b8 0a 00 00 00       	mov    $0xa,%eax
 8d0:	cd 40                	int    $0x40
 8d2:	c3                   	ret

000008d3 <getpid>:
SYSCALL(getpid)
 8d3:	b8 0b 00 00 00       	mov    $0xb,%eax
 8d8:	cd 40                	int    $0x40
 8da:	c3                   	ret

000008db <sbrk>:
SYSCALL(sbrk)
 8db:	b8 0c 00 00 00       	mov    $0xc,%eax
 8e0:	cd 40                	int    $0x40
 8e2:	c3                   	ret

000008e3 <sleep>:
SYSCALL(sleep)
 8e3:	b8 0d 00 00 00       	mov    $0xd,%eax
 8e8:	cd 40                	int    $0x40
 8ea:	c3                   	ret

000008eb <uptime>:
SYSCALL(uptime)
 8eb:	b8 0e 00 00 00       	mov    $0xe,%eax
 8f0:	cd 40                	int    $0x40
 8f2:	c3                   	ret

000008f3 <symlink>:
SYSCALL(symlink)
 8f3:	b8 16 00 00 00       	mov    $0x16,%eax
 8f8:	cd 40                	int    $0x40
 8fa:	c3                   	ret
 8fb:	66 90                	xchg   %ax,%ax
 8fd:	66 90                	xchg   %ax,%ax
 8ff:	90                   	nop

00000900 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	57                   	push   %edi
 904:	56                   	push   %esi
 905:	53                   	push   %ebx
 906:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 908:	89 d1                	mov    %edx,%ecx
{
 90a:	83 ec 3c             	sub    $0x3c,%esp
 90d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 910:	85 d2                	test   %edx,%edx
 912:	0f 89 80 00 00 00    	jns    998 <printint+0x98>
 918:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 91c:	74 7a                	je     998 <printint+0x98>
    x = -xx;
 91e:	f7 d9                	neg    %ecx
    neg = 1;
 920:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 925:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 928:	31 f6                	xor    %esi,%esi
 92a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 930:	89 c8                	mov    %ecx,%eax
 932:	31 d2                	xor    %edx,%edx
 934:	89 f7                	mov    %esi,%edi
 936:	f7 f3                	div    %ebx
 938:	8d 76 01             	lea    0x1(%esi),%esi
 93b:	0f b6 92 6c 11 00 00 	movzbl 0x116c(%edx),%edx
 942:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 946:	89 ca                	mov    %ecx,%edx
 948:	89 c1                	mov    %eax,%ecx
 94a:	39 da                	cmp    %ebx,%edx
 94c:	73 e2                	jae    930 <printint+0x30>
  if(neg)
 94e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 951:	85 c0                	test   %eax,%eax
 953:	74 07                	je     95c <printint+0x5c>
    buf[i++] = '-';
 955:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
 95a:	89 f7                	mov    %esi,%edi
 95c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 95f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 962:	01 df                	add    %ebx,%edi
 964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  while(--i >= 0)
    putc(fd, buf[i]);
 968:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 96b:	83 ec 04             	sub    $0x4,%esp
 96e:	88 45 d7             	mov    %al,-0x29(%ebp)
 971:	8d 45 d7             	lea    -0x29(%ebp),%eax
 974:	6a 01                	push   $0x1
 976:	50                   	push   %eax
 977:	56                   	push   %esi
 978:	e8 f6 fe ff ff       	call   873 <write>
  while(--i >= 0)
 97d:	89 f8                	mov    %edi,%eax
 97f:	83 c4 10             	add    $0x10,%esp
 982:	83 ef 01             	sub    $0x1,%edi
 985:	39 d8                	cmp    %ebx,%eax
 987:	75 df                	jne    968 <printint+0x68>
}
 989:	8d 65 f4             	lea    -0xc(%ebp),%esp
 98c:	5b                   	pop    %ebx
 98d:	5e                   	pop    %esi
 98e:	5f                   	pop    %edi
 98f:	5d                   	pop    %ebp
 990:	c3                   	ret
 991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 998:	31 c0                	xor    %eax,%eax
 99a:	eb 89                	jmp    925 <printint+0x25>
 99c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	57                   	push   %edi
 9a4:	56                   	push   %esi
 9a5:	53                   	push   %ebx
 9a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9a9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 9ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 9af:	0f b6 1e             	movzbl (%esi),%ebx
 9b2:	83 c6 01             	add    $0x1,%esi
 9b5:	84 db                	test   %bl,%bl
 9b7:	74 67                	je     a20 <printf+0x80>
 9b9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 9bc:	31 d2                	xor    %edx,%edx
 9be:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 9c1:	eb 34                	jmp    9f7 <printf+0x57>
 9c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 9c7:	90                   	nop
 9c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 9cb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 9d0:	83 f8 25             	cmp    $0x25,%eax
 9d3:	74 18                	je     9ed <printf+0x4d>
  write(fd, &c, 1);
 9d5:	83 ec 04             	sub    $0x4,%esp
 9d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 9db:	88 5d e7             	mov    %bl,-0x19(%ebp)
 9de:	6a 01                	push   $0x1
 9e0:	50                   	push   %eax
 9e1:	57                   	push   %edi
 9e2:	e8 8c fe ff ff       	call   873 <write>
 9e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 9ea:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 9ed:	0f b6 1e             	movzbl (%esi),%ebx
 9f0:	83 c6 01             	add    $0x1,%esi
 9f3:	84 db                	test   %bl,%bl
 9f5:	74 29                	je     a20 <printf+0x80>
    c = fmt[i] & 0xff;
 9f7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 9fa:	85 d2                	test   %edx,%edx
 9fc:	74 ca                	je     9c8 <printf+0x28>
      }
    } else if(state == '%'){
 9fe:	83 fa 25             	cmp    $0x25,%edx
 a01:	75 ea                	jne    9ed <printf+0x4d>
      if(c == 'd'){
 a03:	83 f8 25             	cmp    $0x25,%eax
 a06:	0f 84 24 01 00 00    	je     b30 <printf+0x190>
 a0c:	83 e8 63             	sub    $0x63,%eax
 a0f:	83 f8 15             	cmp    $0x15,%eax
 a12:	77 1c                	ja     a30 <printf+0x90>
 a14:	ff 24 85 14 11 00 00 	jmp    *0x1114(,%eax,4)
 a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a1f:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a23:	5b                   	pop    %ebx
 a24:	5e                   	pop    %esi
 a25:	5f                   	pop    %edi
 a26:	5d                   	pop    %ebp
 a27:	c3                   	ret
 a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a2f:	90                   	nop
  write(fd, &c, 1);
 a30:	83 ec 04             	sub    $0x4,%esp
 a33:	8d 55 e7             	lea    -0x19(%ebp),%edx
 a36:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 a3a:	6a 01                	push   $0x1
 a3c:	52                   	push   %edx
 a3d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 a40:	57                   	push   %edi
 a41:	e8 2d fe ff ff       	call   873 <write>
 a46:	83 c4 0c             	add    $0xc,%esp
 a49:	88 5d e7             	mov    %bl,-0x19(%ebp)
 a4c:	6a 01                	push   $0x1
 a4e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 a51:	52                   	push   %edx
 a52:	57                   	push   %edi
 a53:	e8 1b fe ff ff       	call   873 <write>
        putc(fd, c);
 a58:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a5b:	31 d2                	xor    %edx,%edx
 a5d:	eb 8e                	jmp    9ed <printf+0x4d>
 a5f:	90                   	nop
        printint(fd, *ap, 16, 0);
 a60:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 a63:	83 ec 0c             	sub    $0xc,%esp
 a66:	b9 10 00 00 00       	mov    $0x10,%ecx
 a6b:	8b 13                	mov    (%ebx),%edx
 a6d:	6a 00                	push   $0x0
 a6f:	89 f8                	mov    %edi,%eax
        ap++;
 a71:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 a74:	e8 87 fe ff ff       	call   900 <printint>
        ap++;
 a79:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 a7c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a7f:	31 d2                	xor    %edx,%edx
 a81:	e9 67 ff ff ff       	jmp    9ed <printf+0x4d>
 a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a8d:	8d 76 00             	lea    0x0(%esi),%esi
        s = (char*)*ap;
 a90:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a93:	8b 18                	mov    (%eax),%ebx
        ap++;
 a95:	83 c0 04             	add    $0x4,%eax
 a98:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 a9b:	85 db                	test   %ebx,%ebx
 a9d:	0f 84 9d 00 00 00    	je     b40 <printf+0x1a0>
        while(*s != 0){
 aa3:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 aa6:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 aa8:	84 c0                	test   %al,%al
 aaa:	0f 84 3d ff ff ff    	je     9ed <printf+0x4d>
 ab0:	8d 55 e7             	lea    -0x19(%ebp),%edx
 ab3:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 ab6:	89 de                	mov    %ebx,%esi
 ab8:	89 d3                	mov    %edx,%ebx
 aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 ac0:	83 ec 04             	sub    $0x4,%esp
 ac3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 ac6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 ac9:	6a 01                	push   $0x1
 acb:	53                   	push   %ebx
 acc:	57                   	push   %edi
 acd:	e8 a1 fd ff ff       	call   873 <write>
        while(*s != 0){
 ad2:	0f b6 06             	movzbl (%esi),%eax
 ad5:	83 c4 10             	add    $0x10,%esp
 ad8:	84 c0                	test   %al,%al
 ada:	75 e4                	jne    ac0 <printf+0x120>
      state = 0;
 adc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 adf:	31 d2                	xor    %edx,%edx
 ae1:	e9 07 ff ff ff       	jmp    9ed <printf+0x4d>
 ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 aed:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 af0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 af3:	83 ec 0c             	sub    $0xc,%esp
 af6:	b9 0a 00 00 00       	mov    $0xa,%ecx
 afb:	8b 13                	mov    (%ebx),%edx
 afd:	6a 01                	push   $0x1
 aff:	e9 6b ff ff ff       	jmp    a6f <printf+0xcf>
 b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 b08:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 b0b:	83 ec 04             	sub    $0x4,%esp
 b0e:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 b11:	8b 03                	mov    (%ebx),%eax
        ap++;
 b13:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 b16:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 b19:	6a 01                	push   $0x1
 b1b:	52                   	push   %edx
 b1c:	57                   	push   %edi
 b1d:	e8 51 fd ff ff       	call   873 <write>
        ap++;
 b22:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 b25:	83 c4 10             	add    $0x10,%esp
      state = 0;
 b28:	31 d2                	xor    %edx,%edx
 b2a:	e9 be fe ff ff       	jmp    9ed <printf+0x4d>
 b2f:	90                   	nop
  write(fd, &c, 1);
 b30:	83 ec 04             	sub    $0x4,%esp
 b33:	88 5d e7             	mov    %bl,-0x19(%ebp)
 b36:	8d 55 e7             	lea    -0x19(%ebp),%edx
 b39:	6a 01                	push   $0x1
 b3b:	e9 11 ff ff ff       	jmp    a51 <printf+0xb1>
 b40:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 b45:	bb 0a 11 00 00       	mov    $0x110a,%ebx
 b4a:	e9 61 ff ff ff       	jmp    ab0 <printf+0x110>
 b4f:	90                   	nop

00000b50 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b50:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b51:	a1 14 14 00 00       	mov    0x1414,%eax
{
 b56:	89 e5                	mov    %esp,%ebp
 b58:	57                   	push   %edi
 b59:	56                   	push   %esi
 b5a:	53                   	push   %ebx
 b5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 b5e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b68:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b6a:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b6c:	39 ca                	cmp    %ecx,%edx
 b6e:	73 30                	jae    ba0 <free+0x50>
 b70:	39 c1                	cmp    %eax,%ecx
 b72:	72 04                	jb     b78 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b74:	39 c2                	cmp    %eax,%edx
 b76:	72 f0                	jb     b68 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b78:	8b 73 fc             	mov    -0x4(%ebx),%esi
 b7b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 b7e:	39 f8                	cmp    %edi,%eax
 b80:	74 2e                	je     bb0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 b82:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 b85:	8b 42 04             	mov    0x4(%edx),%eax
 b88:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 b8b:	39 f1                	cmp    %esi,%ecx
 b8d:	74 38                	je     bc7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 b8f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 b91:	5b                   	pop    %ebx
  freep = p;
 b92:	89 15 14 14 00 00    	mov    %edx,0x1414
}
 b98:	5e                   	pop    %esi
 b99:	5f                   	pop    %edi
 b9a:	5d                   	pop    %ebp
 b9b:	c3                   	ret
 b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ba0:	39 c1                	cmp    %eax,%ecx
 ba2:	72 d0                	jb     b74 <free+0x24>
 ba4:	eb c2                	jmp    b68 <free+0x18>
 ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 bad:	8d 76 00             	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 bb0:	03 70 04             	add    0x4(%eax),%esi
 bb3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 bb6:	8b 02                	mov    (%edx),%eax
 bb8:	8b 00                	mov    (%eax),%eax
 bba:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 bbd:	8b 42 04             	mov    0x4(%edx),%eax
 bc0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 bc3:	39 f1                	cmp    %esi,%ecx
 bc5:	75 c8                	jne    b8f <free+0x3f>
    p->s.size += bp->s.size;
 bc7:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 bca:	89 15 14 14 00 00    	mov    %edx,0x1414
    p->s.size += bp->s.size;
 bd0:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 bd3:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 bd6:	89 0a                	mov    %ecx,(%edx)
}
 bd8:	5b                   	pop    %ebx
 bd9:	5e                   	pop    %esi
 bda:	5f                   	pop    %edi
 bdb:	5d                   	pop    %ebp
 bdc:	c3                   	ret
 bdd:	8d 76 00             	lea    0x0(%esi),%esi

00000be0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 be0:	55                   	push   %ebp
 be1:	89 e5                	mov    %esp,%ebp
 be3:	57                   	push   %edi
 be4:	56                   	push   %esi
 be5:	53                   	push   %ebx
 be6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 be9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 bec:	8b 15 14 14 00 00    	mov    0x1414,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bf2:	8d 78 07             	lea    0x7(%eax),%edi
 bf5:	c1 ef 03             	shr    $0x3,%edi
 bf8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 bfb:	85 d2                	test   %edx,%edx
 bfd:	0f 84 8d 00 00 00    	je     c90 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c03:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 c05:	8b 48 04             	mov    0x4(%eax),%ecx
 c08:	39 f9                	cmp    %edi,%ecx
 c0a:	73 64                	jae    c70 <malloc+0x90>
  if(nu < 4096)
 c0c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 c11:	39 df                	cmp    %ebx,%edi
 c13:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 c16:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 c1d:	eb 0a                	jmp    c29 <malloc+0x49>
 c1f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c20:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 c22:	8b 48 04             	mov    0x4(%eax),%ecx
 c25:	39 f9                	cmp    %edi,%ecx
 c27:	73 47                	jae    c70 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c29:	89 c2                	mov    %eax,%edx
 c2b:	39 05 14 14 00 00    	cmp    %eax,0x1414
 c31:	75 ed                	jne    c20 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 c33:	83 ec 0c             	sub    $0xc,%esp
 c36:	56                   	push   %esi
 c37:	e8 9f fc ff ff       	call   8db <sbrk>
  if(p == (char*)-1)
 c3c:	83 c4 10             	add    $0x10,%esp
 c3f:	83 f8 ff             	cmp    $0xffffffff,%eax
 c42:	74 1c                	je     c60 <malloc+0x80>
  hp->s.size = nu;
 c44:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 c47:	83 ec 0c             	sub    $0xc,%esp
 c4a:	83 c0 08             	add    $0x8,%eax
 c4d:	50                   	push   %eax
 c4e:	e8 fd fe ff ff       	call   b50 <free>
  return freep;
 c53:	8b 15 14 14 00 00    	mov    0x1414,%edx
      if((p = morecore(nunits)) == 0)
 c59:	83 c4 10             	add    $0x10,%esp
 c5c:	85 d2                	test   %edx,%edx
 c5e:	75 c0                	jne    c20 <malloc+0x40>
        return 0;
  }
}
 c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 c63:	31 c0                	xor    %eax,%eax
}
 c65:	5b                   	pop    %ebx
 c66:	5e                   	pop    %esi
 c67:	5f                   	pop    %edi
 c68:	5d                   	pop    %ebp
 c69:	c3                   	ret
 c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 c70:	39 cf                	cmp    %ecx,%edi
 c72:	74 4c                	je     cc0 <malloc+0xe0>
        p->s.size -= nunits;
 c74:	29 f9                	sub    %edi,%ecx
 c76:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 c79:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 c7c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 c7f:	89 15 14 14 00 00    	mov    %edx,0x1414
}
 c85:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 c88:	83 c0 08             	add    $0x8,%eax
}
 c8b:	5b                   	pop    %ebx
 c8c:	5e                   	pop    %esi
 c8d:	5f                   	pop    %edi
 c8e:	5d                   	pop    %ebp
 c8f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 c90:	c7 05 14 14 00 00 18 	movl   $0x1418,0x1414
 c97:	14 00 00 
    base.s.size = 0;
 c9a:	b8 18 14 00 00       	mov    $0x1418,%eax
    base.s.ptr = freep = prevp = &base;
 c9f:	c7 05 18 14 00 00 18 	movl   $0x1418,0x1418
 ca6:	14 00 00 
    base.s.size = 0;
 ca9:	c7 05 1c 14 00 00 00 	movl   $0x0,0x141c
 cb0:	00 00 00 
    if(p->s.size >= nunits){
 cb3:	e9 54 ff ff ff       	jmp    c0c <malloc+0x2c>
 cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 cbf:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 cc0:	8b 08                	mov    (%eax),%ecx
 cc2:	89 0a                	mov    %ecx,(%edx)
 cc4:	eb b9                	jmp    c7f <malloc+0x9f>
