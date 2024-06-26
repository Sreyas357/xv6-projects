
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 54 11 80       	mov    $0x801154d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 32 10 80       	mov    $0x80103270,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 73 10 80       	push   $0x801073a0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 95 45 00 00       	call   801045f0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 73 10 80       	push   $0x801073a7
80100097:	50                   	push   %eax
80100098:	e8 23 44 00 00       	call   801044c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 e7 46 00 00       	call   801047d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 09 46 00 00       	call   80104770 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 43 00 00       	call   80104500 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 6f 23 00 00       	call   80102500 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ae 73 10 80       	push   $0x801073ae
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 dd 43 00 00       	call   801045a0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 27 23 00 00       	jmp    80102500 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 73 10 80       	push   $0x801073bf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 43 00 00       	call   801045a0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 4c 43 00 00       	call   80104560 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 b0 45 00 00       	call   801047d0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 02 45 00 00       	jmp    80104770 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 c6 73 10 80       	push   $0x801073c6
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 97 16 00 00       	call   80101930 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 2b 45 00 00       	call   801047d0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 8e 3f 00 00       	call   80104260 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 b9 38 00 00       	call   80103ba0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 75 44 00 00       	call   80104770 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 4c 15 00 00       	call   80101850 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 1f 44 00 00       	call   80104770 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 f6 14 00 00       	call   80101850 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 72 27 00 00       	call   80102b10 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 73 10 80       	push   $0x801073cd
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 f7 7c 10 80 	movl   $0x80107cf7,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 43 42 00 00       	call   80104610 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 73 10 80       	push   $0x801073e1
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 ac 5a 00 00       	call   80105ed0 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004df:	90                   	nop
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 e1 59 00 00       	call   80105ed0 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 d5 59 00 00       	call   80105ed0 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 c9 59 00 00       	call   80105ed0 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 da 43 00 00       	call   80104940 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 35 43 00 00       	call   801048b0 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058d:	8d 76 00             	lea    0x0(%esi),%esi
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 e5 73 10 80       	push   $0x801073e5
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 6c 13 00 00       	call   80101930 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005cb:	e8 00 42 00 00       	call   801047d0 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 df                	cmp    %ebx,%edi
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ef 10 80       	push   $0x8010ef20
80100604:	e8 67 41 00 00       	call   80104770 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 3e 12 00 00       	call   80101850 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	89 c6                	mov    %eax,%esi
80100627:	53                   	push   %ebx
80100628:	89 d3                	mov    %edx,%ebx
8010062a:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062d:	85 c9                	test   %ecx,%ecx
8010062f:	74 04                	je     80100635 <printint+0x15>
80100631:	85 c0                	test   %eax,%eax
80100633:	78 63                	js     80100698 <printint+0x78>
    x = xx;
80100635:	89 f1                	mov    %esi,%ecx
80100637:	31 c0                	xor    %eax,%eax
  i = 0;
80100639:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010063c:	31 f6                	xor    %esi,%esi
8010063e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 10 74 10 80 	movzbl -0x7fef8bf0(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100661:	85 c0                	test   %eax,%eax
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 0c                	je     801006a0 <printint+0x80>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
80100698:	89 c8                	mov    %ecx,%eax
    x = -xx;
8010069a:	89 f1                	mov    %esi,%ecx
8010069c:	f7 d9                	neg    %ecx
8010069e:	eb 99                	jmp    80100639 <printint+0x19>
}
801006a0:	83 c4 2c             	add    $0x2c,%esp
801006a3:	5b                   	pop    %ebx
801006a4:	5e                   	pop    %esi
801006a5:	5f                   	pop    %edi
801006a6:	5d                   	pop    %ebp
801006a7:	c3                   	ret
801006a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 36 01 00 00    	jne    80100800 <cprintf+0x150>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 e0 01 00 00    	je     801008b2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 6b                	je     80100744 <cprintf+0x94>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	0f 85 dc 00 00 00    	jne    801007c8 <cprintf+0x118>
    c = fmt[++i] & 0xff;
801006ec:	83 c3 01             	add    $0x1,%ebx
801006ef:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006f3:	85 c9                	test   %ecx,%ecx
801006f5:	74 42                	je     80100739 <cprintf+0x89>
    switch(c){
801006f7:	83 f9 70             	cmp    $0x70,%ecx
801006fa:	0f 84 99 00 00 00    	je     80100799 <cprintf+0xe9>
80100700:	7f 4e                	jg     80100750 <cprintf+0xa0>
80100702:	83 f9 25             	cmp    $0x25,%ecx
80100705:	0f 84 cd 00 00 00    	je     801007d8 <cprintf+0x128>
8010070b:	83 f9 64             	cmp    $0x64,%ecx
8010070e:	0f 85 24 01 00 00    	jne    80100838 <cprintf+0x188>
      printint(*argp++, 10, 1);
80100714:	8d 47 04             	lea    0x4(%edi),%eax
80100717:	b9 01 00 00 00       	mov    $0x1,%ecx
8010071c:	ba 0a 00 00 00       	mov    $0xa,%edx
80100721:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100724:	8b 07                	mov    (%edi),%eax
80100726:	e8 f5 fe ff ff       	call   80100620 <printint>
8010072b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010072e:	83 c3 01             	add    $0x1,%ebx
80100731:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100735:	85 c0                	test   %eax,%eax
80100737:	75 aa                	jne    801006e3 <cprintf+0x33>
80100739:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
8010073c:	85 ff                	test   %edi,%edi
8010073e:	0f 85 df 00 00 00    	jne    80100823 <cprintf+0x173>
}
80100744:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100747:	5b                   	pop    %ebx
80100748:	5e                   	pop    %esi
80100749:	5f                   	pop    %edi
8010074a:	5d                   	pop    %ebp
8010074b:	c3                   	ret
8010074c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100750:	83 f9 73             	cmp    $0x73,%ecx
80100753:	75 3b                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
80100755:	8b 17                	mov    (%edi),%edx
80100757:	8d 47 04             	lea    0x4(%edi),%eax
8010075a:	85 d2                	test   %edx,%edx
8010075c:	0f 85 0e 01 00 00    	jne    80100870 <cprintf+0x1c0>
80100762:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
80100767:	bf f8 73 10 80       	mov    $0x801073f8,%edi
8010076c:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010076f:	89 fb                	mov    %edi,%ebx
80100771:	89 f7                	mov    %esi,%edi
80100773:	89 c6                	mov    %eax,%esi
80100775:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100778:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010077e:	85 d2                	test   %edx,%edx
80100780:	0f 84 fe 00 00 00    	je     80100884 <cprintf+0x1d4>
80100786:	fa                   	cli
    for(;;)
80100787:	eb fe                	jmp    80100787 <cprintf+0xd7>
80100789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 f9 78             	cmp    $0x78,%ecx
80100793:	0f 85 9f 00 00 00    	jne    80100838 <cprintf+0x188>
      printint(*argp++, 16, 0);
80100799:	8d 47 04             	lea    0x4(%edi),%eax
8010079c:	31 c9                	xor    %ecx,%ecx
8010079e:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007a3:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801007a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007a9:	8b 07                	mov    (%edi),%eax
801007ab:	e8 70 fe ff ff       	call   80100620 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b0:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801007b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b7:	85 c0                	test   %eax,%eax
801007b9:	0f 85 24 ff ff ff    	jne    801006e3 <cprintf+0x33>
801007bf:	e9 75 ff ff ff       	jmp    80100739 <cprintf+0x89>
801007c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007c8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ce:	85 c9                	test   %ecx,%ecx
801007d0:	74 15                	je     801007e7 <cprintf+0x137>
801007d2:	fa                   	cli
    for(;;)
801007d3:	eb fe                	jmp    801007d3 <cprintf+0x123>
801007d5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007d8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007de:	85 c9                	test   %ecx,%ecx
801007e0:	75 7e                	jne    80100860 <cprintf+0x1b0>
801007e2:	b8 25 00 00 00       	mov    $0x25,%eax
801007e7:	e8 14 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ec:	83 c3 01             	add    $0x1,%ebx
801007ef:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007f3:	85 c0                	test   %eax,%eax
801007f5:	0f 85 e8 fe ff ff    	jne    801006e3 <cprintf+0x33>
801007fb:	e9 39 ff ff ff       	jmp    80100739 <cprintf+0x89>
    acquire(&cons.lock);
80100800:	83 ec 0c             	sub    $0xc,%esp
80100803:	68 20 ef 10 80       	push   $0x8010ef20
80100808:	e8 c3 3f 00 00       	call   801047d0 <acquire>
  if (fmt == 0)
8010080d:	83 c4 10             	add    $0x10,%esp
80100810:	85 f6                	test   %esi,%esi
80100812:	0f 84 9a 00 00 00    	je     801008b2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100818:	0f b6 06             	movzbl (%esi),%eax
8010081b:	85 c0                	test   %eax,%eax
8010081d:	0f 85 b6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
80100823:	83 ec 0c             	sub    $0xc,%esp
80100826:	68 20 ef 10 80       	push   $0x8010ef20
8010082b:	e8 40 3f 00 00       	call   80104770 <release>
80100830:	83 c4 10             	add    $0x10,%esp
80100833:	e9 0c ff ff ff       	jmp    80100744 <cprintf+0x94>
  if(panicked){
80100838:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010083e:	85 d2                	test   %edx,%edx
80100840:	75 26                	jne    80100868 <cprintf+0x1b8>
80100842:	b8 25 00 00 00       	mov    $0x25,%eax
80100847:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010084a:	e8 b1 fb ff ff       	call   80100400 <consputc.part.0>
8010084f:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100854:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100857:	85 c0                	test   %eax,%eax
80100859:	74 4b                	je     801008a6 <cprintf+0x1f6>
8010085b:	fa                   	cli
    for(;;)
8010085c:	eb fe                	jmp    8010085c <cprintf+0x1ac>
8010085e:	66 90                	xchg   %ax,%ax
80100860:	fa                   	cli
80100861:	eb fe                	jmp    80100861 <cprintf+0x1b1>
80100863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100867:	90                   	nop
80100868:	fa                   	cli
80100869:	eb fe                	jmp    80100869 <cprintf+0x1b9>
8010086b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010086f:	90                   	nop
      for(; *s; s++)
80100870:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100873:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100875:	84 c9                	test   %cl,%cl
80100877:	0f 85 ef fe ff ff    	jne    8010076c <cprintf+0xbc>
      if((s = (char*)*argp++) == 0)
8010087d:	89 c7                	mov    %eax,%edi
8010087f:	e9 aa fe ff ff       	jmp    8010072e <cprintf+0x7e>
80100884:	e8 77 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100889:	0f be 43 01          	movsbl 0x1(%ebx),%eax
8010088d:	83 c3 01             	add    $0x1,%ebx
80100890:	84 c0                	test   %al,%al
80100892:	0f 85 e0 fe ff ff    	jne    80100778 <cprintf+0xc8>
      if((s = (char*)*argp++) == 0)
80100898:	89 f0                	mov    %esi,%eax
8010089a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010089d:	89 fe                	mov    %edi,%esi
8010089f:	89 c7                	mov    %eax,%edi
801008a1:	e9 88 fe ff ff       	jmp    8010072e <cprintf+0x7e>
801008a6:	89 c8                	mov    %ecx,%eax
801008a8:	e8 53 fb ff ff       	call   80100400 <consputc.part.0>
801008ad:	e9 7c fe ff ff       	jmp    8010072e <cprintf+0x7e>
    panic("null fmt");
801008b2:	83 ec 0c             	sub    $0xc,%esp
801008b5:	68 ff 73 10 80       	push   $0x801073ff
801008ba:	e8 c1 fa ff ff       	call   80100380 <panic>
801008bf:	90                   	nop

801008c0 <consoleintr>:
{
801008c0:	55                   	push   %ebp
801008c1:	89 e5                	mov    %esp,%ebp
801008c3:	57                   	push   %edi
801008c4:	56                   	push   %esi
  int c, doprocdump = 0;
801008c5:	31 f6                	xor    %esi,%esi
{
801008c7:	53                   	push   %ebx
801008c8:	83 ec 18             	sub    $0x18,%esp
801008cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
801008ce:	68 20 ef 10 80       	push   $0x8010ef20
801008d3:	e8 f8 3e 00 00       	call   801047d0 <acquire>
  while((c = getc()) >= 0){
801008d8:	83 c4 10             	add    $0x10,%esp
801008db:	eb 1a                	jmp    801008f7 <consoleintr+0x37>
801008dd:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008e0:	83 fb 08             	cmp    $0x8,%ebx
801008e3:	0f 84 d7 00 00 00    	je     801009c0 <consoleintr+0x100>
801008e9:	83 fb 10             	cmp    $0x10,%ebx
801008ec:	0f 85 2d 01 00 00    	jne    80100a1f <consoleintr+0x15f>
801008f2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008f7:	ff d7                	call   *%edi
801008f9:	89 c3                	mov    %eax,%ebx
801008fb:	85 c0                	test   %eax,%eax
801008fd:	0f 88 e5 00 00 00    	js     801009e8 <consoleintr+0x128>
    switch(c){
80100903:	83 fb 15             	cmp    $0x15,%ebx
80100906:	74 7a                	je     80100982 <consoleintr+0xc2>
80100908:	7e d6                	jle    801008e0 <consoleintr+0x20>
8010090a:	83 fb 7f             	cmp    $0x7f,%ebx
8010090d:	0f 84 ad 00 00 00    	je     801009c0 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100913:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100918:	89 c2                	mov    %eax,%edx
8010091a:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100920:	83 fa 7f             	cmp    $0x7f,%edx
80100923:	77 d2                	ja     801008f7 <consoleintr+0x37>
  if(panicked){
80100925:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
8010092b:	8d 48 01             	lea    0x1(%eax),%ecx
8010092e:	83 e0 7f             	and    $0x7f,%eax
80100931:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
80100937:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
8010093d:	85 d2                	test   %edx,%edx
8010093f:	0f 85 47 01 00 00    	jne    80100a8c <consoleintr+0x1cc>
80100945:	89 d8                	mov    %ebx,%eax
80100947:	e8 b4 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010094c:	83 fb 0a             	cmp    $0xa,%ebx
8010094f:	0f 84 18 01 00 00    	je     80100a6d <consoleintr+0x1ad>
80100955:	83 fb 04             	cmp    $0x4,%ebx
80100958:	0f 84 0f 01 00 00    	je     80100a6d <consoleintr+0x1ad>
8010095e:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100963:	83 e8 80             	sub    $0xffffff80,%eax
80100966:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
8010096c:	75 89                	jne    801008f7 <consoleintr+0x37>
8010096e:	e9 ff 00 00 00       	jmp    80100a72 <consoleintr+0x1b2>
80100973:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100977:	90                   	nop
80100978:	b8 00 01 00 00       	mov    $0x100,%eax
8010097d:	e8 7e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100982:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100987:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098d:	0f 84 64 ff ff ff    	je     801008f7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100993:	83 e8 01             	sub    $0x1,%eax
80100996:	89 c2                	mov    %eax,%edx
80100998:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010099b:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
801009a2:	0f 84 4f ff ff ff    	je     801008f7 <consoleintr+0x37>
  if(panicked){
801009a8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
801009ae:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
801009b3:	85 d2                	test   %edx,%edx
801009b5:	74 c1                	je     80100978 <consoleintr+0xb8>
801009b7:	fa                   	cli
    for(;;)
801009b8:	eb fe                	jmp    801009b8 <consoleintr+0xf8>
801009ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
801009c0:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009c5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009cb:	0f 84 26 ff ff ff    	je     801008f7 <consoleintr+0x37>
        input.e--;
801009d1:	83 e8 01             	sub    $0x1,%eax
801009d4:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
801009d9:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801009de:	85 c0                	test   %eax,%eax
801009e0:	74 22                	je     80100a04 <consoleintr+0x144>
801009e2:	fa                   	cli
    for(;;)
801009e3:	eb fe                	jmp    801009e3 <consoleintr+0x123>
801009e5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
801009e8:	83 ec 0c             	sub    $0xc,%esp
801009eb:	68 20 ef 10 80       	push   $0x8010ef20
801009f0:	e8 7b 3d 00 00       	call   80104770 <release>
  if(doprocdump) {
801009f5:	83 c4 10             	add    $0x10,%esp
801009f8:	85 f6                	test   %esi,%esi
801009fa:	75 17                	jne    80100a13 <consoleintr+0x153>
}
801009fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009ff:	5b                   	pop    %ebx
80100a00:	5e                   	pop    %esi
80100a01:	5f                   	pop    %edi
80100a02:	5d                   	pop    %ebp
80100a03:	c3                   	ret
80100a04:	b8 00 01 00 00       	mov    $0x100,%eax
80100a09:	e8 f2 f9 ff ff       	call   80100400 <consputc.part.0>
80100a0e:	e9 e4 fe ff ff       	jmp    801008f7 <consoleintr+0x37>
80100a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a16:	5b                   	pop    %ebx
80100a17:	5e                   	pop    %esi
80100a18:	5f                   	pop    %edi
80100a19:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a1a:	e9 e1 39 00 00       	jmp    80104400 <procdump>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a1f:	85 db                	test   %ebx,%ebx
80100a21:	0f 84 d0 fe ff ff    	je     801008f7 <consoleintr+0x37>
80100a27:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a2c:	89 c2                	mov    %eax,%edx
80100a2e:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100a34:	83 fa 7f             	cmp    $0x7f,%edx
80100a37:	0f 87 ba fe ff ff    	ja     801008f7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a3d:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
80100a40:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a46:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a49:	83 fb 0d             	cmp    $0xd,%ebx
80100a4c:	0f 85 df fe ff ff    	jne    80100931 <consoleintr+0x71>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a52:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
80100a58:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a5f:	85 d2                	test   %edx,%edx
80100a61:	75 29                	jne    80100a8c <consoleintr+0x1cc>
80100a63:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a68:	e8 93 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a6d:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a72:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a75:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a7a:	68 00 ef 10 80       	push   $0x8010ef00
80100a7f:	e8 9c 38 00 00       	call   80104320 <wakeup>
80100a84:	83 c4 10             	add    $0x10,%esp
80100a87:	e9 6b fe ff ff       	jmp    801008f7 <consoleintr+0x37>
80100a8c:	fa                   	cli
    for(;;)
80100a8d:	eb fe                	jmp    80100a8d <consoleintr+0x1cd>
80100a8f:	90                   	nop

80100a90 <consoleinit>:

void
consoleinit(void)
{
80100a90:	55                   	push   %ebp
80100a91:	89 e5                	mov    %esp,%ebp
80100a93:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a96:	68 08 74 10 80       	push   $0x80107408
80100a9b:	68 20 ef 10 80       	push   $0x8010ef20
80100aa0:	e8 4b 3b 00 00       	call   801045f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100aa5:	58                   	pop    %eax
80100aa6:	5a                   	pop    %edx
80100aa7:	6a 00                	push   $0x0
80100aa9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100aab:	c7 05 0c f9 10 80 b0 	movl   $0x801005b0,0x8010f90c
80100ab2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab5:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100abc:	02 10 80 
  cons.locking = 1;
80100abf:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100ac6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100ac9:	e8 c2 1b 00 00       	call   80102690 <ioapicenable>
}
80100ace:	83 c4 10             	add    $0x10,%esp
80100ad1:	c9                   	leave
80100ad2:	c3                   	ret
80100ad3:	66 90                	xchg   %ax,%ax
80100ad5:	66 90                	xchg   %ax,%ax
80100ad7:	66 90                	xchg   %ax,%ax
80100ad9:	66 90                	xchg   %ax,%ax
80100adb:	66 90                	xchg   %ax,%ax
80100add:	66 90                	xchg   %ax,%ax
80100adf:	90                   	nop

80100ae0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ae0:	55                   	push   %ebp
80100ae1:	89 e5                	mov    %esp,%ebp
80100ae3:	57                   	push   %edi
80100ae4:	56                   	push   %esi
80100ae5:	53                   	push   %ebx
80100ae6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100aec:	e8 af 30 00 00       	call   80103ba0 <myproc>
80100af1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100af7:	e8 84 24 00 00       	call   80102f80 <begin_op>

  if((ip = namei(path)) == 0){
80100afc:	83 ec 0c             	sub    $0xc,%esp
80100aff:	ff 75 08             	push   0x8(%ebp)
80100b02:	e8 a9 17 00 00       	call   801022b0 <namei>
80100b07:	83 c4 10             	add    $0x10,%esp
80100b0a:	85 c0                	test   %eax,%eax
80100b0c:	0f 84 30 03 00 00    	je     80100e42 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b12:	83 ec 0c             	sub    $0xc,%esp
80100b15:	89 c7                	mov    %eax,%edi
80100b17:	50                   	push   %eax
80100b18:	e8 33 0d 00 00       	call   80101850 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b1d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b23:	6a 34                	push   $0x34
80100b25:	6a 00                	push   $0x0
80100b27:	50                   	push   %eax
80100b28:	57                   	push   %edi
80100b29:	e8 02 11 00 00       	call   80101c30 <readi>
80100b2e:	83 c4 20             	add    $0x20,%esp
80100b31:	83 f8 34             	cmp    $0x34,%eax
80100b34:	0f 85 01 01 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b3a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b41:	45 4c 46 
80100b44:	0f 85 f1 00 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b4a:	e8 f1 64 00 00       	call   80107040 <setupkvm>
80100b4f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b55:	85 c0                	test   %eax,%eax
80100b57:	0f 84 de 00 00 00    	je     80100c3b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b5d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b64:	00 
80100b65:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b6b:	0f 84 a1 02 00 00    	je     80100e12 <exec+0x332>
  sz = 0;
80100b71:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b78:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b7b:	31 db                	xor    %ebx,%ebx
80100b7d:	e9 8c 00 00 00       	jmp    80100c0e <exec+0x12e>
80100b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b88:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b8f:	75 6c                	jne    80100bfd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b91:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b97:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b9d:	0f 82 87 00 00 00    	jb     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ba3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ba9:	72 7f                	jb     80100c2a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bab:	83 ec 04             	sub    $0x4,%esp
80100bae:	50                   	push   %eax
80100baf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bb5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bbb:	e8 b0 62 00 00       	call   80106e70 <allocuvm>
80100bc0:	83 c4 10             	add    $0x10,%esp
80100bc3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	74 5d                	je     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bcd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bd3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bd8:	75 50                	jne    80100c2a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bda:	83 ec 0c             	sub    $0xc,%esp
80100bdd:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100be3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100be9:	57                   	push   %edi
80100bea:	50                   	push   %eax
80100beb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bf1:	e8 aa 61 00 00       	call   80106da0 <loaduvm>
80100bf6:	83 c4 20             	add    $0x20,%esp
80100bf9:	85 c0                	test   %eax,%eax
80100bfb:	78 2d                	js     80100c2a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bfd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c04:	83 c3 01             	add    $0x1,%ebx
80100c07:	83 c6 20             	add    $0x20,%esi
80100c0a:	39 d8                	cmp    %ebx,%eax
80100c0c:	7e 52                	jle    80100c60 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c0e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c14:	6a 20                	push   $0x20
80100c16:	56                   	push   %esi
80100c17:	50                   	push   %eax
80100c18:	57                   	push   %edi
80100c19:	e8 12 10 00 00       	call   80101c30 <readi>
80100c1e:	83 c4 10             	add    $0x10,%esp
80100c21:	83 f8 20             	cmp    $0x20,%eax
80100c24:	0f 84 5e ff ff ff    	je     80100b88 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c2a:	83 ec 0c             	sub    $0xc,%esp
80100c2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c33:	e8 88 63 00 00       	call   80106fc0 <freevm>
  if(ip){
80100c38:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c3b:	83 ec 0c             	sub    $0xc,%esp
80100c3e:	57                   	push   %edi
80100c3f:	e8 6c 0f 00 00       	call   80101bb0 <iunlockput>
    end_op();
80100c44:	e8 a7 23 00 00       	call   80102ff0 <end_op>
80100c49:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c54:	5b                   	pop    %ebx
80100c55:	5e                   	pop    %esi
80100c56:	5f                   	pop    %edi
80100c57:	5d                   	pop    %ebp
80100c58:	c3                   	ret
80100c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c60:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c66:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c6c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c72:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c78:	83 ec 0c             	sub    $0xc,%esp
80100c7b:	57                   	push   %edi
80100c7c:	e8 2f 0f 00 00       	call   80101bb0 <iunlockput>
  end_op();
80100c81:	e8 6a 23 00 00       	call   80102ff0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c86:	83 c4 0c             	add    $0xc,%esp
80100c89:	53                   	push   %ebx
80100c8a:	56                   	push   %esi
80100c8b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c91:	56                   	push   %esi
80100c92:	e8 d9 61 00 00       	call   80106e70 <allocuvm>
80100c97:	83 c4 10             	add    $0x10,%esp
80100c9a:	89 c7                	mov    %eax,%edi
80100c9c:	85 c0                	test   %eax,%eax
80100c9e:	0f 84 86 00 00 00    	je     80100d2a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ca4:	83 ec 08             	sub    $0x8,%esp
80100ca7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100cad:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100caf:	50                   	push   %eax
80100cb0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100cb1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cb3:	e8 28 64 00 00       	call   801070e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cbb:	83 c4 10             	add    $0x10,%esp
80100cbe:	8b 10                	mov    (%eax),%edx
80100cc0:	85 d2                	test   %edx,%edx
80100cc2:	0f 84 56 01 00 00    	je     80100e1e <exec+0x33e>
80100cc8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cce:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100cd1:	eb 23                	jmp    80100cf6 <exec+0x216>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
80100cd8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cdb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100ce2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100ceb:	85 d2                	test   %edx,%edx
80100ced:	74 51                	je     80100d40 <exec+0x260>
    if(argc >= MAXARG)
80100cef:	83 f8 20             	cmp    $0x20,%eax
80100cf2:	74 36                	je     80100d2a <exec+0x24a>
  for(argc = 0; argv[argc]; argc++) {
80100cf4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cf6:	83 ec 0c             	sub    $0xc,%esp
80100cf9:	52                   	push   %edx
80100cfa:	e8 a1 3d 00 00       	call   80104aa0 <strlen>
80100cff:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d01:	58                   	pop    %eax
80100d02:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d05:	83 eb 01             	sub    $0x1,%ebx
80100d08:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d0b:	e8 90 3d 00 00       	call   80104aa0 <strlen>
80100d10:	83 c0 01             	add    $0x1,%eax
80100d13:	50                   	push   %eax
80100d14:	ff 34 b7             	push   (%edi,%esi,4)
80100d17:	53                   	push   %ebx
80100d18:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d1e:	e8 8d 65 00 00       	call   801072b0 <copyout>
80100d23:	83 c4 20             	add    $0x20,%esp
80100d26:	85 c0                	test   %eax,%eax
80100d28:	79 ae                	jns    80100cd8 <exec+0x1f8>
    freevm(pgdir);
80100d2a:	83 ec 0c             	sub    $0xc,%esp
80100d2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d33:	e8 88 62 00 00       	call   80106fc0 <freevm>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	e9 0c ff ff ff       	jmp    80100c4c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d40:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d47:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d4d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d53:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d56:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d59:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d60:	00 00 00 00 
  ustack[1] = argc;
80100d64:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d6a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d71:	ff ff ff 
  ustack[1] = argc;
80100d74:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d7c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7e:	29 d0                	sub    %edx,%eax
80100d80:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d86:	56                   	push   %esi
80100d87:	51                   	push   %ecx
80100d88:	53                   	push   %ebx
80100d89:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d8f:	e8 1c 65 00 00       	call   801072b0 <copyout>
80100d94:	83 c4 10             	add    $0x10,%esp
80100d97:	85 c0                	test   %eax,%eax
80100d99:	78 8f                	js     80100d2a <exec+0x24a>
  for(last=s=path; *s; s++)
80100d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d9e:	8b 55 08             	mov    0x8(%ebp),%edx
80100da1:	0f b6 00             	movzbl (%eax),%eax
80100da4:	84 c0                	test   %al,%al
80100da6:	74 17                	je     80100dbf <exec+0x2df>
80100da8:	89 d1                	mov    %edx,%ecx
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100db0:	83 c1 01             	add    $0x1,%ecx
80100db3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100db5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100db8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100dbb:	84 c0                	test   %al,%al
80100dbd:	75 f1                	jne    80100db0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100dbf:	83 ec 04             	sub    $0x4,%esp
80100dc2:	6a 10                	push   $0x10
80100dc4:	52                   	push   %edx
80100dc5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100dcb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dce:	50                   	push   %eax
80100dcf:	e8 8c 3c 00 00       	call   80104a60 <safestrcpy>
  curproc->pgdir = pgdir;
80100dd4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dda:	89 f0                	mov    %esi,%eax
80100ddc:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100ddf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100de1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100de4:	89 c1                	mov    %eax,%ecx
80100de6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dec:	8b 40 18             	mov    0x18(%eax),%eax
80100def:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100df2:	8b 41 18             	mov    0x18(%ecx),%eax
80100df5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100df8:	89 0c 24             	mov    %ecx,(%esp)
80100dfb:	e8 10 5e 00 00       	call   80106c10 <switchuvm>
  freevm(oldpgdir);
80100e00:	89 34 24             	mov    %esi,(%esp)
80100e03:	e8 b8 61 00 00       	call   80106fc0 <freevm>
  return 0;
80100e08:	83 c4 10             	add    $0x10,%esp
80100e0b:	31 c0                	xor    %eax,%eax
80100e0d:	e9 3f fe ff ff       	jmp    80100c51 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e12:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e17:	31 f6                	xor    %esi,%esi
80100e19:	e9 5a fe ff ff       	jmp    80100c78 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e1e:	be 10 00 00 00       	mov    $0x10,%esi
80100e23:	ba 04 00 00 00       	mov    $0x4,%edx
80100e28:	b8 03 00 00 00       	mov    $0x3,%eax
80100e2d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e34:	00 00 00 
80100e37:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e3d:	e9 17 ff ff ff       	jmp    80100d59 <exec+0x279>
    end_op();
80100e42:	e8 a9 21 00 00       	call   80102ff0 <end_op>
    cprintf("exec: fail\n");
80100e47:	83 ec 0c             	sub    $0xc,%esp
80100e4a:	68 21 74 10 80       	push   $0x80107421
80100e4f:	e8 5c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e54:	83 c4 10             	add    $0x10,%esp
80100e57:	e9 f0 fd ff ff       	jmp    80100c4c <exec+0x16c>
80100e5c:	66 90                	xchg   %ax,%ax
80100e5e:	66 90                	xchg   %ax,%ax

80100e60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e66:	68 2d 74 10 80       	push   $0x8010742d
80100e6b:	68 60 ef 10 80       	push   $0x8010ef60
80100e70:	e8 7b 37 00 00       	call   801045f0 <initlock>
}
80100e75:	83 c4 10             	add    $0x10,%esp
80100e78:	c9                   	leave
80100e79:	c3                   	ret
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e84:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e8c:	68 60 ef 10 80       	push   $0x8010ef60
80100e91:	e8 3a 39 00 00       	call   801047d0 <acquire>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb 10                	jmp    80100eab <filealloc+0x2b>
80100e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e9f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea0:	83 c3 18             	add    $0x18,%ebx
80100ea3:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100ea9:	74 25                	je     80100ed0 <filealloc+0x50>
    if(f->ref == 0){
80100eab:	8b 43 04             	mov    0x4(%ebx),%eax
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	75 ee                	jne    80100ea0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100eb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100eb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ebc:	68 60 ef 10 80       	push   $0x8010ef60
80100ec1:	e8 aa 38 00 00       	call   80104770 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ec6:	89 d8                	mov    %ebx,%eax
      return f;
80100ec8:	83 c4 10             	add    $0x10,%esp
}
80100ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ece:	c9                   	leave
80100ecf:	c3                   	ret
  release(&ftable.lock);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ed3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ed5:	68 60 ef 10 80       	push   $0x8010ef60
80100eda:	e8 91 38 00 00       	call   80104770 <release>
}
80100edf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
}
80100ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee7:	c9                   	leave
80100ee8:	c3                   	ret
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 10             	sub    $0x10,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100efa:	68 60 ef 10 80       	push   $0x8010ef60
80100eff:	e8 cc 38 00 00       	call   801047d0 <acquire>
  if(f->ref < 1)
80100f04:	8b 43 04             	mov    0x4(%ebx),%eax
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 1a                	jle    80100f28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f17:	68 60 ef 10 80       	push   $0x8010ef60
80100f1c:	e8 4f 38 00 00       	call   80104770 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave
80100f27:	c3                   	ret
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 34 74 10 80       	push   $0x80107434
80100f30:	e8 4b f4 ff ff       	call   80100380 <panic>
80100f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 28             	sub    $0x28,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f4c:	68 60 ef 10 80       	push   $0x8010ef60
80100f51:	e8 7a 38 00 00       	call   801047d0 <acquire>
  if(f->ref < 1)
80100f56:	8b 53 04             	mov    0x4(%ebx),%edx
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	85 d2                	test   %edx,%edx
80100f5e:	0f 8e a5 00 00 00    	jle    80101009 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f64:	83 ea 01             	sub    $0x1,%edx
80100f67:	89 53 04             	mov    %edx,0x4(%ebx)
80100f6a:	75 44                	jne    80100fb0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f6c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f70:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f73:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f7b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f7e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f81:	8b 43 10             	mov    0x10(%ebx),%eax
80100f84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f87:	68 60 ef 10 80       	push   $0x8010ef60
80100f8c:	e8 df 37 00 00       	call   80104770 <release>

  if(ff.type == FD_PIPE)
80100f91:	83 c4 10             	add    $0x10,%esp
80100f94:	83 ff 01             	cmp    $0x1,%edi
80100f97:	74 57                	je     80100ff0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f99:	83 ff 02             	cmp    $0x2,%edi
80100f9c:	74 2a                	je     80100fc8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
80100fa5:	c3                   	ret
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fb0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fba:	5b                   	pop    %ebx
80100fbb:	5e                   	pop    %esi
80100fbc:	5f                   	pop    %edi
80100fbd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fbe:	e9 ad 37 00 00       	jmp    80104770 <release>
80100fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fc7:	90                   	nop
    begin_op();
80100fc8:	e8 b3 1f 00 00       	call   80102f80 <begin_op>
    iput(ff.ip);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	ff 75 e0             	push   -0x20(%ebp)
80100fd3:	e8 a8 09 00 00       	call   80101980 <iput>
    end_op();
80100fd8:	83 c4 10             	add    $0x10,%esp
}
80100fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fde:	5b                   	pop    %ebx
80100fdf:	5e                   	pop    %esi
80100fe0:	5f                   	pop    %edi
80100fe1:	5d                   	pop    %ebp
    end_op();
80100fe2:	e9 09 20 00 00       	jmp    80102ff0 <end_op>
80100fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fee:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ff0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ff4:	83 ec 08             	sub    $0x8,%esp
80100ff7:	53                   	push   %ebx
80100ff8:	56                   	push   %esi
80100ff9:	e8 42 27 00 00       	call   80103740 <pipeclose>
80100ffe:	83 c4 10             	add    $0x10,%esp
}
80101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101004:	5b                   	pop    %ebx
80101005:	5e                   	pop    %esi
80101006:	5f                   	pop    %edi
80101007:	5d                   	pop    %ebp
80101008:	c3                   	ret
    panic("fileclose");
80101009:	83 ec 0c             	sub    $0xc,%esp
8010100c:	68 3c 74 10 80       	push   $0x8010743c
80101011:	e8 6a f3 ff ff       	call   80100380 <panic>
80101016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010101d:	8d 76 00             	lea    0x0(%esi),%esi

80101020 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
80101024:	83 ec 04             	sub    $0x4,%esp
80101027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010102a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010102d:	75 31                	jne    80101060 <filestat+0x40>
    ilock(f->ip);
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	ff 73 10             	push   0x10(%ebx)
80101035:	e8 16 08 00 00       	call   80101850 <ilock>
    stati(f->ip, st);
8010103a:	58                   	pop    %eax
8010103b:	5a                   	pop    %edx
8010103c:	ff 75 0c             	push   0xc(%ebp)
8010103f:	ff 73 10             	push   0x10(%ebx)
80101042:	e8 b9 0b 00 00       	call   80101c00 <stati>
    iunlock(f->ip);
80101047:	59                   	pop    %ecx
80101048:	ff 73 10             	push   0x10(%ebx)
8010104b:	e8 e0 08 00 00       	call   80101930 <iunlock>
    return 0;
  }
  return -1;
}
80101050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101053:	83 c4 10             	add    $0x10,%esp
80101056:	31 c0                	xor    %eax,%eax
}
80101058:	c9                   	leave
80101059:	c3                   	ret
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101068:	c9                   	leave
80101069:	c3                   	ret
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101070 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010107f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101082:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101086:	74 60                	je     801010e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101088:	8b 03                	mov    (%ebx),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	74 41                	je     801010d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108f:	83 f8 02             	cmp    $0x2,%eax
80101092:	75 5b                	jne    801010ef <fileread+0x7f>
    ilock(f->ip);
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 73 10             	push   0x10(%ebx)
8010109a:	e8 b1 07 00 00       	call   80101850 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010109f:	57                   	push   %edi
801010a0:	ff 73 14             	push   0x14(%ebx)
801010a3:	56                   	push   %esi
801010a4:	ff 73 10             	push   0x10(%ebx)
801010a7:	e8 84 0b 00 00       	call   80101c30 <readi>
801010ac:	83 c4 20             	add    $0x20,%esp
801010af:	89 c6                	mov    %eax,%esi
801010b1:	85 c0                	test   %eax,%eax
801010b3:	7e 03                	jle    801010b8 <fileread+0x48>
      f->off += r;
801010b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff 73 10             	push   0x10(%ebx)
801010be:	e8 6d 08 00 00       	call   80101930 <iunlock>
    return r;
801010c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	89 f0                	mov    %esi,%eax
801010cb:	5b                   	pop    %ebx
801010cc:	5e                   	pop    %esi
801010cd:	5f                   	pop    %edi
801010ce:	5d                   	pop    %ebp
801010cf:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010dd:	e9 1e 28 00 00       	jmp    80103900 <piperead>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ed:	eb d7                	jmp    801010c6 <fileread+0x56>
  panic("fileread");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 46 74 10 80       	push   $0x80107446
801010f7:	e8 84 f2 ff ff       	call   80100380 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
80101109:	8b 45 0c             	mov    0xc(%ebp),%eax
8010110c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010110f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101112:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101115:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010111c:	0f 84 bb 00 00 00    	je     801011dd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101122:	8b 03                	mov    (%ebx),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	0f 84 bf 00 00 00    	je     801011ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112d:	83 f8 02             	cmp    $0x2,%eax
80101130:	0f 85 c8 00 00 00    	jne    801011fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101139:	31 f6                	xor    %esi,%esi
    while(i < n){
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 30                	jg     8010116f <filewrite+0x6f>
8010113f:	e9 94 00 00 00       	jmp    801011d8 <filewrite+0xd8>
80101144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101148:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010114e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101151:	ff 73 10             	push   0x10(%ebx)
80101154:	e8 d7 07 00 00       	call   80101930 <iunlock>
      end_op();
80101159:	e8 92 1e 00 00       	call   80102ff0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010115e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	39 c7                	cmp    %eax,%edi
80101166:	75 5c                	jne    801011c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101168:	01 fe                	add    %edi,%esi
    while(i < n){
8010116a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010116d:	7e 69                	jle    801011d8 <filewrite+0xd8>
      int n1 = n - i;
8010116f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101172:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101177:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101179:	39 c7                	cmp    %eax,%edi
8010117b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010117e:	e8 fd 1d 00 00       	call   80102f80 <begin_op>
      ilock(f->ip);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	ff 73 10             	push   0x10(%ebx)
80101189:	e8 c2 06 00 00       	call   80101850 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010118e:	57                   	push   %edi
8010118f:	ff 73 14             	push   0x14(%ebx)
80101192:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101195:	01 f0                	add    %esi,%eax
80101197:	50                   	push   %eax
80101198:	ff 73 10             	push   0x10(%ebx)
8010119b:	e8 c0 0b 00 00       	call   80101d60 <writei>
801011a0:	83 c4 20             	add    $0x20,%esp
801011a3:	85 c0                	test   %eax,%eax
801011a5:	7f a1                	jg     80101148 <filewrite+0x48>
801011a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011aa:	83 ec 0c             	sub    $0xc,%esp
801011ad:	ff 73 10             	push   0x10(%ebx)
801011b0:	e8 7b 07 00 00       	call   80101930 <iunlock>
      end_op();
801011b5:	e8 36 1e 00 00       	call   80102ff0 <end_op>
      if(r < 0)
801011ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011bd:	83 c4 10             	add    $0x10,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	75 14                	jne    801011d8 <filewrite+0xd8>
        panic("short filewrite");
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	68 4f 74 10 80       	push   $0x8010744f
801011cc:	e8 af f1 ff ff       	call   80100380 <panic>
801011d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011d8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011db:	74 05                	je     801011e2 <filewrite+0xe2>
    return -1;
801011dd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e5:	89 f0                	mov    %esi,%eax
801011e7:	5b                   	pop    %ebx
801011e8:	5e                   	pop    %esi
801011e9:	5f                   	pop    %edi
801011ea:	5d                   	pop    %ebp
801011eb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801011ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f5:	5b                   	pop    %ebx
801011f6:	5e                   	pop    %esi
801011f7:	5f                   	pop    %edi
801011f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011f9:	e9 e2 25 00 00       	jmp    801037e0 <pipewrite>
  panic("filewrite");
801011fe:	83 ec 0c             	sub    $0xc,%esp
80101201:	68 55 74 10 80       	push   $0x80107455
80101206:	e8 75 f1 ff ff       	call   80100380 <panic>
8010120b:	66 90                	xchg   %ax,%ax
8010120d:	66 90                	xchg   %ax,%ax
8010120f:	90                   	nop

80101210 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101219:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010121f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101222:	85 c9                	test   %ecx,%ecx
80101224:	0f 84 8c 00 00 00    	je     801012b6 <balloc+0xa6>
8010122a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010122c:	89 f8                	mov    %edi,%eax
8010122e:	83 ec 08             	sub    $0x8,%esp
80101231:	89 fe                	mov    %edi,%esi
80101233:	c1 f8 0c             	sar    $0xc,%eax
80101236:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010123c:	50                   	push   %eax
8010123d:	ff 75 dc             	push   -0x24(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101248:	83 c4 10             	add    $0x10,%esp
8010124b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101253:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101256:	31 c0                	xor    %eax,%eax
80101258:	eb 32                	jmp    8010128c <balloc+0x7c>
8010125a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101260:	89 c1                	mov    %eax,%ecx
80101262:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101267:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010126a:	83 e1 07             	and    $0x7,%ecx
8010126d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010126f:	89 c1                	mov    %eax,%ecx
80101271:	c1 f9 03             	sar    $0x3,%ecx
80101274:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101279:	89 fa                	mov    %edi,%edx
8010127b:	85 df                	test   %ebx,%edi
8010127d:	74 49                	je     801012c8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010127f:	83 c0 01             	add    $0x1,%eax
80101282:	83 c6 01             	add    $0x1,%esi
80101285:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010128a:	74 07                	je     80101293 <balloc+0x83>
8010128c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010128f:	39 d6                	cmp    %edx,%esi
80101291:	72 cd                	jb     80101260 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101293:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101296:	83 ec 0c             	sub    $0xc,%esp
80101299:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010129c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012a2:	e8 49 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012a7:	83 c4 10             	add    $0x10,%esp
801012aa:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
801012b0:	0f 82 76 ff ff ff    	jb     8010122c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	68 5f 74 10 80       	push   $0x8010745f
801012be:	e8 bd f0 ff ff       	call   80100380 <panic>
801012c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012c7:	90                   	nop
        bp->data[bi/8] |= m;  // Mark block in use.
801012c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012cb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012ce:	09 da                	or     %ebx,%edx
801012d0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012d4:	57                   	push   %edi
801012d5:	e8 86 1e 00 00       	call   80103160 <log_write>
        brelse(bp);
801012da:	89 3c 24             	mov    %edi,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012e2:	58                   	pop    %eax
801012e3:	5a                   	pop    %edx
801012e4:	56                   	push   %esi
801012e5:	ff 75 dc             	push   -0x24(%ebp)
801012e8:	e8 e3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012ed:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012f5:	68 00 02 00 00       	push   $0x200
801012fa:	6a 00                	push   $0x0
801012fc:	50                   	push   %eax
801012fd:	e8 ae 35 00 00       	call   801048b0 <memset>
  log_write(bp);
80101302:	89 1c 24             	mov    %ebx,(%esp)
80101305:	e8 56 1e 00 00       	call   80103160 <log_write>
  brelse(bp);
8010130a:	89 1c 24             	mov    %ebx,(%esp)
8010130d:	e8 de ee ff ff       	call   801001f0 <brelse>
}
80101312:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101315:	89 f0                	mov    %esi,%eax
80101317:	5b                   	pop    %ebx
80101318:	5e                   	pop    %esi
80101319:	5f                   	pop    %edi
8010131a:	5d                   	pop    %ebp
8010131b:	c3                   	ret
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101320 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101324:	31 ff                	xor    %edi,%edi
{
80101326:	56                   	push   %esi
80101327:	89 c6                	mov    %eax,%esi
80101329:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010132f:	83 ec 28             	sub    $0x28,%esp
80101332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101335:	68 60 f9 10 80       	push   $0x8010f960
8010133a:	e8 91 34 00 00       	call   801047d0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	eb 1b                	jmp    80101362 <iget+0x42>
80101347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101350:	39 33                	cmp    %esi,(%ebx)
80101352:	74 6c                	je     801013c0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101354:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010135a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101360:	74 26                	je     80101388 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101362:	8b 43 08             	mov    0x8(%ebx),%eax
80101365:	85 c0                	test   %eax,%eax
80101367:	7f e7                	jg     80101350 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101369:	85 ff                	test   %edi,%edi
8010136b:	75 e7                	jne    80101354 <iget+0x34>
8010136d:	85 c0                	test   %eax,%eax
8010136f:	75 76                	jne    801013e7 <iget+0xc7>
80101371:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101373:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101379:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010137f:	75 e1                	jne    80101362 <iget+0x42>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101388:	85 ff                	test   %edi,%edi
8010138a:	74 79                	je     80101405 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010138c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010138f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101391:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101394:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010139b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013a2:	68 60 f9 10 80       	push   $0x8010f960
801013a7:	e8 c4 33 00 00       	call   80104770 <release>

  return ip;
801013ac:	83 c4 10             	add    $0x10,%esp
}
801013af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b2:	89 f8                	mov    %edi,%eax
801013b4:	5b                   	pop    %ebx
801013b5:	5e                   	pop    %esi
801013b6:	5f                   	pop    %edi
801013b7:	5d                   	pop    %ebp
801013b8:	c3                   	ret
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013c3:	75 8f                	jne    80101354 <iget+0x34>
      ip->ref++;
801013c5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013c8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013cb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013cd:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013d0:	68 60 f9 10 80       	push   $0x8010f960
801013d5:	e8 96 33 00 00       	call   80104770 <release>
      return ip;
801013da:	83 c4 10             	add    $0x10,%esp
}
801013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e0:	89 f8                	mov    %edi,%eax
801013e2:	5b                   	pop    %ebx
801013e3:	5e                   	pop    %esi
801013e4:	5f                   	pop    %edi
801013e5:	5d                   	pop    %ebp
801013e6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ed:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013f3:	74 10                	je     80101405 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f5:	8b 43 08             	mov    0x8(%ebx),%eax
801013f8:	85 c0                	test   %eax,%eax
801013fa:	0f 8f 50 ff ff ff    	jg     80101350 <iget+0x30>
80101400:	e9 68 ff ff ff       	jmp    8010136d <iget+0x4d>
    panic("iget: no inodes");
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	68 75 74 10 80       	push   $0x80107475
8010140d:	e8 6e ef ff ff       	call   80100380 <panic>
80101412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101420 <bfree>:
{
80101420:	55                   	push   %ebp
80101421:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101423:	89 d0                	mov    %edx,%eax
80101425:	c1 e8 0c             	shr    $0xc,%eax
{
80101428:	89 e5                	mov    %esp,%ebp
8010142a:	56                   	push   %esi
8010142b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010142c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
80101432:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101434:	83 ec 08             	sub    $0x8,%esp
80101437:	50                   	push   %eax
80101438:	51                   	push   %ecx
80101439:	e8 92 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101440:	c1 fb 03             	sar    $0x3,%ebx
80101443:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101446:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101448:	83 e1 07             	and    $0x7,%ecx
8010144b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101450:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101456:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101458:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010145d:	85 c1                	test   %eax,%ecx
8010145f:	74 23                	je     80101484 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101461:	f7 d0                	not    %eax
  log_write(bp);
80101463:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101466:	21 c8                	and    %ecx,%eax
80101468:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010146c:	56                   	push   %esi
8010146d:	e8 ee 1c 00 00       	call   80103160 <log_write>
  brelse(bp);
80101472:	89 34 24             	mov    %esi,(%esp)
80101475:	e8 76 ed ff ff       	call   801001f0 <brelse>
}
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101480:	5b                   	pop    %ebx
80101481:	5e                   	pop    %esi
80101482:	5d                   	pop    %ebp
80101483:	c3                   	ret
    panic("freeing free block");
80101484:	83 ec 0c             	sub    $0xc,%esp
80101487:	68 85 74 10 80       	push   $0x80107485
8010148c:	e8 ef ee ff ff       	call   80100380 <panic>
80101491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop

801014a0 <bmap.part.0>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	89 c6                	mov    %eax,%esi
801014a7:	53                   	push   %ebx
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }


  bn -= NDIRECT;
801014a8:	8d 5a f5             	lea    -0xb(%edx),%ebx
bmap(struct inode *ip, uint bn)
801014ab:	83 ec 1c             	sub    $0x1c,%esp

  if(bn < NINDIRECT){
801014ae:	83 fb 7f             	cmp    $0x7f,%ebx
801014b1:	0f 86 89 00 00 00    	jbe    80101540 <bmap.part.0+0xa0>
    }
    brelse(bp);
    return addr;
  }

  bn -= NINDIRECT;
801014b7:	8d 9a 75 ff ff ff    	lea    -0x8b(%edx),%ebx

  
  if( bn < NINDIRECT*NINDIRECT){
801014bd:	81 fb ff 3f 00 00    	cmp    $0x3fff,%ebx
801014c3:	0f 87 11 01 00 00    	ja     801015da <bmap.part.0+0x13a>

    if((addr = ip->addrs[NDIRECT+1]) == 0)
801014c9:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014cf:	85 c0                	test   %eax,%eax
801014d1:	0f 84 d9 00 00 00    	je     801015b0 <bmap.part.0+0x110>
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    
    //reading first layer of doubly indexed block
    
    bp = bread(ip->dev,addr);
801014d7:	83 ec 08             	sub    $0x8,%esp
801014da:	50                   	push   %eax
801014db:	ff 36                	push   (%esi)
801014dd:	e8 ee eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;

    index = bn/NINDIRECT;

    if( (addr = a[index]) == 0){
801014e2:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev,addr);
801014e5:	89 c7                	mov    %eax,%edi
    index = bn/NINDIRECT;
801014e7:	89 d8                	mov    %ebx,%eax
801014e9:	c1 e8 07             	shr    $0x7,%eax
    if( (addr = a[index]) == 0){
801014ec:	8d 54 87 5c          	lea    0x5c(%edi,%eax,4),%edx
801014f0:	8b 02                	mov    (%edx),%eax
801014f2:	85 c0                	test   %eax,%eax
801014f4:	0f 84 8e 00 00 00    	je     80101588 <bmap.part.0+0xe8>
      a[index] = addr= balloc(ip->dev);
      log_write(bp);
    }

    brelse(bp);
801014fa:	83 ec 0c             	sub    $0xc,%esp
801014fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    //reading last layer 

    bp = bread(ip->dev,addr);
    a = (uint*)bp->data;

    index = bn%NINDIRECT;
80101500:	83 e3 7f             	and    $0x7f,%ebx
    brelse(bp);
80101503:	57                   	push   %edi
80101504:	e8 e7 ec ff ff       	call   801001f0 <brelse>
    bp = bread(ip->dev,addr);
80101509:	58                   	pop    %eax
8010150a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010150d:	5a                   	pop    %edx
8010150e:	50                   	push   %eax
8010150f:	ff 36                	push   (%esi)
80101511:	e8 ba eb ff ff       	call   801000d0 <bread>

    if(( addr = a[index]) == 0){
80101516:	83 c4 10             	add    $0x10,%esp
80101519:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev,addr);
8010151d:	89 c7                	mov    %eax,%edi
    if(( addr = a[index]) == 0){
8010151f:	8b 1a                	mov    (%edx),%ebx
80101521:	85 db                	test   %ebx,%ebx
80101523:	74 3f                	je     80101564 <bmap.part.0+0xc4>
      a[index] = addr = balloc(ip->dev);
      log_write(bp);
    }

    brelse(bp);
80101525:	83 ec 0c             	sub    $0xc,%esp
80101528:	57                   	push   %edi
80101529:	e8 c2 ec ff ff       	call   801001f0 <brelse>

    return addr;
8010152e:	83 c4 10             	add    $0x10,%esp


  }

  panic("bmap: out of range");
}
80101531:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101534:	89 d8                	mov    %ebx,%eax
80101536:	5b                   	pop    %ebx
80101537:	5e                   	pop    %esi
80101538:	5f                   	pop    %edi
80101539:	5d                   	pop    %ebp
8010153a:	c3                   	ret
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop
    if((addr = ip->addrs[NDIRECT]) == 0)      
80101540:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80101546:	85 c0                	test   %eax,%eax
80101548:	74 7e                	je     801015c8 <bmap.part.0+0x128>
    bp = bread(ip->dev, addr);
8010154a:	83 ec 08             	sub    $0x8,%esp
8010154d:	50                   	push   %eax
8010154e:	ff 36                	push   (%esi)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101555:	83 c4 10             	add    $0x10,%esp
80101558:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010155c:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010155e:	8b 1a                	mov    (%edx),%ebx
80101560:	85 db                	test   %ebx,%ebx
80101562:	75 c1                	jne    80101525 <bmap.part.0+0x85>
      a[index] = addr = balloc(ip->dev);
80101564:	8b 06                	mov    (%esi),%eax
80101566:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101569:	e8 a2 fc ff ff       	call   80101210 <balloc>
8010156e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101571:	83 ec 0c             	sub    $0xc,%esp
      a[index] = addr = balloc(ip->dev);
80101574:	89 c3                	mov    %eax,%ebx
80101576:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101578:	57                   	push   %edi
80101579:	e8 e2 1b 00 00       	call   80103160 <log_write>
8010157e:	83 c4 10             	add    $0x10,%esp
80101581:	eb a2                	jmp    80101525 <bmap.part.0+0x85>
80101583:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101587:	90                   	nop
      a[index] = addr= balloc(ip->dev);
80101588:	8b 06                	mov    (%esi),%eax
8010158a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010158d:	e8 7e fc ff ff       	call   80101210 <balloc>
80101592:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101595:	83 ec 0c             	sub    $0xc,%esp
      a[index] = addr= balloc(ip->dev);
80101598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010159b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010159d:	57                   	push   %edi
8010159e:	e8 bd 1b 00 00       	call   80103160 <log_write>
801015a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801015a6:	83 c4 10             	add    $0x10,%esp
801015a9:	e9 4c ff ff ff       	jmp    801014fa <bmap.part.0+0x5a>
801015ae:	66 90                	xchg   %ax,%ax
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
801015b0:	8b 06                	mov    (%esi),%eax
801015b2:	e8 59 fc ff ff       	call   80101210 <balloc>
801015b7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015bd:	e9 15 ff ff ff       	jmp    801014d7 <bmap.part.0+0x37>
801015c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015c8:	8b 06                	mov    (%esi),%eax
801015ca:	e8 41 fc ff ff       	call   80101210 <balloc>
801015cf:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
801015d5:	e9 70 ff ff ff       	jmp    8010154a <bmap.part.0+0xaa>
  panic("bmap: out of range");
801015da:	83 ec 0c             	sub    $0xc,%esp
801015dd:	68 98 74 10 80       	push   $0x80107498
801015e2:	e8 99 ed ff ff       	call   80100380 <panic>
801015e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ee:	66 90                	xchg   %ax,%ax

801015f0 <readsb>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801015f8:	83 ec 08             	sub    $0x8,%esp
801015fb:	6a 01                	push   $0x1
801015fd:	ff 75 08             	push   0x8(%ebp)
80101600:	e8 cb ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101605:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101608:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010160a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010160d:	6a 1c                	push   $0x1c
8010160f:	50                   	push   %eax
80101610:	56                   	push   %esi
80101611:	e8 2a 33 00 00       	call   80104940 <memmove>
  brelse(bp);
80101616:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101619:	83 c4 10             	add    $0x10,%esp
}
8010161c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010161f:	5b                   	pop    %ebx
80101620:	5e                   	pop    %esi
80101621:	5d                   	pop    %ebp
  brelse(bp);
80101622:	e9 c9 eb ff ff       	jmp    801001f0 <brelse>
80101627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010162e:	66 90                	xchg   %ax,%ax

80101630 <iinit>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	53                   	push   %ebx
80101634:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101639:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010163c:	68 ab 74 10 80       	push   $0x801074ab
80101641:	68 60 f9 10 80       	push   $0x8010f960
80101646:	e8 a5 2f 00 00       	call   801045f0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010164b:	83 c4 10             	add    $0x10,%esp
8010164e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101650:	83 ec 08             	sub    $0x8,%esp
80101653:	68 b2 74 10 80       	push   $0x801074b2
80101658:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101659:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010165f:	e8 5c 2e 00 00       	call   801044c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101664:	83 c4 10             	add    $0x10,%esp
80101667:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010166d:	75 e1                	jne    80101650 <iinit+0x20>
  bp = bread(dev, 1);
8010166f:	83 ec 08             	sub    $0x8,%esp
80101672:	6a 01                	push   $0x1
80101674:	ff 75 08             	push   0x8(%ebp)
80101677:	e8 54 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010167c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010167f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101681:	8d 40 5c             	lea    0x5c(%eax),%eax
80101684:	6a 1c                	push   $0x1c
80101686:	50                   	push   %eax
80101687:	68 b4 15 11 80       	push   $0x801115b4
8010168c:	e8 af 32 00 00       	call   80104940 <memmove>
  brelse(bp);
80101691:	89 1c 24             	mov    %ebx,(%esp)
80101694:	e8 57 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101699:	ff 35 cc 15 11 80    	push   0x801115cc
8010169f:	ff 35 c8 15 11 80    	push   0x801115c8
801016a5:	ff 35 c4 15 11 80    	push   0x801115c4
801016ab:	ff 35 c0 15 11 80    	push   0x801115c0
801016b1:	ff 35 bc 15 11 80    	push   0x801115bc
801016b7:	ff 35 b8 15 11 80    	push   0x801115b8
801016bd:	ff 35 b4 15 11 80    	push   0x801115b4
801016c3:	68 18 75 10 80       	push   $0x80107518
801016c8:	e8 e3 ef ff ff       	call   801006b0 <cprintf>
}
801016cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016d0:	83 c4 30             	add    $0x30,%esp
801016d3:	c9                   	leave
801016d4:	c3                   	ret
801016d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016e0 <ialloc>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	57                   	push   %edi
801016e4:	56                   	push   %esi
801016e5:	53                   	push   %ebx
801016e6:	83 ec 1c             	sub    $0x1c,%esp
801016e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801016ec:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
801016f3:	8b 75 08             	mov    0x8(%ebp),%esi
801016f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016f9:	0f 86 91 00 00 00    	jbe    80101790 <ialloc+0xb0>
801016ff:	bf 01 00 00 00       	mov    $0x1,%edi
80101704:	eb 21                	jmp    80101727 <ialloc+0x47>
80101706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010170d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101710:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101713:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101716:	53                   	push   %ebx
80101717:	e8 d4 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010171c:	83 c4 10             	add    $0x10,%esp
8010171f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101725:	73 69                	jae    80101790 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101727:	89 f8                	mov    %edi,%eax
80101729:	83 ec 08             	sub    $0x8,%esp
8010172c:	c1 e8 03             	shr    $0x3,%eax
8010172f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101735:	50                   	push   %eax
80101736:	56                   	push   %esi
80101737:	e8 94 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010173c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010173f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101741:	89 f8                	mov    %edi,%eax
80101743:	83 e0 07             	and    $0x7,%eax
80101746:	c1 e0 06             	shl    $0x6,%eax
80101749:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010174d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101751:	75 bd                	jne    80101710 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101753:	83 ec 04             	sub    $0x4,%esp
80101756:	6a 40                	push   $0x40
80101758:	6a 00                	push   $0x0
8010175a:	51                   	push   %ecx
8010175b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010175e:	e8 4d 31 00 00       	call   801048b0 <memset>
      dip->type = type;
80101763:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101767:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010176a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010176d:	89 1c 24             	mov    %ebx,(%esp)
80101770:	e8 eb 19 00 00       	call   80103160 <log_write>
      brelse(bp);
80101775:	89 1c 24             	mov    %ebx,(%esp)
80101778:	e8 73 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010177d:	83 c4 10             	add    $0x10,%esp
}
80101780:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101783:	89 fa                	mov    %edi,%edx
}
80101785:	5b                   	pop    %ebx
      return iget(dev, inum);
80101786:	89 f0                	mov    %esi,%eax
}
80101788:	5e                   	pop    %esi
80101789:	5f                   	pop    %edi
8010178a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010178b:	e9 90 fb ff ff       	jmp    80101320 <iget>
  panic("ialloc: no inodes");
80101790:	83 ec 0c             	sub    $0xc,%esp
80101793:	68 b8 74 10 80       	push   $0x801074b8
80101798:	e8 e3 eb ff ff       	call   80100380 <panic>
8010179d:	8d 76 00             	lea    0x0(%esi),%esi

801017a0 <iupdate>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017ab:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ae:	83 ec 08             	sub    $0x8,%esp
801017b1:	c1 e8 03             	shr    $0x3,%eax
801017b4:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017ba:	50                   	push   %eax
801017bb:	ff 73 a4             	push   -0x5c(%ebx)
801017be:	e8 0d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801017c3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017c7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ca:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017cc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801017cf:	83 e0 07             	and    $0x7,%eax
801017d2:	c1 e0 06             	shl    $0x6,%eax
801017d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801017d9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017dc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017e0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801017e3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801017e7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801017eb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801017ef:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017f3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017f7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017fa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017fd:	6a 34                	push   $0x34
801017ff:	53                   	push   %ebx
80101800:	50                   	push   %eax
80101801:	e8 3a 31 00 00       	call   80104940 <memmove>
  log_write(bp);
80101806:	89 34 24             	mov    %esi,(%esp)
80101809:	e8 52 19 00 00       	call   80103160 <log_write>
  brelse(bp);
8010180e:	89 75 08             	mov    %esi,0x8(%ebp)
80101811:	83 c4 10             	add    $0x10,%esp
}
80101814:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101817:	5b                   	pop    %ebx
80101818:	5e                   	pop    %esi
80101819:	5d                   	pop    %ebp
  brelse(bp);
8010181a:	e9 d1 e9 ff ff       	jmp    801001f0 <brelse>
8010181f:	90                   	nop

80101820 <idup>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	53                   	push   %ebx
80101824:	83 ec 10             	sub    $0x10,%esp
80101827:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010182a:	68 60 f9 10 80       	push   $0x8010f960
8010182f:	e8 9c 2f 00 00       	call   801047d0 <acquire>
  ip->ref++;
80101834:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101838:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010183f:	e8 2c 2f 00 00       	call   80104770 <release>
}
80101844:	89 d8                	mov    %ebx,%eax
80101846:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101849:	c9                   	leave
8010184a:	c3                   	ret
8010184b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <ilock>:
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	56                   	push   %esi
80101854:	53                   	push   %ebx
80101855:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101858:	85 db                	test   %ebx,%ebx
8010185a:	0f 84 b7 00 00 00    	je     80101917 <ilock+0xc7>
80101860:	8b 53 08             	mov    0x8(%ebx),%edx
80101863:	85 d2                	test   %edx,%edx
80101865:	0f 8e ac 00 00 00    	jle    80101917 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010186b:	83 ec 0c             	sub    $0xc,%esp
8010186e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101871:	50                   	push   %eax
80101872:	e8 89 2c 00 00       	call   80104500 <acquiresleep>
  if(ip->valid == 0){
80101877:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010187a:	83 c4 10             	add    $0x10,%esp
8010187d:	85 c0                	test   %eax,%eax
8010187f:	74 0f                	je     80101890 <ilock+0x40>
}
80101881:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101884:	5b                   	pop    %ebx
80101885:	5e                   	pop    %esi
80101886:	5d                   	pop    %ebp
80101887:	c3                   	ret
80101888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101890:	8b 43 04             	mov    0x4(%ebx),%eax
80101893:	83 ec 08             	sub    $0x8,%esp
80101896:	c1 e8 03             	shr    $0x3,%eax
80101899:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010189f:	50                   	push   %eax
801018a0:	ff 33                	push   (%ebx)
801018a2:	e8 29 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018a7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018aa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018ac:	8b 43 04             	mov    0x4(%ebx),%eax
801018af:	83 e0 07             	and    $0x7,%eax
801018b2:	c1 e0 06             	shl    $0x6,%eax
801018b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801018b9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018bc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018bf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801018c3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801018c7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801018cb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801018cf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801018d3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801018d7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801018db:	8b 50 fc             	mov    -0x4(%eax),%edx
801018de:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018e1:	6a 34                	push   $0x34
801018e3:	50                   	push   %eax
801018e4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801018e7:	50                   	push   %eax
801018e8:	e8 53 30 00 00       	call   80104940 <memmove>
    brelse(bp);
801018ed:	89 34 24             	mov    %esi,(%esp)
801018f0:	e8 fb e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801018f5:	83 c4 10             	add    $0x10,%esp
801018f8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018fd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101904:	0f 85 77 ff ff ff    	jne    80101881 <ilock+0x31>
      panic("ilock: no type");
8010190a:	83 ec 0c             	sub    $0xc,%esp
8010190d:	68 d0 74 10 80       	push   $0x801074d0
80101912:	e8 69 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101917:	83 ec 0c             	sub    $0xc,%esp
8010191a:	68 ca 74 10 80       	push   $0x801074ca
8010191f:	e8 5c ea ff ff       	call   80100380 <panic>
80101924:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010192b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010192f:	90                   	nop

80101930 <iunlock>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	56                   	push   %esi
80101934:	53                   	push   %ebx
80101935:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101938:	85 db                	test   %ebx,%ebx
8010193a:	74 28                	je     80101964 <iunlock+0x34>
8010193c:	83 ec 0c             	sub    $0xc,%esp
8010193f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101942:	56                   	push   %esi
80101943:	e8 58 2c 00 00       	call   801045a0 <holdingsleep>
80101948:	83 c4 10             	add    $0x10,%esp
8010194b:	85 c0                	test   %eax,%eax
8010194d:	74 15                	je     80101964 <iunlock+0x34>
8010194f:	8b 43 08             	mov    0x8(%ebx),%eax
80101952:	85 c0                	test   %eax,%eax
80101954:	7e 0e                	jle    80101964 <iunlock+0x34>
  releasesleep(&ip->lock);
80101956:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101959:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010195c:	5b                   	pop    %ebx
8010195d:	5e                   	pop    %esi
8010195e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010195f:	e9 fc 2b 00 00       	jmp    80104560 <releasesleep>
    panic("iunlock");
80101964:	83 ec 0c             	sub    $0xc,%esp
80101967:	68 df 74 10 80       	push   $0x801074df
8010196c:	e8 0f ea ff ff       	call   80100380 <panic>
80101971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010197f:	90                   	nop

80101980 <iput>:
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	57                   	push   %edi
80101984:	56                   	push   %esi
80101985:	53                   	push   %ebx
80101986:	83 ec 38             	sub    $0x38,%esp
80101989:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquiresleep(&ip->lock);
8010198c:	8d 5f 0c             	lea    0xc(%edi),%ebx
8010198f:	53                   	push   %ebx
80101990:	e8 6b 2b 00 00       	call   80104500 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101995:	8b 57 4c             	mov    0x4c(%edi),%edx
80101998:	83 c4 10             	add    $0x10,%esp
8010199b:	85 d2                	test   %edx,%edx
8010199d:	74 07                	je     801019a6 <iput+0x26>
8010199f:	66 83 7f 56 00       	cmpw   $0x0,0x56(%edi)
801019a4:	74 2f                	je     801019d5 <iput+0x55>
  releasesleep(&ip->lock);
801019a6:	83 ec 0c             	sub    $0xc,%esp
801019a9:	53                   	push   %ebx
801019aa:	e8 b1 2b 00 00       	call   80104560 <releasesleep>
  acquire(&icache.lock);
801019af:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801019b6:	e8 15 2e 00 00       	call   801047d0 <acquire>
  ip->ref--;
801019bb:	83 6f 08 01          	subl   $0x1,0x8(%edi)
  release(&icache.lock);
801019bf:	83 c4 10             	add    $0x10,%esp
801019c2:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
801019c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019cc:	5b                   	pop    %ebx
801019cd:	5e                   	pop    %esi
801019ce:	5f                   	pop    %edi
801019cf:	5d                   	pop    %ebp
  release(&icache.lock);
801019d0:	e9 9b 2d 00 00       	jmp    80104770 <release>
    acquire(&icache.lock);
801019d5:	83 ec 0c             	sub    $0xc,%esp
801019d8:	68 60 f9 10 80       	push   $0x8010f960
801019dd:	e8 ee 2d 00 00       	call   801047d0 <acquire>
    int r = ip->ref;
801019e2:	8b 77 08             	mov    0x8(%edi),%esi
    release(&icache.lock);
801019e5:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801019ec:	e8 7f 2d 00 00       	call   80104770 <release>
    if(r == 1){
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	83 fe 01             	cmp    $0x1,%esi
801019f7:	75 ad                	jne    801019a6 <iput+0x26>
801019f9:	8d 8f 88 00 00 00    	lea    0x88(%edi),%ecx
801019ff:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101a02:	8d 77 5c             	lea    0x5c(%edi),%esi
80101a05:	89 cb                	mov    %ecx,%ebx
80101a07:	eb 0e                	jmp    80101a17 <iput+0x97>
80101a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j, j1;
  struct buf *bp,*bp1;
  uint *a,*a1;

  for(i = 0; i < NDIRECT; i++){
80101a10:	83 c6 04             	add    $0x4,%esi
80101a13:	39 de                	cmp    %ebx,%esi
80101a15:	74 15                	je     80101a2c <iput+0xac>
    if(ip->addrs[i]){
80101a17:	8b 16                	mov    (%esi),%edx
80101a19:	85 d2                	test   %edx,%edx
80101a1b:	74 f3                	je     80101a10 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a1d:	8b 07                	mov    (%edi),%eax
80101a1f:	e8 fc f9 ff ff       	call   80101420 <bfree>
      ip->addrs[i] = 0;
80101a24:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a2a:	eb e4                	jmp    80101a10 <iput+0x90>
    }
  }

  if(ip->addrs[NDIRECT]){
80101a2c:	8b 87 88 00 00 00    	mov    0x88(%edi),%eax
80101a32:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a35:	85 c0                	test   %eax,%eax
80101a37:	75 37                	jne    80101a70 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  
  }

  if(ip->addrs[NDIRECT+1]){
80101a39:	8b 87 8c 00 00 00    	mov    0x8c(%edi),%eax
80101a3f:	85 c0                	test   %eax,%eax
80101a41:	75 6f                	jne    80101ab2 <iput+0x132>
    ip->addrs[NDIRECT+1] = 0;
  
  }

  ip->size = 0;
  iupdate(ip);
80101a43:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a46:	c7 47 58 00 00 00 00 	movl   $0x0,0x58(%edi)
  iupdate(ip);
80101a4d:	57                   	push   %edi
80101a4e:	e8 4d fd ff ff       	call   801017a0 <iupdate>
      ip->type = 0;
80101a53:	31 c0                	xor    %eax,%eax
80101a55:	66 89 47 50          	mov    %ax,0x50(%edi)
      iupdate(ip);
80101a59:	89 3c 24             	mov    %edi,(%esp)
80101a5c:	e8 3f fd ff ff       	call   801017a0 <iupdate>
      ip->valid = 0;
80101a61:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
80101a68:	83 c4 10             	add    $0x10,%esp
80101a6b:	e9 36 ff ff ff       	jmp    801019a6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a70:	83 ec 08             	sub    $0x8,%esp
80101a73:	50                   	push   %eax
80101a74:	ff 37                	push   (%edi)
80101a76:	e8 55 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a7b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101a7e:	83 c4 10             	add    $0x10,%esp
80101a81:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a87:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a8a:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a8d:	89 cb                	mov    %ecx,%ebx
80101a8f:	eb 12                	jmp    80101aa3 <iput+0x123>
80101a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a98:	83 c6 04             	add    $0x4,%esi
80101a9b:	39 de                	cmp    %ebx,%esi
80101a9d:	0f 84 a8 00 00 00    	je     80101b4b <iput+0x1cb>
      if(a[j])
80101aa3:	8b 16                	mov    (%esi),%edx
80101aa5:	85 d2                	test   %edx,%edx
80101aa7:	74 ef                	je     80101a98 <iput+0x118>
        bfree(ip->dev, a[j]);
80101aa9:	8b 07                	mov    (%edi),%eax
80101aab:	e8 70 f9 ff ff       	call   80101420 <bfree>
80101ab0:	eb e6                	jmp    80101a98 <iput+0x118>
    bp = bread(ip->dev,ip->addrs[NDIRECT+1]);
80101ab2:	83 ec 08             	sub    $0x8,%esp
80101ab5:	50                   	push   %eax
80101ab6:	ff 37                	push   (%edi)
80101ab8:	e8 13 e6 ff ff       	call   801000d0 <bread>
80101abd:	89 5d d8             	mov    %ebx,-0x28(%ebp)
80101ac0:	83 c4 10             	add    $0x10,%esp
80101ac3:	89 c6                	mov    %eax,%esi
    for( j = 0 ; j < NINDIRECT ; j++){
80101ac5:	8d 48 5c             	lea    0x5c(%eax),%ecx
80101ac8:	8d 80 5c 02 00 00    	lea    0x25c(%eax),%eax
80101ace:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101ad1:	89 75 d4             	mov    %esi,-0x2c(%ebp)
80101ad4:	eb 16                	jmp    80101aec <iput+0x16c>
80101ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101add:	8d 76 00             	lea    0x0(%esi),%esi
80101ae0:	83 c1 04             	add    $0x4,%ecx
80101ae3:	39 4d e4             	cmp    %ecx,-0x1c(%ebp)
80101ae6:	0f 84 8d 00 00 00    	je     80101b79 <iput+0x1f9>
      if(a[j]){
80101aec:	8b 01                	mov    (%ecx),%eax
80101aee:	85 c0                	test   %eax,%eax
80101af0:	74 ee                	je     80101ae0 <iput+0x160>
        bp1 = bread(ip->dev,a[j]);
80101af2:	83 ec 08             	sub    $0x8,%esp
80101af5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101af8:	50                   	push   %eax
80101af9:	ff 37                	push   (%edi)
80101afb:	e8 d0 e5 ff ff       	call   801000d0 <bread>
        for(j1 = 0 ; j1 < NINDIRECT ; j1++ ){
80101b00:	83 c4 10             	add    $0x10,%esp
80101b03:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101b06:	89 c3                	mov    %eax,%ebx
80101b08:	8d b0 00 02 00 00    	lea    0x200(%eax),%esi
80101b0e:	eb 07                	jmp    80101b17 <iput+0x197>
80101b10:	83 c3 04             	add    $0x4,%ebx
80101b13:	39 de                	cmp    %ebx,%esi
80101b15:	74 14                	je     80101b2b <iput+0x1ab>
          if(a1[j1]){
80101b17:	8b 13                	mov    (%ebx),%edx
80101b19:	85 d2                	test   %edx,%edx
80101b1b:	74 f3                	je     80101b10 <iput+0x190>
            bfree(ip->dev,a1[j1]);
80101b1d:	8b 07                	mov    (%edi),%eax
        for(j1 = 0 ; j1 < NINDIRECT ; j1++ ){
80101b1f:	83 c3 04             	add    $0x4,%ebx
            bfree(ip->dev,a1[j1]);
80101b22:	e8 f9 f8 ff ff       	call   80101420 <bfree>
        for(j1 = 0 ; j1 < NINDIRECT ; j1++ ){
80101b27:	39 de                	cmp    %ebx,%esi
80101b29:	75 ec                	jne    80101b17 <iput+0x197>
        brelse(bp1);
80101b2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101b2e:	83 ec 0c             	sub    $0xc,%esp
80101b31:	50                   	push   %eax
80101b32:	e8 b9 e6 ff ff       	call   801001f0 <brelse>
        bfree(ip->dev,a[j]);
80101b37:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b3a:	8b 07                	mov    (%edi),%eax
80101b3c:	8b 11                	mov    (%ecx),%edx
80101b3e:	e8 dd f8 ff ff       	call   80101420 <bfree>
80101b43:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b46:	83 c4 10             	add    $0x10,%esp
80101b49:	eb 95                	jmp    80101ae0 <iput+0x160>
    brelse(bp);
80101b4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b4e:	83 ec 0c             	sub    $0xc,%esp
80101b51:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b54:	50                   	push   %eax
80101b55:	e8 96 e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b5a:	8b 97 88 00 00 00    	mov    0x88(%edi),%edx
80101b60:	8b 07                	mov    (%edi),%eax
80101b62:	e8 b9 f8 ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b67:	83 c4 10             	add    $0x10,%esp
80101b6a:	c7 87 88 00 00 00 00 	movl   $0x0,0x88(%edi)
80101b71:	00 00 00 
80101b74:	e9 c0 fe ff ff       	jmp    80101a39 <iput+0xb9>
    brelse(bp);
80101b79:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80101b7c:	83 ec 0c             	sub    $0xc,%esp
80101b7f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b82:	56                   	push   %esi
80101b83:	e8 68 e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev,ip->addrs[NDIRECT+1]);
80101b88:	8b 97 8c 00 00 00    	mov    0x8c(%edi),%edx
80101b8e:	8b 07                	mov    (%edi),%eax
80101b90:	e8 8b f8 ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT+1] = 0;
80101b95:	83 c4 10             	add    $0x10,%esp
80101b98:	c7 87 8c 00 00 00 00 	movl   $0x0,0x8c(%edi)
80101b9f:	00 00 00 
80101ba2:	e9 9c fe ff ff       	jmp    80101a43 <iput+0xc3>
80101ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bae:	66 90                	xchg   %ax,%ax

80101bb0 <iunlockput>:
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	56                   	push   %esi
80101bb4:	53                   	push   %ebx
80101bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101bb8:	85 db                	test   %ebx,%ebx
80101bba:	74 34                	je     80101bf0 <iunlockput+0x40>
80101bbc:	83 ec 0c             	sub    $0xc,%esp
80101bbf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101bc2:	56                   	push   %esi
80101bc3:	e8 d8 29 00 00       	call   801045a0 <holdingsleep>
80101bc8:	83 c4 10             	add    $0x10,%esp
80101bcb:	85 c0                	test   %eax,%eax
80101bcd:	74 21                	je     80101bf0 <iunlockput+0x40>
80101bcf:	8b 43 08             	mov    0x8(%ebx),%eax
80101bd2:	85 c0                	test   %eax,%eax
80101bd4:	7e 1a                	jle    80101bf0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101bd6:	83 ec 0c             	sub    $0xc,%esp
80101bd9:	56                   	push   %esi
80101bda:	e8 81 29 00 00       	call   80104560 <releasesleep>
  iput(ip);
80101bdf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101be2:	83 c4 10             	add    $0x10,%esp
}
80101be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101be8:	5b                   	pop    %ebx
80101be9:	5e                   	pop    %esi
80101bea:	5d                   	pop    %ebp
  iput(ip);
80101beb:	e9 90 fd ff ff       	jmp    80101980 <iput>
    panic("iunlock");
80101bf0:	83 ec 0c             	sub    $0xc,%esp
80101bf3:	68 df 74 10 80       	push   $0x801074df
80101bf8:	e8 83 e7 ff ff       	call   80100380 <panic>
80101bfd:	8d 76 00             	lea    0x0(%esi),%esi

80101c00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	8b 55 08             	mov    0x8(%ebp),%edx
80101c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101c09:	8b 0a                	mov    (%edx),%ecx
80101c0b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101c0e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101c11:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101c14:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101c18:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101c1b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101c1f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101c23:	8b 52 58             	mov    0x58(%edx),%edx
80101c26:	89 50 10             	mov    %edx,0x10(%eax)
}
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret
80101c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c2f:	90                   	nop

80101c30 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	57                   	push   %edi
80101c34:	56                   	push   %esi
80101c35:	53                   	push   %ebx
80101c36:	83 ec 1c             	sub    $0x1c,%esp
80101c39:	8b 7d 08             	mov    0x8(%ebp),%edi
80101c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c3f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c42:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
80101c47:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101c4a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101c4d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101c50:	0f 84 e2 00 00 00    	je     80101d38 <readi+0x108>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c59:	8b 57 58             	mov    0x58(%edi),%edx
80101c5c:	39 f2                	cmp    %esi,%edx
80101c5e:	0f 82 f5 00 00 00    	jb     80101d59 <readi+0x129>
80101c64:	89 f1                	mov    %esi,%ecx
80101c66:	31 db                	xor    %ebx,%ebx
80101c68:	01 c1                	add    %eax,%ecx
80101c6a:	0f 92 c3             	setb   %bl
80101c6d:	89 df                	mov    %ebx,%edi
80101c6f:	0f 82 e4 00 00 00    	jb     80101d59 <readi+0x129>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c75:	89 d3                	mov    %edx,%ebx
80101c77:	29 f3                	sub    %esi,%ebx
80101c79:	39 ca                	cmp    %ecx,%edx
80101c7b:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c7e:	85 c0                	test   %eax,%eax
80101c80:	0f 84 a4 00 00 00    	je     80101d2a <readi+0xfa>
80101c86:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101c89:	eb 65                	jmp    80101cf0 <readi+0xc0>
80101c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c8f:	90                   	nop
80101c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c93:	e8 08 f8 ff ff       	call   801014a0 <bmap.part.0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c98:	83 ec 08             	sub    $0x8,%esp
80101c9b:	50                   	push   %eax
80101c9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c9f:	ff 30                	push   (%eax)
80101ca1:	e8 2a e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ca6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ca9:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cae:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101cb0:	89 f0                	mov    %esi,%eax
80101cb2:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cb7:	29 fb                	sub    %edi,%ebx
80101cb9:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101cbb:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101cbf:	39 d9                	cmp    %ebx,%ecx
80101cc1:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101cc4:	83 c4 0c             	add    $0xc,%esp
80101cc7:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cc8:	01 df                	add    %ebx,%edi
80101cca:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ccc:	89 55 d8             	mov    %edx,-0x28(%ebp)
80101ccf:	50                   	push   %eax
80101cd0:	ff 75 dc             	push   -0x24(%ebp)
80101cd3:	e8 68 2c 00 00       	call   80104940 <memmove>
    brelse(bp);
80101cd8:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101cdb:	89 14 24             	mov    %edx,(%esp)
80101cde:	e8 0d e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ce3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ce6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ce9:	83 c4 10             	add    $0x10,%esp
80101cec:	39 df                	cmp    %ebx,%edi
80101cee:	73 38                	jae    80101d28 <readi+0xf8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cf0:	89 f2                	mov    %esi,%edx
80101cf2:	c1 ea 09             	shr    $0x9,%edx
  if(bn < NDIRECT){             // last block contains doubleindirect block
80101cf5:	81 fe ff 15 00 00    	cmp    $0x15ff,%esi
80101cfb:	77 93                	ja     80101c90 <readi+0x60>
    if((addr = ip->addrs[bn]) == 0)
80101cfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d00:	8d 5a 14             	lea    0x14(%edx),%ebx
80101d03:	8b 44 98 0c          	mov    0xc(%eax,%ebx,4),%eax
80101d07:	85 c0                	test   %eax,%eax
80101d09:	75 8d                	jne    80101c98 <readi+0x68>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d0e:	8b 00                	mov    (%eax),%eax
80101d10:	e8 fb f4 ff ff       	call   80101210 <balloc>
80101d15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d18:	89 44 99 0c          	mov    %eax,0xc(%ecx,%ebx,4)
80101d1c:	e9 77 ff ff ff       	jmp    80101c98 <readi+0x68>
80101d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d28:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d2d:	5b                   	pop    %ebx
80101d2e:	5e                   	pop    %esi
80101d2f:	5f                   	pop    %edi
80101d30:	5d                   	pop    %ebp
80101d31:	c3                   	ret
80101d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d38:	0f bf 57 52          	movswl 0x52(%edi),%edx
80101d3c:	66 83 fa 09          	cmp    $0x9,%dx
80101d40:	77 17                	ja     80101d59 <readi+0x129>
80101d42:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101d49:	85 d2                	test   %edx,%edx
80101d4b:	74 0c                	je     80101d59 <readi+0x129>
    return devsw[ip->major].read(ip, dst, n);
80101d4d:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d53:	5b                   	pop    %ebx
80101d54:	5e                   	pop    %esi
80101d55:	5f                   	pop    %edi
80101d56:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101d57:	ff e2                	jmp    *%edx
      return -1;
80101d59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d5e:	eb ca                	jmp    80101d2a <readi+0xfa>

80101d60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	57                   	push   %edi
80101d64:	56                   	push   %esi
80101d65:	53                   	push   %ebx
80101d66:	83 ec 1c             	sub    $0x1c,%esp
80101d69:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d6c:	8b 55 08             	mov    0x8(%ebp),%edx
80101d6f:	8b 7d 10             	mov    0x10(%ebp),%edi
80101d72:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d75:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d78:	66 83 7a 50 03       	cmpw   $0x3,0x50(%edx)
{
80101d7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d80:	0f 84 f2 00 00 00    	je     80101e78 <writei+0x118>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d86:	39 7a 58             	cmp    %edi,0x58(%edx)
80101d89:	0f 82 22 01 00 00    	jb     80101eb1 <writei+0x151>
80101d8f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101d92:	31 c9                	xor    %ecx,%ecx
80101d94:	89 f0                	mov    %esi,%eax
80101d96:	01 f8                	add    %edi,%eax
80101d98:	0f 92 c1             	setb   %cl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d9b:	3d 00 16 81 00       	cmp    $0x811600,%eax
80101da0:	0f 87 0b 01 00 00    	ja     80101eb1 <writei+0x151>
80101da6:	85 c9                	test   %ecx,%ecx
80101da8:	0f 85 03 01 00 00    	jne    80101eb1 <writei+0x151>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101dae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101db5:	85 f6                	test   %esi,%esi
80101db7:	0f 84 ab 00 00 00    	je     80101e68 <writei+0x108>
80101dbd:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc0:	eb 6f                	jmp    80101e31 <writei+0xd1>
80101dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101dc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101dcb:	e8 d0 f6 ff ff       	call   801014a0 <bmap.part.0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101dd0:	83 ec 08             	sub    $0x8,%esp
80101dd3:	50                   	push   %eax
80101dd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101dd7:	ff 30                	push   (%eax)
80101dd9:	e8 f2 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101dde:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101de1:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101de4:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101de9:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101deb:	89 f8                	mov    %edi,%eax
80101ded:	25 ff 01 00 00       	and    $0x1ff,%eax
80101df2:	29 d3                	sub    %edx,%ebx
80101df4:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101df6:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101dfa:	39 d9                	cmp    %ebx,%ecx
80101dfc:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101dff:	83 c4 0c             	add    $0xc,%esp
80101e02:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e03:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101e05:	ff 75 d8             	push   -0x28(%ebp)
80101e08:	50                   	push   %eax
80101e09:	e8 32 2b 00 00       	call   80104940 <memmove>
    log_write(bp);
80101e0e:	89 34 24             	mov    %esi,(%esp)
80101e11:	e8 4a 13 00 00       	call   80103160 <log_write>
    brelse(bp);
80101e16:	89 34 24             	mov    %esi,(%esp)
80101e19:	e8 d2 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e1e:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101e21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e24:	83 c4 10             	add    $0x10,%esp
80101e27:	01 5d d8             	add    %ebx,-0x28(%ebp)
80101e2a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101e2d:	39 d8                	cmp    %ebx,%eax
80101e2f:	73 2f                	jae    80101e60 <writei+0x100>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e31:	89 fa                	mov    %edi,%edx
80101e33:	c1 ea 09             	shr    $0x9,%edx
  if(bn < NDIRECT){             // last block contains doubleindirect block
80101e36:	81 ff ff 15 00 00    	cmp    $0x15ff,%edi
80101e3c:	77 8a                	ja     80101dc8 <writei+0x68>
    if((addr = ip->addrs[bn]) == 0)
80101e3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e41:	8d 5a 14             	lea    0x14(%edx),%ebx
80101e44:	8b 44 98 0c          	mov    0xc(%eax,%ebx,4),%eax
80101e48:	85 c0                	test   %eax,%eax
80101e4a:	75 84                	jne    80101dd0 <writei+0x70>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101e4c:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101e4f:	8b 06                	mov    (%esi),%eax
80101e51:	e8 ba f3 ff ff       	call   80101210 <balloc>
80101e56:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101e5a:	e9 71 ff ff ff       	jmp    80101dd0 <writei+0x70>
80101e5f:	90                   	nop
  }

  if(n > 0 && off > ip->size){
80101e60:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e63:	39 7a 58             	cmp    %edi,0x58(%edx)
80101e66:	72 38                	jb     80101ea0 <writei+0x140>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101e6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e6e:	5b                   	pop    %ebx
80101e6f:	5e                   	pop    %esi
80101e70:	5f                   	pop    %edi
80101e71:	5d                   	pop    %ebp
80101e72:	c3                   	ret
80101e73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e77:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101e78:	0f bf 42 52          	movswl 0x52(%edx),%eax
80101e7c:	66 83 f8 09          	cmp    $0x9,%ax
80101e80:	77 2f                	ja     80101eb1 <writei+0x151>
80101e82:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101e89:	85 c0                	test   %eax,%eax
80101e8b:	74 24                	je     80101eb1 <writei+0x151>
    return devsw[ip->major].write(ip, src, n);
80101e8d:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e90:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e96:	5b                   	pop    %ebx
80101e97:	5e                   	pop    %esi
80101e98:	5f                   	pop    %edi
80101e99:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e9a:	ff e0                	jmp    *%eax
80101e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101ea0:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101ea3:	89 7a 58             	mov    %edi,0x58(%edx)
    iupdate(ip);
80101ea6:	52                   	push   %edx
80101ea7:	e8 f4 f8 ff ff       	call   801017a0 <iupdate>
80101eac:	83 c4 10             	add    $0x10,%esp
80101eaf:	eb b7                	jmp    80101e68 <writei+0x108>
      return -1;
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb b3                	jmp    80101e6b <writei+0x10b>
80101eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebf:	90                   	nop

80101ec0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ec6:	6a 0e                	push   $0xe
80101ec8:	ff 75 0c             	push   0xc(%ebp)
80101ecb:	ff 75 08             	push   0x8(%ebp)
80101ece:	e8 dd 2a 00 00       	call   801049b0 <strncmp>
}
80101ed3:	c9                   	leave
80101ed4:	c3                   	ret
80101ed5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ee0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	57                   	push   %edi
80101ee4:	56                   	push   %esi
80101ee5:	53                   	push   %ebx
80101ee6:	83 ec 1c             	sub    $0x1c,%esp
80101ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101eec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ef1:	0f 85 85 00 00 00    	jne    80101f7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ef7:	8b 53 58             	mov    0x58(%ebx),%edx
80101efa:	31 ff                	xor    %edi,%edi
80101efc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101eff:	85 d2                	test   %edx,%edx
80101f01:	74 3e                	je     80101f41 <dirlookup+0x61>
80101f03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f08:	6a 10                	push   $0x10
80101f0a:	57                   	push   %edi
80101f0b:	56                   	push   %esi
80101f0c:	53                   	push   %ebx
80101f0d:	e8 1e fd ff ff       	call   80101c30 <readi>
80101f12:	83 c4 10             	add    $0x10,%esp
80101f15:	83 f8 10             	cmp    $0x10,%eax
80101f18:	75 55                	jne    80101f6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101f1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f1f:	74 18                	je     80101f39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101f21:	83 ec 04             	sub    $0x4,%esp
80101f24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f27:	6a 0e                	push   $0xe
80101f29:	50                   	push   %eax
80101f2a:	ff 75 0c             	push   0xc(%ebp)
80101f2d:	e8 7e 2a 00 00       	call   801049b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101f32:	83 c4 10             	add    $0x10,%esp
80101f35:	85 c0                	test   %eax,%eax
80101f37:	74 17                	je     80101f50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f39:	83 c7 10             	add    $0x10,%edi
80101f3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f3f:	72 c7                	jb     80101f08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101f44:	31 c0                	xor    %eax,%eax
}
80101f46:	5b                   	pop    %ebx
80101f47:	5e                   	pop    %esi
80101f48:	5f                   	pop    %edi
80101f49:	5d                   	pop    %ebp
80101f4a:	c3                   	ret
80101f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f4f:	90                   	nop
      if(poff)
80101f50:	8b 45 10             	mov    0x10(%ebp),%eax
80101f53:	85 c0                	test   %eax,%eax
80101f55:	74 05                	je     80101f5c <dirlookup+0x7c>
        *poff = off;
80101f57:	8b 45 10             	mov    0x10(%ebp),%eax
80101f5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101f5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101f60:	8b 03                	mov    (%ebx),%eax
80101f62:	e8 b9 f3 ff ff       	call   80101320 <iget>
}
80101f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6a:	5b                   	pop    %ebx
80101f6b:	5e                   	pop    %esi
80101f6c:	5f                   	pop    %edi
80101f6d:	5d                   	pop    %ebp
80101f6e:	c3                   	ret
      panic("dirlookup read");
80101f6f:	83 ec 0c             	sub    $0xc,%esp
80101f72:	68 f9 74 10 80       	push   $0x801074f9
80101f77:	e8 04 e4 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101f7c:	83 ec 0c             	sub    $0xc,%esp
80101f7f:	68 e7 74 10 80       	push   $0x801074e7
80101f84:	e8 f7 e3 ff ff       	call   80100380 <panic>
80101f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	57                   	push   %edi
80101f94:	56                   	push   %esi
80101f95:	53                   	push   %ebx
80101f96:	89 c3                	mov    %eax,%ebx
80101f98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101fa1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101fa4:	0f 84 64 01 00 00    	je     8010210e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101faa:	e8 f1 1b 00 00       	call   80103ba0 <myproc>
  acquire(&icache.lock);
80101faf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101fb2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101fb5:	68 60 f9 10 80       	push   $0x8010f960
80101fba:	e8 11 28 00 00       	call   801047d0 <acquire>
  ip->ref++;
80101fbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101fc3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101fca:	e8 a1 27 00 00       	call   80104770 <release>
80101fcf:	83 c4 10             	add    $0x10,%esp
80101fd2:	eb 07                	jmp    80101fdb <namex+0x4b>
80101fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101fd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101fdb:	0f b6 03             	movzbl (%ebx),%eax
80101fde:	3c 2f                	cmp    $0x2f,%al
80101fe0:	74 f6                	je     80101fd8 <namex+0x48>
  if(*path == 0)
80101fe2:	84 c0                	test   %al,%al
80101fe4:	0f 84 06 01 00 00    	je     801020f0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101fea:	0f b6 03             	movzbl (%ebx),%eax
80101fed:	84 c0                	test   %al,%al
80101fef:	0f 84 10 01 00 00    	je     80102105 <namex+0x175>
80101ff5:	89 df                	mov    %ebx,%edi
80101ff7:	3c 2f                	cmp    $0x2f,%al
80101ff9:	0f 84 06 01 00 00    	je     80102105 <namex+0x175>
80101fff:	90                   	nop
80102000:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80102004:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80102007:	3c 2f                	cmp    $0x2f,%al
80102009:	74 04                	je     8010200f <namex+0x7f>
8010200b:	84 c0                	test   %al,%al
8010200d:	75 f1                	jne    80102000 <namex+0x70>
  len = path - s;
8010200f:	89 f8                	mov    %edi,%eax
80102011:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80102013:	83 f8 0d             	cmp    $0xd,%eax
80102016:	0f 8e ac 00 00 00    	jle    801020c8 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010201c:	83 ec 04             	sub    $0x4,%esp
8010201f:	6a 0e                	push   $0xe
80102021:	53                   	push   %ebx
    path++;
80102022:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80102024:	ff 75 e4             	push   -0x1c(%ebp)
80102027:	e8 14 29 00 00       	call   80104940 <memmove>
8010202c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010202f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102032:	75 0c                	jne    80102040 <namex+0xb0>
80102034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102038:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010203b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010203e:	74 f8                	je     80102038 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102040:	83 ec 0c             	sub    $0xc,%esp
80102043:	56                   	push   %esi
80102044:	e8 07 f8 ff ff       	call   80101850 <ilock>
    if(ip->type != T_DIR){
80102049:	83 c4 10             	add    $0x10,%esp
8010204c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102051:	0f 85 cd 00 00 00    	jne    80102124 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102057:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010205a:	85 c0                	test   %eax,%eax
8010205c:	74 09                	je     80102067 <namex+0xd7>
8010205e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102061:	0f 84 34 01 00 00    	je     8010219b <namex+0x20b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102067:	83 ec 04             	sub    $0x4,%esp
8010206a:	6a 00                	push   $0x0
8010206c:	ff 75 e4             	push   -0x1c(%ebp)
8010206f:	56                   	push   %esi
80102070:	e8 6b fe ff ff       	call   80101ee0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102075:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80102078:	83 c4 10             	add    $0x10,%esp
8010207b:	89 c7                	mov    %eax,%edi
8010207d:	85 c0                	test   %eax,%eax
8010207f:	0f 84 e1 00 00 00    	je     80102166 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	52                   	push   %edx
80102089:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010208c:	e8 0f 25 00 00       	call   801045a0 <holdingsleep>
80102091:	83 c4 10             	add    $0x10,%esp
80102094:	85 c0                	test   %eax,%eax
80102096:	0f 84 3f 01 00 00    	je     801021db <namex+0x24b>
8010209c:	8b 56 08             	mov    0x8(%esi),%edx
8010209f:	85 d2                	test   %edx,%edx
801020a1:	0f 8e 34 01 00 00    	jle    801021db <namex+0x24b>
  releasesleep(&ip->lock);
801020a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020aa:	83 ec 0c             	sub    $0xc,%esp
801020ad:	52                   	push   %edx
801020ae:	e8 ad 24 00 00       	call   80104560 <releasesleep>
  iput(ip);
801020b3:	89 34 24             	mov    %esi,(%esp)
801020b6:	89 fe                	mov    %edi,%esi
801020b8:	e8 c3 f8 ff ff       	call   80101980 <iput>
801020bd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801020c0:	e9 16 ff ff ff       	jmp    80101fdb <namex+0x4b>
801020c5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801020c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801020cb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
801020ce:	83 ec 04             	sub    $0x4,%esp
801020d1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801020d4:	50                   	push   %eax
801020d5:	53                   	push   %ebx
    name[len] = 0;
801020d6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801020d8:	ff 75 e4             	push   -0x1c(%ebp)
801020db:	e8 60 28 00 00       	call   80104940 <memmove>
    name[len] = 0;
801020e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020e3:	83 c4 10             	add    $0x10,%esp
801020e6:	c6 02 00             	movb   $0x0,(%edx)
801020e9:	e9 41 ff ff ff       	jmp    8010202f <namex+0x9f>
801020ee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801020f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801020f3:	85 c0                	test   %eax,%eax
801020f5:	0f 85 d0 00 00 00    	jne    801021cb <namex+0x23b>
    iput(ip);
    return 0;
  }
  return ip;
}
801020fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fe:	89 f0                	mov    %esi,%eax
80102100:	5b                   	pop    %ebx
80102101:	5e                   	pop    %esi
80102102:	5f                   	pop    %edi
80102103:	5d                   	pop    %ebp
80102104:	c3                   	ret
  while(*path != '/' && *path != 0)
80102105:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102108:	89 df                	mov    %ebx,%edi
8010210a:	31 c0                	xor    %eax,%eax
8010210c:	eb c0                	jmp    801020ce <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010210e:	ba 01 00 00 00       	mov    $0x1,%edx
80102113:	b8 01 00 00 00       	mov    $0x1,%eax
80102118:	e8 03 f2 ff ff       	call   80101320 <iget>
8010211d:	89 c6                	mov    %eax,%esi
8010211f:	e9 b7 fe ff ff       	jmp    80101fdb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102124:	83 ec 0c             	sub    $0xc,%esp
80102127:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010212a:	53                   	push   %ebx
8010212b:	e8 70 24 00 00       	call   801045a0 <holdingsleep>
80102130:	83 c4 10             	add    $0x10,%esp
80102133:	85 c0                	test   %eax,%eax
80102135:	0f 84 a0 00 00 00    	je     801021db <namex+0x24b>
8010213b:	8b 46 08             	mov    0x8(%esi),%eax
8010213e:	85 c0                	test   %eax,%eax
80102140:	0f 8e 95 00 00 00    	jle    801021db <namex+0x24b>
  releasesleep(&ip->lock);
80102146:	83 ec 0c             	sub    $0xc,%esp
80102149:	53                   	push   %ebx
8010214a:	e8 11 24 00 00       	call   80104560 <releasesleep>
  iput(ip);
8010214f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102152:	31 f6                	xor    %esi,%esi
  iput(ip);
80102154:	e8 27 f8 ff ff       	call   80101980 <iput>
      return 0;
80102159:	83 c4 10             	add    $0x10,%esp
}
8010215c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010215f:	89 f0                	mov    %esi,%eax
80102161:	5b                   	pop    %ebx
80102162:	5e                   	pop    %esi
80102163:	5f                   	pop    %edi
80102164:	5d                   	pop    %ebp
80102165:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102166:	83 ec 0c             	sub    $0xc,%esp
80102169:	52                   	push   %edx
8010216a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010216d:	e8 2e 24 00 00       	call   801045a0 <holdingsleep>
80102172:	83 c4 10             	add    $0x10,%esp
80102175:	85 c0                	test   %eax,%eax
80102177:	74 62                	je     801021db <namex+0x24b>
80102179:	8b 4e 08             	mov    0x8(%esi),%ecx
8010217c:	85 c9                	test   %ecx,%ecx
8010217e:	7e 5b                	jle    801021db <namex+0x24b>
  releasesleep(&ip->lock);
80102180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102183:	83 ec 0c             	sub    $0xc,%esp
80102186:	52                   	push   %edx
80102187:	e8 d4 23 00 00       	call   80104560 <releasesleep>
  iput(ip);
8010218c:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010218f:	31 f6                	xor    %esi,%esi
  iput(ip);
80102191:	e8 ea f7 ff ff       	call   80101980 <iput>
      return 0;
80102196:	83 c4 10             	add    $0x10,%esp
80102199:	eb c1                	jmp    8010215c <namex+0x1cc>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010219b:	83 ec 0c             	sub    $0xc,%esp
8010219e:	8d 5e 0c             	lea    0xc(%esi),%ebx
801021a1:	53                   	push   %ebx
801021a2:	e8 f9 23 00 00       	call   801045a0 <holdingsleep>
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	85 c0                	test   %eax,%eax
801021ac:	74 2d                	je     801021db <namex+0x24b>
801021ae:	8b 7e 08             	mov    0x8(%esi),%edi
801021b1:	85 ff                	test   %edi,%edi
801021b3:	7e 26                	jle    801021db <namex+0x24b>
  releasesleep(&ip->lock);
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	53                   	push   %ebx
801021b9:	e8 a2 23 00 00       	call   80104560 <releasesleep>
}
801021be:	83 c4 10             	add    $0x10,%esp
}
801021c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021c4:	89 f0                	mov    %esi,%eax
801021c6:	5b                   	pop    %ebx
801021c7:	5e                   	pop    %esi
801021c8:	5f                   	pop    %edi
801021c9:	5d                   	pop    %ebp
801021ca:	c3                   	ret
    iput(ip);
801021cb:	83 ec 0c             	sub    $0xc,%esp
801021ce:	56                   	push   %esi
      return 0;
801021cf:	31 f6                	xor    %esi,%esi
    iput(ip);
801021d1:	e8 aa f7 ff ff       	call   80101980 <iput>
    return 0;
801021d6:	83 c4 10             	add    $0x10,%esp
801021d9:	eb 81                	jmp    8010215c <namex+0x1cc>
    panic("iunlock");
801021db:	83 ec 0c             	sub    $0xc,%esp
801021de:	68 df 74 10 80       	push   $0x801074df
801021e3:	e8 98 e1 ff ff       	call   80100380 <panic>
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <dirlink>:
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	57                   	push   %edi
801021f4:	56                   	push   %esi
801021f5:	53                   	push   %ebx
801021f6:	83 ec 20             	sub    $0x20,%esp
801021f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801021fc:	6a 00                	push   $0x0
801021fe:	ff 75 0c             	push   0xc(%ebp)
80102201:	53                   	push   %ebx
80102202:	e8 d9 fc ff ff       	call   80101ee0 <dirlookup>
80102207:	83 c4 10             	add    $0x10,%esp
8010220a:	85 c0                	test   %eax,%eax
8010220c:	75 67                	jne    80102275 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010220e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102211:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102214:	85 ff                	test   %edi,%edi
80102216:	74 29                	je     80102241 <dirlink+0x51>
80102218:	31 ff                	xor    %edi,%edi
8010221a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010221d:	eb 09                	jmp    80102228 <dirlink+0x38>
8010221f:	90                   	nop
80102220:	83 c7 10             	add    $0x10,%edi
80102223:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102226:	73 19                	jae    80102241 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102228:	6a 10                	push   $0x10
8010222a:	57                   	push   %edi
8010222b:	56                   	push   %esi
8010222c:	53                   	push   %ebx
8010222d:	e8 fe f9 ff ff       	call   80101c30 <readi>
80102232:	83 c4 10             	add    $0x10,%esp
80102235:	83 f8 10             	cmp    $0x10,%eax
80102238:	75 4e                	jne    80102288 <dirlink+0x98>
    if(de.inum == 0)
8010223a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010223f:	75 df                	jne    80102220 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102241:	83 ec 04             	sub    $0x4,%esp
80102244:	8d 45 da             	lea    -0x26(%ebp),%eax
80102247:	6a 0e                	push   $0xe
80102249:	ff 75 0c             	push   0xc(%ebp)
8010224c:	50                   	push   %eax
8010224d:	e8 ae 27 00 00       	call   80104a00 <strncpy>
  de.inum = inum;
80102252:	8b 45 10             	mov    0x10(%ebp),%eax
80102255:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102259:	6a 10                	push   $0x10
8010225b:	57                   	push   %edi
8010225c:	56                   	push   %esi
8010225d:	53                   	push   %ebx
8010225e:	e8 fd fa ff ff       	call   80101d60 <writei>
80102263:	83 c4 20             	add    $0x20,%esp
80102266:	83 f8 10             	cmp    $0x10,%eax
80102269:	75 2a                	jne    80102295 <dirlink+0xa5>
  return 0;
8010226b:	31 c0                	xor    %eax,%eax
}
8010226d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102270:	5b                   	pop    %ebx
80102271:	5e                   	pop    %esi
80102272:	5f                   	pop    %edi
80102273:	5d                   	pop    %ebp
80102274:	c3                   	ret
    iput(ip);
80102275:	83 ec 0c             	sub    $0xc,%esp
80102278:	50                   	push   %eax
80102279:	e8 02 f7 ff ff       	call   80101980 <iput>
    return -1;
8010227e:	83 c4 10             	add    $0x10,%esp
80102281:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102286:	eb e5                	jmp    8010226d <dirlink+0x7d>
      panic("dirlink read");
80102288:	83 ec 0c             	sub    $0xc,%esp
8010228b:	68 08 75 10 80       	push   $0x80107508
80102290:	e8 eb e0 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102295:	83 ec 0c             	sub    $0xc,%esp
80102298:	68 de 7a 10 80       	push   $0x80107ade
8010229d:	e8 de e0 ff ff       	call   80100380 <panic>
801022a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022b0 <namei>:

struct inode*
namei(char *path)
{
801022b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801022b1:	31 d2                	xor    %edx,%edx
{
801022b3:	89 e5                	mov    %esp,%ebp
801022b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801022b8:	8b 45 08             	mov    0x8(%ebp),%eax
801022bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801022be:	e8 cd fc ff ff       	call   80101f90 <namex>
}
801022c3:	c9                   	leave
801022c4:	c3                   	ret
801022c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801022d0:	55                   	push   %ebp
  return namex(path, 1, name);
801022d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801022d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801022d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801022db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801022df:	e9 ac fc ff ff       	jmp    80101f90 <namex>
801022e4:	66 90                	xchg   %ax,%ax
801022e6:	66 90                	xchg   %ax,%ax
801022e8:	66 90                	xchg   %ax,%ax
801022ea:	66 90                	xchg   %ax,%ax
801022ec:	66 90                	xchg   %ax,%ax
801022ee:	66 90                	xchg   %ax,%ax

801022f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	57                   	push   %edi
801022f4:	56                   	push   %esi
801022f5:	53                   	push   %ebx
801022f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801022f9:	85 c0                	test   %eax,%eax
801022fb:	0f 84 b4 00 00 00    	je     801023b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102301:	8b 70 08             	mov    0x8(%eax),%esi
80102304:	89 c3                	mov    %eax,%ebx
80102306:	81 fe 1f 4e 00 00    	cmp    $0x4e1f,%esi
8010230c:	0f 87 96 00 00 00    	ja     801023a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102312:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231e:	66 90                	xchg   %ax,%ax
80102320:	89 ca                	mov    %ecx,%edx
80102322:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102323:	83 e0 c0             	and    $0xffffffc0,%eax
80102326:	3c 40                	cmp    $0x40,%al
80102328:	75 f6                	jne    80102320 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010232a:	31 ff                	xor    %edi,%edi
8010232c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102331:	89 f8                	mov    %edi,%eax
80102333:	ee                   	out    %al,(%dx)
80102334:	b8 01 00 00 00       	mov    $0x1,%eax
80102339:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010233e:	ee                   	out    %al,(%dx)
8010233f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102344:	89 f0                	mov    %esi,%eax
80102346:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102347:	89 f0                	mov    %esi,%eax
80102349:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010234e:	c1 f8 08             	sar    $0x8,%eax
80102351:	ee                   	out    %al,(%dx)
80102352:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102357:	89 f8                	mov    %edi,%eax
80102359:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010235a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010235e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102363:	c1 e0 04             	shl    $0x4,%eax
80102366:	83 e0 10             	and    $0x10,%eax
80102369:	83 c8 e0             	or     $0xffffffe0,%eax
8010236c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010236d:	f6 03 04             	testb  $0x4,(%ebx)
80102370:	75 16                	jne    80102388 <idestart+0x98>
80102372:	b8 20 00 00 00       	mov    $0x20,%eax
80102377:	89 ca                	mov    %ecx,%edx
80102379:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010237a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010237d:	5b                   	pop    %ebx
8010237e:	5e                   	pop    %esi
8010237f:	5f                   	pop    %edi
80102380:	5d                   	pop    %ebp
80102381:	c3                   	ret
80102382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102388:	b8 30 00 00 00       	mov    $0x30,%eax
8010238d:	89 ca                	mov    %ecx,%edx
8010238f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102390:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102395:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102398:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010239d:	fc                   	cld
8010239e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801023a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023a3:	5b                   	pop    %ebx
801023a4:	5e                   	pop    %esi
801023a5:	5f                   	pop    %edi
801023a6:	5d                   	pop    %ebp
801023a7:	c3                   	ret
    panic("incorrect blockno");
801023a8:	83 ec 0c             	sub    $0xc,%esp
801023ab:	68 74 75 10 80       	push   $0x80107574
801023b0:	e8 cb df ff ff       	call   80100380 <panic>
    panic("idestart");
801023b5:	83 ec 0c             	sub    $0xc,%esp
801023b8:	68 6b 75 10 80       	push   $0x8010756b
801023bd:	e8 be df ff ff       	call   80100380 <panic>
801023c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801023d0 <ideinit>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023d6:	68 86 75 10 80       	push   $0x80107586
801023db:	68 00 16 11 80       	push   $0x80111600
801023e0:	e8 0b 22 00 00       	call   801045f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023e5:	58                   	pop    %eax
801023e6:	a1 84 17 11 80       	mov    0x80111784,%eax
801023eb:	5a                   	pop    %edx
801023ec:	83 e8 01             	sub    $0x1,%eax
801023ef:	50                   	push   %eax
801023f0:	6a 0e                	push   $0xe
801023f2:	e8 99 02 00 00       	call   80102690 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023fa:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801023ff:	90                   	nop
80102400:	89 ca                	mov    %ecx,%edx
80102402:	ec                   	in     (%dx),%al
80102403:	83 e0 c0             	and    $0xffffffc0,%eax
80102406:	3c 40                	cmp    $0x40,%al
80102408:	75 f6                	jne    80102400 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010240a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010240f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102414:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102415:	89 ca                	mov    %ecx,%edx
80102417:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102418:	84 c0                	test   %al,%al
8010241a:	75 1e                	jne    8010243a <ideinit+0x6a>
8010241c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102421:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0; i<1000; i++){
80102430:	83 e9 01             	sub    $0x1,%ecx
80102433:	74 0f                	je     80102444 <ideinit+0x74>
80102435:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102436:	84 c0                	test   %al,%al
80102438:	74 f6                	je     80102430 <ideinit+0x60>
      havedisk1 = 1;
8010243a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102441:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102444:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102449:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010244e:	ee                   	out    %al,(%dx)
}
8010244f:	c9                   	leave
80102450:	c3                   	ret
80102451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010245f:	90                   	nop

80102460 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	57                   	push   %edi
80102464:	56                   	push   %esi
80102465:	53                   	push   %ebx
80102466:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102469:	68 00 16 11 80       	push   $0x80111600
8010246e:	e8 5d 23 00 00       	call   801047d0 <acquire>

  if((b = idequeue) == 0){
80102473:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102479:	83 c4 10             	add    $0x10,%esp
8010247c:	85 db                	test   %ebx,%ebx
8010247e:	74 63                	je     801024e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102480:	8b 43 58             	mov    0x58(%ebx),%eax
80102483:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102488:	8b 33                	mov    (%ebx),%esi
8010248a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102490:	75 2f                	jne    801024c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102492:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010249e:	66 90                	xchg   %ax,%ax
801024a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024a1:	89 c1                	mov    %eax,%ecx
801024a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801024a6:	80 f9 40             	cmp    $0x40,%cl
801024a9:	75 f5                	jne    801024a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024ab:	a8 21                	test   $0x21,%al
801024ad:	75 12                	jne    801024c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801024af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801024b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801024b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024bc:	fc                   	cld
801024bd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801024bf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801024c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801024c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801024c7:	83 ce 02             	or     $0x2,%esi
801024ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801024cc:	53                   	push   %ebx
801024cd:	e8 4e 1e 00 00       	call   80104320 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801024d2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801024d7:	83 c4 10             	add    $0x10,%esp
801024da:	85 c0                	test   %eax,%eax
801024dc:	74 05                	je     801024e3 <ideintr+0x83>
    idestart(idequeue);
801024de:	e8 0d fe ff ff       	call   801022f0 <idestart>
    release(&idelock);
801024e3:	83 ec 0c             	sub    $0xc,%esp
801024e6:	68 00 16 11 80       	push   $0x80111600
801024eb:	e8 80 22 00 00       	call   80104770 <release>

  release(&idelock);
}
801024f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024f3:	5b                   	pop    %ebx
801024f4:	5e                   	pop    %esi
801024f5:	5f                   	pop    %edi
801024f6:	5d                   	pop    %ebp
801024f7:	c3                   	ret
801024f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ff:	90                   	nop

80102500 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	53                   	push   %ebx
80102504:	83 ec 10             	sub    $0x10,%esp
80102507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010250a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010250d:	50                   	push   %eax
8010250e:	e8 8d 20 00 00       	call   801045a0 <holdingsleep>
80102513:	83 c4 10             	add    $0x10,%esp
80102516:	85 c0                	test   %eax,%eax
80102518:	0f 84 c3 00 00 00    	je     801025e1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010251e:	8b 03                	mov    (%ebx),%eax
80102520:	83 e0 06             	and    $0x6,%eax
80102523:	83 f8 02             	cmp    $0x2,%eax
80102526:	0f 84 a8 00 00 00    	je     801025d4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010252c:	8b 53 04             	mov    0x4(%ebx),%edx
8010252f:	85 d2                	test   %edx,%edx
80102531:	74 0d                	je     80102540 <iderw+0x40>
80102533:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102538:	85 c0                	test   %eax,%eax
8010253a:	0f 84 87 00 00 00    	je     801025c7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	68 00 16 11 80       	push   $0x80111600
80102548:	e8 83 22 00 00       	call   801047d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010254d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102552:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102559:	83 c4 10             	add    $0x10,%esp
8010255c:	85 c0                	test   %eax,%eax
8010255e:	74 60                	je     801025c0 <iderw+0xc0>
80102560:	89 c2                	mov    %eax,%edx
80102562:	8b 40 58             	mov    0x58(%eax),%eax
80102565:	85 c0                	test   %eax,%eax
80102567:	75 f7                	jne    80102560 <iderw+0x60>
80102569:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010256c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010256e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102574:	74 3a                	je     801025b0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102576:	8b 03                	mov    (%ebx),%eax
80102578:	83 e0 06             	and    $0x6,%eax
8010257b:	83 f8 02             	cmp    $0x2,%eax
8010257e:	74 1b                	je     8010259b <iderw+0x9b>
    sleep(b, &idelock);
80102580:	83 ec 08             	sub    $0x8,%esp
80102583:	68 00 16 11 80       	push   $0x80111600
80102588:	53                   	push   %ebx
80102589:	e8 d2 1c 00 00       	call   80104260 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010258e:	8b 03                	mov    (%ebx),%eax
80102590:	83 c4 10             	add    $0x10,%esp
80102593:	83 e0 06             	and    $0x6,%eax
80102596:	83 f8 02             	cmp    $0x2,%eax
80102599:	75 e5                	jne    80102580 <iderw+0x80>
  }


  release(&idelock);
8010259b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801025a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025a5:	c9                   	leave
  release(&idelock);
801025a6:	e9 c5 21 00 00       	jmp    80104770 <release>
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop
    idestart(b);
801025b0:	89 d8                	mov    %ebx,%eax
801025b2:	e8 39 fd ff ff       	call   801022f0 <idestart>
801025b7:	eb bd                	jmp    80102576 <iderw+0x76>
801025b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025c0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801025c5:	eb a5                	jmp    8010256c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801025c7:	83 ec 0c             	sub    $0xc,%esp
801025ca:	68 b5 75 10 80       	push   $0x801075b5
801025cf:	e8 ac dd ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801025d4:	83 ec 0c             	sub    $0xc,%esp
801025d7:	68 a0 75 10 80       	push   $0x801075a0
801025dc:	e8 9f dd ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801025e1:	83 ec 0c             	sub    $0xc,%esp
801025e4:	68 8a 75 10 80       	push   $0x8010758a
801025e9:	e8 92 dd ff ff       	call   80100380 <panic>
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	56                   	push   %esi
801025f4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025f5:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801025fc:	00 c0 fe 
  ioapic->reg = reg;
801025ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102606:	00 00 00 
  return ioapic->data;
80102609:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010260f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102612:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102618:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010261e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102625:	c1 ee 10             	shr    $0x10,%esi
80102628:	89 f0                	mov    %esi,%eax
8010262a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010262d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102630:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102633:	39 c2                	cmp    %eax,%edx
80102635:	74 16                	je     8010264d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102637:	83 ec 0c             	sub    $0xc,%esp
8010263a:	68 d4 75 10 80       	push   $0x801075d4
8010263f:	e8 6c e0 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102644:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010264a:	83 c4 10             	add    $0x10,%esp
{
8010264d:	ba 10 00 00 00       	mov    $0x10,%edx
80102652:	31 c0                	xor    %eax,%eax
80102654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102658:	89 13                	mov    %edx,(%ebx)
8010265a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010265d:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102663:	83 c0 01             	add    $0x1,%eax
80102666:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010266c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010266f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102672:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102675:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102677:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010267d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102684:	39 c6                	cmp    %eax,%esi
80102686:	7d d0                	jge    80102658 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102688:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010268b:	5b                   	pop    %ebx
8010268c:	5e                   	pop    %esi
8010268d:	5d                   	pop    %ebp
8010268e:	c3                   	ret
8010268f:	90                   	nop

80102690 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102690:	55                   	push   %ebp
  ioapic->reg = reg;
80102691:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102697:	89 e5                	mov    %esp,%ebp
80102699:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010269c:	8d 50 20             	lea    0x20(%eax),%edx
8010269f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801026a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026a5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801026b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026b6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801026be:	89 50 10             	mov    %edx,0x10(%eax)
}
801026c1:	5d                   	pop    %ebp
801026c2:	c3                   	ret
801026c3:	66 90                	xchg   %ax,%ax
801026c5:	66 90                	xchg   %ax,%ax
801026c7:	66 90                	xchg   %ax,%ax
801026c9:	66 90                	xchg   %ax,%ax
801026cb:	66 90                	xchg   %ax,%ax
801026cd:	66 90                	xchg   %ax,%ax
801026cf:	90                   	nop

801026d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	53                   	push   %ebx
801026d4:	83 ec 04             	sub    $0x4,%esp
801026d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026e0:	75 76                	jne    80102758 <kfree+0x88>
801026e2:	81 fb d0 54 11 80    	cmp    $0x801154d0,%ebx
801026e8:	72 6e                	jb     80102758 <kfree+0x88>
801026ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026f5:	77 61                	ja     80102758 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026f7:	83 ec 04             	sub    $0x4,%esp
801026fa:	68 00 10 00 00       	push   $0x1000
801026ff:	6a 01                	push   $0x1
80102701:	53                   	push   %ebx
80102702:	e8 a9 21 00 00       	call   801048b0 <memset>

  if(kmem.use_lock)
80102707:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010270d:	83 c4 10             	add    $0x10,%esp
80102710:	85 d2                	test   %edx,%edx
80102712:	75 1c                	jne    80102730 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102714:	a1 78 16 11 80       	mov    0x80111678,%eax
80102719:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010271b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102720:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102726:	85 c0                	test   %eax,%eax
80102728:	75 1e                	jne    80102748 <kfree+0x78>
    release(&kmem.lock);
}
8010272a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010272d:	c9                   	leave
8010272e:	c3                   	ret
8010272f:	90                   	nop
    acquire(&kmem.lock);
80102730:	83 ec 0c             	sub    $0xc,%esp
80102733:	68 40 16 11 80       	push   $0x80111640
80102738:	e8 93 20 00 00       	call   801047d0 <acquire>
8010273d:	83 c4 10             	add    $0x10,%esp
80102740:	eb d2                	jmp    80102714 <kfree+0x44>
80102742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102748:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010274f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102752:	c9                   	leave
    release(&kmem.lock);
80102753:	e9 18 20 00 00       	jmp    80104770 <release>
    panic("kfree");
80102758:	83 ec 0c             	sub    $0xc,%esp
8010275b:	68 06 76 10 80       	push   $0x80107606
80102760:	e8 1b dc ff ff       	call   80100380 <panic>
80102765:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <freerange>:
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	56                   	push   %esi
80102774:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102775:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102778:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010277b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102781:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102787:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010278d:	39 de                	cmp    %ebx,%esi
8010278f:	72 23                	jb     801027b4 <freerange+0x44>
80102791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102798:	83 ec 0c             	sub    $0xc,%esp
8010279b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027a7:	50                   	push   %eax
801027a8:	e8 23 ff ff ff       	call   801026d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027ad:	83 c4 10             	add    $0x10,%esp
801027b0:	39 de                	cmp    %ebx,%esi
801027b2:	73 e4                	jae    80102798 <freerange+0x28>
}
801027b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027b7:	5b                   	pop    %ebx
801027b8:	5e                   	pop    %esi
801027b9:	5d                   	pop    %ebp
801027ba:	c3                   	ret
801027bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027bf:	90                   	nop

801027c0 <kinit2>:
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	56                   	push   %esi
801027c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801027c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801027cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027dd:	39 de                	cmp    %ebx,%esi
801027df:	72 23                	jb     80102804 <kinit2+0x44>
801027e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027e8:	83 ec 0c             	sub    $0xc,%esp
801027eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027f7:	50                   	push   %eax
801027f8:	e8 d3 fe ff ff       	call   801026d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027fd:	83 c4 10             	add    $0x10,%esp
80102800:	39 de                	cmp    %ebx,%esi
80102802:	73 e4                	jae    801027e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102804:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010280b:	00 00 00 
}
8010280e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102811:	5b                   	pop    %ebx
80102812:	5e                   	pop    %esi
80102813:	5d                   	pop    %ebp
80102814:	c3                   	ret
80102815:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010281c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102820 <kinit1>:
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	56                   	push   %esi
80102824:	53                   	push   %ebx
80102825:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102828:	83 ec 08             	sub    $0x8,%esp
8010282b:	68 0c 76 10 80       	push   $0x8010760c
80102830:	68 40 16 11 80       	push   $0x80111640
80102835:	e8 b6 1d 00 00       	call   801045f0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010283a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010283d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102840:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102847:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010284a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102850:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102856:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010285c:	39 de                	cmp    %ebx,%esi
8010285e:	72 1c                	jb     8010287c <kinit1+0x5c>
    kfree(p);
80102860:	83 ec 0c             	sub    $0xc,%esp
80102863:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102869:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010286f:	50                   	push   %eax
80102870:	e8 5b fe ff ff       	call   801026d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102875:	83 c4 10             	add    $0x10,%esp
80102878:	39 de                	cmp    %ebx,%esi
8010287a:	73 e4                	jae    80102860 <kinit1+0x40>
}
8010287c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010287f:	5b                   	pop    %ebx
80102880:	5e                   	pop    %esi
80102881:	5d                   	pop    %ebp
80102882:	c3                   	ret
80102883:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102890 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	53                   	push   %ebx
80102894:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102897:	a1 74 16 11 80       	mov    0x80111674,%eax
8010289c:	85 c0                	test   %eax,%eax
8010289e:	75 20                	jne    801028c0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801028a0:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
801028a6:	85 db                	test   %ebx,%ebx
801028a8:	74 07                	je     801028b1 <kalloc+0x21>
    kmem.freelist = r->next;
801028aa:	8b 03                	mov    (%ebx),%eax
801028ac:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801028b1:	89 d8                	mov    %ebx,%eax
801028b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028b6:	c9                   	leave
801028b7:	c3                   	ret
801028b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop
    acquire(&kmem.lock);
801028c0:	83 ec 0c             	sub    $0xc,%esp
801028c3:	68 40 16 11 80       	push   $0x80111640
801028c8:	e8 03 1f 00 00       	call   801047d0 <acquire>
  r = kmem.freelist;
801028cd:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
801028d3:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
801028d8:	83 c4 10             	add    $0x10,%esp
801028db:	85 db                	test   %ebx,%ebx
801028dd:	74 08                	je     801028e7 <kalloc+0x57>
    kmem.freelist = r->next;
801028df:	8b 13                	mov    (%ebx),%edx
801028e1:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801028e7:	85 c0                	test   %eax,%eax
801028e9:	74 c6                	je     801028b1 <kalloc+0x21>
    release(&kmem.lock);
801028eb:	83 ec 0c             	sub    $0xc,%esp
801028ee:	68 40 16 11 80       	push   $0x80111640
801028f3:	e8 78 1e 00 00       	call   80104770 <release>
}
801028f8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801028fa:	83 c4 10             	add    $0x10,%esp
}
801028fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102900:	c9                   	leave
80102901:	c3                   	ret
80102902:	66 90                	xchg   %ax,%ax
80102904:	66 90                	xchg   %ax,%ax
80102906:	66 90                	xchg   %ax,%ax
80102908:	66 90                	xchg   %ax,%ax
8010290a:	66 90                	xchg   %ax,%ax
8010290c:	66 90                	xchg   %ax,%ax
8010290e:	66 90                	xchg   %ax,%ax

80102910 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	ba 64 00 00 00       	mov    $0x64,%edx
80102915:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102916:	a8 01                	test   $0x1,%al
80102918:	0f 84 c2 00 00 00    	je     801029e0 <kbdgetc+0xd0>
{
8010291e:	55                   	push   %ebp
8010291f:	ba 60 00 00 00       	mov    $0x60,%edx
80102924:	89 e5                	mov    %esp,%ebp
80102926:	53                   	push   %ebx
80102927:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102928:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010292e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102931:	3c e0                	cmp    $0xe0,%al
80102933:	74 5b                	je     80102990 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102935:	89 da                	mov    %ebx,%edx
80102937:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010293a:	84 c0                	test   %al,%al
8010293c:	78 6a                	js     801029a8 <kbdgetc+0x98>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010293e:	85 d2                	test   %edx,%edx
80102940:	74 09                	je     8010294b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102942:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102945:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102948:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010294b:	0f b6 91 40 77 10 80 	movzbl -0x7fef88c0(%ecx),%edx
  shift ^= togglecode[data];
80102952:	0f b6 81 40 76 10 80 	movzbl -0x7fef89c0(%ecx),%eax
  shift |= shiftcode[data];
80102959:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010295b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010295d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010295f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102965:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102968:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010296b:	8b 04 85 20 76 10 80 	mov    -0x7fef89e0(,%eax,4),%eax
80102972:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102976:	74 0b                	je     80102983 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102978:	8d 50 9f             	lea    -0x61(%eax),%edx
8010297b:	83 fa 19             	cmp    $0x19,%edx
8010297e:	77 48                	ja     801029c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102980:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102983:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102986:	c9                   	leave
80102987:	c3                   	ret
80102988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298f:	90                   	nop
    shift |= E0ESC;
80102990:	89 d8                	mov    %ebx,%eax
80102992:	83 c8 40             	or     $0x40,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102995:	a3 7c 16 11 80       	mov    %eax,0x8011167c
}
8010299a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
8010299d:	31 c0                	xor    %eax,%eax
}
8010299f:	c9                   	leave
801029a0:	c3                   	ret
801029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    data = (shift & E0ESC ? data : data & 0x7F);
801029a8:	83 e0 7f             	and    $0x7f,%eax
801029ab:	85 d2                	test   %edx,%edx
801029ad:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801029b0:	0f b6 81 40 77 10 80 	movzbl -0x7fef88c0(%ecx),%eax
801029b7:	83 c8 40             	or     $0x40,%eax
801029ba:	0f b6 c0             	movzbl %al,%eax
801029bd:	f7 d0                	not    %eax
801029bf:	21 d8                	and    %ebx,%eax
    return 0;
801029c1:	eb d2                	jmp    80102995 <kbdgetc+0x85>
801029c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029c7:	90                   	nop
    else if('A' <= c && c <= 'Z')
801029c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801029cb:	8d 50 20             	lea    0x20(%eax),%edx
}
801029ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029d1:	c9                   	leave
      c += 'a' - 'A';
801029d2:	83 f9 1a             	cmp    $0x1a,%ecx
801029d5:	0f 42 c2             	cmovb  %edx,%eax
}
801029d8:	c3                   	ret
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801029e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029e5:	c3                   	ret
801029e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ed:	8d 76 00             	lea    0x0(%esi),%esi

801029f0 <kbdintr>:

void
kbdintr(void)
{
801029f0:	55                   	push   %ebp
801029f1:	89 e5                	mov    %esp,%ebp
801029f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029f6:	68 10 29 10 80       	push   $0x80102910
801029fb:	e8 c0 de ff ff       	call   801008c0 <consoleintr>
}
80102a00:	83 c4 10             	add    $0x10,%esp
80102a03:	c9                   	leave
80102a04:	c3                   	ret
80102a05:	66 90                	xchg   %ax,%ax
80102a07:	66 90                	xchg   %ax,%ax
80102a09:	66 90                	xchg   %ax,%ax
80102a0b:	66 90                	xchg   %ax,%ax
80102a0d:	66 90                	xchg   %ax,%ax
80102a0f:	90                   	nop

80102a10 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a10:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a15:	85 c0                	test   %eax,%eax
80102a17:	0f 84 cb 00 00 00    	je     80102ae8 <lapicinit+0xd8>
  lapic[index] = value;
80102a1d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a24:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a27:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a2a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a31:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a34:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a37:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a3e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a41:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a44:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a4b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a51:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a58:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a5e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a65:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a68:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a6b:	8b 50 30             	mov    0x30(%eax),%edx
80102a6e:	c1 ea 10             	shr    $0x10,%edx
80102a71:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102a77:	75 77                	jne    80102af0 <lapicinit+0xe0>
  lapic[index] = value;
80102a79:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a80:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a83:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a86:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a8d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a90:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a93:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a9a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aa0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102aa7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aaa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ab4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ac1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac4:	8b 50 20             	mov    0x20(%eax),%edx
80102ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ace:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ad0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ad6:	80 e6 10             	and    $0x10,%dh
80102ad9:	75 f5                	jne    80102ad0 <lapicinit+0xc0>
  lapic[index] = value;
80102adb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ae2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ae8:	c3                   	ret
80102ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102af0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102af7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102afa:	8b 50 20             	mov    0x20(%eax),%edx
}
80102afd:	e9 77 ff ff ff       	jmp    80102a79 <lapicinit+0x69>
80102b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b10 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b10:	a1 80 16 11 80       	mov    0x80111680,%eax
80102b15:	85 c0                	test   %eax,%eax
80102b17:	74 07                	je     80102b20 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102b19:	8b 40 20             	mov    0x20(%eax),%eax
80102b1c:	c1 e8 18             	shr    $0x18,%eax
80102b1f:	c3                   	ret
    return 0;
80102b20:	31 c0                	xor    %eax,%eax
}
80102b22:	c3                   	ret
80102b23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b30 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b30:	a1 80 16 11 80       	mov    0x80111680,%eax
80102b35:	85 c0                	test   %eax,%eax
80102b37:	74 0d                	je     80102b46 <lapiceoi+0x16>
  lapic[index] = value;
80102b39:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b40:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b43:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b46:	c3                   	ret
80102b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b4e:	66 90                	xchg   %ax,%ax

80102b50 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102b50:	c3                   	ret
80102b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b5f:	90                   	nop

80102b60 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b60:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b61:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b66:	ba 70 00 00 00       	mov    $0x70,%edx
80102b6b:	89 e5                	mov    %esp,%ebp
80102b6d:	53                   	push   %ebx
80102b6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b74:	ee                   	out    %al,(%dx)
80102b75:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b7a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b7f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b80:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102b82:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b85:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b8b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b8d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102b90:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b92:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b95:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b98:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b9e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102ba3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ba9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102bb3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bb9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102bc0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bc6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bcc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bcf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bd5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bd8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bde:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102be1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102be7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102bea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bed:	c9                   	leave
80102bee:	c3                   	ret
80102bef:	90                   	nop

80102bf0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102bf0:	55                   	push   %ebp
80102bf1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102bf6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bfb:	89 e5                	mov    %esp,%ebp
80102bfd:	57                   	push   %edi
80102bfe:	56                   	push   %esi
80102bff:	53                   	push   %ebx
80102c00:	83 ec 4c             	sub    $0x4c,%esp
80102c03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c04:	ba 71 00 00 00       	mov    $0x71,%edx
80102c09:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102c0a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c0d:	bf 70 00 00 00       	mov    $0x70,%edi
80102c12:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c15:	8d 76 00             	lea    0x0(%esi),%esi
80102c18:	31 c0                	xor    %eax,%eax
80102c1a:	89 fa                	mov    %edi,%edx
80102c1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c22:	89 ca                	mov    %ecx,%edx
80102c24:	ec                   	in     (%dx),%al
80102c25:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c28:	89 fa                	mov    %edi,%edx
80102c2a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c30:	89 ca                	mov    %ecx,%edx
80102c32:	ec                   	in     (%dx),%al
80102c33:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c36:	89 fa                	mov    %edi,%edx
80102c38:	b8 04 00 00 00       	mov    $0x4,%eax
80102c3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3e:	89 ca                	mov    %ecx,%edx
80102c40:	ec                   	in     (%dx),%al
80102c41:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c44:	89 fa                	mov    %edi,%edx
80102c46:	b8 07 00 00 00       	mov    $0x7,%eax
80102c4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4c:	89 ca                	mov    %ecx,%edx
80102c4e:	ec                   	in     (%dx),%al
80102c4f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c52:	89 fa                	mov    %edi,%edx
80102c54:	b8 08 00 00 00       	mov    $0x8,%eax
80102c59:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5a:	89 ca                	mov    %ecx,%edx
80102c5c:	ec                   	in     (%dx),%al
80102c5d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c5f:	89 fa                	mov    %edi,%edx
80102c61:	b8 09 00 00 00       	mov    $0x9,%eax
80102c66:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c67:	89 ca                	mov    %ecx,%edx
80102c69:	ec                   	in     (%dx),%al
80102c6a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c6d:	89 fa                	mov    %edi,%edx
80102c6f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c75:	89 ca                	mov    %ecx,%edx
80102c77:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c78:	84 c0                	test   %al,%al
80102c7a:	78 9c                	js     80102c18 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c7c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c80:	89 f2                	mov    %esi,%edx
80102c82:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102c85:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c88:	89 fa                	mov    %edi,%edx
80102c8a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c8d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c91:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102c94:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c97:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c9b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c9e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ca2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ca5:	31 c0                	xor    %eax,%eax
80102ca7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ca8:	89 ca                	mov    %ecx,%edx
80102caa:	ec                   	in     (%dx),%al
80102cab:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cae:	89 fa                	mov    %edi,%edx
80102cb0:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102cb3:	b8 02 00 00 00       	mov    $0x2,%eax
80102cb8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb9:	89 ca                	mov    %ecx,%edx
80102cbb:	ec                   	in     (%dx),%al
80102cbc:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cbf:	89 fa                	mov    %edi,%edx
80102cc1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102cc4:	b8 04 00 00 00       	mov    $0x4,%eax
80102cc9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cca:	89 ca                	mov    %ecx,%edx
80102ccc:	ec                   	in     (%dx),%al
80102ccd:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd0:	89 fa                	mov    %edi,%edx
80102cd2:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102cd5:	b8 07 00 00 00       	mov    $0x7,%eax
80102cda:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cdb:	89 ca                	mov    %ecx,%edx
80102cdd:	ec                   	in     (%dx),%al
80102cde:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce1:	89 fa                	mov    %edi,%edx
80102ce3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ce6:	b8 08 00 00 00       	mov    $0x8,%eax
80102ceb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cec:	89 ca                	mov    %ecx,%edx
80102cee:	ec                   	in     (%dx),%al
80102cef:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf2:	89 fa                	mov    %edi,%edx
80102cf4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102cf7:	b8 09 00 00 00       	mov    $0x9,%eax
80102cfc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cfd:	89 ca                	mov    %ecx,%edx
80102cff:	ec                   	in     (%dx),%al
80102d00:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d03:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102d06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d09:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d0c:	6a 18                	push   $0x18
80102d0e:	50                   	push   %eax
80102d0f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d12:	50                   	push   %eax
80102d13:	e8 d8 1b 00 00       	call   801048f0 <memcmp>
80102d18:	83 c4 10             	add    $0x10,%esp
80102d1b:	85 c0                	test   %eax,%eax
80102d1d:	0f 85 f5 fe ff ff    	jne    80102c18 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d23:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d2a:	89 f0                	mov    %esi,%eax
80102d2c:	84 c0                	test   %al,%al
80102d2e:	75 78                	jne    80102da8 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d30:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d33:	89 c2                	mov    %eax,%edx
80102d35:	83 e0 0f             	and    $0xf,%eax
80102d38:	c1 ea 04             	shr    $0x4,%edx
80102d3b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d3e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d41:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d44:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d47:	89 c2                	mov    %eax,%edx
80102d49:	83 e0 0f             	and    $0xf,%eax
80102d4c:	c1 ea 04             	shr    $0x4,%edx
80102d4f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d52:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d55:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d58:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d5b:	89 c2                	mov    %eax,%edx
80102d5d:	83 e0 0f             	and    $0xf,%eax
80102d60:	c1 ea 04             	shr    $0x4,%edx
80102d63:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d66:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d69:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d6c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d6f:	89 c2                	mov    %eax,%edx
80102d71:	83 e0 0f             	and    $0xf,%eax
80102d74:	c1 ea 04             	shr    $0x4,%edx
80102d77:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d7a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d7d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d80:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d83:	89 c2                	mov    %eax,%edx
80102d85:	83 e0 0f             	and    $0xf,%eax
80102d88:	c1 ea 04             	shr    $0x4,%edx
80102d8b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d8e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d91:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d94:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d97:	89 c2                	mov    %eax,%edx
80102d99:	83 e0 0f             	and    $0xf,%eax
80102d9c:	c1 ea 04             	shr    $0x4,%edx
80102d9f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102da2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102da5:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102da8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102dab:	89 03                	mov    %eax,(%ebx)
80102dad:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102db0:	89 43 04             	mov    %eax,0x4(%ebx)
80102db3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102db6:	89 43 08             	mov    %eax,0x8(%ebx)
80102db9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102dbc:	89 43 0c             	mov    %eax,0xc(%ebx)
80102dbf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102dc2:	89 43 10             	mov    %eax,0x10(%ebx)
80102dc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102dc8:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102dcb:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102dd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dd5:	5b                   	pop    %ebx
80102dd6:	5e                   	pop    %esi
80102dd7:	5f                   	pop    %edi
80102dd8:	5d                   	pop    %ebp
80102dd9:	c3                   	ret
80102dda:	66 90                	xchg   %ax,%ax
80102ddc:	66 90                	xchg   %ax,%ax
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102de0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102de6:	85 c9                	test   %ecx,%ecx
80102de8:	0f 8e 8a 00 00 00    	jle    80102e78 <install_trans+0x98>
{
80102dee:	55                   	push   %ebp
80102def:	89 e5                	mov    %esp,%ebp
80102df1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102df2:	31 ff                	xor    %edi,%edi
{
80102df4:	56                   	push   %esi
80102df5:	53                   	push   %ebx
80102df6:	83 ec 0c             	sub    $0xc,%esp
80102df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e00:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102e05:	83 ec 08             	sub    $0x8,%esp
80102e08:	01 f8                	add    %edi,%eax
80102e0a:	83 c0 01             	add    $0x1,%eax
80102e0d:	50                   	push   %eax
80102e0e:	ff 35 e4 16 11 80    	push   0x801116e4
80102e14:	e8 b7 d2 ff ff       	call   801000d0 <bread>
80102e19:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e1b:	58                   	pop    %eax
80102e1c:	5a                   	pop    %edx
80102e1d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102e24:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e2a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e2d:	e8 9e d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e32:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e35:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e37:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e3a:	68 00 02 00 00       	push   $0x200
80102e3f:	50                   	push   %eax
80102e40:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102e43:	50                   	push   %eax
80102e44:	e8 f7 1a 00 00       	call   80104940 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e49:	89 1c 24             	mov    %ebx,(%esp)
80102e4c:	e8 5f d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102e51:	89 34 24             	mov    %esi,(%esp)
80102e54:	e8 97 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102e59:	89 1c 24             	mov    %ebx,(%esp)
80102e5c:	e8 8f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e61:	83 c4 10             	add    $0x10,%esp
80102e64:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102e6a:	7f 94                	jg     80102e00 <install_trans+0x20>
  }
}
80102e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e6f:	5b                   	pop    %ebx
80102e70:	5e                   	pop    %esi
80102e71:	5f                   	pop    %edi
80102e72:	5d                   	pop    %ebp
80102e73:	c3                   	ret
80102e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e78:	c3                   	ret
80102e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e87:	ff 35 d4 16 11 80    	push   0x801116d4
80102e8d:	ff 35 e4 16 11 80    	push   0x801116e4
80102e93:	e8 38 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e98:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e9b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e9d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102ea2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ea5:	85 c0                	test   %eax,%eax
80102ea7:	7e 19                	jle    80102ec2 <write_head+0x42>
80102ea9:	31 d2                	xor    %edx,%edx
80102eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eaf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102eb0:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102eb7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ebb:	83 c2 01             	add    $0x1,%edx
80102ebe:	39 d0                	cmp    %edx,%eax
80102ec0:	75 ee                	jne    80102eb0 <write_head+0x30>
  }
  bwrite(buf);
80102ec2:	83 ec 0c             	sub    $0xc,%esp
80102ec5:	53                   	push   %ebx
80102ec6:	e8 e5 d2 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ecb:	89 1c 24             	mov    %ebx,(%esp)
80102ece:	e8 1d d3 ff ff       	call   801001f0 <brelse>
}
80102ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ed6:	83 c4 10             	add    $0x10,%esp
80102ed9:	c9                   	leave
80102eda:	c3                   	ret
80102edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102edf:	90                   	nop

80102ee0 <initlog>:
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	53                   	push   %ebx
80102ee4:	83 ec 2c             	sub    $0x2c,%esp
80102ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102eea:	68 40 78 10 80       	push   $0x80107840
80102eef:	68 a0 16 11 80       	push   $0x801116a0
80102ef4:	e8 f7 16 00 00       	call   801045f0 <initlock>
  readsb(dev, &sb);
80102ef9:	58                   	pop    %eax
80102efa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102efd:	5a                   	pop    %edx
80102efe:	50                   	push   %eax
80102eff:	53                   	push   %ebx
80102f00:	e8 eb e6 ff ff       	call   801015f0 <readsb>
  log.start = sb.logstart;
80102f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102f08:	59                   	pop    %ecx
  log.dev = dev;
80102f09:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102f0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102f12:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102f17:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102f1d:	5a                   	pop    %edx
80102f1e:	50                   	push   %eax
80102f1f:	53                   	push   %ebx
80102f20:	e8 ab d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102f25:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102f28:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102f2b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102f31:	85 db                	test   %ebx,%ebx
80102f33:	7e 1d                	jle    80102f52 <initlog+0x72>
80102f35:	31 d2                	xor    %edx,%edx
80102f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f40:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102f44:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f4b:	83 c2 01             	add    $0x1,%edx
80102f4e:	39 d3                	cmp    %edx,%ebx
80102f50:	75 ee                	jne    80102f40 <initlog+0x60>
  brelse(buf);
80102f52:	83 ec 0c             	sub    $0xc,%esp
80102f55:	50                   	push   %eax
80102f56:	e8 95 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f5b:	e8 80 fe ff ff       	call   80102de0 <install_trans>
  log.lh.n = 0;
80102f60:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102f67:	00 00 00 
  write_head(); // clear the log
80102f6a:	e8 11 ff ff ff       	call   80102e80 <write_head>
}
80102f6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f72:	83 c4 10             	add    $0x10,%esp
80102f75:	c9                   	leave
80102f76:	c3                   	ret
80102f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f7e:	66 90                	xchg   %ax,%ax

80102f80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f86:	68 a0 16 11 80       	push   $0x801116a0
80102f8b:	e8 40 18 00 00       	call   801047d0 <acquire>
80102f90:	83 c4 10             	add    $0x10,%esp
80102f93:	eb 18                	jmp    80102fad <begin_op+0x2d>
80102f95:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f98:	83 ec 08             	sub    $0x8,%esp
80102f9b:	68 a0 16 11 80       	push   $0x801116a0
80102fa0:	68 a0 16 11 80       	push   $0x801116a0
80102fa5:	e8 b6 12 00 00       	call   80104260 <sleep>
80102faa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102fad:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102fb2:	85 c0                	test   %eax,%eax
80102fb4:	75 e2                	jne    80102f98 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102fb6:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102fbb:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102fc1:	83 c0 01             	add    $0x1,%eax
80102fc4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102fc7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102fca:	83 fa 1e             	cmp    $0x1e,%edx
80102fcd:	7f c9                	jg     80102f98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fcf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102fd2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102fd7:	68 a0 16 11 80       	push   $0x801116a0
80102fdc:	e8 8f 17 00 00       	call   80104770 <release>
      break;
    }
  }
}
80102fe1:	83 c4 10             	add    $0x10,%esp
80102fe4:	c9                   	leave
80102fe5:	c3                   	ret
80102fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fed:	8d 76 00             	lea    0x0(%esi),%esi

80102ff0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	57                   	push   %edi
80102ff4:	56                   	push   %esi
80102ff5:	53                   	push   %ebx
80102ff6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ff9:	68 a0 16 11 80       	push   $0x801116a0
80102ffe:	e8 cd 17 00 00       	call   801047d0 <acquire>
  log.outstanding -= 1;
80103003:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80103008:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
8010300e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103011:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103014:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
8010301a:	85 f6                	test   %esi,%esi
8010301c:	0f 85 22 01 00 00    	jne    80103144 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103022:	85 db                	test   %ebx,%ebx
80103024:	0f 85 f6 00 00 00    	jne    80103120 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010302a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80103031:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103034:	83 ec 0c             	sub    $0xc,%esp
80103037:	68 a0 16 11 80       	push   $0x801116a0
8010303c:	e8 2f 17 00 00       	call   80104770 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103041:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80103047:	83 c4 10             	add    $0x10,%esp
8010304a:	85 c9                	test   %ecx,%ecx
8010304c:	7f 42                	jg     80103090 <end_op+0xa0>
    acquire(&log.lock);
8010304e:	83 ec 0c             	sub    $0xc,%esp
80103051:	68 a0 16 11 80       	push   $0x801116a0
80103056:	e8 75 17 00 00       	call   801047d0 <acquire>
    log.committing = 0;
8010305b:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80103062:	00 00 00 
    wakeup(&log);
80103065:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
8010306c:	e8 af 12 00 00       	call   80104320 <wakeup>
    release(&log.lock);
80103071:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80103078:	e8 f3 16 00 00       	call   80104770 <release>
8010307d:	83 c4 10             	add    $0x10,%esp
}
80103080:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103083:	5b                   	pop    %ebx
80103084:	5e                   	pop    %esi
80103085:	5f                   	pop    %edi
80103086:	5d                   	pop    %ebp
80103087:	c3                   	ret
80103088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010308f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103090:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80103095:	83 ec 08             	sub    $0x8,%esp
80103098:	01 d8                	add    %ebx,%eax
8010309a:	83 c0 01             	add    $0x1,%eax
8010309d:	50                   	push   %eax
8010309e:	ff 35 e4 16 11 80    	push   0x801116e4
801030a4:	e8 27 d0 ff ff       	call   801000d0 <bread>
801030a9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030ab:	58                   	pop    %eax
801030ac:	5a                   	pop    %edx
801030ad:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
801030b4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
801030ba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030bd:	e8 0e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801030c2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030c5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801030ca:	68 00 02 00 00       	push   $0x200
801030cf:	50                   	push   %eax
801030d0:	8d 46 5c             	lea    0x5c(%esi),%eax
801030d3:	50                   	push   %eax
801030d4:	e8 67 18 00 00       	call   80104940 <memmove>
    bwrite(to);  // write the log
801030d9:	89 34 24             	mov    %esi,(%esp)
801030dc:	e8 cf d0 ff ff       	call   801001b0 <bwrite>
    brelse(from);
801030e1:	89 3c 24             	mov    %edi,(%esp)
801030e4:	e8 07 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
801030e9:	89 34 24             	mov    %esi,(%esp)
801030ec:	e8 ff d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030f1:	83 c4 10             	add    $0x10,%esp
801030f4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
801030fa:	7c 94                	jl     80103090 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030fc:	e8 7f fd ff ff       	call   80102e80 <write_head>
    install_trans(); // Now install writes to home locations
80103101:	e8 da fc ff ff       	call   80102de0 <install_trans>
    log.lh.n = 0;
80103106:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
8010310d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103110:	e8 6b fd ff ff       	call   80102e80 <write_head>
80103115:	e9 34 ff ff ff       	jmp    8010304e <end_op+0x5e>
8010311a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103120:	83 ec 0c             	sub    $0xc,%esp
80103123:	68 a0 16 11 80       	push   $0x801116a0
80103128:	e8 f3 11 00 00       	call   80104320 <wakeup>
  release(&log.lock);
8010312d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80103134:	e8 37 16 00 00       	call   80104770 <release>
80103139:	83 c4 10             	add    $0x10,%esp
}
8010313c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010313f:	5b                   	pop    %ebx
80103140:	5e                   	pop    %esi
80103141:	5f                   	pop    %edi
80103142:	5d                   	pop    %ebp
80103143:	c3                   	ret
    panic("log.committing");
80103144:	83 ec 0c             	sub    $0xc,%esp
80103147:	68 44 78 10 80       	push   $0x80107844
8010314c:	e8 2f d2 ff ff       	call   80100380 <panic>
80103151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop

80103160 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	53                   	push   %ebx
80103164:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103167:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
8010316d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103170:	83 fa 1d             	cmp    $0x1d,%edx
80103173:	7f 7d                	jg     801031f2 <log_write+0x92>
80103175:	a1 d8 16 11 80       	mov    0x801116d8,%eax
8010317a:	83 e8 01             	sub    $0x1,%eax
8010317d:	39 c2                	cmp    %eax,%edx
8010317f:	7d 71                	jge    801031f2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103181:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80103186:	85 c0                	test   %eax,%eax
80103188:	7e 75                	jle    801031ff <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010318a:	83 ec 0c             	sub    $0xc,%esp
8010318d:	68 a0 16 11 80       	push   $0x801116a0
80103192:	e8 39 16 00 00       	call   801047d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103197:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010319a:	83 c4 10             	add    $0x10,%esp
8010319d:	31 c0                	xor    %eax,%eax
8010319f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
801031a5:	85 d2                	test   %edx,%edx
801031a7:	7f 0e                	jg     801031b7 <log_write+0x57>
801031a9:	eb 15                	jmp    801031c0 <log_write+0x60>
801031ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	83 c0 01             	add    $0x1,%eax
801031b3:	39 c2                	cmp    %eax,%edx
801031b5:	74 29                	je     801031e0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031b7:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
801031be:	75 f0                	jne    801031b0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801031c0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
801031c7:	39 c2                	cmp    %eax,%edx
801031c9:	74 1c                	je     801031e7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801031cb:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801031ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801031d1:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
801031d8:	c9                   	leave
  release(&log.lock);
801031d9:	e9 92 15 00 00       	jmp    80104770 <release>
801031de:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
801031e0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
801031e7:	83 c2 01             	add    $0x1,%edx
801031ea:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
801031f0:	eb d9                	jmp    801031cb <log_write+0x6b>
    panic("too big a transaction");
801031f2:	83 ec 0c             	sub    $0xc,%esp
801031f5:	68 53 78 10 80       	push   $0x80107853
801031fa:	e8 81 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801031ff:	83 ec 0c             	sub    $0xc,%esp
80103202:	68 69 78 10 80       	push   $0x80107869
80103207:	e8 74 d1 ff ff       	call   80100380 <panic>
8010320c:	66 90                	xchg   %ax,%ax
8010320e:	66 90                	xchg   %ax,%ax

80103210 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	53                   	push   %ebx
80103214:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103217:	e8 64 09 00 00       	call   80103b80 <cpuid>
8010321c:	89 c3                	mov    %eax,%ebx
8010321e:	e8 5d 09 00 00       	call   80103b80 <cpuid>
80103223:	83 ec 04             	sub    $0x4,%esp
80103226:	53                   	push   %ebx
80103227:	50                   	push   %eax
80103228:	68 84 78 10 80       	push   $0x80107884
8010322d:	e8 7e d4 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103232:	e8 b9 28 00 00       	call   80105af0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103237:	e8 e4 08 00 00       	call   80103b20 <mycpu>
8010323c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010323e:	b8 01 00 00 00       	mov    $0x1,%eax
80103243:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010324a:	e8 01 0c 00 00       	call   80103e50 <scheduler>
8010324f:	90                   	nop

80103250 <mpenter>:
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103256:	e8 a5 39 00 00       	call   80106c00 <switchkvm>
  seginit();
8010325b:	e8 10 39 00 00       	call   80106b70 <seginit>
  lapicinit();
80103260:	e8 ab f7 ff ff       	call   80102a10 <lapicinit>
  mpmain();
80103265:	e8 a6 ff ff ff       	call   80103210 <mpmain>
8010326a:	66 90                	xchg   %ax,%ax
8010326c:	66 90                	xchg   %ax,%ax
8010326e:	66 90                	xchg   %ax,%ax

80103270 <main>:
{
80103270:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103274:	83 e4 f0             	and    $0xfffffff0,%esp
80103277:	ff 71 fc             	push   -0x4(%ecx)
8010327a:	55                   	push   %ebp
8010327b:	89 e5                	mov    %esp,%ebp
8010327d:	53                   	push   %ebx
8010327e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010327f:	83 ec 08             	sub    $0x8,%esp
80103282:	68 00 00 40 80       	push   $0x80400000
80103287:	68 d0 54 11 80       	push   $0x801154d0
8010328c:	e8 8f f5 ff ff       	call   80102820 <kinit1>
  kvmalloc();      // kernel page table
80103291:	e8 2a 3e 00 00       	call   801070c0 <kvmalloc>
  mpinit();        // detect other processors
80103296:	e8 85 01 00 00       	call   80103420 <mpinit>
  lapicinit();     // interrupt controller
8010329b:	e8 70 f7 ff ff       	call   80102a10 <lapicinit>
  seginit();       // segment descriptors
801032a0:	e8 cb 38 00 00       	call   80106b70 <seginit>
  picinit();       // disable pic
801032a5:	e8 86 03 00 00       	call   80103630 <picinit>
  ioapicinit();    // another interrupt controller
801032aa:	e8 41 f3 ff ff       	call   801025f0 <ioapicinit>
  consoleinit();   // console hardware
801032af:	e8 dc d7 ff ff       	call   80100a90 <consoleinit>
  uartinit();      // serial port
801032b4:	e8 27 2b 00 00       	call   80105de0 <uartinit>
  pinit();         // process table
801032b9:	e8 42 08 00 00       	call   80103b00 <pinit>
  tvinit();        // trap vectors
801032be:	e8 ad 27 00 00       	call   80105a70 <tvinit>
  binit();         // buffer cache
801032c3:	e8 78 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032c8:	e8 93 db ff ff       	call   80100e60 <fileinit>
  ideinit();       // disk 
801032cd:	e8 fe f0 ff ff       	call   801023d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032d2:	83 c4 0c             	add    $0xc,%esp
801032d5:	68 8a 00 00 00       	push   $0x8a
801032da:	68 8c a4 10 80       	push   $0x8010a48c
801032df:	68 00 70 00 80       	push   $0x80007000
801032e4:	e8 57 16 00 00       	call   80104940 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032e9:	83 c4 10             	add    $0x10,%esp
801032ec:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801032f3:	00 00 00 
801032f6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801032fb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103300:	76 7e                	jbe    80103380 <main+0x110>
80103302:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103307:	eb 20                	jmp    80103329 <main+0xb9>
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103310:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103317:	00 00 00 
8010331a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103320:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103325:	39 c3                	cmp    %eax,%ebx
80103327:	73 57                	jae    80103380 <main+0x110>
    if(c == mycpu())  // We've started already.
80103329:	e8 f2 07 00 00       	call   80103b20 <mycpu>
8010332e:	39 c3                	cmp    %eax,%ebx
80103330:	74 de                	je     80103310 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103332:	e8 59 f5 ff ff       	call   80102890 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103337:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010333a:	c7 05 f8 6f 00 80 50 	movl   $0x80103250,0x80006ff8
80103341:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103344:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010334b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010334e:	05 00 10 00 00       	add    $0x1000,%eax
80103353:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103358:	0f b6 03             	movzbl (%ebx),%eax
8010335b:	68 00 70 00 00       	push   $0x7000
80103360:	50                   	push   %eax
80103361:	e8 fa f7 ff ff       	call   80102b60 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103366:	83 c4 10             	add    $0x10,%esp
80103369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103370:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103376:	85 c0                	test   %eax,%eax
80103378:	74 f6                	je     80103370 <main+0x100>
8010337a:	eb 94                	jmp    80103310 <main+0xa0>
8010337c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103380:	83 ec 08             	sub    $0x8,%esp
80103383:	68 00 00 00 8e       	push   $0x8e000000
80103388:	68 00 00 40 80       	push   $0x80400000
8010338d:	e8 2e f4 ff ff       	call   801027c0 <kinit2>
  userinit();      // first user process
80103392:	e8 39 08 00 00       	call   80103bd0 <userinit>
  mpmain();        // finish this processor's setup
80103397:	e8 74 fe ff ff       	call   80103210 <mpmain>
8010339c:	66 90                	xchg   %ax,%ax
8010339e:	66 90                	xchg   %ax,%ax

801033a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801033a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801033ab:	53                   	push   %ebx
  e = addr+len;
801033ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801033af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801033b2:	39 de                	cmp    %ebx,%esi
801033b4:	72 10                	jb     801033c6 <mpsearch1+0x26>
801033b6:	eb 50                	jmp    80103408 <mpsearch1+0x68>
801033b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033bf:	90                   	nop
801033c0:	89 fe                	mov    %edi,%esi
801033c2:	39 df                	cmp    %ebx,%edi
801033c4:	73 42                	jae    80103408 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033c6:	83 ec 04             	sub    $0x4,%esp
801033c9:	8d 7e 10             	lea    0x10(%esi),%edi
801033cc:	6a 04                	push   $0x4
801033ce:	68 98 78 10 80       	push   $0x80107898
801033d3:	56                   	push   %esi
801033d4:	e8 17 15 00 00       	call   801048f0 <memcmp>
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	85 c0                	test   %eax,%eax
801033de:	75 e0                	jne    801033c0 <mpsearch1+0x20>
801033e0:	89 f2                	mov    %esi,%edx
801033e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033f0:	39 fa                	cmp    %edi,%edx
801033f2:	75 f4                	jne    801033e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033f4:	84 c0                	test   %al,%al
801033f6:	75 c8                	jne    801033c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033fb:	89 f0                	mov    %esi,%eax
801033fd:	5b                   	pop    %ebx
801033fe:	5e                   	pop    %esi
801033ff:	5f                   	pop    %edi
80103400:	5d                   	pop    %ebp
80103401:	c3                   	ret
80103402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103408:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010340b:	31 f6                	xor    %esi,%esi
}
8010340d:	5b                   	pop    %ebx
8010340e:	89 f0                	mov    %esi,%eax
80103410:	5e                   	pop    %esi
80103411:	5f                   	pop    %edi
80103412:	5d                   	pop    %ebp
80103413:	c3                   	ret
80103414:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010341b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010341f:	90                   	nop

80103420 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	57                   	push   %edi
80103424:	56                   	push   %esi
80103425:	53                   	push   %ebx
80103426:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103429:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103430:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103437:	c1 e0 08             	shl    $0x8,%eax
8010343a:	09 d0                	or     %edx,%eax
8010343c:	c1 e0 04             	shl    $0x4,%eax
8010343f:	75 1b                	jne    8010345c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103441:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103448:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010344f:	c1 e0 08             	shl    $0x8,%eax
80103452:	09 d0                	or     %edx,%eax
80103454:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103457:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010345c:	ba 00 04 00 00       	mov    $0x400,%edx
80103461:	e8 3a ff ff ff       	call   801033a0 <mpsearch1>
80103466:	89 c3                	mov    %eax,%ebx
80103468:	85 c0                	test   %eax,%eax
8010346a:	0f 84 50 01 00 00    	je     801035c0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103470:	8b 73 04             	mov    0x4(%ebx),%esi
80103473:	85 f6                	test   %esi,%esi
80103475:	0f 84 35 01 00 00    	je     801035b0 <mpinit+0x190>
  if(memcmp(conf, "PCMP", 4) != 0)
8010347b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010347e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103484:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103487:	6a 04                	push   $0x4
80103489:	68 9d 78 10 80       	push   $0x8010789d
8010348e:	50                   	push   %eax
8010348f:	e8 5c 14 00 00       	call   801048f0 <memcmp>
80103494:	83 c4 10             	add    $0x10,%esp
80103497:	85 c0                	test   %eax,%eax
80103499:	0f 85 11 01 00 00    	jne    801035b0 <mpinit+0x190>
  if(conf->version != 1 && conf->version != 4)
8010349f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801034a6:	3c 01                	cmp    $0x1,%al
801034a8:	74 08                	je     801034b2 <mpinit+0x92>
801034aa:	3c 04                	cmp    $0x4,%al
801034ac:	0f 85 fe 00 00 00    	jne    801035b0 <mpinit+0x190>
  if(sum((uchar*)conf, conf->length) != 0)
801034b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801034b9:	66 85 d2             	test   %dx,%dx
801034bc:	74 22                	je     801034e0 <mpinit+0xc0>
801034be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801034c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801034c3:	31 d2                	xor    %edx,%edx
801034c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801034cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034d4:	39 c7                	cmp    %eax,%edi
801034d6:	75 f0                	jne    801034c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801034d8:	84 d2                	test   %dl,%dl
801034da:	0f 85 d0 00 00 00    	jne    801035b0 <mpinit+0x190>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801034e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801034ec:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034f1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034f8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801034fe:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103503:	01 d7                	add    %edx,%edi
80103505:	89 fa                	mov    %edi,%edx
80103507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350e:	66 90                	xchg   %ax,%ax
80103510:	39 d0                	cmp    %edx,%eax
80103512:	73 15                	jae    80103529 <mpinit+0x109>
    switch(*p){
80103514:	0f b6 08             	movzbl (%eax),%ecx
80103517:	80 f9 02             	cmp    $0x2,%cl
8010351a:	74 54                	je     80103570 <mpinit+0x150>
8010351c:	77 42                	ja     80103560 <mpinit+0x140>
8010351e:	84 c9                	test   %cl,%cl
80103520:	74 5e                	je     80103580 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103522:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103525:	39 d0                	cmp    %edx,%eax
80103527:	72 eb                	jb     80103514 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103529:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010352c:	85 f6                	test   %esi,%esi
8010352e:	0f 84 e1 00 00 00    	je     80103615 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103534:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103538:	74 15                	je     8010354f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010353a:	b8 70 00 00 00       	mov    $0x70,%eax
8010353f:	ba 22 00 00 00       	mov    $0x22,%edx
80103544:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103545:	ba 23 00 00 00       	mov    $0x23,%edx
8010354a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010354b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010354e:	ee                   	out    %al,(%dx)
  }
}
8010354f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103552:	5b                   	pop    %ebx
80103553:	5e                   	pop    %esi
80103554:	5f                   	pop    %edi
80103555:	5d                   	pop    %ebp
80103556:	c3                   	ret
80103557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010355e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103560:	83 e9 03             	sub    $0x3,%ecx
80103563:	80 f9 01             	cmp    $0x1,%cl
80103566:	76 ba                	jbe    80103522 <mpinit+0x102>
80103568:	31 f6                	xor    %esi,%esi
8010356a:	eb a4                	jmp    80103510 <mpinit+0xf0>
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103570:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103574:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103577:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010357d:	eb 91                	jmp    80103510 <mpinit+0xf0>
8010357f:	90                   	nop
      if(ncpu < NCPU) {
80103580:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103586:	83 f9 07             	cmp    $0x7,%ecx
80103589:	7f 19                	jg     801035a4 <mpinit+0x184>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010358b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103591:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103595:	83 c1 01             	add    $0x1,%ecx
80103598:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010359e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
801035a4:	83 c0 14             	add    $0x14,%eax
      continue;
801035a7:	e9 64 ff ff ff       	jmp    80103510 <mpinit+0xf0>
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	68 a2 78 10 80       	push   $0x801078a2
801035b8:	e8 c3 cd ff ff       	call   80100380 <panic>
801035bd:	8d 76 00             	lea    0x0(%esi),%esi
{
801035c0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801035c5:	eb 13                	jmp    801035da <mpinit+0x1ba>
801035c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ce:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801035d0:	89 f3                	mov    %esi,%ebx
801035d2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801035d8:	74 d6                	je     801035b0 <mpinit+0x190>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035da:	83 ec 04             	sub    $0x4,%esp
801035dd:	8d 73 10             	lea    0x10(%ebx),%esi
801035e0:	6a 04                	push   $0x4
801035e2:	68 98 78 10 80       	push   $0x80107898
801035e7:	53                   	push   %ebx
801035e8:	e8 03 13 00 00       	call   801048f0 <memcmp>
801035ed:	83 c4 10             	add    $0x10,%esp
801035f0:	85 c0                	test   %eax,%eax
801035f2:	75 dc                	jne    801035d0 <mpinit+0x1b0>
801035f4:	89 da                	mov    %ebx,%edx
801035f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103600:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103603:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103606:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103608:	39 f2                	cmp    %esi,%edx
8010360a:	75 f4                	jne    80103600 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010360c:	84 c0                	test   %al,%al
8010360e:	75 c0                	jne    801035d0 <mpinit+0x1b0>
80103610:	e9 5b fe ff ff       	jmp    80103470 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103615:	83 ec 0c             	sub    $0xc,%esp
80103618:	68 bc 78 10 80       	push   $0x801078bc
8010361d:	e8 5e cd ff ff       	call   80100380 <panic>
80103622:	66 90                	xchg   %ax,%ax
80103624:	66 90                	xchg   %ax,%ax
80103626:	66 90                	xchg   %ax,%ax
80103628:	66 90                	xchg   %ax,%ax
8010362a:	66 90                	xchg   %ax,%ax
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <picinit>:
80103630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103635:	ba 21 00 00 00       	mov    $0x21,%edx
8010363a:	ee                   	out    %al,(%dx)
8010363b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103640:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103641:	c3                   	ret
80103642:	66 90                	xchg   %ax,%ax
80103644:	66 90                	xchg   %ax,%ax
80103646:	66 90                	xchg   %ax,%ax
80103648:	66 90                	xchg   %ax,%ax
8010364a:	66 90                	xchg   %ax,%ax
8010364c:	66 90                	xchg   %ax,%ax
8010364e:	66 90                	xchg   %ax,%ax

80103650 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
80103655:	53                   	push   %ebx
80103656:	83 ec 0c             	sub    $0xc,%esp
80103659:	8b 75 08             	mov    0x8(%ebp),%esi
8010365c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010365f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103665:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010366b:	e8 10 d8 ff ff       	call   80100e80 <filealloc>
80103670:	89 06                	mov    %eax,(%esi)
80103672:	85 c0                	test   %eax,%eax
80103674:	0f 84 a5 00 00 00    	je     8010371f <pipealloc+0xcf>
8010367a:	e8 01 d8 ff ff       	call   80100e80 <filealloc>
8010367f:	89 07                	mov    %eax,(%edi)
80103681:	85 c0                	test   %eax,%eax
80103683:	0f 84 84 00 00 00    	je     8010370d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103689:	e8 02 f2 ff ff       	call   80102890 <kalloc>
8010368e:	89 c3                	mov    %eax,%ebx
80103690:	85 c0                	test   %eax,%eax
80103692:	0f 84 a0 00 00 00    	je     80103738 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103698:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010369f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801036a2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801036a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801036ac:	00 00 00 
  p->nwrite = 0;
801036af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801036b6:	00 00 00 
  p->nread = 0;
801036b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036c0:	00 00 00 
  initlock(&p->lock, "pipe");
801036c3:	68 db 78 10 80       	push   $0x801078db
801036c8:	50                   	push   %eax
801036c9:	e8 22 0f 00 00       	call   801045f0 <initlock>
  (*f0)->type = FD_PIPE;
801036ce:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036d0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801036d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036d9:	8b 06                	mov    (%esi),%eax
801036db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036df:	8b 06                	mov    (%esi),%eax
801036e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036e5:	8b 06                	mov    (%esi),%eax
801036e7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036ea:	8b 07                	mov    (%edi),%eax
801036ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036f2:	8b 07                	mov    (%edi),%eax
801036f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036f8:	8b 07                	mov    (%edi),%eax
801036fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036fe:	8b 07                	mov    (%edi),%eax
80103700:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103703:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103705:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103708:	5b                   	pop    %ebx
80103709:	5e                   	pop    %esi
8010370a:	5f                   	pop    %edi
8010370b:	5d                   	pop    %ebp
8010370c:	c3                   	ret
  if(*f0)
8010370d:	8b 06                	mov    (%esi),%eax
8010370f:	85 c0                	test   %eax,%eax
80103711:	74 1e                	je     80103731 <pipealloc+0xe1>
    fileclose(*f0);
80103713:	83 ec 0c             	sub    $0xc,%esp
80103716:	50                   	push   %eax
80103717:	e8 24 d8 ff ff       	call   80100f40 <fileclose>
8010371c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010371f:	8b 07                	mov    (%edi),%eax
80103721:	85 c0                	test   %eax,%eax
80103723:	74 0c                	je     80103731 <pipealloc+0xe1>
    fileclose(*f1);
80103725:	83 ec 0c             	sub    $0xc,%esp
80103728:	50                   	push   %eax
80103729:	e8 12 d8 ff ff       	call   80100f40 <fileclose>
8010372e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103736:	eb cd                	jmp    80103705 <pipealloc+0xb5>
  if(*f0)
80103738:	8b 06                	mov    (%esi),%eax
8010373a:	85 c0                	test   %eax,%eax
8010373c:	75 d5                	jne    80103713 <pipealloc+0xc3>
8010373e:	eb df                	jmp    8010371f <pipealloc+0xcf>

80103740 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	56                   	push   %esi
80103744:	53                   	push   %ebx
80103745:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103748:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010374b:	83 ec 0c             	sub    $0xc,%esp
8010374e:	53                   	push   %ebx
8010374f:	e8 7c 10 00 00       	call   801047d0 <acquire>
  if(writable){
80103754:	83 c4 10             	add    $0x10,%esp
80103757:	85 f6                	test   %esi,%esi
80103759:	74 65                	je     801037c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010375b:	83 ec 0c             	sub    $0xc,%esp
8010375e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103764:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010376b:	00 00 00 
    wakeup(&p->nread);
8010376e:	50                   	push   %eax
8010376f:	e8 ac 0b 00 00       	call   80104320 <wakeup>
80103774:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103777:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010377d:	85 d2                	test   %edx,%edx
8010377f:	75 0a                	jne    8010378b <pipeclose+0x4b>
80103781:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103787:	85 c0                	test   %eax,%eax
80103789:	74 15                	je     801037a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010378b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010378e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103791:	5b                   	pop    %ebx
80103792:	5e                   	pop    %esi
80103793:	5d                   	pop    %ebp
    release(&p->lock);
80103794:	e9 d7 0f 00 00       	jmp    80104770 <release>
80103799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
801037a3:	53                   	push   %ebx
801037a4:	e8 c7 0f 00 00       	call   80104770 <release>
    kfree((char*)p);
801037a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801037ac:	83 c4 10             	add    $0x10,%esp
}
801037af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b2:	5b                   	pop    %ebx
801037b3:	5e                   	pop    %esi
801037b4:	5d                   	pop    %ebp
    kfree((char*)p);
801037b5:	e9 16 ef ff ff       	jmp    801026d0 <kfree>
801037ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801037c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037d0:	00 00 00 
    wakeup(&p->nwrite);
801037d3:	50                   	push   %eax
801037d4:	e8 47 0b 00 00       	call   80104320 <wakeup>
801037d9:	83 c4 10             	add    $0x10,%esp
801037dc:	eb 99                	jmp    80103777 <pipeclose+0x37>
801037de:	66 90                	xchg   %ax,%ax

801037e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	57                   	push   %edi
801037e4:	56                   	push   %esi
801037e5:	53                   	push   %ebx
801037e6:	83 ec 28             	sub    $0x28,%esp
801037e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037ec:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801037ef:	53                   	push   %ebx
801037f0:	e8 db 0f 00 00       	call   801047d0 <acquire>
  for(i = 0; i < n; i++){
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	85 ff                	test   %edi,%edi
801037fa:	0f 8e ce 00 00 00    	jle    801038ce <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103800:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103806:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103809:	89 7d 10             	mov    %edi,0x10(%ebp)
8010380c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010380f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103812:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103815:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010381b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103821:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103827:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010382d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103830:	0f 85 b6 00 00 00    	jne    801038ec <pipewrite+0x10c>
80103836:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103839:	eb 3b                	jmp    80103876 <pipewrite+0x96>
8010383b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010383f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103840:	e8 5b 03 00 00       	call   80103ba0 <myproc>
80103845:	8b 48 24             	mov    0x24(%eax),%ecx
80103848:	85 c9                	test   %ecx,%ecx
8010384a:	75 34                	jne    80103880 <pipewrite+0xa0>
      wakeup(&p->nread);
8010384c:	83 ec 0c             	sub    $0xc,%esp
8010384f:	56                   	push   %esi
80103850:	e8 cb 0a 00 00       	call   80104320 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103855:	58                   	pop    %eax
80103856:	5a                   	pop    %edx
80103857:	53                   	push   %ebx
80103858:	57                   	push   %edi
80103859:	e8 02 0a 00 00       	call   80104260 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010385e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103864:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010386a:	83 c4 10             	add    $0x10,%esp
8010386d:	05 00 02 00 00       	add    $0x200,%eax
80103872:	39 c2                	cmp    %eax,%edx
80103874:	75 2a                	jne    801038a0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103876:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010387c:	85 c0                	test   %eax,%eax
8010387e:	75 c0                	jne    80103840 <pipewrite+0x60>
        release(&p->lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
80103883:	53                   	push   %ebx
80103884:	e8 e7 0e 00 00       	call   80104770 <release>
        return -1;
80103889:	83 c4 10             	add    $0x10,%esp
8010388c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103891:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103894:	5b                   	pop    %ebx
80103895:	5e                   	pop    %esi
80103896:	5f                   	pop    %edi
80103897:	5d                   	pop    %ebp
80103898:	c3                   	ret
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038a3:	8d 42 01             	lea    0x1(%edx),%eax
801038a6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
801038ac:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038af:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801038b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038b8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801038bc:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801038c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801038c3:	39 c1                	cmp    %eax,%ecx
801038c5:	0f 85 50 ff ff ff    	jne    8010381b <pipewrite+0x3b>
801038cb:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038ce:	83 ec 0c             	sub    $0xc,%esp
801038d1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038d7:	50                   	push   %eax
801038d8:	e8 43 0a 00 00       	call   80104320 <wakeup>
  release(&p->lock);
801038dd:	89 1c 24             	mov    %ebx,(%esp)
801038e0:	e8 8b 0e 00 00       	call   80104770 <release>
  return n;
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	89 f8                	mov    %edi,%eax
801038ea:	eb a5                	jmp    80103891 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038ef:	eb b2                	jmp    801038a3 <pipewrite+0xc3>
801038f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ff:	90                   	nop

80103900 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
80103905:	53                   	push   %ebx
80103906:	83 ec 18             	sub    $0x18,%esp
80103909:	8b 75 08             	mov    0x8(%ebp),%esi
8010390c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010390f:	56                   	push   %esi
80103910:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103916:	e8 b5 0e 00 00       	call   801047d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010391b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103921:	83 c4 10             	add    $0x10,%esp
80103924:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010392a:	74 2f                	je     8010395b <piperead+0x5b>
8010392c:	eb 37                	jmp    80103965 <piperead+0x65>
8010392e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103930:	e8 6b 02 00 00       	call   80103ba0 <myproc>
80103935:	8b 48 24             	mov    0x24(%eax),%ecx
80103938:	85 c9                	test   %ecx,%ecx
8010393a:	0f 85 80 00 00 00    	jne    801039c0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103940:	83 ec 08             	sub    $0x8,%esp
80103943:	56                   	push   %esi
80103944:	53                   	push   %ebx
80103945:	e8 16 09 00 00       	call   80104260 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010394a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103950:	83 c4 10             	add    $0x10,%esp
80103953:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103959:	75 0a                	jne    80103965 <piperead+0x65>
8010395b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103961:	85 c0                	test   %eax,%eax
80103963:	75 cb                	jne    80103930 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103965:	8b 55 10             	mov    0x10(%ebp),%edx
80103968:	31 db                	xor    %ebx,%ebx
8010396a:	85 d2                	test   %edx,%edx
8010396c:	7f 20                	jg     8010398e <piperead+0x8e>
8010396e:	eb 2c                	jmp    8010399c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103970:	8d 48 01             	lea    0x1(%eax),%ecx
80103973:	25 ff 01 00 00       	and    $0x1ff,%eax
80103978:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010397e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103983:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103986:	83 c3 01             	add    $0x1,%ebx
80103989:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010398c:	74 0e                	je     8010399c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010398e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103994:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010399a:	75 d4                	jne    80103970 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010399c:	83 ec 0c             	sub    $0xc,%esp
8010399f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801039a5:	50                   	push   %eax
801039a6:	e8 75 09 00 00       	call   80104320 <wakeup>
  release(&p->lock);
801039ab:	89 34 24             	mov    %esi,(%esp)
801039ae:	e8 bd 0d 00 00       	call   80104770 <release>
  return i;
801039b3:	83 c4 10             	add    $0x10,%esp
}
801039b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039b9:	89 d8                	mov    %ebx,%eax
801039bb:	5b                   	pop    %ebx
801039bc:	5e                   	pop    %esi
801039bd:	5f                   	pop    %edi
801039be:	5d                   	pop    %ebp
801039bf:	c3                   	ret
      release(&p->lock);
801039c0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801039c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801039c8:	56                   	push   %esi
801039c9:	e8 a2 0d 00 00       	call   80104770 <release>
      return -1;
801039ce:	83 c4 10             	add    $0x10,%esp
}
801039d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039d4:	89 d8                	mov    %ebx,%eax
801039d6:	5b                   	pop    %ebx
801039d7:	5e                   	pop    %esi
801039d8:	5f                   	pop    %edi
801039d9:	5d                   	pop    %ebp
801039da:	c3                   	ret
801039db:	66 90                	xchg   %ax,%ax
801039dd:	66 90                	xchg   %ax,%ax
801039df:	90                   	nop

801039e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039e4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801039e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039ec:	68 20 1d 11 80       	push   $0x80111d20
801039f1:	e8 da 0d 00 00       	call   801047d0 <acquire>
801039f6:	83 c4 10             	add    $0x10,%esp
801039f9:	eb 10                	jmp    80103a0b <allocproc+0x2b>
801039fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039ff:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a00:	83 c3 7c             	add    $0x7c,%ebx
80103a03:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103a09:	74 75                	je     80103a80 <allocproc+0xa0>
    if(p->state == UNUSED)
80103a0b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a0e:	85 c0                	test   %eax,%eax
80103a10:	75 ee                	jne    80103a00 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a12:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103a17:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103a1a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103a21:	89 43 10             	mov    %eax,0x10(%ebx)
80103a24:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103a27:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
80103a2c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103a32:	e8 39 0d 00 00       	call   80104770 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a37:	e8 54 ee ff ff       	call   80102890 <kalloc>
80103a3c:	83 c4 10             	add    $0x10,%esp
80103a3f:	89 43 08             	mov    %eax,0x8(%ebx)
80103a42:	85 c0                	test   %eax,%eax
80103a44:	74 53                	je     80103a99 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a46:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a4c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a4f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a54:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a57:	c7 40 14 62 5a 10 80 	movl   $0x80105a62,0x14(%eax)
  p->context = (struct context*)sp;
80103a5e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a61:	6a 14                	push   $0x14
80103a63:	6a 00                	push   $0x0
80103a65:	50                   	push   %eax
80103a66:	e8 45 0e 00 00       	call   801048b0 <memset>
  p->context->eip = (uint)forkret;
80103a6b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a6e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a71:	c7 40 10 b0 3a 10 80 	movl   $0x80103ab0,0x10(%eax)
}
80103a78:	89 d8                	mov    %ebx,%eax
80103a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a7d:	c9                   	leave
80103a7e:	c3                   	ret
80103a7f:	90                   	nop
  release(&ptable.lock);
80103a80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a83:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a85:	68 20 1d 11 80       	push   $0x80111d20
80103a8a:	e8 e1 0c 00 00       	call   80104770 <release>
  return 0;
80103a8f:	83 c4 10             	add    $0x10,%esp
}
80103a92:	89 d8                	mov    %ebx,%eax
80103a94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a97:	c9                   	leave
80103a98:	c3                   	ret
    p->state = UNUSED;
80103a99:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103aa0:	31 db                	xor    %ebx,%ebx
80103aa2:	eb ee                	jmp    80103a92 <allocproc+0xb2>
80103aa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103ab6:	68 20 1d 11 80       	push   $0x80111d20
80103abb:	e8 b0 0c 00 00       	call   80104770 <release>

  if (first) {
80103ac0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103ac5:	83 c4 10             	add    $0x10,%esp
80103ac8:	85 c0                	test   %eax,%eax
80103aca:	75 04                	jne    80103ad0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103acc:	c9                   	leave
80103acd:	c3                   	ret
80103ace:	66 90                	xchg   %ax,%ax
    first = 0;
80103ad0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103ad7:	00 00 00 
    iinit(ROOTDEV);
80103ada:	83 ec 0c             	sub    $0xc,%esp
80103add:	6a 01                	push   $0x1
80103adf:	e8 4c db ff ff       	call   80101630 <iinit>
    initlog(ROOTDEV);
80103ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103aeb:	e8 f0 f3 ff ff       	call   80102ee0 <initlog>
}
80103af0:	83 c4 10             	add    $0x10,%esp
80103af3:	c9                   	leave
80103af4:	c3                   	ret
80103af5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b00 <pinit>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b06:	68 e0 78 10 80       	push   $0x801078e0
80103b0b:	68 20 1d 11 80       	push   $0x80111d20
80103b10:	e8 db 0a 00 00       	call   801045f0 <initlock>
}
80103b15:	83 c4 10             	add    $0x10,%esp
80103b18:	c9                   	leave
80103b19:	c3                   	ret
80103b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b20 <mycpu>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	56                   	push   %esi
80103b24:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b25:	9c                   	pushf
80103b26:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b27:	f6 c4 02             	test   $0x2,%ah
80103b2a:	75 46                	jne    80103b72 <mycpu+0x52>
  apicid = lapicid();
80103b2c:	e8 df ef ff ff       	call   80102b10 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b31:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103b37:	85 f6                	test   %esi,%esi
80103b39:	7e 2a                	jle    80103b65 <mycpu+0x45>
80103b3b:	31 d2                	xor    %edx,%edx
80103b3d:	eb 08                	jmp    80103b47 <mycpu+0x27>
80103b3f:	90                   	nop
80103b40:	83 c2 01             	add    $0x1,%edx
80103b43:	39 f2                	cmp    %esi,%edx
80103b45:	74 1e                	je     80103b65 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103b47:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b4d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103b54:	39 c3                	cmp    %eax,%ebx
80103b56:	75 e8                	jne    80103b40 <mycpu+0x20>
}
80103b58:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b5b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103b61:	5b                   	pop    %ebx
80103b62:	5e                   	pop    %esi
80103b63:	5d                   	pop    %ebp
80103b64:	c3                   	ret
  panic("unknown apicid\n");
80103b65:	83 ec 0c             	sub    $0xc,%esp
80103b68:	68 e7 78 10 80       	push   $0x801078e7
80103b6d:	e8 0e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b72:	83 ec 0c             	sub    $0xc,%esp
80103b75:	68 c4 79 10 80       	push   $0x801079c4
80103b7a:	e8 01 c8 ff ff       	call   80100380 <panic>
80103b7f:	90                   	nop

80103b80 <cpuid>:
cpuid() {
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b86:	e8 95 ff ff ff       	call   80103b20 <mycpu>
}
80103b8b:	c9                   	leave
  return mycpu()-cpus;
80103b8c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103b91:	c1 f8 04             	sar    $0x4,%eax
80103b94:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b9a:	c3                   	ret
80103b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b9f:	90                   	nop

80103ba0 <myproc>:
myproc(void) {
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	53                   	push   %ebx
80103ba4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ba7:	e8 d4 0a 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103bac:	e8 6f ff ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103bb1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bb7:	e8 14 0b 00 00       	call   801046d0 <popcli>
}
80103bbc:	89 d8                	mov    %ebx,%eax
80103bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc1:	c9                   	leave
80103bc2:	c3                   	ret
80103bc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bd0 <userinit>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	53                   	push   %ebx
80103bd4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103bd7:	e8 04 fe ff ff       	call   801039e0 <allocproc>
80103bdc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bde:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
80103be3:	e8 58 34 00 00       	call   80107040 <setupkvm>
80103be8:	89 43 04             	mov    %eax,0x4(%ebx)
80103beb:	85 c0                	test   %eax,%eax
80103bed:	0f 84 bd 00 00 00    	je     80103cb0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bf3:	83 ec 04             	sub    $0x4,%esp
80103bf6:	68 2c 00 00 00       	push   $0x2c
80103bfb:	68 60 a4 10 80       	push   $0x8010a460
80103c00:	50                   	push   %eax
80103c01:	e8 1a 31 00 00       	call   80106d20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c06:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c09:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c0f:	6a 4c                	push   $0x4c
80103c11:	6a 00                	push   $0x0
80103c13:	ff 73 18             	push   0x18(%ebx)
80103c16:	e8 95 0c 00 00       	call   801048b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c1b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c1e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c23:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c26:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c2b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c32:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c36:	8b 43 18             	mov    0x18(%ebx),%eax
80103c39:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c41:	8b 43 18             	mov    0x18(%ebx),%eax
80103c44:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c48:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c4c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c4f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c56:	8b 43 18             	mov    0x18(%ebx),%eax
80103c59:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c60:	8b 43 18             	mov    0x18(%ebx),%eax
80103c63:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c6a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c6d:	6a 10                	push   $0x10
80103c6f:	68 10 79 10 80       	push   $0x80107910
80103c74:	50                   	push   %eax
80103c75:	e8 e6 0d 00 00       	call   80104a60 <safestrcpy>
  p->cwd = namei("/");
80103c7a:	c7 04 24 19 79 10 80 	movl   $0x80107919,(%esp)
80103c81:	e8 2a e6 ff ff       	call   801022b0 <namei>
80103c86:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c89:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c90:	e8 3b 0b 00 00       	call   801047d0 <acquire>
  p->state = RUNNABLE;
80103c95:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c9c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103ca3:	e8 c8 0a 00 00       	call   80104770 <release>
}
80103ca8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cab:	83 c4 10             	add    $0x10,%esp
80103cae:	c9                   	leave
80103caf:	c3                   	ret
    panic("userinit: out of memory?");
80103cb0:	83 ec 0c             	sub    $0xc,%esp
80103cb3:	68 f7 78 10 80       	push   $0x801078f7
80103cb8:	e8 c3 c6 ff ff       	call   80100380 <panic>
80103cbd:	8d 76 00             	lea    0x0(%esi),%esi

80103cc0 <growproc>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	56                   	push   %esi
80103cc4:	53                   	push   %ebx
80103cc5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cc8:	e8 b3 09 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103ccd:	e8 4e fe ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103cd2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cd8:	e8 f3 09 00 00       	call   801046d0 <popcli>
  sz = curproc->sz;
80103cdd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103cdf:	85 f6                	test   %esi,%esi
80103ce1:	7f 1d                	jg     80103d00 <growproc+0x40>
  } else if(n < 0){
80103ce3:	75 3b                	jne    80103d20 <growproc+0x60>
  switchuvm(curproc);
80103ce5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ce8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cea:	53                   	push   %ebx
80103ceb:	e8 20 2f 00 00       	call   80106c10 <switchuvm>
  return 0;
80103cf0:	83 c4 10             	add    $0x10,%esp
80103cf3:	31 c0                	xor    %eax,%eax
}
80103cf5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cf8:	5b                   	pop    %ebx
80103cf9:	5e                   	pop    %esi
80103cfa:	5d                   	pop    %ebp
80103cfb:	c3                   	ret
80103cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d00:	83 ec 04             	sub    $0x4,%esp
80103d03:	01 c6                	add    %eax,%esi
80103d05:	56                   	push   %esi
80103d06:	50                   	push   %eax
80103d07:	ff 73 04             	push   0x4(%ebx)
80103d0a:	e8 61 31 00 00       	call   80106e70 <allocuvm>
80103d0f:	83 c4 10             	add    $0x10,%esp
80103d12:	85 c0                	test   %eax,%eax
80103d14:	75 cf                	jne    80103ce5 <growproc+0x25>
      return -1;
80103d16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d1b:	eb d8                	jmp    80103cf5 <growproc+0x35>
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d20:	83 ec 04             	sub    $0x4,%esp
80103d23:	01 c6                	add    %eax,%esi
80103d25:	56                   	push   %esi
80103d26:	50                   	push   %eax
80103d27:	ff 73 04             	push   0x4(%ebx)
80103d2a:	e8 61 32 00 00       	call   80106f90 <deallocuvm>
80103d2f:	83 c4 10             	add    $0x10,%esp
80103d32:	85 c0                	test   %eax,%eax
80103d34:	75 af                	jne    80103ce5 <growproc+0x25>
80103d36:	eb de                	jmp    80103d16 <growproc+0x56>
80103d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3f:	90                   	nop

80103d40 <fork>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d49:	e8 32 09 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103d4e:	e8 cd fd ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103d53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d59:	e8 72 09 00 00       	call   801046d0 <popcli>
  if((np = allocproc()) == 0){
80103d5e:	e8 7d fc ff ff       	call   801039e0 <allocproc>
80103d63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d66:	85 c0                	test   %eax,%eax
80103d68:	0f 84 d6 00 00 00    	je     80103e44 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d6e:	83 ec 08             	sub    $0x8,%esp
80103d71:	ff 33                	push   (%ebx)
80103d73:	89 c7                	mov    %eax,%edi
80103d75:	ff 73 04             	push   0x4(%ebx)
80103d78:	e8 b3 33 00 00       	call   80107130 <copyuvm>
80103d7d:	83 c4 10             	add    $0x10,%esp
80103d80:	89 47 04             	mov    %eax,0x4(%edi)
80103d83:	85 c0                	test   %eax,%eax
80103d85:	0f 84 9a 00 00 00    	je     80103e25 <fork+0xe5>
  np->sz = curproc->sz;
80103d8b:	8b 03                	mov    (%ebx),%eax
80103d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d90:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d92:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d95:	89 c8                	mov    %ecx,%eax
80103d97:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d9a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d9f:	8b 73 18             	mov    0x18(%ebx),%esi
80103da2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103da4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103da6:	8b 40 18             	mov    0x18(%eax),%eax
80103da9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103db0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103db4:	85 c0                	test   %eax,%eax
80103db6:	74 13                	je     80103dcb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103db8:	83 ec 0c             	sub    $0xc,%esp
80103dbb:	50                   	push   %eax
80103dbc:	e8 2f d1 ff ff       	call   80100ef0 <filedup>
80103dc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dc4:	83 c4 10             	add    $0x10,%esp
80103dc7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dcb:	83 c6 01             	add    $0x1,%esi
80103dce:	83 fe 10             	cmp    $0x10,%esi
80103dd1:	75 dd                	jne    80103db0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103dd3:	83 ec 0c             	sub    $0xc,%esp
80103dd6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dd9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103ddc:	e8 3f da ff ff       	call   80101820 <idup>
80103de1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103de4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103de7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dea:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ded:	6a 10                	push   $0x10
80103def:	53                   	push   %ebx
80103df0:	50                   	push   %eax
80103df1:	e8 6a 0c 00 00       	call   80104a60 <safestrcpy>
  pid = np->pid;
80103df6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103df9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e00:	e8 cb 09 00 00       	call   801047d0 <acquire>
  np->state = RUNNABLE;
80103e05:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103e0c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e13:	e8 58 09 00 00       	call   80104770 <release>
  return pid;
80103e18:	83 c4 10             	add    $0x10,%esp
}
80103e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e1e:	89 d8                	mov    %ebx,%eax
80103e20:	5b                   	pop    %ebx
80103e21:	5e                   	pop    %esi
80103e22:	5f                   	pop    %edi
80103e23:	5d                   	pop    %ebp
80103e24:	c3                   	ret
    kfree(np->kstack);
80103e25:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e28:	83 ec 0c             	sub    $0xc,%esp
80103e2b:	ff 73 08             	push   0x8(%ebx)
80103e2e:	e8 9d e8 ff ff       	call   801026d0 <kfree>
    np->kstack = 0;
80103e33:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e3a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e3d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e44:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e49:	eb d0                	jmp    80103e1b <fork+0xdb>
80103e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e4f:	90                   	nop

80103e50 <scheduler>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	57                   	push   %edi
80103e54:	56                   	push   %esi
80103e55:	53                   	push   %ebx
80103e56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e59:	e8 c2 fc ff ff       	call   80103b20 <mycpu>
  c->proc = 0;
80103e5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e65:	00 00 00 
  struct cpu *c = mycpu();
80103e68:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e6a:	8d 78 04             	lea    0x4(%eax),%edi
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e70:	fb                   	sti
    acquire(&ptable.lock);
80103e71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e74:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103e79:	68 20 1d 11 80       	push   $0x80111d20
80103e7e:	e8 4d 09 00 00       	call   801047d0 <acquire>
80103e83:	83 c4 10             	add    $0x10,%esp
80103e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103e90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e94:	75 33                	jne    80103ec9 <scheduler+0x79>
      switchuvm(p);
80103e96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e9f:	53                   	push   %ebx
80103ea0:	e8 6b 2d 00 00       	call   80106c10 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ea5:	58                   	pop    %eax
80103ea6:	5a                   	pop    %edx
80103ea7:	ff 73 1c             	push   0x1c(%ebx)
80103eaa:	57                   	push   %edi
      p->state = RUNNING;
80103eab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103eb2:	e8 04 0c 00 00       	call   80104abb <swtch>
      switchkvm();
80103eb7:	e8 44 2d 00 00       	call   80106c00 <switchkvm>
      c->proc = 0;
80103ebc:	83 c4 10             	add    $0x10,%esp
80103ebf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ec6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec9:	83 c3 7c             	add    $0x7c,%ebx
80103ecc:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103ed2:	75 bc                	jne    80103e90 <scheduler+0x40>
    release(&ptable.lock);
80103ed4:	83 ec 0c             	sub    $0xc,%esp
80103ed7:	68 20 1d 11 80       	push   $0x80111d20
80103edc:	e8 8f 08 00 00       	call   80104770 <release>
    sti();
80103ee1:	83 c4 10             	add    $0x10,%esp
80103ee4:	eb 8a                	jmp    80103e70 <scheduler+0x20>
80103ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eed:	8d 76 00             	lea    0x0(%esi),%esi

80103ef0 <sched>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
  pushcli();
80103ef5:	e8 86 07 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103efa:	e8 21 fc ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103eff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f05:	e8 c6 07 00 00       	call   801046d0 <popcli>
  if(!holding(&ptable.lock))
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 20 1d 11 80       	push   $0x80111d20
80103f12:	e8 19 08 00 00       	call   80104730 <holding>
80103f17:	83 c4 10             	add    $0x10,%esp
80103f1a:	85 c0                	test   %eax,%eax
80103f1c:	74 4f                	je     80103f6d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f1e:	e8 fd fb ff ff       	call   80103b20 <mycpu>
80103f23:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f2a:	75 68                	jne    80103f94 <sched+0xa4>
  if(p->state == RUNNING)
80103f2c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f30:	74 55                	je     80103f87 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f32:	9c                   	pushf
80103f33:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f34:	f6 c4 02             	test   $0x2,%ah
80103f37:	75 41                	jne    80103f7a <sched+0x8a>
  intena = mycpu()->intena;
80103f39:	e8 e2 fb ff ff       	call   80103b20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f3e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f41:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f47:	e8 d4 fb ff ff       	call   80103b20 <mycpu>
80103f4c:	83 ec 08             	sub    $0x8,%esp
80103f4f:	ff 70 04             	push   0x4(%eax)
80103f52:	53                   	push   %ebx
80103f53:	e8 63 0b 00 00       	call   80104abb <swtch>
  mycpu()->intena = intena;
80103f58:	e8 c3 fb ff ff       	call   80103b20 <mycpu>
}
80103f5d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f60:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f69:	5b                   	pop    %ebx
80103f6a:	5e                   	pop    %esi
80103f6b:	5d                   	pop    %ebp
80103f6c:	c3                   	ret
    panic("sched ptable.lock");
80103f6d:	83 ec 0c             	sub    $0xc,%esp
80103f70:	68 1b 79 10 80       	push   $0x8010791b
80103f75:	e8 06 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	68 47 79 10 80       	push   $0x80107947
80103f82:	e8 f9 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80103f87:	83 ec 0c             	sub    $0xc,%esp
80103f8a:	68 39 79 10 80       	push   $0x80107939
80103f8f:	e8 ec c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103f94:	83 ec 0c             	sub    $0xc,%esp
80103f97:	68 2d 79 10 80       	push   $0x8010792d
80103f9c:	e8 df c3 ff ff       	call   80100380 <panic>
80103fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103faf:	90                   	nop

80103fb0 <exit>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	57                   	push   %edi
80103fb4:	56                   	push   %esi
80103fb5:	53                   	push   %ebx
80103fb6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fb9:	e8 e2 fb ff ff       	call   80103ba0 <myproc>
  if(curproc == initproc)
80103fbe:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103fc4:	0f 84 fd 00 00 00    	je     801040c7 <exit+0x117>
80103fca:	89 c3                	mov    %eax,%ebx
80103fcc:	8d 70 28             	lea    0x28(%eax),%esi
80103fcf:	8d 78 68             	lea    0x68(%eax),%edi
80103fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103fd8:	8b 06                	mov    (%esi),%eax
80103fda:	85 c0                	test   %eax,%eax
80103fdc:	74 12                	je     80103ff0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103fde:	83 ec 0c             	sub    $0xc,%esp
80103fe1:	50                   	push   %eax
80103fe2:	e8 59 cf ff ff       	call   80100f40 <fileclose>
      curproc->ofile[fd] = 0;
80103fe7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103fed:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103ff0:	83 c6 04             	add    $0x4,%esi
80103ff3:	39 f7                	cmp    %esi,%edi
80103ff5:	75 e1                	jne    80103fd8 <exit+0x28>
  begin_op();
80103ff7:	e8 84 ef ff ff       	call   80102f80 <begin_op>
  iput(curproc->cwd);
80103ffc:	83 ec 0c             	sub    $0xc,%esp
80103fff:	ff 73 68             	push   0x68(%ebx)
80104002:	e8 79 d9 ff ff       	call   80101980 <iput>
  end_op();
80104007:	e8 e4 ef ff ff       	call   80102ff0 <end_op>
  curproc->cwd = 0;
8010400c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104013:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010401a:	e8 b1 07 00 00       	call   801047d0 <acquire>
  wakeup1(curproc->parent);
8010401f:	8b 53 14             	mov    0x14(%ebx),%edx
80104022:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104025:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010402a:	eb 0e                	jmp    8010403a <exit+0x8a>
8010402c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104030:	83 c0 7c             	add    $0x7c,%eax
80104033:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104038:	74 1c                	je     80104056 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010403a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010403e:	75 f0                	jne    80104030 <exit+0x80>
80104040:	3b 50 20             	cmp    0x20(%eax),%edx
80104043:	75 eb                	jne    80104030 <exit+0x80>
      p->state = RUNNABLE;
80104045:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010404c:	83 c0 7c             	add    $0x7c,%eax
8010404f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104054:	75 e4                	jne    8010403a <exit+0x8a>
      p->parent = initproc;
80104056:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80104061:	eb 10                	jmp    80104073 <exit+0xc3>
80104063:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104067:	90                   	nop
80104068:	83 c2 7c             	add    $0x7c,%edx
8010406b:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80104071:	74 3b                	je     801040ae <exit+0xfe>
    if(p->parent == curproc){
80104073:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104076:	75 f0                	jne    80104068 <exit+0xb8>
      if(p->state == ZOMBIE)
80104078:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010407c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010407f:	75 e7                	jne    80104068 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104081:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80104086:	eb 12                	jmp    8010409a <exit+0xea>
80104088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408f:	90                   	nop
80104090:	83 c0 7c             	add    $0x7c,%eax
80104093:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104098:	74 ce                	je     80104068 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010409a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010409e:	75 f0                	jne    80104090 <exit+0xe0>
801040a0:	3b 48 20             	cmp    0x20(%eax),%ecx
801040a3:	75 eb                	jne    80104090 <exit+0xe0>
      p->state = RUNNABLE;
801040a5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040ac:	eb e2                	jmp    80104090 <exit+0xe0>
  curproc->state = ZOMBIE;
801040ae:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801040b5:	e8 36 fe ff ff       	call   80103ef0 <sched>
  panic("zombie exit");
801040ba:	83 ec 0c             	sub    $0xc,%esp
801040bd:	68 68 79 10 80       	push   $0x80107968
801040c2:	e8 b9 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
801040c7:	83 ec 0c             	sub    $0xc,%esp
801040ca:	68 5b 79 10 80       	push   $0x8010795b
801040cf:	e8 ac c2 ff ff       	call   80100380 <panic>
801040d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040df:	90                   	nop

801040e0 <wait>:
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	56                   	push   %esi
801040e4:	53                   	push   %ebx
  pushcli();
801040e5:	e8 96 05 00 00       	call   80104680 <pushcli>
  c = mycpu();
801040ea:	e8 31 fa ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801040ef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040f5:	e8 d6 05 00 00       	call   801046d0 <popcli>
  acquire(&ptable.lock);
801040fa:	83 ec 0c             	sub    $0xc,%esp
801040fd:	68 20 1d 11 80       	push   $0x80111d20
80104102:	e8 c9 06 00 00       	call   801047d0 <acquire>
80104107:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010410a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010410c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80104111:	eb 10                	jmp    80104123 <wait+0x43>
80104113:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104117:	90                   	nop
80104118:	83 c3 7c             	add    $0x7c,%ebx
8010411b:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80104121:	74 1b                	je     8010413e <wait+0x5e>
      if(p->parent != curproc)
80104123:	39 73 14             	cmp    %esi,0x14(%ebx)
80104126:	75 f0                	jne    80104118 <wait+0x38>
      if(p->state == ZOMBIE){
80104128:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010412c:	74 62                	je     80104190 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010412e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104131:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104136:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
8010413c:	75 e5                	jne    80104123 <wait+0x43>
    if(!havekids || curproc->killed){
8010413e:	85 c0                	test   %eax,%eax
80104140:	0f 84 a0 00 00 00    	je     801041e6 <wait+0x106>
80104146:	8b 46 24             	mov    0x24(%esi),%eax
80104149:	85 c0                	test   %eax,%eax
8010414b:	0f 85 95 00 00 00    	jne    801041e6 <wait+0x106>
  pushcli();
80104151:	e8 2a 05 00 00       	call   80104680 <pushcli>
  c = mycpu();
80104156:	e8 c5 f9 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
8010415b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104161:	e8 6a 05 00 00       	call   801046d0 <popcli>
  if(p == 0)
80104166:	85 db                	test   %ebx,%ebx
80104168:	0f 84 8f 00 00 00    	je     801041fd <wait+0x11d>
  p->chan = chan;
8010416e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104171:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104178:	e8 73 fd ff ff       	call   80103ef0 <sched>
  p->chan = 0;
8010417d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104184:	eb 84                	jmp    8010410a <wait+0x2a>
80104186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010418d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104190:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104193:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104196:	ff 73 08             	push   0x8(%ebx)
80104199:	e8 32 e5 ff ff       	call   801026d0 <kfree>
        p->kstack = 0;
8010419e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801041a5:	5a                   	pop    %edx
801041a6:	ff 73 04             	push   0x4(%ebx)
801041a9:	e8 12 2e 00 00       	call   80106fc0 <freevm>
        p->pid = 0;
801041ae:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041b5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041bc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041c0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041ce:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801041d5:	e8 96 05 00 00       	call   80104770 <release>
        return pid;
801041da:	83 c4 10             	add    $0x10,%esp
}
801041dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041e0:	89 f0                	mov    %esi,%eax
801041e2:	5b                   	pop    %ebx
801041e3:	5e                   	pop    %esi
801041e4:	5d                   	pop    %ebp
801041e5:	c3                   	ret
      release(&ptable.lock);
801041e6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041e9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041ee:	68 20 1d 11 80       	push   $0x80111d20
801041f3:	e8 78 05 00 00       	call   80104770 <release>
      return -1;
801041f8:	83 c4 10             	add    $0x10,%esp
801041fb:	eb e0                	jmp    801041dd <wait+0xfd>
    panic("sleep");
801041fd:	83 ec 0c             	sub    $0xc,%esp
80104200:	68 74 79 10 80       	push   $0x80107974
80104205:	e8 76 c1 ff ff       	call   80100380 <panic>
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104210 <yield>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
80104214:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104217:	68 20 1d 11 80       	push   $0x80111d20
8010421c:	e8 af 05 00 00       	call   801047d0 <acquire>
  pushcli();
80104221:	e8 5a 04 00 00       	call   80104680 <pushcli>
  c = mycpu();
80104226:	e8 f5 f8 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
8010422b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104231:	e8 9a 04 00 00       	call   801046d0 <popcli>
  myproc()->state = RUNNABLE;
80104236:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010423d:	e8 ae fc ff ff       	call   80103ef0 <sched>
  release(&ptable.lock);
80104242:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104249:	e8 22 05 00 00       	call   80104770 <release>
}
8010424e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104251:	83 c4 10             	add    $0x10,%esp
80104254:	c9                   	leave
80104255:	c3                   	ret
80104256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425d:	8d 76 00             	lea    0x0(%esi),%esi

80104260 <sleep>:
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	57                   	push   %edi
80104264:	56                   	push   %esi
80104265:	53                   	push   %ebx
80104266:	83 ec 0c             	sub    $0xc,%esp
80104269:	8b 7d 08             	mov    0x8(%ebp),%edi
8010426c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010426f:	e8 0c 04 00 00       	call   80104680 <pushcli>
  c = mycpu();
80104274:	e8 a7 f8 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80104279:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010427f:	e8 4c 04 00 00       	call   801046d0 <popcli>
  if(p == 0)
80104284:	85 db                	test   %ebx,%ebx
80104286:	0f 84 87 00 00 00    	je     80104313 <sleep+0xb3>
  if(lk == 0)
8010428c:	85 f6                	test   %esi,%esi
8010428e:	74 76                	je     80104306 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104290:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80104296:	74 50                	je     801042e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104298:	83 ec 0c             	sub    $0xc,%esp
8010429b:	68 20 1d 11 80       	push   $0x80111d20
801042a0:	e8 2b 05 00 00       	call   801047d0 <acquire>
    release(lk);
801042a5:	89 34 24             	mov    %esi,(%esp)
801042a8:	e8 c3 04 00 00       	call   80104770 <release>
  p->chan = chan;
801042ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042b7:	e8 34 fc ff ff       	call   80103ef0 <sched>
  p->chan = 0;
801042bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042c3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801042ca:	e8 a1 04 00 00       	call   80104770 <release>
    acquire(lk);
801042cf:	89 75 08             	mov    %esi,0x8(%ebp)
801042d2:	83 c4 10             	add    $0x10,%esp
}
801042d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042d8:	5b                   	pop    %ebx
801042d9:	5e                   	pop    %esi
801042da:	5f                   	pop    %edi
801042db:	5d                   	pop    %ebp
    acquire(lk);
801042dc:	e9 ef 04 00 00       	jmp    801047d0 <acquire>
801042e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042f2:	e8 f9 fb ff ff       	call   80103ef0 <sched>
  p->chan = 0;
801042f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104301:	5b                   	pop    %ebx
80104302:	5e                   	pop    %esi
80104303:	5f                   	pop    %edi
80104304:	5d                   	pop    %ebp
80104305:	c3                   	ret
    panic("sleep without lk");
80104306:	83 ec 0c             	sub    $0xc,%esp
80104309:	68 7a 79 10 80       	push   $0x8010797a
8010430e:	e8 6d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
80104313:	83 ec 0c             	sub    $0xc,%esp
80104316:	68 74 79 10 80       	push   $0x80107974
8010431b:	e8 60 c0 ff ff       	call   80100380 <panic>

80104320 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	53                   	push   %ebx
80104324:	83 ec 10             	sub    $0x10,%esp
80104327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010432a:	68 20 1d 11 80       	push   $0x80111d20
8010432f:	e8 9c 04 00 00       	call   801047d0 <acquire>
80104334:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104337:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010433c:	eb 0c                	jmp    8010434a <wakeup+0x2a>
8010433e:	66 90                	xchg   %ax,%ax
80104340:	83 c0 7c             	add    $0x7c,%eax
80104343:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104348:	74 1c                	je     80104366 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010434a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010434e:	75 f0                	jne    80104340 <wakeup+0x20>
80104350:	3b 58 20             	cmp    0x20(%eax),%ebx
80104353:	75 eb                	jne    80104340 <wakeup+0x20>
      p->state = RUNNABLE;
80104355:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010435c:	83 c0 7c             	add    $0x7c,%eax
8010435f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104364:	75 e4                	jne    8010434a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104366:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010436d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104370:	c9                   	leave
  release(&ptable.lock);
80104371:	e9 fa 03 00 00       	jmp    80104770 <release>
80104376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437d:	8d 76 00             	lea    0x0(%esi),%esi

80104380 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	83 ec 10             	sub    $0x10,%esp
80104387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010438a:	68 20 1d 11 80       	push   $0x80111d20
8010438f:	e8 3c 04 00 00       	call   801047d0 <acquire>
80104394:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104397:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010439c:	eb 0c                	jmp    801043aa <kill+0x2a>
8010439e:	66 90                	xchg   %ax,%ax
801043a0:	83 c0 7c             	add    $0x7c,%eax
801043a3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801043a8:	74 36                	je     801043e0 <kill+0x60>
    if(p->pid == pid){
801043aa:	39 58 10             	cmp    %ebx,0x10(%eax)
801043ad:	75 f1                	jne    801043a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043af:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043b3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043ba:	75 07                	jne    801043c3 <kill+0x43>
        p->state = RUNNABLE;
801043bc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043c3:	83 ec 0c             	sub    $0xc,%esp
801043c6:	68 20 1d 11 80       	push   $0x80111d20
801043cb:	e8 a0 03 00 00       	call   80104770 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043d3:	83 c4 10             	add    $0x10,%esp
801043d6:	31 c0                	xor    %eax,%eax
}
801043d8:	c9                   	leave
801043d9:	c3                   	ret
801043da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043e0:	83 ec 0c             	sub    $0xc,%esp
801043e3:	68 20 1d 11 80       	push   $0x80111d20
801043e8:	e8 83 03 00 00       	call   80104770 <release>
}
801043ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043f0:	83 c4 10             	add    $0x10,%esp
801043f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043f8:	c9                   	leave
801043f9:	c3                   	ret
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	57                   	push   %edi
80104404:	56                   	push   %esi
80104405:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104408:	53                   	push   %ebx
80104409:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010440e:	83 ec 3c             	sub    $0x3c,%esp
80104411:	eb 24                	jmp    80104437 <procdump+0x37>
80104413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104417:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104418:	83 ec 0c             	sub    $0xc,%esp
8010441b:	68 f7 7c 10 80       	push   $0x80107cf7
80104420:	e8 8b c2 ff ff       	call   801006b0 <cprintf>
80104425:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104428:	83 c3 7c             	add    $0x7c,%ebx
8010442b:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80104431:	0f 84 81 00 00 00    	je     801044b8 <procdump+0xb8>
    if(p->state == UNUSED)
80104437:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010443a:	85 c0                	test   %eax,%eax
8010443c:	74 ea                	je     80104428 <procdump+0x28>
      state = "???";
8010443e:	ba 8b 79 10 80       	mov    $0x8010798b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104443:	83 f8 05             	cmp    $0x5,%eax
80104446:	77 11                	ja     80104459 <procdump+0x59>
80104448:	8b 14 85 ec 79 10 80 	mov    -0x7fef8614(,%eax,4),%edx
      state = "???";
8010444f:	b8 8b 79 10 80       	mov    $0x8010798b,%eax
80104454:	85 d2                	test   %edx,%edx
80104456:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104459:	53                   	push   %ebx
8010445a:	52                   	push   %edx
8010445b:	ff 73 a4             	push   -0x5c(%ebx)
8010445e:	68 8f 79 10 80       	push   $0x8010798f
80104463:	e8 48 c2 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104468:	83 c4 10             	add    $0x10,%esp
8010446b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010446f:	75 a7                	jne    80104418 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104471:	83 ec 08             	sub    $0x8,%esp
80104474:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104477:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010447a:	50                   	push   %eax
8010447b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010447e:	8b 40 0c             	mov    0xc(%eax),%eax
80104481:	83 c0 08             	add    $0x8,%eax
80104484:	50                   	push   %eax
80104485:	e8 86 01 00 00       	call   80104610 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010448a:	83 c4 10             	add    $0x10,%esp
8010448d:	8d 76 00             	lea    0x0(%esi),%esi
80104490:	8b 17                	mov    (%edi),%edx
80104492:	85 d2                	test   %edx,%edx
80104494:	74 82                	je     80104418 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104496:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104499:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010449c:	52                   	push   %edx
8010449d:	68 e1 73 10 80       	push   $0x801073e1
801044a2:	e8 09 c2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044a7:	83 c4 10             	add    $0x10,%esp
801044aa:	39 f7                	cmp    %esi,%edi
801044ac:	75 e2                	jne    80104490 <procdump+0x90>
801044ae:	e9 65 ff ff ff       	jmp    80104418 <procdump+0x18>
801044b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044b7:	90                   	nop
  }
}
801044b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044bb:	5b                   	pop    %ebx
801044bc:	5e                   	pop    %esi
801044bd:	5f                   	pop    %edi
801044be:	5d                   	pop    %ebp
801044bf:	c3                   	ret

801044c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 0c             	sub    $0xc,%esp
801044c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044ca:	68 04 7a 10 80       	push   $0x80107a04
801044cf:	8d 43 04             	lea    0x4(%ebx),%eax
801044d2:	50                   	push   %eax
801044d3:	e8 18 01 00 00       	call   801045f0 <initlock>
  lk->name = name;
801044d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044e1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044eb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f1:	c9                   	leave
801044f2:	c3                   	ret
801044f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104500 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
80104505:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104508:	8d 73 04             	lea    0x4(%ebx),%esi
8010450b:	83 ec 0c             	sub    $0xc,%esp
8010450e:	56                   	push   %esi
8010450f:	e8 bc 02 00 00       	call   801047d0 <acquire>
  while (lk->locked) {
80104514:	8b 13                	mov    (%ebx),%edx
80104516:	83 c4 10             	add    $0x10,%esp
80104519:	85 d2                	test   %edx,%edx
8010451b:	74 16                	je     80104533 <acquiresleep+0x33>
8010451d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104520:	83 ec 08             	sub    $0x8,%esp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
80104525:	e8 36 fd ff ff       	call   80104260 <sleep>
  while (lk->locked) {
8010452a:	8b 03                	mov    (%ebx),%eax
8010452c:	83 c4 10             	add    $0x10,%esp
8010452f:	85 c0                	test   %eax,%eax
80104531:	75 ed                	jne    80104520 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104533:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104539:	e8 62 f6 ff ff       	call   80103ba0 <myproc>
8010453e:	8b 40 10             	mov    0x10(%eax),%eax
80104541:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104544:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104547:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010454a:	5b                   	pop    %ebx
8010454b:	5e                   	pop    %esi
8010454c:	5d                   	pop    %ebp
  release(&lk->lk);
8010454d:	e9 1e 02 00 00       	jmp    80104770 <release>
80104552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104560 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
80104565:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104568:	8d 73 04             	lea    0x4(%ebx),%esi
8010456b:	83 ec 0c             	sub    $0xc,%esp
8010456e:	56                   	push   %esi
8010456f:	e8 5c 02 00 00       	call   801047d0 <acquire>
  lk->locked = 0;
80104574:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010457a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104581:	89 1c 24             	mov    %ebx,(%esp)
80104584:	e8 97 fd ff ff       	call   80104320 <wakeup>
  release(&lk->lk);
80104589:	89 75 08             	mov    %esi,0x8(%ebp)
8010458c:	83 c4 10             	add    $0x10,%esp
}
8010458f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104592:	5b                   	pop    %ebx
80104593:	5e                   	pop    %esi
80104594:	5d                   	pop    %ebp
  release(&lk->lk);
80104595:	e9 d6 01 00 00       	jmp    80104770 <release>
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	31 ff                	xor    %edi,%edi
801045a6:	56                   	push   %esi
801045a7:	53                   	push   %ebx
801045a8:	83 ec 18             	sub    $0x18,%esp
801045ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045ae:	8d 73 04             	lea    0x4(%ebx),%esi
801045b1:	56                   	push   %esi
801045b2:	e8 19 02 00 00       	call   801047d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045b7:	8b 03                	mov    (%ebx),%eax
801045b9:	83 c4 10             	add    $0x10,%esp
801045bc:	85 c0                	test   %eax,%eax
801045be:	75 18                	jne    801045d8 <holdingsleep+0x38>
  release(&lk->lk);
801045c0:	83 ec 0c             	sub    $0xc,%esp
801045c3:	56                   	push   %esi
801045c4:	e8 a7 01 00 00       	call   80104770 <release>
  return r;
}
801045c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045cc:	89 f8                	mov    %edi,%eax
801045ce:	5b                   	pop    %ebx
801045cf:	5e                   	pop    %esi
801045d0:	5f                   	pop    %edi
801045d1:	5d                   	pop    %ebp
801045d2:	c3                   	ret
801045d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045d7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801045d8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045db:	e8 c0 f5 ff ff       	call   80103ba0 <myproc>
801045e0:	39 58 10             	cmp    %ebx,0x10(%eax)
801045e3:	0f 94 c0             	sete   %al
801045e6:	0f b6 c0             	movzbl %al,%eax
801045e9:	89 c7                	mov    %eax,%edi
801045eb:	eb d3                	jmp    801045c0 <holdingsleep+0x20>
801045ed:	66 90                	xchg   %ax,%ax
801045ef:	90                   	nop

801045f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104602:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104609:	5d                   	pop    %ebp
8010460a:	c3                   	ret
8010460b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010460f:	90                   	nop

80104610 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	8b 45 08             	mov    0x8(%ebp),%eax
80104617:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010461a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010461d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104622:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104627:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010462c:	76 10                	jbe    8010463e <getcallerpcs+0x2e>
8010462e:	eb 28                	jmp    80104658 <getcallerpcs+0x48>
80104630:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104636:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010463c:	77 1a                	ja     80104658 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010463e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104641:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104644:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104647:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104649:	83 f8 0a             	cmp    $0xa,%eax
8010464c:	75 e2                	jne    80104630 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010464e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104651:	c9                   	leave
80104652:	c3                   	ret
80104653:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104657:	90                   	nop
80104658:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010465b:	8d 51 28             	lea    0x28(%ecx),%edx
8010465e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104666:	83 c0 04             	add    $0x4,%eax
80104669:	39 d0                	cmp    %edx,%eax
8010466b:	75 f3                	jne    80104660 <getcallerpcs+0x50>
}
8010466d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104670:	c9                   	leave
80104671:	c3                   	ret
80104672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104680 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	53                   	push   %ebx
80104684:	83 ec 04             	sub    $0x4,%esp
80104687:	9c                   	pushf
80104688:	5b                   	pop    %ebx
  asm volatile("cli");
80104689:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010468a:	e8 91 f4 ff ff       	call   80103b20 <mycpu>
8010468f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104695:	85 c0                	test   %eax,%eax
80104697:	74 17                	je     801046b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104699:	e8 82 f4 ff ff       	call   80103b20 <mycpu>
8010469e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a8:	c9                   	leave
801046a9:	c3                   	ret
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801046b0:	e8 6b f4 ff ff       	call   80103b20 <mycpu>
801046b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801046c1:	eb d6                	jmp    80104699 <pushcli+0x19>
801046c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046d0 <popcli>:

void
popcli(void)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046d6:	9c                   	pushf
801046d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046d8:	f6 c4 02             	test   $0x2,%ah
801046db:	75 35                	jne    80104712 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046dd:	e8 3e f4 ff ff       	call   80103b20 <mycpu>
801046e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046e9:	78 34                	js     8010471f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046eb:	e8 30 f4 ff ff       	call   80103b20 <mycpu>
801046f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046f6:	85 d2                	test   %edx,%edx
801046f8:	74 06                	je     80104700 <popcli+0x30>
    sti();
}
801046fa:	c9                   	leave
801046fb:	c3                   	ret
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104700:	e8 1b f4 ff ff       	call   80103b20 <mycpu>
80104705:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010470b:	85 c0                	test   %eax,%eax
8010470d:	74 eb                	je     801046fa <popcli+0x2a>
  asm volatile("sti");
8010470f:	fb                   	sti
}
80104710:	c9                   	leave
80104711:	c3                   	ret
    panic("popcli - interruptible");
80104712:	83 ec 0c             	sub    $0xc,%esp
80104715:	68 0f 7a 10 80       	push   $0x80107a0f
8010471a:	e8 61 bc ff ff       	call   80100380 <panic>
    panic("popcli");
8010471f:	83 ec 0c             	sub    $0xc,%esp
80104722:	68 26 7a 10 80       	push   $0x80107a26
80104727:	e8 54 bc ff ff       	call   80100380 <panic>
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104730 <holding>:
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
80104735:	8b 75 08             	mov    0x8(%ebp),%esi
80104738:	31 db                	xor    %ebx,%ebx
  pushcli();
8010473a:	e8 41 ff ff ff       	call   80104680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010473f:	8b 06                	mov    (%esi),%eax
80104741:	85 c0                	test   %eax,%eax
80104743:	75 0b                	jne    80104750 <holding+0x20>
  popcli();
80104745:	e8 86 ff ff ff       	call   801046d0 <popcli>
}
8010474a:	89 d8                	mov    %ebx,%eax
8010474c:	5b                   	pop    %ebx
8010474d:	5e                   	pop    %esi
8010474e:	5d                   	pop    %ebp
8010474f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104750:	8b 5e 08             	mov    0x8(%esi),%ebx
80104753:	e8 c8 f3 ff ff       	call   80103b20 <mycpu>
80104758:	39 c3                	cmp    %eax,%ebx
8010475a:	0f 94 c3             	sete   %bl
  popcli();
8010475d:	e8 6e ff ff ff       	call   801046d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104762:	0f b6 db             	movzbl %bl,%ebx
}
80104765:	89 d8                	mov    %ebx,%eax
80104767:	5b                   	pop    %ebx
80104768:	5e                   	pop    %esi
80104769:	5d                   	pop    %ebp
8010476a:	c3                   	ret
8010476b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010476f:	90                   	nop

80104770 <release>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104778:	e8 03 ff ff ff       	call   80104680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010477d:	8b 03                	mov    (%ebx),%eax
8010477f:	85 c0                	test   %eax,%eax
80104781:	75 15                	jne    80104798 <release+0x28>
  popcli();
80104783:	e8 48 ff ff ff       	call   801046d0 <popcli>
    panic("release");
80104788:	83 ec 0c             	sub    $0xc,%esp
8010478b:	68 2d 7a 10 80       	push   $0x80107a2d
80104790:	e8 eb bb ff ff       	call   80100380 <panic>
80104795:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104798:	8b 73 08             	mov    0x8(%ebx),%esi
8010479b:	e8 80 f3 ff ff       	call   80103b20 <mycpu>
801047a0:	39 c6                	cmp    %eax,%esi
801047a2:	75 df                	jne    80104783 <release+0x13>
  popcli();
801047a4:	e8 27 ff ff ff       	call   801046d0 <popcli>
  lk->pcs[0] = 0;
801047a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801047b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801047b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047c5:	5b                   	pop    %ebx
801047c6:	5e                   	pop    %esi
801047c7:	5d                   	pop    %ebp
  popcli();
801047c8:	e9 03 ff ff ff       	jmp    801046d0 <popcli>
801047cd:	8d 76 00             	lea    0x0(%esi),%esi

801047d0 <acquire>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
801047d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801047d7:	e8 a4 fe ff ff       	call   80104680 <pushcli>
  if(holding(lk))
801047dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047df:	e8 9c fe ff ff       	call   80104680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047e4:	8b 03                	mov    (%ebx),%eax
801047e6:	85 c0                	test   %eax,%eax
801047e8:	0f 85 9a 00 00 00    	jne    80104888 <acquire+0xb8>
  popcli();
801047ee:	e8 dd fe ff ff       	call   801046d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801047f3:	b9 01 00 00 00       	mov    $0x1,%ecx
801047f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ff:	90                   	nop
  while(xchg(&lk->locked, 1) != 0)
80104800:	8b 55 08             	mov    0x8(%ebp),%edx
80104803:	89 c8                	mov    %ecx,%eax
80104805:	f0 87 02             	lock xchg %eax,(%edx)
80104808:	85 c0                	test   %eax,%eax
8010480a:	75 f4                	jne    80104800 <acquire+0x30>
  __sync_synchronize();
8010480c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104811:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104814:	e8 07 f3 ff ff       	call   80103b20 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104819:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010481c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010481e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104821:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104827:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010482c:	77 32                	ja     80104860 <acquire+0x90>
  ebp = (uint*)v - 2;
8010482e:	89 e8                	mov    %ebp,%eax
80104830:	eb 14                	jmp    80104846 <acquire+0x76>
80104832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104838:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010483e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104844:	77 1a                	ja     80104860 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104846:	8b 58 04             	mov    0x4(%eax),%ebx
80104849:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010484d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104850:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104852:	83 fa 0a             	cmp    $0xa,%edx
80104855:	75 e1                	jne    80104838 <acquire+0x68>
}
80104857:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010485a:	c9                   	leave
8010485b:	c3                   	ret
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104860:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104864:	8d 51 34             	lea    0x34(%ecx),%edx
80104867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010486e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104870:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104876:	83 c0 04             	add    $0x4,%eax
80104879:	39 c2                	cmp    %eax,%edx
8010487b:	75 f3                	jne    80104870 <acquire+0xa0>
}
8010487d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104880:	c9                   	leave
80104881:	c3                   	ret
80104882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104888:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010488b:	e8 90 f2 ff ff       	call   80103b20 <mycpu>
80104890:	39 c3                	cmp    %eax,%ebx
80104892:	0f 85 56 ff ff ff    	jne    801047ee <acquire+0x1e>
  popcli();
80104898:	e8 33 fe ff ff       	call   801046d0 <popcli>
    panic("acquire");
8010489d:	83 ec 0c             	sub    $0xc,%esp
801048a0:	68 35 7a 10 80       	push   $0x80107a35
801048a5:	e8 d6 ba ff ff       	call   80100380 <panic>
801048aa:	66 90                	xchg   %ax,%ax
801048ac:	66 90                	xchg   %ax,%ax
801048ae:	66 90                	xchg   %ax,%ax

801048b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	8b 55 08             	mov    0x8(%ebp),%edx
801048b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801048ba:	89 d0                	mov    %edx,%eax
801048bc:	09 c8                	or     %ecx,%eax
801048be:	a8 03                	test   $0x3,%al
801048c0:	75 1e                	jne    801048e0 <memset+0x30>
    c &= 0xFF;
801048c2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801048c6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
801048c9:	89 d7                	mov    %edx,%edi
801048cb:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801048d1:	fc                   	cld
801048d2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801048d4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801048d7:	89 d0                	mov    %edx,%eax
801048d9:	c9                   	leave
801048da:	c3                   	ret
801048db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048df:	90                   	nop
  asm volatile("cld; rep stosb" :
801048e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801048e3:	89 d7                	mov    %edx,%edi
801048e5:	fc                   	cld
801048e6:	f3 aa                	rep stos %al,%es:(%edi)
801048e8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801048eb:	89 d0                	mov    %edx,%eax
801048ed:	c9                   	leave
801048ee:	c3                   	ret
801048ef:	90                   	nop

801048f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	8b 75 10             	mov    0x10(%ebp),%esi
801048f7:	8b 55 08             	mov    0x8(%ebp),%edx
801048fa:	53                   	push   %ebx
801048fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048fe:	85 f6                	test   %esi,%esi
80104900:	74 2e                	je     80104930 <memcmp+0x40>
80104902:	01 c6                	add    %eax,%esi
80104904:	eb 14                	jmp    8010491a <memcmp+0x2a>
80104906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104910:	83 c0 01             	add    $0x1,%eax
80104913:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104916:	39 f0                	cmp    %esi,%eax
80104918:	74 16                	je     80104930 <memcmp+0x40>
    if(*s1 != *s2)
8010491a:	0f b6 0a             	movzbl (%edx),%ecx
8010491d:	0f b6 18             	movzbl (%eax),%ebx
80104920:	38 d9                	cmp    %bl,%cl
80104922:	74 ec                	je     80104910 <memcmp+0x20>
      return *s1 - *s2;
80104924:	0f b6 c1             	movzbl %cl,%eax
80104927:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104929:	5b                   	pop    %ebx
8010492a:	5e                   	pop    %esi
8010492b:	5d                   	pop    %ebp
8010492c:	c3                   	ret
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
80104930:	5b                   	pop    %ebx
  return 0;
80104931:	31 c0                	xor    %eax,%eax
}
80104933:	5e                   	pop    %esi
80104934:	5d                   	pop    %ebp
80104935:	c3                   	ret
80104936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493d:	8d 76 00             	lea    0x0(%esi),%esi

80104940 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	8b 55 08             	mov    0x8(%ebp),%edx
80104947:	8b 45 10             	mov    0x10(%ebp),%eax
8010494a:	56                   	push   %esi
8010494b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010494e:	39 d6                	cmp    %edx,%esi
80104950:	73 26                	jae    80104978 <memmove+0x38>
80104952:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104955:	39 ca                	cmp    %ecx,%edx
80104957:	73 1f                	jae    80104978 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104959:	85 c0                	test   %eax,%eax
8010495b:	74 0f                	je     8010496c <memmove+0x2c>
8010495d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104960:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104964:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104967:	83 e8 01             	sub    $0x1,%eax
8010496a:	73 f4                	jae    80104960 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010496c:	5e                   	pop    %esi
8010496d:	89 d0                	mov    %edx,%eax
8010496f:	5f                   	pop    %edi
80104970:	5d                   	pop    %ebp
80104971:	c3                   	ret
80104972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104978:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010497b:	89 d7                	mov    %edx,%edi
8010497d:	85 c0                	test   %eax,%eax
8010497f:	74 eb                	je     8010496c <memmove+0x2c>
80104981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104988:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104989:	39 ce                	cmp    %ecx,%esi
8010498b:	75 fb                	jne    80104988 <memmove+0x48>
}
8010498d:	5e                   	pop    %esi
8010498e:	89 d0                	mov    %edx,%eax
80104990:	5f                   	pop    %edi
80104991:	5d                   	pop    %ebp
80104992:	c3                   	ret
80104993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801049a0:	eb 9e                	jmp    80104940 <memmove>
801049a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	53                   	push   %ebx
801049b4:	8b 55 10             	mov    0x10(%ebp),%edx
801049b7:	8b 45 08             	mov    0x8(%ebp),%eax
801049ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801049bd:	85 d2                	test   %edx,%edx
801049bf:	75 16                	jne    801049d7 <strncmp+0x27>
801049c1:	eb 2d                	jmp    801049f0 <strncmp+0x40>
801049c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049c7:	90                   	nop
801049c8:	3a 19                	cmp    (%ecx),%bl
801049ca:	75 12                	jne    801049de <strncmp+0x2e>
    n--, p++, q++;
801049cc:	83 c0 01             	add    $0x1,%eax
801049cf:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049d2:	83 ea 01             	sub    $0x1,%edx
801049d5:	74 19                	je     801049f0 <strncmp+0x40>
801049d7:	0f b6 18             	movzbl (%eax),%ebx
801049da:	84 db                	test   %bl,%bl
801049dc:	75 ea                	jne    801049c8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049de:	0f b6 00             	movzbl (%eax),%eax
801049e1:	0f b6 11             	movzbl (%ecx),%edx
}
801049e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049e7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801049e8:	29 d0                	sub    %edx,%eax
}
801049ea:	c3                   	ret
801049eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049ef:	90                   	nop
801049f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801049f3:	31 c0                	xor    %eax,%eax
}
801049f5:	c9                   	leave
801049f6:	c3                   	ret
801049f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	57                   	push   %edi
80104a04:	56                   	push   %esi
80104a05:	8b 75 08             	mov    0x8(%ebp),%esi
80104a08:	53                   	push   %ebx
80104a09:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a0c:	89 f0                	mov    %esi,%eax
80104a0e:	eb 15                	jmp    80104a25 <strncpy+0x25>
80104a10:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a14:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a17:	83 c0 01             	add    $0x1,%eax
80104a1a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104a1e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104a21:	84 c9                	test   %cl,%cl
80104a23:	74 13                	je     80104a38 <strncpy+0x38>
80104a25:	89 d3                	mov    %edx,%ebx
80104a27:	83 ea 01             	sub    $0x1,%edx
80104a2a:	85 db                	test   %ebx,%ebx
80104a2c:	7f e2                	jg     80104a10 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104a2e:	5b                   	pop    %ebx
80104a2f:	89 f0                	mov    %esi,%eax
80104a31:	5e                   	pop    %esi
80104a32:	5f                   	pop    %edi
80104a33:	5d                   	pop    %ebp
80104a34:	c3                   	ret
80104a35:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104a38:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104a3b:	83 e9 01             	sub    $0x1,%ecx
80104a3e:	85 d2                	test   %edx,%edx
80104a40:	74 ec                	je     80104a2e <strncpy+0x2e>
80104a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104a48:	83 c0 01             	add    $0x1,%eax
80104a4b:	89 ca                	mov    %ecx,%edx
80104a4d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104a51:	29 c2                	sub    %eax,%edx
80104a53:	85 d2                	test   %edx,%edx
80104a55:	7f f1                	jg     80104a48 <strncpy+0x48>
}
80104a57:	5b                   	pop    %ebx
80104a58:	89 f0                	mov    %esi,%eax
80104a5a:	5e                   	pop    %esi
80104a5b:	5f                   	pop    %edi
80104a5c:	5d                   	pop    %ebp
80104a5d:	c3                   	ret
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	8b 55 10             	mov    0x10(%ebp),%edx
80104a67:	8b 75 08             	mov    0x8(%ebp),%esi
80104a6a:	53                   	push   %ebx
80104a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a6e:	85 d2                	test   %edx,%edx
80104a70:	7e 25                	jle    80104a97 <safestrcpy+0x37>
80104a72:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a76:	89 f2                	mov    %esi,%edx
80104a78:	eb 16                	jmp    80104a90 <safestrcpy+0x30>
80104a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a80:	0f b6 08             	movzbl (%eax),%ecx
80104a83:	83 c0 01             	add    $0x1,%eax
80104a86:	83 c2 01             	add    $0x1,%edx
80104a89:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a8c:	84 c9                	test   %cl,%cl
80104a8e:	74 04                	je     80104a94 <safestrcpy+0x34>
80104a90:	39 d8                	cmp    %ebx,%eax
80104a92:	75 ec                	jne    80104a80 <safestrcpy+0x20>
    ;
  *s = 0;
80104a94:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a97:	89 f0                	mov    %esi,%eax
80104a99:	5b                   	pop    %ebx
80104a9a:	5e                   	pop    %esi
80104a9b:	5d                   	pop    %ebp
80104a9c:	c3                   	ret
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi

80104aa0 <strlen>:

int
strlen(const char *s)
{
80104aa0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104aa1:	31 c0                	xor    %eax,%eax
{
80104aa3:	89 e5                	mov    %esp,%ebp
80104aa5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104aa8:	80 3a 00             	cmpb   $0x0,(%edx)
80104aab:	74 0c                	je     80104ab9 <strlen+0x19>
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
80104ab0:	83 c0 01             	add    $0x1,%eax
80104ab3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ab7:	75 f7                	jne    80104ab0 <strlen+0x10>
    ;
  return n;
}
80104ab9:	5d                   	pop    %ebp
80104aba:	c3                   	ret

80104abb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104abb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104abf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ac3:	55                   	push   %ebp
  pushl %ebx
80104ac4:	53                   	push   %ebx
  pushl %esi
80104ac5:	56                   	push   %esi
  pushl %edi
80104ac6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ac7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ac9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104acb:	5f                   	pop    %edi
  popl %esi
80104acc:	5e                   	pop    %esi
  popl %ebx
80104acd:	5b                   	pop    %ebx
  popl %ebp
80104ace:	5d                   	pop    %ebp
  ret
80104acf:	c3                   	ret

80104ad0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 04             	sub    $0x4,%esp
80104ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104ada:	e8 c1 f0 ff ff       	call   80103ba0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104adf:	8b 00                	mov    (%eax),%eax
80104ae1:	39 c3                	cmp    %eax,%ebx
80104ae3:	73 1b                	jae    80104b00 <fetchint+0x30>
80104ae5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ae8:	39 d0                	cmp    %edx,%eax
80104aea:	72 14                	jb     80104b00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104aec:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aef:	8b 13                	mov    (%ebx),%edx
80104af1:	89 10                	mov    %edx,(%eax)
  return 0;
80104af3:	31 c0                	xor    %eax,%eax
}
80104af5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af8:	c9                   	leave
80104af9:	c3                   	ret
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b05:	eb ee                	jmp    80104af5 <fetchint+0x25>
80104b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 04             	sub    $0x4,%esp
80104b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b1a:	e8 81 f0 ff ff       	call   80103ba0 <myproc>

  if(addr >= curproc->sz)
80104b1f:	3b 18                	cmp    (%eax),%ebx
80104b21:	73 2d                	jae    80104b50 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b23:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b26:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b28:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b2a:	39 d3                	cmp    %edx,%ebx
80104b2c:	73 22                	jae    80104b50 <fetchstr+0x40>
80104b2e:	89 d8                	mov    %ebx,%eax
80104b30:	eb 0d                	jmp    80104b3f <fetchstr+0x2f>
80104b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b38:	83 c0 01             	add    $0x1,%eax
80104b3b:	39 d0                	cmp    %edx,%eax
80104b3d:	73 11                	jae    80104b50 <fetchstr+0x40>
    if(*s == 0)
80104b3f:	80 38 00             	cmpb   $0x0,(%eax)
80104b42:	75 f4                	jne    80104b38 <fetchstr+0x28>
      return s - *pp;
80104b44:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b49:	c9                   	leave
80104b4a:	c3                   	ret
80104b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b4f:	90                   	nop
80104b50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b58:	c9                   	leave
80104b59:	c3                   	ret
80104b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b60 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b65:	e8 36 f0 ff ff       	call   80103ba0 <myproc>
80104b6a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b6d:	8b 40 18             	mov    0x18(%eax),%eax
80104b70:	8b 40 44             	mov    0x44(%eax),%eax
80104b73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b76:	e8 25 f0 ff ff       	call   80103ba0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b7b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b7e:	8b 00                	mov    (%eax),%eax
80104b80:	39 c6                	cmp    %eax,%esi
80104b82:	73 1c                	jae    80104ba0 <argint+0x40>
80104b84:	8d 53 08             	lea    0x8(%ebx),%edx
80104b87:	39 d0                	cmp    %edx,%eax
80104b89:	72 15                	jb     80104ba0 <argint+0x40>
  *ip = *(int*)(addr);
80104b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b8e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b91:	89 10                	mov    %edx,(%eax)
  return 0;
80104b93:	31 c0                	xor    %eax,%eax
}
80104b95:	5b                   	pop    %ebx
80104b96:	5e                   	pop    %esi
80104b97:	5d                   	pop    %ebp
80104b98:	c3                   	ret
80104b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ba5:	eb ee                	jmp    80104b95 <argint+0x35>
80104ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	53                   	push   %ebx
80104bb6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104bb9:	e8 e2 ef ff ff       	call   80103ba0 <myproc>
80104bbe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bc0:	e8 db ef ff ff       	call   80103ba0 <myproc>
80104bc5:	8b 55 08             	mov    0x8(%ebp),%edx
80104bc8:	8b 40 18             	mov    0x18(%eax),%eax
80104bcb:	8b 40 44             	mov    0x44(%eax),%eax
80104bce:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bd1:	e8 ca ef ff ff       	call   80103ba0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bd9:	8b 00                	mov    (%eax),%eax
80104bdb:	39 c7                	cmp    %eax,%edi
80104bdd:	73 31                	jae    80104c10 <argptr+0x60>
80104bdf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104be2:	39 c8                	cmp    %ecx,%eax
80104be4:	72 2a                	jb     80104c10 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104be6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104be9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bec:	85 d2                	test   %edx,%edx
80104bee:	78 20                	js     80104c10 <argptr+0x60>
80104bf0:	8b 16                	mov    (%esi),%edx
80104bf2:	39 d0                	cmp    %edx,%eax
80104bf4:	73 1a                	jae    80104c10 <argptr+0x60>
80104bf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104bf9:	01 c3                	add    %eax,%ebx
80104bfb:	39 da                	cmp    %ebx,%edx
80104bfd:	72 11                	jb     80104c10 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104bff:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c02:	89 02                	mov    %eax,(%edx)
  return 0;
80104c04:	31 c0                	xor    %eax,%eax
}
80104c06:	83 c4 0c             	add    $0xc,%esp
80104c09:	5b                   	pop    %ebx
80104c0a:	5e                   	pop    %esi
80104c0b:	5f                   	pop    %edi
80104c0c:	5d                   	pop    %ebp
80104c0d:	c3                   	ret
80104c0e:	66 90                	xchg   %ax,%ax
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c15:	eb ef                	jmp    80104c06 <argptr+0x56>
80104c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c25:	e8 76 ef ff ff       	call   80103ba0 <myproc>
80104c2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c2d:	8b 40 18             	mov    0x18(%eax),%eax
80104c30:	8b 40 44             	mov    0x44(%eax),%eax
80104c33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c36:	e8 65 ef ff ff       	call   80103ba0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c3e:	8b 00                	mov    (%eax),%eax
80104c40:	39 c6                	cmp    %eax,%esi
80104c42:	73 44                	jae    80104c88 <argstr+0x68>
80104c44:	8d 53 08             	lea    0x8(%ebx),%edx
80104c47:	39 d0                	cmp    %edx,%eax
80104c49:	72 3d                	jb     80104c88 <argstr+0x68>
  *ip = *(int*)(addr);
80104c4b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c4e:	e8 4d ef ff ff       	call   80103ba0 <myproc>
  if(addr >= curproc->sz)
80104c53:	3b 18                	cmp    (%eax),%ebx
80104c55:	73 31                	jae    80104c88 <argstr+0x68>
  *pp = (char*)addr;
80104c57:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c5a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c5c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c5e:	39 d3                	cmp    %edx,%ebx
80104c60:	73 26                	jae    80104c88 <argstr+0x68>
80104c62:	89 d8                	mov    %ebx,%eax
80104c64:	eb 11                	jmp    80104c77 <argstr+0x57>
80104c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
80104c70:	83 c0 01             	add    $0x1,%eax
80104c73:	39 d0                	cmp    %edx,%eax
80104c75:	73 11                	jae    80104c88 <argstr+0x68>
    if(*s == 0)
80104c77:	80 38 00             	cmpb   $0x0,(%eax)
80104c7a:	75 f4                	jne    80104c70 <argstr+0x50>
      return s - *pp;
80104c7c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c7e:	5b                   	pop    %ebx
80104c7f:	5e                   	pop    %esi
80104c80:	5d                   	pop    %ebp
80104c81:	c3                   	ret
80104c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c88:	5b                   	pop    %ebx
    return -1;
80104c89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c8e:	5e                   	pop    %esi
80104c8f:	5d                   	pop    %ebp
80104c90:	c3                   	ret
80104c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9f:	90                   	nop

80104ca0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	53                   	push   %ebx
80104ca4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ca7:	e8 f4 ee ff ff       	call   80103ba0 <myproc>
80104cac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cae:	8b 40 18             	mov    0x18(%eax),%eax
80104cb1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104cb4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cb7:	83 fa 14             	cmp    $0x14,%edx
80104cba:	77 24                	ja     80104ce0 <syscall+0x40>
80104cbc:	8b 14 85 60 7a 10 80 	mov    -0x7fef85a0(,%eax,4),%edx
80104cc3:	85 d2                	test   %edx,%edx
80104cc5:	74 19                	je     80104ce0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104cc7:	ff d2                	call   *%edx
80104cc9:	89 c2                	mov    %eax,%edx
80104ccb:	8b 43 18             	mov    0x18(%ebx),%eax
80104cce:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104cd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cd4:	c9                   	leave
80104cd5:	c3                   	ret
80104cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ce0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ce1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ce4:	50                   	push   %eax
80104ce5:	ff 73 10             	push   0x10(%ebx)
80104ce8:	68 3d 7a 10 80       	push   $0x80107a3d
80104ced:	e8 be b9 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104cf2:	8b 43 18             	mov    0x18(%ebx),%eax
80104cf5:	83 c4 10             	add    $0x10,%esp
80104cf8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104cff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d02:	c9                   	leave
80104d03:	c3                   	ret
80104d04:	66 90                	xchg   %ax,%ax
80104d06:	66 90                	xchg   %ax,%ax
80104d08:	66 90                	xchg   %ax,%ax
80104d0a:	66 90                	xchg   %ax,%ax
80104d0c:	66 90                	xchg   %ax,%ax
80104d0e:	66 90                	xchg   %ax,%ax

80104d10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	57                   	push   %edi
80104d14:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d15:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d18:	53                   	push   %ebx
80104d19:	83 ec 34             	sub    $0x34,%esp
80104d1c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d22:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d25:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d28:	57                   	push   %edi
80104d29:	50                   	push   %eax
80104d2a:	e8 a1 d5 ff ff       	call   801022d0 <nameiparent>
80104d2f:	83 c4 10             	add    $0x10,%esp
80104d32:	85 c0                	test   %eax,%eax
80104d34:	74 5e                	je     80104d94 <create+0x84>
    return 0;
  ilock(dp);
80104d36:	83 ec 0c             	sub    $0xc,%esp
80104d39:	89 c3                	mov    %eax,%ebx
80104d3b:	50                   	push   %eax
80104d3c:	e8 0f cb ff ff       	call   80101850 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d41:	83 c4 0c             	add    $0xc,%esp
80104d44:	6a 00                	push   $0x0
80104d46:	57                   	push   %edi
80104d47:	53                   	push   %ebx
80104d48:	e8 93 d1 ff ff       	call   80101ee0 <dirlookup>
80104d4d:	83 c4 10             	add    $0x10,%esp
80104d50:	89 c6                	mov    %eax,%esi
80104d52:	85 c0                	test   %eax,%eax
80104d54:	74 4a                	je     80104da0 <create+0x90>
    iunlockput(dp);
80104d56:	83 ec 0c             	sub    $0xc,%esp
80104d59:	53                   	push   %ebx
80104d5a:	e8 51 ce ff ff       	call   80101bb0 <iunlockput>
    ilock(ip);
80104d5f:	89 34 24             	mov    %esi,(%esp)
80104d62:	e8 e9 ca ff ff       	call   80101850 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d67:	83 c4 10             	add    $0x10,%esp
80104d6a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d6f:	75 17                	jne    80104d88 <create+0x78>
80104d71:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d76:	75 10                	jne    80104d88 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d7b:	89 f0                	mov    %esi,%eax
80104d7d:	5b                   	pop    %ebx
80104d7e:	5e                   	pop    %esi
80104d7f:	5f                   	pop    %edi
80104d80:	5d                   	pop    %ebp
80104d81:	c3                   	ret
80104d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d88:	83 ec 0c             	sub    $0xc,%esp
80104d8b:	56                   	push   %esi
80104d8c:	e8 1f ce ff ff       	call   80101bb0 <iunlockput>
    return 0;
80104d91:	83 c4 10             	add    $0x10,%esp
}
80104d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d97:	31 f6                	xor    %esi,%esi
}
80104d99:	5b                   	pop    %ebx
80104d9a:	89 f0                	mov    %esi,%eax
80104d9c:	5e                   	pop    %esi
80104d9d:	5f                   	pop    %edi
80104d9e:	5d                   	pop    %ebp
80104d9f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104da0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104da4:	83 ec 08             	sub    $0x8,%esp
80104da7:	50                   	push   %eax
80104da8:	ff 33                	push   (%ebx)
80104daa:	e8 31 c9 ff ff       	call   801016e0 <ialloc>
80104daf:	83 c4 10             	add    $0x10,%esp
80104db2:	89 c6                	mov    %eax,%esi
80104db4:	85 c0                	test   %eax,%eax
80104db6:	0f 84 bc 00 00 00    	je     80104e78 <create+0x168>
  ilock(ip);
80104dbc:	83 ec 0c             	sub    $0xc,%esp
80104dbf:	50                   	push   %eax
80104dc0:	e8 8b ca ff ff       	call   80101850 <ilock>
  ip->major = major;
80104dc5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104dc9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104dcd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104dd1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104dd5:	b8 01 00 00 00       	mov    $0x1,%eax
80104dda:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104dde:	89 34 24             	mov    %esi,(%esp)
80104de1:	e8 ba c9 ff ff       	call   801017a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104de6:	83 c4 10             	add    $0x10,%esp
80104de9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104dee:	74 30                	je     80104e20 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104df0:	83 ec 04             	sub    $0x4,%esp
80104df3:	ff 76 04             	push   0x4(%esi)
80104df6:	57                   	push   %edi
80104df7:	53                   	push   %ebx
80104df8:	e8 f3 d3 ff ff       	call   801021f0 <dirlink>
80104dfd:	83 c4 10             	add    $0x10,%esp
80104e00:	85 c0                	test   %eax,%eax
80104e02:	78 67                	js     80104e6b <create+0x15b>
  iunlockput(dp);
80104e04:	83 ec 0c             	sub    $0xc,%esp
80104e07:	53                   	push   %ebx
80104e08:	e8 a3 cd ff ff       	call   80101bb0 <iunlockput>
  return ip;
80104e0d:	83 c4 10             	add    $0x10,%esp
}
80104e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e13:	89 f0                	mov    %esi,%eax
80104e15:	5b                   	pop    %ebx
80104e16:	5e                   	pop    %esi
80104e17:	5f                   	pop    %edi
80104e18:	5d                   	pop    %ebp
80104e19:	c3                   	ret
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e20:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e23:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e28:	53                   	push   %ebx
80104e29:	e8 72 c9 ff ff       	call   801017a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e2e:	83 c4 0c             	add    $0xc,%esp
80104e31:	ff 76 04             	push   0x4(%esi)
80104e34:	68 d4 7a 10 80       	push   $0x80107ad4
80104e39:	56                   	push   %esi
80104e3a:	e8 b1 d3 ff ff       	call   801021f0 <dirlink>
80104e3f:	83 c4 10             	add    $0x10,%esp
80104e42:	85 c0                	test   %eax,%eax
80104e44:	78 18                	js     80104e5e <create+0x14e>
80104e46:	83 ec 04             	sub    $0x4,%esp
80104e49:	ff 73 04             	push   0x4(%ebx)
80104e4c:	68 d3 7a 10 80       	push   $0x80107ad3
80104e51:	56                   	push   %esi
80104e52:	e8 99 d3 ff ff       	call   801021f0 <dirlink>
80104e57:	83 c4 10             	add    $0x10,%esp
80104e5a:	85 c0                	test   %eax,%eax
80104e5c:	79 92                	jns    80104df0 <create+0xe0>
      panic("create dots");
80104e5e:	83 ec 0c             	sub    $0xc,%esp
80104e61:	68 c7 7a 10 80       	push   $0x80107ac7
80104e66:	e8 15 b5 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104e6b:	83 ec 0c             	sub    $0xc,%esp
80104e6e:	68 d6 7a 10 80       	push   $0x80107ad6
80104e73:	e8 08 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e78:	83 ec 0c             	sub    $0xc,%esp
80104e7b:	68 b8 7a 10 80       	push   $0x80107ab8
80104e80:	e8 fb b4 ff ff       	call   80100380 <panic>
80104e85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e90 <sys_dup>:
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e95:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e9b:	50                   	push   %eax
80104e9c:	6a 00                	push   $0x0
80104e9e:	e8 bd fc ff ff       	call   80104b60 <argint>
80104ea3:	83 c4 10             	add    $0x10,%esp
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	78 36                	js     80104ee0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eaa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104eae:	77 30                	ja     80104ee0 <sys_dup+0x50>
80104eb0:	e8 eb ec ff ff       	call   80103ba0 <myproc>
80104eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104eb8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ebc:	85 f6                	test   %esi,%esi
80104ebe:	74 20                	je     80104ee0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ec0:	e8 db ec ff ff       	call   80103ba0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ec5:	31 db                	xor    %ebx,%ebx
80104ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ece:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104ed0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ed4:	85 d2                	test   %edx,%edx
80104ed6:	74 18                	je     80104ef0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104ed8:	83 c3 01             	add    $0x1,%ebx
80104edb:	83 fb 10             	cmp    $0x10,%ebx
80104ede:	75 f0                	jne    80104ed0 <sys_dup+0x40>
}
80104ee0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ee3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ee8:	89 d8                	mov    %ebx,%eax
80104eea:	5b                   	pop    %ebx
80104eeb:	5e                   	pop    %esi
80104eec:	5d                   	pop    %ebp
80104eed:	c3                   	ret
80104eee:	66 90                	xchg   %ax,%ax
  filedup(f);
80104ef0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104ef3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ef7:	56                   	push   %esi
80104ef8:	e8 f3 bf ff ff       	call   80100ef0 <filedup>
  return fd;
80104efd:	83 c4 10             	add    $0x10,%esp
}
80104f00:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f03:	89 d8                	mov    %ebx,%eax
80104f05:	5b                   	pop    %ebx
80104f06:	5e                   	pop    %esi
80104f07:	5d                   	pop    %ebp
80104f08:	c3                   	ret
80104f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f10 <sys_read>:
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	56                   	push   %esi
80104f14:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f15:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f18:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f1b:	53                   	push   %ebx
80104f1c:	6a 00                	push   $0x0
80104f1e:	e8 3d fc ff ff       	call   80104b60 <argint>
80104f23:	83 c4 10             	add    $0x10,%esp
80104f26:	85 c0                	test   %eax,%eax
80104f28:	78 5e                	js     80104f88 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f2a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f2e:	77 58                	ja     80104f88 <sys_read+0x78>
80104f30:	e8 6b ec ff ff       	call   80103ba0 <myproc>
80104f35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f38:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f3c:	85 f6                	test   %esi,%esi
80104f3e:	74 48                	je     80104f88 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f40:	83 ec 08             	sub    $0x8,%esp
80104f43:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f46:	50                   	push   %eax
80104f47:	6a 02                	push   $0x2
80104f49:	e8 12 fc ff ff       	call   80104b60 <argint>
80104f4e:	83 c4 10             	add    $0x10,%esp
80104f51:	85 c0                	test   %eax,%eax
80104f53:	78 33                	js     80104f88 <sys_read+0x78>
80104f55:	83 ec 04             	sub    $0x4,%esp
80104f58:	ff 75 f0             	push   -0x10(%ebp)
80104f5b:	53                   	push   %ebx
80104f5c:	6a 01                	push   $0x1
80104f5e:	e8 4d fc ff ff       	call   80104bb0 <argptr>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	85 c0                	test   %eax,%eax
80104f68:	78 1e                	js     80104f88 <sys_read+0x78>
  return fileread(f, p, n);
80104f6a:	83 ec 04             	sub    $0x4,%esp
80104f6d:	ff 75 f0             	push   -0x10(%ebp)
80104f70:	ff 75 f4             	push   -0xc(%ebp)
80104f73:	56                   	push   %esi
80104f74:	e8 f7 c0 ff ff       	call   80101070 <fileread>
80104f79:	83 c4 10             	add    $0x10,%esp
}
80104f7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f7f:	5b                   	pop    %ebx
80104f80:	5e                   	pop    %esi
80104f81:	5d                   	pop    %ebp
80104f82:	c3                   	ret
80104f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f87:	90                   	nop
    return -1;
80104f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f8d:	eb ed                	jmp    80104f7c <sys_read+0x6c>
80104f8f:	90                   	nop

80104f90 <sys_write>:
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f95:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f9b:	53                   	push   %ebx
80104f9c:	6a 00                	push   $0x0
80104f9e:	e8 bd fb ff ff       	call   80104b60 <argint>
80104fa3:	83 c4 10             	add    $0x10,%esp
80104fa6:	85 c0                	test   %eax,%eax
80104fa8:	78 5e                	js     80105008 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104faa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fae:	77 58                	ja     80105008 <sys_write+0x78>
80104fb0:	e8 eb eb ff ff       	call   80103ba0 <myproc>
80104fb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fb8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fbc:	85 f6                	test   %esi,%esi
80104fbe:	74 48                	je     80105008 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fc0:	83 ec 08             	sub    $0x8,%esp
80104fc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fc6:	50                   	push   %eax
80104fc7:	6a 02                	push   $0x2
80104fc9:	e8 92 fb ff ff       	call   80104b60 <argint>
80104fce:	83 c4 10             	add    $0x10,%esp
80104fd1:	85 c0                	test   %eax,%eax
80104fd3:	78 33                	js     80105008 <sys_write+0x78>
80104fd5:	83 ec 04             	sub    $0x4,%esp
80104fd8:	ff 75 f0             	push   -0x10(%ebp)
80104fdb:	53                   	push   %ebx
80104fdc:	6a 01                	push   $0x1
80104fde:	e8 cd fb ff ff       	call   80104bb0 <argptr>
80104fe3:	83 c4 10             	add    $0x10,%esp
80104fe6:	85 c0                	test   %eax,%eax
80104fe8:	78 1e                	js     80105008 <sys_write+0x78>
  return filewrite(f, p, n);
80104fea:	83 ec 04             	sub    $0x4,%esp
80104fed:	ff 75 f0             	push   -0x10(%ebp)
80104ff0:	ff 75 f4             	push   -0xc(%ebp)
80104ff3:	56                   	push   %esi
80104ff4:	e8 07 c1 ff ff       	call   80101100 <filewrite>
80104ff9:	83 c4 10             	add    $0x10,%esp
}
80104ffc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fff:	5b                   	pop    %ebx
80105000:	5e                   	pop    %esi
80105001:	5d                   	pop    %ebp
80105002:	c3                   	ret
80105003:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105007:	90                   	nop
    return -1;
80105008:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010500d:	eb ed                	jmp    80104ffc <sys_write+0x6c>
8010500f:	90                   	nop

80105010 <sys_close>:
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105015:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105018:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010501b:	50                   	push   %eax
8010501c:	6a 00                	push   $0x0
8010501e:	e8 3d fb ff ff       	call   80104b60 <argint>
80105023:	83 c4 10             	add    $0x10,%esp
80105026:	85 c0                	test   %eax,%eax
80105028:	78 3e                	js     80105068 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010502a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010502e:	77 38                	ja     80105068 <sys_close+0x58>
80105030:	e8 6b eb ff ff       	call   80103ba0 <myproc>
80105035:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105038:	8d 5a 08             	lea    0x8(%edx),%ebx
8010503b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010503f:	85 f6                	test   %esi,%esi
80105041:	74 25                	je     80105068 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105043:	e8 58 eb ff ff       	call   80103ba0 <myproc>
  fileclose(f);
80105048:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010504b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105052:	00 
  fileclose(f);
80105053:	56                   	push   %esi
80105054:	e8 e7 be ff ff       	call   80100f40 <fileclose>
  return 0;
80105059:	83 c4 10             	add    $0x10,%esp
8010505c:	31 c0                	xor    %eax,%eax
}
8010505e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105061:	5b                   	pop    %ebx
80105062:	5e                   	pop    %esi
80105063:	5d                   	pop    %ebp
80105064:	c3                   	ret
80105065:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506d:	eb ef                	jmp    8010505e <sys_close+0x4e>
8010506f:	90                   	nop

80105070 <sys_fstat>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105075:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105078:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010507b:	53                   	push   %ebx
8010507c:	6a 00                	push   $0x0
8010507e:	e8 dd fa ff ff       	call   80104b60 <argint>
80105083:	83 c4 10             	add    $0x10,%esp
80105086:	85 c0                	test   %eax,%eax
80105088:	78 46                	js     801050d0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010508a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010508e:	77 40                	ja     801050d0 <sys_fstat+0x60>
80105090:	e8 0b eb ff ff       	call   80103ba0 <myproc>
80105095:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105098:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010509c:	85 f6                	test   %esi,%esi
8010509e:	74 30                	je     801050d0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050a0:	83 ec 04             	sub    $0x4,%esp
801050a3:	6a 14                	push   $0x14
801050a5:	53                   	push   %ebx
801050a6:	6a 01                	push   $0x1
801050a8:	e8 03 fb ff ff       	call   80104bb0 <argptr>
801050ad:	83 c4 10             	add    $0x10,%esp
801050b0:	85 c0                	test   %eax,%eax
801050b2:	78 1c                	js     801050d0 <sys_fstat+0x60>
  return filestat(f, st);
801050b4:	83 ec 08             	sub    $0x8,%esp
801050b7:	ff 75 f4             	push   -0xc(%ebp)
801050ba:	56                   	push   %esi
801050bb:	e8 60 bf ff ff       	call   80101020 <filestat>
801050c0:	83 c4 10             	add    $0x10,%esp
}
801050c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050c6:	5b                   	pop    %ebx
801050c7:	5e                   	pop    %esi
801050c8:	5d                   	pop    %ebp
801050c9:	c3                   	ret
801050ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d5:	eb ec                	jmp    801050c3 <sys_fstat+0x53>
801050d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050de:	66 90                	xchg   %ax,%ax

801050e0 <sys_link>:
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	57                   	push   %edi
801050e4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050e5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050e8:	53                   	push   %ebx
801050e9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050ec:	50                   	push   %eax
801050ed:	6a 00                	push   $0x0
801050ef:	e8 2c fb ff ff       	call   80104c20 <argstr>
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	85 c0                	test   %eax,%eax
801050f9:	0f 88 fb 00 00 00    	js     801051fa <sys_link+0x11a>
801050ff:	83 ec 08             	sub    $0x8,%esp
80105102:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105105:	50                   	push   %eax
80105106:	6a 01                	push   $0x1
80105108:	e8 13 fb ff ff       	call   80104c20 <argstr>
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	85 c0                	test   %eax,%eax
80105112:	0f 88 e2 00 00 00    	js     801051fa <sys_link+0x11a>
  begin_op();
80105118:	e8 63 de ff ff       	call   80102f80 <begin_op>
  if((ip = namei(old)) == 0){
8010511d:	83 ec 0c             	sub    $0xc,%esp
80105120:	ff 75 d4             	push   -0x2c(%ebp)
80105123:	e8 88 d1 ff ff       	call   801022b0 <namei>
80105128:	83 c4 10             	add    $0x10,%esp
8010512b:	89 c3                	mov    %eax,%ebx
8010512d:	85 c0                	test   %eax,%eax
8010512f:	0f 84 df 00 00 00    	je     80105214 <sys_link+0x134>
  ilock(ip);
80105135:	83 ec 0c             	sub    $0xc,%esp
80105138:	50                   	push   %eax
80105139:	e8 12 c7 ff ff       	call   80101850 <ilock>
  if(ip->type == T_DIR){
8010513e:	83 c4 10             	add    $0x10,%esp
80105141:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105146:	0f 84 b5 00 00 00    	je     80105201 <sys_link+0x121>
  iupdate(ip);
8010514c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010514f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105154:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105157:	53                   	push   %ebx
80105158:	e8 43 c6 ff ff       	call   801017a0 <iupdate>
  iunlock(ip);
8010515d:	89 1c 24             	mov    %ebx,(%esp)
80105160:	e8 cb c7 ff ff       	call   80101930 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105165:	58                   	pop    %eax
80105166:	5a                   	pop    %edx
80105167:	57                   	push   %edi
80105168:	ff 75 d0             	push   -0x30(%ebp)
8010516b:	e8 60 d1 ff ff       	call   801022d0 <nameiparent>
80105170:	83 c4 10             	add    $0x10,%esp
80105173:	89 c6                	mov    %eax,%esi
80105175:	85 c0                	test   %eax,%eax
80105177:	74 5b                	je     801051d4 <sys_link+0xf4>
  ilock(dp);
80105179:	83 ec 0c             	sub    $0xc,%esp
8010517c:	50                   	push   %eax
8010517d:	e8 ce c6 ff ff       	call   80101850 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105182:	8b 03                	mov    (%ebx),%eax
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	39 06                	cmp    %eax,(%esi)
80105189:	75 3d                	jne    801051c8 <sys_link+0xe8>
8010518b:	83 ec 04             	sub    $0x4,%esp
8010518e:	ff 73 04             	push   0x4(%ebx)
80105191:	57                   	push   %edi
80105192:	56                   	push   %esi
80105193:	e8 58 d0 ff ff       	call   801021f0 <dirlink>
80105198:	83 c4 10             	add    $0x10,%esp
8010519b:	85 c0                	test   %eax,%eax
8010519d:	78 29                	js     801051c8 <sys_link+0xe8>
  iunlockput(dp);
8010519f:	83 ec 0c             	sub    $0xc,%esp
801051a2:	56                   	push   %esi
801051a3:	e8 08 ca ff ff       	call   80101bb0 <iunlockput>
  iput(ip);
801051a8:	89 1c 24             	mov    %ebx,(%esp)
801051ab:	e8 d0 c7 ff ff       	call   80101980 <iput>
  end_op();
801051b0:	e8 3b de ff ff       	call   80102ff0 <end_op>
  return 0;
801051b5:	83 c4 10             	add    $0x10,%esp
801051b8:	31 c0                	xor    %eax,%eax
}
801051ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051bd:	5b                   	pop    %ebx
801051be:	5e                   	pop    %esi
801051bf:	5f                   	pop    %edi
801051c0:	5d                   	pop    %ebp
801051c1:	c3                   	ret
801051c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801051c8:	83 ec 0c             	sub    $0xc,%esp
801051cb:	56                   	push   %esi
801051cc:	e8 df c9 ff ff       	call   80101bb0 <iunlockput>
    goto bad;
801051d1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051d4:	83 ec 0c             	sub    $0xc,%esp
801051d7:	53                   	push   %ebx
801051d8:	e8 73 c6 ff ff       	call   80101850 <ilock>
  ip->nlink--;
801051dd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051e2:	89 1c 24             	mov    %ebx,(%esp)
801051e5:	e8 b6 c5 ff ff       	call   801017a0 <iupdate>
  iunlockput(ip);
801051ea:	89 1c 24             	mov    %ebx,(%esp)
801051ed:	e8 be c9 ff ff       	call   80101bb0 <iunlockput>
  end_op();
801051f2:	e8 f9 dd ff ff       	call   80102ff0 <end_op>
  return -1;
801051f7:	83 c4 10             	add    $0x10,%esp
    return -1;
801051fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ff:	eb b9                	jmp    801051ba <sys_link+0xda>
    iunlockput(ip);
80105201:	83 ec 0c             	sub    $0xc,%esp
80105204:	53                   	push   %ebx
80105205:	e8 a6 c9 ff ff       	call   80101bb0 <iunlockput>
    end_op();
8010520a:	e8 e1 dd ff ff       	call   80102ff0 <end_op>
    return -1;
8010520f:	83 c4 10             	add    $0x10,%esp
80105212:	eb e6                	jmp    801051fa <sys_link+0x11a>
    end_op();
80105214:	e8 d7 dd ff ff       	call   80102ff0 <end_op>
    return -1;
80105219:	eb df                	jmp    801051fa <sys_link+0x11a>
8010521b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010521f:	90                   	nop

80105220 <sys_unlink>:
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	57                   	push   %edi
80105224:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105225:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105228:	53                   	push   %ebx
80105229:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010522c:	50                   	push   %eax
8010522d:	6a 00                	push   $0x0
8010522f:	e8 ec f9 ff ff       	call   80104c20 <argstr>
80105234:	83 c4 10             	add    $0x10,%esp
80105237:	85 c0                	test   %eax,%eax
80105239:	0f 88 54 01 00 00    	js     80105393 <sys_unlink+0x173>
  begin_op();
8010523f:	e8 3c dd ff ff       	call   80102f80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105244:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105247:	83 ec 08             	sub    $0x8,%esp
8010524a:	53                   	push   %ebx
8010524b:	ff 75 c0             	push   -0x40(%ebp)
8010524e:	e8 7d d0 ff ff       	call   801022d0 <nameiparent>
80105253:	83 c4 10             	add    $0x10,%esp
80105256:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105259:	85 c0                	test   %eax,%eax
8010525b:	0f 84 58 01 00 00    	je     801053b9 <sys_unlink+0x199>
  ilock(dp);
80105261:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105264:	83 ec 0c             	sub    $0xc,%esp
80105267:	57                   	push   %edi
80105268:	e8 e3 c5 ff ff       	call   80101850 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010526d:	58                   	pop    %eax
8010526e:	5a                   	pop    %edx
8010526f:	68 d4 7a 10 80       	push   $0x80107ad4
80105274:	53                   	push   %ebx
80105275:	e8 46 cc ff ff       	call   80101ec0 <namecmp>
8010527a:	83 c4 10             	add    $0x10,%esp
8010527d:	85 c0                	test   %eax,%eax
8010527f:	0f 84 fb 00 00 00    	je     80105380 <sys_unlink+0x160>
80105285:	83 ec 08             	sub    $0x8,%esp
80105288:	68 d3 7a 10 80       	push   $0x80107ad3
8010528d:	53                   	push   %ebx
8010528e:	e8 2d cc ff ff       	call   80101ec0 <namecmp>
80105293:	83 c4 10             	add    $0x10,%esp
80105296:	85 c0                	test   %eax,%eax
80105298:	0f 84 e2 00 00 00    	je     80105380 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010529e:	83 ec 04             	sub    $0x4,%esp
801052a1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052a4:	50                   	push   %eax
801052a5:	53                   	push   %ebx
801052a6:	57                   	push   %edi
801052a7:	e8 34 cc ff ff       	call   80101ee0 <dirlookup>
801052ac:	83 c4 10             	add    $0x10,%esp
801052af:	89 c3                	mov    %eax,%ebx
801052b1:	85 c0                	test   %eax,%eax
801052b3:	0f 84 c7 00 00 00    	je     80105380 <sys_unlink+0x160>
  ilock(ip);
801052b9:	83 ec 0c             	sub    $0xc,%esp
801052bc:	50                   	push   %eax
801052bd:	e8 8e c5 ff ff       	call   80101850 <ilock>
  if(ip->nlink < 1)
801052c2:	83 c4 10             	add    $0x10,%esp
801052c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052ca:	0f 8e 0a 01 00 00    	jle    801053da <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052d0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052d5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052d8:	74 66                	je     80105340 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052da:	83 ec 04             	sub    $0x4,%esp
801052dd:	6a 10                	push   $0x10
801052df:	6a 00                	push   $0x0
801052e1:	57                   	push   %edi
801052e2:	e8 c9 f5 ff ff       	call   801048b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052e7:	6a 10                	push   $0x10
801052e9:	ff 75 c4             	push   -0x3c(%ebp)
801052ec:	57                   	push   %edi
801052ed:	ff 75 b4             	push   -0x4c(%ebp)
801052f0:	e8 6b ca ff ff       	call   80101d60 <writei>
801052f5:	83 c4 20             	add    $0x20,%esp
801052f8:	83 f8 10             	cmp    $0x10,%eax
801052fb:	0f 85 cc 00 00 00    	jne    801053cd <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105301:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105306:	0f 84 94 00 00 00    	je     801053a0 <sys_unlink+0x180>
  iunlockput(dp);
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	ff 75 b4             	push   -0x4c(%ebp)
80105312:	e8 99 c8 ff ff       	call   80101bb0 <iunlockput>
  ip->nlink--;
80105317:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010531c:	89 1c 24             	mov    %ebx,(%esp)
8010531f:	e8 7c c4 ff ff       	call   801017a0 <iupdate>
  iunlockput(ip);
80105324:	89 1c 24             	mov    %ebx,(%esp)
80105327:	e8 84 c8 ff ff       	call   80101bb0 <iunlockput>
  end_op();
8010532c:	e8 bf dc ff ff       	call   80102ff0 <end_op>
  return 0;
80105331:	83 c4 10             	add    $0x10,%esp
80105334:	31 c0                	xor    %eax,%eax
}
80105336:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105339:	5b                   	pop    %ebx
8010533a:	5e                   	pop    %esi
8010533b:	5f                   	pop    %edi
8010533c:	5d                   	pop    %ebp
8010533d:	c3                   	ret
8010533e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105340:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105344:	76 94                	jbe    801052da <sys_unlink+0xba>
80105346:	be 20 00 00 00       	mov    $0x20,%esi
8010534b:	eb 0b                	jmp    80105358 <sys_unlink+0x138>
8010534d:	8d 76 00             	lea    0x0(%esi),%esi
80105350:	83 c6 10             	add    $0x10,%esi
80105353:	3b 73 58             	cmp    0x58(%ebx),%esi
80105356:	73 82                	jae    801052da <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105358:	6a 10                	push   $0x10
8010535a:	56                   	push   %esi
8010535b:	57                   	push   %edi
8010535c:	53                   	push   %ebx
8010535d:	e8 ce c8 ff ff       	call   80101c30 <readi>
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	83 f8 10             	cmp    $0x10,%eax
80105368:	75 56                	jne    801053c0 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010536a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010536f:	74 df                	je     80105350 <sys_unlink+0x130>
    iunlockput(ip);
80105371:	83 ec 0c             	sub    $0xc,%esp
80105374:	53                   	push   %ebx
80105375:	e8 36 c8 ff ff       	call   80101bb0 <iunlockput>
    goto bad;
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105380:	83 ec 0c             	sub    $0xc,%esp
80105383:	ff 75 b4             	push   -0x4c(%ebp)
80105386:	e8 25 c8 ff ff       	call   80101bb0 <iunlockput>
  end_op();
8010538b:	e8 60 dc ff ff       	call   80102ff0 <end_op>
  return -1;
80105390:	83 c4 10             	add    $0x10,%esp
    return -1;
80105393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105398:	eb 9c                	jmp    80105336 <sys_unlink+0x116>
8010539a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801053a0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801053a3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801053a6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801053ab:	50                   	push   %eax
801053ac:	e8 ef c3 ff ff       	call   801017a0 <iupdate>
801053b1:	83 c4 10             	add    $0x10,%esp
801053b4:	e9 53 ff ff ff       	jmp    8010530c <sys_unlink+0xec>
    end_op();
801053b9:	e8 32 dc ff ff       	call   80102ff0 <end_op>
    return -1;
801053be:	eb d3                	jmp    80105393 <sys_unlink+0x173>
      panic("isdirempty: readi");
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	68 f8 7a 10 80       	push   $0x80107af8
801053c8:	e8 b3 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801053cd:	83 ec 0c             	sub    $0xc,%esp
801053d0:	68 0a 7b 10 80       	push   $0x80107b0a
801053d5:	e8 a6 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801053da:	83 ec 0c             	sub    $0xc,%esp
801053dd:	68 e6 7a 10 80       	push   $0x80107ae6
801053e2:	e8 99 af ff ff       	call   80100380 <panic>
801053e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ee:	66 90                	xchg   %ax,%ax

801053f0 <sys_open>:

int
sys_open(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053f8:	53                   	push   %ebx
801053f9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053fc:	50                   	push   %eax
801053fd:	6a 00                	push   $0x0
801053ff:	e8 1c f8 ff ff       	call   80104c20 <argstr>
80105404:	83 c4 10             	add    $0x10,%esp
80105407:	85 c0                	test   %eax,%eax
80105409:	0f 88 8e 00 00 00    	js     8010549d <sys_open+0xad>
8010540f:	83 ec 08             	sub    $0x8,%esp
80105412:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105415:	50                   	push   %eax
80105416:	6a 01                	push   $0x1
80105418:	e8 43 f7 ff ff       	call   80104b60 <argint>
8010541d:	83 c4 10             	add    $0x10,%esp
80105420:	85 c0                	test   %eax,%eax
80105422:	78 79                	js     8010549d <sys_open+0xad>
    return -1;

  begin_op();
80105424:	e8 57 db ff ff       	call   80102f80 <begin_op>

  if(omode & O_CREATE){
80105429:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010542d:	75 79                	jne    801054a8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010542f:	83 ec 0c             	sub    $0xc,%esp
80105432:	ff 75 e0             	push   -0x20(%ebp)
80105435:	e8 76 ce ff ff       	call   801022b0 <namei>
8010543a:	83 c4 10             	add    $0x10,%esp
8010543d:	89 c6                	mov    %eax,%esi
8010543f:	85 c0                	test   %eax,%eax
80105441:	0f 84 7e 00 00 00    	je     801054c5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105447:	83 ec 0c             	sub    $0xc,%esp
8010544a:	50                   	push   %eax
8010544b:	e8 00 c4 ff ff       	call   80101850 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105450:	83 c4 10             	add    $0x10,%esp
80105453:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105458:	0f 84 ba 00 00 00    	je     80105518 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010545e:	e8 1d ba ff ff       	call   80100e80 <filealloc>
80105463:	89 c7                	mov    %eax,%edi
80105465:	85 c0                	test   %eax,%eax
80105467:	74 23                	je     8010548c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105469:	e8 32 e7 ff ff       	call   80103ba0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010546e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105470:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105474:	85 d2                	test   %edx,%edx
80105476:	74 58                	je     801054d0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105478:	83 c3 01             	add    $0x1,%ebx
8010547b:	83 fb 10             	cmp    $0x10,%ebx
8010547e:	75 f0                	jne    80105470 <sys_open+0x80>
    if(f)
      fileclose(f);
80105480:	83 ec 0c             	sub    $0xc,%esp
80105483:	57                   	push   %edi
80105484:	e8 b7 ba ff ff       	call   80100f40 <fileclose>
80105489:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	56                   	push   %esi
80105490:	e8 1b c7 ff ff       	call   80101bb0 <iunlockput>
    end_op();
80105495:	e8 56 db ff ff       	call   80102ff0 <end_op>
    return -1;
8010549a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010549d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054a2:	eb 65                	jmp    80105509 <sys_open+0x119>
801054a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801054a8:	83 ec 0c             	sub    $0xc,%esp
801054ab:	31 c9                	xor    %ecx,%ecx
801054ad:	ba 02 00 00 00       	mov    $0x2,%edx
801054b2:	6a 00                	push   $0x0
801054b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054b7:	e8 54 f8 ff ff       	call   80104d10 <create>
    if(ip == 0){
801054bc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801054bf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054c1:	85 c0                	test   %eax,%eax
801054c3:	75 99                	jne    8010545e <sys_open+0x6e>
      end_op();
801054c5:	e8 26 db ff ff       	call   80102ff0 <end_op>
      return -1;
801054ca:	eb d1                	jmp    8010549d <sys_open+0xad>
801054cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801054d0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054d3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801054d7:	56                   	push   %esi
801054d8:	e8 53 c4 ff ff       	call   80101930 <iunlock>
  end_op();
801054dd:	e8 0e db ff ff       	call   80102ff0 <end_op>

  f->type = FD_INODE;
801054e2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054eb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054ee:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054f1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054f3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054fa:	f7 d0                	not    %eax
801054fc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054ff:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105502:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105505:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105509:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010550c:	89 d8                	mov    %ebx,%eax
8010550e:	5b                   	pop    %ebx
8010550f:	5e                   	pop    %esi
80105510:	5f                   	pop    %edi
80105511:	5d                   	pop    %ebp
80105512:	c3                   	ret
80105513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105517:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105518:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010551b:	85 c9                	test   %ecx,%ecx
8010551d:	0f 84 3b ff ff ff    	je     8010545e <sys_open+0x6e>
80105523:	e9 64 ff ff ff       	jmp    8010548c <sys_open+0x9c>
80105528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552f:	90                   	nop

80105530 <sys_mkdir>:

int
sys_mkdir(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105536:	e8 45 da ff ff       	call   80102f80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010553b:	83 ec 08             	sub    $0x8,%esp
8010553e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105541:	50                   	push   %eax
80105542:	6a 00                	push   $0x0
80105544:	e8 d7 f6 ff ff       	call   80104c20 <argstr>
80105549:	83 c4 10             	add    $0x10,%esp
8010554c:	85 c0                	test   %eax,%eax
8010554e:	78 30                	js     80105580 <sys_mkdir+0x50>
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105556:	31 c9                	xor    %ecx,%ecx
80105558:	ba 01 00 00 00       	mov    $0x1,%edx
8010555d:	6a 00                	push   $0x0
8010555f:	e8 ac f7 ff ff       	call   80104d10 <create>
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	85 c0                	test   %eax,%eax
80105569:	74 15                	je     80105580 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010556b:	83 ec 0c             	sub    $0xc,%esp
8010556e:	50                   	push   %eax
8010556f:	e8 3c c6 ff ff       	call   80101bb0 <iunlockput>
  end_op();
80105574:	e8 77 da ff ff       	call   80102ff0 <end_op>
  return 0;
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	31 c0                	xor    %eax,%eax
}
8010557e:	c9                   	leave
8010557f:	c3                   	ret
    end_op();
80105580:	e8 6b da ff ff       	call   80102ff0 <end_op>
    return -1;
80105585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010558a:	c9                   	leave
8010558b:	c3                   	ret
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105590 <sys_mknod>:

int
sys_mknod(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105596:	e8 e5 d9 ff ff       	call   80102f80 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010559b:	83 ec 08             	sub    $0x8,%esp
8010559e:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055a1:	50                   	push   %eax
801055a2:	6a 00                	push   $0x0
801055a4:	e8 77 f6 ff ff       	call   80104c20 <argstr>
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	85 c0                	test   %eax,%eax
801055ae:	78 60                	js     80105610 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055b0:	83 ec 08             	sub    $0x8,%esp
801055b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055b6:	50                   	push   %eax
801055b7:	6a 01                	push   $0x1
801055b9:	e8 a2 f5 ff ff       	call   80104b60 <argint>
  if((argstr(0, &path)) < 0 ||
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	85 c0                	test   %eax,%eax
801055c3:	78 4b                	js     80105610 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055c5:	83 ec 08             	sub    $0x8,%esp
801055c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055cb:	50                   	push   %eax
801055cc:	6a 02                	push   $0x2
801055ce:	e8 8d f5 ff ff       	call   80104b60 <argint>
     argint(1, &major) < 0 ||
801055d3:	83 c4 10             	add    $0x10,%esp
801055d6:	85 c0                	test   %eax,%eax
801055d8:	78 36                	js     80105610 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801055da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801055de:	83 ec 0c             	sub    $0xc,%esp
801055e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801055e5:	ba 03 00 00 00       	mov    $0x3,%edx
801055ea:	50                   	push   %eax
801055eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055ee:	e8 1d f7 ff ff       	call   80104d10 <create>
     argint(2, &minor) < 0 ||
801055f3:	83 c4 10             	add    $0x10,%esp
801055f6:	85 c0                	test   %eax,%eax
801055f8:	74 16                	je     80105610 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055fa:	83 ec 0c             	sub    $0xc,%esp
801055fd:	50                   	push   %eax
801055fe:	e8 ad c5 ff ff       	call   80101bb0 <iunlockput>
  end_op();
80105603:	e8 e8 d9 ff ff       	call   80102ff0 <end_op>
  return 0;
80105608:	83 c4 10             	add    $0x10,%esp
8010560b:	31 c0                	xor    %eax,%eax
}
8010560d:	c9                   	leave
8010560e:	c3                   	ret
8010560f:	90                   	nop
    end_op();
80105610:	e8 db d9 ff ff       	call   80102ff0 <end_op>
    return -1;
80105615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010561a:	c9                   	leave
8010561b:	c3                   	ret
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105620 <sys_chdir>:

int
sys_chdir(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	56                   	push   %esi
80105624:	53                   	push   %ebx
80105625:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105628:	e8 73 e5 ff ff       	call   80103ba0 <myproc>
8010562d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010562f:	e8 4c d9 ff ff       	call   80102f80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105634:	83 ec 08             	sub    $0x8,%esp
80105637:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010563a:	50                   	push   %eax
8010563b:	6a 00                	push   $0x0
8010563d:	e8 de f5 ff ff       	call   80104c20 <argstr>
80105642:	83 c4 10             	add    $0x10,%esp
80105645:	85 c0                	test   %eax,%eax
80105647:	78 77                	js     801056c0 <sys_chdir+0xa0>
80105649:	83 ec 0c             	sub    $0xc,%esp
8010564c:	ff 75 f4             	push   -0xc(%ebp)
8010564f:	e8 5c cc ff ff       	call   801022b0 <namei>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	89 c3                	mov    %eax,%ebx
80105659:	85 c0                	test   %eax,%eax
8010565b:	74 63                	je     801056c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010565d:	83 ec 0c             	sub    $0xc,%esp
80105660:	50                   	push   %eax
80105661:	e8 ea c1 ff ff       	call   80101850 <ilock>
  if(ip->type != T_DIR){
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010566e:	75 30                	jne    801056a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	53                   	push   %ebx
80105674:	e8 b7 c2 ff ff       	call   80101930 <iunlock>
  iput(curproc->cwd);
80105679:	58                   	pop    %eax
8010567a:	ff 76 68             	push   0x68(%esi)
8010567d:	e8 fe c2 ff ff       	call   80101980 <iput>
  end_op();
80105682:	e8 69 d9 ff ff       	call   80102ff0 <end_op>
  curproc->cwd = ip;
80105687:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010568a:	83 c4 10             	add    $0x10,%esp
8010568d:	31 c0                	xor    %eax,%eax
}
8010568f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105692:	5b                   	pop    %ebx
80105693:	5e                   	pop    %esi
80105694:	5d                   	pop    %ebp
80105695:	c3                   	ret
80105696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	53                   	push   %ebx
801056a4:	e8 07 c5 ff ff       	call   80101bb0 <iunlockput>
    end_op();
801056a9:	e8 42 d9 ff ff       	call   80102ff0 <end_op>
    return -1;
801056ae:	83 c4 10             	add    $0x10,%esp
    return -1;
801056b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b6:	eb d7                	jmp    8010568f <sys_chdir+0x6f>
801056b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056bf:	90                   	nop
    end_op();
801056c0:	e8 2b d9 ff ff       	call   80102ff0 <end_op>
    return -1;
801056c5:	eb ea                	jmp    801056b1 <sys_chdir+0x91>
801056c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ce:	66 90                	xchg   %ax,%ax

801056d0 <sys_exec>:

int
sys_exec(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	57                   	push   %edi
801056d4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056d5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056db:	53                   	push   %ebx
801056dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056e2:	50                   	push   %eax
801056e3:	6a 00                	push   $0x0
801056e5:	e8 36 f5 ff ff       	call   80104c20 <argstr>
801056ea:	83 c4 10             	add    $0x10,%esp
801056ed:	85 c0                	test   %eax,%eax
801056ef:	0f 88 87 00 00 00    	js     8010577c <sys_exec+0xac>
801056f5:	83 ec 08             	sub    $0x8,%esp
801056f8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056fe:	50                   	push   %eax
801056ff:	6a 01                	push   $0x1
80105701:	e8 5a f4 ff ff       	call   80104b60 <argint>
80105706:	83 c4 10             	add    $0x10,%esp
80105709:	85 c0                	test   %eax,%eax
8010570b:	78 6f                	js     8010577c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010570d:	83 ec 04             	sub    $0x4,%esp
80105710:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105716:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105718:	68 80 00 00 00       	push   $0x80
8010571d:	6a 00                	push   $0x0
8010571f:	56                   	push   %esi
80105720:	e8 8b f1 ff ff       	call   801048b0 <memset>
80105725:	83 c4 10             	add    $0x10,%esp
80105728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105730:	83 ec 08             	sub    $0x8,%esp
80105733:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105739:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105740:	50                   	push   %eax
80105741:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105747:	01 f8                	add    %edi,%eax
80105749:	50                   	push   %eax
8010574a:	e8 81 f3 ff ff       	call   80104ad0 <fetchint>
8010574f:	83 c4 10             	add    $0x10,%esp
80105752:	85 c0                	test   %eax,%eax
80105754:	78 26                	js     8010577c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105756:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010575c:	85 c0                	test   %eax,%eax
8010575e:	74 30                	je     80105790 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105760:	83 ec 08             	sub    $0x8,%esp
80105763:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105766:	52                   	push   %edx
80105767:	50                   	push   %eax
80105768:	e8 a3 f3 ff ff       	call   80104b10 <fetchstr>
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	85 c0                	test   %eax,%eax
80105772:	78 08                	js     8010577c <sys_exec+0xac>
  for(i=0;; i++){
80105774:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105777:	83 fb 20             	cmp    $0x20,%ebx
8010577a:	75 b4                	jne    80105730 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010577c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010577f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105784:	5b                   	pop    %ebx
80105785:	5e                   	pop    %esi
80105786:	5f                   	pop    %edi
80105787:	5d                   	pop    %ebp
80105788:	c3                   	ret
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105790:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105797:	00 00 00 00 
  return exec(path, argv);
8010579b:	83 ec 08             	sub    $0x8,%esp
8010579e:	56                   	push   %esi
8010579f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801057a5:	e8 36 b3 ff ff       	call   80100ae0 <exec>
801057aa:	83 c4 10             	add    $0x10,%esp
}
801057ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b0:	5b                   	pop    %ebx
801057b1:	5e                   	pop    %esi
801057b2:	5f                   	pop    %edi
801057b3:	5d                   	pop    %ebp
801057b4:	c3                   	ret
801057b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_pipe>:

int
sys_pipe(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	57                   	push   %edi
801057c4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057c5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057c8:	53                   	push   %ebx
801057c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057cc:	6a 08                	push   $0x8
801057ce:	50                   	push   %eax
801057cf:	6a 00                	push   $0x0
801057d1:	e8 da f3 ff ff       	call   80104bb0 <argptr>
801057d6:	83 c4 10             	add    $0x10,%esp
801057d9:	85 c0                	test   %eax,%eax
801057db:	0f 88 8b 00 00 00    	js     8010586c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057e1:	83 ec 08             	sub    $0x8,%esp
801057e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057e7:	50                   	push   %eax
801057e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057eb:	50                   	push   %eax
801057ec:	e8 5f de ff ff       	call   80103650 <pipealloc>
801057f1:	83 c4 10             	add    $0x10,%esp
801057f4:	85 c0                	test   %eax,%eax
801057f6:	78 74                	js     8010586c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057fb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057fd:	e8 9e e3 ff ff       	call   80103ba0 <myproc>
    if(curproc->ofile[fd] == 0){
80105802:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105806:	85 f6                	test   %esi,%esi
80105808:	74 16                	je     80105820 <sys_pipe+0x60>
8010580a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105810:	83 c3 01             	add    $0x1,%ebx
80105813:	83 fb 10             	cmp    $0x10,%ebx
80105816:	74 3d                	je     80105855 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105818:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010581c:	85 f6                	test   %esi,%esi
8010581e:	75 f0                	jne    80105810 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105820:	8d 73 08             	lea    0x8(%ebx),%esi
80105823:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105827:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010582a:	e8 71 e3 ff ff       	call   80103ba0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010582f:	31 d2                	xor    %edx,%edx
80105831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105838:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010583c:	85 c9                	test   %ecx,%ecx
8010583e:	74 38                	je     80105878 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105840:	83 c2 01             	add    $0x1,%edx
80105843:	83 fa 10             	cmp    $0x10,%edx
80105846:	75 f0                	jne    80105838 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105848:	e8 53 e3 ff ff       	call   80103ba0 <myproc>
8010584d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105854:	00 
    fileclose(rf);
80105855:	83 ec 0c             	sub    $0xc,%esp
80105858:	ff 75 e0             	push   -0x20(%ebp)
8010585b:	e8 e0 b6 ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
80105860:	58                   	pop    %eax
80105861:	ff 75 e4             	push   -0x1c(%ebp)
80105864:	e8 d7 b6 ff ff       	call   80100f40 <fileclose>
    return -1;
80105869:	83 c4 10             	add    $0x10,%esp
    return -1;
8010586c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105871:	eb 16                	jmp    80105889 <sys_pipe+0xc9>
80105873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105877:	90                   	nop
      curproc->ofile[fd] = f;
80105878:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010587c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010587f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105881:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105884:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105887:	31 c0                	xor    %eax,%eax
}
80105889:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010588c:	5b                   	pop    %ebx
8010588d:	5e                   	pop    %esi
8010588e:	5f                   	pop    %edi
8010588f:	5d                   	pop    %ebp
80105890:	c3                   	ret
80105891:	66 90                	xchg   %ax,%ax
80105893:	66 90                	xchg   %ax,%ax
80105895:	66 90                	xchg   %ax,%ax
80105897:	66 90                	xchg   %ax,%ax
80105899:	66 90                	xchg   %ax,%ax
8010589b:	66 90                	xchg   %ax,%ax
8010589d:	66 90                	xchg   %ax,%ax
8010589f:	90                   	nop

801058a0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801058a0:	e9 9b e4 ff ff       	jmp    80103d40 <fork>
801058a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_exit>:
}

int
sys_exit(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801058b6:	e8 f5 e6 ff ff       	call   80103fb0 <exit>
  return 0;  // not reached
}
801058bb:	31 c0                	xor    %eax,%eax
801058bd:	c9                   	leave
801058be:	c3                   	ret
801058bf:	90                   	nop

801058c0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801058c0:	e9 1b e8 ff ff       	jmp    801040e0 <wait>
801058c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058d0 <sys_kill>:
}

int
sys_kill(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d9:	50                   	push   %eax
801058da:	6a 00                	push   $0x0
801058dc:	e8 7f f2 ff ff       	call   80104b60 <argint>
801058e1:	83 c4 10             	add    $0x10,%esp
801058e4:	85 c0                	test   %eax,%eax
801058e6:	78 18                	js     80105900 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058e8:	83 ec 0c             	sub    $0xc,%esp
801058eb:	ff 75 f4             	push   -0xc(%ebp)
801058ee:	e8 8d ea ff ff       	call   80104380 <kill>
801058f3:	83 c4 10             	add    $0x10,%esp
}
801058f6:	c9                   	leave
801058f7:	c3                   	ret
801058f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ff:	90                   	nop
80105900:	c9                   	leave
    return -1;
80105901:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105906:	c3                   	ret
80105907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590e:	66 90                	xchg   %ax,%ax

80105910 <sys_getpid>:

int
sys_getpid(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105916:	e8 85 e2 ff ff       	call   80103ba0 <myproc>
8010591b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010591e:	c9                   	leave
8010591f:	c3                   	ret

80105920 <sys_sbrk>:

int
sys_sbrk(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105924:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105927:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010592a:	50                   	push   %eax
8010592b:	6a 00                	push   $0x0
8010592d:	e8 2e f2 ff ff       	call   80104b60 <argint>
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	85 c0                	test   %eax,%eax
80105937:	78 27                	js     80105960 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105939:	e8 62 e2 ff ff       	call   80103ba0 <myproc>
  if(growproc(n) < 0)
8010593e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105941:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105943:	ff 75 f4             	push   -0xc(%ebp)
80105946:	e8 75 e3 ff ff       	call   80103cc0 <growproc>
8010594b:	83 c4 10             	add    $0x10,%esp
8010594e:	85 c0                	test   %eax,%eax
80105950:	78 0e                	js     80105960 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105952:	89 d8                	mov    %ebx,%eax
80105954:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105957:	c9                   	leave
80105958:	c3                   	ret
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105960:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105965:	eb eb                	jmp    80105952 <sys_sbrk+0x32>
80105967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596e:	66 90                	xchg   %ax,%ax

80105970 <sys_sleep>:

int
sys_sleep(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105974:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105977:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010597a:	50                   	push   %eax
8010597b:	6a 00                	push   $0x0
8010597d:	e8 de f1 ff ff       	call   80104b60 <argint>
80105982:	83 c4 10             	add    $0x10,%esp
80105985:	85 c0                	test   %eax,%eax
80105987:	78 64                	js     801059ed <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105989:	83 ec 0c             	sub    $0xc,%esp
8010598c:	68 80 3c 11 80       	push   $0x80113c80
80105991:	e8 3a ee ff ff       	call   801047d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105996:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105999:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
8010599f:	83 c4 10             	add    $0x10,%esp
801059a2:	85 d2                	test   %edx,%edx
801059a4:	75 2b                	jne    801059d1 <sys_sleep+0x61>
801059a6:	eb 58                	jmp    80105a00 <sys_sleep+0x90>
801059a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059af:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801059b0:	83 ec 08             	sub    $0x8,%esp
801059b3:	68 80 3c 11 80       	push   $0x80113c80
801059b8:	68 60 3c 11 80       	push   $0x80113c60
801059bd:	e8 9e e8 ff ff       	call   80104260 <sleep>
  while(ticks - ticks0 < n){
801059c2:	a1 60 3c 11 80       	mov    0x80113c60,%eax
801059c7:	83 c4 10             	add    $0x10,%esp
801059ca:	29 d8                	sub    %ebx,%eax
801059cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059cf:	73 2f                	jae    80105a00 <sys_sleep+0x90>
    if(myproc()->killed){
801059d1:	e8 ca e1 ff ff       	call   80103ba0 <myproc>
801059d6:	8b 40 24             	mov    0x24(%eax),%eax
801059d9:	85 c0                	test   %eax,%eax
801059db:	74 d3                	je     801059b0 <sys_sleep+0x40>
      release(&tickslock);
801059dd:	83 ec 0c             	sub    $0xc,%esp
801059e0:	68 80 3c 11 80       	push   $0x80113c80
801059e5:	e8 86 ed ff ff       	call   80104770 <release>
      return -1;
801059ea:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801059ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801059f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f5:	c9                   	leave
801059f6:	c3                   	ret
801059f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	68 80 3c 11 80       	push   $0x80113c80
80105a08:	e8 63 ed ff ff       	call   80104770 <release>
}
80105a0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105a10:	83 c4 10             	add    $0x10,%esp
80105a13:	31 c0                	xor    %eax,%eax
}
80105a15:	c9                   	leave
80105a16:	c3                   	ret
80105a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1e:	66 90                	xchg   %ax,%ax

80105a20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	53                   	push   %ebx
80105a24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a27:	68 80 3c 11 80       	push   $0x80113c80
80105a2c:	e8 9f ed ff ff       	call   801047d0 <acquire>
  xticks = ticks;
80105a31:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  release(&tickslock);
80105a37:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105a3e:	e8 2d ed ff ff       	call   80104770 <release>
  return xticks;
}
80105a43:	89 d8                	mov    %ebx,%eax
80105a45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a48:	c9                   	leave
80105a49:	c3                   	ret

80105a4a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a4a:	1e                   	push   %ds
  pushl %es
80105a4b:	06                   	push   %es
  pushl %fs
80105a4c:	0f a0                	push   %fs
  pushl %gs
80105a4e:	0f a8                	push   %gs
  pushal
80105a50:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a51:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a55:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a57:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a59:	54                   	push   %esp
  call trap
80105a5a:	e8 c1 00 00 00       	call   80105b20 <trap>
  addl $4, %esp
80105a5f:	83 c4 04             	add    $0x4,%esp

80105a62 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a62:	61                   	popa
  popl %gs
80105a63:	0f a9                	pop    %gs
  popl %fs
80105a65:	0f a1                	pop    %fs
  popl %es
80105a67:	07                   	pop    %es
  popl %ds
80105a68:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a69:	83 c4 08             	add    $0x8,%esp
  iret
80105a6c:	cf                   	iret
80105a6d:	66 90                	xchg   %ax,%ax
80105a6f:	90                   	nop

80105a70 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a70:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a71:	31 c0                	xor    %eax,%eax
{
80105a73:	89 e5                	mov    %esp,%ebp
80105a75:	83 ec 08             	sub    $0x8,%esp
80105a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a80:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a87:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
80105a8e:	08 00 00 8e 
80105a92:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
80105a99:	80 
80105a9a:	c1 ea 10             	shr    $0x10,%edx
80105a9d:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
80105aa4:	80 
  for(i = 0; i < 256; i++)
80105aa5:	83 c0 01             	add    $0x1,%eax
80105aa8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105aad:	75 d1                	jne    80105a80 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105aaf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ab2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105ab7:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
80105abe:	00 00 ef 
  initlock(&tickslock, "time");
80105ac1:	68 19 7b 10 80       	push   $0x80107b19
80105ac6:	68 80 3c 11 80       	push   $0x80113c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105acb:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
80105ad1:	c1 e8 10             	shr    $0x10,%eax
80105ad4:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6
  initlock(&tickslock, "time");
80105ada:	e8 11 eb ff ff       	call   801045f0 <initlock>
}
80105adf:	83 c4 10             	add    $0x10,%esp
80105ae2:	c9                   	leave
80105ae3:	c3                   	ret
80105ae4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aef:	90                   	nop

80105af0 <idtinit>:

void
idtinit(void)
{
80105af0:	55                   	push   %ebp
  pd[0] = size-1;
80105af1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105af6:	89 e5                	mov    %esp,%ebp
80105af8:	83 ec 10             	sub    $0x10,%esp
80105afb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105aff:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105b04:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b08:	c1 e8 10             	shr    $0x10,%eax
80105b0b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b0f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b12:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b15:	c9                   	leave
80105b16:	c3                   	ret
80105b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b1e:	66 90                	xchg   %ax,%ax

80105b20 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	57                   	push   %edi
80105b24:	56                   	push   %esi
80105b25:	53                   	push   %ebx
80105b26:	83 ec 1c             	sub    $0x1c,%esp
80105b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b2c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b2f:	83 f8 40             	cmp    $0x40,%eax
80105b32:	0f 84 68 01 00 00    	je     80105ca0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b38:	83 e8 20             	sub    $0x20,%eax
80105b3b:	83 f8 1f             	cmp    $0x1f,%eax
80105b3e:	0f 87 8c 00 00 00    	ja     80105bd0 <trap+0xb0>
80105b44:	ff 24 85 c0 7b 10 80 	jmp    *-0x7fef8440(,%eax,4)
80105b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b4f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105b50:	e8 0b c9 ff ff       	call   80102460 <ideintr>
    lapiceoi();
80105b55:	e8 d6 cf ff ff       	call   80102b30 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b5a:	e8 41 e0 ff ff       	call   80103ba0 <myproc>
80105b5f:	85 c0                	test   %eax,%eax
80105b61:	74 1d                	je     80105b80 <trap+0x60>
80105b63:	e8 38 e0 ff ff       	call   80103ba0 <myproc>
80105b68:	8b 50 24             	mov    0x24(%eax),%edx
80105b6b:	85 d2                	test   %edx,%edx
80105b6d:	74 11                	je     80105b80 <trap+0x60>
80105b6f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b73:	83 e0 03             	and    $0x3,%eax
80105b76:	66 83 f8 03          	cmp    $0x3,%ax
80105b7a:	0f 84 e8 01 00 00    	je     80105d68 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105b80:	e8 1b e0 ff ff       	call   80103ba0 <myproc>
80105b85:	85 c0                	test   %eax,%eax
80105b87:	74 0f                	je     80105b98 <trap+0x78>
80105b89:	e8 12 e0 ff ff       	call   80103ba0 <myproc>
80105b8e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b92:	0f 84 b8 00 00 00    	je     80105c50 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b98:	e8 03 e0 ff ff       	call   80103ba0 <myproc>
80105b9d:	85 c0                	test   %eax,%eax
80105b9f:	74 1d                	je     80105bbe <trap+0x9e>
80105ba1:	e8 fa df ff ff       	call   80103ba0 <myproc>
80105ba6:	8b 40 24             	mov    0x24(%eax),%eax
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	74 11                	je     80105bbe <trap+0x9e>
80105bad:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105bb1:	83 e0 03             	and    $0x3,%eax
80105bb4:	66 83 f8 03          	cmp    $0x3,%ax
80105bb8:	0f 84 0f 01 00 00    	je     80105ccd <trap+0x1ad>
    exit();
}
80105bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bc1:	5b                   	pop    %ebx
80105bc2:	5e                   	pop    %esi
80105bc3:	5f                   	pop    %edi
80105bc4:	5d                   	pop    %ebp
80105bc5:	c3                   	ret
80105bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105bd0:	e8 cb df ff ff       	call   80103ba0 <myproc>
80105bd5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bd8:	85 c0                	test   %eax,%eax
80105bda:	0f 84 a2 01 00 00    	je     80105d82 <trap+0x262>
80105be0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105be4:	0f 84 98 01 00 00    	je     80105d82 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105bea:	0f 20 d1             	mov    %cr2,%ecx
80105bed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bf0:	e8 8b df ff ff       	call   80103b80 <cpuid>
80105bf5:	8b 73 30             	mov    0x30(%ebx),%esi
80105bf8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105bfb:	8b 43 34             	mov    0x34(%ebx),%eax
80105bfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105c01:	e8 9a df ff ff       	call   80103ba0 <myproc>
80105c06:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c09:	e8 92 df ff ff       	call   80103ba0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c0e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c11:	51                   	push   %ecx
80105c12:	57                   	push   %edi
80105c13:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c16:	52                   	push   %edx
80105c17:	ff 75 e4             	push   -0x1c(%ebp)
80105c1a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c1b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c1e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c21:	56                   	push   %esi
80105c22:	ff 70 10             	push   0x10(%eax)
80105c25:	68 7c 7b 10 80       	push   $0x80107b7c
80105c2a:	e8 81 aa ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105c2f:	83 c4 20             	add    $0x20,%esp
80105c32:	e8 69 df ff ff       	call   80103ba0 <myproc>
80105c37:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c3e:	e8 5d df ff ff       	call   80103ba0 <myproc>
80105c43:	85 c0                	test   %eax,%eax
80105c45:	0f 85 18 ff ff ff    	jne    80105b63 <trap+0x43>
80105c4b:	e9 30 ff ff ff       	jmp    80105b80 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105c50:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105c54:	0f 85 3e ff ff ff    	jne    80105b98 <trap+0x78>
    yield();
80105c5a:	e8 b1 e5 ff ff       	call   80104210 <yield>
80105c5f:	e9 34 ff ff ff       	jmp    80105b98 <trap+0x78>
80105c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105c68:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c6b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105c6f:	e8 0c df ff ff       	call   80103b80 <cpuid>
80105c74:	57                   	push   %edi
80105c75:	56                   	push   %esi
80105c76:	50                   	push   %eax
80105c77:	68 24 7b 10 80       	push   $0x80107b24
80105c7c:	e8 2f aa ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105c81:	e8 aa ce ff ff       	call   80102b30 <lapiceoi>
    break;
80105c86:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c89:	e8 12 df ff ff       	call   80103ba0 <myproc>
80105c8e:	85 c0                	test   %eax,%eax
80105c90:	0f 85 cd fe ff ff    	jne    80105b63 <trap+0x43>
80105c96:	e9 e5 fe ff ff       	jmp    80105b80 <trap+0x60>
80105c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c9f:	90                   	nop
    if(myproc()->killed)
80105ca0:	e8 fb de ff ff       	call   80103ba0 <myproc>
80105ca5:	8b 70 24             	mov    0x24(%eax),%esi
80105ca8:	85 f6                	test   %esi,%esi
80105caa:	0f 85 c8 00 00 00    	jne    80105d78 <trap+0x258>
    myproc()->tf = tf;
80105cb0:	e8 eb de ff ff       	call   80103ba0 <myproc>
80105cb5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105cb8:	e8 e3 ef ff ff       	call   80104ca0 <syscall>
    if(myproc()->killed)
80105cbd:	e8 de de ff ff       	call   80103ba0 <myproc>
80105cc2:	8b 48 24             	mov    0x24(%eax),%ecx
80105cc5:	85 c9                	test   %ecx,%ecx
80105cc7:	0f 84 f1 fe ff ff    	je     80105bbe <trap+0x9e>
}
80105ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cd0:	5b                   	pop    %ebx
80105cd1:	5e                   	pop    %esi
80105cd2:	5f                   	pop    %edi
80105cd3:	5d                   	pop    %ebp
      exit();
80105cd4:	e9 d7 e2 ff ff       	jmp    80103fb0 <exit>
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ce0:	e8 4b 02 00 00       	call   80105f30 <uartintr>
    lapiceoi();
80105ce5:	e8 46 ce ff ff       	call   80102b30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cea:	e8 b1 de ff ff       	call   80103ba0 <myproc>
80105cef:	85 c0                	test   %eax,%eax
80105cf1:	0f 85 6c fe ff ff    	jne    80105b63 <trap+0x43>
80105cf7:	e9 84 fe ff ff       	jmp    80105b80 <trap+0x60>
80105cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105d00:	e8 eb cc ff ff       	call   801029f0 <kbdintr>
    lapiceoi();
80105d05:	e8 26 ce ff ff       	call   80102b30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d0a:	e8 91 de ff ff       	call   80103ba0 <myproc>
80105d0f:	85 c0                	test   %eax,%eax
80105d11:	0f 85 4c fe ff ff    	jne    80105b63 <trap+0x43>
80105d17:	e9 64 fe ff ff       	jmp    80105b80 <trap+0x60>
80105d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105d20:	e8 5b de ff ff       	call   80103b80 <cpuid>
80105d25:	85 c0                	test   %eax,%eax
80105d27:	0f 85 28 fe ff ff    	jne    80105b55 <trap+0x35>
      acquire(&tickslock);
80105d2d:	83 ec 0c             	sub    $0xc,%esp
80105d30:	68 80 3c 11 80       	push   $0x80113c80
80105d35:	e8 96 ea ff ff       	call   801047d0 <acquire>
      ticks++;
80105d3a:	83 05 60 3c 11 80 01 	addl   $0x1,0x80113c60
      wakeup(&ticks);
80105d41:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80105d48:	e8 d3 e5 ff ff       	call   80104320 <wakeup>
      release(&tickslock);
80105d4d:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105d54:	e8 17 ea ff ff       	call   80104770 <release>
80105d59:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105d5c:	e9 f4 fd ff ff       	jmp    80105b55 <trap+0x35>
80105d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105d68:	e8 43 e2 ff ff       	call   80103fb0 <exit>
80105d6d:	e9 0e fe ff ff       	jmp    80105b80 <trap+0x60>
80105d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105d78:	e8 33 e2 ff ff       	call   80103fb0 <exit>
80105d7d:	e9 2e ff ff ff       	jmp    80105cb0 <trap+0x190>
80105d82:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d85:	e8 f6 dd ff ff       	call   80103b80 <cpuid>
80105d8a:	83 ec 0c             	sub    $0xc,%esp
80105d8d:	56                   	push   %esi
80105d8e:	57                   	push   %edi
80105d8f:	50                   	push   %eax
80105d90:	ff 73 30             	push   0x30(%ebx)
80105d93:	68 48 7b 10 80       	push   $0x80107b48
80105d98:	e8 13 a9 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105d9d:	83 c4 14             	add    $0x14,%esp
80105da0:	68 1e 7b 10 80       	push   $0x80107b1e
80105da5:	e8 d6 a5 ff ff       	call   80100380 <panic>
80105daa:	66 90                	xchg   %ax,%ax
80105dac:	66 90                	xchg   %ax,%ax
80105dae:	66 90                	xchg   %ax,%ax

80105db0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105db0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105db5:	85 c0                	test   %eax,%eax
80105db7:	74 17                	je     80105dd0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105db9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105dbe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105dbf:	a8 01                	test   $0x1,%al
80105dc1:	74 0d                	je     80105dd0 <uartgetc+0x20>
80105dc3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dc8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105dc9:	0f b6 c0             	movzbl %al,%eax
80105dcc:	c3                   	ret
80105dcd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dd5:	c3                   	ret
80105dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ddd:	8d 76 00             	lea    0x0(%esi),%esi

80105de0 <uartinit>:
{
80105de0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105de1:	31 c9                	xor    %ecx,%ecx
80105de3:	89 c8                	mov    %ecx,%eax
80105de5:	89 e5                	mov    %esp,%ebp
80105de7:	57                   	push   %edi
80105de8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105ded:	56                   	push   %esi
80105dee:	89 fa                	mov    %edi,%edx
80105df0:	53                   	push   %ebx
80105df1:	83 ec 1c             	sub    $0x1c,%esp
80105df4:	ee                   	out    %al,(%dx)
80105df5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105dfa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105dff:	89 f2                	mov    %esi,%edx
80105e01:	ee                   	out    %al,(%dx)
80105e02:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e0c:	ee                   	out    %al,(%dx)
80105e0d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e12:	89 c8                	mov    %ecx,%eax
80105e14:	89 da                	mov    %ebx,%edx
80105e16:	ee                   	out    %al,(%dx)
80105e17:	b8 03 00 00 00       	mov    $0x3,%eax
80105e1c:	89 f2                	mov    %esi,%edx
80105e1e:	ee                   	out    %al,(%dx)
80105e1f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e24:	89 c8                	mov    %ecx,%eax
80105e26:	ee                   	out    %al,(%dx)
80105e27:	b8 01 00 00 00       	mov    $0x1,%eax
80105e2c:	89 da                	mov    %ebx,%edx
80105e2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e2f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e34:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e35:	3c ff                	cmp    $0xff,%al
80105e37:	0f 84 7c 00 00 00    	je     80105eb9 <uartinit+0xd9>
  uart = 1;
80105e3d:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105e44:	00 00 00 
80105e47:	89 fa                	mov    %edi,%edx
80105e49:	ec                   	in     (%dx),%al
80105e4a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e4f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e50:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105e53:	bf 40 7c 10 80       	mov    $0x80107c40,%edi
80105e58:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105e5d:	6a 00                	push   $0x0
80105e5f:	6a 04                	push   $0x4
80105e61:	e8 2a c8 ff ff       	call   80102690 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105e66:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105e6a:	83 c4 10             	add    $0x10,%esp
80105e6d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105e70:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105e75:	85 c0                	test   %eax,%eax
80105e77:	74 32                	je     80105eab <uartinit+0xcb>
80105e79:	89 f2                	mov    %esi,%edx
80105e7b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e7c:	a8 20                	test   $0x20,%al
80105e7e:	75 21                	jne    80105ea1 <uartinit+0xc1>
80105e80:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e85:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105e88:	83 ec 0c             	sub    $0xc,%esp
80105e8b:	6a 0a                	push   $0xa
80105e8d:	e8 be cc ff ff       	call   80102b50 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e92:	83 c4 10             	add    $0x10,%esp
80105e95:	83 eb 01             	sub    $0x1,%ebx
80105e98:	74 07                	je     80105ea1 <uartinit+0xc1>
80105e9a:	89 f2                	mov    %esi,%edx
80105e9c:	ec                   	in     (%dx),%al
80105e9d:	a8 20                	test   $0x20,%al
80105e9f:	74 e7                	je     80105e88 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ea1:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ea6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105eaa:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105eab:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105eaf:	83 c7 01             	add    $0x1,%edi
80105eb2:	88 45 e7             	mov    %al,-0x19(%ebp)
80105eb5:	84 c0                	test   %al,%al
80105eb7:	75 b7                	jne    80105e70 <uartinit+0x90>
}
80105eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ebc:	5b                   	pop    %ebx
80105ebd:	5e                   	pop    %esi
80105ebe:	5f                   	pop    %edi
80105ebf:	5d                   	pop    %ebp
80105ec0:	c3                   	ret
80105ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ecf:	90                   	nop

80105ed0 <uartputc>:
  if(!uart)
80105ed0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105ed5:	85 c0                	test   %eax,%eax
80105ed7:	74 4f                	je     80105f28 <uartputc+0x58>
{
80105ed9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105eda:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105edf:	89 e5                	mov    %esp,%ebp
80105ee1:	56                   	push   %esi
80105ee2:	53                   	push   %ebx
80105ee3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ee4:	a8 20                	test   $0x20,%al
80105ee6:	75 29                	jne    80105f11 <uartputc+0x41>
80105ee8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105eed:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105ef8:	83 ec 0c             	sub    $0xc,%esp
80105efb:	6a 0a                	push   $0xa
80105efd:	e8 4e cc ff ff       	call   80102b50 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	83 eb 01             	sub    $0x1,%ebx
80105f08:	74 07                	je     80105f11 <uartputc+0x41>
80105f0a:	89 f2                	mov    %esi,%edx
80105f0c:	ec                   	in     (%dx),%al
80105f0d:	a8 20                	test   $0x20,%al
80105f0f:	74 e7                	je     80105ef8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f11:	8b 45 08             	mov    0x8(%ebp),%eax
80105f14:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f19:	ee                   	out    %al,(%dx)
}
80105f1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f1d:	5b                   	pop    %ebx
80105f1e:	5e                   	pop    %esi
80105f1f:	5d                   	pop    %ebp
80105f20:	c3                   	ret
80105f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f28:	c3                   	ret
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f30 <uartintr>:

void
uartintr(void)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f36:	68 b0 5d 10 80       	push   $0x80105db0
80105f3b:	e8 80 a9 ff ff       	call   801008c0 <consoleintr>
}
80105f40:	83 c4 10             	add    $0x10,%esp
80105f43:	c9                   	leave
80105f44:	c3                   	ret

80105f45 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $0
80105f47:	6a 00                	push   $0x0
  jmp alltraps
80105f49:	e9 fc fa ff ff       	jmp    80105a4a <alltraps>

80105f4e <vector1>:
.globl vector1
vector1:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $1
80105f50:	6a 01                	push   $0x1
  jmp alltraps
80105f52:	e9 f3 fa ff ff       	jmp    80105a4a <alltraps>

80105f57 <vector2>:
.globl vector2
vector2:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $2
80105f59:	6a 02                	push   $0x2
  jmp alltraps
80105f5b:	e9 ea fa ff ff       	jmp    80105a4a <alltraps>

80105f60 <vector3>:
.globl vector3
vector3:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $3
80105f62:	6a 03                	push   $0x3
  jmp alltraps
80105f64:	e9 e1 fa ff ff       	jmp    80105a4a <alltraps>

80105f69 <vector4>:
.globl vector4
vector4:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $4
80105f6b:	6a 04                	push   $0x4
  jmp alltraps
80105f6d:	e9 d8 fa ff ff       	jmp    80105a4a <alltraps>

80105f72 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $5
80105f74:	6a 05                	push   $0x5
  jmp alltraps
80105f76:	e9 cf fa ff ff       	jmp    80105a4a <alltraps>

80105f7b <vector6>:
.globl vector6
vector6:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $6
80105f7d:	6a 06                	push   $0x6
  jmp alltraps
80105f7f:	e9 c6 fa ff ff       	jmp    80105a4a <alltraps>

80105f84 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $7
80105f86:	6a 07                	push   $0x7
  jmp alltraps
80105f88:	e9 bd fa ff ff       	jmp    80105a4a <alltraps>

80105f8d <vector8>:
.globl vector8
vector8:
  pushl $8
80105f8d:	6a 08                	push   $0x8
  jmp alltraps
80105f8f:	e9 b6 fa ff ff       	jmp    80105a4a <alltraps>

80105f94 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f94:	6a 00                	push   $0x0
  pushl $9
80105f96:	6a 09                	push   $0x9
  jmp alltraps
80105f98:	e9 ad fa ff ff       	jmp    80105a4a <alltraps>

80105f9d <vector10>:
.globl vector10
vector10:
  pushl $10
80105f9d:	6a 0a                	push   $0xa
  jmp alltraps
80105f9f:	e9 a6 fa ff ff       	jmp    80105a4a <alltraps>

80105fa4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105fa4:	6a 0b                	push   $0xb
  jmp alltraps
80105fa6:	e9 9f fa ff ff       	jmp    80105a4a <alltraps>

80105fab <vector12>:
.globl vector12
vector12:
  pushl $12
80105fab:	6a 0c                	push   $0xc
  jmp alltraps
80105fad:	e9 98 fa ff ff       	jmp    80105a4a <alltraps>

80105fb2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105fb2:	6a 0d                	push   $0xd
  jmp alltraps
80105fb4:	e9 91 fa ff ff       	jmp    80105a4a <alltraps>

80105fb9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105fb9:	6a 0e                	push   $0xe
  jmp alltraps
80105fbb:	e9 8a fa ff ff       	jmp    80105a4a <alltraps>

80105fc0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $15
80105fc2:	6a 0f                	push   $0xf
  jmp alltraps
80105fc4:	e9 81 fa ff ff       	jmp    80105a4a <alltraps>

80105fc9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $16
80105fcb:	6a 10                	push   $0x10
  jmp alltraps
80105fcd:	e9 78 fa ff ff       	jmp    80105a4a <alltraps>

80105fd2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105fd2:	6a 11                	push   $0x11
  jmp alltraps
80105fd4:	e9 71 fa ff ff       	jmp    80105a4a <alltraps>

80105fd9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $18
80105fdb:	6a 12                	push   $0x12
  jmp alltraps
80105fdd:	e9 68 fa ff ff       	jmp    80105a4a <alltraps>

80105fe2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $19
80105fe4:	6a 13                	push   $0x13
  jmp alltraps
80105fe6:	e9 5f fa ff ff       	jmp    80105a4a <alltraps>

80105feb <vector20>:
.globl vector20
vector20:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $20
80105fed:	6a 14                	push   $0x14
  jmp alltraps
80105fef:	e9 56 fa ff ff       	jmp    80105a4a <alltraps>

80105ff4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $21
80105ff6:	6a 15                	push   $0x15
  jmp alltraps
80105ff8:	e9 4d fa ff ff       	jmp    80105a4a <alltraps>

80105ffd <vector22>:
.globl vector22
vector22:
  pushl $0
80105ffd:	6a 00                	push   $0x0
  pushl $22
80105fff:	6a 16                	push   $0x16
  jmp alltraps
80106001:	e9 44 fa ff ff       	jmp    80105a4a <alltraps>

80106006 <vector23>:
.globl vector23
vector23:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $23
80106008:	6a 17                	push   $0x17
  jmp alltraps
8010600a:	e9 3b fa ff ff       	jmp    80105a4a <alltraps>

8010600f <vector24>:
.globl vector24
vector24:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $24
80106011:	6a 18                	push   $0x18
  jmp alltraps
80106013:	e9 32 fa ff ff       	jmp    80105a4a <alltraps>

80106018 <vector25>:
.globl vector25
vector25:
  pushl $0
80106018:	6a 00                	push   $0x0
  pushl $25
8010601a:	6a 19                	push   $0x19
  jmp alltraps
8010601c:	e9 29 fa ff ff       	jmp    80105a4a <alltraps>

80106021 <vector26>:
.globl vector26
vector26:
  pushl $0
80106021:	6a 00                	push   $0x0
  pushl $26
80106023:	6a 1a                	push   $0x1a
  jmp alltraps
80106025:	e9 20 fa ff ff       	jmp    80105a4a <alltraps>

8010602a <vector27>:
.globl vector27
vector27:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $27
8010602c:	6a 1b                	push   $0x1b
  jmp alltraps
8010602e:	e9 17 fa ff ff       	jmp    80105a4a <alltraps>

80106033 <vector28>:
.globl vector28
vector28:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $28
80106035:	6a 1c                	push   $0x1c
  jmp alltraps
80106037:	e9 0e fa ff ff       	jmp    80105a4a <alltraps>

8010603c <vector29>:
.globl vector29
vector29:
  pushl $0
8010603c:	6a 00                	push   $0x0
  pushl $29
8010603e:	6a 1d                	push   $0x1d
  jmp alltraps
80106040:	e9 05 fa ff ff       	jmp    80105a4a <alltraps>

80106045 <vector30>:
.globl vector30
vector30:
  pushl $0
80106045:	6a 00                	push   $0x0
  pushl $30
80106047:	6a 1e                	push   $0x1e
  jmp alltraps
80106049:	e9 fc f9 ff ff       	jmp    80105a4a <alltraps>

8010604e <vector31>:
.globl vector31
vector31:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $31
80106050:	6a 1f                	push   $0x1f
  jmp alltraps
80106052:	e9 f3 f9 ff ff       	jmp    80105a4a <alltraps>

80106057 <vector32>:
.globl vector32
vector32:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $32
80106059:	6a 20                	push   $0x20
  jmp alltraps
8010605b:	e9 ea f9 ff ff       	jmp    80105a4a <alltraps>

80106060 <vector33>:
.globl vector33
vector33:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $33
80106062:	6a 21                	push   $0x21
  jmp alltraps
80106064:	e9 e1 f9 ff ff       	jmp    80105a4a <alltraps>

80106069 <vector34>:
.globl vector34
vector34:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $34
8010606b:	6a 22                	push   $0x22
  jmp alltraps
8010606d:	e9 d8 f9 ff ff       	jmp    80105a4a <alltraps>

80106072 <vector35>:
.globl vector35
vector35:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $35
80106074:	6a 23                	push   $0x23
  jmp alltraps
80106076:	e9 cf f9 ff ff       	jmp    80105a4a <alltraps>

8010607b <vector36>:
.globl vector36
vector36:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $36
8010607d:	6a 24                	push   $0x24
  jmp alltraps
8010607f:	e9 c6 f9 ff ff       	jmp    80105a4a <alltraps>

80106084 <vector37>:
.globl vector37
vector37:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $37
80106086:	6a 25                	push   $0x25
  jmp alltraps
80106088:	e9 bd f9 ff ff       	jmp    80105a4a <alltraps>

8010608d <vector38>:
.globl vector38
vector38:
  pushl $0
8010608d:	6a 00                	push   $0x0
  pushl $38
8010608f:	6a 26                	push   $0x26
  jmp alltraps
80106091:	e9 b4 f9 ff ff       	jmp    80105a4a <alltraps>

80106096 <vector39>:
.globl vector39
vector39:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $39
80106098:	6a 27                	push   $0x27
  jmp alltraps
8010609a:	e9 ab f9 ff ff       	jmp    80105a4a <alltraps>

8010609f <vector40>:
.globl vector40
vector40:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $40
801060a1:	6a 28                	push   $0x28
  jmp alltraps
801060a3:	e9 a2 f9 ff ff       	jmp    80105a4a <alltraps>

801060a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801060a8:	6a 00                	push   $0x0
  pushl $41
801060aa:	6a 29                	push   $0x29
  jmp alltraps
801060ac:	e9 99 f9 ff ff       	jmp    80105a4a <alltraps>

801060b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801060b1:	6a 00                	push   $0x0
  pushl $42
801060b3:	6a 2a                	push   $0x2a
  jmp alltraps
801060b5:	e9 90 f9 ff ff       	jmp    80105a4a <alltraps>

801060ba <vector43>:
.globl vector43
vector43:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $43
801060bc:	6a 2b                	push   $0x2b
  jmp alltraps
801060be:	e9 87 f9 ff ff       	jmp    80105a4a <alltraps>

801060c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $44
801060c5:	6a 2c                	push   $0x2c
  jmp alltraps
801060c7:	e9 7e f9 ff ff       	jmp    80105a4a <alltraps>

801060cc <vector45>:
.globl vector45
vector45:
  pushl $0
801060cc:	6a 00                	push   $0x0
  pushl $45
801060ce:	6a 2d                	push   $0x2d
  jmp alltraps
801060d0:	e9 75 f9 ff ff       	jmp    80105a4a <alltraps>

801060d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $46
801060d7:	6a 2e                	push   $0x2e
  jmp alltraps
801060d9:	e9 6c f9 ff ff       	jmp    80105a4a <alltraps>

801060de <vector47>:
.globl vector47
vector47:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $47
801060e0:	6a 2f                	push   $0x2f
  jmp alltraps
801060e2:	e9 63 f9 ff ff       	jmp    80105a4a <alltraps>

801060e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $48
801060e9:	6a 30                	push   $0x30
  jmp alltraps
801060eb:	e9 5a f9 ff ff       	jmp    80105a4a <alltraps>

801060f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $49
801060f2:	6a 31                	push   $0x31
  jmp alltraps
801060f4:	e9 51 f9 ff ff       	jmp    80105a4a <alltraps>

801060f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $50
801060fb:	6a 32                	push   $0x32
  jmp alltraps
801060fd:	e9 48 f9 ff ff       	jmp    80105a4a <alltraps>

80106102 <vector51>:
.globl vector51
vector51:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $51
80106104:	6a 33                	push   $0x33
  jmp alltraps
80106106:	e9 3f f9 ff ff       	jmp    80105a4a <alltraps>

8010610b <vector52>:
.globl vector52
vector52:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $52
8010610d:	6a 34                	push   $0x34
  jmp alltraps
8010610f:	e9 36 f9 ff ff       	jmp    80105a4a <alltraps>

80106114 <vector53>:
.globl vector53
vector53:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $53
80106116:	6a 35                	push   $0x35
  jmp alltraps
80106118:	e9 2d f9 ff ff       	jmp    80105a4a <alltraps>

8010611d <vector54>:
.globl vector54
vector54:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $54
8010611f:	6a 36                	push   $0x36
  jmp alltraps
80106121:	e9 24 f9 ff ff       	jmp    80105a4a <alltraps>

80106126 <vector55>:
.globl vector55
vector55:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $55
80106128:	6a 37                	push   $0x37
  jmp alltraps
8010612a:	e9 1b f9 ff ff       	jmp    80105a4a <alltraps>

8010612f <vector56>:
.globl vector56
vector56:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $56
80106131:	6a 38                	push   $0x38
  jmp alltraps
80106133:	e9 12 f9 ff ff       	jmp    80105a4a <alltraps>

80106138 <vector57>:
.globl vector57
vector57:
  pushl $0
80106138:	6a 00                	push   $0x0
  pushl $57
8010613a:	6a 39                	push   $0x39
  jmp alltraps
8010613c:	e9 09 f9 ff ff       	jmp    80105a4a <alltraps>

80106141 <vector58>:
.globl vector58
vector58:
  pushl $0
80106141:	6a 00                	push   $0x0
  pushl $58
80106143:	6a 3a                	push   $0x3a
  jmp alltraps
80106145:	e9 00 f9 ff ff       	jmp    80105a4a <alltraps>

8010614a <vector59>:
.globl vector59
vector59:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $59
8010614c:	6a 3b                	push   $0x3b
  jmp alltraps
8010614e:	e9 f7 f8 ff ff       	jmp    80105a4a <alltraps>

80106153 <vector60>:
.globl vector60
vector60:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $60
80106155:	6a 3c                	push   $0x3c
  jmp alltraps
80106157:	e9 ee f8 ff ff       	jmp    80105a4a <alltraps>

8010615c <vector61>:
.globl vector61
vector61:
  pushl $0
8010615c:	6a 00                	push   $0x0
  pushl $61
8010615e:	6a 3d                	push   $0x3d
  jmp alltraps
80106160:	e9 e5 f8 ff ff       	jmp    80105a4a <alltraps>

80106165 <vector62>:
.globl vector62
vector62:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $62
80106167:	6a 3e                	push   $0x3e
  jmp alltraps
80106169:	e9 dc f8 ff ff       	jmp    80105a4a <alltraps>

8010616e <vector63>:
.globl vector63
vector63:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $63
80106170:	6a 3f                	push   $0x3f
  jmp alltraps
80106172:	e9 d3 f8 ff ff       	jmp    80105a4a <alltraps>

80106177 <vector64>:
.globl vector64
vector64:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $64
80106179:	6a 40                	push   $0x40
  jmp alltraps
8010617b:	e9 ca f8 ff ff       	jmp    80105a4a <alltraps>

80106180 <vector65>:
.globl vector65
vector65:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $65
80106182:	6a 41                	push   $0x41
  jmp alltraps
80106184:	e9 c1 f8 ff ff       	jmp    80105a4a <alltraps>

80106189 <vector66>:
.globl vector66
vector66:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $66
8010618b:	6a 42                	push   $0x42
  jmp alltraps
8010618d:	e9 b8 f8 ff ff       	jmp    80105a4a <alltraps>

80106192 <vector67>:
.globl vector67
vector67:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $67
80106194:	6a 43                	push   $0x43
  jmp alltraps
80106196:	e9 af f8 ff ff       	jmp    80105a4a <alltraps>

8010619b <vector68>:
.globl vector68
vector68:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $68
8010619d:	6a 44                	push   $0x44
  jmp alltraps
8010619f:	e9 a6 f8 ff ff       	jmp    80105a4a <alltraps>

801061a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $69
801061a6:	6a 45                	push   $0x45
  jmp alltraps
801061a8:	e9 9d f8 ff ff       	jmp    80105a4a <alltraps>

801061ad <vector70>:
.globl vector70
vector70:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $70
801061af:	6a 46                	push   $0x46
  jmp alltraps
801061b1:	e9 94 f8 ff ff       	jmp    80105a4a <alltraps>

801061b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $71
801061b8:	6a 47                	push   $0x47
  jmp alltraps
801061ba:	e9 8b f8 ff ff       	jmp    80105a4a <alltraps>

801061bf <vector72>:
.globl vector72
vector72:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $72
801061c1:	6a 48                	push   $0x48
  jmp alltraps
801061c3:	e9 82 f8 ff ff       	jmp    80105a4a <alltraps>

801061c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $73
801061ca:	6a 49                	push   $0x49
  jmp alltraps
801061cc:	e9 79 f8 ff ff       	jmp    80105a4a <alltraps>

801061d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $74
801061d3:	6a 4a                	push   $0x4a
  jmp alltraps
801061d5:	e9 70 f8 ff ff       	jmp    80105a4a <alltraps>

801061da <vector75>:
.globl vector75
vector75:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $75
801061dc:	6a 4b                	push   $0x4b
  jmp alltraps
801061de:	e9 67 f8 ff ff       	jmp    80105a4a <alltraps>

801061e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $76
801061e5:	6a 4c                	push   $0x4c
  jmp alltraps
801061e7:	e9 5e f8 ff ff       	jmp    80105a4a <alltraps>

801061ec <vector77>:
.globl vector77
vector77:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $77
801061ee:	6a 4d                	push   $0x4d
  jmp alltraps
801061f0:	e9 55 f8 ff ff       	jmp    80105a4a <alltraps>

801061f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $78
801061f7:	6a 4e                	push   $0x4e
  jmp alltraps
801061f9:	e9 4c f8 ff ff       	jmp    80105a4a <alltraps>

801061fe <vector79>:
.globl vector79
vector79:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $79
80106200:	6a 4f                	push   $0x4f
  jmp alltraps
80106202:	e9 43 f8 ff ff       	jmp    80105a4a <alltraps>

80106207 <vector80>:
.globl vector80
vector80:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $80
80106209:	6a 50                	push   $0x50
  jmp alltraps
8010620b:	e9 3a f8 ff ff       	jmp    80105a4a <alltraps>

80106210 <vector81>:
.globl vector81
vector81:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $81
80106212:	6a 51                	push   $0x51
  jmp alltraps
80106214:	e9 31 f8 ff ff       	jmp    80105a4a <alltraps>

80106219 <vector82>:
.globl vector82
vector82:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $82
8010621b:	6a 52                	push   $0x52
  jmp alltraps
8010621d:	e9 28 f8 ff ff       	jmp    80105a4a <alltraps>

80106222 <vector83>:
.globl vector83
vector83:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $83
80106224:	6a 53                	push   $0x53
  jmp alltraps
80106226:	e9 1f f8 ff ff       	jmp    80105a4a <alltraps>

8010622b <vector84>:
.globl vector84
vector84:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $84
8010622d:	6a 54                	push   $0x54
  jmp alltraps
8010622f:	e9 16 f8 ff ff       	jmp    80105a4a <alltraps>

80106234 <vector85>:
.globl vector85
vector85:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $85
80106236:	6a 55                	push   $0x55
  jmp alltraps
80106238:	e9 0d f8 ff ff       	jmp    80105a4a <alltraps>

8010623d <vector86>:
.globl vector86
vector86:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $86
8010623f:	6a 56                	push   $0x56
  jmp alltraps
80106241:	e9 04 f8 ff ff       	jmp    80105a4a <alltraps>

80106246 <vector87>:
.globl vector87
vector87:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $87
80106248:	6a 57                	push   $0x57
  jmp alltraps
8010624a:	e9 fb f7 ff ff       	jmp    80105a4a <alltraps>

8010624f <vector88>:
.globl vector88
vector88:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $88
80106251:	6a 58                	push   $0x58
  jmp alltraps
80106253:	e9 f2 f7 ff ff       	jmp    80105a4a <alltraps>

80106258 <vector89>:
.globl vector89
vector89:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $89
8010625a:	6a 59                	push   $0x59
  jmp alltraps
8010625c:	e9 e9 f7 ff ff       	jmp    80105a4a <alltraps>

80106261 <vector90>:
.globl vector90
vector90:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $90
80106263:	6a 5a                	push   $0x5a
  jmp alltraps
80106265:	e9 e0 f7 ff ff       	jmp    80105a4a <alltraps>

8010626a <vector91>:
.globl vector91
vector91:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $91
8010626c:	6a 5b                	push   $0x5b
  jmp alltraps
8010626e:	e9 d7 f7 ff ff       	jmp    80105a4a <alltraps>

80106273 <vector92>:
.globl vector92
vector92:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $92
80106275:	6a 5c                	push   $0x5c
  jmp alltraps
80106277:	e9 ce f7 ff ff       	jmp    80105a4a <alltraps>

8010627c <vector93>:
.globl vector93
vector93:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $93
8010627e:	6a 5d                	push   $0x5d
  jmp alltraps
80106280:	e9 c5 f7 ff ff       	jmp    80105a4a <alltraps>

80106285 <vector94>:
.globl vector94
vector94:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $94
80106287:	6a 5e                	push   $0x5e
  jmp alltraps
80106289:	e9 bc f7 ff ff       	jmp    80105a4a <alltraps>

8010628e <vector95>:
.globl vector95
vector95:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $95
80106290:	6a 5f                	push   $0x5f
  jmp alltraps
80106292:	e9 b3 f7 ff ff       	jmp    80105a4a <alltraps>

80106297 <vector96>:
.globl vector96
vector96:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $96
80106299:	6a 60                	push   $0x60
  jmp alltraps
8010629b:	e9 aa f7 ff ff       	jmp    80105a4a <alltraps>

801062a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $97
801062a2:	6a 61                	push   $0x61
  jmp alltraps
801062a4:	e9 a1 f7 ff ff       	jmp    80105a4a <alltraps>

801062a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $98
801062ab:	6a 62                	push   $0x62
  jmp alltraps
801062ad:	e9 98 f7 ff ff       	jmp    80105a4a <alltraps>

801062b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $99
801062b4:	6a 63                	push   $0x63
  jmp alltraps
801062b6:	e9 8f f7 ff ff       	jmp    80105a4a <alltraps>

801062bb <vector100>:
.globl vector100
vector100:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $100
801062bd:	6a 64                	push   $0x64
  jmp alltraps
801062bf:	e9 86 f7 ff ff       	jmp    80105a4a <alltraps>

801062c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $101
801062c6:	6a 65                	push   $0x65
  jmp alltraps
801062c8:	e9 7d f7 ff ff       	jmp    80105a4a <alltraps>

801062cd <vector102>:
.globl vector102
vector102:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $102
801062cf:	6a 66                	push   $0x66
  jmp alltraps
801062d1:	e9 74 f7 ff ff       	jmp    80105a4a <alltraps>

801062d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $103
801062d8:	6a 67                	push   $0x67
  jmp alltraps
801062da:	e9 6b f7 ff ff       	jmp    80105a4a <alltraps>

801062df <vector104>:
.globl vector104
vector104:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $104
801062e1:	6a 68                	push   $0x68
  jmp alltraps
801062e3:	e9 62 f7 ff ff       	jmp    80105a4a <alltraps>

801062e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $105
801062ea:	6a 69                	push   $0x69
  jmp alltraps
801062ec:	e9 59 f7 ff ff       	jmp    80105a4a <alltraps>

801062f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $106
801062f3:	6a 6a                	push   $0x6a
  jmp alltraps
801062f5:	e9 50 f7 ff ff       	jmp    80105a4a <alltraps>

801062fa <vector107>:
.globl vector107
vector107:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $107
801062fc:	6a 6b                	push   $0x6b
  jmp alltraps
801062fe:	e9 47 f7 ff ff       	jmp    80105a4a <alltraps>

80106303 <vector108>:
.globl vector108
vector108:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $108
80106305:	6a 6c                	push   $0x6c
  jmp alltraps
80106307:	e9 3e f7 ff ff       	jmp    80105a4a <alltraps>

8010630c <vector109>:
.globl vector109
vector109:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $109
8010630e:	6a 6d                	push   $0x6d
  jmp alltraps
80106310:	e9 35 f7 ff ff       	jmp    80105a4a <alltraps>

80106315 <vector110>:
.globl vector110
vector110:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $110
80106317:	6a 6e                	push   $0x6e
  jmp alltraps
80106319:	e9 2c f7 ff ff       	jmp    80105a4a <alltraps>

8010631e <vector111>:
.globl vector111
vector111:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $111
80106320:	6a 6f                	push   $0x6f
  jmp alltraps
80106322:	e9 23 f7 ff ff       	jmp    80105a4a <alltraps>

80106327 <vector112>:
.globl vector112
vector112:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $112
80106329:	6a 70                	push   $0x70
  jmp alltraps
8010632b:	e9 1a f7 ff ff       	jmp    80105a4a <alltraps>

80106330 <vector113>:
.globl vector113
vector113:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $113
80106332:	6a 71                	push   $0x71
  jmp alltraps
80106334:	e9 11 f7 ff ff       	jmp    80105a4a <alltraps>

80106339 <vector114>:
.globl vector114
vector114:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $114
8010633b:	6a 72                	push   $0x72
  jmp alltraps
8010633d:	e9 08 f7 ff ff       	jmp    80105a4a <alltraps>

80106342 <vector115>:
.globl vector115
vector115:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $115
80106344:	6a 73                	push   $0x73
  jmp alltraps
80106346:	e9 ff f6 ff ff       	jmp    80105a4a <alltraps>

8010634b <vector116>:
.globl vector116
vector116:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $116
8010634d:	6a 74                	push   $0x74
  jmp alltraps
8010634f:	e9 f6 f6 ff ff       	jmp    80105a4a <alltraps>

80106354 <vector117>:
.globl vector117
vector117:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $117
80106356:	6a 75                	push   $0x75
  jmp alltraps
80106358:	e9 ed f6 ff ff       	jmp    80105a4a <alltraps>

8010635d <vector118>:
.globl vector118
vector118:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $118
8010635f:	6a 76                	push   $0x76
  jmp alltraps
80106361:	e9 e4 f6 ff ff       	jmp    80105a4a <alltraps>

80106366 <vector119>:
.globl vector119
vector119:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $119
80106368:	6a 77                	push   $0x77
  jmp alltraps
8010636a:	e9 db f6 ff ff       	jmp    80105a4a <alltraps>

8010636f <vector120>:
.globl vector120
vector120:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $120
80106371:	6a 78                	push   $0x78
  jmp alltraps
80106373:	e9 d2 f6 ff ff       	jmp    80105a4a <alltraps>

80106378 <vector121>:
.globl vector121
vector121:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $121
8010637a:	6a 79                	push   $0x79
  jmp alltraps
8010637c:	e9 c9 f6 ff ff       	jmp    80105a4a <alltraps>

80106381 <vector122>:
.globl vector122
vector122:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $122
80106383:	6a 7a                	push   $0x7a
  jmp alltraps
80106385:	e9 c0 f6 ff ff       	jmp    80105a4a <alltraps>

8010638a <vector123>:
.globl vector123
vector123:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $123
8010638c:	6a 7b                	push   $0x7b
  jmp alltraps
8010638e:	e9 b7 f6 ff ff       	jmp    80105a4a <alltraps>

80106393 <vector124>:
.globl vector124
vector124:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $124
80106395:	6a 7c                	push   $0x7c
  jmp alltraps
80106397:	e9 ae f6 ff ff       	jmp    80105a4a <alltraps>

8010639c <vector125>:
.globl vector125
vector125:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $125
8010639e:	6a 7d                	push   $0x7d
  jmp alltraps
801063a0:	e9 a5 f6 ff ff       	jmp    80105a4a <alltraps>

801063a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $126
801063a7:	6a 7e                	push   $0x7e
  jmp alltraps
801063a9:	e9 9c f6 ff ff       	jmp    80105a4a <alltraps>

801063ae <vector127>:
.globl vector127
vector127:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $127
801063b0:	6a 7f                	push   $0x7f
  jmp alltraps
801063b2:	e9 93 f6 ff ff       	jmp    80105a4a <alltraps>

801063b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $128
801063b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801063be:	e9 87 f6 ff ff       	jmp    80105a4a <alltraps>

801063c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $129
801063c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801063ca:	e9 7b f6 ff ff       	jmp    80105a4a <alltraps>

801063cf <vector130>:
.globl vector130
vector130:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $130
801063d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801063d6:	e9 6f f6 ff ff       	jmp    80105a4a <alltraps>

801063db <vector131>:
.globl vector131
vector131:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $131
801063dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801063e2:	e9 63 f6 ff ff       	jmp    80105a4a <alltraps>

801063e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $132
801063e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801063ee:	e9 57 f6 ff ff       	jmp    80105a4a <alltraps>

801063f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $133
801063f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801063fa:	e9 4b f6 ff ff       	jmp    80105a4a <alltraps>

801063ff <vector134>:
.globl vector134
vector134:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $134
80106401:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106406:	e9 3f f6 ff ff       	jmp    80105a4a <alltraps>

8010640b <vector135>:
.globl vector135
vector135:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $135
8010640d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106412:	e9 33 f6 ff ff       	jmp    80105a4a <alltraps>

80106417 <vector136>:
.globl vector136
vector136:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $136
80106419:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010641e:	e9 27 f6 ff ff       	jmp    80105a4a <alltraps>

80106423 <vector137>:
.globl vector137
vector137:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $137
80106425:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010642a:	e9 1b f6 ff ff       	jmp    80105a4a <alltraps>

8010642f <vector138>:
.globl vector138
vector138:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $138
80106431:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106436:	e9 0f f6 ff ff       	jmp    80105a4a <alltraps>

8010643b <vector139>:
.globl vector139
vector139:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $139
8010643d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106442:	e9 03 f6 ff ff       	jmp    80105a4a <alltraps>

80106447 <vector140>:
.globl vector140
vector140:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $140
80106449:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010644e:	e9 f7 f5 ff ff       	jmp    80105a4a <alltraps>

80106453 <vector141>:
.globl vector141
vector141:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $141
80106455:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010645a:	e9 eb f5 ff ff       	jmp    80105a4a <alltraps>

8010645f <vector142>:
.globl vector142
vector142:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $142
80106461:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106466:	e9 df f5 ff ff       	jmp    80105a4a <alltraps>

8010646b <vector143>:
.globl vector143
vector143:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $143
8010646d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106472:	e9 d3 f5 ff ff       	jmp    80105a4a <alltraps>

80106477 <vector144>:
.globl vector144
vector144:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $144
80106479:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010647e:	e9 c7 f5 ff ff       	jmp    80105a4a <alltraps>

80106483 <vector145>:
.globl vector145
vector145:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $145
80106485:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010648a:	e9 bb f5 ff ff       	jmp    80105a4a <alltraps>

8010648f <vector146>:
.globl vector146
vector146:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $146
80106491:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106496:	e9 af f5 ff ff       	jmp    80105a4a <alltraps>

8010649b <vector147>:
.globl vector147
vector147:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $147
8010649d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801064a2:	e9 a3 f5 ff ff       	jmp    80105a4a <alltraps>

801064a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $148
801064a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801064ae:	e9 97 f5 ff ff       	jmp    80105a4a <alltraps>

801064b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $149
801064b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801064ba:	e9 8b f5 ff ff       	jmp    80105a4a <alltraps>

801064bf <vector150>:
.globl vector150
vector150:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $150
801064c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801064c6:	e9 7f f5 ff ff       	jmp    80105a4a <alltraps>

801064cb <vector151>:
.globl vector151
vector151:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $151
801064cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801064d2:	e9 73 f5 ff ff       	jmp    80105a4a <alltraps>

801064d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $152
801064d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801064de:	e9 67 f5 ff ff       	jmp    80105a4a <alltraps>

801064e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $153
801064e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801064ea:	e9 5b f5 ff ff       	jmp    80105a4a <alltraps>

801064ef <vector154>:
.globl vector154
vector154:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $154
801064f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801064f6:	e9 4f f5 ff ff       	jmp    80105a4a <alltraps>

801064fb <vector155>:
.globl vector155
vector155:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $155
801064fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106502:	e9 43 f5 ff ff       	jmp    80105a4a <alltraps>

80106507 <vector156>:
.globl vector156
vector156:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $156
80106509:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010650e:	e9 37 f5 ff ff       	jmp    80105a4a <alltraps>

80106513 <vector157>:
.globl vector157
vector157:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $157
80106515:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010651a:	e9 2b f5 ff ff       	jmp    80105a4a <alltraps>

8010651f <vector158>:
.globl vector158
vector158:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $158
80106521:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106526:	e9 1f f5 ff ff       	jmp    80105a4a <alltraps>

8010652b <vector159>:
.globl vector159
vector159:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $159
8010652d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106532:	e9 13 f5 ff ff       	jmp    80105a4a <alltraps>

80106537 <vector160>:
.globl vector160
vector160:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $160
80106539:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010653e:	e9 07 f5 ff ff       	jmp    80105a4a <alltraps>

80106543 <vector161>:
.globl vector161
vector161:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $161
80106545:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010654a:	e9 fb f4 ff ff       	jmp    80105a4a <alltraps>

8010654f <vector162>:
.globl vector162
vector162:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $162
80106551:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106556:	e9 ef f4 ff ff       	jmp    80105a4a <alltraps>

8010655b <vector163>:
.globl vector163
vector163:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $163
8010655d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106562:	e9 e3 f4 ff ff       	jmp    80105a4a <alltraps>

80106567 <vector164>:
.globl vector164
vector164:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $164
80106569:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010656e:	e9 d7 f4 ff ff       	jmp    80105a4a <alltraps>

80106573 <vector165>:
.globl vector165
vector165:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $165
80106575:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010657a:	e9 cb f4 ff ff       	jmp    80105a4a <alltraps>

8010657f <vector166>:
.globl vector166
vector166:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $166
80106581:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106586:	e9 bf f4 ff ff       	jmp    80105a4a <alltraps>

8010658b <vector167>:
.globl vector167
vector167:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $167
8010658d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106592:	e9 b3 f4 ff ff       	jmp    80105a4a <alltraps>

80106597 <vector168>:
.globl vector168
vector168:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $168
80106599:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010659e:	e9 a7 f4 ff ff       	jmp    80105a4a <alltraps>

801065a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $169
801065a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801065aa:	e9 9b f4 ff ff       	jmp    80105a4a <alltraps>

801065af <vector170>:
.globl vector170
vector170:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $170
801065b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801065b6:	e9 8f f4 ff ff       	jmp    80105a4a <alltraps>

801065bb <vector171>:
.globl vector171
vector171:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $171
801065bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801065c2:	e9 83 f4 ff ff       	jmp    80105a4a <alltraps>

801065c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $172
801065c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801065ce:	e9 77 f4 ff ff       	jmp    80105a4a <alltraps>

801065d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $173
801065d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801065da:	e9 6b f4 ff ff       	jmp    80105a4a <alltraps>

801065df <vector174>:
.globl vector174
vector174:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $174
801065e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801065e6:	e9 5f f4 ff ff       	jmp    80105a4a <alltraps>

801065eb <vector175>:
.globl vector175
vector175:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $175
801065ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801065f2:	e9 53 f4 ff ff       	jmp    80105a4a <alltraps>

801065f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $176
801065f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801065fe:	e9 47 f4 ff ff       	jmp    80105a4a <alltraps>

80106603 <vector177>:
.globl vector177
vector177:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $177
80106605:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010660a:	e9 3b f4 ff ff       	jmp    80105a4a <alltraps>

8010660f <vector178>:
.globl vector178
vector178:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $178
80106611:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106616:	e9 2f f4 ff ff       	jmp    80105a4a <alltraps>

8010661b <vector179>:
.globl vector179
vector179:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $179
8010661d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106622:	e9 23 f4 ff ff       	jmp    80105a4a <alltraps>

80106627 <vector180>:
.globl vector180
vector180:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $180
80106629:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010662e:	e9 17 f4 ff ff       	jmp    80105a4a <alltraps>

80106633 <vector181>:
.globl vector181
vector181:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $181
80106635:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010663a:	e9 0b f4 ff ff       	jmp    80105a4a <alltraps>

8010663f <vector182>:
.globl vector182
vector182:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $182
80106641:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106646:	e9 ff f3 ff ff       	jmp    80105a4a <alltraps>

8010664b <vector183>:
.globl vector183
vector183:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $183
8010664d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106652:	e9 f3 f3 ff ff       	jmp    80105a4a <alltraps>

80106657 <vector184>:
.globl vector184
vector184:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $184
80106659:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010665e:	e9 e7 f3 ff ff       	jmp    80105a4a <alltraps>

80106663 <vector185>:
.globl vector185
vector185:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $185
80106665:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010666a:	e9 db f3 ff ff       	jmp    80105a4a <alltraps>

8010666f <vector186>:
.globl vector186
vector186:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $186
80106671:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106676:	e9 cf f3 ff ff       	jmp    80105a4a <alltraps>

8010667b <vector187>:
.globl vector187
vector187:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $187
8010667d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106682:	e9 c3 f3 ff ff       	jmp    80105a4a <alltraps>

80106687 <vector188>:
.globl vector188
vector188:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $188
80106689:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010668e:	e9 b7 f3 ff ff       	jmp    80105a4a <alltraps>

80106693 <vector189>:
.globl vector189
vector189:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $189
80106695:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010669a:	e9 ab f3 ff ff       	jmp    80105a4a <alltraps>

8010669f <vector190>:
.globl vector190
vector190:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $190
801066a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801066a6:	e9 9f f3 ff ff       	jmp    80105a4a <alltraps>

801066ab <vector191>:
.globl vector191
vector191:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $191
801066ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801066b2:	e9 93 f3 ff ff       	jmp    80105a4a <alltraps>

801066b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $192
801066b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801066be:	e9 87 f3 ff ff       	jmp    80105a4a <alltraps>

801066c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $193
801066c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801066ca:	e9 7b f3 ff ff       	jmp    80105a4a <alltraps>

801066cf <vector194>:
.globl vector194
vector194:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $194
801066d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801066d6:	e9 6f f3 ff ff       	jmp    80105a4a <alltraps>

801066db <vector195>:
.globl vector195
vector195:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $195
801066dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801066e2:	e9 63 f3 ff ff       	jmp    80105a4a <alltraps>

801066e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $196
801066e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801066ee:	e9 57 f3 ff ff       	jmp    80105a4a <alltraps>

801066f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $197
801066f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801066fa:	e9 4b f3 ff ff       	jmp    80105a4a <alltraps>

801066ff <vector198>:
.globl vector198
vector198:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $198
80106701:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106706:	e9 3f f3 ff ff       	jmp    80105a4a <alltraps>

8010670b <vector199>:
.globl vector199
vector199:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $199
8010670d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106712:	e9 33 f3 ff ff       	jmp    80105a4a <alltraps>

80106717 <vector200>:
.globl vector200
vector200:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $200
80106719:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010671e:	e9 27 f3 ff ff       	jmp    80105a4a <alltraps>

80106723 <vector201>:
.globl vector201
vector201:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $201
80106725:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010672a:	e9 1b f3 ff ff       	jmp    80105a4a <alltraps>

8010672f <vector202>:
.globl vector202
vector202:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $202
80106731:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106736:	e9 0f f3 ff ff       	jmp    80105a4a <alltraps>

8010673b <vector203>:
.globl vector203
vector203:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $203
8010673d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106742:	e9 03 f3 ff ff       	jmp    80105a4a <alltraps>

80106747 <vector204>:
.globl vector204
vector204:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $204
80106749:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010674e:	e9 f7 f2 ff ff       	jmp    80105a4a <alltraps>

80106753 <vector205>:
.globl vector205
vector205:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $205
80106755:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010675a:	e9 eb f2 ff ff       	jmp    80105a4a <alltraps>

8010675f <vector206>:
.globl vector206
vector206:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $206
80106761:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106766:	e9 df f2 ff ff       	jmp    80105a4a <alltraps>

8010676b <vector207>:
.globl vector207
vector207:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $207
8010676d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106772:	e9 d3 f2 ff ff       	jmp    80105a4a <alltraps>

80106777 <vector208>:
.globl vector208
vector208:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $208
80106779:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010677e:	e9 c7 f2 ff ff       	jmp    80105a4a <alltraps>

80106783 <vector209>:
.globl vector209
vector209:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $209
80106785:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010678a:	e9 bb f2 ff ff       	jmp    80105a4a <alltraps>

8010678f <vector210>:
.globl vector210
vector210:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $210
80106791:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106796:	e9 af f2 ff ff       	jmp    80105a4a <alltraps>

8010679b <vector211>:
.globl vector211
vector211:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $211
8010679d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801067a2:	e9 a3 f2 ff ff       	jmp    80105a4a <alltraps>

801067a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $212
801067a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801067ae:	e9 97 f2 ff ff       	jmp    80105a4a <alltraps>

801067b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $213
801067b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801067ba:	e9 8b f2 ff ff       	jmp    80105a4a <alltraps>

801067bf <vector214>:
.globl vector214
vector214:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $214
801067c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801067c6:	e9 7f f2 ff ff       	jmp    80105a4a <alltraps>

801067cb <vector215>:
.globl vector215
vector215:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $215
801067cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801067d2:	e9 73 f2 ff ff       	jmp    80105a4a <alltraps>

801067d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $216
801067d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801067de:	e9 67 f2 ff ff       	jmp    80105a4a <alltraps>

801067e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $217
801067e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801067ea:	e9 5b f2 ff ff       	jmp    80105a4a <alltraps>

801067ef <vector218>:
.globl vector218
vector218:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $218
801067f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801067f6:	e9 4f f2 ff ff       	jmp    80105a4a <alltraps>

801067fb <vector219>:
.globl vector219
vector219:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $219
801067fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106802:	e9 43 f2 ff ff       	jmp    80105a4a <alltraps>

80106807 <vector220>:
.globl vector220
vector220:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $220
80106809:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010680e:	e9 37 f2 ff ff       	jmp    80105a4a <alltraps>

80106813 <vector221>:
.globl vector221
vector221:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $221
80106815:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010681a:	e9 2b f2 ff ff       	jmp    80105a4a <alltraps>

8010681f <vector222>:
.globl vector222
vector222:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $222
80106821:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106826:	e9 1f f2 ff ff       	jmp    80105a4a <alltraps>

8010682b <vector223>:
.globl vector223
vector223:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $223
8010682d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106832:	e9 13 f2 ff ff       	jmp    80105a4a <alltraps>

80106837 <vector224>:
.globl vector224
vector224:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $224
80106839:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010683e:	e9 07 f2 ff ff       	jmp    80105a4a <alltraps>

80106843 <vector225>:
.globl vector225
vector225:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $225
80106845:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010684a:	e9 fb f1 ff ff       	jmp    80105a4a <alltraps>

8010684f <vector226>:
.globl vector226
vector226:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $226
80106851:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106856:	e9 ef f1 ff ff       	jmp    80105a4a <alltraps>

8010685b <vector227>:
.globl vector227
vector227:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $227
8010685d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106862:	e9 e3 f1 ff ff       	jmp    80105a4a <alltraps>

80106867 <vector228>:
.globl vector228
vector228:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $228
80106869:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010686e:	e9 d7 f1 ff ff       	jmp    80105a4a <alltraps>

80106873 <vector229>:
.globl vector229
vector229:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $229
80106875:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010687a:	e9 cb f1 ff ff       	jmp    80105a4a <alltraps>

8010687f <vector230>:
.globl vector230
vector230:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $230
80106881:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106886:	e9 bf f1 ff ff       	jmp    80105a4a <alltraps>

8010688b <vector231>:
.globl vector231
vector231:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $231
8010688d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106892:	e9 b3 f1 ff ff       	jmp    80105a4a <alltraps>

80106897 <vector232>:
.globl vector232
vector232:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $232
80106899:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010689e:	e9 a7 f1 ff ff       	jmp    80105a4a <alltraps>

801068a3 <vector233>:
.globl vector233
vector233:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $233
801068a5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801068aa:	e9 9b f1 ff ff       	jmp    80105a4a <alltraps>

801068af <vector234>:
.globl vector234
vector234:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $234
801068b1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801068b6:	e9 8f f1 ff ff       	jmp    80105a4a <alltraps>

801068bb <vector235>:
.globl vector235
vector235:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $235
801068bd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801068c2:	e9 83 f1 ff ff       	jmp    80105a4a <alltraps>

801068c7 <vector236>:
.globl vector236
vector236:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $236
801068c9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801068ce:	e9 77 f1 ff ff       	jmp    80105a4a <alltraps>

801068d3 <vector237>:
.globl vector237
vector237:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $237
801068d5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801068da:	e9 6b f1 ff ff       	jmp    80105a4a <alltraps>

801068df <vector238>:
.globl vector238
vector238:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $238
801068e1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801068e6:	e9 5f f1 ff ff       	jmp    80105a4a <alltraps>

801068eb <vector239>:
.globl vector239
vector239:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $239
801068ed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801068f2:	e9 53 f1 ff ff       	jmp    80105a4a <alltraps>

801068f7 <vector240>:
.globl vector240
vector240:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $240
801068f9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801068fe:	e9 47 f1 ff ff       	jmp    80105a4a <alltraps>

80106903 <vector241>:
.globl vector241
vector241:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $241
80106905:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010690a:	e9 3b f1 ff ff       	jmp    80105a4a <alltraps>

8010690f <vector242>:
.globl vector242
vector242:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $242
80106911:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106916:	e9 2f f1 ff ff       	jmp    80105a4a <alltraps>

8010691b <vector243>:
.globl vector243
vector243:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $243
8010691d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106922:	e9 23 f1 ff ff       	jmp    80105a4a <alltraps>

80106927 <vector244>:
.globl vector244
vector244:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $244
80106929:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010692e:	e9 17 f1 ff ff       	jmp    80105a4a <alltraps>

80106933 <vector245>:
.globl vector245
vector245:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $245
80106935:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010693a:	e9 0b f1 ff ff       	jmp    80105a4a <alltraps>

8010693f <vector246>:
.globl vector246
vector246:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $246
80106941:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106946:	e9 ff f0 ff ff       	jmp    80105a4a <alltraps>

8010694b <vector247>:
.globl vector247
vector247:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $247
8010694d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106952:	e9 f3 f0 ff ff       	jmp    80105a4a <alltraps>

80106957 <vector248>:
.globl vector248
vector248:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $248
80106959:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010695e:	e9 e7 f0 ff ff       	jmp    80105a4a <alltraps>

80106963 <vector249>:
.globl vector249
vector249:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $249
80106965:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010696a:	e9 db f0 ff ff       	jmp    80105a4a <alltraps>

8010696f <vector250>:
.globl vector250
vector250:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $250
80106971:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106976:	e9 cf f0 ff ff       	jmp    80105a4a <alltraps>

8010697b <vector251>:
.globl vector251
vector251:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $251
8010697d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106982:	e9 c3 f0 ff ff       	jmp    80105a4a <alltraps>

80106987 <vector252>:
.globl vector252
vector252:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $252
80106989:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010698e:	e9 b7 f0 ff ff       	jmp    80105a4a <alltraps>

80106993 <vector253>:
.globl vector253
vector253:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $253
80106995:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010699a:	e9 ab f0 ff ff       	jmp    80105a4a <alltraps>

8010699f <vector254>:
.globl vector254
vector254:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $254
801069a1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801069a6:	e9 9f f0 ff ff       	jmp    80105a4a <alltraps>

801069ab <vector255>:
.globl vector255
vector255:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $255
801069ad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801069b2:	e9 93 f0 ff ff       	jmp    80105a4a <alltraps>
801069b7:	66 90                	xchg   %ax,%ax
801069b9:	66 90                	xchg   %ax,%ax
801069bb:	66 90                	xchg   %ax,%ax
801069bd:	66 90                	xchg   %ax,%ax
801069bf:	90                   	nop

801069c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069c6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801069cc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069d2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
801069d5:	39 d3                	cmp    %edx,%ebx
801069d7:	73 56                	jae    80106a2f <deallocuvm.part.0+0x6f>
801069d9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801069dc:	89 c6                	mov    %eax,%esi
801069de:	89 d7                	mov    %edx,%edi
801069e0:	eb 12                	jmp    801069f4 <deallocuvm.part.0+0x34>
801069e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801069e8:	83 c2 01             	add    $0x1,%edx
801069eb:	89 d3                	mov    %edx,%ebx
801069ed:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
801069f0:	39 fb                	cmp    %edi,%ebx
801069f2:	73 38                	jae    80106a2c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
801069f4:	89 da                	mov    %ebx,%edx
801069f6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801069f9:	8b 04 96             	mov    (%esi,%edx,4),%eax
801069fc:	a8 01                	test   $0x1,%al
801069fe:	74 e8                	je     801069e8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106a00:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a07:	c1 e9 0a             	shr    $0xa,%ecx
80106a0a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106a10:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106a17:	85 c0                	test   %eax,%eax
80106a19:	74 cd                	je     801069e8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106a1b:	8b 10                	mov    (%eax),%edx
80106a1d:	f6 c2 01             	test   $0x1,%dl
80106a20:	75 1e                	jne    80106a40 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106a22:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a28:	39 fb                	cmp    %edi,%ebx
80106a2a:	72 c8                	jb     801069f4 <deallocuvm.part.0+0x34>
80106a2c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a32:	89 c8                	mov    %ecx,%eax
80106a34:	5b                   	pop    %ebx
80106a35:	5e                   	pop    %esi
80106a36:	5f                   	pop    %edi
80106a37:	5d                   	pop    %ebp
80106a38:	c3                   	ret
80106a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106a40:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a46:	74 26                	je     80106a6e <deallocuvm.part.0+0xae>
      kfree(v);
80106a48:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106a4b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106a51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a54:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106a5a:	52                   	push   %edx
80106a5b:	e8 70 bc ff ff       	call   801026d0 <kfree>
      *pte = 0;
80106a60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106a63:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106a66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106a6c:	eb 82                	jmp    801069f0 <deallocuvm.part.0+0x30>
        panic("kfree");
80106a6e:	83 ec 0c             	sub    $0xc,%esp
80106a71:	68 06 76 10 80       	push   $0x80107606
80106a76:	e8 05 99 ff ff       	call   80100380 <panic>
80106a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a7f:	90                   	nop

80106a80 <mappages>:
{
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	57                   	push   %edi
80106a84:	56                   	push   %esi
80106a85:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106a86:	89 d3                	mov    %edx,%ebx
80106a88:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106a8e:	83 ec 1c             	sub    $0x1c,%esp
80106a91:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a94:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106aa0:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa3:	29 d8                	sub    %ebx,%eax
80106aa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106aa8:	eb 3f                	jmp    80106ae9 <mappages+0x69>
80106aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106ab0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ab2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106ab7:	c1 ea 0a             	shr    $0xa,%edx
80106aba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ac0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ac7:	85 c0                	test   %eax,%eax
80106ac9:	74 75                	je     80106b40 <mappages+0xc0>
    if(*pte & PTE_P)
80106acb:	f6 00 01             	testb  $0x1,(%eax)
80106ace:	0f 85 86 00 00 00    	jne    80106b5a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106ad4:	0b 75 0c             	or     0xc(%ebp),%esi
80106ad7:	83 ce 01             	or     $0x1,%esi
80106ada:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106adc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106adf:	39 c3                	cmp    %eax,%ebx
80106ae1:	74 6d                	je     80106b50 <mappages+0xd0>
    a += PGSIZE;
80106ae3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106ae9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106aec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106aef:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106af2:	89 d8                	mov    %ebx,%eax
80106af4:	c1 e8 16             	shr    $0x16,%eax
80106af7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106afa:	8b 07                	mov    (%edi),%eax
80106afc:	a8 01                	test   $0x1,%al
80106afe:	75 b0                	jne    80106ab0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b00:	e8 8b bd ff ff       	call   80102890 <kalloc>
80106b05:	85 c0                	test   %eax,%eax
80106b07:	74 37                	je     80106b40 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106b09:	83 ec 04             	sub    $0x4,%esp
80106b0c:	68 00 10 00 00       	push   $0x1000
80106b11:	6a 00                	push   $0x0
80106b13:	50                   	push   %eax
80106b14:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106b17:	e8 94 dd ff ff       	call   801048b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b1c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106b1f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b22:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106b28:	83 c8 07             	or     $0x7,%eax
80106b2b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106b2d:	89 d8                	mov    %ebx,%eax
80106b2f:	c1 e8 0a             	shr    $0xa,%eax
80106b32:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b37:	01 d0                	add    %edx,%eax
80106b39:	eb 90                	jmp    80106acb <mappages+0x4b>
80106b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b3f:	90                   	nop
}
80106b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b48:	5b                   	pop    %ebx
80106b49:	5e                   	pop    %esi
80106b4a:	5f                   	pop    %edi
80106b4b:	5d                   	pop    %ebp
80106b4c:	c3                   	ret
80106b4d:	8d 76 00             	lea    0x0(%esi),%esi
80106b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b53:	31 c0                	xor    %eax,%eax
}
80106b55:	5b                   	pop    %ebx
80106b56:	5e                   	pop    %esi
80106b57:	5f                   	pop    %edi
80106b58:	5d                   	pop    %ebp
80106b59:	c3                   	ret
      panic("remap");
80106b5a:	83 ec 0c             	sub    $0xc,%esp
80106b5d:	68 48 7c 10 80       	push   $0x80107c48
80106b62:	e8 19 98 ff ff       	call   80100380 <panic>
80106b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b6e:	66 90                	xchg   %ax,%ax

80106b70 <seginit>:
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b76:	e8 05 d0 ff ff       	call   80103b80 <cpuid>
  pd[0] = size-1;
80106b7b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b80:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106b86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106b8a:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106b91:	ff 00 00 
80106b94:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106b9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b9e:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106ba5:	ff 00 00 
80106ba8:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106baf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106bb2:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106bb9:	ff 00 00 
80106bbc:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106bc3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106bc6:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106bcd:	ff 00 00 
80106bd0:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106bd7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106bda:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106bdf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106be3:	c1 e8 10             	shr    $0x10,%eax
80106be6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106bea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106bed:	0f 01 10             	lgdtl  (%eax)
}
80106bf0:	c9                   	leave
80106bf1:	c3                   	ret
80106bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c00:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106c05:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c0a:	0f 22 d8             	mov    %eax,%cr3
}
80106c0d:	c3                   	ret
80106c0e:	66 90                	xchg   %ax,%ax

80106c10 <switchuvm>:
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	56                   	push   %esi
80106c15:	53                   	push   %ebx
80106c16:	83 ec 1c             	sub    $0x1c,%esp
80106c19:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c1c:	85 f6                	test   %esi,%esi
80106c1e:	0f 84 cb 00 00 00    	je     80106cef <switchuvm+0xdf>
  if(p->kstack == 0)
80106c24:	8b 46 08             	mov    0x8(%esi),%eax
80106c27:	85 c0                	test   %eax,%eax
80106c29:	0f 84 da 00 00 00    	je     80106d09 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c2f:	8b 46 04             	mov    0x4(%esi),%eax
80106c32:	85 c0                	test   %eax,%eax
80106c34:	0f 84 c2 00 00 00    	je     80106cfc <switchuvm+0xec>
  pushcli();
80106c3a:	e8 41 da ff ff       	call   80104680 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c3f:	e8 dc ce ff ff       	call   80103b20 <mycpu>
80106c44:	89 c3                	mov    %eax,%ebx
80106c46:	e8 d5 ce ff ff       	call   80103b20 <mycpu>
80106c4b:	89 c7                	mov    %eax,%edi
80106c4d:	e8 ce ce ff ff       	call   80103b20 <mycpu>
80106c52:	83 c7 08             	add    $0x8,%edi
80106c55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c58:	e8 c3 ce ff ff       	call   80103b20 <mycpu>
80106c5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c60:	ba 67 00 00 00       	mov    $0x67,%edx
80106c65:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106c6c:	83 c0 08             	add    $0x8,%eax
80106c6f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c76:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c7b:	83 c1 08             	add    $0x8,%ecx
80106c7e:	c1 e8 18             	shr    $0x18,%eax
80106c81:	c1 e9 10             	shr    $0x10,%ecx
80106c84:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106c8a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106c90:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106c95:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c9c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ca1:	e8 7a ce ff ff       	call   80103b20 <mycpu>
80106ca6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106cad:	e8 6e ce ff ff       	call   80103b20 <mycpu>
80106cb2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106cb6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106cb9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cbf:	e8 5c ce ff ff       	call   80103b20 <mycpu>
80106cc4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cc7:	e8 54 ce ff ff       	call   80103b20 <mycpu>
80106ccc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106cd0:	b8 28 00 00 00       	mov    $0x28,%eax
80106cd5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106cd8:	8b 46 04             	mov    0x4(%esi),%eax
80106cdb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ce0:	0f 22 d8             	mov    %eax,%cr3
}
80106ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ce6:	5b                   	pop    %ebx
80106ce7:	5e                   	pop    %esi
80106ce8:	5f                   	pop    %edi
80106ce9:	5d                   	pop    %ebp
  popcli();
80106cea:	e9 e1 d9 ff ff       	jmp    801046d0 <popcli>
    panic("switchuvm: no process");
80106cef:	83 ec 0c             	sub    $0xc,%esp
80106cf2:	68 4e 7c 10 80       	push   $0x80107c4e
80106cf7:	e8 84 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106cfc:	83 ec 0c             	sub    $0xc,%esp
80106cff:	68 79 7c 10 80       	push   $0x80107c79
80106d04:	e8 77 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106d09:	83 ec 0c             	sub    $0xc,%esp
80106d0c:	68 64 7c 10 80       	push   $0x80107c64
80106d11:	e8 6a 96 ff ff       	call   80100380 <panic>
80106d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d1d:	8d 76 00             	lea    0x0(%esi),%esi

80106d20 <inituvm>:
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 1c             	sub    $0x1c,%esp
80106d29:	8b 45 08             	mov    0x8(%ebp),%eax
80106d2c:	8b 75 10             	mov    0x10(%ebp),%esi
80106d2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106d32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d35:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d3b:	77 49                	ja     80106d86 <inituvm+0x66>
  mem = kalloc();
80106d3d:	e8 4e bb ff ff       	call   80102890 <kalloc>
  memset(mem, 0, PGSIZE);
80106d42:	83 ec 04             	sub    $0x4,%esp
80106d45:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106d4a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d4c:	6a 00                	push   $0x0
80106d4e:	50                   	push   %eax
80106d4f:	e8 5c db ff ff       	call   801048b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d54:	58                   	pop    %eax
80106d55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d5b:	5a                   	pop    %edx
80106d5c:	6a 06                	push   $0x6
80106d5e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d63:	31 d2                	xor    %edx,%edx
80106d65:	50                   	push   %eax
80106d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d69:	e8 12 fd ff ff       	call   80106a80 <mappages>
  memmove(mem, init, sz);
80106d6e:	89 75 10             	mov    %esi,0x10(%ebp)
80106d71:	83 c4 10             	add    $0x10,%esp
80106d74:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106d77:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106d7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d7d:	5b                   	pop    %ebx
80106d7e:	5e                   	pop    %esi
80106d7f:	5f                   	pop    %edi
80106d80:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106d81:	e9 ba db ff ff       	jmp    80104940 <memmove>
    panic("inituvm: more than a page");
80106d86:	83 ec 0c             	sub    $0xc,%esp
80106d89:	68 8d 7c 10 80       	push   $0x80107c8d
80106d8e:	e8 ed 95 ff ff       	call   80100380 <panic>
80106d93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106da0 <loaduvm>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
80106da6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106da9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106dac:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106daf:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106db5:	0f 85 a2 00 00 00    	jne    80106e5d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106dbb:	85 ff                	test   %edi,%edi
80106dbd:	74 7d                	je     80106e3c <loaduvm+0x9c>
80106dbf:	90                   	nop
  pde = &pgdir[PDX(va)];
80106dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106dc3:	8b 55 08             	mov    0x8(%ebp),%edx
80106dc6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106dc8:	89 c1                	mov    %eax,%ecx
80106dca:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106dcd:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106dd0:	f6 c1 01             	test   $0x1,%cl
80106dd3:	75 13                	jne    80106de8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106dd5:	83 ec 0c             	sub    $0xc,%esp
80106dd8:	68 a7 7c 10 80       	push   $0x80107ca7
80106ddd:	e8 9e 95 ff ff       	call   80100380 <panic>
80106de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106de8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106deb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106df1:	25 fc 0f 00 00       	and    $0xffc,%eax
80106df6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106dfd:	85 c9                	test   %ecx,%ecx
80106dff:	74 d4                	je     80106dd5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106e01:	89 fb                	mov    %edi,%ebx
80106e03:	b8 00 10 00 00       	mov    $0x1000,%eax
80106e08:	29 f3                	sub    %esi,%ebx
80106e0a:	39 c3                	cmp    %eax,%ebx
80106e0c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e0f:	53                   	push   %ebx
80106e10:	8b 45 14             	mov    0x14(%ebp),%eax
80106e13:	01 f0                	add    %esi,%eax
80106e15:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106e16:	8b 01                	mov    (%ecx),%eax
80106e18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e1d:	05 00 00 00 80       	add    $0x80000000,%eax
80106e22:	50                   	push   %eax
80106e23:	ff 75 10             	push   0x10(%ebp)
80106e26:	e8 05 ae ff ff       	call   80101c30 <readi>
80106e2b:	83 c4 10             	add    $0x10,%esp
80106e2e:	39 d8                	cmp    %ebx,%eax
80106e30:	75 1e                	jne    80106e50 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106e32:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e38:	39 fe                	cmp    %edi,%esi
80106e3a:	72 84                	jb     80106dc0 <loaduvm+0x20>
}
80106e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e3f:	31 c0                	xor    %eax,%eax
}
80106e41:	5b                   	pop    %ebx
80106e42:	5e                   	pop    %esi
80106e43:	5f                   	pop    %edi
80106e44:	5d                   	pop    %ebp
80106e45:	c3                   	ret
80106e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e4d:	8d 76 00             	lea    0x0(%esi),%esi
80106e50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e58:	5b                   	pop    %ebx
80106e59:	5e                   	pop    %esi
80106e5a:	5f                   	pop    %edi
80106e5b:	5d                   	pop    %ebp
80106e5c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106e5d:	83 ec 0c             	sub    $0xc,%esp
80106e60:	68 48 7d 10 80       	push   $0x80107d48
80106e65:	e8 16 95 ff ff       	call   80100380 <panic>
80106e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e70 <allocuvm>:
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	57                   	push   %edi
80106e74:	56                   	push   %esi
80106e75:	53                   	push   %ebx
80106e76:	83 ec 1c             	sub    $0x1c,%esp
80106e79:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106e7c:	85 f6                	test   %esi,%esi
80106e7e:	0f 88 98 00 00 00    	js     80106f1c <allocuvm+0xac>
80106e84:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106e86:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106e89:	0f 82 a1 00 00 00    	jb     80106f30 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e92:	05 ff 0f 00 00       	add    $0xfff,%eax
80106e97:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e9c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106e9e:	39 f0                	cmp    %esi,%eax
80106ea0:	0f 83 8d 00 00 00    	jae    80106f33 <allocuvm+0xc3>
80106ea6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106ea9:	eb 44                	jmp    80106eef <allocuvm+0x7f>
80106eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106eaf:	90                   	nop
    memset(mem, 0, PGSIZE);
80106eb0:	83 ec 04             	sub    $0x4,%esp
80106eb3:	68 00 10 00 00       	push   $0x1000
80106eb8:	6a 00                	push   $0x0
80106eba:	50                   	push   %eax
80106ebb:	e8 f0 d9 ff ff       	call   801048b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ec0:	58                   	pop    %eax
80106ec1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ec7:	5a                   	pop    %edx
80106ec8:	6a 06                	push   $0x6
80106eca:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ecf:	89 fa                	mov    %edi,%edx
80106ed1:	50                   	push   %eax
80106ed2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ed5:	e8 a6 fb ff ff       	call   80106a80 <mappages>
80106eda:	83 c4 10             	add    $0x10,%esp
80106edd:	85 c0                	test   %eax,%eax
80106edf:	78 5f                	js     80106f40 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106ee1:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106ee7:	39 f7                	cmp    %esi,%edi
80106ee9:	0f 83 89 00 00 00    	jae    80106f78 <allocuvm+0x108>
    mem = kalloc();
80106eef:	e8 9c b9 ff ff       	call   80102890 <kalloc>
80106ef4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106ef6:	85 c0                	test   %eax,%eax
80106ef8:	75 b6                	jne    80106eb0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106efa:	83 ec 0c             	sub    $0xc,%esp
80106efd:	68 c5 7c 10 80       	push   $0x80107cc5
80106f02:	e8 a9 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106f07:	83 c4 10             	add    $0x10,%esp
80106f0a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f0d:	74 0d                	je     80106f1c <allocuvm+0xac>
80106f0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f12:	8b 45 08             	mov    0x8(%ebp),%eax
80106f15:	89 f2                	mov    %esi,%edx
80106f17:	e8 a4 fa ff ff       	call   801069c0 <deallocuvm.part.0>
    return 0;
80106f1c:	31 d2                	xor    %edx,%edx
}
80106f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f21:	89 d0                	mov    %edx,%eax
80106f23:	5b                   	pop    %ebx
80106f24:	5e                   	pop    %esi
80106f25:	5f                   	pop    %edi
80106f26:	5d                   	pop    %ebp
80106f27:	c3                   	ret
80106f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f2f:	90                   	nop
    return oldsz;
80106f30:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f36:	89 d0                	mov    %edx,%eax
80106f38:	5b                   	pop    %ebx
80106f39:	5e                   	pop    %esi
80106f3a:	5f                   	pop    %edi
80106f3b:	5d                   	pop    %ebp
80106f3c:	c3                   	ret
80106f3d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106f40:	83 ec 0c             	sub    $0xc,%esp
80106f43:	68 dd 7c 10 80       	push   $0x80107cdd
80106f48:	e8 63 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106f4d:	83 c4 10             	add    $0x10,%esp
80106f50:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f53:	74 0d                	je     80106f62 <allocuvm+0xf2>
80106f55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f58:	8b 45 08             	mov    0x8(%ebp),%eax
80106f5b:	89 f2                	mov    %esi,%edx
80106f5d:	e8 5e fa ff ff       	call   801069c0 <deallocuvm.part.0>
      kfree(mem);
80106f62:	83 ec 0c             	sub    $0xc,%esp
80106f65:	53                   	push   %ebx
80106f66:	e8 65 b7 ff ff       	call   801026d0 <kfree>
      return 0;
80106f6b:	83 c4 10             	add    $0x10,%esp
    return 0;
80106f6e:	31 d2                	xor    %edx,%edx
80106f70:	eb ac                	jmp    80106f1e <allocuvm+0xae>
80106f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f7e:	5b                   	pop    %ebx
80106f7f:	5e                   	pop    %esi
80106f80:	89 d0                	mov    %edx,%eax
80106f82:	5f                   	pop    %edi
80106f83:	5d                   	pop    %ebp
80106f84:	c3                   	ret
80106f85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f90 <deallocuvm>:
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f96:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f99:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106f9c:	39 d1                	cmp    %edx,%ecx
80106f9e:	73 10                	jae    80106fb0 <deallocuvm+0x20>
}
80106fa0:	5d                   	pop    %ebp
80106fa1:	e9 1a fa ff ff       	jmp    801069c0 <deallocuvm.part.0>
80106fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fad:	8d 76 00             	lea    0x0(%esi),%esi
80106fb0:	89 d0                	mov    %edx,%eax
80106fb2:	5d                   	pop    %ebp
80106fb3:	c3                   	ret
80106fb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fbf:	90                   	nop

80106fc0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
80106fc6:	83 ec 0c             	sub    $0xc,%esp
80106fc9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106fcc:	85 f6                	test   %esi,%esi
80106fce:	74 59                	je     80107029 <freevm+0x69>
  if(newsz >= oldsz)
80106fd0:	31 c9                	xor    %ecx,%ecx
80106fd2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106fd7:	89 f0                	mov    %esi,%eax
80106fd9:	89 f3                	mov    %esi,%ebx
80106fdb:	e8 e0 f9 ff ff       	call   801069c0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106fe0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106fe6:	eb 0f                	jmp    80106ff7 <freevm+0x37>
80106fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fef:	90                   	nop
80106ff0:	83 c3 04             	add    $0x4,%ebx
80106ff3:	39 fb                	cmp    %edi,%ebx
80106ff5:	74 23                	je     8010701a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ff7:	8b 03                	mov    (%ebx),%eax
80106ff9:	a8 01                	test   $0x1,%al
80106ffb:	74 f3                	je     80106ff0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ffd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107002:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107005:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107008:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010700d:	50                   	push   %eax
8010700e:	e8 bd b6 ff ff       	call   801026d0 <kfree>
80107013:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107016:	39 fb                	cmp    %edi,%ebx
80107018:	75 dd                	jne    80106ff7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010701a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010701d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107020:	5b                   	pop    %ebx
80107021:	5e                   	pop    %esi
80107022:	5f                   	pop    %edi
80107023:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107024:	e9 a7 b6 ff ff       	jmp    801026d0 <kfree>
    panic("freevm: no pgdir");
80107029:	83 ec 0c             	sub    $0xc,%esp
8010702c:	68 f9 7c 10 80       	push   $0x80107cf9
80107031:	e8 4a 93 ff ff       	call   80100380 <panic>
80107036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703d:	8d 76 00             	lea    0x0(%esi),%esi

80107040 <setupkvm>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	56                   	push   %esi
80107044:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107045:	e8 46 b8 ff ff       	call   80102890 <kalloc>
8010704a:	85 c0                	test   %eax,%eax
8010704c:	74 5e                	je     801070ac <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010704e:	83 ec 04             	sub    $0x4,%esp
80107051:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107053:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107058:	68 00 10 00 00       	push   $0x1000
8010705d:	6a 00                	push   $0x0
8010705f:	50                   	push   %eax
80107060:	e8 4b d8 ff ff       	call   801048b0 <memset>
80107065:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107068:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010706b:	83 ec 08             	sub    $0x8,%esp
8010706e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107071:	8b 13                	mov    (%ebx),%edx
80107073:	ff 73 0c             	push   0xc(%ebx)
80107076:	50                   	push   %eax
80107077:	29 c1                	sub    %eax,%ecx
80107079:	89 f0                	mov    %esi,%eax
8010707b:	e8 00 fa ff ff       	call   80106a80 <mappages>
80107080:	83 c4 10             	add    $0x10,%esp
80107083:	85 c0                	test   %eax,%eax
80107085:	78 19                	js     801070a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107087:	83 c3 10             	add    $0x10,%ebx
8010708a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107090:	75 d6                	jne    80107068 <setupkvm+0x28>
}
80107092:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107095:	89 f0                	mov    %esi,%eax
80107097:	5b                   	pop    %ebx
80107098:	5e                   	pop    %esi
80107099:	5d                   	pop    %ebp
8010709a:	c3                   	ret
8010709b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010709f:	90                   	nop
      freevm(pgdir);
801070a0:	83 ec 0c             	sub    $0xc,%esp
801070a3:	56                   	push   %esi
801070a4:	e8 17 ff ff ff       	call   80106fc0 <freevm>
      return 0;
801070a9:	83 c4 10             	add    $0x10,%esp
}
801070ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801070af:	31 f6                	xor    %esi,%esi
}
801070b1:	89 f0                	mov    %esi,%eax
801070b3:	5b                   	pop    %ebx
801070b4:	5e                   	pop    %esi
801070b5:	5d                   	pop    %ebp
801070b6:	c3                   	ret
801070b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070be:	66 90                	xchg   %ax,%ax

801070c0 <kvmalloc>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801070c6:	e8 75 ff ff ff       	call   80107040 <setupkvm>
801070cb:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070d0:	05 00 00 00 80       	add    $0x80000000,%eax
801070d5:	0f 22 d8             	mov    %eax,%cr3
}
801070d8:	c9                   	leave
801070d9:	c3                   	ret
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	83 ec 08             	sub    $0x8,%esp
801070e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801070e9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801070ec:	89 c1                	mov    %eax,%ecx
801070ee:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801070f1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801070f4:	f6 c2 01             	test   $0x1,%dl
801070f7:	75 17                	jne    80107110 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801070f9:	83 ec 0c             	sub    $0xc,%esp
801070fc:	68 0a 7d 10 80       	push   $0x80107d0a
80107101:	e8 7a 92 ff ff       	call   80100380 <panic>
80107106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010710d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107110:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107113:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107119:	25 fc 0f 00 00       	and    $0xffc,%eax
8010711e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107125:	85 c0                	test   %eax,%eax
80107127:	74 d0                	je     801070f9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107129:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010712c:	c9                   	leave
8010712d:	c3                   	ret
8010712e:	66 90                	xchg   %ax,%ax

80107130 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	57                   	push   %edi
80107134:	56                   	push   %esi
80107135:	53                   	push   %ebx
80107136:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107139:	e8 02 ff ff ff       	call   80107040 <setupkvm>
8010713e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107141:	85 c0                	test   %eax,%eax
80107143:	0f 84 e9 00 00 00    	je     80107232 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107149:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010714c:	85 c9                	test   %ecx,%ecx
8010714e:	0f 84 b2 00 00 00    	je     80107206 <copyuvm+0xd6>
80107154:	31 f6                	xor    %esi,%esi
80107156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010715d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107160:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107163:	89 f0                	mov    %esi,%eax
80107165:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107168:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010716b:	a8 01                	test   $0x1,%al
8010716d:	75 11                	jne    80107180 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010716f:	83 ec 0c             	sub    $0xc,%esp
80107172:	68 14 7d 10 80       	push   $0x80107d14
80107177:	e8 04 92 ff ff       	call   80100380 <panic>
8010717c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107180:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107182:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107187:	c1 ea 0a             	shr    $0xa,%edx
8010718a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107190:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107197:	85 c0                	test   %eax,%eax
80107199:	74 d4                	je     8010716f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010719b:	8b 00                	mov    (%eax),%eax
8010719d:	a8 01                	test   $0x1,%al
8010719f:	0f 84 9f 00 00 00    	je     80107244 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801071a5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801071a7:	25 ff 0f 00 00       	and    $0xfff,%eax
801071ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801071af:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801071b5:	e8 d6 b6 ff ff       	call   80102890 <kalloc>
801071ba:	89 c3                	mov    %eax,%ebx
801071bc:	85 c0                	test   %eax,%eax
801071be:	74 64                	je     80107224 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801071c0:	83 ec 04             	sub    $0x4,%esp
801071c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801071c9:	68 00 10 00 00       	push   $0x1000
801071ce:	57                   	push   %edi
801071cf:	50                   	push   %eax
801071d0:	e8 6b d7 ff ff       	call   80104940 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801071d5:	58                   	pop    %eax
801071d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071dc:	5a                   	pop    %edx
801071dd:	ff 75 e4             	push   -0x1c(%ebp)
801071e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071e5:	89 f2                	mov    %esi,%edx
801071e7:	50                   	push   %eax
801071e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071eb:	e8 90 f8 ff ff       	call   80106a80 <mappages>
801071f0:	83 c4 10             	add    $0x10,%esp
801071f3:	85 c0                	test   %eax,%eax
801071f5:	78 21                	js     80107218 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801071f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071fd:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107200:	0f 82 5a ff ff ff    	jb     80107160 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107206:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107209:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010720c:	5b                   	pop    %ebx
8010720d:	5e                   	pop    %esi
8010720e:	5f                   	pop    %edi
8010720f:	5d                   	pop    %ebp
80107210:	c3                   	ret
80107211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107218:	83 ec 0c             	sub    $0xc,%esp
8010721b:	53                   	push   %ebx
8010721c:	e8 af b4 ff ff       	call   801026d0 <kfree>
      goto bad;
80107221:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107224:	83 ec 0c             	sub    $0xc,%esp
80107227:	ff 75 e0             	push   -0x20(%ebp)
8010722a:	e8 91 fd ff ff       	call   80106fc0 <freevm>
  return 0;
8010722f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107232:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107239:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010723c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010723f:	5b                   	pop    %ebx
80107240:	5e                   	pop    %esi
80107241:	5f                   	pop    %edi
80107242:	5d                   	pop    %ebp
80107243:	c3                   	ret
      panic("copyuvm: page not present");
80107244:	83 ec 0c             	sub    $0xc,%esp
80107247:	68 2e 7d 10 80       	push   $0x80107d2e
8010724c:	e8 2f 91 ff ff       	call   80100380 <panic>
80107251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010725f:	90                   	nop

80107260 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107266:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107269:	89 c1                	mov    %eax,%ecx
8010726b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010726e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107271:	f6 c2 01             	test   $0x1,%dl
80107274:	0f 84 00 01 00 00    	je     8010737a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010727a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010727d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107283:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107284:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107289:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107290:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107292:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107297:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010729a:	05 00 00 00 80       	add    $0x80000000,%eax
8010729f:	83 fa 05             	cmp    $0x5,%edx
801072a2:	ba 00 00 00 00       	mov    $0x0,%edx
801072a7:	0f 45 c2             	cmovne %edx,%eax
}
801072aa:	c3                   	ret
801072ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072af:	90                   	nop

801072b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	56                   	push   %esi
801072b5:	53                   	push   %ebx
801072b6:	83 ec 0c             	sub    $0xc,%esp
801072b9:	8b 75 14             	mov    0x14(%ebp),%esi
801072bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801072bf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801072c2:	85 f6                	test   %esi,%esi
801072c4:	75 51                	jne    80107317 <copyout+0x67>
801072c6:	e9 a5 00 00 00       	jmp    80107370 <copyout+0xc0>
801072cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072cf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801072d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801072d6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801072dc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801072e2:	74 75                	je     80107359 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801072e4:	89 fb                	mov    %edi,%ebx
801072e6:	29 c3                	sub    %eax,%ebx
801072e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072ee:	39 f3                	cmp    %esi,%ebx
801072f0:	0f 47 de             	cmova  %esi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801072f3:	29 f8                	sub    %edi,%eax
801072f5:	83 ec 04             	sub    $0x4,%esp
801072f8:	01 c1                	add    %eax,%ecx
801072fa:	53                   	push   %ebx
801072fb:	52                   	push   %edx
801072fc:	89 55 10             	mov    %edx,0x10(%ebp)
801072ff:	51                   	push   %ecx
80107300:	e8 3b d6 ff ff       	call   80104940 <memmove>
    len -= n;
    buf += n;
80107305:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107308:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010730e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107311:	01 da                	add    %ebx,%edx
  while(len > 0){
80107313:	29 de                	sub    %ebx,%esi
80107315:	74 59                	je     80107370 <copyout+0xc0>
  if(*pde & PTE_P){
80107317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010731a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010731c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010731e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107321:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107327:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010732a:	f6 c1 01             	test   $0x1,%cl
8010732d:	0f 84 4e 00 00 00    	je     80107381 <copyout.cold>
  return &pgtab[PTX(va)];
80107333:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107335:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010733b:	c1 eb 0c             	shr    $0xc,%ebx
8010733e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107344:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010734b:	89 d9                	mov    %ebx,%ecx
8010734d:	83 e1 05             	and    $0x5,%ecx
80107350:	83 f9 05             	cmp    $0x5,%ecx
80107353:	0f 84 77 ff ff ff    	je     801072d0 <copyout+0x20>
  }
  return 0;
}
80107359:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010735c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107361:	5b                   	pop    %ebx
80107362:	5e                   	pop    %esi
80107363:	5f                   	pop    %edi
80107364:	5d                   	pop    %ebp
80107365:	c3                   	ret
80107366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010736d:	8d 76 00             	lea    0x0(%esi),%esi
80107370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107373:	31 c0                	xor    %eax,%eax
}
80107375:	5b                   	pop    %ebx
80107376:	5e                   	pop    %esi
80107377:	5f                   	pop    %edi
80107378:	5d                   	pop    %ebp
80107379:	c3                   	ret

8010737a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010737a:	a1 00 00 00 00       	mov    0x0,%eax
8010737f:	0f 0b                	ud2

80107381 <copyout.cold>:
80107381:	a1 00 00 00 00       	mov    0x0,%eax
80107386:	0f 0b                	ud2
