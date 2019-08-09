Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A30D87357
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Aug 2019 09:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405826AbfHIHpN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Aug 2019 03:45:13 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:62219 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728823AbfHIHpN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Aug 2019 03:45:13 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAD3zGR6JE1dOJcEAQ--.4098S2;
        Fri, 09 Aug 2019 15:44:59 +0800 (CST)
Subject: Re: [PATCH] rbd: fix response length parameter for
 rbd_obj_method_sync()
To:     Ilya Dryomov <idryomov@gmail.com>
References: <1565334327-7454-1-git-send-email-dongsheng.yang@easystack.cn>
 <CAOi1vP9p8YHykG3dmUa=VekcTSd+3hOei4N+JDcMDSoqvV10aQ@mail.gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D4D2477.20204@easystack.cn>
Date:   Fri, 9 Aug 2019 15:44:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9p8YHykG3dmUa=VekcTSd+3hOei4N+JDcMDSoqvV10aQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAD3zGR6JE1dOJcEAQ--.4098S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRJwIqUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiUwYMelf4pXYrBQAAsx
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 08/09/2019 03:34 PM, Ilya Dryomov wrote:
> On Fri, Aug 9, 2019 at 9:05 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn> wrote:
>> Response will be an encoded string, which includes a length.
>> So we need to allocate more buf of sizeof (__le32) in reply
>> buffer, and pass the reply buffer size as a parameter in
>> rbd_obj_method_sync function.
>>
>> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
>> ---
>>   drivers/block/rbd.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>> index 3327192..db55ece 100644
>> --- a/drivers/block/rbd.c
>> +++ b/drivers/block/rbd.c
>> @@ -5661,14 +5661,17 @@ static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
>>          void *reply_buf;
>>          int ret;
>>          void *p;
>> +       size_t size;
>>
>> -       reply_buf = kzalloc(RBD_OBJ_PREFIX_LEN_MAX, GFP_KERNEL);
>> +       /* Response will be an encoded string, which includes a length */
>> +       size = sizeof (__le32) + RBD_OBJ_PREFIX_LEN_MAX;
>> +       reply_buf = kzalloc(size, GFP_KERNEL);
>>          if (!reply_buf)
>>                  return -ENOMEM;
>>
>>          ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
>>                                    &rbd_dev->header_oloc, "get_object_prefix",
>> -                                 NULL, 0, reply_buf, RBD_OBJ_PREFIX_LEN_MAX);
>> +                                 NULL, 0, reply_buf, size);
>>          dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
>>          if (ret < 0)
>>                  goto out;
>> @@ -6697,7 +6700,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
>>
>>          ret = rbd_obj_method_sync(rbd_dev, &oid, &rbd_dev->header_oloc,
>>                                    "get_id", NULL, 0,
>> -                                 response, RBD_IMAGE_ID_LEN_MAX);
>> +                                 response, size);
>>          dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
>>          if (ret == -ENOENT) {
>>                  image_id = kstrdup("", GFP_KERNEL);
> Hi Dongsheng,
>
> AFAIR RBD_OBJ_PREFIX_LEN_MAX and RBD_IMAGE_ID_LEN_MAX are arbitrary
> constants with enough slack for length, etc.  We shouldn't ever see
> object prefixes or image ids that are longer than 62 bytes.

Hi Ilya,
     Yes, this patch is not fixing a real problem, as you mentioned we 
dont have
prefixes or image ids longer than 62 bytes. But this patch is going to 
make it
logical consistent.

The most confusing case is for rbd_dev_image_id(), size of response is 
already
RBD_IMAGE_ID_LEN_MAX + sizeof (__le32). but the @resp_length in 
rbd_obj_method_sync()
is still RBD_IMAGE_ID_LEN_MAX.

Thanx
>
> Thanks,
>
>                  Ilya
>


