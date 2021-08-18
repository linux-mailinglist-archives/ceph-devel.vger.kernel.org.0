Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B153EF77A
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 03:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhHRBVj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 21:21:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232410AbhHRBVi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 21:21:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629249662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TSISmaX8V6zU56Ti4OfmCMElCRLwkjnsKnmkqdAoUXE=;
        b=VcWNP1DkOfYy8Zxg0acN62zrvRy+eBvw5tQ+f8jHbnDQTATTyx8pWWrUlPcSD9fIxMjmkC
        tlgZywmud+E62qdXw457RplibKISsywDeVGVQ/xaeaSy4w76ZUzfkCSBcc0ghO0miyIv16
        TQTH3OIABbi+7XOBjGMcMDBIQusb20w=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-3SJte_9QPOGfb96QIeHL9Q-1; Tue, 17 Aug 2021 21:21:00 -0400
X-MC-Unique: 3SJte_9QPOGfb96QIeHL9Q-1
Received: by mail-pg1-f198.google.com with SMTP id t28-20020a63461c000000b00252078b83e4so366846pga.15
        for <ceph-devel@vger.kernel.org>; Tue, 17 Aug 2021 18:21:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TSISmaX8V6zU56Ti4OfmCMElCRLwkjnsKnmkqdAoUXE=;
        b=pz7/M+YbmBWR+XMIfcM25PaICYvQBjHI37unO8N6q0D2OSWBljBM3uAw+0gwBOlEu5
         ZFm3GjPVj5fPGJXrP3c85wcW5PVMTk049i1lEt2Bpvl+R4XUaD8FIwyOGVyzUCbfR/GU
         GImzV4+ipz6KdN1SIyfTlNntb6wMKDtZq2vlk1MjUQDiFySJ0CTegThku7Uoyn10Kq4X
         LdBMcEuHGndpCTZ50HqaHUXa1xlOIa0oOpGg9TgToqfUgW8REy5n7VoaHFwRX+jJIAi1
         D7ujGMIEXkNLNvEqgJmQ8DXZx5stw/9Tn2spK+CKaYYlc52bpWmFb9v/1uw/xNEJPT4I
         9rRw==
X-Gm-Message-State: AOAM532r7ByE8YSIRqrfwJyvrYqljYKitZTqYhNXTZagDI8sCiz7PN+3
        tDYcG2hmCpymgZQ6aqD66dEI8Fz2EhjF0ntwiPX37jZr43553BUdVI9dUcsX4OoK+YJaUBV/0WZ
        bBkMitYZGNH2hrbr3fPY/RoszAvGpE8iIZXbn3mJkbppglcypcjxXsfq7N8TFcOPPX1c21J0=
X-Received: by 2002:a62:6242:0:b029:3c6:5a66:c8f2 with SMTP id w63-20020a6262420000b02903c65a66c8f2mr6495329pfb.59.1629249659545;
        Tue, 17 Aug 2021 18:20:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrqk+V+km7d/6Kx49Ax7bXtN6Ktj2l8+q8JFkQlvdqoOl/WgefBgNl1e/u+W8EufyYnFqVWQ==
X-Received: by 2002:a62:6242:0:b029:3c6:5a66:c8f2 with SMTP id w63-20020a6262420000b02903c65a66c8f2mr6495301pfb.59.1629249659215;
        Tue, 17 Aug 2021 18:20:59 -0700 (PDT)
Received: from [10.72.12.44] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m23sm3125039pjr.38.2021.08.17.18.20.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 18:20:58 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: try to reconnect to the export targets
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210817034445.405663-1-xiubli@redhat.com>
 <35529e08cdad0bca25be41658bdc4b5b1ab81d28.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <cc045aa9-85b9-8efa-4c65-3e1359153e3a@redhat.com>
