Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009072EFD11
	for <lists+ceph-devel@lfdr.de>; Sat,  9 Jan 2021 03:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbhAICKU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Jan 2021 21:10:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726011AbhAICKT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 8 Jan 2021 21:10:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610158132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J4znwvWG8AkEa/gQQU2yaxrEkAcJA+G/v8w9dZvVq90=;
        b=EgBJs37IjJvXSSBSno2RRu0zmowPjwieeWoL17VTohlXcLOBOfyjozOcCnsueRhnxF+bAD
        q8uHrJTvsMRZ15kmDv0L62ger7MpdzrygslM2n4VA4hCh0YnpKZbGvTTQntOQRfczCYNTv
        rkd91jLig6zg5o2zNcfuzLxg/5Gy47U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-QZHn0Fk8NTKChskhHCeE0A-1; Fri, 08 Jan 2021 21:08:48 -0500
X-MC-Unique: QZHn0Fk8NTKChskhHCeE0A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF9BD1842140;
        Sat,  9 Jan 2021 02:08:46 +0000 (UTC)
Received: from [10.72.12.57] (ovpn-12-57.pek2.redhat.com [10.72.12.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C892A1754A;
        Sat,  9 Jan 2021 02:08:44 +0000 (UTC)
Subject: Re: [PATCH v2] ceph: defer flushing the capsnap if the Fb is used
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210107023051.119063-1-xiubli@redhat.com>
 <97ec811665eee254627c46d7999818fd94bab9ed.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d81773a1-e843-472d-5997-e53cedcfb7b3@redhat.com>
Date:   Sat, 9 Jan 2021 10:08:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <97ec811665eee254627c46d7999818fd94bab9ed.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/1/9 2:24, Jeff Layton wrote:
> On Thu, 2021-01-07 at 10:30 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If the Fb cap is used it means the client is flushing the dirty
>> data to OSD, just defer flushing the capsnap.
>>
>> URL: https://tracker.ceph.com/issues/48679
>> URL: https://tracker.ceph.com/issues/48640
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - Fix inode reference leak bug
>>
>>   fs/ceph/caps.c | 32 +++++++++++++++++++-------------
>>   fs/ceph/snap.c |  6 +++---
>>   2 files changed, 22 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index abbf48fc6230..2f2451d563bd 100644
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
>> @@ -3064,25 +3065,15 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>>   		if (--ci->i_wb_ref == 0) {
>>   			last++;
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
>> @@ -3094,6 +3085,21 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
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
>
> Ok, so let's assume you're putting Fb. You increment put and set
> check_flushsnaps to true. Later, you get down to here and call
> ceph_try_drop_cap_snap and it returns true and now you've incremented
> "put" twice.
>
> Is that right? Do Fb caps hold two inode references?

Yeah, one in ceph_take_cap_refs().

Another one is in ceph_queue_cap_snap() and when `used & (Fb | Fw)` is 
true, the flush capsnap will be delayed by holding the inode ref, so we 
need to put the inode ref here or in __ceph_finish_cap_snap().


> Either way, I think this function needs some better
> documentation/comments, particularly since you're making a significant
> change to how it works.

Okay, I will post the V3 after my back later to add more comments about 
this.

Thanks

>
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


