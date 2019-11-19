Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7571023EB
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 13:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfKSMIr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 07:08:47 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:37056 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbfKSMIr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 07:08:47 -0500
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowACnKVw829NdIJzwAw--.1151S2;
        Tue, 19 Nov 2019 20:08:28 +0800 (CST)
Subject: Re: [PATCH 8/9] rbd: don't query snapshot features
To:     Ilya Dryomov <idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
 <20191118133816.3963-9-idryomov@gmail.com> <5DD3A9EA.6050108@easystack.cn>
 <CAOi1vP_Yn4HJAvMqYk5MH_z0uawLy-Aky_cBsdNG6g=WBqzZ5A@mail.gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DD3DB3C.2050302@easystack.cn>
Date:   Tue, 19 Nov 2019 20:08:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_Yn4HJAvMqYk5MH_z0uawLy-Aky_cBsdNG6g=WBqzZ5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowACnKVw829NdIJzwAw--.1151S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJw4kKFW8Cr13GF1kGr47twb_yoW5Xw4Upr
        4fJF9FkFWUWry2ka15Xrn8ArWrKa17t34DuryUA34xuasYkr9xAFyxCFW0qFWDGa4DWFW8
        GF4YyrZxAr4jyFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0p_4E_ZUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbibxxyellZu1mh4gAAsa
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 11/19/2019 07:55 PM, Ilya Dryomov wrote:
> On Tue, Nov 19, 2019 at 9:38 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn> wrote:
>>
>>
>> On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
>>> Since infernalis, ceph.git commit 281f87f9ee52 ("cls_rbd: get_features
>>> on snapshots returns HEAD image features"), querying and checking that
>>> is pointless.  Userspace support for manipulating image features after
>>> image creation came also in infernalis, so a snapshot with a different
>>> set of features wasn't ever possible.
>>>
>>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>> Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
>>
>> Just one small nit below.
>>> ---
>>>    drivers/block/rbd.c | 38 +-------------------------------------
>>>    1 file changed, 1 insertion(+), 37 deletions(-)
>>>
>>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>>> index aba60e37b058..935b66808e40 100644
>>> --- a/drivers/block/rbd.c
>>> +++ b/drivers/block/rbd.c
>>> @@ -377,7 +377,6 @@ struct rbd_client_id {
>>>
>>>    struct rbd_mapping {
>>>        u64                     size;
>>> -     u64                     features;
>>>    };
>>>
>>>    /*
>>> @@ -644,8 +643,6 @@ static const char *rbd_dev_v2_snap_name(struct rbd_device *rbd_dev,
>>>                                        u64 snap_id);
>>>    static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
>>>                                u8 *order, u64 *snap_size);
>>> -static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
>>> -             u64 *snap_features);
>>>    static int rbd_dev_v2_get_flags(struct rbd_device *rbd_dev);
>>>
>>>    static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result);
>>> @@ -1303,51 +1300,23 @@ static int rbd_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
>>>        return 0;
>>>    }
>>>
>>> -static int rbd_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
>>> -                     u64 *snap_features)
>>> -{
>>> -     rbd_assert(rbd_image_format_valid(rbd_dev->image_format));
>>> -     if (snap_id == CEPH_NOSNAP) {
>>> -             *snap_features = rbd_dev->header.features;
>>> -     } else if (rbd_dev->image_format == 1) {
>>> -             *snap_features = 0;     /* No features for format 1 */
>>> -     } else {
>>> -             u64 features = 0;
>>> -             int ret;
>>> -
>>> -             ret = _rbd_dev_v2_snap_features(rbd_dev, snap_id, &features);
>> Just nit:
>>
>> _rbd_dev_v2_snap_features has only one caller now. we can implement it directly in rbd_dev_v2_features().
> I kept both to minimize code churn and also because I actually expect
> rbd_dev_v2_features() to be removed in the future.  We need to get away
> from using rbd_dev as a global variable (and thus functions that take
> just rbd_dev and both read from and write to it).

Okey, so there is a reason from future plan to keep it. No problem

Thanx
>
> Thanks,
>
>                  Ilya
>


