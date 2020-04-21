Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A951B2CA3
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 18:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgDUQ2z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 12:28:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:36606 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgDUQ2z (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 12:28:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8F225AA4F;
        Tue, 21 Apr 2020 16:28:52 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 21 Apr 2020 18:28:52 +0200
From:   Roman Penyaev <rpenyaev@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH 00/16] libceph: messenger: send/recv data at one go
In-Reply-To: <CAOi1vP-miL6bU=ghfd0tcazdk83+UJtUKMY0bn4hutoAf1Wh1g@mail.gmail.com>
References: <20200421131850.443228-1-rpenyaev@suse.de>
 <CAOi1vP-miL6bU=ghfd0tcazdk83+UJtUKMY0bn4hutoAf1Wh1g@mail.gmail.com>
Message-ID: <62eceed084b57ca9585c00356a72adbd@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


Hi Ilya,

On 2020-04-21 17:51, Ilya Dryomov wrote:
> On Tue, Apr 21, 2020 at 3:18 PM Roman Penyaev <rpenyaev@suse.de> wrote:
>> 
>> Hi folks,
>> 
>> While experimenting with messenger code in userspace [1] I noticed
>> that send and receive socket calls always operate with 4k, even bvec
>> length is larger (for example when bvec is contructed from bio, where
>> multi-page is used for big IOs). This is an attempt to speed up send
>> and receive for large IO.
>> 
>> First 3 patches are cleanups. I remove unused code and get rid of
>> ceph_osd_data structure. I found that ceph_osd_data duplicates
>> ceph_msg_data and it seems unified API looks better for similar
>> things.
>> 
>> In the following patches ceph_msg_data_cursor is switched to iov_iter,
>> which seems is more suitable for such kind of things (when we
>> basically do socket IO). This gives us the possibility to use the
>> whole iov_iter for sendmsg() and recvmsg() calls instead of iterating
>> page by page. sendpage() call also benefits from this, because now if
>> bvec is constructed from multi-page, then we can 0-copy the whole
>> bvec in one go.
> 
> Hi Roman,
> 
> I'm in the process of rewriting the kernel messenger to support msgr2
> (i.e. encryption) and noticed the same things.  The switch to iov_iter
> was the first thing I implemented ;)  Among other things is support for
> multipage bvecs and explicit socket corking.

Ah, ok, good to know. This patchset came from the userspace variant of
the kernel messenger. These changes also show nice numbers on userspace
side. (of course without sendpage() variant and plus some caching on
receive, which I also implemented for kernel side, but left aside since
this did not show any interesting results for rbd load)

> I haven't benchmarked any
> of it though -- it just seemed like a sensible thing to do, especially
> since the sendmsg/sendpage infrastructure needed changes for encryption
> anyway.

I can benchmark on my localhost setup easily. Just add me to CC when
you are done.

