Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F33CC1023D3
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 13:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfKSMEf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 07:04:35 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:33402 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSMEf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 07:04:35 -0500
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHz19O2tNdkJfwAw--.1046S2;
        Tue, 19 Nov 2019 20:04:30 +0800 (CST)
Subject: Re: [PATCH 3/9] rbd: treat images mapped read-only seriously
To:     Ilya Dryomov <idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
 <20191118133816.3963-4-idryomov@gmail.com> <5DD3A9D6.4010908@easystack.cn>
 <CAOi1vP-Q0B4omNcoWCR7SX7V=4L_81o4HfZciH1EtOULmM=epA@mail.gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DD3DA4E.1060107@easystack.cn>
Date:   Tue, 19 Nov 2019 20:04:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-Q0B4omNcoWCR7SX7V=4L_81o4HfZciH1EtOULmM=epA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowADHz19O2tNdkJfwAw--.1046S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUj6wZDUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiGw5yelpcg-WabwAAsY
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 11/19/2019 06:55 PM, Ilya Dryomov wrote:
> On Tue, Nov 19, 2019 at 9:37 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn> wrote:
>>
>>
>> On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
>>> Even though -o ro/-o read_only/--read-only options are very old, we
>>> have never really treated them seriously (on par with snapshots).  As
>>> a first step, fail writes to images mapped read-only just like we do
>>> for snapshots.
>>>
>>> We need this check in rbd because the block layer basically ignores
>>> read-only setting, see commit a32e236eb93e ("Partially revert "block:
>>> fail op_is_write() requests to read-only partitions"").
>>>
>>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>>> ---
>>>    drivers/block/rbd.c | 13 ++++++++-----
>>>    1 file changed, 8 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>>> index 330d2789f373..842b92ef2c06 100644
>>> --- a/drivers/block/rbd.c
>>> +++ b/drivers/block/rbd.c
>>> @@ -4820,11 +4820,14 @@ static void rbd_queue_workfn(struct work_struct *work)
>>>                goto err_rq;
>>>        }
>>>
>>> -     if (op_type != OBJ_OP_READ && rbd_is_snap(rbd_dev)) {
>>> -             rbd_warn(rbd_dev, "%s on read-only snapshot",
>>> -                      obj_op_name(op_type));
>>> -             result = -EIO;
>>> -             goto err;
>>> +     if (op_type != OBJ_OP_READ) {
>>> +             if (rbd_is_ro(rbd_dev)) {
>>> +                     rbd_warn(rbd_dev, "%s on read-only mapping",
>>> +                              obj_op_name(op_type));
>>> +                     result = -EIO;
>>> +                     goto err;
>>> +             }
>>> +             rbd_assert(!rbd_is_snap(rbd_dev));
>> Just one question here, if block layer does not prevent write for
>> readonly disk 100%,
>> should we make it rbd-level readonly in rbd_ioctl_set_ro() when requested ?
> No, the point is to divorce the read-only setting at the block layer
> level from read-only setting in rbd.  Enforcing the block layer setting
> is up to the block layer, rbd only enforces the rbd setting.  We allow
> the block layer setting to be tweaked with BLKROSET, while rbd setting
> is immutable (i.e. if you mapped with -o ro, you would have to unmap
> and map without -o ro).  So we propagate rbd setting up to the block
> layer, but the block layer setting isn't propagated down to rbd.

makes sense
>
> Thanks,
>
>                  Ilya
>


