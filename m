Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057C8210A9B
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 13:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbgGAL5a (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 07:57:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41275 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730103AbgGAL53 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Jul 2020 07:57:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593604648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h+vnH5yxqzybGoCfPk7S5UvD4rTQ6W8DF52LVA0sahg=;
        b=Iz7c/ec+Z4T9WSuBHvdhohyNcZVeS5Uo2Js4auhmhQ1SM5ELd3tEgC47MeBQzEo4A1ciyh
        JpJPXudxmqFGKWYoEQKy9f+l+Wgz4QEJCpdoq8oeS5ozCouWq7ab7J4QEwCI7+xjwdsoES
        GOSmw82xkr9SxOgX8y4uBJIql9SpKOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-7pSF0dbJMkSPvK0rhyqAIQ-1; Wed, 01 Jul 2020 07:57:24 -0400
X-MC-Unique: 7pSF0dbJMkSPvK0rhyqAIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DADE100D0DE;
        Wed,  1 Jul 2020 11:57:23 +0000 (UTC)
Received: from [10.72.12.116] (ovpn-12-116.pek2.redhat.com [10.72.12.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B5F7A63D6;
        Wed,  1 Jul 2020 11:57:21 +0000 (UTC)
Subject: Re: [PATCH 1/3] ceph: fix potential mdsc use-after-free crash
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <1593582768-2954-1-git-send-email-xiubli@redhat.com>
 <c586bbc39a666391c86be355b5c7cb32a5baa532.camel@kernel.org>
 <daef4fc2-b206-d1cb-5946-2b97a2062628@redhat.com>
 <ad6ab748fa35d34f14486cd69389fc44eb373ce7.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <2ec6a518-973e-0c87-98c8-180d8b8a0feb@redhat.com>
Date:   Wed, 1 Jul 2020 19:57:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <ad6ab748fa35d34f14486cd69389fc44eb373ce7.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/7/1 19:55, Jeff Layton wrote:
> On Wed, 2020-07-01 at 19:25 +0800, Xiubo Li wrote:
>> On 2020/7/1 19:17, Jeff Layton wrote:
>>> On Wed, 2020-07-01 at 01:52 -0400, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> Make sure the delayed work stopped before releasing the resources.
>>>>
>>>> Because the cancel_delayed_work_sync() will only guarantee that the
>>>> work finishes executing if the work is already in the ->worklist.
>>>> That means after the cancel_delayed_work_sync() returns and in case
>>>> if the work will re-arm itself, it will leave the work requeued. And
>>>> if we release the resources before the delayed work to run again we
>>>> will hit the use-after-free bug.
>>>>
>>>> URL: https://tracker.ceph.com/issues/46293
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/mds_client.c | 14 +++++++++++++-
>>>>    1 file changed, 13 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index d5e523c..9a09d12 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -4330,6 +4330,9 @@ static void delayed_work(struct work_struct *work)
>>>>    
>>>>    	dout("mdsc delayed_work\n");
>>>>    
>>>> +	if (mdsc->stopping)
>>>> +		return;
>>>> +
>>>>    	mutex_lock(&mdsc->mutex);
>>>>    	renew_interval = mdsc->mdsmap->m_session_timeout >> 2;
>>>>    	renew_caps = time_after_eq(jiffies, HZ*renew_interval +
>>>> @@ -4689,7 +4692,16 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
>>>>    static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
>>>>    {
>>>>    	dout("stop\n");
>>>> -	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
>>>> +	/*
>>>> +	 * Make sure the delayed work stopped before releasing
>>>> +	 * the resources.
>>>> +	 *
>>>> +	 * Because the cancel_delayed_work_sync() will only
>>>> +	 * guarantee that the work finishes executing. But the
>>>> +	 * delayed work will re-arm itself again after that.
>>>> +	 */
>>>> +	flush_delayed_work(&mdsc->delayed_work);
>>>> +
>>>>    	if (mdsc->mdsmap)
>>>>    		ceph_mdsmap_destroy(mdsc->mdsmap);
>>>>    	kfree(mdsc->sessions);
>>> This patch looks fine, but the subject says [PATCH 1/3]. Were there
>>> others in this series that didn't make it to the list for some reason?
>> Sorry for confusing.
>>
>> Just generated this patch with the metrics series and forget to fix it
>> before sending out.
>>
>>
> No worries. Just making sure before I merged it. Merged patch into
> testing branch.

Thanks Jeff.

BRs


>
> Thanks!


