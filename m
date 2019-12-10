Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3CB117DE8
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Dec 2019 03:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfLJCpv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Dec 2019 21:45:51 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32898 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbfLJCpv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Dec 2019 21:45:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575945949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TsWHK0+X8USyffzaB2NeZDLX+CwnWEptVPj1Iof7FyM=;
        b=S48eXpdD4TvswfG3Qb49HEn23tQyu279u8H3Tk5YNiaMdMRvb6eOtJIXwZVwiNPwtQ+avR
        Mtkcrmc9ZZVw0WlEzaodtg2NJhGJA7SZz50Qn/YVJuFFPn1w8RSoqSRvnjzU/f1/EDlh/Q
        a98nl9BBZyK4i3BR0o7WKeANwVyZicU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-np8El5ECN1SVXUDmoUuMgg-1; Mon, 09 Dec 2019 21:45:48 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5158C800EB7;
        Tue, 10 Dec 2019 02:45:47 +0000 (UTC)
Received: from [10.72.12.181] (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BBD31001B07;
        Tue, 10 Dec 2019 02:45:42 +0000 (UTC)
Subject: Re: [PATCH] ceph: clean the dirty page when session is closed or
 rejected
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191209092830.22157-1-xiubli@redhat.com>
 <3db8af6d73324694035532611036d8bc5e3d9921.camel@kernel.org>
 <0d3d8008-f675-431d-0eb4-f064ea88aa5c@redhat.com>
 <c8fff676999dfc43321ae5e73eda9d958ca3ea89.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <23070bf1-eac1-c37e-5b92-cb5f68561517@redhat.com>
Date:   Tue, 10 Dec 2019 10:45:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <c8fff676999dfc43321ae5e73eda9d958ca3ea89.camel@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: np8El5ECN1SVXUDmoUuMgg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/9 20:46, Jeff Layton wrote:
> On Mon, 2019-12-09 at 19:54 +0800, Xiubo Li wrote:
>> On 2019/12/9 19:38, Jeff Layton wrote:
>>> On Mon, 2019-12-09 at 04:28 -0500, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> Try to queue writeback and invalidate the dirty pages when sessions
>>>> are closed, rejected or reconnect denied.
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/mds_client.c | 13 +++++++++++++
>>>>    1 file changed, 13 insertions(+)
>>>>
>>> Can you explain a bit more about the problem you're fixing? In what
>>> situation is this currently broken, and what are the effects of that
>>> breakage?
>>>
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index be1ac9f8e0e6..68f3b5ed6ac8 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -1385,9 +1385,11 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>>>    {
>>>>    	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
>>>>    	struct ceph_inode_info *ci = ceph_inode(inode);
>>>> +	struct ceph_mds_session *session = cap->session;
>>>>    	LIST_HEAD(to_remove);
>>>>    	bool dirty_dropped = false;
>>>>    	bool invalidate = false;
>>>> +	bool writeback = false;
>>>>    
>>>>    	dout("removing cap %p, ci is %p, inode is %p\n",
>>>>    	     cap, ci, &ci->vfs_inode);
>>>> @@ -1398,12 +1400,21 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>>>    	if (!ci->i_auth_cap) {
>>>>    		struct ceph_cap_flush *cf;
>>>>    		struct ceph_mds_client *mdsc = fsc->mdsc;
>>>> +		int s_state = session->s_state;
>>>>    
>>>>    		if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
>>>>    			if (inode->i_data.nrpages > 0)
>>>>    				invalidate = true;
>>>>    			if (ci->i_wrbuffer_ref > 0)
>>>>    				mapping_set_error(&inode->i_data, -EIO);
>>>> +		} else if (s_state == CEPH_MDS_SESSION_CLOSED ||
>>>> +			   s_state == CEPH_MDS_SESSION_REJECTED) {
>>>> +			/* reconnect denied or rejected */
>>>> +			if (!__ceph_is_any_real_caps(ci) &&
>>>> +			    inode->i_data.nrpages > 0)
>>>> +				invalidate = true;
>>>> +			if (ci->i_wrbuffer_ref > 0)
>>>> +				writeback = true;
>>> I don't know here. If the session is CLOSED/REJECTED, is kicking off
>>> writeback the right thing to do? In principle, this means that the
>>> client may have been blacklisted and none of the writes will succeed.
>> If the client was blacklisted,  it will be not safe to still buffer the
>> data and flush it after the related sessions are reconnected without
>> remounting.
>>
>> Maybe we need to throw it directly.
>>
>>
> It depends. We have tunable behavior for this now.
>
> I think you may want to look over the recover_session= patches  that
> were merged v5.4 ((131d7eb4faa1fc, and previous patches). That mount
> option governs what happens if the client is blacklisted, and then the
> blacklisting is later removed.

Yeah, I checked that patches before and from my test of the blacklist 
stuff, the kclient's sessions won't recovery automatically even after 
the kclient is removed from the blacklisting. And the kclient will force 
remount after 30 minutes if recover_session=clean.

After a session is rejected due to blacklisting, the handle_session(case 
CEPH_MDS_SESSION_REJECTED: ) will requeue some inflight requests of this 
session, but these requests or the new requests couldn't use the 
rejected session, because the session->blacklisted=true could only be 
cleaned in the recovery_session=clean code until 30 minutes timedout, as 
default with recovery_session=no the session maybe keep 
session->blacklisted for ever (?), then I must do the remount manually.

I may not totally understand the purpose of the recovery_session= 
patches and I may miss something important here.

 From the https://docs.ceph.com/docs/master/cephfs/eviction/, maybe we 
could just throw away the dirty pages of the sessions directly, so after 
reconnected we can make sure it is safe without any stale buffered data.


Thanks.

> Will this patch change either recover_session= behavior? If so, then you
> should explain how and why.
>
>
>>>>    		}
>>>>    
>>>>    		while (!list_empty(&ci->i_cap_flush_list)) {
>>>> @@ -1472,6 +1483,8 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>>>    	}
>>>>    
>>>>    	wake_up_all(&ci->i_cap_wq);
>>>> +	if (writeback)
>>>> +		ceph_queue_writeback(inode);
>>>>    	if (invalidate)
>>>>    		ceph_queue_invalidate(inode);
>>>>    	if (dirty_dropped)
>>> Thanks,
>>

