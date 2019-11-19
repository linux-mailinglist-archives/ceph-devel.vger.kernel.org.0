Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F991023DD
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 13:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfKSMGQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 07:06:16 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:34800 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfKSMGP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 07:06:15 -0500
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAD371+o2tNdOpnwAw--.1083S2;
        Tue, 19 Nov 2019 20:06:00 +0800 (CST)
Subject: Re: [PATCH 6/9] rbd: don't establish watch for read-only mappings
To:     Ilya Dryomov <idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
 <20191118133816.3963-7-idryomov@gmail.com> <5DD3A9E3.3040002@easystack.cn>
 <CAOi1vP-vPSjsfHx3R_jPuk-D-u1w-0VXMpN9Gmd6Z62SpXJ7Gw@mail.gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DD3DAA8.9050202@easystack.cn>
Date:   Tue, 19 Nov 2019 20:06:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-vPSjsfHx3R_jPuk-D-u1w-0VXMpN9Gmd6Z62SpXJ7Gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAD371+o2tNdOpnwAw--.1083S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXF1kXFy5KF1kKw43urWrAFb_yoWrWw18pw
        s5tFW5tFWUGF12k343Awn0qr15tFn2q34kWwnrCw1xCrnagrnxtryxKF15WrWrAryxCr48
        AF45JFW5CFZYyrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR8hL5UUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbibwhyellZu1mgwwAAsu
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 11/19/2019 07:42 PM, Ilya Dryomov wrote:
> On Tue, Nov 19, 2019 at 9:38 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn> wrote:
>>
>>
>> On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
>>> With exclusive lock out of the way, watch is the only thing left that
>>> prevents a read-only mapping from being used with read-only OSD caps.
>>>
>>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>>> ---
>>>    drivers/block/rbd.c | 41 +++++++++++++++++++++++++++--------------
>>>    1 file changed, 27 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>>> index aaa359561356..bfff195e8e23 100644
>>> --- a/drivers/block/rbd.c
>>> +++ b/drivers/block/rbd.c
>>> @@ -6985,6 +6985,24 @@ static int rbd_dev_header_name(struct rbd_device *rbd_dev)
>>>        return ret;
>>>    }
>>>
>>> +static void rbd_print_dne(struct rbd_device *rbd_dev, bool is_snap)
>>> +{
>>> +     if (!is_snap) {
>>> +             pr_info("image %s/%s%s%s does not exist\n",
>>> +                     rbd_dev->spec->pool_name,
>>> +                     rbd_dev->spec->pool_ns ?: "",
>>> +                     rbd_dev->spec->pool_ns ? "/" : "",
>>> +                     rbd_dev->spec->image_name);
>>> +     } else {
>>> +             pr_info("snap %s/%s%s%s@%s does not exist\n",
>>> +                     rbd_dev->spec->pool_name,
>>> +                     rbd_dev->spec->pool_ns ?: "",
>>> +                     rbd_dev->spec->pool_ns ? "/" : "",
>>> +                     rbd_dev->spec->image_name,
>>> +                     rbd_dev->spec->snap_name);
>>> +     }
>>> +}
>>> +
>>>    static void rbd_dev_image_release(struct rbd_device *rbd_dev)
>>>    {
>>>        rbd_dev_unprobe(rbd_dev);
>>> @@ -7003,6 +7021,7 @@ static void rbd_dev_image_release(struct rbd_device *rbd_dev)
>>>     */
>>>    static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
>>>    {
>>> +     bool need_watch = !depth && !rbd_is_ro(rbd_dev);
>>>        int ret;
>>>
>>>        /*
>>> @@ -7019,22 +7038,21 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
>>>        if (ret)
>>>                goto err_out_format;
>>>
>>> -     if (!depth) {
>>> +     if (need_watch) {
>>>                ret = rbd_register_watch(rbd_dev);
>>>                if (ret) {
>>>                        if (ret == -ENOENT)
>>> -                             pr_info("image %s/%s%s%s does not exist\n",
>>> -                                     rbd_dev->spec->pool_name,
>>> -                                     rbd_dev->spec->pool_ns ?: "",
>>> -                                     rbd_dev->spec->pool_ns ? "/" : "",
>>> -                                     rbd_dev->spec->image_name);
>>> +                             rbd_print_dne(rbd_dev, false);
>>>                        goto err_out_format;
>>>                }
>>>        }
>>>
>>>        ret = rbd_dev_header_info(rbd_dev);
>>> -     if (ret)
>>> +     if (ret) {
>>> +             if (ret == -ENOENT && !need_watch)
>> It's not just "if (ret == -ENOENT)" here, could you explain it more
>> about why we need "&& !need_watch"?
> Just a mechanical transformation, I think.
>
> There were two pr_infos before this patch, one for images and one for
> snapshots.  Because we don't call rbd_register_watch() in the read-only
> case anymore, we need a second pr_info for images.  One is "active" for
> the normal case (need_watch), the other is "active" for the read-only
> case (!need_watch).
>
> Since only one ENOENT is expected, we could just "if (ret == -ENOENT)",
> "&& !need_watch" isn't strictly needed.

Okey, thanx
>
>>> +                     rbd_print_dne(rbd_dev, false);
>>>                goto err_out_watch;
>>> +     }
>>>
>>>        /*
>>>         * If this image is the one being mapped, we have pool name and
>>> @@ -7048,12 +7066,7 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
>>>                ret = rbd_spec_fill_names(rbd_dev);
>>>        if (ret) {
>>>                if (ret == -ENOENT)
>>> -                     pr_info("snap %s/%s%s%s@%s does not exist\n",
>>> -                             rbd_dev->spec->pool_name,
>>> -                             rbd_dev->spec->pool_ns ?: "",
>>> -                             rbd_dev->spec->pool_ns ? "/" : "",
>>> -                             rbd_dev->spec->image_name,
>>> -                             rbd_dev->spec->snap_name);
>>> +                     rbd_print_dne(rbd_dev, true);
>> is_snap here is always true? IIUC, as we have a watcher for non-snap
>> mapping, the rbd_spec_fill_snap_id()
>> would not be fail with -ENOENT. Is that the reason? If so, can we add an
>> rbd_assert(depth); and add
>> a comment about why we use is_snap == true here?
> I don't think we need an assert here.  This just wraps the pr_info that
> has been there for years, no other change is made.

Okey, let's keep this logic.
>
> Thanks,
>
>                  Ilya
>


