
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc f0 e6 14 80       	mov    $0x8014e6f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 31 10 80       	mov    $0x80103170,%eax
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
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 7b 10 80       	push   $0x80107b80
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 e5 4a 00 00       	call   80104b40 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
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
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 7b 10 80       	push   $0x80107b87
80100097:	50                   	push   %eax
80100098:	e8 73 49 00 00       	call   80104a10 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
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
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 27 4c 00 00       	call   80104d10 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
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
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
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
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 49 4b 00 00       	call   80104cb0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 48 00 00       	call   80104a50 <acquiresleep>
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
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
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
801001a1:	68 8e 7b 10 80       	push   $0x80107b8e
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
801001be:	e8 2d 49 00 00       	call   80104af0 <holdingsleep>
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
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 9f 7b 10 80       	push   $0x80107b9f
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
801001ff:	e8 ec 48 00 00       	call   80104af0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 48 00 00       	call   80104ab0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 f0 4a 00 00       	call   80104d10 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 3f 4a 00 00       	jmp    80104cb0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 a6 7b 10 80       	push   $0x80107ba6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

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
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 6b 4a 00 00       	call   80104d10 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
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
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 3e 3f 00 00       	call   80104210 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 b9 37 00 00       	call   80103aa0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 b5 49 00 00       	call   80104cb0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
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
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
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
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 5f 49 00 00       	call   80104cb0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
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
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
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
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 26 00 00       	call   80102a00 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ad 7b 10 80       	push   $0x80107bad
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 73 85 10 80 	movl   $0x80108573,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 93 47 00 00       	call   80104b60 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 c1 7b 10 80       	push   $0x80107bc1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
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
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 f1 61 00 00       	call   80106610 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 06 61 00 00       	call   80106610 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 fa 60 00 00       	call   80106610 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ee 60 00 00       	call   80106610 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 1a 49 00 00       	call   80104e70 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 65 48 00 00       	call   80104dd0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 c5 7b 10 80       	push   $0x80107bc5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 60 47 00 00       	call   80104d10 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 c7 46 00 00       	call   80104cb0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 f0 7b 10 80 	movzbl -0x7fef8410(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 23 45 00 00       	call   80104d10 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf d8 7b 10 80       	mov    $0x80107bd8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 50 44 00 00       	call   80104cb0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 df 7b 10 80       	push   $0x80107bdf
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 78 44 00 00       	call   80104d10 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 db 42 00 00       	call   80104cb0 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 9d 39 00 00       	jmp    801043b0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 87 38 00 00       	call   801042d0 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 e8 7b 10 80       	push   $0x80107be8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 cb 40 00 00       	call   80104b40 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 df 2f 00 00       	call   80103aa0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 a4 23 00 00       	call   80102e70 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 cc 23 00 00       	call   80102ee0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 67 6c 00 00       	call   801077a0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 18 6a 00 00       	call   801075c0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 f2 68 00 00       	call   801074d0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 00 6b 00 00       	call   80107720 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 8a 22 00 00       	call   80102ee0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 59 69 00 00       	call   801075c0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 b8 6b 00 00       	call   80107840 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 f8 42 00 00       	call   80104fd0 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 e4 42 00 00       	call   80104fd0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 a3 6d 00 00       	call   80107aa0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 0a 6a 00 00       	call   80107720 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 38 6d 00 00       	call   80107aa0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 ea 41 00 00       	call   80104f90 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 6e 65 00 00       	call   80107340 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 46 69 00 00       	call   80107720 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 f7 20 00 00       	call   80102ee0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 01 7c 10 80       	push   $0x80107c01
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 0d 7c 10 80       	push   $0x80107c0d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 1b 3d 00 00       	call   80104b40 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 ca 3e 00 00       	call   80104d10 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 3a 3e 00 00       	call   80104cb0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 21 3e 00 00       	call   80104cb0 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 5c 3e 00 00       	call   80104d10 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 df 3d 00 00       	call   80104cb0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 14 7c 10 80       	push   $0x80107c14
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 0a 3e 00 00       	call   80104d10 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 6f 3d 00 00       	call   80104cb0 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 3d 3d 00 00       	jmp    80104cb0 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 f3 1e 00 00       	call   80102e70 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 49 1f 00 00       	jmp    80102ee0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 92 26 00 00       	call   80103640 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 1c 7c 10 80       	push   $0x80107c1c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 4e 27 00 00       	jmp    801037e0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 26 7c 10 80       	push   $0x80107c26
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 d2 1d 00 00       	call   80102ee0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 3d 1d 00 00       	call   80102e70 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 76 1d 00 00       	call   80102ee0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 2f 7c 10 80       	push   $0x80107c2f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 32 25 00 00       	jmp    801036e0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 35 7c 10 80       	push   $0x80107c35
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 3e 1e 00 00       	call   80103050 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 3f 7c 10 80       	push   $0x80107c3f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 52 7c 10 80       	push   $0x80107c52
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 4e 1d 00 00       	call   80103050 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 a6 3a 00 00       	call   80104dd0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 1e 1d 00 00       	call   80103050 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 a1 39 00 00       	call   80104d10 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 d4 38 00 00       	call   80104cb0 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 a6 38 00 00       	call   80104cb0 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 68 7c 10 80       	push   $0x80107c68
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 86 1b 00 00       	call   80103050 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 78 7c 10 80       	push   $0x80107c78
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 2a 39 00 00       	call   80104e70 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 8b 7c 10 80       	push   $0x80107c8b
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 c5 35 00 00       	call   80104b40 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 92 7c 10 80       	push   $0x80107c92
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 7c 34 00 00       	call   80104a10 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 af 38 00 00       	call   80104e70 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 f8 7c 10 80       	push   $0x80107cf8
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 3d 37 00 00       	call   80104dd0 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 ab 19 00 00       	call   80103050 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 98 7c 10 80       	push   $0x80107c98
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 3a 37 00 00       	call   80104e70 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 12 19 00 00       	call   80103050 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 ac 35 00 00       	call   80104d10 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 3c 35 00 00       	call   80104cb0 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 a9 32 00 00       	call   80104a50 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 53 36 00 00       	call   80104e70 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 b0 7c 10 80       	push   $0x80107cb0
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 aa 7c 10 80       	push   $0x80107caa
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 78 32 00 00       	call   80104af0 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 1c 32 00 00       	jmp    80104ab0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 bf 7c 10 80       	push   $0x80107cbf
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 8b 31 00 00       	call   80104a50 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 d1 31 00 00       	call   80104ab0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 25 34 00 00       	call   80104d10 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 ab 33 00 00       	jmp    80104cb0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 fb 33 00 00       	call   80104d10 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 8c 33 00 00       	call   80104cb0 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 c8 30 00 00       	call   80104af0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 71 30 00 00       	call   80104ab0 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 bf 7c 10 80       	push   $0x80107cbf
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 34 33 00 00       	call   80104e70 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 38 32 00 00       	call   80104e70 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 10 14 00 00       	call   80103050 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 0d 32 00 00       	call   80104ee0 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 ae 31 00 00       	call   80104ee0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 d9 7c 10 80       	push   $0x80107cd9
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 c7 7c 10 80       	push   $0x80107cc7
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 f1 1c 00 00       	call   80103aa0 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 51 2f 00 00       	call   80104d10 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 e1 2e 00 00       	call   80104cb0 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 44 30 00 00       	call   80104e70 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 5f 2c 00 00       	call   80104af0 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 fd 2b 00 00       	call   80104ab0 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 90 2f 00 00       	call   80104e70 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 c0 2b 00 00       	call   80104af0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 61 2b 00 00       	call   80104ab0 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 7e 2b 00 00       	call   80104af0 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 5b 2b 00 00       	call   80104af0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 04 2b 00 00       	call   80104ab0 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 bf 7c 10 80       	push   $0x80107cbf
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 ee 2e 00 00       	call   80104f30 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 e8 7c 10 80       	push   $0x80107ce8
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 12 83 10 80       	push   $0x80108312
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 54 7d 10 80       	push   $0x80107d54
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 4b 7d 10 80       	push   $0x80107d4b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 66 7d 10 80       	push   $0x80107d66
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 6b 29 00 00       	call   80104b40 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 a4 a7 14 80       	mov    0x8014a7a4,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 bd 2a 00 00       	call   80104d10 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 1e 20 00 00       	call   801042d0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 e0 29 00 00       	call   80104cb0 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 fd 27 00 00       	call   80104af0 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 e3 29 00 00       	call   80104d10 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 a2 1e 00 00       	call   80104210 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 25 29 00 00       	jmp    80104cb0 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 95 7d 10 80       	push   $0x80107d95
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 80 7d 10 80       	push   $0x80107d80
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 6a 7d 10 80       	push   $0x80107d6a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 a0 a7 14 80 	movzbl 0x8014a7a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 b4 7d 10 80       	push   $0x80107db4
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <get_refcount>:
int num_free_pages;
uint pgrefcount[PHYSTOP >> PGSHIFT];

uint
get_refcount(uint pa)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
  return pgrefcount[pa >> PGSHIFT];
801024c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801024c6:	5d                   	pop    %ebp
  return pgrefcount[pa >> PGSHIFT];
801024c7:	c1 e8 0c             	shr    $0xc,%eax
801024ca:	8b 04 85 40 26 11 80 	mov    -0x7feed9c0(,%eax,4),%eax
}
801024d1:	c3                   	ret    
801024d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801024e0 <inc_refcount>:

void
inc_refcount(uint pa)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
  pgrefcount[pa >> PGSHIFT]++;
801024e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801024e6:	5d                   	pop    %ebp
  pgrefcount[pa >> PGSHIFT]++;
801024e7:	c1 e8 0c             	shr    $0xc,%eax
801024ea:	83 04 85 40 26 11 80 	addl   $0x1,-0x7feed9c0(,%eax,4)
801024f1:	01 
}
801024f2:	c3                   	ret    
801024f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102500 <dec_refcount>:

void
dec_refcount(uint pa)
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
  pgrefcount[pa >> PGSHIFT]--;
80102503:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102506:	5d                   	pop    %ebp
  pgrefcount[pa >> PGSHIFT]--;
80102507:	c1 e8 0c             	shr    $0xc,%eax
8010250a:	83 2c 85 40 26 11 80 	subl   $0x1,-0x7feed9c0(,%eax,4)
80102511:	01 
}
80102512:	c3                   	ret    
80102513:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010251a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102520 <getNumFreePages>:

int
getNumFreePages(void)
{
  return num_free_pages;
}
80102520:	a1 40 a6 14 80       	mov    0x8014a640,%eax
80102525:	c3                   	ret    
80102526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010252d:	8d 76 00             	lea    0x0(%esi),%esi

80102530 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	56                   	push   %esi
80102534:	8b 75 08             	mov    0x8(%ebp),%esi
80102537:	53                   	push   %ebx
  struct run *r;
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102538:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
8010253e:	0f 85 b9 00 00 00    	jne    801025fd <kfree+0xcd>
80102544:	81 fe f0 e6 14 80    	cmp    $0x8014e6f0,%esi
8010254a:	0f 82 ad 00 00 00    	jb     801025fd <kfree+0xcd>
80102550:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
80102556:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
8010255c:	0f 87 9b 00 00 00    	ja     801025fd <kfree+0xcd>
    panic("kfree");

  if(kmem.use_lock)
80102562:	8b 15 94 a6 14 80    	mov    0x8014a694,%edx
80102568:	85 d2                	test   %edx,%edx
8010256a:	75 7c                	jne    801025e8 <kfree+0xb8>
  return pgrefcount[pa >> PGSHIFT];
8010256c:	c1 eb 0c             	shr    $0xc,%ebx
8010256f:	8b 04 9d 40 26 11 80 	mov    -0x7feed9c0(,%ebx,4),%eax
    acquire(&kmem.lock);

  if(get_refcount(V2P(v)) > 0) // 20181295 if there are reference pages
80102576:	85 c0                	test   %eax,%eax
80102578:	74 26                	je     801025a0 <kfree+0x70>
  pgrefcount[pa >> PGSHIFT]--;
8010257a:	83 e8 01             	sub    $0x1,%eax
8010257d:	89 04 9d 40 26 11 80 	mov    %eax,-0x7feed9c0(,%ebx,4)
    dec_refcount(V2P(v));

  if (get_refcount(V2P(v)) == 0){ // 20181295 if there's no reference page
80102584:	74 1a                	je     801025a0 <kfree+0x70>
    r = (struct run*)v;
    r->next = kmem.freelist;
    kmem.freelist = r;
  }

  if(kmem.use_lock)
80102586:	a1 94 a6 14 80       	mov    0x8014a694,%eax
8010258b:	85 c0                	test   %eax,%eax
8010258d:	75 41                	jne    801025d0 <kfree+0xa0>
    release(&kmem.lock);
}
8010258f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102592:	5b                   	pop    %ebx
80102593:	5e                   	pop    %esi
80102594:	5d                   	pop    %ebp
80102595:	c3                   	ret    
80102596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(v, 1, PGSIZE);
801025a0:	83 ec 04             	sub    $0x4,%esp
801025a3:	68 00 10 00 00       	push   $0x1000
801025a8:	6a 01                	push   $0x1
801025aa:	56                   	push   %esi
801025ab:	e8 20 28 00 00       	call   80104dd0 <memset>
    r->next = kmem.freelist;
801025b0:	a1 98 a6 14 80       	mov    0x8014a698,%eax
    num_free_pages++; // 20181295
801025b5:	83 05 40 a6 14 80 01 	addl   $0x1,0x8014a640
    kmem.freelist = r;
801025bc:	83 c4 10             	add    $0x10,%esp
    r->next = kmem.freelist;
801025bf:	89 06                	mov    %eax,(%esi)
  if(kmem.use_lock)
801025c1:	a1 94 a6 14 80       	mov    0x8014a694,%eax
    kmem.freelist = r;
801025c6:	89 35 98 a6 14 80    	mov    %esi,0x8014a698
  if(kmem.use_lock)
801025cc:	85 c0                	test   %eax,%eax
801025ce:	74 bf                	je     8010258f <kfree+0x5f>
    release(&kmem.lock);
801025d0:	c7 45 08 60 a6 14 80 	movl   $0x8014a660,0x8(%ebp)
}
801025d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025da:	5b                   	pop    %ebx
801025db:	5e                   	pop    %esi
801025dc:	5d                   	pop    %ebp
    release(&kmem.lock);
801025dd:	e9 ce 26 00 00       	jmp    80104cb0 <release>
801025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	68 60 a6 14 80       	push   $0x8014a660
801025f0:	e8 1b 27 00 00       	call   80104d10 <acquire>
801025f5:	83 c4 10             	add    $0x10,%esp
801025f8:	e9 6f ff ff ff       	jmp    8010256c <kfree+0x3c>
    panic("kfree");
801025fd:	83 ec 0c             	sub    $0xc,%esp
80102600:	68 e6 7d 10 80       	push   $0x80107de6
80102605:	e8 76 dd ff ff       	call   80100380 <panic>
8010260a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102610 <freerange>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102614:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102617:	8b 75 0c             	mov    0xc(%ebp),%esi
8010261a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010261b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102621:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102627:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262d:	39 de                	cmp    %ebx,%esi
8010262f:	72 37                	jb     80102668 <freerange+0x58>
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pgrefcount[V2P(p) >> PGSHIFT] = 0;  // 20181295
80102638:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
8010263e:	83 ec 0c             	sub    $0xc,%esp
    pgrefcount[V2P(p) >> PGSHIFT] = 0;  // 20181295
80102641:	c1 e8 0c             	shr    $0xc,%eax
80102644:	c7 04 85 40 26 11 80 	movl   $0x0,-0x7feed9c0(,%eax,4)
8010264b:	00 00 00 00 
    kfree(p);
8010264f:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102655:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265b:	50                   	push   %eax
8010265c:	e8 cf fe ff ff       	call   80102530 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102661:	83 c4 10             	add    $0x10,%esp
80102664:	39 f3                	cmp    %esi,%ebx
80102666:	76 d0                	jbe    80102638 <freerange+0x28>
}
80102668:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266b:	5b                   	pop    %ebx
8010266c:	5e                   	pop    %esi
8010266d:	5d                   	pop    %ebp
8010266e:	c3                   	ret    
8010266f:	90                   	nop

80102670 <kinit2>:
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102674:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102677:	8b 75 0c             	mov    0xc(%ebp),%esi
8010267a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010267b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102681:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102687:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010268d:	39 de                	cmp    %ebx,%esi
8010268f:	72 37                	jb     801026c8 <kinit2+0x58>
80102691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pgrefcount[V2P(p) >> PGSHIFT] = 0;  // 20181295
80102698:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
8010269e:	83 ec 0c             	sub    $0xc,%esp
    pgrefcount[V2P(p) >> PGSHIFT] = 0;  // 20181295
801026a1:	c1 e8 0c             	shr    $0xc,%eax
801026a4:	c7 04 85 40 26 11 80 	movl   $0x0,-0x7feed9c0(,%eax,4)
801026ab:	00 00 00 00 
    kfree(p);
801026af:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026b5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026bb:	50                   	push   %eax
801026bc:	e8 6f fe ff ff       	call   80102530 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026c1:	83 c4 10             	add    $0x10,%esp
801026c4:	39 de                	cmp    %ebx,%esi
801026c6:	73 d0                	jae    80102698 <kinit2+0x28>
  kmem.use_lock = 1;
801026c8:	c7 05 94 a6 14 80 01 	movl   $0x1,0x8014a694
801026cf:	00 00 00 
}
801026d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026d5:	5b                   	pop    %ebx
801026d6:	5e                   	pop    %esi
801026d7:	5d                   	pop    %ebp
801026d8:	c3                   	ret    
801026d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801026e0 <kinit1>:
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	56                   	push   %esi
801026e4:	53                   	push   %ebx
801026e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801026e8:	83 ec 08             	sub    $0x8,%esp
801026eb:	68 ec 7d 10 80       	push   $0x80107dec
801026f0:	68 60 a6 14 80       	push   $0x8014a660
801026f5:	e8 46 24 00 00       	call   80104b40 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026fd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102700:	c7 05 94 a6 14 80 00 	movl   $0x0,0x8014a694
80102707:	00 00 00 
  num_free_pages = 0;   //20181295
8010270a:	c7 05 40 a6 14 80 00 	movl   $0x0,0x8014a640
80102711:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102714:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010271a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102720:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102726:	39 de                	cmp    %ebx,%esi
80102728:	72 36                	jb     80102760 <kinit1+0x80>
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pgrefcount[V2P(p) >> PGSHIFT] = 0;  // 20181295
80102730:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
80102736:	83 ec 0c             	sub    $0xc,%esp
    pgrefcount[V2P(p) >> PGSHIFT] = 0;  // 20181295
80102739:	c1 e8 0c             	shr    $0xc,%eax
8010273c:	c7 04 85 40 26 11 80 	movl   $0x0,-0x7feed9c0(,%eax,4)
80102743:	00 00 00 00 
    kfree(p);
80102747:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010274d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102753:	50                   	push   %eax
80102754:	e8 d7 fd ff ff       	call   80102530 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102759:	83 c4 10             	add    $0x10,%esp
8010275c:	39 de                	cmp    %ebx,%esi
8010275e:	73 d0                	jae    80102730 <kinit1+0x50>
}
80102760:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102763:	5b                   	pop    %ebx
80102764:	5e                   	pop    %esi
80102765:	5d                   	pop    %ebp
80102766:	c3                   	ret    
80102767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276e:	66 90                	xchg   %ax,%ax

80102770 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102776:	8b 15 94 a6 14 80    	mov    0x8014a694,%edx
8010277c:	85 d2                	test   %edx,%edx
8010277e:	75 50                	jne    801027d0 <kalloc+0x60>
    acquire(&kmem.lock);
  num_free_pages--; // 20181295
  r = kmem.freelist;
80102780:	a1 98 a6 14 80       	mov    0x8014a698,%eax
  num_free_pages--; // 20181295
80102785:	83 2d 40 a6 14 80 01 	subl   $0x1,0x8014a640
  if(r){
8010278c:	85 c0                	test   %eax,%eax
8010278e:	74 20                	je     801027b0 <kalloc+0x40>
    kmem.freelist = r->next;
80102790:	8b 08                	mov    (%eax),%ecx
80102792:	89 0d 98 a6 14 80    	mov    %ecx,0x8014a698
    pgrefcount[V2P((char*)r) >> PGSHIFT] = 1; // 20181295
80102798:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010279e:	c1 e9 0c             	shr    $0xc,%ecx
801027a1:	c7 04 8d 40 26 11 80 	movl   $0x1,-0x7feed9c0(,%ecx,4)
801027a8:	01 00 00 00 
  }
  if(kmem.use_lock)
801027ac:	85 d2                	test   %edx,%edx
801027ae:	75 08                	jne    801027b8 <kalloc+0x48>
    release(&kmem.lock);
  return (char*)r;
}
801027b0:	c9                   	leave  
801027b1:	c3                   	ret    
801027b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801027b8:	83 ec 0c             	sub    $0xc,%esp
801027bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027be:	68 60 a6 14 80       	push   $0x8014a660
801027c3:	e8 e8 24 00 00       	call   80104cb0 <release>
  return (char*)r;
801027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801027cb:	83 c4 10             	add    $0x10,%esp
}
801027ce:	c9                   	leave  
801027cf:	c3                   	ret    
    acquire(&kmem.lock);
801027d0:	83 ec 0c             	sub    $0xc,%esp
801027d3:	68 60 a6 14 80       	push   $0x8014a660
801027d8:	e8 33 25 00 00       	call   80104d10 <acquire>
  r = kmem.freelist;
801027dd:	a1 98 a6 14 80       	mov    0x8014a698,%eax
  num_free_pages--; // 20181295
801027e2:	83 2d 40 a6 14 80 01 	subl   $0x1,0x8014a640
  if(r){
801027e9:	83 c4 10             	add    $0x10,%esp
  if(kmem.use_lock)
801027ec:	8b 15 94 a6 14 80    	mov    0x8014a694,%edx
  if(r){
801027f2:	85 c0                	test   %eax,%eax
801027f4:	75 9a                	jne    80102790 <kalloc+0x20>
801027f6:	eb b4                	jmp    801027ac <kalloc+0x3c>
801027f8:	66 90                	xchg   %ax,%ax
801027fa:	66 90                	xchg   %ax,%ax
801027fc:	66 90                	xchg   %ax,%ax
801027fe:	66 90                	xchg   %ax,%ax

80102800 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102800:	ba 64 00 00 00       	mov    $0x64,%edx
80102805:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102806:	a8 01                	test   $0x1,%al
80102808:	0f 84 c2 00 00 00    	je     801028d0 <kbdgetc+0xd0>
{
8010280e:	55                   	push   %ebp
8010280f:	ba 60 00 00 00       	mov    $0x60,%edx
80102814:	89 e5                	mov    %esp,%ebp
80102816:	53                   	push   %ebx
80102817:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102818:	8b 1d 9c a6 14 80    	mov    0x8014a69c,%ebx
  data = inb(KBDATAP);
8010281e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102821:	3c e0                	cmp    $0xe0,%al
80102823:	74 5b                	je     80102880 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102825:	89 da                	mov    %ebx,%edx
80102827:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010282a:	84 c0                	test   %al,%al
8010282c:	78 62                	js     80102890 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010282e:	85 d2                	test   %edx,%edx
80102830:	74 09                	je     8010283b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102832:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102835:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102838:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010283b:	0f b6 91 20 7f 10 80 	movzbl -0x7fef80e0(%ecx),%edx
  shift ^= togglecode[data];
80102842:	0f b6 81 20 7e 10 80 	movzbl -0x7fef81e0(%ecx),%eax
  shift |= shiftcode[data];
80102849:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010284b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010284d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010284f:	89 15 9c a6 14 80    	mov    %edx,0x8014a69c
  c = charcode[shift & (CTL | SHIFT)][data];
80102855:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102858:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010285b:	8b 04 85 00 7e 10 80 	mov    -0x7fef8200(,%eax,4),%eax
80102862:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102866:	74 0b                	je     80102873 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102868:	8d 50 9f             	lea    -0x61(%eax),%edx
8010286b:	83 fa 19             	cmp    $0x19,%edx
8010286e:	77 48                	ja     801028b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102870:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102873:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102876:	c9                   	leave  
80102877:	c3                   	ret    
80102878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop
    shift |= E0ESC;
80102880:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102883:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102885:	89 1d 9c a6 14 80    	mov    %ebx,0x8014a69c
}
8010288b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010288e:	c9                   	leave  
8010288f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102890:	83 e0 7f             	and    $0x7f,%eax
80102893:	85 d2                	test   %edx,%edx
80102895:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102898:	0f b6 81 20 7f 10 80 	movzbl -0x7fef80e0(%ecx),%eax
8010289f:	83 c8 40             	or     $0x40,%eax
801028a2:	0f b6 c0             	movzbl %al,%eax
801028a5:	f7 d0                	not    %eax
801028a7:	21 d8                	and    %ebx,%eax
}
801028a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801028ac:	a3 9c a6 14 80       	mov    %eax,0x8014a69c
    return 0;
801028b1:	31 c0                	xor    %eax,%eax
}
801028b3:	c9                   	leave  
801028b4:	c3                   	ret    
801028b5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801028b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801028be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028c1:	c9                   	leave  
      c += 'a' - 'A';
801028c2:	83 f9 1a             	cmp    $0x1a,%ecx
801028c5:	0f 42 c2             	cmovb  %edx,%eax
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801028d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028d5:	c3                   	ret    
801028d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028dd:	8d 76 00             	lea    0x0(%esi),%esi

801028e0 <kbdintr>:

void
kbdintr(void)
{
801028e0:	55                   	push   %ebp
801028e1:	89 e5                	mov    %esp,%ebp
801028e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028e6:	68 00 28 10 80       	push   $0x80102800
801028eb:	e8 90 df ff ff       	call   80100880 <consoleintr>
}
801028f0:	83 c4 10             	add    $0x10,%esp
801028f3:	c9                   	leave  
801028f4:	c3                   	ret    
801028f5:	66 90                	xchg   %ax,%ax
801028f7:	66 90                	xchg   %ax,%ax
801028f9:	66 90                	xchg   %ax,%ax
801028fb:	66 90                	xchg   %ax,%ax
801028fd:	66 90                	xchg   %ax,%ax
801028ff:	90                   	nop

80102900 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102900:	a1 a0 a6 14 80       	mov    0x8014a6a0,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	0f 84 cb 00 00 00    	je     801029d8 <lapicinit+0xd8>
  lapic[index] = value;
8010290d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102914:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102917:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102921:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102924:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102927:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010292e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102931:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102934:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010293b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010293e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102941:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102948:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010294b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010294e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102955:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102958:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010295b:	8b 50 30             	mov    0x30(%eax),%edx
8010295e:	c1 ea 10             	shr    $0x10,%edx
80102961:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102967:	75 77                	jne    801029e0 <lapicinit+0xe0>
  lapic[index] = value;
80102969:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102970:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102973:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102976:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010297d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102980:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102983:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010298a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010298d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102990:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102997:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010299a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010299d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029b4:	8b 50 20             	mov    0x20(%eax),%edx
801029b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029be:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029c6:	80 e6 10             	and    $0x10,%dh
801029c9:	75 f5                	jne    801029c0 <lapicinit+0xc0>
  lapic[index] = value;
801029cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029d8:	c3                   	ret    
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801029e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801029ed:	e9 77 ff ff ff       	jmp    80102969 <lapicinit+0x69>
801029f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a00:	a1 a0 a6 14 80       	mov    0x8014a6a0,%eax
80102a05:	85 c0                	test   %eax,%eax
80102a07:	74 07                	je     80102a10 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a09:	8b 40 20             	mov    0x20(%eax),%eax
80102a0c:	c1 e8 18             	shr    $0x18,%eax
80102a0f:	c3                   	ret    
    return 0;
80102a10:	31 c0                	xor    %eax,%eax
}
80102a12:	c3                   	ret    
80102a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a20:	a1 a0 a6 14 80       	mov    0x8014a6a0,%eax
80102a25:	85 c0                	test   %eax,%eax
80102a27:	74 0d                	je     80102a36 <lapiceoi+0x16>
  lapic[index] = value;
80102a29:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a33:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a36:	c3                   	ret    
80102a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a3e:	66 90                	xchg   %ax,%ax

80102a40 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a40:	c3                   	ret    
80102a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a4f:	90                   	nop

80102a50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a51:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a56:	ba 70 00 00 00       	mov    $0x70,%edx
80102a5b:	89 e5                	mov    %esp,%ebp
80102a5d:	53                   	push   %ebx
80102a5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a64:	ee                   	out    %al,(%dx)
80102a65:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a6a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a6f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a70:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a72:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a75:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a7b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a7d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102a80:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a82:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a85:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a88:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a8e:	a1 a0 a6 14 80       	mov    0x8014a6a0,%eax
80102a93:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a99:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a9c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102aa3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aa9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ab0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ab6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102abc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102abf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ac5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ac8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ace:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ad1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ad7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102add:	c9                   	leave  
80102ade:	c3                   	ret    
80102adf:	90                   	nop

80102ae0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ae0:	55                   	push   %ebp
80102ae1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ae6:	ba 70 00 00 00       	mov    $0x70,%edx
80102aeb:	89 e5                	mov    %esp,%ebp
80102aed:	57                   	push   %edi
80102aee:	56                   	push   %esi
80102aef:	53                   	push   %ebx
80102af0:	83 ec 4c             	sub    $0x4c,%esp
80102af3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af4:	ba 71 00 00 00       	mov    $0x71,%edx
80102af9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102afa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b05:	8d 76 00             	lea    0x0(%esi),%esi
80102b08:	31 c0                	xor    %eax,%eax
80102b0a:	89 da                	mov    %ebx,%edx
80102b0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b12:	89 ca                	mov    %ecx,%edx
80102b14:	ec                   	in     (%dx),%al
80102b15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b18:	89 da                	mov    %ebx,%edx
80102b1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b20:	89 ca                	mov    %ecx,%edx
80102b22:	ec                   	in     (%dx),%al
80102b23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b26:	89 da                	mov    %ebx,%edx
80102b28:	b8 04 00 00 00       	mov    $0x4,%eax
80102b2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2e:	89 ca                	mov    %ecx,%edx
80102b30:	ec                   	in     (%dx),%al
80102b31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b34:	89 da                	mov    %ebx,%edx
80102b36:	b8 07 00 00 00       	mov    $0x7,%eax
80102b3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3c:	89 ca                	mov    %ecx,%edx
80102b3e:	ec                   	in     (%dx),%al
80102b3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b42:	89 da                	mov    %ebx,%edx
80102b44:	b8 08 00 00 00       	mov    $0x8,%eax
80102b49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4a:	89 ca                	mov    %ecx,%edx
80102b4c:	ec                   	in     (%dx),%al
80102b4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4f:	89 da                	mov    %ebx,%edx
80102b51:	b8 09 00 00 00       	mov    $0x9,%eax
80102b56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b57:	89 ca                	mov    %ecx,%edx
80102b59:	ec                   	in     (%dx),%al
80102b5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b5c:	89 da                	mov    %ebx,%edx
80102b5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b64:	89 ca                	mov    %ecx,%edx
80102b66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b67:	84 c0                	test   %al,%al
80102b69:	78 9d                	js     80102b08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b6f:	89 fa                	mov    %edi,%edx
80102b71:	0f b6 fa             	movzbl %dl,%edi
80102b74:	89 f2                	mov    %esi,%edx
80102b76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b80:	89 da                	mov    %ebx,%edx
80102b82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102b85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b99:	31 c0                	xor    %eax,%eax
80102b9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9c:	89 ca                	mov    %ecx,%edx
80102b9e:	ec                   	in     (%dx),%al
80102b9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba2:	89 da                	mov    %ebx,%edx
80102ba4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ba7:	b8 02 00 00 00       	mov    $0x2,%eax
80102bac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bad:	89 ca                	mov    %ecx,%edx
80102baf:	ec                   	in     (%dx),%al
80102bb0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb3:	89 da                	mov    %ebx,%edx
80102bb5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102bb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbe:	89 ca                	mov    %ecx,%edx
80102bc0:	ec                   	in     (%dx),%al
80102bc1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc4:	89 da                	mov    %ebx,%edx
80102bc6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102bc9:	b8 07 00 00 00       	mov    $0x7,%eax
80102bce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcf:	89 ca                	mov    %ecx,%edx
80102bd1:	ec                   	in     (%dx),%al
80102bd2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd5:	89 da                	mov    %ebx,%edx
80102bd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102bda:	b8 08 00 00 00       	mov    $0x8,%eax
80102bdf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be0:	89 ca                	mov    %ecx,%edx
80102be2:	ec                   	in     (%dx),%al
80102be3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be6:	89 da                	mov    %ebx,%edx
80102be8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102beb:	b8 09 00 00 00       	mov    $0x9,%eax
80102bf0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf1:	89 ca                	mov    %ecx,%edx
80102bf3:	ec                   	in     (%dx),%al
80102bf4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bf7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102bfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bfd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c00:	6a 18                	push   $0x18
80102c02:	50                   	push   %eax
80102c03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c06:	50                   	push   %eax
80102c07:	e8 14 22 00 00       	call   80104e20 <memcmp>
80102c0c:	83 c4 10             	add    $0x10,%esp
80102c0f:	85 c0                	test   %eax,%eax
80102c11:	0f 85 f1 fe ff ff    	jne    80102b08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c1b:	75 78                	jne    80102c95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c20:	89 c2                	mov    %eax,%edx
80102c22:	83 e0 0f             	and    $0xf,%eax
80102c25:	c1 ea 04             	shr    $0x4,%edx
80102c28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c34:	89 c2                	mov    %eax,%edx
80102c36:	83 e0 0f             	and    $0xf,%eax
80102c39:	c1 ea 04             	shr    $0x4,%edx
80102c3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c48:	89 c2                	mov    %eax,%edx
80102c4a:	83 e0 0f             	and    $0xf,%eax
80102c4d:	c1 ea 04             	shr    $0x4,%edx
80102c50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c5c:	89 c2                	mov    %eax,%edx
80102c5e:	83 e0 0f             	and    $0xf,%eax
80102c61:	c1 ea 04             	shr    $0x4,%edx
80102c64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c70:	89 c2                	mov    %eax,%edx
80102c72:	83 e0 0f             	and    $0xf,%eax
80102c75:	c1 ea 04             	shr    $0x4,%edx
80102c78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c84:	89 c2                	mov    %eax,%edx
80102c86:	83 e0 0f             	and    $0xf,%eax
80102c89:	c1 ea 04             	shr    $0x4,%edx
80102c8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c95:	8b 75 08             	mov    0x8(%ebp),%esi
80102c98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c9b:	89 06                	mov    %eax,(%esi)
80102c9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ca0:	89 46 04             	mov    %eax,0x4(%esi)
80102ca3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ca6:	89 46 08             	mov    %eax,0x8(%esi)
80102ca9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cac:	89 46 0c             	mov    %eax,0xc(%esi)
80102caf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cb2:	89 46 10             	mov    %eax,0x10(%esi)
80102cb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102cbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102cc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cc5:	5b                   	pop    %ebx
80102cc6:	5e                   	pop    %esi
80102cc7:	5f                   	pop    %edi
80102cc8:	5d                   	pop    %ebp
80102cc9:	c3                   	ret    
80102cca:	66 90                	xchg   %ax,%ax
80102ccc:	66 90                	xchg   %ax,%ax
80102cce:	66 90                	xchg   %ax,%ax

80102cd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cd0:	8b 0d 08 a7 14 80    	mov    0x8014a708,%ecx
80102cd6:	85 c9                	test   %ecx,%ecx
80102cd8:	0f 8e 8a 00 00 00    	jle    80102d68 <install_trans+0x98>
{
80102cde:	55                   	push   %ebp
80102cdf:	89 e5                	mov    %esp,%ebp
80102ce1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ce2:	31 ff                	xor    %edi,%edi
{
80102ce4:	56                   	push   %esi
80102ce5:	53                   	push   %ebx
80102ce6:	83 ec 0c             	sub    $0xc,%esp
80102ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102cf0:	a1 f4 a6 14 80       	mov    0x8014a6f4,%eax
80102cf5:	83 ec 08             	sub    $0x8,%esp
80102cf8:	01 f8                	add    %edi,%eax
80102cfa:	83 c0 01             	add    $0x1,%eax
80102cfd:	50                   	push   %eax
80102cfe:	ff 35 04 a7 14 80    	push   0x8014a704
80102d04:	e8 c7 d3 ff ff       	call   801000d0 <bread>
80102d09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d0b:	58                   	pop    %eax
80102d0c:	5a                   	pop    %edx
80102d0d:	ff 34 bd 0c a7 14 80 	push   -0x7feb58f4(,%edi,4)
80102d14:	ff 35 04 a7 14 80    	push   0x8014a704
  for (tail = 0; tail < log.lh.n; tail++) {
80102d1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d1d:	e8 ae d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d2a:	68 00 02 00 00       	push   $0x200
80102d2f:	50                   	push   %eax
80102d30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d33:	50                   	push   %eax
80102d34:	e8 37 21 00 00       	call   80104e70 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d39:	89 1c 24             	mov    %ebx,(%esp)
80102d3c:	e8 6f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d41:	89 34 24             	mov    %esi,(%esp)
80102d44:	e8 a7 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d49:	89 1c 24             	mov    %ebx,(%esp)
80102d4c:	e8 9f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d51:	83 c4 10             	add    $0x10,%esp
80102d54:	39 3d 08 a7 14 80    	cmp    %edi,0x8014a708
80102d5a:	7f 94                	jg     80102cf0 <install_trans+0x20>
  }
}
80102d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d5f:	5b                   	pop    %ebx
80102d60:	5e                   	pop    %esi
80102d61:	5f                   	pop    %edi
80102d62:	5d                   	pop    %ebp
80102d63:	c3                   	ret    
80102d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d68:	c3                   	ret    
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d77:	ff 35 f4 a6 14 80    	push   0x8014a6f4
80102d7d:	ff 35 04 a7 14 80    	push   0x8014a704
80102d83:	e8 48 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d8d:	a1 08 a7 14 80       	mov    0x8014a708,%eax
80102d92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d95:	85 c0                	test   %eax,%eax
80102d97:	7e 19                	jle    80102db2 <write_head+0x42>
80102d99:	31 d2                	xor    %edx,%edx
80102d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d9f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102da0:	8b 0c 95 0c a7 14 80 	mov    -0x7feb58f4(,%edx,4),%ecx
80102da7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dab:	83 c2 01             	add    $0x1,%edx
80102dae:	39 d0                	cmp    %edx,%eax
80102db0:	75 ee                	jne    80102da0 <write_head+0x30>
  }
  bwrite(buf);
80102db2:	83 ec 0c             	sub    $0xc,%esp
80102db5:	53                   	push   %ebx
80102db6:	e8 f5 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102dbb:	89 1c 24             	mov    %ebx,(%esp)
80102dbe:	e8 2d d4 ff ff       	call   801001f0 <brelse>
}
80102dc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dc6:	83 c4 10             	add    $0x10,%esp
80102dc9:	c9                   	leave  
80102dca:	c3                   	ret    
80102dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dcf:	90                   	nop

80102dd0 <initlog>:
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	53                   	push   %ebx
80102dd4:	83 ec 2c             	sub    $0x2c,%esp
80102dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dda:	68 20 80 10 80       	push   $0x80108020
80102ddf:	68 c0 a6 14 80       	push   $0x8014a6c0
80102de4:	e8 57 1d 00 00       	call   80104b40 <initlock>
  readsb(dev, &sb);
80102de9:	58                   	pop    %eax
80102dea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ded:	5a                   	pop    %edx
80102dee:	50                   	push   %eax
80102def:	53                   	push   %ebx
80102df0:	e8 2b e7 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102df8:	59                   	pop    %ecx
  log.dev = dev;
80102df9:	89 1d 04 a7 14 80    	mov    %ebx,0x8014a704
  log.size = sb.nlog;
80102dff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e02:	a3 f4 a6 14 80       	mov    %eax,0x8014a6f4
  log.size = sb.nlog;
80102e07:	89 15 f8 a6 14 80    	mov    %edx,0x8014a6f8
  struct buf *buf = bread(log.dev, log.start);
80102e0d:	5a                   	pop    %edx
80102e0e:	50                   	push   %eax
80102e0f:	53                   	push   %ebx
80102e10:	e8 bb d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102e1b:	89 1d 08 a7 14 80    	mov    %ebx,0x8014a708
  for (i = 0; i < log.lh.n; i++) {
80102e21:	85 db                	test   %ebx,%ebx
80102e23:	7e 1d                	jle    80102e42 <initlog+0x72>
80102e25:	31 d2                	xor    %edx,%edx
80102e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102e30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102e34:	89 0c 95 0c a7 14 80 	mov    %ecx,-0x7feb58f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e3b:	83 c2 01             	add    $0x1,%edx
80102e3e:	39 d3                	cmp    %edx,%ebx
80102e40:	75 ee                	jne    80102e30 <initlog+0x60>
  brelse(buf);
80102e42:	83 ec 0c             	sub    $0xc,%esp
80102e45:	50                   	push   %eax
80102e46:	e8 a5 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e4b:	e8 80 fe ff ff       	call   80102cd0 <install_trans>
  log.lh.n = 0;
80102e50:	c7 05 08 a7 14 80 00 	movl   $0x0,0x8014a708
80102e57:	00 00 00 
  write_head(); // clear the log
80102e5a:	e8 11 ff ff ff       	call   80102d70 <write_head>
}
80102e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e62:	83 c4 10             	add    $0x10,%esp
80102e65:	c9                   	leave  
80102e66:	c3                   	ret    
80102e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6e:	66 90                	xchg   %ax,%ax

80102e70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e76:	68 c0 a6 14 80       	push   $0x8014a6c0
80102e7b:	e8 90 1e 00 00       	call   80104d10 <acquire>
80102e80:	83 c4 10             	add    $0x10,%esp
80102e83:	eb 18                	jmp    80102e9d <begin_op+0x2d>
80102e85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e88:	83 ec 08             	sub    $0x8,%esp
80102e8b:	68 c0 a6 14 80       	push   $0x8014a6c0
80102e90:	68 c0 a6 14 80       	push   $0x8014a6c0
80102e95:	e8 76 13 00 00       	call   80104210 <sleep>
80102e9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e9d:	a1 00 a7 14 80       	mov    0x8014a700,%eax
80102ea2:	85 c0                	test   %eax,%eax
80102ea4:	75 e2                	jne    80102e88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ea6:	a1 fc a6 14 80       	mov    0x8014a6fc,%eax
80102eab:	8b 15 08 a7 14 80    	mov    0x8014a708,%edx
80102eb1:	83 c0 01             	add    $0x1,%eax
80102eb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102eb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102eba:	83 fa 1e             	cmp    $0x1e,%edx
80102ebd:	7f c9                	jg     80102e88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ebf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ec2:	a3 fc a6 14 80       	mov    %eax,0x8014a6fc
      release(&log.lock);
80102ec7:	68 c0 a6 14 80       	push   $0x8014a6c0
80102ecc:	e8 df 1d 00 00       	call   80104cb0 <release>
      break;
    }
  }
}
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	c9                   	leave  
80102ed5:	c3                   	ret    
80102ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102edd:	8d 76 00             	lea    0x0(%esi),%esi

80102ee0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	57                   	push   %edi
80102ee4:	56                   	push   %esi
80102ee5:	53                   	push   %ebx
80102ee6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ee9:	68 c0 a6 14 80       	push   $0x8014a6c0
80102eee:	e8 1d 1e 00 00       	call   80104d10 <acquire>
  log.outstanding -= 1;
80102ef3:	a1 fc a6 14 80       	mov    0x8014a6fc,%eax
  if(log.committing)
80102ef8:	8b 35 00 a7 14 80    	mov    0x8014a700,%esi
80102efe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f04:	89 1d fc a6 14 80    	mov    %ebx,0x8014a6fc
  if(log.committing)
80102f0a:	85 f6                	test   %esi,%esi
80102f0c:	0f 85 22 01 00 00    	jne    80103034 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f12:	85 db                	test   %ebx,%ebx
80102f14:	0f 85 f6 00 00 00    	jne    80103010 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f1a:	c7 05 00 a7 14 80 01 	movl   $0x1,0x8014a700
80102f21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 c0 a6 14 80       	push   $0x8014a6c0
80102f2c:	e8 7f 1d 00 00       	call   80104cb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f31:	8b 0d 08 a7 14 80    	mov    0x8014a708,%ecx
80102f37:	83 c4 10             	add    $0x10,%esp
80102f3a:	85 c9                	test   %ecx,%ecx
80102f3c:	7f 42                	jg     80102f80 <end_op+0xa0>
    acquire(&log.lock);
80102f3e:	83 ec 0c             	sub    $0xc,%esp
80102f41:	68 c0 a6 14 80       	push   $0x8014a6c0
80102f46:	e8 c5 1d 00 00       	call   80104d10 <acquire>
    wakeup(&log);
80102f4b:	c7 04 24 c0 a6 14 80 	movl   $0x8014a6c0,(%esp)
    log.committing = 0;
80102f52:	c7 05 00 a7 14 80 00 	movl   $0x0,0x8014a700
80102f59:	00 00 00 
    wakeup(&log);
80102f5c:	e8 6f 13 00 00       	call   801042d0 <wakeup>
    release(&log.lock);
80102f61:	c7 04 24 c0 a6 14 80 	movl   $0x8014a6c0,(%esp)
80102f68:	e8 43 1d 00 00       	call   80104cb0 <release>
80102f6d:	83 c4 10             	add    $0x10,%esp
}
80102f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f73:	5b                   	pop    %ebx
80102f74:	5e                   	pop    %esi
80102f75:	5f                   	pop    %edi
80102f76:	5d                   	pop    %ebp
80102f77:	c3                   	ret    
80102f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f80:	a1 f4 a6 14 80       	mov    0x8014a6f4,%eax
80102f85:	83 ec 08             	sub    $0x8,%esp
80102f88:	01 d8                	add    %ebx,%eax
80102f8a:	83 c0 01             	add    $0x1,%eax
80102f8d:	50                   	push   %eax
80102f8e:	ff 35 04 a7 14 80    	push   0x8014a704
80102f94:	e8 37 d1 ff ff       	call   801000d0 <bread>
80102f99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f9b:	58                   	pop    %eax
80102f9c:	5a                   	pop    %edx
80102f9d:	ff 34 9d 0c a7 14 80 	push   -0x7feb58f4(,%ebx,4)
80102fa4:	ff 35 04 a7 14 80    	push   0x8014a704
  for (tail = 0; tail < log.lh.n; tail++) {
80102faa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fad:	e8 1e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102fb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102fb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102fba:	68 00 02 00 00       	push   $0x200
80102fbf:	50                   	push   %eax
80102fc0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fc3:	50                   	push   %eax
80102fc4:	e8 a7 1e 00 00       	call   80104e70 <memmove>
    bwrite(to);  // write the log
80102fc9:	89 34 24             	mov    %esi,(%esp)
80102fcc:	e8 df d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102fd1:	89 3c 24             	mov    %edi,(%esp)
80102fd4:	e8 17 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102fd9:	89 34 24             	mov    %esi,(%esp)
80102fdc:	e8 0f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fe1:	83 c4 10             	add    $0x10,%esp
80102fe4:	3b 1d 08 a7 14 80    	cmp    0x8014a708,%ebx
80102fea:	7c 94                	jl     80102f80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fec:	e8 7f fd ff ff       	call   80102d70 <write_head>
    install_trans(); // Now install writes to home locations
80102ff1:	e8 da fc ff ff       	call   80102cd0 <install_trans>
    log.lh.n = 0;
80102ff6:	c7 05 08 a7 14 80 00 	movl   $0x0,0x8014a708
80102ffd:	00 00 00 
    write_head();    // Erase the transaction from the log
80103000:	e8 6b fd ff ff       	call   80102d70 <write_head>
80103005:	e9 34 ff ff ff       	jmp    80102f3e <end_op+0x5e>
8010300a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103010:	83 ec 0c             	sub    $0xc,%esp
80103013:	68 c0 a6 14 80       	push   $0x8014a6c0
80103018:	e8 b3 12 00 00       	call   801042d0 <wakeup>
  release(&log.lock);
8010301d:	c7 04 24 c0 a6 14 80 	movl   $0x8014a6c0,(%esp)
80103024:	e8 87 1c 00 00       	call   80104cb0 <release>
80103029:	83 c4 10             	add    $0x10,%esp
}
8010302c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
    panic("log.committing");
80103034:	83 ec 0c             	sub    $0xc,%esp
80103037:	68 24 80 10 80       	push   $0x80108024
8010303c:	e8 3f d3 ff ff       	call   80100380 <panic>
80103041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010304f:	90                   	nop

80103050 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	53                   	push   %ebx
80103054:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103057:	8b 15 08 a7 14 80    	mov    0x8014a708,%edx
{
8010305d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103060:	83 fa 1d             	cmp    $0x1d,%edx
80103063:	0f 8f 85 00 00 00    	jg     801030ee <log_write+0x9e>
80103069:	a1 f8 a6 14 80       	mov    0x8014a6f8,%eax
8010306e:	83 e8 01             	sub    $0x1,%eax
80103071:	39 c2                	cmp    %eax,%edx
80103073:	7d 79                	jge    801030ee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103075:	a1 fc a6 14 80       	mov    0x8014a6fc,%eax
8010307a:	85 c0                	test   %eax,%eax
8010307c:	7e 7d                	jle    801030fb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010307e:	83 ec 0c             	sub    $0xc,%esp
80103081:	68 c0 a6 14 80       	push   $0x8014a6c0
80103086:	e8 85 1c 00 00       	call   80104d10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010308b:	8b 15 08 a7 14 80    	mov    0x8014a708,%edx
80103091:	83 c4 10             	add    $0x10,%esp
80103094:	85 d2                	test   %edx,%edx
80103096:	7e 4a                	jle    801030e2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103098:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010309b:	31 c0                	xor    %eax,%eax
8010309d:	eb 08                	jmp    801030a7 <log_write+0x57>
8010309f:	90                   	nop
801030a0:	83 c0 01             	add    $0x1,%eax
801030a3:	39 c2                	cmp    %eax,%edx
801030a5:	74 29                	je     801030d0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030a7:	39 0c 85 0c a7 14 80 	cmp    %ecx,-0x7feb58f4(,%eax,4)
801030ae:	75 f0                	jne    801030a0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801030b0:	89 0c 85 0c a7 14 80 	mov    %ecx,-0x7feb58f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801030b7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801030ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801030bd:	c7 45 08 c0 a6 14 80 	movl   $0x8014a6c0,0x8(%ebp)
}
801030c4:	c9                   	leave  
  release(&log.lock);
801030c5:	e9 e6 1b 00 00       	jmp    80104cb0 <release>
801030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030d0:	89 0c 95 0c a7 14 80 	mov    %ecx,-0x7feb58f4(,%edx,4)
    log.lh.n++;
801030d7:	83 c2 01             	add    $0x1,%edx
801030da:	89 15 08 a7 14 80    	mov    %edx,0x8014a708
801030e0:	eb d5                	jmp    801030b7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801030e2:	8b 43 08             	mov    0x8(%ebx),%eax
801030e5:	a3 0c a7 14 80       	mov    %eax,0x8014a70c
  if (i == log.lh.n)
801030ea:	75 cb                	jne    801030b7 <log_write+0x67>
801030ec:	eb e9                	jmp    801030d7 <log_write+0x87>
    panic("too big a transaction");
801030ee:	83 ec 0c             	sub    $0xc,%esp
801030f1:	68 33 80 10 80       	push   $0x80108033
801030f6:	e8 85 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801030fb:	83 ec 0c             	sub    $0xc,%esp
801030fe:	68 49 80 10 80       	push   $0x80108049
80103103:	e8 78 d2 ff ff       	call   80100380 <panic>
80103108:	66 90                	xchg   %ax,%ax
8010310a:	66 90                	xchg   %ax,%ax
8010310c:	66 90                	xchg   %ax,%ax
8010310e:	66 90                	xchg   %ax,%ax

80103110 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	53                   	push   %ebx
80103114:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103117:	e8 64 09 00 00       	call   80103a80 <cpuid>
8010311c:	89 c3                	mov    %eax,%ebx
8010311e:	e8 5d 09 00 00       	call   80103a80 <cpuid>
80103123:	83 ec 04             	sub    $0x4,%esp
80103126:	53                   	push   %ebx
80103127:	50                   	push   %eax
80103128:	68 64 80 10 80       	push   $0x80108064
8010312d:	e8 6e d5 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103132:	e8 e9 30 00 00       	call   80106220 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103137:	e8 e4 08 00 00       	call   80103a20 <mycpu>
8010313c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010313e:	b8 01 00 00 00       	mov    $0x1,%eax
80103143:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010314a:	e8 21 0c 00 00       	call   80103d70 <scheduler>
8010314f:	90                   	nop

80103150 <mpenter>:
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103156:	e8 d5 41 00 00       	call   80107330 <switchkvm>
  seginit();
8010315b:	e8 40 41 00 00       	call   801072a0 <seginit>
  lapicinit();
80103160:	e8 9b f7 ff ff       	call   80102900 <lapicinit>
  mpmain();
80103165:	e8 a6 ff ff ff       	call   80103110 <mpmain>
8010316a:	66 90                	xchg   %ax,%ax
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <main>:
{
80103170:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103174:	83 e4 f0             	and    $0xfffffff0,%esp
80103177:	ff 71 fc             	push   -0x4(%ecx)
8010317a:	55                   	push   %ebp
8010317b:	89 e5                	mov    %esp,%ebp
8010317d:	53                   	push   %ebx
8010317e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010317f:	83 ec 08             	sub    $0x8,%esp
80103182:	68 00 00 40 80       	push   $0x80400000
80103187:	68 f0 e6 14 80       	push   $0x8014e6f0
8010318c:	e8 4f f5 ff ff       	call   801026e0 <kinit1>
  kvmalloc();      // kernel page table
80103191:	e8 8a 46 00 00       	call   80107820 <kvmalloc>
  mpinit();        // detect other processors
80103196:	e8 85 01 00 00       	call   80103320 <mpinit>
  lapicinit();     // interrupt controller
8010319b:	e8 60 f7 ff ff       	call   80102900 <lapicinit>
  seginit();       // segment descriptors
801031a0:	e8 fb 40 00 00       	call   801072a0 <seginit>
  picinit();       // disable pic
801031a5:	e8 76 03 00 00       	call   80103520 <picinit>
  ioapicinit();    // another interrupt controller
801031aa:	e8 21 f2 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
801031af:	e8 ac d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801031b4:	e8 77 33 00 00       	call   80106530 <uartinit>
  pinit();         // process table
801031b9:	e8 42 08 00 00       	call   80103a00 <pinit>
  tvinit();        // trap vectors
801031be:	e8 dd 2f 00 00       	call   801061a0 <tvinit>
  binit();         // buffer cache
801031c3:	e8 78 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
801031c8:	e8 43 dc ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801031cd:	e8 ee ef ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031d2:	83 c4 0c             	add    $0xc,%esp
801031d5:	68 8a 00 00 00       	push   $0x8a
801031da:	68 8c b4 10 80       	push   $0x8010b48c
801031df:	68 00 70 00 80       	push   $0x80007000
801031e4:	e8 87 1c 00 00       	call   80104e70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	69 05 a4 a7 14 80 b0 	imul   $0xb0,0x8014a7a4,%eax
801031f3:	00 00 00 
801031f6:	05 c0 a7 14 80       	add    $0x8014a7c0,%eax
801031fb:	3d c0 a7 14 80       	cmp    $0x8014a7c0,%eax
80103200:	76 7e                	jbe    80103280 <main+0x110>
80103202:	bb c0 a7 14 80       	mov    $0x8014a7c0,%ebx
80103207:	eb 20                	jmp    80103229 <main+0xb9>
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103210:	69 05 a4 a7 14 80 b0 	imul   $0xb0,0x8014a7a4,%eax
80103217:	00 00 00 
8010321a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103220:	05 c0 a7 14 80       	add    $0x8014a7c0,%eax
80103225:	39 c3                	cmp    %eax,%ebx
80103227:	73 57                	jae    80103280 <main+0x110>
    if(c == mycpu())  // We've started already.
80103229:	e8 f2 07 00 00       	call   80103a20 <mycpu>
8010322e:	39 c3                	cmp    %eax,%ebx
80103230:	74 de                	je     80103210 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103232:	e8 39 f5 ff ff       	call   80102770 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103237:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010323a:	c7 05 f8 6f 00 80 50 	movl   $0x80103150,0x80006ff8
80103241:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103244:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010324b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010324e:	05 00 10 00 00       	add    $0x1000,%eax
80103253:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103258:	0f b6 03             	movzbl (%ebx),%eax
8010325b:	68 00 70 00 00       	push   $0x7000
80103260:	50                   	push   %eax
80103261:	e8 ea f7 ff ff       	call   80102a50 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103266:	83 c4 10             	add    $0x10,%esp
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103270:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103276:	85 c0                	test   %eax,%eax
80103278:	74 f6                	je     80103270 <main+0x100>
8010327a:	eb 94                	jmp    80103210 <main+0xa0>
8010327c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103280:	83 ec 08             	sub    $0x8,%esp
80103283:	68 00 00 00 8e       	push   $0x8e000000
80103288:	68 00 00 40 80       	push   $0x80400000
8010328d:	e8 de f3 ff ff       	call   80102670 <kinit2>
  userinit();      // first user process
80103292:	e8 39 08 00 00       	call   80103ad0 <userinit>
  mpmain();        // finish this processor's setup
80103297:	e8 74 fe ff ff       	call   80103110 <mpmain>
8010329c:	66 90                	xchg   %ax,%ax
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032ab:	53                   	push   %ebx
  e = addr+len;
801032ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801032b2:	39 de                	cmp    %ebx,%esi
801032b4:	72 10                	jb     801032c6 <mpsearch1+0x26>
801032b6:	eb 50                	jmp    80103308 <mpsearch1+0x68>
801032b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032bf:	90                   	nop
801032c0:	89 fe                	mov    %edi,%esi
801032c2:	39 fb                	cmp    %edi,%ebx
801032c4:	76 42                	jbe    80103308 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032c6:	83 ec 04             	sub    $0x4,%esp
801032c9:	8d 7e 10             	lea    0x10(%esi),%edi
801032cc:	6a 04                	push   $0x4
801032ce:	68 78 80 10 80       	push   $0x80108078
801032d3:	56                   	push   %esi
801032d4:	e8 47 1b 00 00       	call   80104e20 <memcmp>
801032d9:	83 c4 10             	add    $0x10,%esp
801032dc:	85 c0                	test   %eax,%eax
801032de:	75 e0                	jne    801032c0 <mpsearch1+0x20>
801032e0:	89 f2                	mov    %esi,%edx
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801032eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801032ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801032f0:	39 fa                	cmp    %edi,%edx
801032f2:	75 f4                	jne    801032e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032f4:	84 c0                	test   %al,%al
801032f6:	75 c8                	jne    801032c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032fb:	89 f0                	mov    %esi,%eax
801032fd:	5b                   	pop    %ebx
801032fe:	5e                   	pop    %esi
801032ff:	5f                   	pop    %edi
80103300:	5d                   	pop    %ebp
80103301:	c3                   	ret    
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010330b:	31 f6                	xor    %esi,%esi
}
8010330d:	5b                   	pop    %ebx
8010330e:	89 f0                	mov    %esi,%eax
80103310:	5e                   	pop    %esi
80103311:	5f                   	pop    %edi
80103312:	5d                   	pop    %ebp
80103313:	c3                   	ret    
80103314:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010331b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010331f:	90                   	nop

80103320 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
80103325:	53                   	push   %ebx
80103326:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103329:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103330:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103337:	c1 e0 08             	shl    $0x8,%eax
8010333a:	09 d0                	or     %edx,%eax
8010333c:	c1 e0 04             	shl    $0x4,%eax
8010333f:	75 1b                	jne    8010335c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103341:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103348:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010334f:	c1 e0 08             	shl    $0x8,%eax
80103352:	09 d0                	or     %edx,%eax
80103354:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103357:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010335c:	ba 00 04 00 00       	mov    $0x400,%edx
80103361:	e8 3a ff ff ff       	call   801032a0 <mpsearch1>
80103366:	89 c3                	mov    %eax,%ebx
80103368:	85 c0                	test   %eax,%eax
8010336a:	0f 84 40 01 00 00    	je     801034b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103370:	8b 73 04             	mov    0x4(%ebx),%esi
80103373:	85 f6                	test   %esi,%esi
80103375:	0f 84 25 01 00 00    	je     801034a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010337b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010337e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103384:	6a 04                	push   $0x4
80103386:	68 7d 80 10 80       	push   $0x8010807d
8010338b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010338c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010338f:	e8 8c 1a 00 00       	call   80104e20 <memcmp>
80103394:	83 c4 10             	add    $0x10,%esp
80103397:	85 c0                	test   %eax,%eax
80103399:	0f 85 01 01 00 00    	jne    801034a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010339f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801033a6:	3c 01                	cmp    $0x1,%al
801033a8:	74 08                	je     801033b2 <mpinit+0x92>
801033aa:	3c 04                	cmp    $0x4,%al
801033ac:	0f 85 ee 00 00 00    	jne    801034a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801033b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801033b9:	66 85 d2             	test   %dx,%dx
801033bc:	74 22                	je     801033e0 <mpinit+0xc0>
801033be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801033c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801033c3:	31 d2                	xor    %edx,%edx
801033c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801033cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801033d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033d4:	39 c7                	cmp    %eax,%edi
801033d6:	75 f0                	jne    801033c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801033d8:	84 d2                	test   %dl,%dl
801033da:	0f 85 c0 00 00 00    	jne    801034a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801033e6:	a3 a0 a6 14 80       	mov    %eax,0x8014a6a0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801033f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801033f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103400:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103407:	90                   	nop
80103408:	39 d0                	cmp    %edx,%eax
8010340a:	73 15                	jae    80103421 <mpinit+0x101>
    switch(*p){
8010340c:	0f b6 08             	movzbl (%eax),%ecx
8010340f:	80 f9 02             	cmp    $0x2,%cl
80103412:	74 4c                	je     80103460 <mpinit+0x140>
80103414:	77 3a                	ja     80103450 <mpinit+0x130>
80103416:	84 c9                	test   %cl,%cl
80103418:	74 56                	je     80103470 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010341a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010341d:	39 d0                	cmp    %edx,%eax
8010341f:	72 eb                	jb     8010340c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103421:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103424:	85 f6                	test   %esi,%esi
80103426:	0f 84 d9 00 00 00    	je     80103505 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010342c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103430:	74 15                	je     80103447 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103432:	b8 70 00 00 00       	mov    $0x70,%eax
80103437:	ba 22 00 00 00       	mov    $0x22,%edx
8010343c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010343d:	ba 23 00 00 00       	mov    $0x23,%edx
80103442:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103443:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103446:	ee                   	out    %al,(%dx)
  }
}
80103447:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010344a:	5b                   	pop    %ebx
8010344b:	5e                   	pop    %esi
8010344c:	5f                   	pop    %edi
8010344d:	5d                   	pop    %ebp
8010344e:	c3                   	ret    
8010344f:	90                   	nop
    switch(*p){
80103450:	83 e9 03             	sub    $0x3,%ecx
80103453:	80 f9 01             	cmp    $0x1,%cl
80103456:	76 c2                	jbe    8010341a <mpinit+0xfa>
80103458:	31 f6                	xor    %esi,%esi
8010345a:	eb ac                	jmp    80103408 <mpinit+0xe8>
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103460:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103464:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103467:	88 0d a0 a7 14 80    	mov    %cl,0x8014a7a0
      continue;
8010346d:	eb 99                	jmp    80103408 <mpinit+0xe8>
8010346f:	90                   	nop
      if(ncpu < NCPU) {
80103470:	8b 0d a4 a7 14 80    	mov    0x8014a7a4,%ecx
80103476:	83 f9 07             	cmp    $0x7,%ecx
80103479:	7f 19                	jg     80103494 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010347b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103481:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103485:	83 c1 01             	add    $0x1,%ecx
80103488:	89 0d a4 a7 14 80    	mov    %ecx,0x8014a7a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010348e:	88 9f c0 a7 14 80    	mov    %bl,-0x7feb5840(%edi)
      p += sizeof(struct mpproc);
80103494:	83 c0 14             	add    $0x14,%eax
      continue;
80103497:	e9 6c ff ff ff       	jmp    80103408 <mpinit+0xe8>
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	68 82 80 10 80       	push   $0x80108082
801034a8:	e8 d3 ce ff ff       	call   80100380 <panic>
801034ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801034b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801034b5:	eb 13                	jmp    801034ca <mpinit+0x1aa>
801034b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801034c0:	89 f3                	mov    %esi,%ebx
801034c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801034c8:	74 d6                	je     801034a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ca:	83 ec 04             	sub    $0x4,%esp
801034cd:	8d 73 10             	lea    0x10(%ebx),%esi
801034d0:	6a 04                	push   $0x4
801034d2:	68 78 80 10 80       	push   $0x80108078
801034d7:	53                   	push   %ebx
801034d8:	e8 43 19 00 00       	call   80104e20 <memcmp>
801034dd:	83 c4 10             	add    $0x10,%esp
801034e0:	85 c0                	test   %eax,%eax
801034e2:	75 dc                	jne    801034c0 <mpinit+0x1a0>
801034e4:	89 da                	mov    %ebx,%edx
801034e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801034f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801034f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801034f8:	39 d6                	cmp    %edx,%esi
801034fa:	75 f4                	jne    801034f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034fc:	84 c0                	test   %al,%al
801034fe:	75 c0                	jne    801034c0 <mpinit+0x1a0>
80103500:	e9 6b fe ff ff       	jmp    80103370 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103505:	83 ec 0c             	sub    $0xc,%esp
80103508:	68 9c 80 10 80       	push   $0x8010809c
8010350d:	e8 6e ce ff ff       	call   80100380 <panic>
80103512:	66 90                	xchg   %ax,%ax
80103514:	66 90                	xchg   %ax,%ax
80103516:	66 90                	xchg   %ax,%ax
80103518:	66 90                	xchg   %ax,%ax
8010351a:	66 90                	xchg   %ax,%ax
8010351c:	66 90                	xchg   %ax,%ax
8010351e:	66 90                	xchg   %ax,%ax

80103520 <picinit>:
80103520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103525:	ba 21 00 00 00       	mov    $0x21,%edx
8010352a:	ee                   	out    %al,(%dx)
8010352b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103530:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103531:	c3                   	ret    
80103532:	66 90                	xchg   %ax,%ax
80103534:	66 90                	xchg   %ax,%ax
80103536:	66 90                	xchg   %ax,%ax
80103538:	66 90                	xchg   %ax,%ax
8010353a:	66 90                	xchg   %ax,%ax
8010353c:	66 90                	xchg   %ax,%ax
8010353e:	66 90                	xchg   %ax,%ax

80103540 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 0c             	sub    $0xc,%esp
80103549:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010354c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010354f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103555:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010355b:	e8 d0 d8 ff ff       	call   80100e30 <filealloc>
80103560:	89 03                	mov    %eax,(%ebx)
80103562:	85 c0                	test   %eax,%eax
80103564:	0f 84 a8 00 00 00    	je     80103612 <pipealloc+0xd2>
8010356a:	e8 c1 d8 ff ff       	call   80100e30 <filealloc>
8010356f:	89 06                	mov    %eax,(%esi)
80103571:	85 c0                	test   %eax,%eax
80103573:	0f 84 87 00 00 00    	je     80103600 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103579:	e8 f2 f1 ff ff       	call   80102770 <kalloc>
8010357e:	89 c7                	mov    %eax,%edi
80103580:	85 c0                	test   %eax,%eax
80103582:	0f 84 b0 00 00 00    	je     80103638 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103588:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010358f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103592:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103595:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010359c:	00 00 00 
  p->nwrite = 0;
8010359f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035a6:	00 00 00 
  p->nread = 0;
801035a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035b0:	00 00 00 
  initlock(&p->lock, "pipe");
801035b3:	68 bb 80 10 80       	push   $0x801080bb
801035b8:	50                   	push   %eax
801035b9:	e8 82 15 00 00       	call   80104b40 <initlock>
  (*f0)->type = FD_PIPE;
801035be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035c9:	8b 03                	mov    (%ebx),%eax
801035cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035cf:	8b 03                	mov    (%ebx),%eax
801035d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035d5:	8b 03                	mov    (%ebx),%eax
801035d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035da:	8b 06                	mov    (%esi),%eax
801035dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035e2:	8b 06                	mov    (%esi),%eax
801035e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035e8:	8b 06                	mov    (%esi),%eax
801035ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035ee:	8b 06                	mov    (%esi),%eax
801035f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035f6:	31 c0                	xor    %eax,%eax
}
801035f8:	5b                   	pop    %ebx
801035f9:	5e                   	pop    %esi
801035fa:	5f                   	pop    %edi
801035fb:	5d                   	pop    %ebp
801035fc:	c3                   	ret    
801035fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103600:	8b 03                	mov    (%ebx),%eax
80103602:	85 c0                	test   %eax,%eax
80103604:	74 1e                	je     80103624 <pipealloc+0xe4>
    fileclose(*f0);
80103606:	83 ec 0c             	sub    $0xc,%esp
80103609:	50                   	push   %eax
8010360a:	e8 e1 d8 ff ff       	call   80100ef0 <fileclose>
8010360f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103612:	8b 06                	mov    (%esi),%eax
80103614:	85 c0                	test   %eax,%eax
80103616:	74 0c                	je     80103624 <pipealloc+0xe4>
    fileclose(*f1);
80103618:	83 ec 0c             	sub    $0xc,%esp
8010361b:	50                   	push   %eax
8010361c:	e8 cf d8 ff ff       	call   80100ef0 <fileclose>
80103621:	83 c4 10             	add    $0x10,%esp
}
80103624:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103627:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010362c:	5b                   	pop    %ebx
8010362d:	5e                   	pop    %esi
8010362e:	5f                   	pop    %edi
8010362f:	5d                   	pop    %ebp
80103630:	c3                   	ret    
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103638:	8b 03                	mov    (%ebx),%eax
8010363a:	85 c0                	test   %eax,%eax
8010363c:	75 c8                	jne    80103606 <pipealloc+0xc6>
8010363e:	eb d2                	jmp    80103612 <pipealloc+0xd2>

80103640 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	56                   	push   %esi
80103644:	53                   	push   %ebx
80103645:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103648:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010364b:	83 ec 0c             	sub    $0xc,%esp
8010364e:	53                   	push   %ebx
8010364f:	e8 bc 16 00 00       	call   80104d10 <acquire>
  if(writable){
80103654:	83 c4 10             	add    $0x10,%esp
80103657:	85 f6                	test   %esi,%esi
80103659:	74 65                	je     801036c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010365b:	83 ec 0c             	sub    $0xc,%esp
8010365e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103664:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010366b:	00 00 00 
    wakeup(&p->nread);
8010366e:	50                   	push   %eax
8010366f:	e8 5c 0c 00 00       	call   801042d0 <wakeup>
80103674:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103677:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010367d:	85 d2                	test   %edx,%edx
8010367f:	75 0a                	jne    8010368b <pipeclose+0x4b>
80103681:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103687:	85 c0                	test   %eax,%eax
80103689:	74 15                	je     801036a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010368b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010368e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103691:	5b                   	pop    %ebx
80103692:	5e                   	pop    %esi
80103693:	5d                   	pop    %ebp
    release(&p->lock);
80103694:	e9 17 16 00 00       	jmp    80104cb0 <release>
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	53                   	push   %ebx
801036a4:	e8 07 16 00 00       	call   80104cb0 <release>
    kfree((char*)p);
801036a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036ac:	83 c4 10             	add    $0x10,%esp
}
801036af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036b2:	5b                   	pop    %ebx
801036b3:	5e                   	pop    %esi
801036b4:	5d                   	pop    %ebp
    kfree((char*)p);
801036b5:	e9 76 ee ff ff       	jmp    80102530 <kfree>
801036ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801036c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036d0:	00 00 00 
    wakeup(&p->nwrite);
801036d3:	50                   	push   %eax
801036d4:	e8 f7 0b 00 00       	call   801042d0 <wakeup>
801036d9:	83 c4 10             	add    $0x10,%esp
801036dc:	eb 99                	jmp    80103677 <pipeclose+0x37>
801036de:	66 90                	xchg   %ax,%ax

801036e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 28             	sub    $0x28,%esp
801036e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801036ec:	53                   	push   %ebx
801036ed:	e8 1e 16 00 00       	call   80104d10 <acquire>
  for(i = 0; i < n; i++){
801036f2:	8b 45 10             	mov    0x10(%ebp),%eax
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	85 c0                	test   %eax,%eax
801036fa:	0f 8e c0 00 00 00    	jle    801037c0 <pipewrite+0xe0>
80103700:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103703:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103709:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010370f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103712:	03 45 10             	add    0x10(%ebp),%eax
80103715:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103718:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010371e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103724:	89 ca                	mov    %ecx,%edx
80103726:	05 00 02 00 00       	add    $0x200,%eax
8010372b:	39 c1                	cmp    %eax,%ecx
8010372d:	74 3f                	je     8010376e <pipewrite+0x8e>
8010372f:	eb 67                	jmp    80103798 <pipewrite+0xb8>
80103731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103738:	e8 63 03 00 00       	call   80103aa0 <myproc>
8010373d:	8b 48 24             	mov    0x24(%eax),%ecx
80103740:	85 c9                	test   %ecx,%ecx
80103742:	75 34                	jne    80103778 <pipewrite+0x98>
      wakeup(&p->nread);
80103744:	83 ec 0c             	sub    $0xc,%esp
80103747:	57                   	push   %edi
80103748:	e8 83 0b 00 00       	call   801042d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010374d:	58                   	pop    %eax
8010374e:	5a                   	pop    %edx
8010374f:	53                   	push   %ebx
80103750:	56                   	push   %esi
80103751:	e8 ba 0a 00 00       	call   80104210 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103756:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010375c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103762:	83 c4 10             	add    $0x10,%esp
80103765:	05 00 02 00 00       	add    $0x200,%eax
8010376a:	39 c2                	cmp    %eax,%edx
8010376c:	75 2a                	jne    80103798 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010376e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103774:	85 c0                	test   %eax,%eax
80103776:	75 c0                	jne    80103738 <pipewrite+0x58>
        release(&p->lock);
80103778:	83 ec 0c             	sub    $0xc,%esp
8010377b:	53                   	push   %ebx
8010377c:	e8 2f 15 00 00       	call   80104cb0 <release>
        return -1;
80103781:	83 c4 10             	add    $0x10,%esp
80103784:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103789:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010378c:	5b                   	pop    %ebx
8010378d:	5e                   	pop    %esi
8010378e:	5f                   	pop    %edi
8010378f:	5d                   	pop    %ebp
80103790:	c3                   	ret    
80103791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103798:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010379b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010379e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801037aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801037ad:	83 c6 01             	add    $0x1,%esi
801037b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801037ba:	0f 85 58 ff ff ff    	jne    80103718 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037c9:	50                   	push   %eax
801037ca:	e8 01 0b 00 00       	call   801042d0 <wakeup>
  release(&p->lock);
801037cf:	89 1c 24             	mov    %ebx,(%esp)
801037d2:	e8 d9 14 00 00       	call   80104cb0 <release>
  return n;
801037d7:	8b 45 10             	mov    0x10(%ebp),%eax
801037da:	83 c4 10             	add    $0x10,%esp
801037dd:	eb aa                	jmp    80103789 <pipewrite+0xa9>
801037df:	90                   	nop

801037e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	57                   	push   %edi
801037e4:	56                   	push   %esi
801037e5:	53                   	push   %ebx
801037e6:	83 ec 18             	sub    $0x18,%esp
801037e9:	8b 75 08             	mov    0x8(%ebp),%esi
801037ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037ef:	56                   	push   %esi
801037f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037f6:	e8 15 15 00 00       	call   80104d10 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103801:	83 c4 10             	add    $0x10,%esp
80103804:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010380a:	74 2f                	je     8010383b <piperead+0x5b>
8010380c:	eb 37                	jmp    80103845 <piperead+0x65>
8010380e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103810:	e8 8b 02 00 00       	call   80103aa0 <myproc>
80103815:	8b 48 24             	mov    0x24(%eax),%ecx
80103818:	85 c9                	test   %ecx,%ecx
8010381a:	0f 85 80 00 00 00    	jne    801038a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103820:	83 ec 08             	sub    $0x8,%esp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	e8 e6 09 00 00       	call   80104210 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010382a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103830:	83 c4 10             	add    $0x10,%esp
80103833:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103839:	75 0a                	jne    80103845 <piperead+0x65>
8010383b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103841:	85 c0                	test   %eax,%eax
80103843:	75 cb                	jne    80103810 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103845:	8b 55 10             	mov    0x10(%ebp),%edx
80103848:	31 db                	xor    %ebx,%ebx
8010384a:	85 d2                	test   %edx,%edx
8010384c:	7f 20                	jg     8010386e <piperead+0x8e>
8010384e:	eb 2c                	jmp    8010387c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103850:	8d 48 01             	lea    0x1(%eax),%ecx
80103853:	25 ff 01 00 00       	and    $0x1ff,%eax
80103858:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010385e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103863:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103866:	83 c3 01             	add    $0x1,%ebx
80103869:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010386c:	74 0e                	je     8010387c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010386e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103874:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010387a:	75 d4                	jne    80103850 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010387c:	83 ec 0c             	sub    $0xc,%esp
8010387f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103885:	50                   	push   %eax
80103886:	e8 45 0a 00 00       	call   801042d0 <wakeup>
  release(&p->lock);
8010388b:	89 34 24             	mov    %esi,(%esp)
8010388e:	e8 1d 14 00 00       	call   80104cb0 <release>
  return i;
80103893:	83 c4 10             	add    $0x10,%esp
}
80103896:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103899:	89 d8                	mov    %ebx,%eax
8010389b:	5b                   	pop    %ebx
8010389c:	5e                   	pop    %esi
8010389d:	5f                   	pop    %edi
8010389e:	5d                   	pop    %ebp
8010389f:	c3                   	ret    
      release(&p->lock);
801038a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038a8:	56                   	push   %esi
801038a9:	e8 02 14 00 00       	call   80104cb0 <release>
      return -1;
801038ae:	83 c4 10             	add    $0x10,%esp
}
801038b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038b4:	89 d8                	mov    %ebx,%eax
801038b6:	5b                   	pop    %ebx
801038b7:	5e                   	pop    %esi
801038b8:	5f                   	pop    %edi
801038b9:	5d                   	pop    %ebp
801038ba:	c3                   	ret    
801038bb:	66 90                	xchg   %ax,%ax
801038bd:	66 90                	xchg   %ax,%ax
801038bf:	90                   	nop

801038c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038c4:	bb 74 ad 14 80       	mov    $0x8014ad74,%ebx
{
801038c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038cc:	68 40 ad 14 80       	push   $0x8014ad40
801038d1:	e8 3a 14 00 00       	call   80104d10 <acquire>
801038d6:	83 c4 10             	add    $0x10,%esp
801038d9:	eb 17                	jmp    801038f2 <allocproc+0x32>
801038db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038df:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e0:	81 c3 84 00 00 00    	add    $0x84,%ebx
801038e6:	81 fb 74 ce 14 80    	cmp    $0x8014ce74,%ebx
801038ec:	0f 84 8e 00 00 00    	je     80103980 <allocproc+0xc0>
    if(p->state == UNUSED)
801038f2:	8b 43 0c             	mov    0xc(%ebx),%eax
801038f5:	85 c0                	test   %eax,%eax
801038f7:	75 e7                	jne    801038e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038f9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->priority = 5;                  //20181295 initialize priority
  p->cnt = 0;                       //20181295 initialize cnt

  release(&ptable.lock);
801038fe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103901:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 5;                  //20181295 initialize priority
80103908:	c7 43 7c 05 00 00 00 	movl   $0x5,0x7c(%ebx)
  p->pid = nextpid++;
8010390f:	89 43 10             	mov    %eax,0x10(%ebx)
80103912:	8d 50 01             	lea    0x1(%eax),%edx
  p->cnt = 0;                       //20181295 initialize cnt
80103915:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010391c:	00 00 00 
  release(&ptable.lock);
8010391f:	68 40 ad 14 80       	push   $0x8014ad40
  p->pid = nextpid++;
80103924:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010392a:	e8 81 13 00 00       	call   80104cb0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010392f:	e8 3c ee ff ff       	call   80102770 <kalloc>
80103934:	83 c4 10             	add    $0x10,%esp
80103937:	89 43 08             	mov    %eax,0x8(%ebx)
8010393a:	85 c0                	test   %eax,%eax
8010393c:	74 5b                	je     80103999 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010393e:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103944:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103947:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010394c:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010394f:	c7 40 14 8d 61 10 80 	movl   $0x8010618d,0x14(%eax)
  p->context = (struct context*)sp;
80103956:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103959:	6a 14                	push   $0x14
8010395b:	6a 00                	push   $0x0
8010395d:	50                   	push   %eax
8010395e:	e8 6d 14 00 00       	call   80104dd0 <memset>
  p->context->eip = (uint)forkret;
80103963:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103966:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103969:	c7 40 10 b0 39 10 80 	movl   $0x801039b0,0x10(%eax)
}
80103970:	89 d8                	mov    %ebx,%eax
80103972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103975:	c9                   	leave  
80103976:	c3                   	ret    
80103977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010397e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103980:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103983:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103985:	68 40 ad 14 80       	push   $0x8014ad40
8010398a:	e8 21 13 00 00       	call   80104cb0 <release>
}
8010398f:	89 d8                	mov    %ebx,%eax
  return 0;
80103991:	83 c4 10             	add    $0x10,%esp
}
80103994:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103997:	c9                   	leave  
80103998:	c3                   	ret    
    p->state = UNUSED;
80103999:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801039a0:	31 db                	xor    %ebx,%ebx
}
801039a2:	89 d8                	mov    %ebx,%eax
801039a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a7:	c9                   	leave  
801039a8:	c3                   	ret    
801039a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039b6:	68 40 ad 14 80       	push   $0x8014ad40
801039bb:	e8 f0 12 00 00       	call   80104cb0 <release>

  if (first) {
801039c0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801039c5:	83 c4 10             	add    $0x10,%esp
801039c8:	85 c0                	test   %eax,%eax
801039ca:	75 04                	jne    801039d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039cc:	c9                   	leave  
801039cd:	c3                   	ret    
801039ce:	66 90                	xchg   %ax,%ax
    first = 0;
801039d0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801039d7:	00 00 00 
    iinit(ROOTDEV);
801039da:	83 ec 0c             	sub    $0xc,%esp
801039dd:	6a 01                	push   $0x1
801039df:	e8 7c db ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801039e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039eb:	e8 e0 f3 ff ff       	call   80102dd0 <initlog>
}
801039f0:	83 c4 10             	add    $0x10,%esp
801039f3:	c9                   	leave  
801039f4:	c3                   	ret    
801039f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a00 <pinit>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a06:	68 c0 80 10 80       	push   $0x801080c0
80103a0b:	68 40 ad 14 80       	push   $0x8014ad40
80103a10:	e8 2b 11 00 00       	call   80104b40 <initlock>
}
80103a15:	83 c4 10             	add    $0x10,%esp
80103a18:	c9                   	leave  
80103a19:	c3                   	ret    
80103a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a20 <mycpu>:
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	56                   	push   %esi
80103a24:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a25:	9c                   	pushf  
80103a26:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a27:	f6 c4 02             	test   $0x2,%ah
80103a2a:	75 46                	jne    80103a72 <mycpu+0x52>
  apicid = lapicid();
80103a2c:	e8 cf ef ff ff       	call   80102a00 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a31:	8b 35 a4 a7 14 80    	mov    0x8014a7a4,%esi
80103a37:	85 f6                	test   %esi,%esi
80103a39:	7e 2a                	jle    80103a65 <mycpu+0x45>
80103a3b:	31 d2                	xor    %edx,%edx
80103a3d:	eb 08                	jmp    80103a47 <mycpu+0x27>
80103a3f:	90                   	nop
80103a40:	83 c2 01             	add    $0x1,%edx
80103a43:	39 f2                	cmp    %esi,%edx
80103a45:	74 1e                	je     80103a65 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a47:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a4d:	0f b6 99 c0 a7 14 80 	movzbl -0x7feb5840(%ecx),%ebx
80103a54:	39 c3                	cmp    %eax,%ebx
80103a56:	75 e8                	jne    80103a40 <mycpu+0x20>
}
80103a58:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a5b:	8d 81 c0 a7 14 80    	lea    -0x7feb5840(%ecx),%eax
}
80103a61:	5b                   	pop    %ebx
80103a62:	5e                   	pop    %esi
80103a63:	5d                   	pop    %ebp
80103a64:	c3                   	ret    
  panic("unknown apicid\n");
80103a65:	83 ec 0c             	sub    $0xc,%esp
80103a68:	68 c7 80 10 80       	push   $0x801080c7
80103a6d:	e8 0e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a72:	83 ec 0c             	sub    $0xc,%esp
80103a75:	68 d0 81 10 80       	push   $0x801081d0
80103a7a:	e8 01 c9 ff ff       	call   80100380 <panic>
80103a7f:	90                   	nop

80103a80 <cpuid>:
cpuid() {
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a86:	e8 95 ff ff ff       	call   80103a20 <mycpu>
}
80103a8b:	c9                   	leave  
  return mycpu()-cpus;
80103a8c:	2d c0 a7 14 80       	sub    $0x8014a7c0,%eax
80103a91:	c1 f8 04             	sar    $0x4,%eax
80103a94:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a9a:	c3                   	ret    
80103a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a9f:	90                   	nop

80103aa0 <myproc>:
myproc(void) {
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	53                   	push   %ebx
80103aa4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103aa7:	e8 14 11 00 00       	call   80104bc0 <pushcli>
  c = mycpu();
80103aac:	e8 6f ff ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103ab1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ab7:	e8 54 11 00 00       	call   80104c10 <popcli>
}
80103abc:	89 d8                	mov    %ebx,%eax
80103abe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ac1:	c9                   	leave  
80103ac2:	c3                   	ret    
80103ac3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ad0 <userinit>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	53                   	push   %ebx
80103ad4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ad7:	e8 e4 fd ff ff       	call   801038c0 <allocproc>
80103adc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103ade:	a3 74 ce 14 80       	mov    %eax,0x8014ce74
  if((p->pgdir = setupkvm()) == 0)
80103ae3:	e8 b8 3c 00 00       	call   801077a0 <setupkvm>
80103ae8:	89 43 04             	mov    %eax,0x4(%ebx)
80103aeb:	85 c0                	test   %eax,%eax
80103aed:	0f 84 bd 00 00 00    	je     80103bb0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103af3:	83 ec 04             	sub    $0x4,%esp
80103af6:	68 2c 00 00 00       	push   $0x2c
80103afb:	68 60 b4 10 80       	push   $0x8010b460
80103b00:	50                   	push   %eax
80103b01:	e8 4a 39 00 00       	call   80107450 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b06:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b09:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b0f:	6a 4c                	push   $0x4c
80103b11:	6a 00                	push   $0x0
80103b13:	ff 73 18             	push   0x18(%ebx)
80103b16:	e8 b5 12 00 00       	call   80104dd0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b1b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b1e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b23:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b26:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b2b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b32:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b36:	8b 43 18             	mov    0x18(%ebx),%eax
80103b39:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b41:	8b 43 18             	mov    0x18(%ebx),%eax
80103b44:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b48:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b4c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b4f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b56:	8b 43 18             	mov    0x18(%ebx),%eax
80103b59:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b60:	8b 43 18             	mov    0x18(%ebx),%eax
80103b63:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b6a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b6d:	6a 10                	push   $0x10
80103b6f:	68 f0 80 10 80       	push   $0x801080f0
80103b74:	50                   	push   %eax
80103b75:	e8 16 14 00 00       	call   80104f90 <safestrcpy>
  p->cwd = namei("/");
80103b7a:	c7 04 24 f9 80 10 80 	movl   $0x801080f9,(%esp)
80103b81:	e8 1a e5 ff ff       	call   801020a0 <namei>
80103b86:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b89:	c7 04 24 40 ad 14 80 	movl   $0x8014ad40,(%esp)
80103b90:	e8 7b 11 00 00       	call   80104d10 <acquire>
  p->state = RUNNABLE;
80103b95:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b9c:	c7 04 24 40 ad 14 80 	movl   $0x8014ad40,(%esp)
80103ba3:	e8 08 11 00 00       	call   80104cb0 <release>
}
80103ba8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bab:	83 c4 10             	add    $0x10,%esp
80103bae:	c9                   	leave  
80103baf:	c3                   	ret    
    panic("userinit: out of memory?");
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	68 d7 80 10 80       	push   $0x801080d7
80103bb8:	e8 c3 c7 ff ff       	call   80100380 <panic>
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi

80103bc0 <growproc>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	56                   	push   %esi
80103bc4:	53                   	push   %ebx
80103bc5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bc8:	e8 f3 0f 00 00       	call   80104bc0 <pushcli>
  c = mycpu();
80103bcd:	e8 4e fe ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103bd2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bd8:	e8 33 10 00 00       	call   80104c10 <popcli>
  sz = curproc->sz;
80103bdd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bdf:	85 f6                	test   %esi,%esi
80103be1:	7f 1d                	jg     80103c00 <growproc+0x40>
  } else if(n < 0){
80103be3:	75 3b                	jne    80103c20 <growproc+0x60>
  switchuvm(curproc);
80103be5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103be8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bea:	53                   	push   %ebx
80103beb:	e8 50 37 00 00       	call   80107340 <switchuvm>
  return 0;
80103bf0:	83 c4 10             	add    $0x10,%esp
80103bf3:	31 c0                	xor    %eax,%eax
}
80103bf5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf8:	5b                   	pop    %ebx
80103bf9:	5e                   	pop    %esi
80103bfa:	5d                   	pop    %ebp
80103bfb:	c3                   	ret    
80103bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c00:	83 ec 04             	sub    $0x4,%esp
80103c03:	01 c6                	add    %eax,%esi
80103c05:	56                   	push   %esi
80103c06:	50                   	push   %eax
80103c07:	ff 73 04             	push   0x4(%ebx)
80103c0a:	e8 b1 39 00 00       	call   801075c0 <allocuvm>
80103c0f:	83 c4 10             	add    $0x10,%esp
80103c12:	85 c0                	test   %eax,%eax
80103c14:	75 cf                	jne    80103be5 <growproc+0x25>
      return -1;
80103c16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c1b:	eb d8                	jmp    80103bf5 <growproc+0x35>
80103c1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c20:	83 ec 04             	sub    $0x4,%esp
80103c23:	01 c6                	add    %eax,%esi
80103c25:	56                   	push   %esi
80103c26:	50                   	push   %eax
80103c27:	ff 73 04             	push   0x4(%ebx)
80103c2a:	e8 c1 3a 00 00       	call   801076f0 <deallocuvm>
80103c2f:	83 c4 10             	add    $0x10,%esp
80103c32:	85 c0                	test   %eax,%eax
80103c34:	75 af                	jne    80103be5 <growproc+0x25>
80103c36:	eb de                	jmp    80103c16 <growproc+0x56>
80103c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c3f:	90                   	nop

80103c40 <fork>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c49:	e8 72 0f 00 00       	call   80104bc0 <pushcli>
  c = mycpu();
80103c4e:	e8 cd fd ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103c53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c59:	e8 b2 0f 00 00       	call   80104c10 <popcli>
  if((np = allocproc()) == 0){
80103c5e:	e8 5d fc ff ff       	call   801038c0 <allocproc>
80103c63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c66:	85 c0                	test   %eax,%eax
80103c68:	0f 84 c7 00 00 00    	je     80103d35 <fork+0xf5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c6e:	83 ec 08             	sub    $0x8,%esp
80103c71:	ff 33                	push   (%ebx)
80103c73:	89 c7                	mov    %eax,%edi
80103c75:	ff 73 04             	push   0x4(%ebx)
80103c78:	e8 13 3c 00 00       	call   80107890 <copyuvm>
80103c7d:	83 c4 10             	add    $0x10,%esp
80103c80:	89 47 04             	mov    %eax,0x4(%edi)
80103c83:	85 c0                	test   %eax,%eax
80103c85:	0f 84 b1 00 00 00    	je     80103d3c <fork+0xfc>
  np->sz = curproc->sz;
80103c8b:	8b 03                	mov    (%ebx),%eax
80103c8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c90:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c92:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c95:	89 59 14             	mov    %ebx,0x14(%ecx)
  np->priority = curproc->priority;                       //20181295 copy priority
80103c98:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103c9b:	89 41 7c             	mov    %eax,0x7c(%ecx)
  *np->tf = *curproc->tf;
80103c9e:	89 c8                	mov    %ecx,%eax
80103ca0:	8b 73 18             	mov    0x18(%ebx),%esi
80103ca3:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ca8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103caa:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cac:	8b 40 18             	mov    0x18(%eax),%eax
80103caf:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103cc0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cc4:	85 c0                	test   %eax,%eax
80103cc6:	74 13                	je     80103cdb <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cc8:	83 ec 0c             	sub    $0xc,%esp
80103ccb:	50                   	push   %eax
80103ccc:	e8 cf d1 ff ff       	call   80100ea0 <filedup>
80103cd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cd4:	83 c4 10             	add    $0x10,%esp
80103cd7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103cdb:	83 c6 01             	add    $0x1,%esi
80103cde:	83 fe 10             	cmp    $0x10,%esi
80103ce1:	75 dd                	jne    80103cc0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103ce3:	83 ec 0c             	sub    $0xc,%esp
80103ce6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ce9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cec:	e8 5f da ff ff       	call   80101750 <idup>
80103cf1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cf4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103cf7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cfa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103cfd:	6a 10                	push   $0x10
80103cff:	53                   	push   %ebx
80103d00:	50                   	push   %eax
80103d01:	e8 8a 12 00 00       	call   80104f90 <safestrcpy>
  pid = np->pid;
80103d06:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d09:	c7 04 24 40 ad 14 80 	movl   $0x8014ad40,(%esp)
80103d10:	e8 fb 0f 00 00       	call   80104d10 <acquire>
  np->state = RUNNABLE;
80103d15:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d1c:	c7 04 24 40 ad 14 80 	movl   $0x8014ad40,(%esp)
80103d23:	e8 88 0f 00 00       	call   80104cb0 <release>
  return pid;
80103d28:	83 c4 10             	add    $0x10,%esp
}
80103d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d2e:	89 d8                	mov    %ebx,%eax
80103d30:	5b                   	pop    %ebx
80103d31:	5e                   	pop    %esi
80103d32:	5f                   	pop    %edi
80103d33:	5d                   	pop    %ebp
80103d34:	c3                   	ret    
    return -1;
80103d35:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d3a:	eb ef                	jmp    80103d2b <fork+0xeb>
    kfree(np->kstack);
80103d3c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d3f:	83 ec 0c             	sub    $0xc,%esp
80103d42:	ff 73 08             	push   0x8(%ebx)
80103d45:	e8 e6 e7 ff ff       	call   80102530 <kfree>
    np->kstack = 0;
80103d4a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d51:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d54:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d5b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d60:	eb c9                	jmp    80103d2b <fork+0xeb>
80103d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d70 <scheduler>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	57                   	push   %edi
80103d74:	56                   	push   %esi
80103d75:	53                   	push   %ebx
80103d76:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d79:	e8 a2 fc ff ff       	call   80103a20 <mycpu>
  c->proc = 0;
80103d7e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d85:	00 00 00 
  struct cpu *c = mycpu();
80103d88:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d8a:	8d 78 04             	lea    0x4(%eax),%edi
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d90:	fb                   	sti    
    acquire(&ptable.lock);
80103d91:	83 ec 0c             	sub    $0xc,%esp
    minp = 0;
80103d94:	31 db                	xor    %ebx,%ebx
    acquire(&ptable.lock);
80103d96:	68 40 ad 14 80       	push   $0x8014ad40
80103d9b:	e8 70 0f 00 00       	call   80104d10 <acquire>
80103da0:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103da3:	b8 74 ad 14 80       	mov    $0x8014ad74,%eax
80103da8:	eb 12                	jmp    80103dbc <scheduler+0x4c>
80103daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103db0:	05 84 00 00 00       	add    $0x84,%eax
80103db5:	3d 74 ce 14 80       	cmp    $0x8014ce74,%eax
80103dba:	74 3c                	je     80103df8 <scheduler+0x88>
      if(p->state == RUNNABLE){
80103dbc:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103dc0:	75 ee                	jne    80103db0 <scheduler+0x40>
        if(!minp || minp->priority > p->priority)
80103dc2:	85 db                	test   %ebx,%ebx
80103dc4:	0f 84 b6 00 00 00    	je     80103e80 <scheduler+0x110>
80103dca:	8b 48 7c             	mov    0x7c(%eax),%ecx
80103dcd:	39 4b 7c             	cmp    %ecx,0x7c(%ebx)
80103dd0:	0f 8f aa 00 00 00    	jg     80103e80 <scheduler+0x110>
        else if (minp->priority == p->priority)
80103dd6:	75 d8                	jne    80103db0 <scheduler+0x40>
          minp = (minp->cnt < p->cnt ? minp : p);
80103dd8:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103dde:	39 93 80 00 00 00    	cmp    %edx,0x80(%ebx)
80103de4:	0f 4d d8             	cmovge %eax,%ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103de7:	05 84 00 00 00       	add    $0x84,%eax
80103dec:	3d 74 ce 14 80       	cmp    $0x8014ce74,%eax
80103df1:	75 c9                	jne    80103dbc <scheduler+0x4c>
80103df3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103df7:	90                   	nop
    if (!minp){
80103df8:	85 db                	test   %ebx,%ebx
80103dfa:	0f 84 87 00 00 00    	je     80103e87 <scheduler+0x117>
    switchuvm(minp);
80103e00:	83 ec 0c             	sub    $0xc,%esp
    c->proc = minp;
80103e03:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
    switchuvm(minp);
80103e09:	53                   	push   %ebx
80103e0a:	e8 31 35 00 00       	call   80107340 <switchuvm>
    minp->cnt++;  //20181295 increase cnt when the process is called by scheduler
80103e0f:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
    minp->state = RUNNING;
80103e15:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    minp->cnt++;  //20181295 increase cnt when the process is called by scheduler
80103e1c:	8d 48 01             	lea    0x1(%eax),%ecx
    if ((minp->priority += minp->cnt / 30) > 10) minp->priority = 10;  //20181295 increase priority if process was called a lot
80103e1f:	b8 89 88 88 88       	mov    $0x88888889,%eax
80103e24:	f7 e9                	imul   %ecx
    minp->cnt++;  //20181295 increase cnt when the process is called by scheduler
80103e26:	89 8b 80 00 00 00    	mov    %ecx,0x80(%ebx)
    if ((minp->priority += minp->cnt / 30) > 10) minp->priority = 10;  //20181295 increase priority if process was called a lot
80103e2c:	01 ca                	add    %ecx,%edx
80103e2e:	c1 f9 1f             	sar    $0x1f,%ecx
80103e31:	c1 fa 04             	sar    $0x4,%edx
80103e34:	29 ca                	sub    %ecx,%edx
80103e36:	01 53 7c             	add    %edx,0x7c(%ebx)
80103e39:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103e3c:	ba 0a 00 00 00       	mov    $0xa,%edx
80103e41:	39 d0                	cmp    %edx,%eax
80103e43:	0f 4f c2             	cmovg  %edx,%eax
80103e46:	89 43 7c             	mov    %eax,0x7c(%ebx)
    swtch(&(c->scheduler), minp->context);
80103e49:	58                   	pop    %eax
80103e4a:	5a                   	pop    %edx
80103e4b:	ff 73 1c             	push   0x1c(%ebx)
80103e4e:	57                   	push   %edi
80103e4f:	e8 97 11 00 00       	call   80104feb <swtch>
    switchkvm();
80103e54:	e8 d7 34 00 00       	call   80107330 <switchkvm>
    c->proc = 0;
80103e59:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e60:	00 00 00 
    release(&ptable.lock);
80103e63:	c7 04 24 40 ad 14 80 	movl   $0x8014ad40,(%esp)
80103e6a:	e8 41 0e 00 00       	call   80104cb0 <release>
80103e6f:	83 c4 10             	add    $0x10,%esp
80103e72:	e9 19 ff ff ff       	jmp    80103d90 <scheduler+0x20>
80103e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7e:	66 90                	xchg   %ax,%ax
80103e80:	89 c3                	mov    %eax,%ebx
80103e82:	e9 29 ff ff ff       	jmp    80103db0 <scheduler+0x40>
      release(&ptable.lock);
80103e87:	83 ec 0c             	sub    $0xc,%esp
80103e8a:	68 40 ad 14 80       	push   $0x8014ad40
80103e8f:	e8 1c 0e 00 00       	call   80104cb0 <release>
      continue;
80103e94:	83 c4 10             	add    $0x10,%esp
80103e97:	e9 f4 fe ff ff       	jmp    80103d90 <scheduler+0x20>
80103e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ea0 <sched>:
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	56                   	push   %esi
80103ea4:	53                   	push   %ebx
  pushcli();
80103ea5:	e8 16 0d 00 00       	call   80104bc0 <pushcli>
  c = mycpu();
80103eaa:	e8 71 fb ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103eaf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103eb5:	e8 56 0d 00 00       	call   80104c10 <popcli>
  if(!holding(&ptable.lock))
80103eba:	83 ec 0c             	sub    $0xc,%esp
80103ebd:	68 40 ad 14 80       	push   $0x8014ad40
80103ec2:	e8 a9 0d 00 00       	call   80104c70 <holding>
80103ec7:	83 c4 10             	add    $0x10,%esp
80103eca:	85 c0                	test   %eax,%eax
80103ecc:	74 4f                	je     80103f1d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103ece:	e8 4d fb ff ff       	call   80103a20 <mycpu>
80103ed3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eda:	75 68                	jne    80103f44 <sched+0xa4>
  if(p->state == RUNNING)
80103edc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ee0:	74 55                	je     80103f37 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ee2:	9c                   	pushf  
80103ee3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ee4:	f6 c4 02             	test   $0x2,%ah
80103ee7:	75 41                	jne    80103f2a <sched+0x8a>
  intena = mycpu()->intena;
80103ee9:	e8 32 fb ff ff       	call   80103a20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103eee:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ef1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ef7:	e8 24 fb ff ff       	call   80103a20 <mycpu>
80103efc:	83 ec 08             	sub    $0x8,%esp
80103eff:	ff 70 04             	push   0x4(%eax)
80103f02:	53                   	push   %ebx
80103f03:	e8 e3 10 00 00       	call   80104feb <swtch>
  mycpu()->intena = intena;
80103f08:	e8 13 fb ff ff       	call   80103a20 <mycpu>
}
80103f0d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f10:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f19:	5b                   	pop    %ebx
80103f1a:	5e                   	pop    %esi
80103f1b:	5d                   	pop    %ebp
80103f1c:	c3                   	ret    
    panic("sched ptable.lock");
80103f1d:	83 ec 0c             	sub    $0xc,%esp
80103f20:	68 fb 80 10 80       	push   $0x801080fb
80103f25:	e8 56 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f2a:	83 ec 0c             	sub    $0xc,%esp
80103f2d:	68 27 81 10 80       	push   $0x80108127
80103f32:	e8 49 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103f37:	83 ec 0c             	sub    $0xc,%esp
80103f3a:	68 19 81 10 80       	push   $0x80108119
80103f3f:	e8 3c c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103f44:	83 ec 0c             	sub    $0xc,%esp
80103f47:	68 0d 81 10 80       	push   $0x8010810d
80103f4c:	e8 2f c4 ff ff       	call   80100380 <panic>
80103f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f5f:	90                   	nop

80103f60 <exit>:
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	57                   	push   %edi
80103f64:	56                   	push   %esi
80103f65:	53                   	push   %ebx
80103f66:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103f69:	e8 32 fb ff ff       	call   80103aa0 <myproc>
  if(curproc == initproc)
80103f6e:	39 05 74 ce 14 80    	cmp    %eax,0x8014ce74
80103f74:	0f 84 07 01 00 00    	je     80104081 <exit+0x121>
80103f7a:	89 c3                	mov    %eax,%ebx
80103f7c:	8d 70 28             	lea    0x28(%eax),%esi
80103f7f:	8d 78 68             	lea    0x68(%eax),%edi
80103f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103f88:	8b 06                	mov    (%esi),%eax
80103f8a:	85 c0                	test   %eax,%eax
80103f8c:	74 12                	je     80103fa0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103f8e:	83 ec 0c             	sub    $0xc,%esp
80103f91:	50                   	push   %eax
80103f92:	e8 59 cf ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103f97:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f9d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103fa0:	83 c6 04             	add    $0x4,%esi
80103fa3:	39 f7                	cmp    %esi,%edi
80103fa5:	75 e1                	jne    80103f88 <exit+0x28>
  begin_op();
80103fa7:	e8 c4 ee ff ff       	call   80102e70 <begin_op>
  iput(curproc->cwd);
80103fac:	83 ec 0c             	sub    $0xc,%esp
80103faf:	ff 73 68             	push   0x68(%ebx)
80103fb2:	e8 f9 d8 ff ff       	call   801018b0 <iput>
  end_op();
80103fb7:	e8 24 ef ff ff       	call   80102ee0 <end_op>
  curproc->cwd = 0;
80103fbc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103fc3:	c7 04 24 40 ad 14 80 	movl   $0x8014ad40,(%esp)
80103fca:	e8 41 0d 00 00       	call   80104d10 <acquire>
  wakeup1(curproc->parent);
80103fcf:	8b 53 14             	mov    0x14(%ebx),%edx
80103fd2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fd5:	b8 74 ad 14 80       	mov    $0x8014ad74,%eax
80103fda:	eb 10                	jmp    80103fec <exit+0x8c>
80103fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fe0:	05 84 00 00 00       	add    $0x84,%eax
80103fe5:	3d 74 ce 14 80       	cmp    $0x8014ce74,%eax
80103fea:	74 1e                	je     8010400a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
80103fec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ff0:	75 ee                	jne    80103fe0 <exit+0x80>
80103ff2:	3b 50 20             	cmp    0x20(%eax),%edx
80103ff5:	75 e9                	jne    80103fe0 <exit+0x80>
      p->state = RUNNABLE;
80103ff7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ffe:	05 84 00 00 00       	add    $0x84,%eax
80104003:	3d 74 ce 14 80       	cmp    $0x8014ce74,%eax
80104008:	75 e2                	jne    80103fec <exit+0x8c>
      p->parent = initproc;
8010400a:	8b 0d 74 ce 14 80    	mov    0x8014ce74,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104010:	ba 74 ad 14 80       	mov    $0x8014ad74,%edx
80104015:	eb 17                	jmp    8010402e <exit+0xce>
80104017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401e:	66 90                	xchg   %ax,%ax
80104020:	81 c2 84 00 00 00    	add    $0x84,%edx
80104026:	81 fa 74 ce 14 80    	cmp    $0x8014ce74,%edx
8010402c:	74 3a                	je     80104068 <exit+0x108>
    if(p->parent == curproc){
8010402e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104031:	75 ed                	jne    80104020 <exit+0xc0>
      if(p->state == ZOMBIE)
80104033:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104037:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010403a:	75 e4                	jne    80104020 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403c:	b8 74 ad 14 80       	mov    $0x8014ad74,%eax
80104041:	eb 11                	jmp    80104054 <exit+0xf4>
80104043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104047:	90                   	nop
80104048:	05 84 00 00 00       	add    $0x84,%eax
8010404d:	3d 74 ce 14 80       	cmp    $0x8014ce74,%eax
80104052:	74 cc                	je     80104020 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104054:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104058:	75 ee                	jne    80104048 <exit+0xe8>
8010405a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010405d:	75 e9                	jne    80104048 <exit+0xe8>
      p->state = RUNNABLE;
8010405f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104066:	eb e0                	jmp    80104048 <exit+0xe8>
  curproc->state = ZOMBIE;
80104068:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010406f:	e8 2c fe ff ff       	call   80103ea0 <sched>
  panic("zombie exit");
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	68 48 81 10 80       	push   $0x80108148
8010407c:	e8 ff c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104081:	83 ec 0c             	sub    $0xc,%esp
80104084:	68 3b 81 10 80       	push   $0x8010813b
80104089:	e8 f2 c2 ff ff       	call   80100380 <panic>
8010408e:	66 90                	xchg   %ax,%ax

80104090 <wait>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	56                   	push   %esi
80104094:	53                   	push   %ebx
  pushcli();
80104095:	e8 26 0b 00 00       	call   80104bc0 <pushcli>
  c = mycpu();
8010409a:	e8 81 f9 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
8010409f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040a5:	e8 66 0b 00 00       	call   80104c10 <popcli>
  acquire(&ptable.lock);
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	68 40 ad 14 80       	push   $0x8014ad40
801040b2:	e8 59 0c 00 00       	call   80104d10 <acquire>
801040b7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040ba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040bc:	bb 74 ad 14 80       	mov    $0x8014ad74,%ebx
801040c1:	eb 13                	jmp    801040d6 <wait+0x46>
801040c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040c7:	90                   	nop
801040c8:	81 c3 84 00 00 00    	add    $0x84,%ebx
801040ce:	81 fb 74 ce 14 80    	cmp    $0x8014ce74,%ebx
801040d4:	74 1e                	je     801040f4 <wait+0x64>
      if(p->parent != curproc)
801040d6:	39 73 14             	cmp    %esi,0x14(%ebx)
801040d9:	75 ed                	jne    801040c8 <wait+0x38>
      if(p->state == ZOMBIE){
801040db:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801040df:	74 5f                	je     80104140 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e1:	81 c3 84 00 00 00    	add    $0x84,%ebx
      havekids = 1;
801040e7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ec:	81 fb 74 ce 14 80    	cmp    $0x8014ce74,%ebx
801040f2:	75 e2                	jne    801040d6 <wait+0x46>
    if(!havekids || curproc->killed){
801040f4:	85 c0                	test   %eax,%eax
801040f6:	0f 84 9a 00 00 00    	je     80104196 <wait+0x106>
801040fc:	8b 46 24             	mov    0x24(%esi),%eax
801040ff:	85 c0                	test   %eax,%eax
80104101:	0f 85 8f 00 00 00    	jne    80104196 <wait+0x106>
  pushcli();
80104107:	e8 b4 0a 00 00       	call   80104bc0 <pushcli>
  c = mycpu();
8010410c:	e8 0f f9 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80104111:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104117:	e8 f4 0a 00 00       	call   80104c10 <popcli>
  if(p == 0)
8010411c:	85 db                	test   %ebx,%ebx
8010411e:	0f 84 89 00 00 00    	je     801041ad <wait+0x11d>
  p->chan = chan;
80104124:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104127:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010412e:	e8 6d fd ff ff       	call   80103ea0 <sched>
  p->chan = 0;
80104133:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010413a:	e9 7b ff ff ff       	jmp    801040ba <wait+0x2a>
8010413f:	90                   	nop
        kfree(p->kstack);
80104140:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104143:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104146:	ff 73 08             	push   0x8(%ebx)
80104149:	e8 e2 e3 ff ff       	call   80102530 <kfree>
        p->kstack = 0;
8010414e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104155:	5a                   	pop    %edx
80104156:	ff 73 04             	push   0x4(%ebx)
80104159:	e8 c2 35 00 00       	call   80107720 <freevm>
        p->pid = 0;
8010415e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104165:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010416c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104170:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104177:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010417e:	c7 04 24 40 ad 14 80 	movl   $0x8014ad40,(%esp)
80104185:	e8 26 0b 00 00       	call   80104cb0 <release>
        return pid;
8010418a:	83 c4 10             	add    $0x10,%esp
}
8010418d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104190:	89 f0                	mov    %esi,%eax
80104192:	5b                   	pop    %ebx
80104193:	5e                   	pop    %esi
80104194:	5d                   	pop    %ebp
80104195:	c3                   	ret    
      release(&ptable.lock);
80104196:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104199:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010419e:	68 40 ad 14 80       	push   $0x8014ad40
801041a3:	e8 08 0b 00 00       	call   80104cb0 <release>
      return -1;
801041a8:	83 c4 10             	add    $0x10,%esp
801041ab:	eb e0                	jmp    8010418d <wait+0xfd>
    panic("sleep");
801041ad:	83 ec 0c             	sub    $0xc,%esp
801041b0:	68 54 81 10 80       	push   $0x80108154
801041b5:	e8 c6 c1 ff ff       	call   80100380 <panic>
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041c0 <yield>:
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801041c7:	68 40 ad 14 80       	push   $0x8014ad40
801041cc:	e8 3f 0b 00 00       	call   80104d10 <acquire>
  pushcli();
801041d1:	e8 ea 09 00 00       	call   80104bc0 <pushcli>
  c = mycpu();
801041d6:	e8 45 f8 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
801041db:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041e1:	e8 2a 0a 00 00       	call   80104c10 <popcli>
  myproc()->state = RUNNABLE;
801041e6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041ed:	e8 ae fc ff ff       	call   80103ea0 <sched>
  release(&ptable.lock);
801041f2:	c7 04 24 40 ad 14 80 	movl   $0x8014ad40,(%esp)
801041f9:	e8 b2 0a 00 00       	call   80104cb0 <release>
}
801041fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104201:	83 c4 10             	add    $0x10,%esp
80104204:	c9                   	leave  
80104205:	c3                   	ret    
80104206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420d:	8d 76 00             	lea    0x0(%esi),%esi

80104210 <sleep>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	53                   	push   %ebx
80104216:	83 ec 0c             	sub    $0xc,%esp
80104219:	8b 7d 08             	mov    0x8(%ebp),%edi
8010421c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010421f:	e8 9c 09 00 00       	call   80104bc0 <pushcli>
  c = mycpu();
80104224:	e8 f7 f7 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80104229:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010422f:	e8 dc 09 00 00       	call   80104c10 <popcli>
  if(p == 0)
80104234:	85 db                	test   %ebx,%ebx
80104236:	0f 84 87 00 00 00    	je     801042c3 <sleep+0xb3>
  if(lk == 0)
8010423c:	85 f6                	test   %esi,%esi
8010423e:	74 76                	je     801042b6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104240:	81 fe 40 ad 14 80    	cmp    $0x8014ad40,%esi
80104246:	74 50                	je     80104298 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104248:	83 ec 0c             	sub    $0xc,%esp
8010424b:	68 40 ad 14 80       	push   $0x8014ad40
80104250:	e8 bb 0a 00 00       	call   80104d10 <acquire>
    release(lk);
80104255:	89 34 24             	mov    %esi,(%esp)
80104258:	e8 53 0a 00 00       	call   80104cb0 <release>
  p->chan = chan;
8010425d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104260:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104267:	e8 34 fc ff ff       	call   80103ea0 <sched>
  p->chan = 0;
8010426c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104273:	c7 04 24 40 ad 14 80 	movl   $0x8014ad40,(%esp)
8010427a:	e8 31 0a 00 00       	call   80104cb0 <release>
    acquire(lk);
8010427f:	89 75 08             	mov    %esi,0x8(%ebp)
80104282:	83 c4 10             	add    $0x10,%esp
}
80104285:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104288:	5b                   	pop    %ebx
80104289:	5e                   	pop    %esi
8010428a:	5f                   	pop    %edi
8010428b:	5d                   	pop    %ebp
    acquire(lk);
8010428c:	e9 7f 0a 00 00       	jmp    80104d10 <acquire>
80104291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104298:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010429b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042a2:	e8 f9 fb ff ff       	call   80103ea0 <sched>
  p->chan = 0;
801042a7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b1:	5b                   	pop    %ebx
801042b2:	5e                   	pop    %esi
801042b3:	5f                   	pop    %edi
801042b4:	5d                   	pop    %ebp
801042b5:	c3                   	ret    
    panic("sleep without lk");
801042b6:	83 ec 0c             	sub    $0xc,%esp
801042b9:	68 5a 81 10 80       	push   $0x8010815a
801042be:	e8 bd c0 ff ff       	call   80100380 <panic>
    panic("sleep");
801042c3:	83 ec 0c             	sub    $0xc,%esp
801042c6:	68 54 81 10 80       	push   $0x80108154
801042cb:	e8 b0 c0 ff ff       	call   80100380 <panic>

801042d0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 10             	sub    $0x10,%esp
801042d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042da:	68 40 ad 14 80       	push   $0x8014ad40
801042df:	e8 2c 0a 00 00       	call   80104d10 <acquire>
801042e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042e7:	b8 74 ad 14 80       	mov    $0x8014ad74,%eax
801042ec:	eb 0e                	jmp    801042fc <wakeup+0x2c>
801042ee:	66 90                	xchg   %ax,%ax
801042f0:	05 84 00 00 00       	add    $0x84,%eax
801042f5:	3d 74 ce 14 80       	cmp    $0x8014ce74,%eax
801042fa:	74 1e                	je     8010431a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801042fc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104300:	75 ee                	jne    801042f0 <wakeup+0x20>
80104302:	3b 58 20             	cmp    0x20(%eax),%ebx
80104305:	75 e9                	jne    801042f0 <wakeup+0x20>
      p->state = RUNNABLE;
80104307:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010430e:	05 84 00 00 00       	add    $0x84,%eax
80104313:	3d 74 ce 14 80       	cmp    $0x8014ce74,%eax
80104318:	75 e2                	jne    801042fc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010431a:	c7 45 08 40 ad 14 80 	movl   $0x8014ad40,0x8(%ebp)
}
80104321:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104324:	c9                   	leave  
  release(&ptable.lock);
80104325:	e9 86 09 00 00       	jmp    80104cb0 <release>
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104330 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 10             	sub    $0x10,%esp
80104337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010433a:	68 40 ad 14 80       	push   $0x8014ad40
8010433f:	e8 cc 09 00 00       	call   80104d10 <acquire>
80104344:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104347:	b8 74 ad 14 80       	mov    $0x8014ad74,%eax
8010434c:	eb 0e                	jmp    8010435c <kill+0x2c>
8010434e:	66 90                	xchg   %ax,%ax
80104350:	05 84 00 00 00       	add    $0x84,%eax
80104355:	3d 74 ce 14 80       	cmp    $0x8014ce74,%eax
8010435a:	74 34                	je     80104390 <kill+0x60>
    if(p->pid == pid){
8010435c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010435f:	75 ef                	jne    80104350 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104361:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104365:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010436c:	75 07                	jne    80104375 <kill+0x45>
        p->state = RUNNABLE;
8010436e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104375:	83 ec 0c             	sub    $0xc,%esp
80104378:	68 40 ad 14 80       	push   $0x8014ad40
8010437d:	e8 2e 09 00 00       	call   80104cb0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104385:	83 c4 10             	add    $0x10,%esp
80104388:	31 c0                	xor    %eax,%eax
}
8010438a:	c9                   	leave  
8010438b:	c3                   	ret    
8010438c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104390:	83 ec 0c             	sub    $0xc,%esp
80104393:	68 40 ad 14 80       	push   $0x8014ad40
80104398:	e8 13 09 00 00       	call   80104cb0 <release>
}
8010439d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043a0:	83 c4 10             	add    $0x10,%esp
801043a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043a8:	c9                   	leave  
801043a9:	c3                   	ret    
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	57                   	push   %edi
801043b4:	56                   	push   %esi
801043b5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043b8:	53                   	push   %ebx
801043b9:	bb e0 ad 14 80       	mov    $0x8014ade0,%ebx
801043be:	83 ec 3c             	sub    $0x3c,%esp
801043c1:	eb 27                	jmp    801043ea <procdump+0x3a>
801043c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043c7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	68 73 85 10 80       	push   $0x80108573
801043d0:	e8 cb c2 ff ff       	call   801006a0 <cprintf>
801043d5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d8:	81 c3 84 00 00 00    	add    $0x84,%ebx
801043de:	81 fb e0 ce 14 80    	cmp    $0x8014cee0,%ebx
801043e4:	0f 84 7e 00 00 00    	je     80104468 <procdump+0xb8>
    if(p->state == UNUSED)
801043ea:	8b 43 a0             	mov    -0x60(%ebx),%eax
801043ed:	85 c0                	test   %eax,%eax
801043ef:	74 e7                	je     801043d8 <procdump+0x28>
      state = "???";
801043f1:	ba 6b 81 10 80       	mov    $0x8010816b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043f6:	83 f8 05             	cmp    $0x5,%eax
801043f9:	77 11                	ja     8010440c <procdump+0x5c>
801043fb:	8b 14 85 f8 81 10 80 	mov    -0x7fef7e08(,%eax,4),%edx
      state = "???";
80104402:	b8 6b 81 10 80       	mov    $0x8010816b,%eax
80104407:	85 d2                	test   %edx,%edx
80104409:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010440c:	53                   	push   %ebx
8010440d:	52                   	push   %edx
8010440e:	ff 73 a4             	push   -0x5c(%ebx)
80104411:	68 6f 81 10 80       	push   $0x8010816f
80104416:	e8 85 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010441b:	83 c4 10             	add    $0x10,%esp
8010441e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104422:	75 a4                	jne    801043c8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104424:	83 ec 08             	sub    $0x8,%esp
80104427:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010442a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010442d:	50                   	push   %eax
8010442e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104431:	8b 40 0c             	mov    0xc(%eax),%eax
80104434:	83 c0 08             	add    $0x8,%eax
80104437:	50                   	push   %eax
80104438:	e8 23 07 00 00       	call   80104b60 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010443d:	83 c4 10             	add    $0x10,%esp
80104440:	8b 17                	mov    (%edi),%edx
80104442:	85 d2                	test   %edx,%edx
80104444:	74 82                	je     801043c8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104446:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104449:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010444c:	52                   	push   %edx
8010444d:	68 c1 7b 10 80       	push   $0x80107bc1
80104452:	e8 49 c2 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104457:	83 c4 10             	add    $0x10,%esp
8010445a:	39 fe                	cmp    %edi,%esi
8010445c:	75 e2                	jne    80104440 <procdump+0x90>
8010445e:	e9 65 ff ff ff       	jmp    801043c8 <procdump+0x18>
80104463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104467:	90                   	nop
  }
}
80104468:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010446b:	5b                   	pop    %ebx
8010446c:	5e                   	pop    %esi
8010446d:	5f                   	pop    %edi
8010446e:	5d                   	pop    %ebp
8010446f:	c3                   	ret    

80104470 <forknexec>:

int
forknexec(const char *path, const char **args)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	56                   	push   %esi
80104475:	53                   	push   %ebx
80104476:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  pushcli();
8010447c:	e8 3f 07 00 00       	call   80104bc0 <pushcli>
  c = mycpu();
80104481:	e8 9a f5 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80104486:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010448c:	e8 7f 07 00 00       	call   80104c10 <popcli>
	int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80104491:	e8 2a f4 ff ff       	call   801038c0 <allocproc>
80104496:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010449c:	85 c0                	test   %eax,%eax
8010449e:	0f 84 ef 00 00 00    	je     80104593 <forknexec+0x123>
    return -2;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801044a4:	83 ec 08             	sub    $0x8,%esp
801044a7:	ff 33                	push   (%ebx)
801044a9:	ff 73 04             	push   0x4(%ebx)
801044ac:	e8 df 33 00 00       	call   80107890 <copyuvm>
801044b1:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
801044b7:	83 c4 10             	add    $0x10,%esp
801044ba:	89 41 04             	mov    %eax,0x4(%ecx)
801044bd:	85 c0                	test   %eax,%eax
801044bf:	0f 84 fa 03 00 00    	je     801048bf <forknexec+0x44f>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -2;
  }
  np->sz = curproc->sz;
801044c5:	8b 03                	mov    (%ebx),%eax
801044c7:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
  np->parent = curproc;
  *np->tf = *curproc->tf;
801044cd:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
801044d2:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
801044d4:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
801044d7:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
801044da:	8b 73 18             	mov    0x18(%ebx),%esi
801044dd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801044df:	89 d7                	mov    %edx,%edi

  for(i = 0; i < NOFILE; i++)
801044e1:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801044e3:	8b 42 18             	mov    0x18(%edx),%eax
801044e6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801044ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
801044f0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801044f4:	85 c0                	test   %eax,%eax
801044f6:	74 10                	je     80104508 <forknexec+0x98>
      np->ofile[i] = filedup(curproc->ofile[i]);
801044f8:	83 ec 0c             	sub    $0xc,%esp
801044fb:	50                   	push   %eax
801044fc:	e8 9f c9 ff ff       	call   80100ea0 <filedup>
80104501:	83 c4 10             	add    $0x10,%esp
80104504:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104508:	83 c6 01             	add    $0x1,%esi
8010450b:	83 fe 10             	cmp    $0x10,%esi
8010450e:	75 e0                	jne    801044f0 <forknexec+0x80>
  np->cwd = idup(curproc->cwd);
80104510:	83 ec 0c             	sub    $0xc,%esp
80104513:	ff 73 68             	push   0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104516:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104519:	e8 32 d2 ff ff       	call   80101750 <idup>
8010451e:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104524:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104527:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010452a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010452d:	6a 10                	push   $0x10
8010452f:	53                   	push   %ebx
80104530:	50                   	push   %eax
80104531:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
80104537:	e8 54 0a 00 00       	call   80104f90 <safestrcpy>

  pid = np->pid;
8010453c:	8b 47 10             	mov    0x10(%edi),%eax
8010453f:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  _path = (char *)path;
  _args = (char **)args;
  begin_op();
80104545:	e8 26 e9 ff ff       	call   80102e70 <begin_op>

  if((ip = namei(_path)) == 0){
8010454a:	5a                   	pop    %edx
8010454b:	ff 75 08             	push   0x8(%ebp)
8010454e:	e8 4d db ff ff       	call   801020a0 <namei>
80104553:	83 c4 10             	add    $0x10,%esp
80104556:	89 c3                	mov    %eax,%ebx
80104558:	85 c0                	test   %eax,%eax
8010455a:	0f 84 2f 03 00 00    	je     8010488f <forknexec+0x41f>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80104560:	83 ec 0c             	sub    $0xc,%esp
80104563:	50                   	push   %eax
80104564:	e8 17 d2 ff ff       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80104569:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
8010456f:	6a 34                	push   $0x34
80104571:	6a 00                	push   $0x0
80104573:	50                   	push   %eax
80104574:	53                   	push   %ebx
80104575:	e8 16 d5 ff ff       	call   80101a90 <readi>
8010457a:	83 c4 20             	add    $0x20,%esp
8010457d:	83 f8 34             	cmp    $0x34,%eax
80104580:	74 2e                	je     801045b0 <forknexec+0x140>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80104582:	83 ec 0c             	sub    $0xc,%esp
80104585:	53                   	push   %ebx
80104586:	e8 85 d4 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010458b:	e8 50 e9 ff ff       	call   80102ee0 <end_op>
80104590:	83 c4 10             	add    $0x10,%esp
  }
  return -2;
80104593:	c7 85 f0 fe ff ff fe 	movl   $0xfffffffe,-0x110(%ebp)
8010459a:	ff ff ff 
}
8010459d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
801045a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045a6:	5b                   	pop    %ebx
801045a7:	5e                   	pop    %esi
801045a8:	5f                   	pop    %edi
801045a9:	5d                   	pop    %ebp
801045aa:	c3                   	ret    
801045ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045af:	90                   	nop
  if(elf.magic != ELF_MAGIC)
801045b0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801045b7:	45 4c 46 
801045ba:	75 c6                	jne    80104582 <forknexec+0x112>
  if((pgdir = setupkvm()) == 0)
801045bc:	e8 df 31 00 00       	call   801077a0 <setupkvm>
801045c1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
801045c7:	85 c0                	test   %eax,%eax
801045c9:	74 b7                	je     80104582 <forknexec+0x112>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801045cb:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801045d2:	00 
801045d3:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801045d9:	0f 84 d4 02 00 00    	je     801048b3 <forknexec+0x443>
  sz = 0;
801045df:	c7 85 e8 fe ff ff 00 	movl   $0x0,-0x118(%ebp)
801045e6:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801045e9:	31 ff                	xor    %edi,%edi
801045eb:	e9 86 00 00 00       	jmp    80104676 <forknexec+0x206>
    if(ph.type != ELF_PROG_LOAD)
801045f0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801045f7:	75 6c                	jne    80104665 <forknexec+0x1f5>
    if(ph.memsz < ph.filesz)
801045f9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801045ff:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80104605:	0f 82 87 00 00 00    	jb     80104692 <forknexec+0x222>
    if(ph.vaddr + ph.memsz < ph.vaddr)
8010460b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80104611:	72 7f                	jb     80104692 <forknexec+0x222>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80104613:	83 ec 04             	sub    $0x4,%esp
80104616:	50                   	push   %eax
80104617:	ff b5 e8 fe ff ff    	push   -0x118(%ebp)
8010461d:	ff b5 ec fe ff ff    	push   -0x114(%ebp)
80104623:	e8 98 2f 00 00       	call   801075c0 <allocuvm>
80104628:	83 c4 10             	add    $0x10,%esp
8010462b:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80104631:	85 c0                	test   %eax,%eax
80104633:	74 5d                	je     80104692 <forknexec+0x222>
    if(ph.vaddr % PGSIZE != 0)
80104635:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010463b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80104640:	75 50                	jne    80104692 <forknexec+0x222>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80104642:	83 ec 0c             	sub    $0xc,%esp
80104645:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
8010464b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80104651:	53                   	push   %ebx
80104652:	50                   	push   %eax
80104653:	ff b5 ec fe ff ff    	push   -0x114(%ebp)
80104659:	e8 72 2e 00 00       	call   801074d0 <loaduvm>
8010465e:	83 c4 20             	add    $0x20,%esp
80104661:	85 c0                	test   %eax,%eax
80104663:	78 2d                	js     80104692 <forknexec+0x222>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80104665:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010466c:	83 c7 01             	add    $0x1,%edi
8010466f:	83 c6 20             	add    $0x20,%esi
80104672:	39 f8                	cmp    %edi,%eax
80104674:	7e 32                	jle    801046a8 <forknexec+0x238>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80104676:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010467c:	6a 20                	push   $0x20
8010467e:	56                   	push   %esi
8010467f:	50                   	push   %eax
80104680:	53                   	push   %ebx
80104681:	e8 0a d4 ff ff       	call   80101a90 <readi>
80104686:	83 c4 10             	add    $0x10,%esp
80104689:	83 f8 20             	cmp    $0x20,%eax
8010468c:	0f 84 5e ff ff ff    	je     801045f0 <forknexec+0x180>
    freevm(pgdir);
80104692:	83 ec 0c             	sub    $0xc,%esp
80104695:	ff b5 ec fe ff ff    	push   -0x114(%ebp)
8010469b:	e8 80 30 00 00       	call   80107720 <freevm>
  if(ip){
801046a0:	83 c4 10             	add    $0x10,%esp
801046a3:	e9 da fe ff ff       	jmp    80104582 <forknexec+0x112>
  sz = PGROUNDUP(sz);
801046a8:	8b b5 e8 fe ff ff    	mov    -0x118(%ebp),%esi
801046ae:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
801046b4:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801046ba:	8d be 00 20 00 00    	lea    0x2000(%esi),%edi
  iunlockput(ip);
801046c0:	83 ec 0c             	sub    $0xc,%esp
801046c3:	53                   	push   %ebx
801046c4:	e8 47 d3 ff ff       	call   80101a10 <iunlockput>
  end_op();
801046c9:	e8 12 e8 ff ff       	call   80102ee0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801046ce:	83 c4 0c             	add    $0xc,%esp
801046d1:	57                   	push   %edi
801046d2:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801046d8:	56                   	push   %esi
801046d9:	57                   	push   %edi
801046da:	e8 e1 2e 00 00       	call   801075c0 <allocuvm>
801046df:	83 c4 10             	add    $0x10,%esp
801046e2:	89 c6                	mov    %eax,%esi
801046e4:	85 c0                	test   %eax,%eax
801046e6:	0f 84 a2 00 00 00    	je     8010478e <forknexec+0x31e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801046ec:	83 ec 08             	sub    $0x8,%esp
801046ef:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; _args[argc]; argc++) {
801046f5:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801046f7:	50                   	push   %eax
801046f8:	57                   	push   %edi
  for(argc = 0; _args[argc]; argc++) {
801046f9:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801046fb:	e8 40 31 00 00       	call   80107840 <clearpteu>
  for(argc = 0; _args[argc]; argc++) {
80104700:	8b 45 0c             	mov    0xc(%ebp),%eax
80104703:	83 c4 10             	add    $0x10,%esp
80104706:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
8010470c:	8b 00                	mov    (%eax),%eax
8010470e:	85 c0                	test   %eax,%eax
80104710:	0f 84 9e 00 00 00    	je     801047b4 <forknexec+0x344>
80104716:	89 b5 e8 fe ff ff    	mov    %esi,-0x118(%ebp)
8010471c:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80104722:	eb 1f                	jmp    80104743 <forknexec+0x2d3>
80104724:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80104727:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; _args[argc]; argc++) {
8010472e:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80104731:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; _args[argc]; argc++) {
80104737:	8b 04 b8             	mov    (%eax,%edi,4),%eax
8010473a:	85 c0                	test   %eax,%eax
8010473c:	74 70                	je     801047ae <forknexec+0x33e>
    if(argc >= MAXARG)
8010473e:	83 ff 20             	cmp    $0x20,%edi
80104741:	74 35                	je     80104778 <forknexec+0x308>
    sp = (sp - (strlen(_args[argc]) + 1)) & ~3;
80104743:	83 ec 0c             	sub    $0xc,%esp
80104746:	50                   	push   %eax
80104747:	e8 84 08 00 00       	call   80104fd0 <strlen>
8010474c:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, _args[argc], strlen(_args[argc]) + 1) < 0)
8010474e:	58                   	pop    %eax
8010474f:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(_args[argc]) + 1)) & ~3;
80104752:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, _args[argc], strlen(_args[argc]) + 1) < 0)
80104755:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(_args[argc]) + 1)) & ~3;
80104758:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, _args[argc], strlen(_args[argc]) + 1) < 0)
8010475b:	e8 70 08 00 00       	call   80104fd0 <strlen>
80104760:	83 c0 01             	add    $0x1,%eax
80104763:	50                   	push   %eax
80104764:	8b 45 0c             	mov    0xc(%ebp),%eax
80104767:	ff 34 b8             	push   (%eax,%edi,4)
8010476a:	53                   	push   %ebx
8010476b:	56                   	push   %esi
8010476c:	e8 2f 33 00 00       	call   80107aa0 <copyout>
80104771:	83 c4 20             	add    $0x20,%esp
80104774:	85 c0                	test   %eax,%eax
80104776:	79 ac                	jns    80104724 <forknexec+0x2b4>
    freevm(pgdir);
80104778:	83 ec 0c             	sub    $0xc,%esp
8010477b:	ff b5 ec fe ff ff    	push   -0x114(%ebp)
80104781:	e8 9a 2f 00 00       	call   80107720 <freevm>
80104786:	83 c4 10             	add    $0x10,%esp
80104789:	e9 05 fe ff ff       	jmp    80104593 <forknexec+0x123>
8010478e:	83 ec 0c             	sub    $0xc,%esp
80104791:	ff b5 ec fe ff ff    	push   -0x114(%ebp)
80104797:	e8 84 2f 00 00       	call   80107720 <freevm>
8010479c:	83 c4 10             	add    $0x10,%esp
  return -2;
8010479f:	c7 85 f0 fe ff ff fe 	movl   $0xfffffffe,-0x110(%ebp)
801047a6:	ff ff ff 
801047a9:	e9 ef fd ff ff       	jmp    8010459d <forknexec+0x12d>
801047ae:	8b b5 e8 fe ff ff    	mov    -0x118(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // _args pointer
801047b4:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801047bb:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801047bd:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801047c4:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // _args pointer
801047c8:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
801047ca:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
801047cd:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
801047d3:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801047d5:	50                   	push   %eax
801047d6:	52                   	push   %edx
801047d7:	53                   	push   %ebx
801047d8:	ff b5 ec fe ff ff    	push   -0x114(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801047de:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801047e5:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // _args pointer
801047e8:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801047ee:	e8 ad 32 00 00       	call   80107aa0 <copyout>
801047f3:	83 c4 10             	add    $0x10,%esp
801047f6:	85 c0                	test   %eax,%eax
801047f8:	78 94                	js     8010478e <forknexec+0x31e>
  for(last=s=_path; *s; s++)
801047fa:	8b 45 08             	mov    0x8(%ebp),%eax
801047fd:	0f b6 10             	movzbl (%eax),%edx
80104800:	84 d2                	test   %dl,%dl
80104802:	0f 84 e4 00 00 00    	je     801048ec <forknexec+0x47c>
80104808:	89 c1                	mov    %eax,%ecx
      last = s+1;
8010480a:	83 c1 01             	add    $0x1,%ecx
8010480d:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=_path; *s; s++)
80104810:	0f b6 11             	movzbl (%ecx),%edx
      last = s+1;
80104813:	0f 44 c1             	cmove  %ecx,%eax
  for(last=s=_path; *s; s++)
80104816:	84 d2                	test   %dl,%dl
80104818:	75 f0                	jne    8010480a <forknexec+0x39a>
  safestrcpy(np->name, last, sizeof(np->name));
8010481a:	83 ec 04             	sub    $0x4,%esp
8010481d:	6a 10                	push   $0x10
8010481f:	50                   	push   %eax
80104820:	ff b5 e4 fe ff ff    	push   -0x11c(%ebp)
80104826:	e8 65 07 00 00       	call   80104f90 <safestrcpy>
  oldpgdir = np->pgdir;
8010482b:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  np->pgdir = pgdir;
80104831:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
  oldpgdir = np->pgdir;
80104837:	8b 79 04             	mov    0x4(%ecx),%edi
  np->tf->eip = elf.entry;  // main
8010483a:	8b 41 18             	mov    0x18(%ecx),%eax
  np->pgdir = pgdir;
8010483d:	89 51 04             	mov    %edx,0x4(%ecx)
  np->sz = sz;
80104840:	89 31                	mov    %esi,(%ecx)
  np->tf->eip = elf.entry;  // main
80104842:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80104848:	89 50 38             	mov    %edx,0x38(%eax)
  np->tf->esp = sp;
8010484b:	8b 41 18             	mov    0x18(%ecx),%eax
8010484e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(np);
80104851:	89 cb                	mov    %ecx,%ebx
80104853:	89 0c 24             	mov    %ecx,(%esp)
80104856:	e8 e5 2a 00 00       	call   80107340 <switchuvm>
  freevm(oldpgdir);
8010485b:	89 3c 24             	mov    %edi,(%esp)
8010485e:	e8 bd 2e 00 00       	call   80107720 <freevm>
  acquire(&ptable.lock);
80104863:	c7 04 24 40 ad 14 80 	movl   $0x8014ad40,(%esp)
8010486a:	e8 a1 04 00 00       	call   80104d10 <acquire>
  np->state = RUNNABLE;
8010486f:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104876:	c7 04 24 40 ad 14 80 	movl   $0x8014ad40,(%esp)
8010487d:	e8 2e 04 00 00       	call   80104cb0 <release>
  wait();
80104882:	e8 09 f8 ff ff       	call   80104090 <wait>
  return pid;
80104887:	83 c4 10             	add    $0x10,%esp
8010488a:	e9 0e fd ff ff       	jmp    8010459d <forknexec+0x12d>
    end_op();
8010488f:	e8 4c e6 ff ff       	call   80102ee0 <end_op>
    cprintf("exec: fail\n");
80104894:	83 ec 0c             	sub    $0xc,%esp
80104897:	68 01 7c 10 80       	push   $0x80107c01
8010489c:	e8 ff bd ff ff       	call   801006a0 <cprintf>
    return -1;
801048a1:	83 c4 10             	add    $0x10,%esp
801048a4:	c7 85 f0 fe ff ff ff 	movl   $0xffffffff,-0x110(%ebp)
801048ab:	ff ff ff 
801048ae:	e9 ea fc ff ff       	jmp    8010459d <forknexec+0x12d>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801048b3:	bf 00 20 00 00       	mov    $0x2000,%edi
801048b8:	31 f6                	xor    %esi,%esi
801048ba:	e9 01 fe ff ff       	jmp    801046c0 <forknexec+0x250>
    kfree(np->kstack);
801048bf:	83 ec 0c             	sub    $0xc,%esp
801048c2:	ff 71 08             	push   0x8(%ecx)
801048c5:	89 cf                	mov    %ecx,%edi
801048c7:	e8 64 dc ff ff       	call   80102530 <kfree>
    np->kstack = 0;
801048cc:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    return -2;
801048d3:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801048d6:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -2;
801048dd:	c7 85 f0 fe ff ff fe 	movl   $0xfffffffe,-0x110(%ebp)
801048e4:	ff ff ff 
801048e7:	e9 b1 fc ff ff       	jmp    8010459d <forknexec+0x12d>
  for(last=s=_path; *s; s++)
801048ec:	8b 45 08             	mov    0x8(%ebp),%eax
801048ef:	e9 26 ff ff ff       	jmp    8010481a <forknexec+0x3aa>
801048f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ff:	90                   	nop

80104900 <set_proc_priority>:

int
set_proc_priority(int pid, int priority)
{
80104900:	55                   	push   %ebp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104901:	b8 74 ad 14 80       	mov    $0x8014ad74,%eax
{
80104906:	89 e5                	mov    %esp,%ebp
80104908:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010490b:	eb 0f                	jmp    8010491c <set_proc_priority+0x1c>
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104910:	05 84 00 00 00       	add    $0x84,%eax
80104915:	3d 74 ce 14 80       	cmp    $0x8014ce74,%eax
8010491a:	74 14                	je     80104930 <set_proc_priority+0x30>
    if (p->pid == pid){
8010491c:	8b 50 10             	mov    0x10(%eax),%edx
8010491f:	39 ca                	cmp    %ecx,%edx
80104921:	75 ed                	jne    80104910 <set_proc_priority+0x10>
      p->priority = priority;
80104923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104926:	89 48 7c             	mov    %ecx,0x7c(%eax)
      return p->pid;
    }
  return -1;
}
80104929:	89 d0                	mov    %edx,%eax
8010492b:	5d                   	pop    %ebp
8010492c:	c3                   	ret    
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
  return -1;
80104930:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
80104935:	5d                   	pop    %ebp
80104936:	89 d0                	mov    %edx,%eax
80104938:	c3                   	ret    
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104940 <get_proc_priority>:

int
get_proc_priority(int pid)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104944:	bb 74 ad 14 80       	mov    $0x8014ad74,%ebx
{
80104949:	83 ec 04             	sub    $0x4,%esp
8010494c:	8b 45 08             	mov    0x8(%ebp),%eax
8010494f:	eb 15                	jmp    80104966 <get_proc_priority+0x26>
80104951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104958:	81 c3 84 00 00 00    	add    $0x84,%ebx
8010495e:	81 fb 74 ce 14 80    	cmp    $0x8014ce74,%ebx
80104964:	74 2a                	je     80104990 <get_proc_priority+0x50>
    if (p->pid == pid){
80104966:	39 43 10             	cmp    %eax,0x10(%ebx)
80104969:	75 ed                	jne    80104958 <get_proc_priority+0x18>
      cprintf("pid %d => priority: %d\n", p->pid, p->priority);
8010496b:	83 ec 04             	sub    $0x4,%esp
8010496e:	ff 73 7c             	push   0x7c(%ebx)
80104971:	50                   	push   %eax
80104972:	68 78 81 10 80       	push   $0x80108178
80104977:	e8 24 bd ff ff       	call   801006a0 <cprintf>
      return p->priority;
8010497c:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010497f:	83 c4 10             	add    $0x10,%esp
    }
  return -1;
}
80104982:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104985:	c9                   	leave  
80104986:	c3                   	ret    
80104987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498e:	66 90                	xchg   %ax,%ax
80104990:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104998:	c9                   	leave  
80104999:	c3                   	ret    
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049a0 <get_proc_cnt>:

//20181295 print cnts of all RUNNABLE process in ptable
int
get_proc_cnt(int pid)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049a4:	bb 74 ad 14 80       	mov    $0x8014ad74,%ebx
{
801049a9:	83 ec 04             	sub    $0x4,%esp
801049ac:	eb 10                	jmp    801049be <get_proc_cnt+0x1e>
801049ae:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049b0:	81 c3 84 00 00 00    	add    $0x84,%ebx
801049b6:	81 fb 74 ce 14 80    	cmp    $0x8014ce74,%ebx
801049bc:	74 2d                	je     801049eb <get_proc_cnt+0x4b>
    if (p->state == RUNNABLE)
801049be:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801049c2:	75 ec                	jne    801049b0 <get_proc_cnt+0x10>
      cprintf("pid %d => cnt : %d\n", p->pid, p->cnt);
801049c4:	83 ec 04             	sub    $0x4,%esp
801049c7:	ff b3 80 00 00 00    	push   0x80(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049cd:	81 c3 84 00 00 00    	add    $0x84,%ebx
      cprintf("pid %d => cnt : %d\n", p->pid, p->cnt);
801049d3:	ff 73 8c             	push   -0x74(%ebx)
801049d6:	68 90 81 10 80       	push   $0x80108190
801049db:	e8 c0 bc ff ff       	call   801006a0 <cprintf>
801049e0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049e3:	81 fb 74 ce 14 80    	cmp    $0x8014ce74,%ebx
801049e9:	75 d3                	jne    801049be <get_proc_cnt+0x1e>
  cprintf("\n");
801049eb:	83 ec 0c             	sub    $0xc,%esp
801049ee:	68 73 85 10 80       	push   $0x80108573
801049f3:	e8 a8 bc ff ff       	call   801006a0 <cprintf>
  return p->cnt;
}
801049f8:	a1 f4 ce 14 80       	mov    0x8014cef4,%eax
801049fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a00:	c9                   	leave  
80104a01:	c3                   	ret    
80104a02:	66 90                	xchg   %ax,%ax
80104a04:	66 90                	xchg   %ax,%ax
80104a06:	66 90                	xchg   %ax,%ax
80104a08:	66 90                	xchg   %ax,%ax
80104a0a:	66 90                	xchg   %ax,%ax
80104a0c:	66 90                	xchg   %ax,%ax
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	53                   	push   %ebx
80104a14:	83 ec 0c             	sub    $0xc,%esp
80104a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a1a:	68 10 82 10 80       	push   $0x80108210
80104a1f:	8d 43 04             	lea    0x4(%ebx),%eax
80104a22:	50                   	push   %eax
80104a23:	e8 18 01 00 00       	call   80104b40 <initlock>
  lk->name = name;
80104a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104a2b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104a31:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104a34:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104a3b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104a3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a41:	c9                   	leave  
80104a42:	c3                   	ret    
80104a43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a50 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
80104a55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a58:	8d 73 04             	lea    0x4(%ebx),%esi
80104a5b:	83 ec 0c             	sub    $0xc,%esp
80104a5e:	56                   	push   %esi
80104a5f:	e8 ac 02 00 00       	call   80104d10 <acquire>
  while (lk->locked) {
80104a64:	8b 13                	mov    (%ebx),%edx
80104a66:	83 c4 10             	add    $0x10,%esp
80104a69:	85 d2                	test   %edx,%edx
80104a6b:	74 16                	je     80104a83 <acquiresleep+0x33>
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104a70:	83 ec 08             	sub    $0x8,%esp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
80104a75:	e8 96 f7 ff ff       	call   80104210 <sleep>
  while (lk->locked) {
80104a7a:	8b 03                	mov    (%ebx),%eax
80104a7c:	83 c4 10             	add    $0x10,%esp
80104a7f:	85 c0                	test   %eax,%eax
80104a81:	75 ed                	jne    80104a70 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104a83:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104a89:	e8 12 f0 ff ff       	call   80103aa0 <myproc>
80104a8e:	8b 40 10             	mov    0x10(%eax),%eax
80104a91:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a94:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a97:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a9a:	5b                   	pop    %ebx
80104a9b:	5e                   	pop    %esi
80104a9c:	5d                   	pop    %ebp
  release(&lk->lk);
80104a9d:	e9 0e 02 00 00       	jmp    80104cb0 <release>
80104aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ab0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
80104ab5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ab8:	8d 73 04             	lea    0x4(%ebx),%esi
80104abb:	83 ec 0c             	sub    $0xc,%esp
80104abe:	56                   	push   %esi
80104abf:	e8 4c 02 00 00       	call   80104d10 <acquire>
  lk->locked = 0;
80104ac4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104aca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ad1:	89 1c 24             	mov    %ebx,(%esp)
80104ad4:	e8 f7 f7 ff ff       	call   801042d0 <wakeup>
  release(&lk->lk);
80104ad9:	89 75 08             	mov    %esi,0x8(%ebp)
80104adc:	83 c4 10             	add    $0x10,%esp
}
80104adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ae2:	5b                   	pop    %ebx
80104ae3:	5e                   	pop    %esi
80104ae4:	5d                   	pop    %ebp
  release(&lk->lk);
80104ae5:	e9 c6 01 00 00       	jmp    80104cb0 <release>
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104af0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	57                   	push   %edi
80104af4:	31 ff                	xor    %edi,%edi
80104af6:	56                   	push   %esi
80104af7:	53                   	push   %ebx
80104af8:	83 ec 18             	sub    $0x18,%esp
80104afb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104afe:	8d 73 04             	lea    0x4(%ebx),%esi
80104b01:	56                   	push   %esi
80104b02:	e8 09 02 00 00       	call   80104d10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104b07:	8b 03                	mov    (%ebx),%eax
80104b09:	83 c4 10             	add    $0x10,%esp
80104b0c:	85 c0                	test   %eax,%eax
80104b0e:	75 18                	jne    80104b28 <holdingsleep+0x38>
  release(&lk->lk);
80104b10:	83 ec 0c             	sub    $0xc,%esp
80104b13:	56                   	push   %esi
80104b14:	e8 97 01 00 00       	call   80104cb0 <release>
  return r;
}
80104b19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b1c:	89 f8                	mov    %edi,%eax
80104b1e:	5b                   	pop    %ebx
80104b1f:	5e                   	pop    %esi
80104b20:	5f                   	pop    %edi
80104b21:	5d                   	pop    %ebp
80104b22:	c3                   	ret    
80104b23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b27:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104b28:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104b2b:	e8 70 ef ff ff       	call   80103aa0 <myproc>
80104b30:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b33:	0f 94 c0             	sete   %al
80104b36:	0f b6 c0             	movzbl %al,%eax
80104b39:	89 c7                	mov    %eax,%edi
80104b3b:	eb d3                	jmp    80104b10 <holdingsleep+0x20>
80104b3d:	66 90                	xchg   %ax,%ax
80104b3f:	90                   	nop

80104b40 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104b4f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104b52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b59:	5d                   	pop    %ebp
80104b5a:	c3                   	ret    
80104b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b5f:	90                   	nop

80104b60 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b60:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b61:	31 d2                	xor    %edx,%edx
{
80104b63:	89 e5                	mov    %esp,%ebp
80104b65:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104b66:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104b69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104b6c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104b6f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b70:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b76:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b7c:	77 1a                	ja     80104b98 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b7e:	8b 58 04             	mov    0x4(%eax),%ebx
80104b81:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b84:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b87:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b89:	83 fa 0a             	cmp    $0xa,%edx
80104b8c:	75 e2                	jne    80104b70 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b91:	c9                   	leave  
80104b92:	c3                   	ret    
80104b93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b97:	90                   	nop
  for(; i < 10; i++)
80104b98:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b9b:	8d 51 28             	lea    0x28(%ecx),%edx
80104b9e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ba6:	83 c0 04             	add    $0x4,%eax
80104ba9:	39 d0                	cmp    %edx,%eax
80104bab:	75 f3                	jne    80104ba0 <getcallerpcs+0x40>
}
80104bad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb0:	c9                   	leave  
80104bb1:	c3                   	ret    
80104bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104bc0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 04             	sub    $0x4,%esp
80104bc7:	9c                   	pushf  
80104bc8:	5b                   	pop    %ebx
  asm volatile("cli");
80104bc9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104bca:	e8 51 ee ff ff       	call   80103a20 <mycpu>
80104bcf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104bd5:	85 c0                	test   %eax,%eax
80104bd7:	74 17                	je     80104bf0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104bd9:	e8 42 ee ff ff       	call   80103a20 <mycpu>
80104bde:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104be8:	c9                   	leave  
80104be9:	c3                   	ret    
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104bf0:	e8 2b ee ff ff       	call   80103a20 <mycpu>
80104bf5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104bfb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104c01:	eb d6                	jmp    80104bd9 <pushcli+0x19>
80104c03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c10 <popcli>:

void
popcli(void)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c16:	9c                   	pushf  
80104c17:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c18:	f6 c4 02             	test   $0x2,%ah
80104c1b:	75 35                	jne    80104c52 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c1d:	e8 fe ed ff ff       	call   80103a20 <mycpu>
80104c22:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c29:	78 34                	js     80104c5f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c2b:	e8 f0 ed ff ff       	call   80103a20 <mycpu>
80104c30:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c36:	85 d2                	test   %edx,%edx
80104c38:	74 06                	je     80104c40 <popcli+0x30>
    sti();
}
80104c3a:	c9                   	leave  
80104c3b:	c3                   	ret    
80104c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c40:	e8 db ed ff ff       	call   80103a20 <mycpu>
80104c45:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c4b:	85 c0                	test   %eax,%eax
80104c4d:	74 eb                	je     80104c3a <popcli+0x2a>
  asm volatile("sti");
80104c4f:	fb                   	sti    
}
80104c50:	c9                   	leave  
80104c51:	c3                   	ret    
    panic("popcli - interruptible");
80104c52:	83 ec 0c             	sub    $0xc,%esp
80104c55:	68 1b 82 10 80       	push   $0x8010821b
80104c5a:	e8 21 b7 ff ff       	call   80100380 <panic>
    panic("popcli");
80104c5f:	83 ec 0c             	sub    $0xc,%esp
80104c62:	68 32 82 10 80       	push   $0x80108232
80104c67:	e8 14 b7 ff ff       	call   80100380 <panic>
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c70 <holding>:
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
80104c75:	8b 75 08             	mov    0x8(%ebp),%esi
80104c78:	31 db                	xor    %ebx,%ebx
  pushcli();
80104c7a:	e8 41 ff ff ff       	call   80104bc0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c7f:	8b 06                	mov    (%esi),%eax
80104c81:	85 c0                	test   %eax,%eax
80104c83:	75 0b                	jne    80104c90 <holding+0x20>
  popcli();
80104c85:	e8 86 ff ff ff       	call   80104c10 <popcli>
}
80104c8a:	89 d8                	mov    %ebx,%eax
80104c8c:	5b                   	pop    %ebx
80104c8d:	5e                   	pop    %esi
80104c8e:	5d                   	pop    %ebp
80104c8f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104c90:	8b 5e 08             	mov    0x8(%esi),%ebx
80104c93:	e8 88 ed ff ff       	call   80103a20 <mycpu>
80104c98:	39 c3                	cmp    %eax,%ebx
80104c9a:	0f 94 c3             	sete   %bl
  popcli();
80104c9d:	e8 6e ff ff ff       	call   80104c10 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104ca2:	0f b6 db             	movzbl %bl,%ebx
}
80104ca5:	89 d8                	mov    %ebx,%eax
80104ca7:	5b                   	pop    %ebx
80104ca8:	5e                   	pop    %esi
80104ca9:	5d                   	pop    %ebp
80104caa:	c3                   	ret    
80104cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104caf:	90                   	nop

80104cb0 <release>:
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	53                   	push   %ebx
80104cb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104cb8:	e8 03 ff ff ff       	call   80104bc0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104cbd:	8b 03                	mov    (%ebx),%eax
80104cbf:	85 c0                	test   %eax,%eax
80104cc1:	75 15                	jne    80104cd8 <release+0x28>
  popcli();
80104cc3:	e8 48 ff ff ff       	call   80104c10 <popcli>
    panic("release");
80104cc8:	83 ec 0c             	sub    $0xc,%esp
80104ccb:	68 39 82 10 80       	push   $0x80108239
80104cd0:	e8 ab b6 ff ff       	call   80100380 <panic>
80104cd5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104cd8:	8b 73 08             	mov    0x8(%ebx),%esi
80104cdb:	e8 40 ed ff ff       	call   80103a20 <mycpu>
80104ce0:	39 c6                	cmp    %eax,%esi
80104ce2:	75 df                	jne    80104cc3 <release+0x13>
  popcli();
80104ce4:	e8 27 ff ff ff       	call   80104c10 <popcli>
  lk->pcs[0] = 0;
80104ce9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104cf0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104cf7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104cfc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104d02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d05:	5b                   	pop    %ebx
80104d06:	5e                   	pop    %esi
80104d07:	5d                   	pop    %ebp
  popcli();
80104d08:	e9 03 ff ff ff       	jmp    80104c10 <popcli>
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi

80104d10 <acquire>:
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	53                   	push   %ebx
80104d14:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104d17:	e8 a4 fe ff ff       	call   80104bc0 <pushcli>
  if(holding(lk))
80104d1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d1f:	e8 9c fe ff ff       	call   80104bc0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d24:	8b 03                	mov    (%ebx),%eax
80104d26:	85 c0                	test   %eax,%eax
80104d28:	75 7e                	jne    80104da8 <acquire+0x98>
  popcli();
80104d2a:	e8 e1 fe ff ff       	call   80104c10 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104d2f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104d38:	8b 55 08             	mov    0x8(%ebp),%edx
80104d3b:	89 c8                	mov    %ecx,%eax
80104d3d:	f0 87 02             	lock xchg %eax,(%edx)
80104d40:	85 c0                	test   %eax,%eax
80104d42:	75 f4                	jne    80104d38 <acquire+0x28>
  __sync_synchronize();
80104d44:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d4c:	e8 cf ec ff ff       	call   80103a20 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104d51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d54:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104d56:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104d59:	31 c0                	xor    %eax,%eax
80104d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d5f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d60:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104d66:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d6c:	77 1a                	ja     80104d88 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104d6e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104d71:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104d75:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104d78:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104d7a:	83 f8 0a             	cmp    $0xa,%eax
80104d7d:	75 e1                	jne    80104d60 <acquire+0x50>
}
80104d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d82:	c9                   	leave  
80104d83:	c3                   	ret    
80104d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104d88:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104d8c:	8d 51 34             	lea    0x34(%ecx),%edx
80104d8f:	90                   	nop
    pcs[i] = 0;
80104d90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d96:	83 c0 04             	add    $0x4,%eax
80104d99:	39 c2                	cmp    %eax,%edx
80104d9b:	75 f3                	jne    80104d90 <acquire+0x80>
}
80104d9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104da0:	c9                   	leave  
80104da1:	c3                   	ret    
80104da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104da8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104dab:	e8 70 ec ff ff       	call   80103a20 <mycpu>
80104db0:	39 c3                	cmp    %eax,%ebx
80104db2:	0f 85 72 ff ff ff    	jne    80104d2a <acquire+0x1a>
  popcli();
80104db8:	e8 53 fe ff ff       	call   80104c10 <popcli>
    panic("acquire");
80104dbd:	83 ec 0c             	sub    $0xc,%esp
80104dc0:	68 41 82 10 80       	push   $0x80108241
80104dc5:	e8 b6 b5 ff ff       	call   80100380 <panic>
80104dca:	66 90                	xchg   %ax,%ax
80104dcc:	66 90                	xchg   %ax,%ax
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	8b 55 08             	mov    0x8(%ebp),%edx
80104dd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104dda:	53                   	push   %ebx
80104ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104dde:	89 d7                	mov    %edx,%edi
80104de0:	09 cf                	or     %ecx,%edi
80104de2:	83 e7 03             	and    $0x3,%edi
80104de5:	75 29                	jne    80104e10 <memset+0x40>
    c &= 0xFF;
80104de7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104dea:	c1 e0 18             	shl    $0x18,%eax
80104ded:	89 fb                	mov    %edi,%ebx
80104def:	c1 e9 02             	shr    $0x2,%ecx
80104df2:	c1 e3 10             	shl    $0x10,%ebx
80104df5:	09 d8                	or     %ebx,%eax
80104df7:	09 f8                	or     %edi,%eax
80104df9:	c1 e7 08             	shl    $0x8,%edi
80104dfc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104dfe:	89 d7                	mov    %edx,%edi
80104e00:	fc                   	cld    
80104e01:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104e03:	5b                   	pop    %ebx
80104e04:	89 d0                	mov    %edx,%eax
80104e06:	5f                   	pop    %edi
80104e07:	5d                   	pop    %ebp
80104e08:	c3                   	ret    
80104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104e10:	89 d7                	mov    %edx,%edi
80104e12:	fc                   	cld    
80104e13:	f3 aa                	rep stos %al,%es:(%edi)
80104e15:	5b                   	pop    %ebx
80104e16:	89 d0                	mov    %edx,%eax
80104e18:	5f                   	pop    %edi
80104e19:	5d                   	pop    %ebp
80104e1a:	c3                   	ret    
80104e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e1f:	90                   	nop

80104e20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	8b 75 10             	mov    0x10(%ebp),%esi
80104e27:	8b 55 08             	mov    0x8(%ebp),%edx
80104e2a:	53                   	push   %ebx
80104e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e2e:	85 f6                	test   %esi,%esi
80104e30:	74 2e                	je     80104e60 <memcmp+0x40>
80104e32:	01 c6                	add    %eax,%esi
80104e34:	eb 14                	jmp    80104e4a <memcmp+0x2a>
80104e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104e40:	83 c0 01             	add    $0x1,%eax
80104e43:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104e46:	39 f0                	cmp    %esi,%eax
80104e48:	74 16                	je     80104e60 <memcmp+0x40>
    if(*s1 != *s2)
80104e4a:	0f b6 0a             	movzbl (%edx),%ecx
80104e4d:	0f b6 18             	movzbl (%eax),%ebx
80104e50:	38 d9                	cmp    %bl,%cl
80104e52:	74 ec                	je     80104e40 <memcmp+0x20>
      return *s1 - *s2;
80104e54:	0f b6 c1             	movzbl %cl,%eax
80104e57:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104e59:	5b                   	pop    %ebx
80104e5a:	5e                   	pop    %esi
80104e5b:	5d                   	pop    %ebp
80104e5c:	c3                   	ret    
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi
80104e60:	5b                   	pop    %ebx
  return 0;
80104e61:	31 c0                	xor    %eax,%eax
}
80104e63:	5e                   	pop    %esi
80104e64:	5d                   	pop    %ebp
80104e65:	c3                   	ret    
80104e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi

80104e70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	57                   	push   %edi
80104e74:	8b 55 08             	mov    0x8(%ebp),%edx
80104e77:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e7a:	56                   	push   %esi
80104e7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e7e:	39 d6                	cmp    %edx,%esi
80104e80:	73 26                	jae    80104ea8 <memmove+0x38>
80104e82:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104e85:	39 fa                	cmp    %edi,%edx
80104e87:	73 1f                	jae    80104ea8 <memmove+0x38>
80104e89:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104e8c:	85 c9                	test   %ecx,%ecx
80104e8e:	74 0c                	je     80104e9c <memmove+0x2c>
      *--d = *--s;
80104e90:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104e94:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104e97:	83 e8 01             	sub    $0x1,%eax
80104e9a:	73 f4                	jae    80104e90 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e9c:	5e                   	pop    %esi
80104e9d:	89 d0                	mov    %edx,%eax
80104e9f:	5f                   	pop    %edi
80104ea0:	5d                   	pop    %ebp
80104ea1:	c3                   	ret    
80104ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104ea8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104eab:	89 d7                	mov    %edx,%edi
80104ead:	85 c9                	test   %ecx,%ecx
80104eaf:	74 eb                	je     80104e9c <memmove+0x2c>
80104eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104eb8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104eb9:	39 c6                	cmp    %eax,%esi
80104ebb:	75 fb                	jne    80104eb8 <memmove+0x48>
}
80104ebd:	5e                   	pop    %esi
80104ebe:	89 d0                	mov    %edx,%eax
80104ec0:	5f                   	pop    %edi
80104ec1:	5d                   	pop    %ebp
80104ec2:	c3                   	ret    
80104ec3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ed0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104ed0:	eb 9e                	jmp    80104e70 <memmove>
80104ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	8b 75 10             	mov    0x10(%ebp),%esi
80104ee7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104eea:	53                   	push   %ebx
80104eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104eee:	85 f6                	test   %esi,%esi
80104ef0:	74 2e                	je     80104f20 <strncmp+0x40>
80104ef2:	01 d6                	add    %edx,%esi
80104ef4:	eb 18                	jmp    80104f0e <strncmp+0x2e>
80104ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
80104f00:	38 d8                	cmp    %bl,%al
80104f02:	75 14                	jne    80104f18 <strncmp+0x38>
    n--, p++, q++;
80104f04:	83 c2 01             	add    $0x1,%edx
80104f07:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104f0a:	39 f2                	cmp    %esi,%edx
80104f0c:	74 12                	je     80104f20 <strncmp+0x40>
80104f0e:	0f b6 01             	movzbl (%ecx),%eax
80104f11:	0f b6 1a             	movzbl (%edx),%ebx
80104f14:	84 c0                	test   %al,%al
80104f16:	75 e8                	jne    80104f00 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104f18:	29 d8                	sub    %ebx,%eax
}
80104f1a:	5b                   	pop    %ebx
80104f1b:	5e                   	pop    %esi
80104f1c:	5d                   	pop    %ebp
80104f1d:	c3                   	ret    
80104f1e:	66 90                	xchg   %ax,%ax
80104f20:	5b                   	pop    %ebx
    return 0;
80104f21:	31 c0                	xor    %eax,%eax
}
80104f23:	5e                   	pop    %esi
80104f24:	5d                   	pop    %ebp
80104f25:	c3                   	ret    
80104f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi

80104f30 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	57                   	push   %edi
80104f34:	56                   	push   %esi
80104f35:	8b 75 08             	mov    0x8(%ebp),%esi
80104f38:	53                   	push   %ebx
80104f39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f3c:	89 f0                	mov    %esi,%eax
80104f3e:	eb 15                	jmp    80104f55 <strncpy+0x25>
80104f40:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104f44:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104f47:	83 c0 01             	add    $0x1,%eax
80104f4a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104f4e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104f51:	84 d2                	test   %dl,%dl
80104f53:	74 09                	je     80104f5e <strncpy+0x2e>
80104f55:	89 cb                	mov    %ecx,%ebx
80104f57:	83 e9 01             	sub    $0x1,%ecx
80104f5a:	85 db                	test   %ebx,%ebx
80104f5c:	7f e2                	jg     80104f40 <strncpy+0x10>
    ;
  while(n-- > 0)
80104f5e:	89 c2                	mov    %eax,%edx
80104f60:	85 c9                	test   %ecx,%ecx
80104f62:	7e 17                	jle    80104f7b <strncpy+0x4b>
80104f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104f68:	83 c2 01             	add    $0x1,%edx
80104f6b:	89 c1                	mov    %eax,%ecx
80104f6d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104f71:	29 d1                	sub    %edx,%ecx
80104f73:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104f77:	85 c9                	test   %ecx,%ecx
80104f79:	7f ed                	jg     80104f68 <strncpy+0x38>
  return os;
}
80104f7b:	5b                   	pop    %ebx
80104f7c:	89 f0                	mov    %esi,%eax
80104f7e:	5e                   	pop    %esi
80104f7f:	5f                   	pop    %edi
80104f80:	5d                   	pop    %ebp
80104f81:	c3                   	ret    
80104f82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f90 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	8b 55 10             	mov    0x10(%ebp),%edx
80104f97:	8b 75 08             	mov    0x8(%ebp),%esi
80104f9a:	53                   	push   %ebx
80104f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104f9e:	85 d2                	test   %edx,%edx
80104fa0:	7e 25                	jle    80104fc7 <safestrcpy+0x37>
80104fa2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104fa6:	89 f2                	mov    %esi,%edx
80104fa8:	eb 16                	jmp    80104fc0 <safestrcpy+0x30>
80104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104fb0:	0f b6 08             	movzbl (%eax),%ecx
80104fb3:	83 c0 01             	add    $0x1,%eax
80104fb6:	83 c2 01             	add    $0x1,%edx
80104fb9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104fbc:	84 c9                	test   %cl,%cl
80104fbe:	74 04                	je     80104fc4 <safestrcpy+0x34>
80104fc0:	39 d8                	cmp    %ebx,%eax
80104fc2:	75 ec                	jne    80104fb0 <safestrcpy+0x20>
    ;
  *s = 0;
80104fc4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104fc7:	89 f0                	mov    %esi,%eax
80104fc9:	5b                   	pop    %ebx
80104fca:	5e                   	pop    %esi
80104fcb:	5d                   	pop    %ebp
80104fcc:	c3                   	ret    
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi

80104fd0 <strlen>:

int
strlen(const char *s)
{
80104fd0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104fd1:	31 c0                	xor    %eax,%eax
{
80104fd3:	89 e5                	mov    %esp,%ebp
80104fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104fd8:	80 3a 00             	cmpb   $0x0,(%edx)
80104fdb:	74 0c                	je     80104fe9 <strlen+0x19>
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
80104fe0:	83 c0 01             	add    $0x1,%eax
80104fe3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104fe7:	75 f7                	jne    80104fe0 <strlen+0x10>
    ;
  return n;
}
80104fe9:	5d                   	pop    %ebp
80104fea:	c3                   	ret    

80104feb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104feb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104fef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ff3:	55                   	push   %ebp
  pushl %ebx
80104ff4:	53                   	push   %ebx
  pushl %esi
80104ff5:	56                   	push   %esi
  pushl %edi
80104ff6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ff7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ff9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104ffb:	5f                   	pop    %edi
  popl %esi
80104ffc:	5e                   	pop    %esi
  popl %ebx
80104ffd:	5b                   	pop    %ebx
  popl %ebp
80104ffe:	5d                   	pop    %ebp
  ret
80104fff:	c3                   	ret    

80105000 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	53                   	push   %ebx
80105004:	83 ec 04             	sub    $0x4,%esp
80105007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010500a:	e8 91 ea ff ff       	call   80103aa0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010500f:	8b 00                	mov    (%eax),%eax
80105011:	39 d8                	cmp    %ebx,%eax
80105013:	76 1b                	jbe    80105030 <fetchint+0x30>
80105015:	8d 53 04             	lea    0x4(%ebx),%edx
80105018:	39 d0                	cmp    %edx,%eax
8010501a:	72 14                	jb     80105030 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010501c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010501f:	8b 13                	mov    (%ebx),%edx
80105021:	89 10                	mov    %edx,(%eax)
  return 0;
80105023:	31 c0                	xor    %eax,%eax
}
80105025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105028:	c9                   	leave  
80105029:	c3                   	ret    
8010502a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105035:	eb ee                	jmp    80105025 <fetchint+0x25>
80105037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503e:	66 90                	xchg   %ax,%ax

80105040 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	53                   	push   %ebx
80105044:	83 ec 04             	sub    $0x4,%esp
80105047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010504a:	e8 51 ea ff ff       	call   80103aa0 <myproc>

  if(addr >= curproc->sz)
8010504f:	39 18                	cmp    %ebx,(%eax)
80105051:	76 2d                	jbe    80105080 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105053:	8b 55 0c             	mov    0xc(%ebp),%edx
80105056:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105058:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010505a:	39 d3                	cmp    %edx,%ebx
8010505c:	73 22                	jae    80105080 <fetchstr+0x40>
8010505e:	89 d8                	mov    %ebx,%eax
80105060:	eb 0d                	jmp    8010506f <fetchstr+0x2f>
80105062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105068:	83 c0 01             	add    $0x1,%eax
8010506b:	39 c2                	cmp    %eax,%edx
8010506d:	76 11                	jbe    80105080 <fetchstr+0x40>
    if(*s == 0)
8010506f:	80 38 00             	cmpb   $0x0,(%eax)
80105072:	75 f4                	jne    80105068 <fetchstr+0x28>
      return s - *pp;
80105074:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105079:	c9                   	leave  
8010507a:	c3                   	ret    
8010507b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010507f:	90                   	nop
80105080:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105088:	c9                   	leave  
80105089:	c3                   	ret    
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105090 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105095:	e8 06 ea ff ff       	call   80103aa0 <myproc>
8010509a:	8b 55 08             	mov    0x8(%ebp),%edx
8010509d:	8b 40 18             	mov    0x18(%eax),%eax
801050a0:	8b 40 44             	mov    0x44(%eax),%eax
801050a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050a6:	e8 f5 e9 ff ff       	call   80103aa0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050ab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050ae:	8b 00                	mov    (%eax),%eax
801050b0:	39 c6                	cmp    %eax,%esi
801050b2:	73 1c                	jae    801050d0 <argint+0x40>
801050b4:	8d 53 08             	lea    0x8(%ebx),%edx
801050b7:	39 d0                	cmp    %edx,%eax
801050b9:	72 15                	jb     801050d0 <argint+0x40>
  *ip = *(int*)(addr);
801050bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801050be:	8b 53 04             	mov    0x4(%ebx),%edx
801050c1:	89 10                	mov    %edx,(%eax)
  return 0;
801050c3:	31 c0                	xor    %eax,%eax
}
801050c5:	5b                   	pop    %ebx
801050c6:	5e                   	pop    %esi
801050c7:	5d                   	pop    %ebp
801050c8:	c3                   	ret    
801050c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050d5:	eb ee                	jmp    801050c5 <argint+0x35>
801050d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050de:	66 90                	xchg   %ax,%ax

801050e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	57                   	push   %edi
801050e4:	56                   	push   %esi
801050e5:	53                   	push   %ebx
801050e6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801050e9:	e8 b2 e9 ff ff       	call   80103aa0 <myproc>
801050ee:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050f0:	e8 ab e9 ff ff       	call   80103aa0 <myproc>
801050f5:	8b 55 08             	mov    0x8(%ebp),%edx
801050f8:	8b 40 18             	mov    0x18(%eax),%eax
801050fb:	8b 40 44             	mov    0x44(%eax),%eax
801050fe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105101:	e8 9a e9 ff ff       	call   80103aa0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105106:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105109:	8b 00                	mov    (%eax),%eax
8010510b:	39 c7                	cmp    %eax,%edi
8010510d:	73 31                	jae    80105140 <argptr+0x60>
8010510f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105112:	39 c8                	cmp    %ecx,%eax
80105114:	72 2a                	jb     80105140 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105116:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105119:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010511c:	85 d2                	test   %edx,%edx
8010511e:	78 20                	js     80105140 <argptr+0x60>
80105120:	8b 16                	mov    (%esi),%edx
80105122:	39 c2                	cmp    %eax,%edx
80105124:	76 1a                	jbe    80105140 <argptr+0x60>
80105126:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105129:	01 c3                	add    %eax,%ebx
8010512b:	39 da                	cmp    %ebx,%edx
8010512d:	72 11                	jb     80105140 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010512f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105132:	89 02                	mov    %eax,(%edx)
  return 0;
80105134:	31 c0                	xor    %eax,%eax
}
80105136:	83 c4 0c             	add    $0xc,%esp
80105139:	5b                   	pop    %ebx
8010513a:	5e                   	pop    %esi
8010513b:	5f                   	pop    %edi
8010513c:	5d                   	pop    %ebp
8010513d:	c3                   	ret    
8010513e:	66 90                	xchg   %ax,%ax
    return -1;
80105140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105145:	eb ef                	jmp    80105136 <argptr+0x56>
80105147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514e:	66 90                	xchg   %ax,%ax

80105150 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105155:	e8 46 e9 ff ff       	call   80103aa0 <myproc>
8010515a:	8b 55 08             	mov    0x8(%ebp),%edx
8010515d:	8b 40 18             	mov    0x18(%eax),%eax
80105160:	8b 40 44             	mov    0x44(%eax),%eax
80105163:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105166:	e8 35 e9 ff ff       	call   80103aa0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010516b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010516e:	8b 00                	mov    (%eax),%eax
80105170:	39 c6                	cmp    %eax,%esi
80105172:	73 44                	jae    801051b8 <argstr+0x68>
80105174:	8d 53 08             	lea    0x8(%ebx),%edx
80105177:	39 d0                	cmp    %edx,%eax
80105179:	72 3d                	jb     801051b8 <argstr+0x68>
  *ip = *(int*)(addr);
8010517b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010517e:	e8 1d e9 ff ff       	call   80103aa0 <myproc>
  if(addr >= curproc->sz)
80105183:	3b 18                	cmp    (%eax),%ebx
80105185:	73 31                	jae    801051b8 <argstr+0x68>
  *pp = (char*)addr;
80105187:	8b 55 0c             	mov    0xc(%ebp),%edx
8010518a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010518c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010518e:	39 d3                	cmp    %edx,%ebx
80105190:	73 26                	jae    801051b8 <argstr+0x68>
80105192:	89 d8                	mov    %ebx,%eax
80105194:	eb 11                	jmp    801051a7 <argstr+0x57>
80105196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
801051a0:	83 c0 01             	add    $0x1,%eax
801051a3:	39 c2                	cmp    %eax,%edx
801051a5:	76 11                	jbe    801051b8 <argstr+0x68>
    if(*s == 0)
801051a7:	80 38 00             	cmpb   $0x0,(%eax)
801051aa:	75 f4                	jne    801051a0 <argstr+0x50>
      return s - *pp;
801051ac:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801051ae:	5b                   	pop    %ebx
801051af:	5e                   	pop    %esi
801051b0:	5d                   	pop    %ebp
801051b1:	c3                   	ret    
801051b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051b8:	5b                   	pop    %ebx
    return -1;
801051b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051be:	5e                   	pop    %esi
801051bf:	5d                   	pop    %ebp
801051c0:	c3                   	ret    
801051c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051cf:	90                   	nop

801051d0 <syscall>:
[SYS_getNumFreePages] sys_getNumFreePages,
};

void
syscall(void)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	53                   	push   %ebx
801051d4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801051d7:	e8 c4 e8 ff ff       	call   80103aa0 <myproc>
801051dc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801051de:	8b 40 18             	mov    0x18(%eax),%eax
801051e1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801051e4:	8d 50 ff             	lea    -0x1(%eax),%edx
801051e7:	83 fa 19             	cmp    $0x19,%edx
801051ea:	77 24                	ja     80105210 <syscall+0x40>
801051ec:	8b 14 85 80 82 10 80 	mov    -0x7fef7d80(,%eax,4),%edx
801051f3:	85 d2                	test   %edx,%edx
801051f5:	74 19                	je     80105210 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801051f7:	ff d2                	call   *%edx
801051f9:	89 c2                	mov    %eax,%edx
801051fb:	8b 43 18             	mov    0x18(%ebx),%eax
801051fe:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105201:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105204:	c9                   	leave  
80105205:	c3                   	ret    
80105206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105210:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105211:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105214:	50                   	push   %eax
80105215:	ff 73 10             	push   0x10(%ebx)
80105218:	68 49 82 10 80       	push   $0x80108249
8010521d:	e8 7e b4 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105222:	8b 43 18             	mov    0x18(%ebx),%eax
80105225:	83 c4 10             	add    $0x10,%esp
80105228:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010522f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105232:	c9                   	leave  
80105233:	c3                   	ret    
80105234:	66 90                	xchg   %ax,%ax
80105236:	66 90                	xchg   %ax,%ax
80105238:	66 90                	xchg   %ax,%ax
8010523a:	66 90                	xchg   %ax,%ax
8010523c:	66 90                	xchg   %ax,%ax
8010523e:	66 90                	xchg   %ax,%ax

80105240 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	57                   	push   %edi
80105244:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105245:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105248:	53                   	push   %ebx
80105249:	83 ec 34             	sub    $0x34,%esp
8010524c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010524f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105252:	57                   	push   %edi
80105253:	50                   	push   %eax
{
80105254:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105257:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010525a:	e8 61 ce ff ff       	call   801020c0 <nameiparent>
8010525f:	83 c4 10             	add    $0x10,%esp
80105262:	85 c0                	test   %eax,%eax
80105264:	0f 84 46 01 00 00    	je     801053b0 <create+0x170>
    return 0;
  ilock(dp);
8010526a:	83 ec 0c             	sub    $0xc,%esp
8010526d:	89 c3                	mov    %eax,%ebx
8010526f:	50                   	push   %eax
80105270:	e8 0b c5 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105275:	83 c4 0c             	add    $0xc,%esp
80105278:	6a 00                	push   $0x0
8010527a:	57                   	push   %edi
8010527b:	53                   	push   %ebx
8010527c:	e8 5f ca ff ff       	call   80101ce0 <dirlookup>
80105281:	83 c4 10             	add    $0x10,%esp
80105284:	89 c6                	mov    %eax,%esi
80105286:	85 c0                	test   %eax,%eax
80105288:	74 56                	je     801052e0 <create+0xa0>
    iunlockput(dp);
8010528a:	83 ec 0c             	sub    $0xc,%esp
8010528d:	53                   	push   %ebx
8010528e:	e8 7d c7 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80105293:	89 34 24             	mov    %esi,(%esp)
80105296:	e8 e5 c4 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010529b:	83 c4 10             	add    $0x10,%esp
8010529e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801052a3:	75 1b                	jne    801052c0 <create+0x80>
801052a5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801052aa:	75 14                	jne    801052c0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801052ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052af:	89 f0                	mov    %esi,%eax
801052b1:	5b                   	pop    %ebx
801052b2:	5e                   	pop    %esi
801052b3:	5f                   	pop    %edi
801052b4:	5d                   	pop    %ebp
801052b5:	c3                   	ret    
801052b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	56                   	push   %esi
    return 0;
801052c4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801052c6:	e8 45 c7 ff ff       	call   80101a10 <iunlockput>
    return 0;
801052cb:	83 c4 10             	add    $0x10,%esp
}
801052ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052d1:	89 f0                	mov    %esi,%eax
801052d3:	5b                   	pop    %ebx
801052d4:	5e                   	pop    %esi
801052d5:	5f                   	pop    %edi
801052d6:	5d                   	pop    %ebp
801052d7:	c3                   	ret    
801052d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052df:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801052e0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801052e4:	83 ec 08             	sub    $0x8,%esp
801052e7:	50                   	push   %eax
801052e8:	ff 33                	push   (%ebx)
801052ea:	e8 21 c3 ff ff       	call   80101610 <ialloc>
801052ef:	83 c4 10             	add    $0x10,%esp
801052f2:	89 c6                	mov    %eax,%esi
801052f4:	85 c0                	test   %eax,%eax
801052f6:	0f 84 cd 00 00 00    	je     801053c9 <create+0x189>
  ilock(ip);
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	50                   	push   %eax
80105300:	e8 7b c4 ff ff       	call   80101780 <ilock>
  ip->major = major;
80105305:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105309:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010530d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105311:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105315:	b8 01 00 00 00       	mov    $0x1,%eax
8010531a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010531e:	89 34 24             	mov    %esi,(%esp)
80105321:	e8 aa c3 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105326:	83 c4 10             	add    $0x10,%esp
80105329:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010532e:	74 30                	je     80105360 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105330:	83 ec 04             	sub    $0x4,%esp
80105333:	ff 76 04             	push   0x4(%esi)
80105336:	57                   	push   %edi
80105337:	53                   	push   %ebx
80105338:	e8 a3 cc ff ff       	call   80101fe0 <dirlink>
8010533d:	83 c4 10             	add    $0x10,%esp
80105340:	85 c0                	test   %eax,%eax
80105342:	78 78                	js     801053bc <create+0x17c>
  iunlockput(dp);
80105344:	83 ec 0c             	sub    $0xc,%esp
80105347:	53                   	push   %ebx
80105348:	e8 c3 c6 ff ff       	call   80101a10 <iunlockput>
  return ip;
8010534d:	83 c4 10             	add    $0x10,%esp
}
80105350:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105353:	89 f0                	mov    %esi,%eax
80105355:	5b                   	pop    %ebx
80105356:	5e                   	pop    %esi
80105357:	5f                   	pop    %edi
80105358:	5d                   	pop    %ebp
80105359:	c3                   	ret    
8010535a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105360:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105363:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105368:	53                   	push   %ebx
80105369:	e8 62 c3 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010536e:	83 c4 0c             	add    $0xc,%esp
80105371:	ff 76 04             	push   0x4(%esi)
80105374:	68 08 83 10 80       	push   $0x80108308
80105379:	56                   	push   %esi
8010537a:	e8 61 cc ff ff       	call   80101fe0 <dirlink>
8010537f:	83 c4 10             	add    $0x10,%esp
80105382:	85 c0                	test   %eax,%eax
80105384:	78 18                	js     8010539e <create+0x15e>
80105386:	83 ec 04             	sub    $0x4,%esp
80105389:	ff 73 04             	push   0x4(%ebx)
8010538c:	68 07 83 10 80       	push   $0x80108307
80105391:	56                   	push   %esi
80105392:	e8 49 cc ff ff       	call   80101fe0 <dirlink>
80105397:	83 c4 10             	add    $0x10,%esp
8010539a:	85 c0                	test   %eax,%eax
8010539c:	79 92                	jns    80105330 <create+0xf0>
      panic("create dots");
8010539e:	83 ec 0c             	sub    $0xc,%esp
801053a1:	68 fb 82 10 80       	push   $0x801082fb
801053a6:	e8 d5 af ff ff       	call   80100380 <panic>
801053ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053af:	90                   	nop
}
801053b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801053b3:	31 f6                	xor    %esi,%esi
}
801053b5:	5b                   	pop    %ebx
801053b6:	89 f0                	mov    %esi,%eax
801053b8:	5e                   	pop    %esi
801053b9:	5f                   	pop    %edi
801053ba:	5d                   	pop    %ebp
801053bb:	c3                   	ret    
    panic("create: dirlink");
801053bc:	83 ec 0c             	sub    $0xc,%esp
801053bf:	68 0a 83 10 80       	push   $0x8010830a
801053c4:	e8 b7 af ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801053c9:	83 ec 0c             	sub    $0xc,%esp
801053cc:	68 ec 82 10 80       	push   $0x801082ec
801053d1:	e8 aa af ff ff       	call   80100380 <panic>
801053d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053dd:	8d 76 00             	lea    0x0(%esi),%esi

801053e0 <sys_dup>:
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801053e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801053e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801053eb:	50                   	push   %eax
801053ec:	6a 00                	push   $0x0
801053ee:	e8 9d fc ff ff       	call   80105090 <argint>
801053f3:	83 c4 10             	add    $0x10,%esp
801053f6:	85 c0                	test   %eax,%eax
801053f8:	78 36                	js     80105430 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053fe:	77 30                	ja     80105430 <sys_dup+0x50>
80105400:	e8 9b e6 ff ff       	call   80103aa0 <myproc>
80105405:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105408:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010540c:	85 f6                	test   %esi,%esi
8010540e:	74 20                	je     80105430 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105410:	e8 8b e6 ff ff       	call   80103aa0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105415:	31 db                	xor    %ebx,%ebx
80105417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105420:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105424:	85 d2                	test   %edx,%edx
80105426:	74 18                	je     80105440 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105428:	83 c3 01             	add    $0x1,%ebx
8010542b:	83 fb 10             	cmp    $0x10,%ebx
8010542e:	75 f0                	jne    80105420 <sys_dup+0x40>
}
80105430:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105433:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105438:	89 d8                	mov    %ebx,%eax
8010543a:	5b                   	pop    %ebx
8010543b:	5e                   	pop    %esi
8010543c:	5d                   	pop    %ebp
8010543d:	c3                   	ret    
8010543e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105440:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105443:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105447:	56                   	push   %esi
80105448:	e8 53 ba ff ff       	call   80100ea0 <filedup>
  return fd;
8010544d:	83 c4 10             	add    $0x10,%esp
}
80105450:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105453:	89 d8                	mov    %ebx,%eax
80105455:	5b                   	pop    %ebx
80105456:	5e                   	pop    %esi
80105457:	5d                   	pop    %ebp
80105458:	c3                   	ret    
80105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_read>:
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	56                   	push   %esi
80105464:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105465:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105468:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010546b:	53                   	push   %ebx
8010546c:	6a 00                	push   $0x0
8010546e:	e8 1d fc ff ff       	call   80105090 <argint>
80105473:	83 c4 10             	add    $0x10,%esp
80105476:	85 c0                	test   %eax,%eax
80105478:	78 5e                	js     801054d8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010547a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010547e:	77 58                	ja     801054d8 <sys_read+0x78>
80105480:	e8 1b e6 ff ff       	call   80103aa0 <myproc>
80105485:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105488:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010548c:	85 f6                	test   %esi,%esi
8010548e:	74 48                	je     801054d8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105490:	83 ec 08             	sub    $0x8,%esp
80105493:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105496:	50                   	push   %eax
80105497:	6a 02                	push   $0x2
80105499:	e8 f2 fb ff ff       	call   80105090 <argint>
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	85 c0                	test   %eax,%eax
801054a3:	78 33                	js     801054d8 <sys_read+0x78>
801054a5:	83 ec 04             	sub    $0x4,%esp
801054a8:	ff 75 f0             	push   -0x10(%ebp)
801054ab:	53                   	push   %ebx
801054ac:	6a 01                	push   $0x1
801054ae:	e8 2d fc ff ff       	call   801050e0 <argptr>
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	85 c0                	test   %eax,%eax
801054b8:	78 1e                	js     801054d8 <sys_read+0x78>
  return fileread(f, p, n);
801054ba:	83 ec 04             	sub    $0x4,%esp
801054bd:	ff 75 f0             	push   -0x10(%ebp)
801054c0:	ff 75 f4             	push   -0xc(%ebp)
801054c3:	56                   	push   %esi
801054c4:	e8 57 bb ff ff       	call   80101020 <fileread>
801054c9:	83 c4 10             	add    $0x10,%esp
}
801054cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054cf:	5b                   	pop    %ebx
801054d0:	5e                   	pop    %esi
801054d1:	5d                   	pop    %ebp
801054d2:	c3                   	ret    
801054d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054d7:	90                   	nop
    return -1;
801054d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054dd:	eb ed                	jmp    801054cc <sys_read+0x6c>
801054df:	90                   	nop

801054e0 <sys_write>:
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	56                   	push   %esi
801054e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801054e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054eb:	53                   	push   %ebx
801054ec:	6a 00                	push   $0x0
801054ee:	e8 9d fb ff ff       	call   80105090 <argint>
801054f3:	83 c4 10             	add    $0x10,%esp
801054f6:	85 c0                	test   %eax,%eax
801054f8:	78 5e                	js     80105558 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054fe:	77 58                	ja     80105558 <sys_write+0x78>
80105500:	e8 9b e5 ff ff       	call   80103aa0 <myproc>
80105505:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105508:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010550c:	85 f6                	test   %esi,%esi
8010550e:	74 48                	je     80105558 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105510:	83 ec 08             	sub    $0x8,%esp
80105513:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105516:	50                   	push   %eax
80105517:	6a 02                	push   $0x2
80105519:	e8 72 fb ff ff       	call   80105090 <argint>
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	85 c0                	test   %eax,%eax
80105523:	78 33                	js     80105558 <sys_write+0x78>
80105525:	83 ec 04             	sub    $0x4,%esp
80105528:	ff 75 f0             	push   -0x10(%ebp)
8010552b:	53                   	push   %ebx
8010552c:	6a 01                	push   $0x1
8010552e:	e8 ad fb ff ff       	call   801050e0 <argptr>
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	85 c0                	test   %eax,%eax
80105538:	78 1e                	js     80105558 <sys_write+0x78>
  return filewrite(f, p, n);
8010553a:	83 ec 04             	sub    $0x4,%esp
8010553d:	ff 75 f0             	push   -0x10(%ebp)
80105540:	ff 75 f4             	push   -0xc(%ebp)
80105543:	56                   	push   %esi
80105544:	e8 67 bb ff ff       	call   801010b0 <filewrite>
80105549:	83 c4 10             	add    $0x10,%esp
}
8010554c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010554f:	5b                   	pop    %ebx
80105550:	5e                   	pop    %esi
80105551:	5d                   	pop    %ebp
80105552:	c3                   	ret    
80105553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105557:	90                   	nop
    return -1;
80105558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555d:	eb ed                	jmp    8010554c <sys_write+0x6c>
8010555f:	90                   	nop

80105560 <sys_close>:
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	56                   	push   %esi
80105564:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105565:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105568:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010556b:	50                   	push   %eax
8010556c:	6a 00                	push   $0x0
8010556e:	e8 1d fb ff ff       	call   80105090 <argint>
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	85 c0                	test   %eax,%eax
80105578:	78 3e                	js     801055b8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010557a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010557e:	77 38                	ja     801055b8 <sys_close+0x58>
80105580:	e8 1b e5 ff ff       	call   80103aa0 <myproc>
80105585:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105588:	8d 5a 08             	lea    0x8(%edx),%ebx
8010558b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010558f:	85 f6                	test   %esi,%esi
80105591:	74 25                	je     801055b8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105593:	e8 08 e5 ff ff       	call   80103aa0 <myproc>
  fileclose(f);
80105598:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010559b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801055a2:	00 
  fileclose(f);
801055a3:	56                   	push   %esi
801055a4:	e8 47 b9 ff ff       	call   80100ef0 <fileclose>
  return 0;
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	31 c0                	xor    %eax,%eax
}
801055ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055b1:	5b                   	pop    %ebx
801055b2:	5e                   	pop    %esi
801055b3:	5d                   	pop    %ebp
801055b4:	c3                   	ret    
801055b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801055b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055bd:	eb ef                	jmp    801055ae <sys_close+0x4e>
801055bf:	90                   	nop

801055c0 <sys_fstat>:
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	56                   	push   %esi
801055c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801055c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801055c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055cb:	53                   	push   %ebx
801055cc:	6a 00                	push   $0x0
801055ce:	e8 bd fa ff ff       	call   80105090 <argint>
801055d3:	83 c4 10             	add    $0x10,%esp
801055d6:	85 c0                	test   %eax,%eax
801055d8:	78 46                	js     80105620 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055de:	77 40                	ja     80105620 <sys_fstat+0x60>
801055e0:	e8 bb e4 ff ff       	call   80103aa0 <myproc>
801055e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801055ec:	85 f6                	test   %esi,%esi
801055ee:	74 30                	je     80105620 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801055f0:	83 ec 04             	sub    $0x4,%esp
801055f3:	6a 14                	push   $0x14
801055f5:	53                   	push   %ebx
801055f6:	6a 01                	push   $0x1
801055f8:	e8 e3 fa ff ff       	call   801050e0 <argptr>
801055fd:	83 c4 10             	add    $0x10,%esp
80105600:	85 c0                	test   %eax,%eax
80105602:	78 1c                	js     80105620 <sys_fstat+0x60>
  return filestat(f, st);
80105604:	83 ec 08             	sub    $0x8,%esp
80105607:	ff 75 f4             	push   -0xc(%ebp)
8010560a:	56                   	push   %esi
8010560b:	e8 c0 b9 ff ff       	call   80100fd0 <filestat>
80105610:	83 c4 10             	add    $0x10,%esp
}
80105613:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105616:	5b                   	pop    %ebx
80105617:	5e                   	pop    %esi
80105618:	5d                   	pop    %ebp
80105619:	c3                   	ret    
8010561a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105625:	eb ec                	jmp    80105613 <sys_fstat+0x53>
80105627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562e:	66 90                	xchg   %ax,%ax

80105630 <sys_link>:
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	57                   	push   %edi
80105634:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105635:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105638:	53                   	push   %ebx
80105639:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010563c:	50                   	push   %eax
8010563d:	6a 00                	push   $0x0
8010563f:	e8 0c fb ff ff       	call   80105150 <argstr>
80105644:	83 c4 10             	add    $0x10,%esp
80105647:	85 c0                	test   %eax,%eax
80105649:	0f 88 fb 00 00 00    	js     8010574a <sys_link+0x11a>
8010564f:	83 ec 08             	sub    $0x8,%esp
80105652:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105655:	50                   	push   %eax
80105656:	6a 01                	push   $0x1
80105658:	e8 f3 fa ff ff       	call   80105150 <argstr>
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	85 c0                	test   %eax,%eax
80105662:	0f 88 e2 00 00 00    	js     8010574a <sys_link+0x11a>
  begin_op();
80105668:	e8 03 d8 ff ff       	call   80102e70 <begin_op>
  if((ip = namei(old)) == 0){
8010566d:	83 ec 0c             	sub    $0xc,%esp
80105670:	ff 75 d4             	push   -0x2c(%ebp)
80105673:	e8 28 ca ff ff       	call   801020a0 <namei>
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	89 c3                	mov    %eax,%ebx
8010567d:	85 c0                	test   %eax,%eax
8010567f:	0f 84 e4 00 00 00    	je     80105769 <sys_link+0x139>
  ilock(ip);
80105685:	83 ec 0c             	sub    $0xc,%esp
80105688:	50                   	push   %eax
80105689:	e8 f2 c0 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010568e:	83 c4 10             	add    $0x10,%esp
80105691:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105696:	0f 84 b5 00 00 00    	je     80105751 <sys_link+0x121>
  iupdate(ip);
8010569c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010569f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801056a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801056a7:	53                   	push   %ebx
801056a8:	e8 23 c0 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
801056ad:	89 1c 24             	mov    %ebx,(%esp)
801056b0:	e8 ab c1 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801056b5:	58                   	pop    %eax
801056b6:	5a                   	pop    %edx
801056b7:	57                   	push   %edi
801056b8:	ff 75 d0             	push   -0x30(%ebp)
801056bb:	e8 00 ca ff ff       	call   801020c0 <nameiparent>
801056c0:	83 c4 10             	add    $0x10,%esp
801056c3:	89 c6                	mov    %eax,%esi
801056c5:	85 c0                	test   %eax,%eax
801056c7:	74 5b                	je     80105724 <sys_link+0xf4>
  ilock(dp);
801056c9:	83 ec 0c             	sub    $0xc,%esp
801056cc:	50                   	push   %eax
801056cd:	e8 ae c0 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801056d2:	8b 03                	mov    (%ebx),%eax
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	39 06                	cmp    %eax,(%esi)
801056d9:	75 3d                	jne    80105718 <sys_link+0xe8>
801056db:	83 ec 04             	sub    $0x4,%esp
801056de:	ff 73 04             	push   0x4(%ebx)
801056e1:	57                   	push   %edi
801056e2:	56                   	push   %esi
801056e3:	e8 f8 c8 ff ff       	call   80101fe0 <dirlink>
801056e8:	83 c4 10             	add    $0x10,%esp
801056eb:	85 c0                	test   %eax,%eax
801056ed:	78 29                	js     80105718 <sys_link+0xe8>
  iunlockput(dp);
801056ef:	83 ec 0c             	sub    $0xc,%esp
801056f2:	56                   	push   %esi
801056f3:	e8 18 c3 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
801056f8:	89 1c 24             	mov    %ebx,(%esp)
801056fb:	e8 b0 c1 ff ff       	call   801018b0 <iput>
  end_op();
80105700:	e8 db d7 ff ff       	call   80102ee0 <end_op>
  return 0;
80105705:	83 c4 10             	add    $0x10,%esp
80105708:	31 c0                	xor    %eax,%eax
}
8010570a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010570d:	5b                   	pop    %ebx
8010570e:	5e                   	pop    %esi
8010570f:	5f                   	pop    %edi
80105710:	5d                   	pop    %ebp
80105711:	c3                   	ret    
80105712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105718:	83 ec 0c             	sub    $0xc,%esp
8010571b:	56                   	push   %esi
8010571c:	e8 ef c2 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105721:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105724:	83 ec 0c             	sub    $0xc,%esp
80105727:	53                   	push   %ebx
80105728:	e8 53 c0 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010572d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105732:	89 1c 24             	mov    %ebx,(%esp)
80105735:	e8 96 bf ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010573a:	89 1c 24             	mov    %ebx,(%esp)
8010573d:	e8 ce c2 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105742:	e8 99 d7 ff ff       	call   80102ee0 <end_op>
  return -1;
80105747:	83 c4 10             	add    $0x10,%esp
8010574a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574f:	eb b9                	jmp    8010570a <sys_link+0xda>
    iunlockput(ip);
80105751:	83 ec 0c             	sub    $0xc,%esp
80105754:	53                   	push   %ebx
80105755:	e8 b6 c2 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010575a:	e8 81 d7 ff ff       	call   80102ee0 <end_op>
    return -1;
8010575f:	83 c4 10             	add    $0x10,%esp
80105762:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105767:	eb a1                	jmp    8010570a <sys_link+0xda>
    end_op();
80105769:	e8 72 d7 ff ff       	call   80102ee0 <end_op>
    return -1;
8010576e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105773:	eb 95                	jmp    8010570a <sys_link+0xda>
80105775:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_unlink>:
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105785:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105788:	53                   	push   %ebx
80105789:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010578c:	50                   	push   %eax
8010578d:	6a 00                	push   $0x0
8010578f:	e8 bc f9 ff ff       	call   80105150 <argstr>
80105794:	83 c4 10             	add    $0x10,%esp
80105797:	85 c0                	test   %eax,%eax
80105799:	0f 88 7a 01 00 00    	js     80105919 <sys_unlink+0x199>
  begin_op();
8010579f:	e8 cc d6 ff ff       	call   80102e70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801057a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801057a7:	83 ec 08             	sub    $0x8,%esp
801057aa:	53                   	push   %ebx
801057ab:	ff 75 c0             	push   -0x40(%ebp)
801057ae:	e8 0d c9 ff ff       	call   801020c0 <nameiparent>
801057b3:	83 c4 10             	add    $0x10,%esp
801057b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801057b9:	85 c0                	test   %eax,%eax
801057bb:	0f 84 62 01 00 00    	je     80105923 <sys_unlink+0x1a3>
  ilock(dp);
801057c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801057c4:	83 ec 0c             	sub    $0xc,%esp
801057c7:	57                   	push   %edi
801057c8:	e8 b3 bf ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801057cd:	58                   	pop    %eax
801057ce:	5a                   	pop    %edx
801057cf:	68 08 83 10 80       	push   $0x80108308
801057d4:	53                   	push   %ebx
801057d5:	e8 e6 c4 ff ff       	call   80101cc0 <namecmp>
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	85 c0                	test   %eax,%eax
801057df:	0f 84 fb 00 00 00    	je     801058e0 <sys_unlink+0x160>
801057e5:	83 ec 08             	sub    $0x8,%esp
801057e8:	68 07 83 10 80       	push   $0x80108307
801057ed:	53                   	push   %ebx
801057ee:	e8 cd c4 ff ff       	call   80101cc0 <namecmp>
801057f3:	83 c4 10             	add    $0x10,%esp
801057f6:	85 c0                	test   %eax,%eax
801057f8:	0f 84 e2 00 00 00    	je     801058e0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801057fe:	83 ec 04             	sub    $0x4,%esp
80105801:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105804:	50                   	push   %eax
80105805:	53                   	push   %ebx
80105806:	57                   	push   %edi
80105807:	e8 d4 c4 ff ff       	call   80101ce0 <dirlookup>
8010580c:	83 c4 10             	add    $0x10,%esp
8010580f:	89 c3                	mov    %eax,%ebx
80105811:	85 c0                	test   %eax,%eax
80105813:	0f 84 c7 00 00 00    	je     801058e0 <sys_unlink+0x160>
  ilock(ip);
80105819:	83 ec 0c             	sub    $0xc,%esp
8010581c:	50                   	push   %eax
8010581d:	e8 5e bf ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105822:	83 c4 10             	add    $0x10,%esp
80105825:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010582a:	0f 8e 1c 01 00 00    	jle    8010594c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105830:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105835:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105838:	74 66                	je     801058a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010583a:	83 ec 04             	sub    $0x4,%esp
8010583d:	6a 10                	push   $0x10
8010583f:	6a 00                	push   $0x0
80105841:	57                   	push   %edi
80105842:	e8 89 f5 ff ff       	call   80104dd0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105847:	6a 10                	push   $0x10
80105849:	ff 75 c4             	push   -0x3c(%ebp)
8010584c:	57                   	push   %edi
8010584d:	ff 75 b4             	push   -0x4c(%ebp)
80105850:	e8 3b c3 ff ff       	call   80101b90 <writei>
80105855:	83 c4 20             	add    $0x20,%esp
80105858:	83 f8 10             	cmp    $0x10,%eax
8010585b:	0f 85 de 00 00 00    	jne    8010593f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105861:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105866:	0f 84 94 00 00 00    	je     80105900 <sys_unlink+0x180>
  iunlockput(dp);
8010586c:	83 ec 0c             	sub    $0xc,%esp
8010586f:	ff 75 b4             	push   -0x4c(%ebp)
80105872:	e8 99 c1 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105877:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010587c:	89 1c 24             	mov    %ebx,(%esp)
8010587f:	e8 4c be ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105884:	89 1c 24             	mov    %ebx,(%esp)
80105887:	e8 84 c1 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010588c:	e8 4f d6 ff ff       	call   80102ee0 <end_op>
  return 0;
80105891:	83 c4 10             	add    $0x10,%esp
80105894:	31 c0                	xor    %eax,%eax
}
80105896:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105899:	5b                   	pop    %ebx
8010589a:	5e                   	pop    %esi
8010589b:	5f                   	pop    %edi
8010589c:	5d                   	pop    %ebp
8010589d:	c3                   	ret    
8010589e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801058a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801058a4:	76 94                	jbe    8010583a <sys_unlink+0xba>
801058a6:	be 20 00 00 00       	mov    $0x20,%esi
801058ab:	eb 0b                	jmp    801058b8 <sys_unlink+0x138>
801058ad:	8d 76 00             	lea    0x0(%esi),%esi
801058b0:	83 c6 10             	add    $0x10,%esi
801058b3:	3b 73 58             	cmp    0x58(%ebx),%esi
801058b6:	73 82                	jae    8010583a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058b8:	6a 10                	push   $0x10
801058ba:	56                   	push   %esi
801058bb:	57                   	push   %edi
801058bc:	53                   	push   %ebx
801058bd:	e8 ce c1 ff ff       	call   80101a90 <readi>
801058c2:	83 c4 10             	add    $0x10,%esp
801058c5:	83 f8 10             	cmp    $0x10,%eax
801058c8:	75 68                	jne    80105932 <sys_unlink+0x1b2>
    if(de.inum != 0)
801058ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801058cf:	74 df                	je     801058b0 <sys_unlink+0x130>
    iunlockput(ip);
801058d1:	83 ec 0c             	sub    $0xc,%esp
801058d4:	53                   	push   %ebx
801058d5:	e8 36 c1 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	ff 75 b4             	push   -0x4c(%ebp)
801058e6:	e8 25 c1 ff ff       	call   80101a10 <iunlockput>
  end_op();
801058eb:	e8 f0 d5 ff ff       	call   80102ee0 <end_op>
  return -1;
801058f0:	83 c4 10             	add    $0x10,%esp
801058f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f8:	eb 9c                	jmp    80105896 <sys_unlink+0x116>
801058fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105900:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105903:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105906:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010590b:	50                   	push   %eax
8010590c:	e8 bf bd ff ff       	call   801016d0 <iupdate>
80105911:	83 c4 10             	add    $0x10,%esp
80105914:	e9 53 ff ff ff       	jmp    8010586c <sys_unlink+0xec>
    return -1;
80105919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010591e:	e9 73 ff ff ff       	jmp    80105896 <sys_unlink+0x116>
    end_op();
80105923:	e8 b8 d5 ff ff       	call   80102ee0 <end_op>
    return -1;
80105928:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592d:	e9 64 ff ff ff       	jmp    80105896 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105932:	83 ec 0c             	sub    $0xc,%esp
80105935:	68 2c 83 10 80       	push   $0x8010832c
8010593a:	e8 41 aa ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010593f:	83 ec 0c             	sub    $0xc,%esp
80105942:	68 3e 83 10 80       	push   $0x8010833e
80105947:	e8 34 aa ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010594c:	83 ec 0c             	sub    $0xc,%esp
8010594f:	68 1a 83 10 80       	push   $0x8010831a
80105954:	e8 27 aa ff ff       	call   80100380 <panic>
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105960 <sys_open>:

int
sys_open(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	57                   	push   %edi
80105964:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105965:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105968:	53                   	push   %ebx
80105969:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010596c:	50                   	push   %eax
8010596d:	6a 00                	push   $0x0
8010596f:	e8 dc f7 ff ff       	call   80105150 <argstr>
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	85 c0                	test   %eax,%eax
80105979:	0f 88 8e 00 00 00    	js     80105a0d <sys_open+0xad>
8010597f:	83 ec 08             	sub    $0x8,%esp
80105982:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105985:	50                   	push   %eax
80105986:	6a 01                	push   $0x1
80105988:	e8 03 f7 ff ff       	call   80105090 <argint>
8010598d:	83 c4 10             	add    $0x10,%esp
80105990:	85 c0                	test   %eax,%eax
80105992:	78 79                	js     80105a0d <sys_open+0xad>
    return -1;

  begin_op();
80105994:	e8 d7 d4 ff ff       	call   80102e70 <begin_op>

  if(omode & O_CREATE){
80105999:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010599d:	75 79                	jne    80105a18 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010599f:	83 ec 0c             	sub    $0xc,%esp
801059a2:	ff 75 e0             	push   -0x20(%ebp)
801059a5:	e8 f6 c6 ff ff       	call   801020a0 <namei>
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	89 c6                	mov    %eax,%esi
801059af:	85 c0                	test   %eax,%eax
801059b1:	0f 84 7e 00 00 00    	je     80105a35 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801059b7:	83 ec 0c             	sub    $0xc,%esp
801059ba:	50                   	push   %eax
801059bb:	e8 c0 bd ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801059c0:	83 c4 10             	add    $0x10,%esp
801059c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801059c8:	0f 84 c2 00 00 00    	je     80105a90 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801059ce:	e8 5d b4 ff ff       	call   80100e30 <filealloc>
801059d3:	89 c7                	mov    %eax,%edi
801059d5:	85 c0                	test   %eax,%eax
801059d7:	74 23                	je     801059fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801059d9:	e8 c2 e0 ff ff       	call   80103aa0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801059e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801059e4:	85 d2                	test   %edx,%edx
801059e6:	74 60                	je     80105a48 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801059e8:	83 c3 01             	add    $0x1,%ebx
801059eb:	83 fb 10             	cmp    $0x10,%ebx
801059ee:	75 f0                	jne    801059e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801059f0:	83 ec 0c             	sub    $0xc,%esp
801059f3:	57                   	push   %edi
801059f4:	e8 f7 b4 ff ff       	call   80100ef0 <fileclose>
801059f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801059fc:	83 ec 0c             	sub    $0xc,%esp
801059ff:	56                   	push   %esi
80105a00:	e8 0b c0 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105a05:	e8 d6 d4 ff ff       	call   80102ee0 <end_op>
    return -1;
80105a0a:	83 c4 10             	add    $0x10,%esp
80105a0d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a12:	eb 6d                	jmp    80105a81 <sys_open+0x121>
80105a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105a18:	83 ec 0c             	sub    $0xc,%esp
80105a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a1e:	31 c9                	xor    %ecx,%ecx
80105a20:	ba 02 00 00 00       	mov    $0x2,%edx
80105a25:	6a 00                	push   $0x0
80105a27:	e8 14 f8 ff ff       	call   80105240 <create>
    if(ip == 0){
80105a2c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105a2f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105a31:	85 c0                	test   %eax,%eax
80105a33:	75 99                	jne    801059ce <sys_open+0x6e>
      end_op();
80105a35:	e8 a6 d4 ff ff       	call   80102ee0 <end_op>
      return -1;
80105a3a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a3f:	eb 40                	jmp    80105a81 <sys_open+0x121>
80105a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105a48:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105a4b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105a4f:	56                   	push   %esi
80105a50:	e8 0b be ff ff       	call   80101860 <iunlock>
  end_op();
80105a55:	e8 86 d4 ff ff       	call   80102ee0 <end_op>

  f->type = FD_INODE;
80105a5a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a63:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105a66:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105a69:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105a6b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105a72:	f7 d0                	not    %eax
80105a74:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a77:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105a7a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a7d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105a81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a84:	89 d8                	mov    %ebx,%eax
80105a86:	5b                   	pop    %ebx
80105a87:	5e                   	pop    %esi
80105a88:	5f                   	pop    %edi
80105a89:	5d                   	pop    %ebp
80105a8a:	c3                   	ret    
80105a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a8f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a90:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a93:	85 c9                	test   %ecx,%ecx
80105a95:	0f 84 33 ff ff ff    	je     801059ce <sys_open+0x6e>
80105a9b:	e9 5c ff ff ff       	jmp    801059fc <sys_open+0x9c>

80105aa0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105aa6:	e8 c5 d3 ff ff       	call   80102e70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105aab:	83 ec 08             	sub    $0x8,%esp
80105aae:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ab1:	50                   	push   %eax
80105ab2:	6a 00                	push   $0x0
80105ab4:	e8 97 f6 ff ff       	call   80105150 <argstr>
80105ab9:	83 c4 10             	add    $0x10,%esp
80105abc:	85 c0                	test   %eax,%eax
80105abe:	78 30                	js     80105af0 <sys_mkdir+0x50>
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac6:	31 c9                	xor    %ecx,%ecx
80105ac8:	ba 01 00 00 00       	mov    $0x1,%edx
80105acd:	6a 00                	push   $0x0
80105acf:	e8 6c f7 ff ff       	call   80105240 <create>
80105ad4:	83 c4 10             	add    $0x10,%esp
80105ad7:	85 c0                	test   %eax,%eax
80105ad9:	74 15                	je     80105af0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105adb:	83 ec 0c             	sub    $0xc,%esp
80105ade:	50                   	push   %eax
80105adf:	e8 2c bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105ae4:	e8 f7 d3 ff ff       	call   80102ee0 <end_op>
  return 0;
80105ae9:	83 c4 10             	add    $0x10,%esp
80105aec:	31 c0                	xor    %eax,%eax
}
80105aee:	c9                   	leave  
80105aef:	c3                   	ret    
    end_op();
80105af0:	e8 eb d3 ff ff       	call   80102ee0 <end_op>
    return -1;
80105af5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105afa:	c9                   	leave  
80105afb:	c3                   	ret    
80105afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b00 <sys_mknod>:

int
sys_mknod(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105b06:	e8 65 d3 ff ff       	call   80102e70 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105b0b:	83 ec 08             	sub    $0x8,%esp
80105b0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b11:	50                   	push   %eax
80105b12:	6a 00                	push   $0x0
80105b14:	e8 37 f6 ff ff       	call   80105150 <argstr>
80105b19:	83 c4 10             	add    $0x10,%esp
80105b1c:	85 c0                	test   %eax,%eax
80105b1e:	78 60                	js     80105b80 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105b20:	83 ec 08             	sub    $0x8,%esp
80105b23:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b26:	50                   	push   %eax
80105b27:	6a 01                	push   $0x1
80105b29:	e8 62 f5 ff ff       	call   80105090 <argint>
  if((argstr(0, &path)) < 0 ||
80105b2e:	83 c4 10             	add    $0x10,%esp
80105b31:	85 c0                	test   %eax,%eax
80105b33:	78 4b                	js     80105b80 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105b35:	83 ec 08             	sub    $0x8,%esp
80105b38:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b3b:	50                   	push   %eax
80105b3c:	6a 02                	push   $0x2
80105b3e:	e8 4d f5 ff ff       	call   80105090 <argint>
     argint(1, &major) < 0 ||
80105b43:	83 c4 10             	add    $0x10,%esp
80105b46:	85 c0                	test   %eax,%eax
80105b48:	78 36                	js     80105b80 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105b4a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105b4e:	83 ec 0c             	sub    $0xc,%esp
80105b51:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105b55:	ba 03 00 00 00       	mov    $0x3,%edx
80105b5a:	50                   	push   %eax
80105b5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b5e:	e8 dd f6 ff ff       	call   80105240 <create>
     argint(2, &minor) < 0 ||
80105b63:	83 c4 10             	add    $0x10,%esp
80105b66:	85 c0                	test   %eax,%eax
80105b68:	74 16                	je     80105b80 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b6a:	83 ec 0c             	sub    $0xc,%esp
80105b6d:	50                   	push   %eax
80105b6e:	e8 9d be ff ff       	call   80101a10 <iunlockput>
  end_op();
80105b73:	e8 68 d3 ff ff       	call   80102ee0 <end_op>
  return 0;
80105b78:	83 c4 10             	add    $0x10,%esp
80105b7b:	31 c0                	xor    %eax,%eax
}
80105b7d:	c9                   	leave  
80105b7e:	c3                   	ret    
80105b7f:	90                   	nop
    end_op();
80105b80:	e8 5b d3 ff ff       	call   80102ee0 <end_op>
    return -1;
80105b85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b8a:	c9                   	leave  
80105b8b:	c3                   	ret    
80105b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b90 <sys_chdir>:

int
sys_chdir(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	56                   	push   %esi
80105b94:	53                   	push   %ebx
80105b95:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b98:	e8 03 df ff ff       	call   80103aa0 <myproc>
80105b9d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105b9f:	e8 cc d2 ff ff       	call   80102e70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ba4:	83 ec 08             	sub    $0x8,%esp
80105ba7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105baa:	50                   	push   %eax
80105bab:	6a 00                	push   $0x0
80105bad:	e8 9e f5 ff ff       	call   80105150 <argstr>
80105bb2:	83 c4 10             	add    $0x10,%esp
80105bb5:	85 c0                	test   %eax,%eax
80105bb7:	78 77                	js     80105c30 <sys_chdir+0xa0>
80105bb9:	83 ec 0c             	sub    $0xc,%esp
80105bbc:	ff 75 f4             	push   -0xc(%ebp)
80105bbf:	e8 dc c4 ff ff       	call   801020a0 <namei>
80105bc4:	83 c4 10             	add    $0x10,%esp
80105bc7:	89 c3                	mov    %eax,%ebx
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	74 63                	je     80105c30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105bcd:	83 ec 0c             	sub    $0xc,%esp
80105bd0:	50                   	push   %eax
80105bd1:	e8 aa bb ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105bd6:	83 c4 10             	add    $0x10,%esp
80105bd9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105bde:	75 30                	jne    80105c10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105be0:	83 ec 0c             	sub    $0xc,%esp
80105be3:	53                   	push   %ebx
80105be4:	e8 77 bc ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105be9:	58                   	pop    %eax
80105bea:	ff 76 68             	push   0x68(%esi)
80105bed:	e8 be bc ff ff       	call   801018b0 <iput>
  end_op();
80105bf2:	e8 e9 d2 ff ff       	call   80102ee0 <end_op>
  curproc->cwd = ip;
80105bf7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105bfa:	83 c4 10             	add    $0x10,%esp
80105bfd:	31 c0                	xor    %eax,%eax
}
80105bff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c02:	5b                   	pop    %ebx
80105c03:	5e                   	pop    %esi
80105c04:	5d                   	pop    %ebp
80105c05:	c3                   	ret    
80105c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105c10:	83 ec 0c             	sub    $0xc,%esp
80105c13:	53                   	push   %ebx
80105c14:	e8 f7 bd ff ff       	call   80101a10 <iunlockput>
    end_op();
80105c19:	e8 c2 d2 ff ff       	call   80102ee0 <end_op>
    return -1;
80105c1e:	83 c4 10             	add    $0x10,%esp
80105c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c26:	eb d7                	jmp    80105bff <sys_chdir+0x6f>
80105c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop
    end_op();
80105c30:	e8 ab d2 ff ff       	call   80102ee0 <end_op>
    return -1;
80105c35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c3a:	eb c3                	jmp    80105bff <sys_chdir+0x6f>
80105c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c40 <sys_exec>:

int
sys_exec(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	57                   	push   %edi
80105c44:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c45:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105c4b:	53                   	push   %ebx
80105c4c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c52:	50                   	push   %eax
80105c53:	6a 00                	push   $0x0
80105c55:	e8 f6 f4 ff ff       	call   80105150 <argstr>
80105c5a:	83 c4 10             	add    $0x10,%esp
80105c5d:	85 c0                	test   %eax,%eax
80105c5f:	0f 88 87 00 00 00    	js     80105cec <sys_exec+0xac>
80105c65:	83 ec 08             	sub    $0x8,%esp
80105c68:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105c6e:	50                   	push   %eax
80105c6f:	6a 01                	push   $0x1
80105c71:	e8 1a f4 ff ff       	call   80105090 <argint>
80105c76:	83 c4 10             	add    $0x10,%esp
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	78 6f                	js     80105cec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105c7d:	83 ec 04             	sub    $0x4,%esp
80105c80:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105c86:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105c88:	68 80 00 00 00       	push   $0x80
80105c8d:	6a 00                	push   $0x0
80105c8f:	56                   	push   %esi
80105c90:	e8 3b f1 ff ff       	call   80104dd0 <memset>
80105c95:	83 c4 10             	add    $0x10,%esp
80105c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105ca0:	83 ec 08             	sub    $0x8,%esp
80105ca3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105ca9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105cb0:	50                   	push   %eax
80105cb1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105cb7:	01 f8                	add    %edi,%eax
80105cb9:	50                   	push   %eax
80105cba:	e8 41 f3 ff ff       	call   80105000 <fetchint>
80105cbf:	83 c4 10             	add    $0x10,%esp
80105cc2:	85 c0                	test   %eax,%eax
80105cc4:	78 26                	js     80105cec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105cc6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105ccc:	85 c0                	test   %eax,%eax
80105cce:	74 30                	je     80105d00 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105cd0:	83 ec 08             	sub    $0x8,%esp
80105cd3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105cd6:	52                   	push   %edx
80105cd7:	50                   	push   %eax
80105cd8:	e8 63 f3 ff ff       	call   80105040 <fetchstr>
80105cdd:	83 c4 10             	add    $0x10,%esp
80105ce0:	85 c0                	test   %eax,%eax
80105ce2:	78 08                	js     80105cec <sys_exec+0xac>
  for(i=0;; i++){
80105ce4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105ce7:	83 fb 20             	cmp    $0x20,%ebx
80105cea:	75 b4                	jne    80105ca0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105cef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cf4:	5b                   	pop    %ebx
80105cf5:	5e                   	pop    %esi
80105cf6:	5f                   	pop    %edi
80105cf7:	5d                   	pop    %ebp
80105cf8:	c3                   	ret    
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105d00:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105d07:	00 00 00 00 
  return exec(path, argv);
80105d0b:	83 ec 08             	sub    $0x8,%esp
80105d0e:	56                   	push   %esi
80105d0f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105d15:	e8 96 ad ff ff       	call   80100ab0 <exec>
80105d1a:	83 c4 10             	add    $0x10,%esp
}
80105d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d20:	5b                   	pop    %ebx
80105d21:	5e                   	pop    %esi
80105d22:	5f                   	pop    %edi
80105d23:	5d                   	pop    %ebp
80105d24:	c3                   	ret    
80105d25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d30 <sys_pipe>:

int
sys_pipe(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	57                   	push   %edi
80105d34:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d35:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105d38:	53                   	push   %ebx
80105d39:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d3c:	6a 08                	push   $0x8
80105d3e:	50                   	push   %eax
80105d3f:	6a 00                	push   $0x0
80105d41:	e8 9a f3 ff ff       	call   801050e0 <argptr>
80105d46:	83 c4 10             	add    $0x10,%esp
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	78 4a                	js     80105d97 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105d4d:	83 ec 08             	sub    $0x8,%esp
80105d50:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d53:	50                   	push   %eax
80105d54:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d57:	50                   	push   %eax
80105d58:	e8 e3 d7 ff ff       	call   80103540 <pipealloc>
80105d5d:	83 c4 10             	add    $0x10,%esp
80105d60:	85 c0                	test   %eax,%eax
80105d62:	78 33                	js     80105d97 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d64:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105d67:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105d69:	e8 32 dd ff ff       	call   80103aa0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d6e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105d70:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105d74:	85 f6                	test   %esi,%esi
80105d76:	74 28                	je     80105da0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105d78:	83 c3 01             	add    $0x1,%ebx
80105d7b:	83 fb 10             	cmp    $0x10,%ebx
80105d7e:	75 f0                	jne    80105d70 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105d80:	83 ec 0c             	sub    $0xc,%esp
80105d83:	ff 75 e0             	push   -0x20(%ebp)
80105d86:	e8 65 b1 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80105d8b:	58                   	pop    %eax
80105d8c:	ff 75 e4             	push   -0x1c(%ebp)
80105d8f:	e8 5c b1 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105d94:	83 c4 10             	add    $0x10,%esp
80105d97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d9c:	eb 53                	jmp    80105df1 <sys_pipe+0xc1>
80105d9e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105da0:	8d 73 08             	lea    0x8(%ebx),%esi
80105da3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105da7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105daa:	e8 f1 dc ff ff       	call   80103aa0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105daf:	31 d2                	xor    %edx,%edx
80105db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105db8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105dbc:	85 c9                	test   %ecx,%ecx
80105dbe:	74 20                	je     80105de0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105dc0:	83 c2 01             	add    $0x1,%edx
80105dc3:	83 fa 10             	cmp    $0x10,%edx
80105dc6:	75 f0                	jne    80105db8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105dc8:	e8 d3 dc ff ff       	call   80103aa0 <myproc>
80105dcd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105dd4:	00 
80105dd5:	eb a9                	jmp    80105d80 <sys_pipe+0x50>
80105dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dde:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105de0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105de4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105de7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105de9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105dec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105def:	31 c0                	xor    %eax,%eax
}
80105df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105df4:	5b                   	pop    %ebx
80105df5:	5e                   	pop    %esi
80105df6:	5f                   	pop    %edi
80105df7:	5d                   	pop    %ebp
80105df8:	c3                   	ret    
80105df9:	66 90                	xchg   %ax,%ax
80105dfb:	66 90                	xchg   %ax,%ax
80105dfd:	66 90                	xchg   %ax,%ax
80105dff:	90                   	nop

80105e00 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105e00:	e9 3b de ff ff       	jmp    80103c40 <fork>
80105e05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e10 <sys_exit>:
}

int
sys_exit(void)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e16:	e8 45 e1 ff ff       	call   80103f60 <exit>
  return 0;  // not reached
}
80105e1b:	31 c0                	xor    %eax,%eax
80105e1d:	c9                   	leave  
80105e1e:	c3                   	ret    
80105e1f:	90                   	nop

80105e20 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105e20:	e9 6b e2 ff ff       	jmp    80104090 <wait>
80105e25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e30 <sys_kill>:
}

int
sys_kill(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105e36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e39:	50                   	push   %eax
80105e3a:	6a 00                	push   $0x0
80105e3c:	e8 4f f2 ff ff       	call   80105090 <argint>
80105e41:	83 c4 10             	add    $0x10,%esp
80105e44:	85 c0                	test   %eax,%eax
80105e46:	78 18                	js     80105e60 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105e48:	83 ec 0c             	sub    $0xc,%esp
80105e4b:	ff 75 f4             	push   -0xc(%ebp)
80105e4e:	e8 dd e4 ff ff       	call   80104330 <kill>
80105e53:	83 c4 10             	add    $0x10,%esp
}
80105e56:	c9                   	leave  
80105e57:	c3                   	ret    
80105e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5f:	90                   	nop
80105e60:	c9                   	leave  
    return -1;
80105e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e66:	c3                   	ret    
80105e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6e:	66 90                	xchg   %ax,%ax

80105e70 <sys_getpid>:

int
sys_getpid(void)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e76:	e8 25 dc ff ff       	call   80103aa0 <myproc>
80105e7b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105e7e:	c9                   	leave  
80105e7f:	c3                   	ret    

80105e80 <sys_sbrk>:

int
sys_sbrk(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105e84:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e87:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e8a:	50                   	push   %eax
80105e8b:	6a 00                	push   $0x0
80105e8d:	e8 fe f1 ff ff       	call   80105090 <argint>
80105e92:	83 c4 10             	add    $0x10,%esp
80105e95:	85 c0                	test   %eax,%eax
80105e97:	78 27                	js     80105ec0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105e99:	e8 02 dc ff ff       	call   80103aa0 <myproc>
  if(growproc(n) < 0)
80105e9e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ea1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ea3:	ff 75 f4             	push   -0xc(%ebp)
80105ea6:	e8 15 dd ff ff       	call   80103bc0 <growproc>
80105eab:	83 c4 10             	add    $0x10,%esp
80105eae:	85 c0                	test   %eax,%eax
80105eb0:	78 0e                	js     80105ec0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105eb2:	89 d8                	mov    %ebx,%eax
80105eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105eb7:	c9                   	leave  
80105eb8:	c3                   	ret    
80105eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ec0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ec5:	eb eb                	jmp    80105eb2 <sys_sbrk+0x32>
80105ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ece:	66 90                	xchg   %ax,%ax

80105ed0 <sys_sleep>:

int
sys_sleep(void)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ed4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ed7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105eda:	50                   	push   %eax
80105edb:	6a 00                	push   $0x0
80105edd:	e8 ae f1 ff ff       	call   80105090 <argint>
80105ee2:	83 c4 10             	add    $0x10,%esp
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	0f 88 8a 00 00 00    	js     80105f77 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105eed:	83 ec 0c             	sub    $0xc,%esp
80105ef0:	68 a0 ce 14 80       	push   $0x8014cea0
80105ef5:	e8 16 ee ff ff       	call   80104d10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105efa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105efd:	8b 1d 80 ce 14 80    	mov    0x8014ce80,%ebx
  while(ticks - ticks0 < n){
80105f03:	83 c4 10             	add    $0x10,%esp
80105f06:	85 d2                	test   %edx,%edx
80105f08:	75 27                	jne    80105f31 <sys_sleep+0x61>
80105f0a:	eb 54                	jmp    80105f60 <sys_sleep+0x90>
80105f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105f10:	83 ec 08             	sub    $0x8,%esp
80105f13:	68 a0 ce 14 80       	push   $0x8014cea0
80105f18:	68 80 ce 14 80       	push   $0x8014ce80
80105f1d:	e8 ee e2 ff ff       	call   80104210 <sleep>
  while(ticks - ticks0 < n){
80105f22:	a1 80 ce 14 80       	mov    0x8014ce80,%eax
80105f27:	83 c4 10             	add    $0x10,%esp
80105f2a:	29 d8                	sub    %ebx,%eax
80105f2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105f2f:	73 2f                	jae    80105f60 <sys_sleep+0x90>
    if(myproc()->killed){
80105f31:	e8 6a db ff ff       	call   80103aa0 <myproc>
80105f36:	8b 40 24             	mov    0x24(%eax),%eax
80105f39:	85 c0                	test   %eax,%eax
80105f3b:	74 d3                	je     80105f10 <sys_sleep+0x40>
      release(&tickslock);
80105f3d:	83 ec 0c             	sub    $0xc,%esp
80105f40:	68 a0 ce 14 80       	push   $0x8014cea0
80105f45:	e8 66 ed ff ff       	call   80104cb0 <release>
  }
  release(&tickslock);
  return 0;
}
80105f4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105f4d:	83 c4 10             	add    $0x10,%esp
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    
80105f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f5e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105f60:	83 ec 0c             	sub    $0xc,%esp
80105f63:	68 a0 ce 14 80       	push   $0x8014cea0
80105f68:	e8 43 ed ff ff       	call   80104cb0 <release>
  return 0;
80105f6d:	83 c4 10             	add    $0x10,%esp
80105f70:	31 c0                	xor    %eax,%eax
}
80105f72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f75:	c9                   	leave  
80105f76:	c3                   	ret    
    return -1;
80105f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f7c:	eb f4                	jmp    80105f72 <sys_sleep+0xa2>
80105f7e:	66 90                	xchg   %ax,%ax

80105f80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	53                   	push   %ebx
80105f84:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105f87:	68 a0 ce 14 80       	push   $0x8014cea0
80105f8c:	e8 7f ed ff ff       	call   80104d10 <acquire>
  xticks = ticks;
80105f91:	8b 1d 80 ce 14 80    	mov    0x8014ce80,%ebx
  release(&tickslock);
80105f97:	c7 04 24 a0 ce 14 80 	movl   $0x8014cea0,(%esp)
80105f9e:	e8 0d ed ff ff       	call   80104cb0 <release>
  return xticks;
}
80105fa3:	89 d8                	mov    %ebx,%eax
80105fa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fa8:	c9                   	leave  
80105fa9:	c3                   	ret    
80105faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105fb0 <sys_forknexec>:

//20181295 hw2
int
sys_forknexec(void)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	57                   	push   %edi
80105fb4:	56                   	push   %esi
	char *path, *args[MAXARG];
	int i;
	uint uargs, uarg;

	if(argstr(0, &path) < 0 || argint(1, (int*)&uargs) < 0){
80105fb5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105fbb:	53                   	push   %ebx
80105fbc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
	if(argstr(0, &path) < 0 || argint(1, (int*)&uargs) < 0){
80105fc2:	50                   	push   %eax
80105fc3:	6a 00                	push   $0x0
80105fc5:	e8 86 f1 ff ff       	call   80105150 <argstr>
80105fca:	83 c4 10             	add    $0x10,%esp
80105fcd:	85 c0                	test   %eax,%eax
80105fcf:	0f 88 87 00 00 00    	js     8010605c <sys_forknexec+0xac>
80105fd5:	83 ec 08             	sub    $0x8,%esp
80105fd8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105fde:	50                   	push   %eax
80105fdf:	6a 01                	push   $0x1
80105fe1:	e8 aa f0 ff ff       	call   80105090 <argint>
80105fe6:	83 c4 10             	add    $0x10,%esp
80105fe9:	85 c0                	test   %eax,%eax
80105feb:	78 6f                	js     8010605c <sys_forknexec+0xac>
		return -1;
  }
	memset(args, 0, sizeof(args));
80105fed:	83 ec 04             	sub    $0x4,%esp
80105ff0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
	for(i=0;; i++){
80105ff6:	31 db                	xor    %ebx,%ebx
	memset(args, 0, sizeof(args));
80105ff8:	68 80 00 00 00       	push   $0x80
80105ffd:	6a 00                	push   $0x0
80105fff:	56                   	push   %esi
80106000:	e8 cb ed ff ff       	call   80104dd0 <memset>
80106005:	83 c4 10             	add    $0x10,%esp
80106008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600f:	90                   	nop
		if(i >= NELEM(args))
			return -1;
		if(fetchint(uargs+4*i, (int*)&uarg) < 0)
80106010:	83 ec 08             	sub    $0x8,%esp
80106013:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106019:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106020:	50                   	push   %eax
80106021:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106027:	01 f8                	add    %edi,%eax
80106029:	50                   	push   %eax
8010602a:	e8 d1 ef ff ff       	call   80105000 <fetchint>
8010602f:	83 c4 10             	add    $0x10,%esp
80106032:	85 c0                	test   %eax,%eax
80106034:	78 26                	js     8010605c <sys_forknexec+0xac>
			return -1;
		if(uarg == 0){
80106036:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010603c:	85 c0                	test   %eax,%eax
8010603e:	74 30                	je     80106070 <sys_forknexec+0xc0>
			args[i] = 0;
			break;
		}
		if(fetchstr(uarg, &args[i]) < 0)
80106040:	83 ec 08             	sub    $0x8,%esp
80106043:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106046:	52                   	push   %edx
80106047:	50                   	push   %eax
80106048:	e8 f3 ef ff ff       	call   80105040 <fetchstr>
8010604d:	83 c4 10             	add    $0x10,%esp
80106050:	85 c0                	test   %eax,%eax
80106052:	78 08                	js     8010605c <sys_forknexec+0xac>
	for(i=0;; i++){
80106054:	83 c3 01             	add    $0x1,%ebx
		if(i >= NELEM(args))
80106057:	83 fb 20             	cmp    $0x20,%ebx
8010605a:	75 b4                	jne    80106010 <sys_forknexec+0x60>
			return -1;
	}
	return forknexec((const char *)path, (const char **)args);
}
8010605c:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return -1;
8010605f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106064:	5b                   	pop    %ebx
80106065:	5e                   	pop    %esi
80106066:	5f                   	pop    %edi
80106067:	5d                   	pop    %ebp
80106068:	c3                   	ret    
80106069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			args[i] = 0;
80106070:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106077:	00 00 00 00 
	return forknexec((const char *)path, (const char **)args);
8010607b:	83 ec 08             	sub    $0x8,%esp
8010607e:	56                   	push   %esi
8010607f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106085:	e8 e6 e3 ff ff       	call   80104470 <forknexec>
8010608a:	83 c4 10             	add    $0x10,%esp
}
8010608d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106090:	5b                   	pop    %ebx
80106091:	5e                   	pop    %esi
80106092:	5f                   	pop    %edi
80106093:	5d                   	pop    %ebp
80106094:	c3                   	ret    
80106095:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010609c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060a0 <sys_set_proc_priority>:


//20181295 hw3
int
sys_set_proc_priority(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	83 ec 20             	sub    $0x20,%esp
  int pid, priority;

  if (argint(0, &pid) < 0 || argint(1, &priority) < 0)
801060a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060a9:	50                   	push   %eax
801060aa:	6a 00                	push   $0x0
801060ac:	e8 df ef ff ff       	call   80105090 <argint>
801060b1:	83 c4 10             	add    $0x10,%esp
801060b4:	85 c0                	test   %eax,%eax
801060b6:	78 28                	js     801060e0 <sys_set_proc_priority+0x40>
801060b8:	83 ec 08             	sub    $0x8,%esp
801060bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060be:	50                   	push   %eax
801060bf:	6a 01                	push   $0x1
801060c1:	e8 ca ef ff ff       	call   80105090 <argint>
801060c6:	83 c4 10             	add    $0x10,%esp
801060c9:	85 c0                	test   %eax,%eax
801060cb:	78 13                	js     801060e0 <sys_set_proc_priority+0x40>
    return -1;
  return set_proc_priority(pid, priority);
801060cd:	83 ec 08             	sub    $0x8,%esp
801060d0:	ff 75 f4             	push   -0xc(%ebp)
801060d3:	ff 75 f0             	push   -0x10(%ebp)
801060d6:	e8 25 e8 ff ff       	call   80104900 <set_proc_priority>
801060db:	83 c4 10             	add    $0x10,%esp
}
801060de:	c9                   	leave  
801060df:	c3                   	ret    
801060e0:	c9                   	leave  
    return -1;
801060e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060e6:	c3                   	ret    
801060e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ee:	66 90                	xchg   %ax,%ax

801060f0 <sys_get_proc_priority>:

int
sys_get_proc_priority(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
801060f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060f9:	50                   	push   %eax
801060fa:	6a 00                	push   $0x0
801060fc:	e8 8f ef ff ff       	call   80105090 <argint>
80106101:	83 c4 10             	add    $0x10,%esp
80106104:	85 c0                	test   %eax,%eax
80106106:	78 18                	js     80106120 <sys_get_proc_priority+0x30>
    return -1;
  return get_proc_priority(pid);
80106108:	83 ec 0c             	sub    $0xc,%esp
8010610b:	ff 75 f4             	push   -0xc(%ebp)
8010610e:	e8 2d e8 ff ff       	call   80104940 <get_proc_priority>
80106113:	83 c4 10             	add    $0x10,%esp
}
80106116:	c9                   	leave  
80106117:	c3                   	ret    
80106118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010611f:	90                   	nop
80106120:	c9                   	leave  
    return -1;
80106121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106126:	c3                   	ret    
80106127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612e:	66 90                	xchg   %ax,%ax

80106130 <sys_get_proc_cnt>:

int
sys_get_proc_cnt(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80106136:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106139:	50                   	push   %eax
8010613a:	6a 00                	push   $0x0
8010613c:	e8 4f ef ff ff       	call   80105090 <argint>
80106141:	83 c4 10             	add    $0x10,%esp
80106144:	85 c0                	test   %eax,%eax
80106146:	78 18                	js     80106160 <sys_get_proc_cnt+0x30>
    return -1;
  return get_proc_cnt(pid);
80106148:	83 ec 0c             	sub    $0xc,%esp
8010614b:	ff 75 f4             	push   -0xc(%ebp)
8010614e:	e8 4d e8 ff ff       	call   801049a0 <get_proc_cnt>
80106153:	83 c4 10             	add    $0x10,%esp
}
80106156:	c9                   	leave  
80106157:	c3                   	ret    
80106158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010615f:	90                   	nop
80106160:	c9                   	leave  
    return -1;
80106161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106166:	c3                   	ret    
80106167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616e:	66 90                	xchg   %ax,%ax

80106170 <sys_getNumFreePages>:

//20181295 hw4
int
sys_getNumFreePages(void)
{
  return getNumFreePages();
80106170:	e9 ab c3 ff ff       	jmp    80102520 <getNumFreePages>

80106175 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106175:	1e                   	push   %ds
  pushl %es
80106176:	06                   	push   %es
  pushl %fs
80106177:	0f a0                	push   %fs
  pushl %gs
80106179:	0f a8                	push   %gs
  pushal
8010617b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010617c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106180:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106182:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106184:	54                   	push   %esp
  call trap
80106185:	e8 c6 00 00 00       	call   80106250 <trap>
  addl $4, %esp
8010618a:	83 c4 04             	add    $0x4,%esp

8010618d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010618d:	61                   	popa   
  popl %gs
8010618e:	0f a9                	pop    %gs
  popl %fs
80106190:	0f a1                	pop    %fs
  popl %es
80106192:	07                   	pop    %es
  popl %ds
80106193:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106194:	83 c4 08             	add    $0x8,%esp
  iret
80106197:	cf                   	iret   
80106198:	66 90                	xchg   %ax,%ax
8010619a:	66 90                	xchg   %ax,%ax
8010619c:	66 90                	xchg   %ax,%ax
8010619e:	66 90                	xchg   %ax,%ax

801061a0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801061a0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801061a1:	31 c0                	xor    %eax,%eax
{
801061a3:	89 e5                	mov    %esp,%ebp
801061a5:	83 ec 08             	sub    $0x8,%esp
801061a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061af:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801061b0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801061b7:	c7 04 c5 e2 ce 14 80 	movl   $0x8e000008,-0x7feb311e(,%eax,8)
801061be:	08 00 00 8e 
801061c2:	66 89 14 c5 e0 ce 14 	mov    %dx,-0x7feb3120(,%eax,8)
801061c9:	80 
801061ca:	c1 ea 10             	shr    $0x10,%edx
801061cd:	66 89 14 c5 e6 ce 14 	mov    %dx,-0x7feb311a(,%eax,8)
801061d4:	80 
  for(i = 0; i < 256; i++)
801061d5:	83 c0 01             	add    $0x1,%eax
801061d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801061dd:	75 d1                	jne    801061b0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801061df:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061e2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801061e7:	c7 05 e2 d0 14 80 08 	movl   $0xef000008,0x8014d0e2
801061ee:	00 00 ef 
  initlock(&tickslock, "time");
801061f1:	68 4d 83 10 80       	push   $0x8010834d
801061f6:	68 a0 ce 14 80       	push   $0x8014cea0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061fb:	66 a3 e0 d0 14 80    	mov    %ax,0x8014d0e0
80106201:	c1 e8 10             	shr    $0x10,%eax
80106204:	66 a3 e6 d0 14 80    	mov    %ax,0x8014d0e6
  initlock(&tickslock, "time");
8010620a:	e8 31 e9 ff ff       	call   80104b40 <initlock>
}
8010620f:	83 c4 10             	add    $0x10,%esp
80106212:	c9                   	leave  
80106213:	c3                   	ret    
80106214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010621b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010621f:	90                   	nop

80106220 <idtinit>:

void
idtinit(void)
{
80106220:	55                   	push   %ebp
  pd[0] = size-1;
80106221:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106226:	89 e5                	mov    %esp,%ebp
80106228:	83 ec 10             	sub    $0x10,%esp
8010622b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010622f:	b8 e0 ce 14 80       	mov    $0x8014cee0,%eax
80106234:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106238:	c1 e8 10             	shr    $0x10,%eax
8010623b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010623f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106242:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106245:	c9                   	leave  
80106246:	c3                   	ret    
80106247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010624e:	66 90                	xchg   %ax,%ax

80106250 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106250:	55                   	push   %ebp
80106251:	89 e5                	mov    %esp,%ebp
80106253:	57                   	push   %edi
80106254:	56                   	push   %esi
80106255:	53                   	push   %ebx
80106256:	83 ec 1c             	sub    $0x1c,%esp
80106259:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010625c:	8b 43 30             	mov    0x30(%ebx),%eax
8010625f:	83 f8 40             	cmp    $0x40,%eax
80106262:	0f 84 30 01 00 00    	je     80106398 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106268:	83 e8 0e             	sub    $0xe,%eax
8010626b:	83 f8 31             	cmp    $0x31,%eax
8010626e:	0f 87 8c 00 00 00    	ja     80106300 <trap+0xb0>
80106274:	ff 24 85 f4 83 10 80 	jmp    *-0x7fef7c0c(,%eax,4)
8010627b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010627f:	90                   	nop
  case T_PGFLT:   //20181295 calls pagefault handler
    pagefault();
    break;
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106280:	e8 fb d7 ff ff       	call   80103a80 <cpuid>
80106285:	85 c0                	test   %eax,%eax
80106287:	0f 84 13 02 00 00    	je     801064a0 <trap+0x250>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
8010628d:	e8 8e c7 ff ff       	call   80102a20 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106292:	e8 09 d8 ff ff       	call   80103aa0 <myproc>
80106297:	85 c0                	test   %eax,%eax
80106299:	74 1d                	je     801062b8 <trap+0x68>
8010629b:	e8 00 d8 ff ff       	call   80103aa0 <myproc>
801062a0:	8b 50 24             	mov    0x24(%eax),%edx
801062a3:	85 d2                	test   %edx,%edx
801062a5:	74 11                	je     801062b8 <trap+0x68>
801062a7:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062ab:	83 e0 03             	and    $0x3,%eax
801062ae:	66 83 f8 03          	cmp    $0x3,%ax
801062b2:	0f 84 c8 01 00 00    	je     80106480 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801062b8:	e8 e3 d7 ff ff       	call   80103aa0 <myproc>
801062bd:	85 c0                	test   %eax,%eax
801062bf:	74 0f                	je     801062d0 <trap+0x80>
801062c1:	e8 da d7 ff ff       	call   80103aa0 <myproc>
801062c6:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062ca:	0f 84 b0 00 00 00    	je     80106380 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062d0:	e8 cb d7 ff ff       	call   80103aa0 <myproc>
801062d5:	85 c0                	test   %eax,%eax
801062d7:	74 1d                	je     801062f6 <trap+0xa6>
801062d9:	e8 c2 d7 ff ff       	call   80103aa0 <myproc>
801062de:	8b 40 24             	mov    0x24(%eax),%eax
801062e1:	85 c0                	test   %eax,%eax
801062e3:	74 11                	je     801062f6 <trap+0xa6>
801062e5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062e9:	83 e0 03             	and    $0x3,%eax
801062ec:	66 83 f8 03          	cmp    $0x3,%ax
801062f0:	0f 84 cf 00 00 00    	je     801063c5 <trap+0x175>
    exit();
}
801062f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062f9:	5b                   	pop    %ebx
801062fa:	5e                   	pop    %esi
801062fb:	5f                   	pop    %edi
801062fc:	5d                   	pop    %ebp
801062fd:	c3                   	ret    
801062fe:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80106300:	e8 9b d7 ff ff       	call   80103aa0 <myproc>
80106305:	8b 7b 38             	mov    0x38(%ebx),%edi
80106308:	85 c0                	test   %eax,%eax
8010630a:	0f 84 c4 01 00 00    	je     801064d4 <trap+0x284>
80106310:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106314:	0f 84 ba 01 00 00    	je     801064d4 <trap+0x284>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010631a:	0f 20 d1             	mov    %cr2,%ecx
8010631d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106320:	e8 5b d7 ff ff       	call   80103a80 <cpuid>
80106325:	8b 73 30             	mov    0x30(%ebx),%esi
80106328:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010632b:	8b 43 34             	mov    0x34(%ebx),%eax
8010632e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106331:	e8 6a d7 ff ff       	call   80103aa0 <myproc>
80106336:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106339:	e8 62 d7 ff ff       	call   80103aa0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010633e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106341:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106344:	51                   	push   %ecx
80106345:	57                   	push   %edi
80106346:	52                   	push   %edx
80106347:	ff 75 e4             	push   -0x1c(%ebp)
8010634a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010634b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010634e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106351:	56                   	push   %esi
80106352:	ff 70 10             	push   0x10(%eax)
80106355:	68 b0 83 10 80       	push   $0x801083b0
8010635a:	e8 41 a3 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010635f:	83 c4 20             	add    $0x20,%esp
80106362:	e8 39 d7 ff ff       	call   80103aa0 <myproc>
80106367:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010636e:	e8 2d d7 ff ff       	call   80103aa0 <myproc>
80106373:	85 c0                	test   %eax,%eax
80106375:	0f 85 20 ff ff ff    	jne    8010629b <trap+0x4b>
8010637b:	e9 38 ff ff ff       	jmp    801062b8 <trap+0x68>
  if(myproc() && myproc()->state == RUNNING &&
80106380:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106384:	0f 85 46 ff ff ff    	jne    801062d0 <trap+0x80>
    yield();
8010638a:	e8 31 de ff ff       	call   801041c0 <yield>
8010638f:	e9 3c ff ff ff       	jmp    801062d0 <trap+0x80>
80106394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106398:	e8 03 d7 ff ff       	call   80103aa0 <myproc>
8010639d:	8b 70 24             	mov    0x24(%eax),%esi
801063a0:	85 f6                	test   %esi,%esi
801063a2:	0f 85 e8 00 00 00    	jne    80106490 <trap+0x240>
    myproc()->tf = tf;
801063a8:	e8 f3 d6 ff ff       	call   80103aa0 <myproc>
801063ad:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801063b0:	e8 1b ee ff ff       	call   801051d0 <syscall>
    if(myproc()->killed)
801063b5:	e8 e6 d6 ff ff       	call   80103aa0 <myproc>
801063ba:	8b 48 24             	mov    0x24(%eax),%ecx
801063bd:	85 c9                	test   %ecx,%ecx
801063bf:	0f 84 31 ff ff ff    	je     801062f6 <trap+0xa6>
}
801063c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063c8:	5b                   	pop    %ebx
801063c9:	5e                   	pop    %esi
801063ca:	5f                   	pop    %edi
801063cb:	5d                   	pop    %ebp
      exit();
801063cc:	e9 8f db ff ff       	jmp    80103f60 <exit>
801063d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801063d8:	8b 7b 38             	mov    0x38(%ebx),%edi
801063db:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801063df:	e8 9c d6 ff ff       	call   80103a80 <cpuid>
801063e4:	57                   	push   %edi
801063e5:	56                   	push   %esi
801063e6:	50                   	push   %eax
801063e7:	68 58 83 10 80       	push   $0x80108358
801063ec:	e8 af a2 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
801063f1:	e8 2a c6 ff ff       	call   80102a20 <lapiceoi>
    break;
801063f6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063f9:	e8 a2 d6 ff ff       	call   80103aa0 <myproc>
801063fe:	85 c0                	test   %eax,%eax
80106400:	0f 85 95 fe ff ff    	jne    8010629b <trap+0x4b>
80106406:	e9 ad fe ff ff       	jmp    801062b8 <trap+0x68>
8010640b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010640f:	90                   	nop
    kbdintr();
80106410:	e8 cb c4 ff ff       	call   801028e0 <kbdintr>
    lapiceoi();
80106415:	e8 06 c6 ff ff       	call   80102a20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010641a:	e8 81 d6 ff ff       	call   80103aa0 <myproc>
8010641f:	85 c0                	test   %eax,%eax
80106421:	0f 85 74 fe ff ff    	jne    8010629b <trap+0x4b>
80106427:	e9 8c fe ff ff       	jmp    801062b8 <trap+0x68>
8010642c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106430:	e8 3b 02 00 00       	call   80106670 <uartintr>
    lapiceoi();
80106435:	e8 e6 c5 ff ff       	call   80102a20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010643a:	e8 61 d6 ff ff       	call   80103aa0 <myproc>
8010643f:	85 c0                	test   %eax,%eax
80106441:	0f 85 54 fe ff ff    	jne    8010629b <trap+0x4b>
80106447:	e9 6c fe ff ff       	jmp    801062b8 <trap+0x68>
8010644c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106450:	e8 eb bd ff ff       	call   80102240 <ideintr>
80106455:	e9 33 fe ff ff       	jmp    8010628d <trap+0x3d>
8010645a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pagefault();
80106460:	e8 2b 15 00 00       	call   80107990 <pagefault>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106465:	e8 36 d6 ff ff       	call   80103aa0 <myproc>
8010646a:	85 c0                	test   %eax,%eax
8010646c:	0f 85 29 fe ff ff    	jne    8010629b <trap+0x4b>
80106472:	e9 41 fe ff ff       	jmp    801062b8 <trap+0x68>
80106477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010647e:	66 90                	xchg   %ax,%ax
    exit();
80106480:	e8 db da ff ff       	call   80103f60 <exit>
80106485:	e9 2e fe ff ff       	jmp    801062b8 <trap+0x68>
8010648a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106490:	e8 cb da ff ff       	call   80103f60 <exit>
80106495:	e9 0e ff ff ff       	jmp    801063a8 <trap+0x158>
8010649a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801064a0:	83 ec 0c             	sub    $0xc,%esp
801064a3:	68 a0 ce 14 80       	push   $0x8014cea0
801064a8:	e8 63 e8 ff ff       	call   80104d10 <acquire>
      wakeup(&ticks);
801064ad:	c7 04 24 80 ce 14 80 	movl   $0x8014ce80,(%esp)
      ticks++;
801064b4:	83 05 80 ce 14 80 01 	addl   $0x1,0x8014ce80
      wakeup(&ticks);
801064bb:	e8 10 de ff ff       	call   801042d0 <wakeup>
      release(&tickslock);
801064c0:	c7 04 24 a0 ce 14 80 	movl   $0x8014cea0,(%esp)
801064c7:	e8 e4 e7 ff ff       	call   80104cb0 <release>
801064cc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801064cf:	e9 b9 fd ff ff       	jmp    8010628d <trap+0x3d>
801064d4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064d7:	e8 a4 d5 ff ff       	call   80103a80 <cpuid>
801064dc:	83 ec 0c             	sub    $0xc,%esp
801064df:	56                   	push   %esi
801064e0:	57                   	push   %edi
801064e1:	50                   	push   %eax
801064e2:	ff 73 30             	push   0x30(%ebx)
801064e5:	68 7c 83 10 80       	push   $0x8010837c
801064ea:	e8 b1 a1 ff ff       	call   801006a0 <cprintf>
      panic("trap");
801064ef:	83 c4 14             	add    $0x14,%esp
801064f2:	68 52 83 10 80       	push   $0x80108352
801064f7:	e8 84 9e ff ff       	call   80100380 <panic>
801064fc:	66 90                	xchg   %ax,%ax
801064fe:	66 90                	xchg   %ax,%ax

80106500 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106500:	a1 e0 d6 14 80       	mov    0x8014d6e0,%eax
80106505:	85 c0                	test   %eax,%eax
80106507:	74 17                	je     80106520 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106509:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010650e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010650f:	a8 01                	test   $0x1,%al
80106511:	74 0d                	je     80106520 <uartgetc+0x20>
80106513:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106518:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106519:	0f b6 c0             	movzbl %al,%eax
8010651c:	c3                   	ret    
8010651d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106525:	c3                   	ret    
80106526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010652d:	8d 76 00             	lea    0x0(%esi),%esi

80106530 <uartinit>:
{
80106530:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106531:	31 c9                	xor    %ecx,%ecx
80106533:	89 c8                	mov    %ecx,%eax
80106535:	89 e5                	mov    %esp,%ebp
80106537:	57                   	push   %edi
80106538:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010653d:	56                   	push   %esi
8010653e:	89 fa                	mov    %edi,%edx
80106540:	53                   	push   %ebx
80106541:	83 ec 1c             	sub    $0x1c,%esp
80106544:	ee                   	out    %al,(%dx)
80106545:	be fb 03 00 00       	mov    $0x3fb,%esi
8010654a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010654f:	89 f2                	mov    %esi,%edx
80106551:	ee                   	out    %al,(%dx)
80106552:	b8 0c 00 00 00       	mov    $0xc,%eax
80106557:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010655c:	ee                   	out    %al,(%dx)
8010655d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106562:	89 c8                	mov    %ecx,%eax
80106564:	89 da                	mov    %ebx,%edx
80106566:	ee                   	out    %al,(%dx)
80106567:	b8 03 00 00 00       	mov    $0x3,%eax
8010656c:	89 f2                	mov    %esi,%edx
8010656e:	ee                   	out    %al,(%dx)
8010656f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106574:	89 c8                	mov    %ecx,%eax
80106576:	ee                   	out    %al,(%dx)
80106577:	b8 01 00 00 00       	mov    $0x1,%eax
8010657c:	89 da                	mov    %ebx,%edx
8010657e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010657f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106584:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106585:	3c ff                	cmp    $0xff,%al
80106587:	74 78                	je     80106601 <uartinit+0xd1>
  uart = 1;
80106589:	c7 05 e0 d6 14 80 01 	movl   $0x1,0x8014d6e0
80106590:	00 00 00 
80106593:	89 fa                	mov    %edi,%edx
80106595:	ec                   	in     (%dx),%al
80106596:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010659b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010659c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010659f:	bf bc 84 10 80       	mov    $0x801084bc,%edi
801065a4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801065a9:	6a 00                	push   $0x0
801065ab:	6a 04                	push   $0x4
801065ad:	e8 ce be ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801065b2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801065b6:	83 c4 10             	add    $0x10,%esp
801065b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801065c0:	a1 e0 d6 14 80       	mov    0x8014d6e0,%eax
801065c5:	bb 80 00 00 00       	mov    $0x80,%ebx
801065ca:	85 c0                	test   %eax,%eax
801065cc:	75 14                	jne    801065e2 <uartinit+0xb2>
801065ce:	eb 23                	jmp    801065f3 <uartinit+0xc3>
    microdelay(10);
801065d0:	83 ec 0c             	sub    $0xc,%esp
801065d3:	6a 0a                	push   $0xa
801065d5:	e8 66 c4 ff ff       	call   80102a40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065da:	83 c4 10             	add    $0x10,%esp
801065dd:	83 eb 01             	sub    $0x1,%ebx
801065e0:	74 07                	je     801065e9 <uartinit+0xb9>
801065e2:	89 f2                	mov    %esi,%edx
801065e4:	ec                   	in     (%dx),%al
801065e5:	a8 20                	test   $0x20,%al
801065e7:	74 e7                	je     801065d0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065e9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801065ed:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065f2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801065f3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801065f7:	83 c7 01             	add    $0x1,%edi
801065fa:	88 45 e7             	mov    %al,-0x19(%ebp)
801065fd:	84 c0                	test   %al,%al
801065ff:	75 bf                	jne    801065c0 <uartinit+0x90>
}
80106601:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106604:	5b                   	pop    %ebx
80106605:	5e                   	pop    %esi
80106606:	5f                   	pop    %edi
80106607:	5d                   	pop    %ebp
80106608:	c3                   	ret    
80106609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106610 <uartputc>:
  if(!uart)
80106610:	a1 e0 d6 14 80       	mov    0x8014d6e0,%eax
80106615:	85 c0                	test   %eax,%eax
80106617:	74 47                	je     80106660 <uartputc+0x50>
{
80106619:	55                   	push   %ebp
8010661a:	89 e5                	mov    %esp,%ebp
8010661c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010661d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106622:	53                   	push   %ebx
80106623:	bb 80 00 00 00       	mov    $0x80,%ebx
80106628:	eb 18                	jmp    80106642 <uartputc+0x32>
8010662a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106630:	83 ec 0c             	sub    $0xc,%esp
80106633:	6a 0a                	push   $0xa
80106635:	e8 06 c4 ff ff       	call   80102a40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010663a:	83 c4 10             	add    $0x10,%esp
8010663d:	83 eb 01             	sub    $0x1,%ebx
80106640:	74 07                	je     80106649 <uartputc+0x39>
80106642:	89 f2                	mov    %esi,%edx
80106644:	ec                   	in     (%dx),%al
80106645:	a8 20                	test   $0x20,%al
80106647:	74 e7                	je     80106630 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106649:	8b 45 08             	mov    0x8(%ebp),%eax
8010664c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106651:	ee                   	out    %al,(%dx)
}
80106652:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106655:	5b                   	pop    %ebx
80106656:	5e                   	pop    %esi
80106657:	5d                   	pop    %ebp
80106658:	c3                   	ret    
80106659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106660:	c3                   	ret    
80106661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010666f:	90                   	nop

80106670 <uartintr>:

void
uartintr(void)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106676:	68 00 65 10 80       	push   $0x80106500
8010667b:	e8 00 a2 ff ff       	call   80100880 <consoleintr>
}
80106680:	83 c4 10             	add    $0x10,%esp
80106683:	c9                   	leave  
80106684:	c3                   	ret    

80106685 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $0
80106687:	6a 00                	push   $0x0
  jmp alltraps
80106689:	e9 e7 fa ff ff       	jmp    80106175 <alltraps>

8010668e <vector1>:
.globl vector1
vector1:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $1
80106690:	6a 01                	push   $0x1
  jmp alltraps
80106692:	e9 de fa ff ff       	jmp    80106175 <alltraps>

80106697 <vector2>:
.globl vector2
vector2:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $2
80106699:	6a 02                	push   $0x2
  jmp alltraps
8010669b:	e9 d5 fa ff ff       	jmp    80106175 <alltraps>

801066a0 <vector3>:
.globl vector3
vector3:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $3
801066a2:	6a 03                	push   $0x3
  jmp alltraps
801066a4:	e9 cc fa ff ff       	jmp    80106175 <alltraps>

801066a9 <vector4>:
.globl vector4
vector4:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $4
801066ab:	6a 04                	push   $0x4
  jmp alltraps
801066ad:	e9 c3 fa ff ff       	jmp    80106175 <alltraps>

801066b2 <vector5>:
.globl vector5
vector5:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $5
801066b4:	6a 05                	push   $0x5
  jmp alltraps
801066b6:	e9 ba fa ff ff       	jmp    80106175 <alltraps>

801066bb <vector6>:
.globl vector6
vector6:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $6
801066bd:	6a 06                	push   $0x6
  jmp alltraps
801066bf:	e9 b1 fa ff ff       	jmp    80106175 <alltraps>

801066c4 <vector7>:
.globl vector7
vector7:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $7
801066c6:	6a 07                	push   $0x7
  jmp alltraps
801066c8:	e9 a8 fa ff ff       	jmp    80106175 <alltraps>

801066cd <vector8>:
.globl vector8
vector8:
  pushl $8
801066cd:	6a 08                	push   $0x8
  jmp alltraps
801066cf:	e9 a1 fa ff ff       	jmp    80106175 <alltraps>

801066d4 <vector9>:
.globl vector9
vector9:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $9
801066d6:	6a 09                	push   $0x9
  jmp alltraps
801066d8:	e9 98 fa ff ff       	jmp    80106175 <alltraps>

801066dd <vector10>:
.globl vector10
vector10:
  pushl $10
801066dd:	6a 0a                	push   $0xa
  jmp alltraps
801066df:	e9 91 fa ff ff       	jmp    80106175 <alltraps>

801066e4 <vector11>:
.globl vector11
vector11:
  pushl $11
801066e4:	6a 0b                	push   $0xb
  jmp alltraps
801066e6:	e9 8a fa ff ff       	jmp    80106175 <alltraps>

801066eb <vector12>:
.globl vector12
vector12:
  pushl $12
801066eb:	6a 0c                	push   $0xc
  jmp alltraps
801066ed:	e9 83 fa ff ff       	jmp    80106175 <alltraps>

801066f2 <vector13>:
.globl vector13
vector13:
  pushl $13
801066f2:	6a 0d                	push   $0xd
  jmp alltraps
801066f4:	e9 7c fa ff ff       	jmp    80106175 <alltraps>

801066f9 <vector14>:
.globl vector14
vector14:
  pushl $14
801066f9:	6a 0e                	push   $0xe
  jmp alltraps
801066fb:	e9 75 fa ff ff       	jmp    80106175 <alltraps>

80106700 <vector15>:
.globl vector15
vector15:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $15
80106702:	6a 0f                	push   $0xf
  jmp alltraps
80106704:	e9 6c fa ff ff       	jmp    80106175 <alltraps>

80106709 <vector16>:
.globl vector16
vector16:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $16
8010670b:	6a 10                	push   $0x10
  jmp alltraps
8010670d:	e9 63 fa ff ff       	jmp    80106175 <alltraps>

80106712 <vector17>:
.globl vector17
vector17:
  pushl $17
80106712:	6a 11                	push   $0x11
  jmp alltraps
80106714:	e9 5c fa ff ff       	jmp    80106175 <alltraps>

80106719 <vector18>:
.globl vector18
vector18:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $18
8010671b:	6a 12                	push   $0x12
  jmp alltraps
8010671d:	e9 53 fa ff ff       	jmp    80106175 <alltraps>

80106722 <vector19>:
.globl vector19
vector19:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $19
80106724:	6a 13                	push   $0x13
  jmp alltraps
80106726:	e9 4a fa ff ff       	jmp    80106175 <alltraps>

8010672b <vector20>:
.globl vector20
vector20:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $20
8010672d:	6a 14                	push   $0x14
  jmp alltraps
8010672f:	e9 41 fa ff ff       	jmp    80106175 <alltraps>

80106734 <vector21>:
.globl vector21
vector21:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $21
80106736:	6a 15                	push   $0x15
  jmp alltraps
80106738:	e9 38 fa ff ff       	jmp    80106175 <alltraps>

8010673d <vector22>:
.globl vector22
vector22:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $22
8010673f:	6a 16                	push   $0x16
  jmp alltraps
80106741:	e9 2f fa ff ff       	jmp    80106175 <alltraps>

80106746 <vector23>:
.globl vector23
vector23:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $23
80106748:	6a 17                	push   $0x17
  jmp alltraps
8010674a:	e9 26 fa ff ff       	jmp    80106175 <alltraps>

8010674f <vector24>:
.globl vector24
vector24:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $24
80106751:	6a 18                	push   $0x18
  jmp alltraps
80106753:	e9 1d fa ff ff       	jmp    80106175 <alltraps>

80106758 <vector25>:
.globl vector25
vector25:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $25
8010675a:	6a 19                	push   $0x19
  jmp alltraps
8010675c:	e9 14 fa ff ff       	jmp    80106175 <alltraps>

80106761 <vector26>:
.globl vector26
vector26:
  pushl $0
80106761:	6a 00                	push   $0x0
  pushl $26
80106763:	6a 1a                	push   $0x1a
  jmp alltraps
80106765:	e9 0b fa ff ff       	jmp    80106175 <alltraps>

8010676a <vector27>:
.globl vector27
vector27:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $27
8010676c:	6a 1b                	push   $0x1b
  jmp alltraps
8010676e:	e9 02 fa ff ff       	jmp    80106175 <alltraps>

80106773 <vector28>:
.globl vector28
vector28:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $28
80106775:	6a 1c                	push   $0x1c
  jmp alltraps
80106777:	e9 f9 f9 ff ff       	jmp    80106175 <alltraps>

8010677c <vector29>:
.globl vector29
vector29:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $29
8010677e:	6a 1d                	push   $0x1d
  jmp alltraps
80106780:	e9 f0 f9 ff ff       	jmp    80106175 <alltraps>

80106785 <vector30>:
.globl vector30
vector30:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $30
80106787:	6a 1e                	push   $0x1e
  jmp alltraps
80106789:	e9 e7 f9 ff ff       	jmp    80106175 <alltraps>

8010678e <vector31>:
.globl vector31
vector31:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $31
80106790:	6a 1f                	push   $0x1f
  jmp alltraps
80106792:	e9 de f9 ff ff       	jmp    80106175 <alltraps>

80106797 <vector32>:
.globl vector32
vector32:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $32
80106799:	6a 20                	push   $0x20
  jmp alltraps
8010679b:	e9 d5 f9 ff ff       	jmp    80106175 <alltraps>

801067a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $33
801067a2:	6a 21                	push   $0x21
  jmp alltraps
801067a4:	e9 cc f9 ff ff       	jmp    80106175 <alltraps>

801067a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $34
801067ab:	6a 22                	push   $0x22
  jmp alltraps
801067ad:	e9 c3 f9 ff ff       	jmp    80106175 <alltraps>

801067b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $35
801067b4:	6a 23                	push   $0x23
  jmp alltraps
801067b6:	e9 ba f9 ff ff       	jmp    80106175 <alltraps>

801067bb <vector36>:
.globl vector36
vector36:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $36
801067bd:	6a 24                	push   $0x24
  jmp alltraps
801067bf:	e9 b1 f9 ff ff       	jmp    80106175 <alltraps>

801067c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $37
801067c6:	6a 25                	push   $0x25
  jmp alltraps
801067c8:	e9 a8 f9 ff ff       	jmp    80106175 <alltraps>

801067cd <vector38>:
.globl vector38
vector38:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $38
801067cf:	6a 26                	push   $0x26
  jmp alltraps
801067d1:	e9 9f f9 ff ff       	jmp    80106175 <alltraps>

801067d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $39
801067d8:	6a 27                	push   $0x27
  jmp alltraps
801067da:	e9 96 f9 ff ff       	jmp    80106175 <alltraps>

801067df <vector40>:
.globl vector40
vector40:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $40
801067e1:	6a 28                	push   $0x28
  jmp alltraps
801067e3:	e9 8d f9 ff ff       	jmp    80106175 <alltraps>

801067e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $41
801067ea:	6a 29                	push   $0x29
  jmp alltraps
801067ec:	e9 84 f9 ff ff       	jmp    80106175 <alltraps>

801067f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $42
801067f3:	6a 2a                	push   $0x2a
  jmp alltraps
801067f5:	e9 7b f9 ff ff       	jmp    80106175 <alltraps>

801067fa <vector43>:
.globl vector43
vector43:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $43
801067fc:	6a 2b                	push   $0x2b
  jmp alltraps
801067fe:	e9 72 f9 ff ff       	jmp    80106175 <alltraps>

80106803 <vector44>:
.globl vector44
vector44:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $44
80106805:	6a 2c                	push   $0x2c
  jmp alltraps
80106807:	e9 69 f9 ff ff       	jmp    80106175 <alltraps>

8010680c <vector45>:
.globl vector45
vector45:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $45
8010680e:	6a 2d                	push   $0x2d
  jmp alltraps
80106810:	e9 60 f9 ff ff       	jmp    80106175 <alltraps>

80106815 <vector46>:
.globl vector46
vector46:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $46
80106817:	6a 2e                	push   $0x2e
  jmp alltraps
80106819:	e9 57 f9 ff ff       	jmp    80106175 <alltraps>

8010681e <vector47>:
.globl vector47
vector47:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $47
80106820:	6a 2f                	push   $0x2f
  jmp alltraps
80106822:	e9 4e f9 ff ff       	jmp    80106175 <alltraps>

80106827 <vector48>:
.globl vector48
vector48:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $48
80106829:	6a 30                	push   $0x30
  jmp alltraps
8010682b:	e9 45 f9 ff ff       	jmp    80106175 <alltraps>

80106830 <vector49>:
.globl vector49
vector49:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $49
80106832:	6a 31                	push   $0x31
  jmp alltraps
80106834:	e9 3c f9 ff ff       	jmp    80106175 <alltraps>

80106839 <vector50>:
.globl vector50
vector50:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $50
8010683b:	6a 32                	push   $0x32
  jmp alltraps
8010683d:	e9 33 f9 ff ff       	jmp    80106175 <alltraps>

80106842 <vector51>:
.globl vector51
vector51:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $51
80106844:	6a 33                	push   $0x33
  jmp alltraps
80106846:	e9 2a f9 ff ff       	jmp    80106175 <alltraps>

8010684b <vector52>:
.globl vector52
vector52:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $52
8010684d:	6a 34                	push   $0x34
  jmp alltraps
8010684f:	e9 21 f9 ff ff       	jmp    80106175 <alltraps>

80106854 <vector53>:
.globl vector53
vector53:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $53
80106856:	6a 35                	push   $0x35
  jmp alltraps
80106858:	e9 18 f9 ff ff       	jmp    80106175 <alltraps>

8010685d <vector54>:
.globl vector54
vector54:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $54
8010685f:	6a 36                	push   $0x36
  jmp alltraps
80106861:	e9 0f f9 ff ff       	jmp    80106175 <alltraps>

80106866 <vector55>:
.globl vector55
vector55:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $55
80106868:	6a 37                	push   $0x37
  jmp alltraps
8010686a:	e9 06 f9 ff ff       	jmp    80106175 <alltraps>

8010686f <vector56>:
.globl vector56
vector56:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $56
80106871:	6a 38                	push   $0x38
  jmp alltraps
80106873:	e9 fd f8 ff ff       	jmp    80106175 <alltraps>

80106878 <vector57>:
.globl vector57
vector57:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $57
8010687a:	6a 39                	push   $0x39
  jmp alltraps
8010687c:	e9 f4 f8 ff ff       	jmp    80106175 <alltraps>

80106881 <vector58>:
.globl vector58
vector58:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $58
80106883:	6a 3a                	push   $0x3a
  jmp alltraps
80106885:	e9 eb f8 ff ff       	jmp    80106175 <alltraps>

8010688a <vector59>:
.globl vector59
vector59:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $59
8010688c:	6a 3b                	push   $0x3b
  jmp alltraps
8010688e:	e9 e2 f8 ff ff       	jmp    80106175 <alltraps>

80106893 <vector60>:
.globl vector60
vector60:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $60
80106895:	6a 3c                	push   $0x3c
  jmp alltraps
80106897:	e9 d9 f8 ff ff       	jmp    80106175 <alltraps>

8010689c <vector61>:
.globl vector61
vector61:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $61
8010689e:	6a 3d                	push   $0x3d
  jmp alltraps
801068a0:	e9 d0 f8 ff ff       	jmp    80106175 <alltraps>

801068a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $62
801068a7:	6a 3e                	push   $0x3e
  jmp alltraps
801068a9:	e9 c7 f8 ff ff       	jmp    80106175 <alltraps>

801068ae <vector63>:
.globl vector63
vector63:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $63
801068b0:	6a 3f                	push   $0x3f
  jmp alltraps
801068b2:	e9 be f8 ff ff       	jmp    80106175 <alltraps>

801068b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $64
801068b9:	6a 40                	push   $0x40
  jmp alltraps
801068bb:	e9 b5 f8 ff ff       	jmp    80106175 <alltraps>

801068c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $65
801068c2:	6a 41                	push   $0x41
  jmp alltraps
801068c4:	e9 ac f8 ff ff       	jmp    80106175 <alltraps>

801068c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $66
801068cb:	6a 42                	push   $0x42
  jmp alltraps
801068cd:	e9 a3 f8 ff ff       	jmp    80106175 <alltraps>

801068d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $67
801068d4:	6a 43                	push   $0x43
  jmp alltraps
801068d6:	e9 9a f8 ff ff       	jmp    80106175 <alltraps>

801068db <vector68>:
.globl vector68
vector68:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $68
801068dd:	6a 44                	push   $0x44
  jmp alltraps
801068df:	e9 91 f8 ff ff       	jmp    80106175 <alltraps>

801068e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $69
801068e6:	6a 45                	push   $0x45
  jmp alltraps
801068e8:	e9 88 f8 ff ff       	jmp    80106175 <alltraps>

801068ed <vector70>:
.globl vector70
vector70:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $70
801068ef:	6a 46                	push   $0x46
  jmp alltraps
801068f1:	e9 7f f8 ff ff       	jmp    80106175 <alltraps>

801068f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $71
801068f8:	6a 47                	push   $0x47
  jmp alltraps
801068fa:	e9 76 f8 ff ff       	jmp    80106175 <alltraps>

801068ff <vector72>:
.globl vector72
vector72:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $72
80106901:	6a 48                	push   $0x48
  jmp alltraps
80106903:	e9 6d f8 ff ff       	jmp    80106175 <alltraps>

80106908 <vector73>:
.globl vector73
vector73:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $73
8010690a:	6a 49                	push   $0x49
  jmp alltraps
8010690c:	e9 64 f8 ff ff       	jmp    80106175 <alltraps>

80106911 <vector74>:
.globl vector74
vector74:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $74
80106913:	6a 4a                	push   $0x4a
  jmp alltraps
80106915:	e9 5b f8 ff ff       	jmp    80106175 <alltraps>

8010691a <vector75>:
.globl vector75
vector75:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $75
8010691c:	6a 4b                	push   $0x4b
  jmp alltraps
8010691e:	e9 52 f8 ff ff       	jmp    80106175 <alltraps>

80106923 <vector76>:
.globl vector76
vector76:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $76
80106925:	6a 4c                	push   $0x4c
  jmp alltraps
80106927:	e9 49 f8 ff ff       	jmp    80106175 <alltraps>

8010692c <vector77>:
.globl vector77
vector77:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $77
8010692e:	6a 4d                	push   $0x4d
  jmp alltraps
80106930:	e9 40 f8 ff ff       	jmp    80106175 <alltraps>

80106935 <vector78>:
.globl vector78
vector78:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $78
80106937:	6a 4e                	push   $0x4e
  jmp alltraps
80106939:	e9 37 f8 ff ff       	jmp    80106175 <alltraps>

8010693e <vector79>:
.globl vector79
vector79:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $79
80106940:	6a 4f                	push   $0x4f
  jmp alltraps
80106942:	e9 2e f8 ff ff       	jmp    80106175 <alltraps>

80106947 <vector80>:
.globl vector80
vector80:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $80
80106949:	6a 50                	push   $0x50
  jmp alltraps
8010694b:	e9 25 f8 ff ff       	jmp    80106175 <alltraps>

80106950 <vector81>:
.globl vector81
vector81:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $81
80106952:	6a 51                	push   $0x51
  jmp alltraps
80106954:	e9 1c f8 ff ff       	jmp    80106175 <alltraps>

80106959 <vector82>:
.globl vector82
vector82:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $82
8010695b:	6a 52                	push   $0x52
  jmp alltraps
8010695d:	e9 13 f8 ff ff       	jmp    80106175 <alltraps>

80106962 <vector83>:
.globl vector83
vector83:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $83
80106964:	6a 53                	push   $0x53
  jmp alltraps
80106966:	e9 0a f8 ff ff       	jmp    80106175 <alltraps>

8010696b <vector84>:
.globl vector84
vector84:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $84
8010696d:	6a 54                	push   $0x54
  jmp alltraps
8010696f:	e9 01 f8 ff ff       	jmp    80106175 <alltraps>

80106974 <vector85>:
.globl vector85
vector85:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $85
80106976:	6a 55                	push   $0x55
  jmp alltraps
80106978:	e9 f8 f7 ff ff       	jmp    80106175 <alltraps>

8010697d <vector86>:
.globl vector86
vector86:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $86
8010697f:	6a 56                	push   $0x56
  jmp alltraps
80106981:	e9 ef f7 ff ff       	jmp    80106175 <alltraps>

80106986 <vector87>:
.globl vector87
vector87:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $87
80106988:	6a 57                	push   $0x57
  jmp alltraps
8010698a:	e9 e6 f7 ff ff       	jmp    80106175 <alltraps>

8010698f <vector88>:
.globl vector88
vector88:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $88
80106991:	6a 58                	push   $0x58
  jmp alltraps
80106993:	e9 dd f7 ff ff       	jmp    80106175 <alltraps>

80106998 <vector89>:
.globl vector89
vector89:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $89
8010699a:	6a 59                	push   $0x59
  jmp alltraps
8010699c:	e9 d4 f7 ff ff       	jmp    80106175 <alltraps>

801069a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $90
801069a3:	6a 5a                	push   $0x5a
  jmp alltraps
801069a5:	e9 cb f7 ff ff       	jmp    80106175 <alltraps>

801069aa <vector91>:
.globl vector91
vector91:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $91
801069ac:	6a 5b                	push   $0x5b
  jmp alltraps
801069ae:	e9 c2 f7 ff ff       	jmp    80106175 <alltraps>

801069b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $92
801069b5:	6a 5c                	push   $0x5c
  jmp alltraps
801069b7:	e9 b9 f7 ff ff       	jmp    80106175 <alltraps>

801069bc <vector93>:
.globl vector93
vector93:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $93
801069be:	6a 5d                	push   $0x5d
  jmp alltraps
801069c0:	e9 b0 f7 ff ff       	jmp    80106175 <alltraps>

801069c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $94
801069c7:	6a 5e                	push   $0x5e
  jmp alltraps
801069c9:	e9 a7 f7 ff ff       	jmp    80106175 <alltraps>

801069ce <vector95>:
.globl vector95
vector95:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $95
801069d0:	6a 5f                	push   $0x5f
  jmp alltraps
801069d2:	e9 9e f7 ff ff       	jmp    80106175 <alltraps>

801069d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $96
801069d9:	6a 60                	push   $0x60
  jmp alltraps
801069db:	e9 95 f7 ff ff       	jmp    80106175 <alltraps>

801069e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801069e0:	6a 00                	push   $0x0
  pushl $97
801069e2:	6a 61                	push   $0x61
  jmp alltraps
801069e4:	e9 8c f7 ff ff       	jmp    80106175 <alltraps>

801069e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801069e9:	6a 00                	push   $0x0
  pushl $98
801069eb:	6a 62                	push   $0x62
  jmp alltraps
801069ed:	e9 83 f7 ff ff       	jmp    80106175 <alltraps>

801069f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $99
801069f4:	6a 63                	push   $0x63
  jmp alltraps
801069f6:	e9 7a f7 ff ff       	jmp    80106175 <alltraps>

801069fb <vector100>:
.globl vector100
vector100:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $100
801069fd:	6a 64                	push   $0x64
  jmp alltraps
801069ff:	e9 71 f7 ff ff       	jmp    80106175 <alltraps>

80106a04 <vector101>:
.globl vector101
vector101:
  pushl $0
80106a04:	6a 00                	push   $0x0
  pushl $101
80106a06:	6a 65                	push   $0x65
  jmp alltraps
80106a08:	e9 68 f7 ff ff       	jmp    80106175 <alltraps>

80106a0d <vector102>:
.globl vector102
vector102:
  pushl $0
80106a0d:	6a 00                	push   $0x0
  pushl $102
80106a0f:	6a 66                	push   $0x66
  jmp alltraps
80106a11:	e9 5f f7 ff ff       	jmp    80106175 <alltraps>

80106a16 <vector103>:
.globl vector103
vector103:
  pushl $0
80106a16:	6a 00                	push   $0x0
  pushl $103
80106a18:	6a 67                	push   $0x67
  jmp alltraps
80106a1a:	e9 56 f7 ff ff       	jmp    80106175 <alltraps>

80106a1f <vector104>:
.globl vector104
vector104:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $104
80106a21:	6a 68                	push   $0x68
  jmp alltraps
80106a23:	e9 4d f7 ff ff       	jmp    80106175 <alltraps>

80106a28 <vector105>:
.globl vector105
vector105:
  pushl $0
80106a28:	6a 00                	push   $0x0
  pushl $105
80106a2a:	6a 69                	push   $0x69
  jmp alltraps
80106a2c:	e9 44 f7 ff ff       	jmp    80106175 <alltraps>

80106a31 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a31:	6a 00                	push   $0x0
  pushl $106
80106a33:	6a 6a                	push   $0x6a
  jmp alltraps
80106a35:	e9 3b f7 ff ff       	jmp    80106175 <alltraps>

80106a3a <vector107>:
.globl vector107
vector107:
  pushl $0
80106a3a:	6a 00                	push   $0x0
  pushl $107
80106a3c:	6a 6b                	push   $0x6b
  jmp alltraps
80106a3e:	e9 32 f7 ff ff       	jmp    80106175 <alltraps>

80106a43 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $108
80106a45:	6a 6c                	push   $0x6c
  jmp alltraps
80106a47:	e9 29 f7 ff ff       	jmp    80106175 <alltraps>

80106a4c <vector109>:
.globl vector109
vector109:
  pushl $0
80106a4c:	6a 00                	push   $0x0
  pushl $109
80106a4e:	6a 6d                	push   $0x6d
  jmp alltraps
80106a50:	e9 20 f7 ff ff       	jmp    80106175 <alltraps>

80106a55 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a55:	6a 00                	push   $0x0
  pushl $110
80106a57:	6a 6e                	push   $0x6e
  jmp alltraps
80106a59:	e9 17 f7 ff ff       	jmp    80106175 <alltraps>

80106a5e <vector111>:
.globl vector111
vector111:
  pushl $0
80106a5e:	6a 00                	push   $0x0
  pushl $111
80106a60:	6a 6f                	push   $0x6f
  jmp alltraps
80106a62:	e9 0e f7 ff ff       	jmp    80106175 <alltraps>

80106a67 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $112
80106a69:	6a 70                	push   $0x70
  jmp alltraps
80106a6b:	e9 05 f7 ff ff       	jmp    80106175 <alltraps>

80106a70 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a70:	6a 00                	push   $0x0
  pushl $113
80106a72:	6a 71                	push   $0x71
  jmp alltraps
80106a74:	e9 fc f6 ff ff       	jmp    80106175 <alltraps>

80106a79 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a79:	6a 00                	push   $0x0
  pushl $114
80106a7b:	6a 72                	push   $0x72
  jmp alltraps
80106a7d:	e9 f3 f6 ff ff       	jmp    80106175 <alltraps>

80106a82 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a82:	6a 00                	push   $0x0
  pushl $115
80106a84:	6a 73                	push   $0x73
  jmp alltraps
80106a86:	e9 ea f6 ff ff       	jmp    80106175 <alltraps>

80106a8b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $116
80106a8d:	6a 74                	push   $0x74
  jmp alltraps
80106a8f:	e9 e1 f6 ff ff       	jmp    80106175 <alltraps>

80106a94 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a94:	6a 00                	push   $0x0
  pushl $117
80106a96:	6a 75                	push   $0x75
  jmp alltraps
80106a98:	e9 d8 f6 ff ff       	jmp    80106175 <alltraps>

80106a9d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a9d:	6a 00                	push   $0x0
  pushl $118
80106a9f:	6a 76                	push   $0x76
  jmp alltraps
80106aa1:	e9 cf f6 ff ff       	jmp    80106175 <alltraps>

80106aa6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106aa6:	6a 00                	push   $0x0
  pushl $119
80106aa8:	6a 77                	push   $0x77
  jmp alltraps
80106aaa:	e9 c6 f6 ff ff       	jmp    80106175 <alltraps>

80106aaf <vector120>:
.globl vector120
vector120:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $120
80106ab1:	6a 78                	push   $0x78
  jmp alltraps
80106ab3:	e9 bd f6 ff ff       	jmp    80106175 <alltraps>

80106ab8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106ab8:	6a 00                	push   $0x0
  pushl $121
80106aba:	6a 79                	push   $0x79
  jmp alltraps
80106abc:	e9 b4 f6 ff ff       	jmp    80106175 <alltraps>

80106ac1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ac1:	6a 00                	push   $0x0
  pushl $122
80106ac3:	6a 7a                	push   $0x7a
  jmp alltraps
80106ac5:	e9 ab f6 ff ff       	jmp    80106175 <alltraps>

80106aca <vector123>:
.globl vector123
vector123:
  pushl $0
80106aca:	6a 00                	push   $0x0
  pushl $123
80106acc:	6a 7b                	push   $0x7b
  jmp alltraps
80106ace:	e9 a2 f6 ff ff       	jmp    80106175 <alltraps>

80106ad3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $124
80106ad5:	6a 7c                	push   $0x7c
  jmp alltraps
80106ad7:	e9 99 f6 ff ff       	jmp    80106175 <alltraps>

80106adc <vector125>:
.globl vector125
vector125:
  pushl $0
80106adc:	6a 00                	push   $0x0
  pushl $125
80106ade:	6a 7d                	push   $0x7d
  jmp alltraps
80106ae0:	e9 90 f6 ff ff       	jmp    80106175 <alltraps>

80106ae5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ae5:	6a 00                	push   $0x0
  pushl $126
80106ae7:	6a 7e                	push   $0x7e
  jmp alltraps
80106ae9:	e9 87 f6 ff ff       	jmp    80106175 <alltraps>

80106aee <vector127>:
.globl vector127
vector127:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $127
80106af0:	6a 7f                	push   $0x7f
  jmp alltraps
80106af2:	e9 7e f6 ff ff       	jmp    80106175 <alltraps>

80106af7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $128
80106af9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106afe:	e9 72 f6 ff ff       	jmp    80106175 <alltraps>

80106b03 <vector129>:
.globl vector129
vector129:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $129
80106b05:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106b0a:	e9 66 f6 ff ff       	jmp    80106175 <alltraps>

80106b0f <vector130>:
.globl vector130
vector130:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $130
80106b11:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b16:	e9 5a f6 ff ff       	jmp    80106175 <alltraps>

80106b1b <vector131>:
.globl vector131
vector131:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $131
80106b1d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b22:	e9 4e f6 ff ff       	jmp    80106175 <alltraps>

80106b27 <vector132>:
.globl vector132
vector132:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $132
80106b29:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b2e:	e9 42 f6 ff ff       	jmp    80106175 <alltraps>

80106b33 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $133
80106b35:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b3a:	e9 36 f6 ff ff       	jmp    80106175 <alltraps>

80106b3f <vector134>:
.globl vector134
vector134:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $134
80106b41:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b46:	e9 2a f6 ff ff       	jmp    80106175 <alltraps>

80106b4b <vector135>:
.globl vector135
vector135:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $135
80106b4d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b52:	e9 1e f6 ff ff       	jmp    80106175 <alltraps>

80106b57 <vector136>:
.globl vector136
vector136:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $136
80106b59:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b5e:	e9 12 f6 ff ff       	jmp    80106175 <alltraps>

80106b63 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $137
80106b65:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b6a:	e9 06 f6 ff ff       	jmp    80106175 <alltraps>

80106b6f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $138
80106b71:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b76:	e9 fa f5 ff ff       	jmp    80106175 <alltraps>

80106b7b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $139
80106b7d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b82:	e9 ee f5 ff ff       	jmp    80106175 <alltraps>

80106b87 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $140
80106b89:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b8e:	e9 e2 f5 ff ff       	jmp    80106175 <alltraps>

80106b93 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $141
80106b95:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b9a:	e9 d6 f5 ff ff       	jmp    80106175 <alltraps>

80106b9f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $142
80106ba1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106ba6:	e9 ca f5 ff ff       	jmp    80106175 <alltraps>

80106bab <vector143>:
.globl vector143
vector143:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $143
80106bad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106bb2:	e9 be f5 ff ff       	jmp    80106175 <alltraps>

80106bb7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $144
80106bb9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106bbe:	e9 b2 f5 ff ff       	jmp    80106175 <alltraps>

80106bc3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $145
80106bc5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106bca:	e9 a6 f5 ff ff       	jmp    80106175 <alltraps>

80106bcf <vector146>:
.globl vector146
vector146:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $146
80106bd1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106bd6:	e9 9a f5 ff ff       	jmp    80106175 <alltraps>

80106bdb <vector147>:
.globl vector147
vector147:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $147
80106bdd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106be2:	e9 8e f5 ff ff       	jmp    80106175 <alltraps>

80106be7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $148
80106be9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106bee:	e9 82 f5 ff ff       	jmp    80106175 <alltraps>

80106bf3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $149
80106bf5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106bfa:	e9 76 f5 ff ff       	jmp    80106175 <alltraps>

80106bff <vector150>:
.globl vector150
vector150:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $150
80106c01:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106c06:	e9 6a f5 ff ff       	jmp    80106175 <alltraps>

80106c0b <vector151>:
.globl vector151
vector151:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $151
80106c0d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c12:	e9 5e f5 ff ff       	jmp    80106175 <alltraps>

80106c17 <vector152>:
.globl vector152
vector152:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $152
80106c19:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c1e:	e9 52 f5 ff ff       	jmp    80106175 <alltraps>

80106c23 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $153
80106c25:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c2a:	e9 46 f5 ff ff       	jmp    80106175 <alltraps>

80106c2f <vector154>:
.globl vector154
vector154:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $154
80106c31:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c36:	e9 3a f5 ff ff       	jmp    80106175 <alltraps>

80106c3b <vector155>:
.globl vector155
vector155:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $155
80106c3d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c42:	e9 2e f5 ff ff       	jmp    80106175 <alltraps>

80106c47 <vector156>:
.globl vector156
vector156:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $156
80106c49:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c4e:	e9 22 f5 ff ff       	jmp    80106175 <alltraps>

80106c53 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $157
80106c55:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c5a:	e9 16 f5 ff ff       	jmp    80106175 <alltraps>

80106c5f <vector158>:
.globl vector158
vector158:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $158
80106c61:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c66:	e9 0a f5 ff ff       	jmp    80106175 <alltraps>

80106c6b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $159
80106c6d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c72:	e9 fe f4 ff ff       	jmp    80106175 <alltraps>

80106c77 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $160
80106c79:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c7e:	e9 f2 f4 ff ff       	jmp    80106175 <alltraps>

80106c83 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $161
80106c85:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c8a:	e9 e6 f4 ff ff       	jmp    80106175 <alltraps>

80106c8f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $162
80106c91:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c96:	e9 da f4 ff ff       	jmp    80106175 <alltraps>

80106c9b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $163
80106c9d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ca2:	e9 ce f4 ff ff       	jmp    80106175 <alltraps>

80106ca7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $164
80106ca9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106cae:	e9 c2 f4 ff ff       	jmp    80106175 <alltraps>

80106cb3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $165
80106cb5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106cba:	e9 b6 f4 ff ff       	jmp    80106175 <alltraps>

80106cbf <vector166>:
.globl vector166
vector166:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $166
80106cc1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106cc6:	e9 aa f4 ff ff       	jmp    80106175 <alltraps>

80106ccb <vector167>:
.globl vector167
vector167:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $167
80106ccd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106cd2:	e9 9e f4 ff ff       	jmp    80106175 <alltraps>

80106cd7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $168
80106cd9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106cde:	e9 92 f4 ff ff       	jmp    80106175 <alltraps>

80106ce3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $169
80106ce5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106cea:	e9 86 f4 ff ff       	jmp    80106175 <alltraps>

80106cef <vector170>:
.globl vector170
vector170:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $170
80106cf1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106cf6:	e9 7a f4 ff ff       	jmp    80106175 <alltraps>

80106cfb <vector171>:
.globl vector171
vector171:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $171
80106cfd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106d02:	e9 6e f4 ff ff       	jmp    80106175 <alltraps>

80106d07 <vector172>:
.globl vector172
vector172:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $172
80106d09:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106d0e:	e9 62 f4 ff ff       	jmp    80106175 <alltraps>

80106d13 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $173
80106d15:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d1a:	e9 56 f4 ff ff       	jmp    80106175 <alltraps>

80106d1f <vector174>:
.globl vector174
vector174:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $174
80106d21:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d26:	e9 4a f4 ff ff       	jmp    80106175 <alltraps>

80106d2b <vector175>:
.globl vector175
vector175:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $175
80106d2d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d32:	e9 3e f4 ff ff       	jmp    80106175 <alltraps>

80106d37 <vector176>:
.globl vector176
vector176:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $176
80106d39:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d3e:	e9 32 f4 ff ff       	jmp    80106175 <alltraps>

80106d43 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $177
80106d45:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d4a:	e9 26 f4 ff ff       	jmp    80106175 <alltraps>

80106d4f <vector178>:
.globl vector178
vector178:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $178
80106d51:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d56:	e9 1a f4 ff ff       	jmp    80106175 <alltraps>

80106d5b <vector179>:
.globl vector179
vector179:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $179
80106d5d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d62:	e9 0e f4 ff ff       	jmp    80106175 <alltraps>

80106d67 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $180
80106d69:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d6e:	e9 02 f4 ff ff       	jmp    80106175 <alltraps>

80106d73 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $181
80106d75:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d7a:	e9 f6 f3 ff ff       	jmp    80106175 <alltraps>

80106d7f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $182
80106d81:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d86:	e9 ea f3 ff ff       	jmp    80106175 <alltraps>

80106d8b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $183
80106d8d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d92:	e9 de f3 ff ff       	jmp    80106175 <alltraps>

80106d97 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $184
80106d99:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d9e:	e9 d2 f3 ff ff       	jmp    80106175 <alltraps>

80106da3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $185
80106da5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106daa:	e9 c6 f3 ff ff       	jmp    80106175 <alltraps>

80106daf <vector186>:
.globl vector186
vector186:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $186
80106db1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106db6:	e9 ba f3 ff ff       	jmp    80106175 <alltraps>

80106dbb <vector187>:
.globl vector187
vector187:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $187
80106dbd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106dc2:	e9 ae f3 ff ff       	jmp    80106175 <alltraps>

80106dc7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $188
80106dc9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106dce:	e9 a2 f3 ff ff       	jmp    80106175 <alltraps>

80106dd3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $189
80106dd5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106dda:	e9 96 f3 ff ff       	jmp    80106175 <alltraps>

80106ddf <vector190>:
.globl vector190
vector190:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $190
80106de1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106de6:	e9 8a f3 ff ff       	jmp    80106175 <alltraps>

80106deb <vector191>:
.globl vector191
vector191:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $191
80106ded:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106df2:	e9 7e f3 ff ff       	jmp    80106175 <alltraps>

80106df7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $192
80106df9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106dfe:	e9 72 f3 ff ff       	jmp    80106175 <alltraps>

80106e03 <vector193>:
.globl vector193
vector193:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $193
80106e05:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106e0a:	e9 66 f3 ff ff       	jmp    80106175 <alltraps>

80106e0f <vector194>:
.globl vector194
vector194:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $194
80106e11:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e16:	e9 5a f3 ff ff       	jmp    80106175 <alltraps>

80106e1b <vector195>:
.globl vector195
vector195:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $195
80106e1d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e22:	e9 4e f3 ff ff       	jmp    80106175 <alltraps>

80106e27 <vector196>:
.globl vector196
vector196:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $196
80106e29:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e2e:	e9 42 f3 ff ff       	jmp    80106175 <alltraps>

80106e33 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $197
80106e35:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e3a:	e9 36 f3 ff ff       	jmp    80106175 <alltraps>

80106e3f <vector198>:
.globl vector198
vector198:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $198
80106e41:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e46:	e9 2a f3 ff ff       	jmp    80106175 <alltraps>

80106e4b <vector199>:
.globl vector199
vector199:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $199
80106e4d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e52:	e9 1e f3 ff ff       	jmp    80106175 <alltraps>

80106e57 <vector200>:
.globl vector200
vector200:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $200
80106e59:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e5e:	e9 12 f3 ff ff       	jmp    80106175 <alltraps>

80106e63 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $201
80106e65:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e6a:	e9 06 f3 ff ff       	jmp    80106175 <alltraps>

80106e6f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $202
80106e71:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e76:	e9 fa f2 ff ff       	jmp    80106175 <alltraps>

80106e7b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $203
80106e7d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e82:	e9 ee f2 ff ff       	jmp    80106175 <alltraps>

80106e87 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $204
80106e89:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e8e:	e9 e2 f2 ff ff       	jmp    80106175 <alltraps>

80106e93 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $205
80106e95:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e9a:	e9 d6 f2 ff ff       	jmp    80106175 <alltraps>

80106e9f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $206
80106ea1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ea6:	e9 ca f2 ff ff       	jmp    80106175 <alltraps>

80106eab <vector207>:
.globl vector207
vector207:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $207
80106ead:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106eb2:	e9 be f2 ff ff       	jmp    80106175 <alltraps>

80106eb7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $208
80106eb9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ebe:	e9 b2 f2 ff ff       	jmp    80106175 <alltraps>

80106ec3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $209
80106ec5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106eca:	e9 a6 f2 ff ff       	jmp    80106175 <alltraps>

80106ecf <vector210>:
.globl vector210
vector210:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $210
80106ed1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ed6:	e9 9a f2 ff ff       	jmp    80106175 <alltraps>

80106edb <vector211>:
.globl vector211
vector211:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $211
80106edd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ee2:	e9 8e f2 ff ff       	jmp    80106175 <alltraps>

80106ee7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $212
80106ee9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106eee:	e9 82 f2 ff ff       	jmp    80106175 <alltraps>

80106ef3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $213
80106ef5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106efa:	e9 76 f2 ff ff       	jmp    80106175 <alltraps>

80106eff <vector214>:
.globl vector214
vector214:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $214
80106f01:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106f06:	e9 6a f2 ff ff       	jmp    80106175 <alltraps>

80106f0b <vector215>:
.globl vector215
vector215:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $215
80106f0d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f12:	e9 5e f2 ff ff       	jmp    80106175 <alltraps>

80106f17 <vector216>:
.globl vector216
vector216:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $216
80106f19:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f1e:	e9 52 f2 ff ff       	jmp    80106175 <alltraps>

80106f23 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $217
80106f25:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f2a:	e9 46 f2 ff ff       	jmp    80106175 <alltraps>

80106f2f <vector218>:
.globl vector218
vector218:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $218
80106f31:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f36:	e9 3a f2 ff ff       	jmp    80106175 <alltraps>

80106f3b <vector219>:
.globl vector219
vector219:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $219
80106f3d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f42:	e9 2e f2 ff ff       	jmp    80106175 <alltraps>

80106f47 <vector220>:
.globl vector220
vector220:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $220
80106f49:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f4e:	e9 22 f2 ff ff       	jmp    80106175 <alltraps>

80106f53 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $221
80106f55:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f5a:	e9 16 f2 ff ff       	jmp    80106175 <alltraps>

80106f5f <vector222>:
.globl vector222
vector222:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $222
80106f61:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f66:	e9 0a f2 ff ff       	jmp    80106175 <alltraps>

80106f6b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $223
80106f6d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f72:	e9 fe f1 ff ff       	jmp    80106175 <alltraps>

80106f77 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $224
80106f79:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f7e:	e9 f2 f1 ff ff       	jmp    80106175 <alltraps>

80106f83 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $225
80106f85:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f8a:	e9 e6 f1 ff ff       	jmp    80106175 <alltraps>

80106f8f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $226
80106f91:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f96:	e9 da f1 ff ff       	jmp    80106175 <alltraps>

80106f9b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $227
80106f9d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106fa2:	e9 ce f1 ff ff       	jmp    80106175 <alltraps>

80106fa7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $228
80106fa9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106fae:	e9 c2 f1 ff ff       	jmp    80106175 <alltraps>

80106fb3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $229
80106fb5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106fba:	e9 b6 f1 ff ff       	jmp    80106175 <alltraps>

80106fbf <vector230>:
.globl vector230
vector230:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $230
80106fc1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106fc6:	e9 aa f1 ff ff       	jmp    80106175 <alltraps>

80106fcb <vector231>:
.globl vector231
vector231:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $231
80106fcd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106fd2:	e9 9e f1 ff ff       	jmp    80106175 <alltraps>

80106fd7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $232
80106fd9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106fde:	e9 92 f1 ff ff       	jmp    80106175 <alltraps>

80106fe3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $233
80106fe5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106fea:	e9 86 f1 ff ff       	jmp    80106175 <alltraps>

80106fef <vector234>:
.globl vector234
vector234:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $234
80106ff1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ff6:	e9 7a f1 ff ff       	jmp    80106175 <alltraps>

80106ffb <vector235>:
.globl vector235
vector235:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $235
80106ffd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107002:	e9 6e f1 ff ff       	jmp    80106175 <alltraps>

80107007 <vector236>:
.globl vector236
vector236:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $236
80107009:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010700e:	e9 62 f1 ff ff       	jmp    80106175 <alltraps>

80107013 <vector237>:
.globl vector237
vector237:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $237
80107015:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010701a:	e9 56 f1 ff ff       	jmp    80106175 <alltraps>

8010701f <vector238>:
.globl vector238
vector238:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $238
80107021:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107026:	e9 4a f1 ff ff       	jmp    80106175 <alltraps>

8010702b <vector239>:
.globl vector239
vector239:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $239
8010702d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107032:	e9 3e f1 ff ff       	jmp    80106175 <alltraps>

80107037 <vector240>:
.globl vector240
vector240:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $240
80107039:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010703e:	e9 32 f1 ff ff       	jmp    80106175 <alltraps>

80107043 <vector241>:
.globl vector241
vector241:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $241
80107045:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010704a:	e9 26 f1 ff ff       	jmp    80106175 <alltraps>

8010704f <vector242>:
.globl vector242
vector242:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $242
80107051:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107056:	e9 1a f1 ff ff       	jmp    80106175 <alltraps>

8010705b <vector243>:
.globl vector243
vector243:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $243
8010705d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107062:	e9 0e f1 ff ff       	jmp    80106175 <alltraps>

80107067 <vector244>:
.globl vector244
vector244:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $244
80107069:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010706e:	e9 02 f1 ff ff       	jmp    80106175 <alltraps>

80107073 <vector245>:
.globl vector245
vector245:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $245
80107075:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010707a:	e9 f6 f0 ff ff       	jmp    80106175 <alltraps>

8010707f <vector246>:
.globl vector246
vector246:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $246
80107081:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107086:	e9 ea f0 ff ff       	jmp    80106175 <alltraps>

8010708b <vector247>:
.globl vector247
vector247:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $247
8010708d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107092:	e9 de f0 ff ff       	jmp    80106175 <alltraps>

80107097 <vector248>:
.globl vector248
vector248:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $248
80107099:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010709e:	e9 d2 f0 ff ff       	jmp    80106175 <alltraps>

801070a3 <vector249>:
.globl vector249
vector249:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $249
801070a5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801070aa:	e9 c6 f0 ff ff       	jmp    80106175 <alltraps>

801070af <vector250>:
.globl vector250
vector250:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $250
801070b1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801070b6:	e9 ba f0 ff ff       	jmp    80106175 <alltraps>

801070bb <vector251>:
.globl vector251
vector251:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $251
801070bd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801070c2:	e9 ae f0 ff ff       	jmp    80106175 <alltraps>

801070c7 <vector252>:
.globl vector252
vector252:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $252
801070c9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801070ce:	e9 a2 f0 ff ff       	jmp    80106175 <alltraps>

801070d3 <vector253>:
.globl vector253
vector253:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $253
801070d5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801070da:	e9 96 f0 ff ff       	jmp    80106175 <alltraps>

801070df <vector254>:
.globl vector254
vector254:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $254
801070e1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801070e6:	e9 8a f0 ff ff       	jmp    80106175 <alltraps>

801070eb <vector255>:
.globl vector255
vector255:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $255
801070ed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801070f2:	e9 7e f0 ff ff       	jmp    80106175 <alltraps>
801070f7:	66 90                	xchg   %ax,%ax
801070f9:	66 90                	xchg   %ax,%ax
801070fb:	66 90                	xchg   %ax,%ax
801070fd:	66 90                	xchg   %ax,%ax
801070ff:	90                   	nop

80107100 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107106:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010710c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107112:	83 ec 1c             	sub    $0x1c,%esp
80107115:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107118:	39 d3                	cmp    %edx,%ebx
8010711a:	73 49                	jae    80107165 <deallocuvm.part.0+0x65>
8010711c:	89 c7                	mov    %eax,%edi
8010711e:	eb 0c                	jmp    8010712c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107120:	83 c0 01             	add    $0x1,%eax
80107123:	c1 e0 16             	shl    $0x16,%eax
80107126:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107128:	39 da                	cmp    %ebx,%edx
8010712a:	76 39                	jbe    80107165 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010712c:	89 d8                	mov    %ebx,%eax
8010712e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107131:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107134:	f6 c1 01             	test   $0x1,%cl
80107137:	74 e7                	je     80107120 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107139:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010713b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107141:	c1 ee 0a             	shr    $0xa,%esi
80107144:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010714a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107151:	85 f6                	test   %esi,%esi
80107153:	74 cb                	je     80107120 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107155:	8b 06                	mov    (%esi),%eax
80107157:	a8 01                	test   $0x1,%al
80107159:	75 15                	jne    80107170 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010715b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107161:	39 da                	cmp    %ebx,%edx
80107163:	77 c7                	ja     8010712c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107165:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107168:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010716b:	5b                   	pop    %ebx
8010716c:	5e                   	pop    %esi
8010716d:	5f                   	pop    %edi
8010716e:	5d                   	pop    %ebp
8010716f:	c3                   	ret    
      if(pa == 0)
80107170:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107175:	74 25                	je     8010719c <deallocuvm.part.0+0x9c>
      kfree(v);
80107177:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010717a:	05 00 00 00 80       	add    $0x80000000,%eax
8010717f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107182:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107188:	50                   	push   %eax
80107189:	e8 a2 b3 ff ff       	call   80102530 <kfree>
      *pte = 0;
8010718e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107197:	83 c4 10             	add    $0x10,%esp
8010719a:	eb 8c                	jmp    80107128 <deallocuvm.part.0+0x28>
        panic("kfree");
8010719c:	83 ec 0c             	sub    $0xc,%esp
8010719f:	68 e6 7d 10 80       	push   $0x80107de6
801071a4:	e8 d7 91 ff ff       	call   80100380 <panic>
801071a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071b0 <mappages>:
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801071b6:	89 d3                	mov    %edx,%ebx
801071b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801071be:	83 ec 1c             	sub    $0x1c,%esp
801071c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071c4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801071c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801071d0:	8b 45 08             	mov    0x8(%ebp),%eax
801071d3:	29 d8                	sub    %ebx,%eax
801071d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071d8:	eb 3d                	jmp    80107217 <mappages+0x67>
801071da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801071e0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801071e7:	c1 ea 0a             	shr    $0xa,%edx
801071ea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071f0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071f7:	85 c0                	test   %eax,%eax
801071f9:	74 75                	je     80107270 <mappages+0xc0>
    if(*pte & PTE_P)
801071fb:	f6 00 01             	testb  $0x1,(%eax)
801071fe:	0f 85 86 00 00 00    	jne    8010728a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107204:	0b 75 0c             	or     0xc(%ebp),%esi
80107207:	83 ce 01             	or     $0x1,%esi
8010720a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010720c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010720f:	74 6f                	je     80107280 <mappages+0xd0>
    a += PGSIZE;
80107211:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107217:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010721a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010721d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107220:	89 d8                	mov    %ebx,%eax
80107222:	c1 e8 16             	shr    $0x16,%eax
80107225:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107228:	8b 07                	mov    (%edi),%eax
8010722a:	a8 01                	test   $0x1,%al
8010722c:	75 b2                	jne    801071e0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010722e:	e8 3d b5 ff ff       	call   80102770 <kalloc>
80107233:	85 c0                	test   %eax,%eax
80107235:	74 39                	je     80107270 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107237:	83 ec 04             	sub    $0x4,%esp
8010723a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010723d:	68 00 10 00 00       	push   $0x1000
80107242:	6a 00                	push   $0x0
80107244:	50                   	push   %eax
80107245:	e8 86 db ff ff       	call   80104dd0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010724a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010724d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107250:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107256:	83 c8 07             	or     $0x7,%eax
80107259:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010725b:	89 d8                	mov    %ebx,%eax
8010725d:	c1 e8 0a             	shr    $0xa,%eax
80107260:	25 fc 0f 00 00       	and    $0xffc,%eax
80107265:	01 d0                	add    %edx,%eax
80107267:	eb 92                	jmp    801071fb <mappages+0x4b>
80107269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107270:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107273:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107278:	5b                   	pop    %ebx
80107279:	5e                   	pop    %esi
8010727a:	5f                   	pop    %edi
8010727b:	5d                   	pop    %ebp
8010727c:	c3                   	ret    
8010727d:	8d 76 00             	lea    0x0(%esi),%esi
80107280:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107283:	31 c0                	xor    %eax,%eax
}
80107285:	5b                   	pop    %ebx
80107286:	5e                   	pop    %esi
80107287:	5f                   	pop    %edi
80107288:	5d                   	pop    %ebp
80107289:	c3                   	ret    
      panic("remap");
8010728a:	83 ec 0c             	sub    $0xc,%esp
8010728d:	68 c4 84 10 80       	push   $0x801084c4
80107292:	e8 e9 90 ff ff       	call   80100380 <panic>
80107297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729e:	66 90                	xchg   %ax,%ax

801072a0 <seginit>:
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801072a6:	e8 d5 c7 ff ff       	call   80103a80 <cpuid>
  pd[0] = size-1;
801072ab:	ba 2f 00 00 00       	mov    $0x2f,%edx
801072b0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801072b6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801072ba:	c7 80 38 a8 14 80 ff 	movl   $0xffff,-0x7feb57c8(%eax)
801072c1:	ff 00 00 
801072c4:	c7 80 3c a8 14 80 00 	movl   $0xcf9a00,-0x7feb57c4(%eax)
801072cb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801072ce:	c7 80 40 a8 14 80 ff 	movl   $0xffff,-0x7feb57c0(%eax)
801072d5:	ff 00 00 
801072d8:	c7 80 44 a8 14 80 00 	movl   $0xcf9200,-0x7feb57bc(%eax)
801072df:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072e2:	c7 80 48 a8 14 80 ff 	movl   $0xffff,-0x7feb57b8(%eax)
801072e9:	ff 00 00 
801072ec:	c7 80 4c a8 14 80 00 	movl   $0xcffa00,-0x7feb57b4(%eax)
801072f3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072f6:	c7 80 50 a8 14 80 ff 	movl   $0xffff,-0x7feb57b0(%eax)
801072fd:	ff 00 00 
80107300:	c7 80 54 a8 14 80 00 	movl   $0xcff200,-0x7feb57ac(%eax)
80107307:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010730a:	05 30 a8 14 80       	add    $0x8014a830,%eax
  pd[1] = (uint)p;
8010730f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107313:	c1 e8 10             	shr    $0x10,%eax
80107316:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010731a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010731d:	0f 01 10             	lgdtl  (%eax)
}
80107320:	c9                   	leave  
80107321:	c3                   	ret    
80107322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107330 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107330:	a1 e4 d6 14 80       	mov    0x8014d6e4,%eax
80107335:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010733a:	0f 22 d8             	mov    %eax,%cr3
}
8010733d:	c3                   	ret    
8010733e:	66 90                	xchg   %ax,%ax

80107340 <switchuvm>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	83 ec 1c             	sub    $0x1c,%esp
80107349:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010734c:	85 f6                	test   %esi,%esi
8010734e:	0f 84 cb 00 00 00    	je     8010741f <switchuvm+0xdf>
  if(p->kstack == 0)
80107354:	8b 46 08             	mov    0x8(%esi),%eax
80107357:	85 c0                	test   %eax,%eax
80107359:	0f 84 da 00 00 00    	je     80107439 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010735f:	8b 46 04             	mov    0x4(%esi),%eax
80107362:	85 c0                	test   %eax,%eax
80107364:	0f 84 c2 00 00 00    	je     8010742c <switchuvm+0xec>
  pushcli();
8010736a:	e8 51 d8 ff ff       	call   80104bc0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010736f:	e8 ac c6 ff ff       	call   80103a20 <mycpu>
80107374:	89 c3                	mov    %eax,%ebx
80107376:	e8 a5 c6 ff ff       	call   80103a20 <mycpu>
8010737b:	89 c7                	mov    %eax,%edi
8010737d:	e8 9e c6 ff ff       	call   80103a20 <mycpu>
80107382:	83 c7 08             	add    $0x8,%edi
80107385:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107388:	e8 93 c6 ff ff       	call   80103a20 <mycpu>
8010738d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107390:	ba 67 00 00 00       	mov    $0x67,%edx
80107395:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010739c:	83 c0 08             	add    $0x8,%eax
8010739f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073a6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801073ab:	83 c1 08             	add    $0x8,%ecx
801073ae:	c1 e8 18             	shr    $0x18,%eax
801073b1:	c1 e9 10             	shr    $0x10,%ecx
801073b4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801073ba:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801073c0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801073c5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073cc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801073d1:	e8 4a c6 ff ff       	call   80103a20 <mycpu>
801073d6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073dd:	e8 3e c6 ff ff       	call   80103a20 <mycpu>
801073e2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073e6:	8b 5e 08             	mov    0x8(%esi),%ebx
801073e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073ef:	e8 2c c6 ff ff       	call   80103a20 <mycpu>
801073f4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073f7:	e8 24 c6 ff ff       	call   80103a20 <mycpu>
801073fc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107400:	b8 28 00 00 00       	mov    $0x28,%eax
80107405:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107408:	8b 46 04             	mov    0x4(%esi),%eax
8010740b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107410:	0f 22 d8             	mov    %eax,%cr3
}
80107413:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107416:	5b                   	pop    %ebx
80107417:	5e                   	pop    %esi
80107418:	5f                   	pop    %edi
80107419:	5d                   	pop    %ebp
  popcli();
8010741a:	e9 f1 d7 ff ff       	jmp    80104c10 <popcli>
    panic("switchuvm: no process");
8010741f:	83 ec 0c             	sub    $0xc,%esp
80107422:	68 ca 84 10 80       	push   $0x801084ca
80107427:	e8 54 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010742c:	83 ec 0c             	sub    $0xc,%esp
8010742f:	68 f5 84 10 80       	push   $0x801084f5
80107434:	e8 47 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107439:	83 ec 0c             	sub    $0xc,%esp
8010743c:	68 e0 84 10 80       	push   $0x801084e0
80107441:	e8 3a 8f ff ff       	call   80100380 <panic>
80107446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010744d:	8d 76 00             	lea    0x0(%esi),%esi

80107450 <inituvm>:
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	57                   	push   %edi
80107454:	56                   	push   %esi
80107455:	53                   	push   %ebx
80107456:	83 ec 1c             	sub    $0x1c,%esp
80107459:	8b 45 0c             	mov    0xc(%ebp),%eax
8010745c:	8b 75 10             	mov    0x10(%ebp),%esi
8010745f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107462:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107465:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010746b:	77 4b                	ja     801074b8 <inituvm+0x68>
  mem = kalloc();
8010746d:	e8 fe b2 ff ff       	call   80102770 <kalloc>
  memset(mem, 0, PGSIZE);
80107472:	83 ec 04             	sub    $0x4,%esp
80107475:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010747a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010747c:	6a 00                	push   $0x0
8010747e:	50                   	push   %eax
8010747f:	e8 4c d9 ff ff       	call   80104dd0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107484:	58                   	pop    %eax
80107485:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010748b:	5a                   	pop    %edx
8010748c:	6a 06                	push   $0x6
8010748e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107493:	31 d2                	xor    %edx,%edx
80107495:	50                   	push   %eax
80107496:	89 f8                	mov    %edi,%eax
80107498:	e8 13 fd ff ff       	call   801071b0 <mappages>
  memmove(mem, init, sz);
8010749d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074a0:	89 75 10             	mov    %esi,0x10(%ebp)
801074a3:	83 c4 10             	add    $0x10,%esp
801074a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801074a9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801074ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074af:	5b                   	pop    %ebx
801074b0:	5e                   	pop    %esi
801074b1:	5f                   	pop    %edi
801074b2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801074b3:	e9 b8 d9 ff ff       	jmp    80104e70 <memmove>
    panic("inituvm: more than a page");
801074b8:	83 ec 0c             	sub    $0xc,%esp
801074bb:	68 09 85 10 80       	push   $0x80108509
801074c0:	e8 bb 8e ff ff       	call   80100380 <panic>
801074c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801074d0 <loaduvm>:
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	57                   	push   %edi
801074d4:	56                   	push   %esi
801074d5:	53                   	push   %ebx
801074d6:	83 ec 1c             	sub    $0x1c,%esp
801074d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801074dc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801074df:	a9 ff 0f 00 00       	test   $0xfff,%eax
801074e4:	0f 85 bb 00 00 00    	jne    801075a5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801074ea:	01 f0                	add    %esi,%eax
801074ec:	89 f3                	mov    %esi,%ebx
801074ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074f1:	8b 45 14             	mov    0x14(%ebp),%eax
801074f4:	01 f0                	add    %esi,%eax
801074f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801074f9:	85 f6                	test   %esi,%esi
801074fb:	0f 84 87 00 00 00    	je     80107588 <loaduvm+0xb8>
80107501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010750b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010750e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107510:	89 c2                	mov    %eax,%edx
80107512:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107515:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107518:	f6 c2 01             	test   $0x1,%dl
8010751b:	75 13                	jne    80107530 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010751d:	83 ec 0c             	sub    $0xc,%esp
80107520:	68 23 85 10 80       	push   $0x80108523
80107525:	e8 56 8e ff ff       	call   80100380 <panic>
8010752a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107530:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107533:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107539:	25 fc 0f 00 00       	and    $0xffc,%eax
8010753e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107545:	85 c0                	test   %eax,%eax
80107547:	74 d4                	je     8010751d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107549:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010754b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010754e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107553:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107558:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010755e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107561:	29 d9                	sub    %ebx,%ecx
80107563:	05 00 00 00 80       	add    $0x80000000,%eax
80107568:	57                   	push   %edi
80107569:	51                   	push   %ecx
8010756a:	50                   	push   %eax
8010756b:	ff 75 10             	push   0x10(%ebp)
8010756e:	e8 1d a5 ff ff       	call   80101a90 <readi>
80107573:	83 c4 10             	add    $0x10,%esp
80107576:	39 f8                	cmp    %edi,%eax
80107578:	75 1e                	jne    80107598 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010757a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107580:	89 f0                	mov    %esi,%eax
80107582:	29 d8                	sub    %ebx,%eax
80107584:	39 c6                	cmp    %eax,%esi
80107586:	77 80                	ja     80107508 <loaduvm+0x38>
}
80107588:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010758b:	31 c0                	xor    %eax,%eax
}
8010758d:	5b                   	pop    %ebx
8010758e:	5e                   	pop    %esi
8010758f:	5f                   	pop    %edi
80107590:	5d                   	pop    %ebp
80107591:	c3                   	ret    
80107592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107598:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010759b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075a0:	5b                   	pop    %ebx
801075a1:	5e                   	pop    %esi
801075a2:	5f                   	pop    %edi
801075a3:	5d                   	pop    %ebp
801075a4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801075a5:	83 ec 0c             	sub    $0xc,%esp
801075a8:	68 c4 85 10 80       	push   $0x801085c4
801075ad:	e8 ce 8d ff ff       	call   80100380 <panic>
801075b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075c0 <allocuvm>:
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	57                   	push   %edi
801075c4:	56                   	push   %esi
801075c5:	53                   	push   %ebx
801075c6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801075c9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801075cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801075cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075d2:	85 c0                	test   %eax,%eax
801075d4:	0f 88 b6 00 00 00    	js     80107690 <allocuvm+0xd0>
  if(newsz < oldsz)
801075da:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801075dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801075e0:	0f 82 9a 00 00 00    	jb     80107680 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801075e6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075ec:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801075f2:	39 75 10             	cmp    %esi,0x10(%ebp)
801075f5:	77 44                	ja     8010763b <allocuvm+0x7b>
801075f7:	e9 87 00 00 00       	jmp    80107683 <allocuvm+0xc3>
801075fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107600:	83 ec 04             	sub    $0x4,%esp
80107603:	68 00 10 00 00       	push   $0x1000
80107608:	6a 00                	push   $0x0
8010760a:	50                   	push   %eax
8010760b:	e8 c0 d7 ff ff       	call   80104dd0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107610:	58                   	pop    %eax
80107611:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107617:	5a                   	pop    %edx
80107618:	6a 06                	push   $0x6
8010761a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010761f:	89 f2                	mov    %esi,%edx
80107621:	50                   	push   %eax
80107622:	89 f8                	mov    %edi,%eax
80107624:	e8 87 fb ff ff       	call   801071b0 <mappages>
80107629:	83 c4 10             	add    $0x10,%esp
8010762c:	85 c0                	test   %eax,%eax
8010762e:	78 78                	js     801076a8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107630:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107636:	39 75 10             	cmp    %esi,0x10(%ebp)
80107639:	76 48                	jbe    80107683 <allocuvm+0xc3>
    mem = kalloc();
8010763b:	e8 30 b1 ff ff       	call   80102770 <kalloc>
80107640:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107642:	85 c0                	test   %eax,%eax
80107644:	75 ba                	jne    80107600 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107646:	83 ec 0c             	sub    $0xc,%esp
80107649:	68 41 85 10 80       	push   $0x80108541
8010764e:	e8 4d 90 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107653:	8b 45 0c             	mov    0xc(%ebp),%eax
80107656:	83 c4 10             	add    $0x10,%esp
80107659:	39 45 10             	cmp    %eax,0x10(%ebp)
8010765c:	74 32                	je     80107690 <allocuvm+0xd0>
8010765e:	8b 55 10             	mov    0x10(%ebp),%edx
80107661:	89 c1                	mov    %eax,%ecx
80107663:	89 f8                	mov    %edi,%eax
80107665:	e8 96 fa ff ff       	call   80107100 <deallocuvm.part.0>
      return 0;
8010766a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107674:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107677:	5b                   	pop    %ebx
80107678:	5e                   	pop    %esi
80107679:	5f                   	pop    %edi
8010767a:	5d                   	pop    %ebp
8010767b:	c3                   	ret    
8010767c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107680:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107686:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107689:	5b                   	pop    %ebx
8010768a:	5e                   	pop    %esi
8010768b:	5f                   	pop    %edi
8010768c:	5d                   	pop    %ebp
8010768d:	c3                   	ret    
8010768e:	66 90                	xchg   %ax,%ax
    return 0;
80107690:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010769a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010769d:	5b                   	pop    %ebx
8010769e:	5e                   	pop    %esi
8010769f:	5f                   	pop    %edi
801076a0:	5d                   	pop    %ebp
801076a1:	c3                   	ret    
801076a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801076a8:	83 ec 0c             	sub    $0xc,%esp
801076ab:	68 59 85 10 80       	push   $0x80108559
801076b0:	e8 eb 8f ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801076b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801076b8:	83 c4 10             	add    $0x10,%esp
801076bb:	39 45 10             	cmp    %eax,0x10(%ebp)
801076be:	74 0c                	je     801076cc <allocuvm+0x10c>
801076c0:	8b 55 10             	mov    0x10(%ebp),%edx
801076c3:	89 c1                	mov    %eax,%ecx
801076c5:	89 f8                	mov    %edi,%eax
801076c7:	e8 34 fa ff ff       	call   80107100 <deallocuvm.part.0>
      kfree(mem);
801076cc:	83 ec 0c             	sub    $0xc,%esp
801076cf:	53                   	push   %ebx
801076d0:	e8 5b ae ff ff       	call   80102530 <kfree>
      return 0;
801076d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801076dc:	83 c4 10             	add    $0x10,%esp
}
801076df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076e5:	5b                   	pop    %ebx
801076e6:	5e                   	pop    %esi
801076e7:	5f                   	pop    %edi
801076e8:	5d                   	pop    %ebp
801076e9:	c3                   	ret    
801076ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076f0 <deallocuvm>:
{
801076f0:	55                   	push   %ebp
801076f1:	89 e5                	mov    %esp,%ebp
801076f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801076f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801076f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801076fc:	39 d1                	cmp    %edx,%ecx
801076fe:	73 10                	jae    80107710 <deallocuvm+0x20>
}
80107700:	5d                   	pop    %ebp
80107701:	e9 fa f9 ff ff       	jmp    80107100 <deallocuvm.part.0>
80107706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770d:	8d 76 00             	lea    0x0(%esi),%esi
80107710:	89 d0                	mov    %edx,%eax
80107712:	5d                   	pop    %ebp
80107713:	c3                   	ret    
80107714:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010771b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010771f:	90                   	nop

80107720 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	57                   	push   %edi
80107724:	56                   	push   %esi
80107725:	53                   	push   %ebx
80107726:	83 ec 0c             	sub    $0xc,%esp
80107729:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010772c:	85 f6                	test   %esi,%esi
8010772e:	74 59                	je     80107789 <freevm+0x69>
  if(newsz >= oldsz)
80107730:	31 c9                	xor    %ecx,%ecx
80107732:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107737:	89 f0                	mov    %esi,%eax
80107739:	89 f3                	mov    %esi,%ebx
8010773b:	e8 c0 f9 ff ff       	call   80107100 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107740:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107746:	eb 0f                	jmp    80107757 <freevm+0x37>
80107748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010774f:	90                   	nop
80107750:	83 c3 04             	add    $0x4,%ebx
80107753:	39 df                	cmp    %ebx,%edi
80107755:	74 23                	je     8010777a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107757:	8b 03                	mov    (%ebx),%eax
80107759:	a8 01                	test   $0x1,%al
8010775b:	74 f3                	je     80107750 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010775d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107762:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107765:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107768:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010776d:	50                   	push   %eax
8010776e:	e8 bd ad ff ff       	call   80102530 <kfree>
80107773:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107776:	39 df                	cmp    %ebx,%edi
80107778:	75 dd                	jne    80107757 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010777a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010777d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107780:	5b                   	pop    %ebx
80107781:	5e                   	pop    %esi
80107782:	5f                   	pop    %edi
80107783:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107784:	e9 a7 ad ff ff       	jmp    80102530 <kfree>
    panic("freevm: no pgdir");
80107789:	83 ec 0c             	sub    $0xc,%esp
8010778c:	68 75 85 10 80       	push   $0x80108575
80107791:	e8 ea 8b ff ff       	call   80100380 <panic>
80107796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010779d:	8d 76 00             	lea    0x0(%esi),%esi

801077a0 <setupkvm>:
{
801077a0:	55                   	push   %ebp
801077a1:	89 e5                	mov    %esp,%ebp
801077a3:	56                   	push   %esi
801077a4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801077a5:	e8 c6 af ff ff       	call   80102770 <kalloc>
801077aa:	89 c6                	mov    %eax,%esi
801077ac:	85 c0                	test   %eax,%eax
801077ae:	74 42                	je     801077f2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801077b0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077b3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801077b8:	68 00 10 00 00       	push   $0x1000
801077bd:	6a 00                	push   $0x0
801077bf:	50                   	push   %eax
801077c0:	e8 0b d6 ff ff       	call   80104dd0 <memset>
801077c5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801077c8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077cb:	83 ec 08             	sub    $0x8,%esp
801077ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801077d1:	ff 73 0c             	push   0xc(%ebx)
801077d4:	8b 13                	mov    (%ebx),%edx
801077d6:	50                   	push   %eax
801077d7:	29 c1                	sub    %eax,%ecx
801077d9:	89 f0                	mov    %esi,%eax
801077db:	e8 d0 f9 ff ff       	call   801071b0 <mappages>
801077e0:	83 c4 10             	add    $0x10,%esp
801077e3:	85 c0                	test   %eax,%eax
801077e5:	78 19                	js     80107800 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077e7:	83 c3 10             	add    $0x10,%ebx
801077ea:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801077f0:	75 d6                	jne    801077c8 <setupkvm+0x28>
}
801077f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077f5:	89 f0                	mov    %esi,%eax
801077f7:	5b                   	pop    %ebx
801077f8:	5e                   	pop    %esi
801077f9:	5d                   	pop    %ebp
801077fa:	c3                   	ret    
801077fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077ff:	90                   	nop
      freevm(pgdir);
80107800:	83 ec 0c             	sub    $0xc,%esp
80107803:	56                   	push   %esi
      return 0;
80107804:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107806:	e8 15 ff ff ff       	call   80107720 <freevm>
      return 0;
8010780b:	83 c4 10             	add    $0x10,%esp
}
8010780e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107811:	89 f0                	mov    %esi,%eax
80107813:	5b                   	pop    %ebx
80107814:	5e                   	pop    %esi
80107815:	5d                   	pop    %ebp
80107816:	c3                   	ret    
80107817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010781e:	66 90                	xchg   %ax,%ax

80107820 <kvmalloc>:
{
80107820:	55                   	push   %ebp
80107821:	89 e5                	mov    %esp,%ebp
80107823:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107826:	e8 75 ff ff ff       	call   801077a0 <setupkvm>
8010782b:	a3 e4 d6 14 80       	mov    %eax,0x8014d6e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107830:	05 00 00 00 80       	add    $0x80000000,%eax
80107835:	0f 22 d8             	mov    %eax,%cr3
}
80107838:	c9                   	leave  
80107839:	c3                   	ret    
8010783a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107840 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107840:	55                   	push   %ebp
80107841:	89 e5                	mov    %esp,%ebp
80107843:	83 ec 08             	sub    $0x8,%esp
80107846:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107849:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010784c:	89 c1                	mov    %eax,%ecx
8010784e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107851:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107854:	f6 c2 01             	test   $0x1,%dl
80107857:	75 17                	jne    80107870 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107859:	83 ec 0c             	sub    $0xc,%esp
8010785c:	68 86 85 10 80       	push   $0x80108586
80107861:	e8 1a 8b ff ff       	call   80100380 <panic>
80107866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010786d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107870:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107873:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107879:	25 fc 0f 00 00       	and    $0xffc,%eax
8010787e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107885:	85 c0                	test   %eax,%eax
80107887:	74 d0                	je     80107859 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107889:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010788c:	c9                   	leave  
8010788d:	c3                   	ret    
8010788e:	66 90                	xchg   %ax,%ax

80107890 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	57                   	push   %edi
80107894:	56                   	push   %esi
80107895:	53                   	push   %ebx
80107896:	83 ec 0c             	sub    $0xc,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
80107899:	e8 02 ff ff ff       	call   801077a0 <setupkvm>
8010789e:	89 c6                	mov    %eax,%esi
801078a0:	85 c0                	test   %eax,%eax
801078a2:	0f 84 a6 00 00 00    	je     8010794e <copyuvm+0xbe>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801078a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801078ab:	85 c0                	test   %eax,%eax
801078ad:	0f 84 8f 00 00 00    	je     80107942 <copyuvm+0xb2>
801078b3:	31 ff                	xor    %edi,%edi
801078b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801078b8:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801078bb:	89 f8                	mov    %edi,%eax
801078bd:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801078c0:	8b 04 82             	mov    (%edx,%eax,4),%eax
801078c3:	a8 01                	test   $0x1,%al
801078c5:	75 11                	jne    801078d8 <copyuvm+0x48>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801078c7:	83 ec 0c             	sub    $0xc,%esp
801078ca:	68 90 85 10 80       	push   $0x80108590
801078cf:	e8 ac 8a ff ff       	call   80100380 <panic>
801078d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801078d8:	89 f9                	mov    %edi,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801078df:	c1 e9 0a             	shr    $0xa,%ecx
801078e2:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801078e8:	8d 8c 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%ecx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801078ef:	85 c9                	test   %ecx,%ecx
801078f1:	74 d4                	je     801078c7 <copyuvm+0x37>
    if(!(*pte & PTE_P))
801078f3:	8b 01                	mov    (%ecx),%eax
801078f5:	a8 01                	test   $0x1,%al
801078f7:	74 7f                	je     80107978 <copyuvm+0xe8>
      panic("copyuvm: page not present");
    
    *pte &= (~PTE_W); //20181295
801078f9:	89 c3                	mov    %eax,%ebx
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) //20181295 change V2P(mem) to V2P(pa)
801078fb:	83 ec 08             	sub    $0x8,%esp
801078fe:	89 fa                	mov    %edi,%edx
    *pte &= (~PTE_W); //20181295
80107900:	83 e3 fd             	and    $0xfffffffd,%ebx
80107903:	89 19                	mov    %ebx,(%ecx)
    pa = PTE_ADDR(*pte);
80107905:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107907:	25 fd 0f 00 00       	and    $0xffd,%eax
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) //20181295 change V2P(mem) to V2P(pa)
8010790c:	b9 00 10 00 00       	mov    $0x1000,%ecx
    pa = PTE_ADDR(*pte);
80107911:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) //20181295 change V2P(mem) to V2P(pa)
80107917:	50                   	push   %eax
80107918:	89 f0                	mov    %esi,%eax
8010791a:	53                   	push   %ebx
8010791b:	e8 90 f8 ff ff       	call   801071b0 <mappages>
80107920:	83 c4 10             	add    $0x10,%esp
80107923:	85 c0                	test   %eax,%eax
80107925:	78 39                	js     80107960 <copyuvm+0xd0>
      goto bad;
    inc_refcount(pa); //20181295
80107927:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < sz; i += PGSIZE){
8010792a:	81 c7 00 10 00 00    	add    $0x1000,%edi
    inc_refcount(pa); //20181295
80107930:	53                   	push   %ebx
80107931:	e8 aa ab ff ff       	call   801024e0 <inc_refcount>
  for(i = 0; i < sz; i += PGSIZE){
80107936:	83 c4 10             	add    $0x10,%esp
80107939:	39 7d 0c             	cmp    %edi,0xc(%ebp)
8010793c:	0f 87 76 ff ff ff    	ja     801078b8 <copyuvm+0x28>
  }
  lcr3(V2P(pgdir)); //20181295
80107942:	8b 45 08             	mov    0x8(%ebp),%eax
80107945:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
8010794b:	0f 22 df             	mov    %edi,%cr3
  return d;

bad:
  freevm(d);
  return 0;
}
8010794e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107951:	89 f0                	mov    %esi,%eax
80107953:	5b                   	pop    %ebx
80107954:	5e                   	pop    %esi
80107955:	5f                   	pop    %edi
80107956:	5d                   	pop    %ebp
80107957:	c3                   	ret    
80107958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010795f:	90                   	nop
  freevm(d);
80107960:	83 ec 0c             	sub    $0xc,%esp
80107963:	56                   	push   %esi
  return 0;
80107964:	31 f6                	xor    %esi,%esi
  freevm(d);
80107966:	e8 b5 fd ff ff       	call   80107720 <freevm>
  return 0;
8010796b:	83 c4 10             	add    $0x10,%esp
}
8010796e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107971:	89 f0                	mov    %esi,%eax
80107973:	5b                   	pop    %ebx
80107974:	5e                   	pop    %esi
80107975:	5f                   	pop    %edi
80107976:	5d                   	pop    %ebp
80107977:	c3                   	ret    
      panic("copyuvm: page not present");
80107978:	83 ec 0c             	sub    $0xc,%esp
8010797b:	68 aa 85 10 80       	push   $0x801085aa
80107980:	e8 fb 89 ff ff       	call   80100380 <panic>
80107985:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010798c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107990 <pagefault>:

//20181295 pagefault handler
void 
pagefault(void)
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	57                   	push   %edi
80107994:	56                   	push   %esi
80107995:	53                   	push   %ebx
80107996:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107999:	0f 20 d3             	mov    %cr2,%ebx
  uint rc, pa, va = rcr2(); //faulting virtual address
  if(va < 0){
    panic("Wrong VA pagefault");
    return;
  }
  pte = walkpgdir(myproc()->pgdir, (void*)va, 0);
8010799c:	e8 ff c0 ff ff       	call   80103aa0 <myproc>
  pde = &pgdir[PDX(va)];
801079a1:	89 da                	mov    %ebx,%edx
  if(*pde & PTE_P){
801079a3:	8b 40 04             	mov    0x4(%eax),%eax
  pde = &pgdir[PDX(va)];
801079a6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801079a9:	8b 04 90             	mov    (%eax,%edx,4),%eax
801079ac:	a8 01                	test   $0x1,%al
801079ae:	0f 84 b6 01 00 00    	je     80107b6a <pagefault.cold>
  return &pgtab[PTX(va)];
801079b4:	c1 eb 0a             	shr    $0xa,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  pa = PTE_ADDR(*pte);
  rc = get_refcount(pa);
801079bc:	83 ec 0c             	sub    $0xc,%esp
  return &pgtab[PTX(va)];
801079bf:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
801079c5:	8d bc 18 00 00 00 80 	lea    -0x80000000(%eax,%ebx,1),%edi
  pa = PTE_ADDR(*pte);
801079cc:	8b 37                	mov    (%edi),%esi
801079ce:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  rc = get_refcount(pa);
801079d4:	56                   	push   %esi
801079d5:	e8 e6 aa ff ff       	call   801024c0 <get_refcount>

  if(rc > 1){
801079da:	83 c4 10             	add    $0x10,%esp
801079dd:	83 f8 01             	cmp    $0x1,%eax
801079e0:	77 1e                	ja     80107a00 <pagefault+0x70>
      return;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    *pte = V2P(mem) | PTE_P | PTE_U | PTE_W;
    dec_refcount(pa);
  }
  else if(rc == 1){
801079e2:	74 5c                	je     80107a40 <pagefault+0xb0>
    *pte |= PTE_W;
  }
  lcr3(V2P(myproc()->pgdir));
801079e4:	e8 b7 c0 ff ff       	call   80103aa0 <myproc>
801079e9:	8b 40 04             	mov    0x4(%eax),%eax
801079ec:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801079f1:	0f 22 d8             	mov    %eax,%cr3
}
801079f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079f7:	5b                   	pop    %ebx
801079f8:	5e                   	pop    %esi
801079f9:	5f                   	pop    %edi
801079fa:	5d                   	pop    %ebp
801079fb:	c3                   	ret    
801079fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((mem = kalloc()) == 0)
80107a00:	e8 6b ad ff ff       	call   80102770 <kalloc>
80107a05:	89 c3                	mov    %eax,%ebx
80107a07:	85 c0                	test   %eax,%eax
80107a09:	74 e9                	je     801079f4 <pagefault+0x64>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a0b:	83 ec 04             	sub    $0x4,%esp
80107a0e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107a14:	68 00 10 00 00       	push   $0x1000
80107a19:	50                   	push   %eax
80107a1a:	53                   	push   %ebx
    *pte = V2P(mem) | PTE_P | PTE_U | PTE_W;
80107a1b:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107a21:	83 cb 07             	or     $0x7,%ebx
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a24:	e8 47 d4 ff ff       	call   80104e70 <memmove>
    *pte = V2P(mem) | PTE_P | PTE_U | PTE_W;
80107a29:	89 1f                	mov    %ebx,(%edi)
    dec_refcount(pa);
80107a2b:	89 34 24             	mov    %esi,(%esp)
80107a2e:	e8 cd aa ff ff       	call   80102500 <dec_refcount>
80107a33:	83 c4 10             	add    $0x10,%esp
80107a36:	eb ac                	jmp    801079e4 <pagefault+0x54>
80107a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a3f:	90                   	nop
    *pte |= PTE_W;
80107a40:	83 0f 02             	orl    $0x2,(%edi)
80107a43:	eb 9f                	jmp    801079e4 <pagefault+0x54>
80107a45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107a50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107a50:	55                   	push   %ebp
80107a51:	89 e5                	mov    %esp,%ebp
80107a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107a56:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107a59:	89 c1                	mov    %eax,%ecx
80107a5b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107a5e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107a61:	f6 c2 01             	test   $0x1,%dl
80107a64:	0f 84 07 01 00 00    	je     80107b71 <uva2ka.cold>
  return &pgtab[PTX(va)];
80107a6a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a6d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107a73:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107a74:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107a79:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107a80:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107a87:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a8a:	05 00 00 00 80       	add    $0x80000000,%eax
80107a8f:	83 fa 05             	cmp    $0x5,%edx
80107a92:	ba 00 00 00 00       	mov    $0x0,%edx
80107a97:	0f 45 c2             	cmovne %edx,%eax
}
80107a9a:	c3                   	ret    
80107a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a9f:	90                   	nop

80107aa0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107aa0:	55                   	push   %ebp
80107aa1:	89 e5                	mov    %esp,%ebp
80107aa3:	57                   	push   %edi
80107aa4:	56                   	push   %esi
80107aa5:	53                   	push   %ebx
80107aa6:	83 ec 0c             	sub    $0xc,%esp
80107aa9:	8b 75 14             	mov    0x14(%ebp),%esi
80107aac:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aaf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ab2:	85 f6                	test   %esi,%esi
80107ab4:	75 51                	jne    80107b07 <copyout+0x67>
80107ab6:	e9 a5 00 00 00       	jmp    80107b60 <copyout+0xc0>
80107abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107abf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107ac0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107ac6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107acc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107ad2:	74 75                	je     80107b49 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107ad4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107ad6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107ad9:	29 c3                	sub    %eax,%ebx
80107adb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107ae1:	39 f3                	cmp    %esi,%ebx
80107ae3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107ae6:	29 f8                	sub    %edi,%eax
80107ae8:	83 ec 04             	sub    $0x4,%esp
80107aeb:	01 c1                	add    %eax,%ecx
80107aed:	53                   	push   %ebx
80107aee:	52                   	push   %edx
80107aef:	51                   	push   %ecx
80107af0:	e8 7b d3 ff ff       	call   80104e70 <memmove>
    len -= n;
    buf += n;
80107af5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107af8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107afe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107b01:	01 da                	add    %ebx,%edx
  while(len > 0){
80107b03:	29 de                	sub    %ebx,%esi
80107b05:	74 59                	je     80107b60 <copyout+0xc0>
  if(*pde & PTE_P){
80107b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107b0a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107b0c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107b0e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107b11:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107b17:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107b1a:	f6 c1 01             	test   $0x1,%cl
80107b1d:	0f 84 55 00 00 00    	je     80107b78 <copyout.cold>
  return &pgtab[PTX(va)];
80107b23:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b25:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107b2b:	c1 eb 0c             	shr    $0xc,%ebx
80107b2e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107b34:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107b3b:	89 d9                	mov    %ebx,%ecx
80107b3d:	83 e1 05             	and    $0x5,%ecx
80107b40:	83 f9 05             	cmp    $0x5,%ecx
80107b43:	0f 84 77 ff ff ff    	je     80107ac0 <copyout+0x20>
  }
  return 0;
}
80107b49:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b51:	5b                   	pop    %ebx
80107b52:	5e                   	pop    %esi
80107b53:	5f                   	pop    %edi
80107b54:	5d                   	pop    %ebp
80107b55:	c3                   	ret    
80107b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b5d:	8d 76 00             	lea    0x0(%esi),%esi
80107b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b63:	31 c0                	xor    %eax,%eax
}
80107b65:	5b                   	pop    %ebx
80107b66:	5e                   	pop    %esi
80107b67:	5f                   	pop    %edi
80107b68:	5d                   	pop    %ebp
80107b69:	c3                   	ret    

80107b6a <pagefault.cold>:
  pa = PTE_ADDR(*pte);
80107b6a:	a1 00 00 00 00       	mov    0x0,%eax
80107b6f:	0f 0b                	ud2    

80107b71 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107b71:	a1 00 00 00 00       	mov    0x0,%eax
80107b76:	0f 0b                	ud2    

80107b78 <copyout.cold>:
80107b78:	a1 00 00 00 00       	mov    0x0,%eax
80107b7d:	0f 0b                	ud2    
