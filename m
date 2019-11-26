Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9433E109BA6
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Nov 2019 11:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfKZKBX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Nov 2019 05:01:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38047 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727482AbfKZKBX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 05:01:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574762482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KlYWPTUW9NlxhMDd08Nj+WEjonkrD0WfqByi9UWdxGA=;
        b=X3hnixsUnzy4MvedA2D6znlIvintp1hJHC1SQvYUpeQ5YlV3LOrNe34n+K+nUbhd2p8N9b
        ov9rWWSVgmJe3ZDkRNJXb+wkauGUfAvacxWYsbzk2KbMZF6PfaYTmfcyTkZPRF0lVykI8l
        v0OyOV7mnsD1DsNLiXg6Sysejzc8aG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-OutyQKuUNDuQsnzaPknP4A-1; Tue, 26 Nov 2019 05:01:18 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8A511005055;
        Tue, 26 Nov 2019 10:01:16 +0000 (UTC)
Received: from [10.72.12.66] (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0313719C69;
        Tue, 26 Nov 2019 10:01:11 +0000 (UTC)
Subject: Re: [PATCH] ceph: trigger the reclaim work once there has enough
 pending caps
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20191126085114.40326-1-xiubli@redhat.com>
 <CAAM7YA=SAY-DQ5iUB-837=eC-ERV46_1_6Zi4SLNdD13_x4U4A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b0714ccd-4844-4b3e-24d4-d75e10bb6b08@redhat.com>
Date:   Tue, 26 Nov 2019 18:01:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAAM7YA=SAY-DQ5iUB-837=eC-ERV46_1_6Zi4SLNdD13_x4U4A@mail.gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: OutyQKuUNDuQsnzaPknP4A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/11/26 17:49, Yan, Zheng wrote:
> On Tue, Nov 26, 2019 at 4:57 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The nr in ceph_reclaim_caps_nr() is very possibly larger than 1,
>> so we may miss it and the reclaim work couldn't triggered as expected.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 08b70b5ee05e..547ffe16f91c 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -2020,7 +2020,7 @@ void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr)
>>          if (!nr)
>>                  return;
>>          val = atomic_add_return(nr, &mdsc->cap_reclaim_pending);
>> -       if (!(val % CEPH_CAPS_PER_RELEASE)) {
>> +       if (val / CEPH_CAPS_PER_RELEASE) {
>>                  atomic_set(&mdsc->cap_reclaim_pending, 0);
>>                  ceph_queue_cap_reclaim_work(mdsc);
>>          }
> this will call ceph_queue_cap_reclaim_work too frequently

No it won't, the '/' here equals to '>=' and then the 
"mdsc->cap_reclaim_pending" will be reset and it will increase from 0 again.

It will make sure that only when "mdsc->cap_reclaim_pending >= 
CEPH_CAPS_PER_RELEASE" will call the work queue.

>> --
>> 2.21.0
>>

