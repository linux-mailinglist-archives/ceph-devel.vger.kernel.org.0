Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10830210A41
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 13:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbgGALZv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 07:25:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44661 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730159AbgGALZv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Jul 2020 07:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593602750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jdWUR7YA5jD3YlWrPe7yHDYb/qarsTLfryBjGA7SXyA=;
        b=djS3mny2uffgYP4PlI8q+JOyPOJHlaB+Z1A2j0tlqRtdDmiKS5y4Yut0dRACabbKxe+nTV
        TEHWtq7hy/FmdsIUgwr7zn4NJinmBf5Ywj5ZZJddIJi7Skw1519T0TzzYJOUlsanaj1C84
        hvJDlOwc9flFMRpwiPc8uq+qjViHHS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-tEsCy7wAPQa0nIDEiD2e2g-1; Wed, 01 Jul 2020 07:25:44 -0400
X-MC-Unique: tEsCy7wAPQa0nIDEiD2e2g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 214E1804001;
        Wed,  1 Jul 2020 11:25:43 +0000 (UTC)
Received: from [10.72.12.116] (ovpn-12-116.pek2.redhat.com [10.72.12.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF6C41057058;
        Wed,  1 Jul 2020 11:25:39 +0000 (UTC)
Subject: Re: [PATCH 1/3] ceph: fix potential mdsc use-after-free crash
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <1593582768-2954-1-git-send-email-xiubli@redhat.com>
 <c586bbc39a666391c86be355b5c7cb32a5baa532.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <daef4fc2-b206-d1cb-5946-2b97a2062628@redhat.com>
Date:   Wed, 1 Jul 2020 19:25:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <c586bbc39a666391c86be355b5c7cb32a5baa532.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/7/1 19:17, Jeff Layton wrote:
> On Wed, 2020-07-01 at 01:52 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Make sure the delayed work stopped before releasing the resources.
>>
>> Because the cancel_delayed_work_sync() will only guarantee that the
>> work finishes executing if the work is already in the ->worklist.
>> That means after the cancel_delayed_work_sync() returns and in case
>> if the work will re-arm itself, it will leave the work requeued. And
>> if we release the resources before the delayed work to run again we
>> will hit the use-after-free bug.
>>
>> URL: https://tracker.ceph.com/issues/46293
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 14 +++++++++++++-
>>   1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index d5e523c..9a09d12 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4330,6 +4330,9 @@ static void delayed_work(struct work_struct *work)
>>   
>>   	dout("mdsc delayed_work\n");
>>   
>> +	if (mdsc->stopping)
>> +		return;
>> +
>>   	mutex_lock(&mdsc->mutex);
>>   	renew_interval = mdsc->mdsmap->m_session_timeout >> 2;
>>   	renew_caps = time_after_eq(jiffies, HZ*renew_interval +
>> @@ -4689,7 +4692,16 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
>>   static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
>>   {
>>   	dout("stop\n");
>> -	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
>> +	/*
>> +	 * Make sure the delayed work stopped before releasing
>> +	 * the resources.
>> +	 *
>> +	 * Because the cancel_delayed_work_sync() will only
>> +	 * guarantee that the work finishes executing. But the
>> +	 * delayed work will re-arm itself again after that.
>> +	 */
>> +	flush_delayed_work(&mdsc->delayed_work);
>> +
>>   	if (mdsc->mdsmap)
>>   		ceph_mdsmap_destroy(mdsc->mdsmap);
>>   	kfree(mdsc->sessions);
> This patch looks fine, but the subject says [PATCH 1/3]. Were there
> others in this series that didn't make it to the list for some reason?

Sorry for confusing.

Just generated this patch with the metrics series and forget to fix it 
before sending out.

BRs

Xiubo

> Thanks,


