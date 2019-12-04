Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6DA112DB2
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2019 15:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfLDOqr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Dec 2019 09:46:47 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24330 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727887AbfLDOqr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Dec 2019 09:46:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575470805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8MpRUGvWPU8NVJcIt0G8DO59vuwIx6aN8LfptX2ZPA0=;
        b=Ge/BRl7wqyZL+vuk230b/ZAxfCiAlQjVT/yt7D4NM3aNffQerAAm8nO92FF8Cck92Gb7HC
        yg6vxtH7zUj1V0C/Ak1LOQSFdF4bswu4k66m+XXxUu3OjArMShR4hByWM/kR3133yD4oCV
        Hdr+UvseXKQUIM2pg9SF1FVAR7ef0JY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-PNzps1foOA-h4dGPR6eIjA-1; Wed, 04 Dec 2019 09:46:44 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E057800D4C;
        Wed,  4 Dec 2019 14:46:43 +0000 (UTC)
Received: from [10.72.12.69] (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C8425D6AE;
        Wed,  4 Dec 2019 14:46:34 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix possible long time wait during umount
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191204062718.56105-1-xiubli@redhat.com>
 <0cc3149a27bf6c64ba3a7b1530d623c68ed02531.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5f1117fa-10be-21a0-5c5e-32a2244ea228@redhat.com>
Date:   Wed, 4 Dec 2019 22:46:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <0cc3149a27bf6c64ba3a7b1530d623c68ed02531.camel@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: PNzps1foOA-h4dGPR6eIjA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/4 22:26, Jeff Layton wrote:
> On Wed, 2019-12-04 at 01:27 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> During umount, if there has no any unsafe request in the mdsc and
>> some requests still in-flight and not got reply yet, and if the
>> rest requets are all safe ones, after that even all of them in mdsc
>> are unregistered, the umount must wait until after mount_timeout
>> seconds anyway.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 163b470f3000..39f4d8501df5 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -2877,6 +2877,10 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>>   		set_bit(CEPH_MDS_R_GOT_SAFE, &req->r_req_flags);
>>   		__unregister_request(mdsc, req);
>>   
>> +		/* last request during umount? */
>> +		if (mdsc->stopping && !__get_oldest_req(mdsc))
>> +			complete_all(&mdsc->safe_umount_waiters);
>> +
>>   		if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags)) {
>>   			/*
>>   			 * We already handled the unsafe response, now do the
>> @@ -2887,9 +2891,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>>   			 */
>>   			dout("got safe reply %llu, mds%d\n", tid, mds);
>>   
>> -			/* last unsafe request during umount? */
>> -			if (mdsc->stopping && !__get_oldest_req(mdsc))
>> -				complete_all(&mdsc->safe_umount_waiters);
>>   			mutex_unlock(&mdsc->mutex);
>>   			goto out;
>>   		}
> Looks reasonable. AIUI, the MDS is free to send a safe reply without
> ever sending an unsafe one,

Yeah, that's the same from the test output.


>   so I don't see why we want to make that
> conditional on receiving an earlier unsafe reply.

 From the commit history I couldn't get why.

Thanks.

BRs


