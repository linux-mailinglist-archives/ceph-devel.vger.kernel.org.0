Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624FB1E1A09
	for <lists+ceph-devel@lfdr.de>; Tue, 26 May 2020 05:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388571AbgEZDiq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 May 2020 23:38:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53925 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388497AbgEZDiq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 May 2020 23:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590464323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rx3mXT/dmDkiRX7oilk07cEsKZ/bHoqIyyBqNo5kDCU=;
        b=db5lcTkTSunwDE1kBKek8tO4SrQTvYdqNB8NDhus0jn5wc8lsgAlJwmRGrtjywOXIAdGBe
        +UNXwnpJWg+JYkWkslliY40Kn8bpLlCdZLg0fx63r1jjiI73IrUXG9VP2JIh+qNVv5Im/N
        ASFE7V/JmILKN7vEYpuWutux2/qJmp4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-m0YudxkaMDuWUFRAdqb-cg-1; Mon, 25 May 2020 23:38:41 -0400
X-MC-Unique: m0YudxkaMDuWUFRAdqb-cg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C033218FF661;
        Tue, 26 May 2020 03:38:40 +0000 (UTC)
Received: from [10.72.12.125] (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5EFF1CA;
        Tue, 26 May 2020 03:38:38 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] ceph: add ceph_async_put_cap_refs to avoid double
 lock and deadlock
To:     "Yan, Zheng" <zyan@redhat.com>, jlayton@kernel.org,
        idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <1590405385-27406-1-git-send-email-xiubli@redhat.com>
 <1590405385-27406-2-git-send-email-xiubli@redhat.com>
 <23e444d7-49f7-8c5e-f179-00354d4b9b68@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <06291af5-0b19-aee7-c802-9020ef0f931a@redhat.com>
