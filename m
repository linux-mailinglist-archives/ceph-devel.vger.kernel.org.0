Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FB32EC800
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Jan 2021 03:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbhAGCRd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Jan 2021 21:17:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726260AbhAGCRc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Jan 2021 21:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609985765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EIgc48i2McQlMbYk2SYYHN06CXVa7WZcrqab/PqxkpY=;
        b=OlEek0LF9NK4qHFi0LyrQ8IhIq8WHFpBou+I1mG3hD6ofVcz8sZ2AAxtiutJsRbbkJWEEn
        T+ZmbL6r4fYs2+PEdSIND975fm55fzJQt6sxnNqWQORKpxbjN/X1GnIFQEu7eRP54remPU
        +bzHrKOozI3sPGjPM4epzJLZJgMqW6A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-pCR-QkPxMjWnXAAb1TF0mw-1; Wed, 06 Jan 2021 21:16:01 -0500
X-MC-Unique: pCR-QkPxMjWnXAAb1TF0mw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A65451005513;
        Thu,  7 Jan 2021 02:16:00 +0000 (UTC)
Received: from [10.72.12.116] (ovpn-12-116.pek2.redhat.com [10.72.12.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 168F15C1D1;
        Thu,  7 Jan 2021 02:15:58 +0000 (UTC)
Subject: Re: [PATCH] ceph: defer flushing the capsnap if the Fb is used
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210106014726.77614-1-xiubli@redhat.com>
 <cd2653125508e1f3eb0dcf423a04b76a1a8be5f3.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b4f37f09-bcb4-b3a1-eb69-82867af95424@redhat.com>
Date:   Thu, 7 Jan 2021 10:15:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <cd2653125508e1f3eb0dcf423a04b76a1a8be5f3.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/1/7 1:58, Jeff Layton wrote:
> On Wed, 2021-01-06 at 09:47 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If the Fb cap is used it means the client is flushing the dirty
>> data to OSD, just defer flushing the capsnap.
>>
>> URL: https://tracker.ceph.com/issues/48679
>> URL: https://tracker.ceph.com/issues/48640
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 33 +++++++++++++++++++--------------
>>   fs/ceph/snap.c |  6 +++---
>>   2 files changed, 22 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index abbf48fc6230..a61ca9183f41 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -3047,6 +3047,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>>   {
>>   	struct inode *inode = &ci->vfs_inode;
>>   	int last = 0, put = 0, flushsnaps = 0, wake = 0;
>> +	bool check_flushsnaps = false;
>>   
>>
>>
>>
>>   	spin_lock(&ci->i_ceph_lock);
>>   	if (had & CEPH_CAP_PIN)
>> @@ -3063,26 +3064,15 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>>   	if (had & CEPH_CAP_FILE_BUFFER) {
>>   		if (--ci->i_wb_ref == 0) {
>>   			last++;
>> -			put++;
>> +			check_flushsnaps = true;
>>   		}
> The "put" variable here is a counter of how many iputs need to be done
> at the end of this function. If you just set check_flushsnaps instead of
> incrementing "put", then you won't do an iput unless both
> __ceph_have_pending_cap_snap and ceph_try_drop_cap_snap both return
> true.
>
> In the case where you're not dealing with snapshots at all, is this
> going to cause an inode refcount leak?

Yeah, I misread the code, I just find the inode reference will be 
increased in "ceph_take_cap_refs()" for the "CEPH_CAP_FILE_BUFFER" cap.

I will fix it in V2.

Thanks.

>
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
>> @@ -3094,6 +3084,21 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>>   			if (!__ceph_is_any_real_caps(ci) && ci->i_snap_realm)
>>   				drop_inode_snap_realm(ci);
>>   		}
>> +	}
>> +	if (check_flushsnaps) {
>> +		if (__ceph_have_pending_cap_snap(ci)) {
>> +			struct ceph_cap_snap *capsnap =
>> +				list_last_entry(&ci->i_cap_snaps,
>> +						struct ceph_cap_snap,
>> +						ci_item);
>> +			capsnap->writing = 0;
>> +			if (ceph_try_drop_cap_snap(ci, capsnap))
>> +				put++;
>> +			else if (__ceph_finish_cap_snap(ci, capsnap))
>> +				flushsnaps = 1;
>> +			wake = 1;
>> +		}
>> +	}
>>   	spin_unlock(&ci->i_ceph_lock);
>>   
>>
>>
>>
>>   	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index b611f829cb61..639fb91cc9db 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -561,10 +561,10 @@ void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>>   	capsnap->context = old_snapc;
>>   	list_add_tail(&capsnap->ci_item, &ci->i_cap_snaps);
>>   
>>
>>
>>
>> -	if (used & CEPH_CAP_FILE_WR) {
>> +	if (used & (CEPH_CAP_FILE_WR | CEPH_CAP_FILE_BUFFER)) {
>>   		dout("queue_cap_snap %p cap_snap %p snapc %p"
>> -		     " seq %llu used WR, now pending\n", inode,
>> -		     capsnap, old_snapc, old_snapc->seq);
>> +		     " seq %llu used WR | BUFFFER, now pending\n",
>> +		     inode, capsnap, old_snapc, old_snapc->seq);
>>   		capsnap->writing = 1;
>>   	} else {
>>   		/* note mtime, size NOW. */


