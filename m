Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7873EE4BD
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 05:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbhHQDDu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Aug 2021 23:03:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236991AbhHQDDt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 23:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629169396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XiR5BwS1Npv1c1i/dcPNHykNfat7MPyyx33UUiA6rjE=;
        b=dcjnZa9sGG5bdhYkfpcyUw1enCBqGtzNGZjMkrB+kOOHx+32isL7WL/xQPkNsy5eE99vIk
        y0oH5rvozU/ZyoHIakn7RxrSEM74/7l6Y11Z8V3B4quDsHdzNH0IqJsMo9i6Y9vfJT/+mu
        bi0bWz5BddIzaB3i+MpcywVc8c7eZbs=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-jST0BuWcOi-R9Ltg6BV0hg-1; Mon, 16 Aug 2021 23:03:15 -0400
X-MC-Unique: jST0BuWcOi-R9Ltg6BV0hg-1
Received: by mail-pj1-f69.google.com with SMTP id s8-20020a17090a0748b0290177ecd83711so1713877pje.2
        for <ceph-devel@vger.kernel.org>; Mon, 16 Aug 2021 20:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=XiR5BwS1Npv1c1i/dcPNHykNfat7MPyyx33UUiA6rjE=;
        b=meUQykd6B0+i0rKxy7aSL6MueMGkHIbY3e8E65ezCKfVK5vG1IevVs0kqwaPAkfa6T
         3mMqCxvWfFEjyAotTYZ2Crrae5FghOCMGX8YcP3QcpLOvedxMhz3TWKIInWO5qFijleZ
         5w19LYzqFI36NqL61DwMAl5F60G5vkuU/6iyjx5dxBVLIrJ+9EpulBFCgWfAp3fObYbK
         O2OfmQUtbWhZag5RdWqk6GT9Y2pKoZU5x4/WZj1VnOkU710x7IVSCAKkGcEMJeEaELTo
         aTtdrHCJJmBGkpN/FRmlO1vaeh0fNmAWy1pPWq9mgwAtX2ECim6qAIoSVUhceMcaKh1+
         klow==
X-Gm-Message-State: AOAM530l64zJ4XwxJkAakxB6QSmdwG6OxkURs4EYceEiU9kF/f6BzqWa
        e+OHJJSlPMYdRbD2z7xFeZPttK9UpQkaJIWqfjcmYkXRSkV14VK1eP7XZUdYUfg3WRiPVQ6M9Uy
        14bZ6dBAtKr8Ccv4OJaEGU18CEHnvwKeD/qnEJG4JGi9VcSAcwuSY9NfqKGC/PL7NVmB7eEc=
X-Received: by 2002:a05:6a00:1c5d:b029:3e0:6fb9:1de4 with SMTP id s29-20020a056a001c5db02903e06fb91de4mr1377940pfw.21.1629169393716;
        Mon, 16 Aug 2021 20:03:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygLc2s0E/q7RmI4N8ovoijkIopRWslnUy1Mhii+21MYbJPXX8sBSHQYoRHCxD6tdpkEEA7hQ==
X-Received: by 2002:a05:6a00:1c5d:b029:3e0:6fb9:1de4 with SMTP id s29-20020a056a001c5db02903e06fb91de4mr1377905pfw.21.1629169393378;
        Mon, 16 Aug 2021 20:03:13 -0700 (PDT)
Received: from [10.72.12.44] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d14sm426552pjc.0.2021.08.16.20.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 20:03:13 -0700 (PDT)
Subject: Re: [PATCH] ceph: try to reconnect to the export targets
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210812041042.132984-1-xiubli@redhat.com>
 <bc940c0fe07921d6e63b4a2316e93d84c96da201.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e417a201-ae99-5c49-1a71-a10009107b1c@redhat.com>