> 
> Support for kvecs isn't implemented yet, but will be in order to get
> rid of all those "allocate a page just to process 16 bytes" sites.
> 
> Unfortunately I got distracted by some higher priority issues with the
> userspace messenger, so the kernel messenger is in a bit of a state of
> disarray at the moment.  Here is the excerpt from the send path:
> 
> #define CEPH_MSG_FLAGS (MSG_DONTWAIT | MSG_NOSIGNAL)
> 
> static int do_sendmsg(struct ceph_connection *con, struct iov_iter *it)
> {
>         struct msghdr msg = { .msg_flags = CEPH_MSG_FLAGS };
>         int ret;
> 
>         msg.msg_iter = *it;
>         while (iov_iter_count(it)) {
>                 ret = do_one_sendmsg(con, &msg);
>                 if (ret <= 0) {
>                         if (ret == -EAGAIN)
>                                 ret = 0;
>                         return ret;
>                 }
> 
>                 iov_iter_advance(it, ret);
>         }
> 
>         BUG_ON(msg_data_left(&msg));
>         return 1;
> }
> 
> static int do_sendpage(struct ceph_connection *con, struct iov_iter 
> *it)
> {
>         ssize_t ret;
> 
>         BUG_ON(!iov_iter_is_bvec(it));
>         while (iov_iter_count(it)) {
>                 struct page *page = it->bvec->bv_page;
>                 int offset = it->bvec->bv_offset + it->iov_offset;
>                 size_t size = min(it->count,
>                                   it->bvec->bv_len - it->iov_offset);
> 
>                 /*
>                  * sendpage cannot properly handle pages with
>                  * page_count == 0, we need to fall back to sendmsg if
>                  * that's the case.
>                  *
>                  * Same goes for slab pages: skb_can_coalesce() allows
>                  * coalescing neighboring slab objects into a single 
> frag
>                  * which triggers one of hardened usercopy checks.
>                  */
>                 if (page_count(page) >= 1 && !PageSlab(page)) {
>                         ret = do_one_sendpage(con, page, offset, size,
>                                               CEPH_MSG_FLAGS);
>                 } else {
>                         struct msghdr msg = { .msg_flags = 
> CEPH_MSG_FLAGS };
>                         struct bio_vec bv = {
>                                 .bv_page = page,
>                                 .bv_offset = offset,
>                                 .bv_len = size,
>                         };
> 
>                         iov_iter_bvec(&msg.msg_iter, WRITE, &bv, 1, 
> size);
>                         ret = do_one_sendmsg(con, &msg);
>                 }
>                 if (ret <= 0) {
>                         if (ret == -EAGAIN)
>                                 ret = 0;
>                         return ret;
>                 }
> 
>                 iov_iter_advance(it, ret);
>         }
> 
>         return 1;
> }
> 
> /*
>  * Write as much as possible.  The socket is expected to be corked,
>  * so we don't bother with MSG_MORE/MSG_SENDPAGE_NOTLAST here.
>  *
>  * Return:
>  *   1 - done, nothing else to write
>  *   0 - socket is full, need to wait
>  *  <0 - error
>  */
> int ceph_tcp_send(struct ceph_connection *con)
> {
>         bool is_kvec = iov_iter_is_kvec(&con->out_iter);
>         int ret;
> 
>         dout("%s con %p have %zu is_kvec %d\n", __func__, con,
>              iov_iter_count(&con->out_iter), is_kvec);
>         if (is_kvec)
>                 ret = do_sendmsg(con, &con->out_iter);
>         else
>                 ret = do_sendpage(con, &con->out_iter);
> 
>         dout("%s con %p ret %d left %zu\n", __func__, con, ret,
>              iov_iter_count(&con->out_iter));
>         return ret;
> }

Ha! Nice! That almost exactly what I do in current patchset, except
corking. I still bother with MSG_MORE/MSG_SENDPAGE_NOTLAST :)

BTW kvecs also can be sendpaged. Since we do not have userspace
iovec, thus page can be easily taken.  But that is a minor.

> I'll make sure to CC you on my patches, should be in a few weeks.

Yes, please.  I can help with benchmarking and reviewing.

