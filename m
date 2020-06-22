Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8B0202DFC
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jun 2020 02:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgFVAyr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 21 Jun 2020 20:54:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50295 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726375AbgFVAyq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 21 Jun 2020 20:54:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592787284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bex5JU7ML19OlLBKQR3Z6rfhgoB8Fp+jMA7Dk49jFxw=;
        b=LFHLnTRdpLmZ9W6GZ6l0ZnsgxEZgB50CMHOnSinITi8yN3Xn882farwf3oyAVLTZ+Yh1pV
        492tY34Co8qVp6AEozfRIk/inSdl16fcMrci/DJO6E9NWnM0g4/892oaSJtUhPSDIuceDu
        Nb/aJ6b85A5By8irmEeDOOwxXUUDDxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-NBWWj1u3O7GD5uK8CWW3mw-1; Sun, 21 Jun 2020 20:54:38 -0400
X-MC-Unique: NBWWj1u3O7GD5uK8CWW3mw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22C758015CB;
        Mon, 22 Jun 2020 00:54:37 +0000 (UTC)
Received: from [10.72.13.235] (ovpn-13-235.pek2.redhat.com [10.72.13.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C60A1002382;
        Mon, 22 Jun 2020 00:54:34 +0000 (UTC)
Subject: Re: [PATCH v2 2/5] ceph: periodically send perf metrics to ceph
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
 <1592481599-7851-3-git-send-email-xiubli@redhat.com>
 <0b035117f68e00be64569021e10e202371589205.camel@kernel.org>
 <f15a5885-3a9b-f308-bb5f-585f14e8ad19@redhat.com>
 <CAOi1vP81JshWEX7Ja1hqA4512ZBCVNiZX=204ijH15RrVeiT1Q@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <650a1cd9-7a01-0826-51bc-48baabeca05e@redhat.com>
Date:   Mon, 22 Jun 2020 08:54:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP81JshWEX7Ja1hqA4512ZBCVNiZX=204ijH15RrVeiT1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/6/19 17:35, Ilya Dryomov wrote:
> On Fri, Jun 19, 2020 at 2:38 AM Xiubo Li <xiubli@redhat.com> wrote:
>> On 2020/6/18 22:42, Jeff Layton wrote:
>>> On Thu, 2020-06-18 at 07:59 -0400, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> This will send the caps/read/write/metadata metrics to any available
>>>> MDS only once per second as default, which will be the same as the
>>>> userland client, or every metric_send_interval seconds, which is a
>>>> module parameter.
>>>>
>>>> URL: https://tracker.ceph.com/issues/43215
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/mds_client.c         |   3 +
>>>>    fs/ceph/metric.c             | 134 +++++++++++++++++++++++++++++++++++++++++++
>>>>    fs/ceph/metric.h             |  78 +++++++++++++++++++++++++
>>>>    fs/ceph/super.c              |  49 ++++++++++++++++
>>>>    fs/ceph/super.h              |   2 +
>>>>    include/linux/ceph/ceph_fs.h |   1 +
>>>>    6 files changed, 267 insertions(+)
>>>>
>>>>
>>> I think 3/5 needs to moved ahead of this one or folded into it, as we'll
>>> have a temporary regression otherwise.
>>>
>>>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>>>> index c9784eb1..5f409dd 100644
>>>> --- a/fs/ceph/super.c
>>>> +++ b/fs/ceph/super.c
>>>> @@ -27,6 +27,9 @@
>>>>    #include <linux/ceph/auth.h>
>>>>    #include <linux/ceph/debugfs.h>
>>>>
>>>> +static DEFINE_MUTEX(ceph_fsc_lock);
>>>> +static LIST_HEAD(ceph_fsc_list);
>>>> +
>>>>    /*
>>>>     * Ceph superblock operations
>>>>     *
>>>> @@ -691,6 +694,10 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>>>>       if (!fsc->wb_pagevec_pool)
>>>>               goto fail_cap_wq;
>>>>
>>>> +    mutex_lock(&ceph_fsc_lock);
>>>> +    list_add_tail(&fsc->list, &ceph_fsc_list);
>>>> +    mutex_unlock(&ceph_fsc_lock);
>>>> +
>>>>       return fsc;
>>>>
>>>>    fail_cap_wq:
>>>> @@ -717,6 +724,10 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
>>>>    {
>>>>       dout("destroy_fs_client %p\n", fsc);
>>>>
>>>> +    mutex_lock(&ceph_fsc_lock);
>>>> +    list_del(&fsc->list);
>>>> +    mutex_unlock(&ceph_fsc_lock);
>>>> +
>>>>       ceph_mdsc_destroy(fsc);
>>>>       destroy_workqueue(fsc->inode_wq);
>>>>       destroy_workqueue(fsc->cap_wq);
>>>> @@ -1282,6 +1293,44 @@ static void __exit exit_ceph(void)
>>>>       destroy_caches();
>>>>    }
>>>>
>>>> +static int param_set_metric_interval(const char *val, const struct kernel_param *kp)
>>>> +{
>>>> +    struct ceph_fs_client *fsc;
>>>> +    unsigned int interval;
>>>> +    int ret;
>>>> +
>>>> +    ret = kstrtouint(val, 0, &interval);
>>>> +    if (ret < 0) {
>>>> +            pr_err("Failed to parse metric interval '%s'\n", val);
>>>> +            return ret;
>>>> +    }
>>>> +
>>>> +    if (interval > 5) {
>>>> +            pr_err("Invalid metric interval %u\n", interval);
>>>> +            return -EINVAL;
>>>> +    }
>>>> +
>>> Why do we want to reject an interval larger than 5s? Is that problematic
>>> for some reason?
>> IMO, a larger interval doesn't make much sense, to limit the interval
>> value in 5s to make sure that the ceph side could show the client real
>> metrics in time. Is this okay ? Or should we use a larger limit ?
> I wonder if providing the option to tune the interval makes sense
> at all then.  Since most clients will be sending their metrics every
> second, the MDS may eventually start relying on that in some way.
> Would a simple on/off switch, to be used if sending metrics causes
> unforeseen trouble, work?

Hi Ilya,

Yeah, this sounds sensible.

Thanks

BRs

>
> Thanks,
>
>                  Ilya
>

