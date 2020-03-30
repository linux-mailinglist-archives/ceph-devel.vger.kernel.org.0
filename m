Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A965197E4A
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Mar 2020 16:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgC3O0V (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Mar 2020 10:26:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:56021 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727899AbgC3O0U (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 10:26:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585578379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DEoy3dDsCnY20mT2yXwbwWhftAa6CAo36uv/yHUug5E=;
        b=MKB+4C3OScUOUjM2kDzOPGV0mM/YckCBN9eNOWxIR9R1DXEGqSEwXprBtlVfk920tnqDl3
        Fkl4PCnkRinURsCqlbjaqO5EXyIUYc5SAaKhxQmJdKqSty9Qkggoen+s4yEsexM2JwFr57
        oHrxOUxzbxwAAPPTVltzrpXgrCQfDaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-u47Yv6FrORu70esMUDjqZw-1; Mon, 30 Mar 2020 10:26:15 -0400
X-MC-Unique: u47Yv6FrORu70esMUDjqZw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2820800D50;
        Mon, 30 Mar 2020 14:26:14 +0000 (UTC)
Received: from [10.72.12.143] (ovpn-12-143.pek2.redhat.com [10.72.12.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 262D097B1C;
        Mon, 30 Mar 2020 14:26:12 +0000 (UTC)
Subject: Re: [PATCH] ceph: reset i_requested_max_size if file write is not
 wanted
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20200330115637.31019-1-zyan@redhat.com>
 <49fe2d9a5956346af46fb4ce37ccc0c8c35185e2.camel@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <1d8f55c9-4d51-6b06-7052-9ce088057e9c@redhat.com>
Date:   Mon, 30 Mar 2020 22:26:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <49fe2d9a5956346af46fb4ce37ccc0c8c35185e2.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 3/30/20 10:00 PM, Jeff Layton wrote:
> On Mon, 2020-03-30 at 19:56 +0800, Yan, Zheng wrote:
>> write can stuck at waiting for larger max_size in following sequence of
>> events:
>>
>> - client opens a file and writes to position 'A' (larger than unit of
>>    max size increment)
>> - client closes the file handle and updates wanted caps (not wanting
>>    file write caps)
>> - client opens and truncates the file, writes to position 'A' again.
>>
>> At the 1st event, client set inode's requested_max_size to 'A'. At the
>> 2nd event, mds removes client's writable range, but client does not reset
>> requested_max_size. At the 3rd event, client does not request max size
>> because requested_max_size is already larger than 'A'.
>>
>> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>> ---
>>   fs/ceph/caps.c | 29 +++++++++++++++++++----------
>>   1 file changed, 19 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index f8b51d0c8184..61808793e0c0 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1363,8 +1363,12 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
>>   	arg->size = inode->i_size;
>>   	ci->i_reported_size = arg->size;
>>   	arg->max_size = ci->i_wanted_max_size;
>> -	if (cap == ci->i_auth_cap)
>> -		ci->i_requested_max_size = arg->max_size;
>> +	if (cap == ci->i_auth_cap) {
>> +		if (want & CEPH_CAP_ANY_FILE_WR)
>> +			ci->i_requested_max_size = arg->max_size;
>> +		else
>> +			ci->i_requested_max_size = 0;
>> +	}
>>   
>>   	if (flushing & CEPH_CAP_XATTR_EXCL) {
>>   		arg->old_xattr_buf = __ceph_build_xattrs_blob(ci);
>> @@ -3343,10 +3347,6 @@ static void handle_cap_grant(struct inode *inode,
>>   				ci->i_requested_max_size = 0;
>>   			}
>>   			wake = true;
>> -		} else if (ci->i_wanted_max_size > ci->i_max_size &&
>> -			   ci->i_wanted_max_size > ci->i_requested_max_size) {
>> -			/* CEPH_CAP_OP_IMPORT */
>> -			wake = true;
>>   		}
>>   	}
>>   
>> @@ -3422,9 +3422,18 @@ static void handle_cap_grant(struct inode *inode,
>>   			fill_inline = true;
>>   	}
>>   
>> -	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
>> +	if (ci->i_auth_cap == cap &&
>> +	    le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
>>   		if (newcaps & ~extra_info->issued)
>>   			wake = true;
>> +
>> +		if (ci->i_requested_max_size > max_size ||
>> +		    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
>> +			/* re-request max_size if necessary */
>> +			ci->i_requested_max_size = 0;
>> +			wake = true;
>> +		}
>> +
>>   		ceph_kick_flushing_inode_caps(session, ci);
>>   		spin_unlock(&ci->i_ceph_lock);
>>   		up_read(&session->s_mdsc->snap_rwsem);
>> @@ -3882,9 +3891,6 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
>>   		__ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
>>   	}
>>   
>> -	/* make sure we re-request max_size, if necessary */
>> -	ci->i_requested_max_size = 0;
>> -
>>   	*old_issued = issued;
>>   	*target_cap = cap;
>>   }
>> @@ -4318,6 +4324,9 @@ int ceph_encode_inode_release(void **p, struct inode *inode,
>>   				cap->issued &= ~drop;
>>   				cap->implemented &= ~drop;
>>   				cap->mds_wanted = wanted;
>> +				if (cap == ci->i_auth_cap &&
>> +				    !(wanted & CEPH_CAP_ANY_FILE_WR))
>> +					ci->i_requested_max_size = 0;
>>   			} else {
>>   				dout("encode_inode_release %p cap %p %s"
>>   				     " (force)\n", inode, cap,
> 
> Thanks Zheng. I assume this is a regression in the "don't request caps
> for idle open files" series? If so, is there a commit that definitively
> broke it? It'd be good to add a Fixes: tag for that if we can to help
> backporters.
> 
> Thanks,
> 

It's not regression. It' kclient version of 
https://tracker.ceph.com/issues/44801. I only saw this bug in ceph-fuse, 
kclient contain this bug in theory.