> 
> Getting rid of ceph_osd_data is probably a good idea.  FWIW I never
> liked it, but not strong enough to bother with removing it.
> 
>> 
>> I also allowed myself to get rid of ->last_piece and ->need_crc
>> members and ceph_msg_data_next() call. Now CRC is calculated not on
>> page basis, but according to the size of processed chunk.  I found
>> ceph_msg_data_next() is a bit redundant, since we always can set the
>> next cursor chunk on cursor init or on advance.
>> 
>> How I tested the performance? I used rbd.fio load on 1 OSD in memory
>> with the following fio configuration:
>> 
>>   direct=1
>>   time_based=1
>>   runtime=10
>>   ioengine=io_uring
>>   size=256m
>> 
>>   rw=rand{read|write}
>>   numjobs=32
>>   iodepth=32
>> 
>>   [job1]
>>   filename=/dev/rbd0
>> 
>> RBD device is mapped with 'nocrc' option set.  For writes OSD 
>> completes
>> requests immediately, without touching the memory simulating null 
>> block
>> device, that's why write throughput in my results is much higher than
>> for reads.
>> 
>> I tested on loopback interface only, in Vm, have not yet setup the
>> cluster on real machines, so sendpage() on a big multi-page shows
>> indeed good results, as expected. But I found an interesting comment
>> in drivers/infiniband/sw/siw/siw_qp_tc.c:siw_tcp_sendpages(), which
>> says:
>> 
>>  "Using sendpage to push page by page appears to be less efficient
>>   than using sendmsg, even if data are copied.
>> 
>>   A general performance limitation might be the extra four bytes
>>   trailer checksum segment to be pushed after user data."
>> 
>> I could not prove or disprove since have tested on loopback interface
>> only.  So it might be that sendmsg() in on go is faster than
>> sendpage() for bvecs with many segments.
> 
> Please share any further findings.  We have been using sendpage for
> the data section of the message since forever and I remember hearing
> about a performance regression when someone inadvertently disabled the
> sendpage path (can't recall the subsystem -- iSCSI?).  If you discover
> that sendpage is actually slower, that would be very interesting.

I will try to find a good machine for that with fat network.
Should be easy to benchmark.

>> Here is the output of the rbd fio load for various block sizes:
>> 
>> ==== WRITE ===
>> 
>> current master, rw=randwrite, numjobs=32 iodepth=32
>> 
>>   4k  IOPS=92.7k, BW=362MiB/s, Lat=11033.30usec
>>   8k  IOPS=85.6k, BW=669MiB/s, Lat=11956.74usec
>>  16k  IOPS=76.8k, BW=1200MiB/s, Lat=13318.24usec
>>  32k  IOPS=56.7k, BW=1770MiB/s, Lat=18056.92usec
>>  64k  IOPS=34.0k, BW=2186MiB/s, Lat=29.23msec
>> 128k  IOPS=21.8k, BW=2720MiB/s, Lat=46.96msec
>> 256k  IOPS=14.4k, BW=3596MiB/s, Lat=71.03msec
>> 512k  IOPS=8726, BW=4363MiB/s, Lat=116.34msec
>>   1m  IOPS=4799, BW=4799MiB/s, Lat=211.15msec
>> 
>> this patchset,  rw=randwrite, numjobs=32 iodepth=32
>> 
>>   4k  IOPS=94.7k, BW=370MiB/s, Lat=10802.43usec
>>   8k  IOPS=91.2k, BW=712MiB/s, Lat=11221.00usec
>>  16k  IOPS=80.4k, BW=1257MiB/s, Lat=12715.56usec
>>  32k  IOPS=61.2k, BW=1912MiB/s, Lat=16721.33usec
>>  64k  IOPS=40.9k, BW=2554MiB/s, Lat=24993.31usec
>> 128k  IOPS=25.7k, BW=3216MiB/s, Lat=39.72msec
>> 256k  IOPS=17.3k, BW=4318MiB/s, Lat=59.15msec
>> 512k  IOPS=11.1k, BW=5559MiB/s, Lat=91.39msec
>>   1m  IOPS=6696, BW=6696MiB/s, Lat=151.25msec
>> 
>> 
>> === READ ===
>> 
>> current master, rw=randread, numjobs=32 iodepth=32
>> 
>>   4k  IOPS=62.5k, BW=244MiB/s, Lat=16.38msec
>>   8k  IOPS=55.5k, BW=433MiB/s, Lat=18.44msec
>>  16k  IOPS=40.6k, BW=635MiB/s, Lat=25.18msec
>>  32k  IOPS=24.6k, BW=768MiB/s, Lat=41.61msec
>>  64k  IOPS=14.8k, BW=925MiB/s, Lat=69.06msec
>> 128k  IOPS=8687, BW=1086MiB/s, Lat=117.59msec
>> 256k  IOPS=4733, BW=1183MiB/s, Lat=214.76msec
>> 512k  IOPS=3156, BW=1578MiB/s, Lat=320.54msec
>>   1m  IOPS=1901, BW=1901MiB/s, Lat=528.22msec
>> 
>> this patchset,  rw=randread, numjobs=32 iodepth=32
>> 
>>   4k  IOPS=62.6k, BW=244MiB/s, Lat=16342.89usec
>>   8k  IOPS=55.5k, BW=434MiB/s, Lat=18.42msec
>>  16k  IOPS=43.2k, BW=675MiB/s, Lat=23.68msec
>>  32k  IOPS=28.4k, BW=887MiB/s, Lat=36.04msec
>>  64k  IOPS=20.2k, BW=1263MiB/s, Lat=50.54msec
>> 128k  IOPS=11.7k, BW=1465MiB/s, Lat=87.01msec
>> 256k  IOPS=6813, BW=1703MiB/s, Lat=149.30msec
>> 512k  IOPS=5363, BW=2682MiB/s, Lat=189.37msec
>>   1m  IOPS=2220, BW=2221MiB/s, Lat=453.92msec
>> 
>> 
>> Results for small blocks are not interesting, since there should not
>> be any difference. But starting from 32k block benefits of doing IO
>> for the whole message at once starts to prevail.
> 
> It's not really the whole message, just the header, front and middle
> sections, right?

No, that is the whole message. Output of fio rbd load. Or I did not get
your question.

> The data section is still per-bvec, it's just that
> bvec is no longer limited to a single page but may encompass several
> physically contiguous pages.

True. Data section is bvec, which is taken from a bio, which on
its turn has one big physically contiguous multipage.  Of course
when there is such a slice of physical contiguous memory.

> These are not that easy to come by on
> a heavily loaded system, but they do result in nice numbers.

Yeah, sometimes there is quite a big number of segments for a big IO.
And for that case it seems makes sense to do buffering, i.e. calling
sendmsg().

So probably sendpage() makes sense to call when

    nr_segs < N && bvec->bv_len > M * 4k

where N and M are some magic numbers which help to resuce costs
of calling do_tcp_sendpages() in a loooong loop. But this is
pure speculation.

--
Roman

