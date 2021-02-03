Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1641930D0A0
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Feb 2021 02:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhBCBHe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Feb 2021 20:07:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229696AbhBCBH0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Feb 2021 20:07:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612314358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Co4Nr5pHevEJOlYplGiroAjCM1nFwbnKRELN80CYOuc=;
        b=GszerxMZpzoLhPOaesrz5i/9NFFQ6SE6cDC2Y3GqCZ1Fz0A8ROxoYDGifwFbhSqHVVlmal
        RcpuZDvSGAePVf6GKTkz9dovZYbMcO84ICADL3EMiemjDCTajOmxi3E1OMbY8neD20vwfz
        KZsMb36QBC7Y2wZbwCH4CkQQTef9SO8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-QAL5jwsBOUWRyRG3gTddVQ-1; Tue, 02 Feb 2021 20:05:54 -0500
X-MC-Unique: QAL5jwsBOUWRyRG3gTddVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16F9C8030C0;
        Wed,  3 Feb 2021 01:05:53 +0000 (UTC)
Received: from [10.72.12.32] (ovpn-12-32.pek2.redhat.com [10.72.12.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 789EF50EDD;
        Wed,  3 Feb 2021 01:05:51 +0000 (UTC)
Subject: Re: [PATCH v4] ceph: defer flushing the capsnap if the Fb is used
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210202065453.814859-1-xiubli@redhat.com>
 <d260d1e6c379dd16168df73003daa88f875bd4d8.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <cc823610-bc7b-0ea8-303d-22edd84a15d7@redhat.com>
Date:   Wed, 3 Feb 2021 09:05:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <d260d1e6c379dd16168df73003daa88f875bd4d8.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/2/2 23:59, Jeff Layton wrote:
> On Tue, 2021-02-02 at 14:54 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If the Fb cap is used it means the current inode is flushing the
>> dirty data to OSD, just defer flushing the capsnap.
>>
>> URL: https://tracker.ceph.com/issues/48679
>> URL: https://tracker.ceph.com/issues/48640
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V4:
>> - Fix stuck issue when running the snaptest-git-ceph.sh pointed by Jeff.
>>
>> V3:
>> - Add more comments about putting the inode ref
>> - A small change about the code style
>>
>> V2:
>> - Fix inode reference leak bug
>>
>>
>>   fs/ceph/caps.c | 33 ++++++++++++++++++++-------------
>>   fs/ceph/snap.c | 10 ++++++++++
>>   2 files changed, 30 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index abbf48fc6230..570731c4d019 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -3047,6 +3047,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>>   {
>>   	struct inode *inode = &ci->vfs_inode;
>>   	int last = 0, put = 0, flushsnaps = 0, wake = 0;
>> +	bool check_flushsnaps = false;
>>   
>>
>>   	spin_lock(&ci->i_ceph_lock);
>>   	if (had & CEPH_CAP_PIN)
>> @@ -3063,26 +3064,17 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>>   	if (had & CEPH_CAP_FILE_BUFFER) {
>>   		if (--ci->i_wb_ref == 0) {
>>   			last++;
>> +			/* put the ref held by ceph_take_cap_refs() */
>>   			put++;
>> +			check_flushsnaps = true;
>>   		}
>>   		dout("put_cap_refs %p wb %d -> %d (?)\n",
>>   		     inode, ci->i_wb_ref+1, ci->i_wb_ref);
>>   	}
>> -	if (had & CEPH_CAP_FILE_WR)
>> +	if (had & CEPH_CAP_FILE_WR) {
>>   		if (--ci->i_wr_ref == 0) {
>>   			last++;
>> -			if (__ceph_have_pending_cap_snap(ci)) {
>> -				struct ceph_cap_snap *capsnap =
>> -					list_last_entry(&ci->i_cap_snaps,
>> -							struct ceph_cap_snap,
>> -							ci_item);
>> -				capsnap->writing = 0;
>> -				if (ceph_try_drop_cap_snap(ci, capsnap))
>> -					put++;
>> -				else if (__ceph_finish_cap_snap(ci, capsnap))
>> -					flushsnaps = 1;
>> -				wake = 1;
>> -			}
>> +			check_flushsnaps = true;
>>   			if (ci->i_wrbuffer_ref_head == 0 &&
>>   			    ci->i_dirty_caps == 0 &&
>>   			    ci->i_flushing_caps == 0) {
>> @@ -3094,6 +3086,21 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>>   			if (!__ceph_is_any_real_caps(ci) && ci->i_snap_realm)
>>   				drop_inode_snap_realm(ci);
>>   		}
>> +	}
>> +	if (check_flushsnaps && __ceph_have_pending_cap_snap(ci)) {
>> +		struct ceph_cap_snap *capsnap =
>> +			list_last_entry(&ci->i_cap_snaps,
>> +					struct ceph_cap_snap,
>> +					ci_item);
>> +
>> +		capsnap->writing = 0;
>> +		if (ceph_try_drop_cap_snap(ci, capsnap))
>> +			/* put the ref held by ceph_queue_cap_snap() */
>> +			put++;
>> +		else if (__ceph_finish_cap_snap(ci, capsnap))
>> +			flushsnaps = 1;
>> +		wake = 1;
>> +	}
>>   	spin_unlock(&ci->i_ceph_lock);
>>   
>>
>>   	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index b611f829cb61..0728b01d4d43 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -623,6 +623,16 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
>>   		return 0;
>>   	}
>>   
>>
>> +	/* Fb cap still in use, delay it */
>> +	if (ci->i_wb_ref) {
>> +		dout("finish_cap_snap %p cap_snap %p snapc %p %llu %s s=%llu "
>> +		     "used WRBUFFER, delaying\n", inode, capsnap,
>> +		     capsnap->context, capsnap->context->seq,
>> +		     ceph_cap_string(capsnap->dirty), capsnap->size);
>> +		capsnap->writing = 1;
>> +		return 0;
>> +	}
>> +
>>   	ci->i_ceph_flags |= CEPH_I_FLUSH_SNAPS;
>>   	dout("finish_cap_snap %p cap_snap %p snapc %p %llu %s s=%llu\n",
>>   	     inode, capsnap, capsnap->context,
> Much better. This one seems to behave better. I've gone ahead and taken
> this into testing branch.

Sure, thanks.

BRs

> Thanks!