Date:   Tue, 17 Aug 2021 11:03:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <bc940c0fe07921d6e63b4a2316e93d84c96da201.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/16/21 8:05 PM, Jeff Layton wrote:
> On Thu, 2021-08-12 at 12:10 +0800, xiubli@redhat.com wrote:
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
>>   fs/ceph/mds_client.c | 58 +++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 57 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 14e44de05812..7dfe7a804320 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4182,13 +4182,24 @@ static void check_new_map(struct ceph_mds_client *mdsc,
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
>> +	if (export_targets && m_info) {
>> +		for (i = 0; i < m_info->num_export_targets; i++) {
>> +			BUG_ON(m_info->export_targets[i] >= newmap->possible_max_rank);
> In general, we shouldn't BUG() in response to bad info sent by the MDS.
> It would probably be better to check these values in
> ceph_mdsmap_decode() and return an error there if it doesn't look right.
> That way we can just toss out the new map instead of crashing.

Sound reasonable, will fix it.


>> +			export_targets[m_info->export_targets[i]] = 1;
>> +		}
>> +	}
>> +
>>   	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>>   		if (!mdsc->sessions[i])
>>   			continue;
>> @@ -4242,6 +4253,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>>   		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
>>   		    newstate >= CEPH_MDS_STATE_RECONNECT) {
>>   			mutex_unlock(&mdsc->mutex);
>> +			if (export_targets)
>> +				export_targets[i] = 0;
>>   			send_mds_reconnect(mdsc, s);
>>   			mutex_lock(&mdsc->mutex);
>>   		}
>> @@ -4264,6 +4277,47 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>>   		}
>>   	}
>>   
>> +	for (i = 0; i < newmap->possible_max_rank; i++) {
> The condition on this loop is slightly different from the one below it,
> and I'm not sure why. Should this also be checking this?
>
>      i < newmap->possible_max_rank && i < mdsc->max_sessions
>
> ...do we need to look at export targets where i >= mdsc->max_sessions ?

No, in this loop I am skipping that check on purpose.

Because just after the importing MDS daemon received the export info it 
will save this info in EImportStart journal and force to open the 
related client sessions, but this force open is only doing the 
preparation to open the session in the importing MDS daemon and then 
journal the sessions info, but won't establish the connections with the 
clients immediately until the clients to connect it seconds later, so if 
the importing MDS crashes before that in the clients may have no record 
in the mdsc->sessions[] for those sessions.

 From my tests in new mdsmap the rank numbers in export_targets maybe 
larger than mdsc->max_sessions.

When a standby MDS is replaying that sessions journal, it will restore 
those sessions state and wait the clients to reconnect them. And in this 
loop we only need to establish the connections for those sessions not in 
the mdsc->sessions[] yet.


>> +		if (!export_targets)
>> +			break;
>> +
>> +		/*
>> +		 * Only open and reconnect sessions that don't
>> +		 * exist yet.
>> +		 */
>> +		if (!export_targets[i] || __have_session(mdsc, i))
>> +			continue;
>> +
>> +		/*
>> +		 * In case the export MDS is crashed just after
>> +		 * the EImportStart journal is flushed, so when
>> +		 * a standby MDS takes over it and is replaying
>> +		 * the EImportStart journal the new MDS daemon
>> +		 * will wait the client to reconnect it, but the
>> +		 * client may never register/open the sessions
>> +		 * yet.
>> +		 *
>> +		 * It will try to reconnect that MDS daemons if
>> +		 * the MDSes are in the export targets and is the
>> +		 * RECONNECT state.
>> +		 */
>> +		newstate = ceph_mdsmap_get_state(newmap, i);
>> +		if (newstate != CEPH_MDS_STATE_RECONNECT)
>> +			continue;
>> +		s = __open_export_target_session(mdsc, i);
>> +		if (IS_ERR(s)) {
>> +			err = PTR_ERR(s);
>> +			pr_err("failed to open export target session, err %d\n",
>> +			       err);
>> +			continue;
>> +		}
>> +		dout("send reconnect to target mds.%d\n", i);
>> +		mutex_unlock(&mdsc->mutex);
>> +		send_mds_reconnect(mdsc, s);
>> +		mutex_lock(&mdsc->mutex);
>> +		ceph_put_mds_session(s);
> Suppose we end up in this part of the code, and we have to drop the
> mdsc->mutex like this. What ensures that an earlier session in the array
> won't end up going back into CEPH_MDS_STATE_RECONNECT before we can get
> into the loop below? This looks racy.

I am not sure I'm totally understanding this.

If my understanding it correct, you may mean:

The session maybe registered and opened by some requests which are 
choosing random MDSes during the mdsc->mutex's unlock/lock gap in the 
loop above.

If so I can fix it by not checking the '__have_session(mdsc, i)' and try 
to get the existing sessions, if exists then just reconnect it, if not 
then register-->open-->reconnect it.


The following loop will only try to open the sessions for the laggy 
MDSes, which haven't been replaced by the standby ones, once a specific 
rank is replaced by a standby MDS it shouldn't be in the laggy state. So 
once a rank has been handled in above reconnect loop, it shouldn't be in 
the following loop.

Thanks


>
>> +	}
>> +
>>   	for (i = 0; i < newmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>>   		s = mdsc->sessions[i];
>>   		if (!s)
>> @@ -4278,6 +4332,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>>   			__open_export_target_sessions(mdsc, s);
>>   		}
>>   	}
>> +
>> +	kfree(export_targets);
>>   }
>>   
>>   

