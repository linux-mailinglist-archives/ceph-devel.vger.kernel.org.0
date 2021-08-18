Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9135D3F0408
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 14:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhHRMyb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 08:54:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235423AbhHRMya (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 08:54:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629291236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CuFrOi7AEWEypzjfNCRGcNZ9n1VJ7moJWLts1IXIJrM=;
        b=I+dcJoqbJEQcr8Au7NdjjW1XB+el71bUrcC1wkbZCtydf+w5T9YsZjKdgpaV8df8JeoWLa
        AaAtEjSEgm5S/X4woimc38K0Tgctj3BreZ33HBLLgyIWpiVCmboS2AOC52A8yoSotuYdKl
        RvlOx5UgdAZid6AAlVyxGsJOwbMDFjE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-WyPtO47cO3CgXEkVanMBog-1; Wed, 18 Aug 2021 08:53:55 -0400
X-MC-Unique: WyPtO47cO3CgXEkVanMBog-1
Received: by mail-pf1-f198.google.com with SMTP id s11-20020a056a0008cbb029038f396b4773so1220730pfu.20
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 05:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CuFrOi7AEWEypzjfNCRGcNZ9n1VJ7moJWLts1IXIJrM=;
        b=axfufXhHumtjmWupYz8suWZ5MVrTvfyaL0ta5OUS1VpHSAPdPff8W8sb+jdRGeufPk
         V6D6cA8v/vG0z2J99U5NvByKbMhPH4sFFLQxgnRhLincWBwwhCpKde+qhibdn2U6gaI5
         p+iDHQNVoctR1mUDZghOS4ac+R5O1gGyAbVa8pfVng+/1LvjSRFgc9NzawapPo4Yt/7K
         7GIeAf3PKwor1xOx9AkvE9otiY72SFHHpZfQuOA/bLsCDimWT+PwUCbgTgct+XgY/Bir
         vt/X8p3WoKeeFFly8zIdNI/kxfrazjvyj6gM9+7/vRhs4+ZjWoBhnl5bIobdRqWQn7VO
         Cq3A==
X-Gm-Message-State: AOAM530yo/BOgURYjCE3CyUInH0eNenAL5qUiZkdX9BK7WcHbBzFwciD
        F1U0a/PRCLYiCMf/GMKtECccHTS6bXFquWoYGu6FREat4SgHSvRVvial+avOV8keGTlCIh6CWWb
        KiJCqUHjyFCA0Pcg6+jcmhuu/H01gNeafM7xLJPm3BT3CPeP5lG58HWyVCQgv9n4ACA0PWAw=
X-Received: by 2002:a17:90a:3186:: with SMTP id j6mr9126787pjb.220.1629291233441;
        Wed, 18 Aug 2021 05:53:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbt5l4KYCwRGs9JnNLusK4GaNgj2bhshrLxYEnsT36LdHx7WwcH3lGHJvz3r/6IxUM5ZTKhw==
X-Received: by 2002:a17:90a:3186:: with SMTP id j6mr9126756pjb.220.1629291233117;
        Wed, 18 Aug 2021 05:53:53 -0700 (PDT)
Received: from [10.72.12.133] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b8sm5306702pjo.51.2021.08.18.05.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 05:53:52 -0700 (PDT)
Subject: Re: [PATCH v3] ceph: try to reconnect to the export targets
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210818013119.76694-1-xiubli@redhat.com>
 <6b99366e2fc4775aec7e1c39053580a4e1048e59.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9de800d3-0686-05bd-1c23-61238edcaebb@redhat.com>
Date:   Wed, 18 Aug 2021 20:53:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <6b99366e2fc4775aec7e1c39053580a4e1048e59.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/18/21 8:31 PM, Jeff Layton wrote:
> On Wed, 2021-08-18 at 09:31 +0800, xiubli@redhat.com wrote:
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
>> V3:
>> - switch to bitmap and on the stack
>> - put the ceph_put_mds_session() out of the mdsc->mutex lock scope
>>
>>
>>   fs/ceph/mds_client.c | 55 +++++++++++++++++++++++++++++++++++++++++++-
>>   fs/ceph/mdsmap.c     | 10 +++++---
>>   2 files changed, 61 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index e49dbeb6c06f..c2fca06b09a0 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -11,6 +11,7 @@
>>   #include <linux/ratelimit.h>
>>   #include <linux/bits.h>
>>   #include <linux/ktime.h>
>> +#include <linux/bitmap.h>
>>   
>>   #include "super.h"
>>   #include "mds_client.h"
>> @@ -4197,13 +4198,19 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>>   			  struct ceph_mdsmap *newmap,
>>   			  struct ceph_mdsmap *oldmap)
>>   {
>> -	int i;
>> +	int i, err;
>>   	int oldstate, newstate;
>>   	struct ceph_mds_session *s;
>> +	unsigned long targets[DIV_ROUND_UP(CEPH_MAX_MDS, sizeof(unsigned long))] = {0};
>>   
>>   	dout("check_new_map new %u old %u\n",
>>   	     newmap->m_epoch, oldmap->m_epoch);
>>   
>> +	if (newmap->m_info) {
>> +		for (i = 0; i < newmap->m_info->num_export_targets; i++)
>> +			set_bit(newmap->m_info->export_targets[i], targets);
>> +	}
>> +
> I wasn't aware you could exceed the size of the first unsigned long in
> the array with the atomic bitops handlers. Looking at the helpers
> themselves though, I don't see why this wouldn't work. Ok!
>
>>   	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>>   		if (!mdsc->sessions[i])
>>   			continue;
>> @@ -4257,6 +4264,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>>   		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
>>   		    newstate >= CEPH_MDS_STATE_RECONNECT) {
>>   			mutex_unlock(&mdsc->mutex);
>> +			clear_bit(i, targets);
>>   			send_mds_reconnect(mdsc, s);
>>   			mutex_lock(&mdsc->mutex);
>>   		}
>> @@ -4279,6 +4287,51 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>>   		}
>>   	}
>>   
>> +	/*
>> +	 * Only open and reconnect sessions that don't exist yet.
>> +	 */
>> +	for (i = 0; i < newmap->possible_max_rank; i++) {
>> +		/*
>> +		 * In case the import MDS is crashed just after
>> +		 * the EImportStart journal is flushed, so when
>> +		 * a standby MDS takes over it and is replaying
>> +		 * the EImportStart journal the new MDS daemon
>> +		 * will wait the client to reconnect it, but the
>> +		 * client may never register/open the session yet.
>> +		 *
>> +		 * Will try to reconnect that MDS daemon if the
>> +		 * rank number is in the export targets array and
>> +		 * is the up:reconnect state.
>> +		 */
>> +		newstate = ceph_mdsmap_get_state(newmap, i);
>> +		if (!test_bit(i, targets) || newstate != CEPH_MDS_STATE_RECONNECT)
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
>> +		ceph_put_mds_session(s);
>> +		mutex_lock(&mdsc->mutex);
>> +	}
>> +
>>   	for (i = 0; i < newmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>>   		s = mdsc->sessions[i];
>>   		if (!s)
>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>> index 3c444b9cb17b..d995cb02d30c 100644
>> --- a/fs/ceph/mdsmap.c
>> +++ b/fs/ceph/mdsmap.c
>> @@ -122,6 +122,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>>   	int err;
>>   	u8 mdsmap_v;
>>   	u16 mdsmap_ev;
>> +	u32 target;
>>   
>>   	m = kzalloc(sizeof(*m), GFP_NOFS);
>>   	if (!m)
>> @@ -260,9 +261,12 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>>   						       sizeof(u32), GFP_NOFS);
>>   			if (!info->export_targets)
>>   				goto nomem;
>> -			for (j = 0; j < num_export_targets; j++)
>> -				info->export_targets[j] =
>> -				       ceph_decode_32(&pexport_targets);
>> +			for (j = 0; j < num_export_targets; j++) {
>> +				target = ceph_decode_32(&pexport_targets);
>> +				if (target >= m->possible_max_rank)
>> +					goto corrupt;
>> +				info->export_targets[j] = target;
>> +			}
>>   		} else {
>>   			info->export_targets = NULL;
>>   		}
> Looks good. Merged into testing. I also reworded the changelog for
> (hopefully) better clarity. Xiubo, let me know if I didn't get the
> description right.

Your changes look much better. Thanks Jeff.



>
> Thanks!

