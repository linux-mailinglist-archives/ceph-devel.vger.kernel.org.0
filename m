Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5822FABA6
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Jan 2021 21:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388346AbhARKgw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Jan 2021 05:36:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42480 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388494AbhARJQ3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 18 Jan 2021 04:16:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610961300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jLhF9w9+aKkcqwkuEudMpLh/G4t/5zGyYhNSMg5g2pQ=;
        b=YOHfBvZI2HmsbVEzvrUwjPBLFUpipuX1xaxL8UQUbNf31LUBmnJ0gsPeXgIvDxwQs4H0Kx
        H0ehymLat+t2GLpvvMQr0IiEKuzyqn9T/3qC5qTikpC4i61q84b8G9qT8yoSeN/8K0SE1x
        gOqwKNs8XxVUmYSPIyWz2bg9G3zglfY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-Ynkkr-rzN4OdDpCmyLHksg-1; Mon, 18 Jan 2021 04:10:53 -0500
X-MC-Unique: Ynkkr-rzN4OdDpCmyLHksg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DED441005513;
        Mon, 18 Jan 2021 09:10:52 +0000 (UTC)
Received: from [10.72.12.125] (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59CFD17511;
        Mon, 18 Jan 2021 09:10:51 +0000 (UTC)
Subject: Re: [PATCH v3] ceph: defer flushing the capsnap if the Fb is used
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210110020140.141727-1-xiubli@redhat.com>
 <f698d039251d444eec334b119b5ae0b0dd101a21.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <376245cf-a60d-6ddb-6ab3-894a491b854e@redhat.com>
Date:   Mon, 18 Jan 2021 17:10:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <f698d039251d444eec334b119b5ae0b0dd101a21.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/1/13 5:48, Jeff Layton wrote:
> On Sun, 2021-01-10 at 10:01 +0800, xiubli@redhat.com wrote:
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
>> V3:
>> - Add more comments about putting the inode ref
>> - A small change about the code style
>>
>> V2:
>> - Fix inode reference leak bug
>>
>>   fs/ceph/caps.c | 32 +++++++++++++++++++-------------
>>   fs/ceph/snap.c |  6 +++---
>>   2 files changed, 22 insertions(+), 16 deletions(-)
>>
> Hi Xiubo,
>
> This patch seems to cause hangs in some xfstests (generic/013, in
> particular). I'll take a closer look when I have a chance, but I'm
> dropping this for now.

Okay.

BTW, what's your test commands to reproduce it ? I will take a look when 
I am free these days or later.

BRs

>
> -- Jeff
>
>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index abbf48fc6230..b00234cf3b04 100644
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
>> @@ -3094,6 +3086,20 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>>   			if (!__ceph_is_any_real_caps(ci) && ci->i_snap_realm)
>>   				drop_inode_snap_realm(ci);
>>   		}
>> +	}
>> +	if (check_flushsnaps && __ceph_have_pending_cap_snap(ci)) {
>> +		struct ceph_cap_snap *capsnap =
>> +			list_last_entry(&ci->i_cap_snaps,
>> +					struct ceph_cap_snap,
>> +					ci_item);
>> +		capsnap->writing = 0;
>> +		if (ceph_try_drop_cap_snap(ci, capsnap))
>> +		        /* put the ref held by ceph_queue_cap_snap() */
>> +			put++;
>> +		else if (__ceph_finish_cap_snap(ci, capsnap))
>> +			flushsnaps = 1;
>> +		wake = 1;
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