Date:   Wed, 18 Aug 2021 09:20:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <35529e08cdad0bca25be41658bdc4b5b1ab81d28.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/18/21 12:18 AM, Jeff Layton wrote:
> On Tue, 2021-08-17 at 11:44 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> In case the export MDS is crashed just after the EImportStart journal
>> is flushed, so when a standby MDS takes over it and when replaying
>> the EImportStart journal the MDS will wait the client to reconnect,
>> but the client may never register/open the sessions yet.
>>
>> We will try to reconnect that MDSes if they're in the export targets
>> and in RECONNECT state.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> - check the export target rank when decoding the mdsmap instead of
>> BUG_ON
>> - fix issue that the sessions have been opened during the mutex's
>> unlock/lock gap
>>
>>
>>   fs/ceph/mds_client.c | 63 +++++++++++++++++++++++++++++++++++++++++++-
>>   fs/ceph/mdsmap.c     | 10 ++++---
>>   2 files changed, 69 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index e49dbeb6c06f..1e013fb09d73 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4197,13 +4197,22 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>>   			  struct ceph_mdsmap *newmap,
>>   			  struct ceph_mdsmap *oldmap)
>>   {
>> -	int i;
>> +	int i, err;
>> +	int *export_targets;
>>   	int oldstate, newstate;
>>   	struct ceph_mds_session *s;
>> +	struct ceph_mds_info *m_info;
>>   
>>   	dout("check_new_map new %u old %u\n",
>>   	     newmap->m_epoch, oldmap->m_epoch);
>>   
>> +	m_info = newmap->m_info;
>> +	export_targets = kcalloc(newmap->possible_max_rank, sizeof(int), GFP_NOFS);
> This allocation could fail under low-memory conditions, particularly
> since it's GFP_NOFS. One idea would be to make this function return int
> so you can just return -ENOMEM if the allocation fails.
>
> Is there a hard max to possible_max_rank? If so and it's not that big,
> then another possibility would be to just declare this array on the
> stack.
>
> Also, since this is just used as a flag, making an array of bools would
> reduce the size of the allocation by a factor of 4.

I think the CEPH_MAX_MDS is, it's 0x100. I will try the bitmap on the stack.



>> +	if (export_targets && m_info) {
>> +		for (i = 0; i < m_info->num_export_targets; i++)
>> +			export_targets[m_info->export_targets[i]] = 1;
>> +	}
>> +
> If you reverse the sense of the flags then you wouldn't need to
> initialize the array at all (assuming you still use kcalloc).

For example the size of the export_targets array is 100, and the 
num_export_target is 1 and the m_info->export_targets[0] is 7, then we 
must clear all the other 99 flags one by one ?


>
>>   	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>>   		if (!mdsc->sessions[i])
>>   			continue;
>> @@ -4257,6 +4266,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>>   		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
>>   		    newstate >= CEPH_MDS_STATE_RECONNECT) {
>>   			mutex_unlock(&mdsc->mutex);
>> +			if (export_targets)
>> +				export_targets[i] = 0;
>>   			send_mds_reconnect(mdsc, s);
>>   			mutex_lock(&mdsc->mutex);
>>   		}
>> @@ -4279,6 +4290,54 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>>   		}
>>   	}
>>   
>> +	/*
>> +	 * Only open and reconnect sessions that don't exist yet.
>> +	 */
>> +	for (i = 0; i < newmap->possible_max_rank; i++) {
>> +		if (unlikely(!export_targets))
>> +			break;
>> +
>> +		/*
>> +		 * In case the import MDS is crashed just after
>> +		 * the EImportStart journal is flushed, so when
>> +		 * a standby MDS takes over it and is replaying
>> +		 * the EImportStart journal the new MDS daemon
>> +		 * will wait the client to reconnect it, but the
>> +		 * client may never register/open the session yet.
>> +		 *
>> +		 * Will try to reconnect that MDS daemon if the
>> +		 * rank number is in the export_targets array and
>> +		 * is the up:reconnect state.
>> +		 */
>> +		newstate = ceph_mdsmap_get_state(newmap, i);
>> +		if (!export_targets[i] || newstate != CEPH_MDS_STATE_RECONNECT)
>> +			continue;
>> +
>> +		/*
>> +		 * The session maybe registered and opened by some
>> +		 * requests which were choosing random MDSes during
>> +		 * the mdsc->mutex's unlock/lock gap below in rare
>> +		 * case. But the related MDS daemon will just queue
>> +		 * that requests and be still waiting for the client's
>> +		 * reconnection request in up:reconnect state.
>> +		 */
>> +		s = __ceph_lookup_mds_session(mdsc, i);
>> +		if (likely(!s)) {
>> +			s = __open_export_target_session(mdsc, i);
>> +			if (IS_ERR(s)) {
>> +				err = PTR_ERR(s);
>> +				pr_err("failed to open export target session, err %d\n",
>> +				       err);
>> +				continue;
>> +			}
>> +		}
>> +		dout("send reconnect to export target mds.%d\n", i);
>> +		mutex_unlock(&mdsc->mutex);
>> +		send_mds_reconnect(mdsc, s);
>> +		mutex_lock(&mdsc->mutex);
>> +		ceph_put_mds_session(s);
> You can put the mds session before you re-take the mutex.

Will fix it.

Thanks