Date:   Tue, 26 May 2020 11:38:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <23e444d7-49f7-8c5e-f179-00354d4b9b68@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/5/26 11:11, Yan, Zheng wrote:
> On 5/25/20 7:16 PM, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> In the ceph_check_caps() it may call the session lock/unlock stuff.
>>
>> There have some deadlock cases, like:
>> handle_forward()
>> ...
>> mutex_lock(&mdsc->mutex)
>> ...
>> ceph_mdsc_put_request()
>>    --> ceph_mdsc_release_request()
>>      --> ceph_put_cap_request()
>>        --> ceph_put_cap_refs()
>>          --> ceph_check_caps()
>> ...
>> mutex_unlock(&mdsc->mutex)
>>
>> And also there maybe has some double session lock cases, like:
>>
>> send_mds_reconnect()
>> ...
>> mutex_lock(&session->s_mutex);
>> ...
>>    --> replay_unsafe_requests()
>>      --> ceph_mdsc_release_dir_caps()
>>        --> ceph_put_cap_refs()
>>          --> ceph_check_caps()
>> ...
>> mutex_unlock(&session->s_mutex);
>>
>> URL: https://tracker.ceph.com/issues/45635
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c       | 29 +++++++++++++++++++++++++++++
>>   fs/ceph/inode.c      |  3 +++
>>   fs/ceph/mds_client.c | 12 +++++++-----
>>   fs/ceph/super.h      |  5 +++++
>>   4 files changed, 44 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 27c2e60..aea66c1 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -3082,6 +3082,35 @@ void ceph_put_cap_refs(struct ceph_inode_info 
>> *ci, int had)
>>           iput(inode);
>>   }
>>   +void ceph_async_put_cap_refs_work(struct work_struct *work)
>> +{
>> +    struct ceph_inode_info *ci = container_of(work, struct 
>> ceph_inode_info,
>> +                          put_cap_refs_work);
>> +    int caps;
>> +
>> +    spin_lock(&ci->i_ceph_lock);
>> +    caps = xchg(&ci->pending_put_caps, 0);
>> +    spin_unlock(&ci->i_ceph_lock);
>> +
>> +    ceph_put_cap_refs(ci, caps);
>> +}
>> +
>> +void ceph_async_put_cap_refs(struct ceph_inode_info *ci, int had)
>> +{
>> +    struct inode *inode = &ci->vfs_inode;
>> +
>> +    spin_lock(&ci->i_ceph_lock);
>> +    if (ci->pending_put_caps & had) {
>> +            spin_unlock(&ci->i_ceph_lock);
>> +        return;
>> +    }
>
> this will cause cap ref leak.

Ah, yeah, right.


>
> I thought about this again. all the trouble is caused by calling 
> ceph_mdsc_release_dir_caps() inside ceph_mdsc_release_request().

And also in ceph_mdsc_release_request() it is calling 
ceph_put_cap_refs() directly in other 3 places.

BRs

Xiubo

> We already call ceph_mdsc_release_dir_caps() in ceph_async_foo_cb() 
> for normal circumdtance. We just need to call 
> ceph_mdsc_release_dir_caps() in 'session closed' case (we never abort 
> async request). In the 'session closed' case, we can use 
> ceph_put_cap_refs_no_check_caps()
>
> Regards
> Yan, Zheng
>
>> +
>> +    ci->pending_put_caps |= had;
>> +    spin_unlock(&ci->i_ceph_lock);
>> +
>> +    queue_work(ceph_inode_to_client(inode)->inode_wq,
>> +           &ci->put_cap_refs_work);
>> +}
>>   /*
>>    * Release @nr WRBUFFER refs on dirty pages for the given @snapc snap
>>    * context.  Adjust per-snap dirty page accounting as appropriate.
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 357c937..303276a 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -517,6 +517,9 @@ struct inode *ceph_alloc_inode(struct super_block 
>> *sb)
>>       INIT_LIST_HEAD(&ci->i_snap_realm_item);
>>       INIT_LIST_HEAD(&ci->i_snap_flush_item);
>>   +    INIT_WORK(&ci->put_cap_refs_work, ceph_async_put_cap_refs_work);
>> +    ci->pending_put_caps = 0;
>> +
>>       INIT_WORK(&ci->i_work, ceph_inode_work);
>>       ci->i_work_mask = 0;
>>       memset(&ci->i_btime, '\0', sizeof(ci->i_btime));
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 0e0ab01..40b31da 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -811,12 +811,14 @@ void ceph_mdsc_release_request(struct kref *kref)
>>       if (req->r_reply)
>>           ceph_msg_put(req->r_reply);
>>       if (req->r_inode) {
>> -        ceph_put_cap_refs(ceph_inode(req->r_inode), CEPH_CAP_PIN);
>> +        ceph_async_put_cap_refs(ceph_inode(req->r_inode),
>> +                    CEPH_CAP_PIN);
>>           /* avoid calling iput_final() in mds dispatch threads */
>>           ceph_async_iput(req->r_inode);
>>       }
>>       if (req->r_parent) {
>> -        ceph_put_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
>> +        ceph_async_put_cap_refs(ceph_inode(req->r_parent),
>> +                    CEPH_CAP_PIN);
>>           ceph_async_iput(req->r_parent);
>>       }
>>       ceph_async_iput(req->r_target_inode);
>> @@ -831,8 +833,8 @@ void ceph_mdsc_release_request(struct kref *kref)
>>            * changed between the dir mutex being dropped and
>>            * this request being freed.
>>            */
>> -        ceph_put_cap_refs(ceph_inode(req->r_old_dentry_dir),
>> -                  CEPH_CAP_PIN);
>> + ceph_async_put_cap_refs(ceph_inode(req->r_old_dentry_dir),
>> +                    CEPH_CAP_PIN);
>>           ceph_async_iput(req->r_old_dentry_dir);
>>       }
>>       kfree(req->r_path1);
>> @@ -3398,7 +3400,7 @@ void ceph_mdsc_release_dir_caps(struct 
>> ceph_mds_request *req)
>>       dcaps = xchg(&req->r_dir_caps, 0);
>>       if (dcaps) {
>>           dout("releasing r_dir_caps=%s\n", ceph_cap_string(dcaps));
>> -        ceph_put_cap_refs(ceph_inode(req->r_parent), dcaps);
>> +        ceph_async_put_cap_refs(ceph_inode(req->r_parent), dcaps);
>>       }
>>   }
>>   diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 226f19c..01d206f 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -421,6 +421,9 @@ struct ceph_inode_info {
>>       struct timespec64 i_btime;
>>       struct timespec64 i_snap_btime;
>>   +    struct work_struct put_cap_refs_work;
>> +    int pending_put_caps;
>> +
>>       struct work_struct i_work;
>>       unsigned long  i_work_mask;
>>   @@ -1095,6 +1098,8 @@ extern void ceph_take_cap_refs(struct 
>> ceph_inode_info *ci, int caps,
>>                   bool snap_rwsem_locked);
>>   extern void ceph_get_cap_refs(struct ceph_inode_info *ci, int caps);
>>   extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
>> +extern void ceph_async_put_cap_refs(struct ceph_inode_info *ci, int 
>> had);
>> +extern void ceph_async_put_cap_refs_work(struct work_struct *work);
>>   extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, 
>> int nr,
>>                          struct ceph_snap_context *snapc);
>>   extern void ceph_flush_snaps(struct ceph_inode_info *ci,
>>
>

