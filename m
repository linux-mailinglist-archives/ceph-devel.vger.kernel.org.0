Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42049C776
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Aug 2019 04:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbfHZCyF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 25 Aug 2019 22:54:05 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:19126 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729389AbfHZCyF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 25 Aug 2019 22:54:05 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHNWWvSWNd0dx8AQ--.16S2;
        Mon, 26 Aug 2019 10:53:35 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [PATCH v3 02/15] libceph: introduce a new parameter of workqueue
 in ceph_osdc_watch()
To:     Ilya Dryomov <idryomov@gmail.com>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
 <1564393377-28949-3-git-send-email-dongsheng.yang@easystack.cn>
 <CAOi1vP8UVpSA5kMv--LQ2+34awVVWU60LQUWN7A3DfYjzpKD0A@mail.gmail.com>
Cc:     Jason Dillaman <jdillama@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Message-ID: <5D6349AF.4060005@easystack.cn>
Date:   Mon, 26 Aug 2019 10:53:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8UVpSA5kMv--LQ2+34awVVWU60LQUWN7A3DfYjzpKD0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowADHNWWvSWNd0dx8AQ--.16S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRRwZ7DUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiWw8delf4pV+T1QAAsg
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 08/19/2019 03:36 PM, Ilya Dryomov wrote:
> On Mon, Jul 29, 2019 at 11:43 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn>  wrote:
>> Currently, if we share osdc in rbd device and journaling, they are
>> sharing the notify_wq in osdc to complete watch_cb. When we
>> need to close journal held with mutex of rbd device, we need
>> to flush the notify_wq. But we don't want to flush the watch_cb
>> of rbd_device, maybe some of it need to lock rbd mutex.
>>
>> To solve this problem, this patch allow user to manage the notify
>> workqueue by themselves in watching.
> What do you mean by "mutex of rbd device", rbd_dev->header_rwsem?
>
> Did you actually encounter the resulting deadlock in testing?

Yes this patch is solving a real problem I met. But I wrote an uncorrect 
commit message.
That's ->lock_rwsem, not mutex. The problem is if we dont have a special 
notify_wq for journaler,
we have to call ceph_osdc_flush_notifies(journaler->osdc) to flush 
notifies in ceph_journaler_close().

As journaler and rbd_device are shareing notify_wq in the same osdc, 
this function will flush other
notifies to call rbd_watch_cb(), some of them need ->lock_rwsem.

There is a simple reproduce method:
(1) start a fio to write /dev/rbd0
(2) in the same time, run a script to add snapshot for this image:
for i in `seq 1 10`; do
         rbd snap add test@snap$i &
done

So when there is another RBD_NOTIFY_OP_REQUEST_LOCK in notify_wq when we 
are doing
ceph_osdc_flush_notifies(journaler->osdc). This flush will never finish.

[1]rbd_dev->task_wq [2]osdc->notify_wq
rbd_release_lock_work
  - down_write(&rbd_dev->lock_rwsem);
                                                 rbd_watch_cb
                                                 - rbd_handle_request_lock
                                                 -- 
down_read(&rbd_dev->lock_rwsem);  <-- this need to wait thread [1] to 
release lock_rwsem
  -- rbd_dev_close_journal()
  --- ceph_osdc_flush_notifies() <-- this need to wait thread[2] to complete


Thanx
> Thanks,
>
>                  Ilya
>


