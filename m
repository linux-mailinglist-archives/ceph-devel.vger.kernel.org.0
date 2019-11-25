Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA6108F3A
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2019 14:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfKYNvP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Nov 2019 08:51:15 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35517 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727462AbfKYNvP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 08:51:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574689873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MGaD9OVKXZ6h413vDWG1Wxg4Ym6exqFGPtdxZcLJ9vY=;
        b=QDj3Tv58T8gV7V75WyEASo9SkjCaJVokwFuLtZxw21QWae6irJVQOZ/nevfbA3DU89I006
        tjXMtdw5sOgOd+Pc4VTwEJzTQAOvgO4r9W5mtQv5QPFaZXjZ2imhAPooSP86rCxj53qhXQ
        TP7veqIXLl44sOSncSeCGomyqqiwRgI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-ncCRsW2XPHWUN-NWdd1ogg-1; Mon, 25 Nov 2019 08:51:10 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 832A58CF43B;
        Mon, 25 Nov 2019 13:51:09 +0000 (UTC)
Received: from [10.72.12.66] (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC4BB19C70;
        Mon, 25 Nov 2019 13:51:01 +0000 (UTC)
Subject: Re: [PATCH v2 2/3] mdsmap: fix mdsmap cluster available check based
 on laggy number
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191125110827.12827-1-xiubli@redhat.com>
 <20191125110827.12827-3-xiubli@redhat.com>
 <3cbf12af7e05ea711e376ddbf93be5abf84fbf00.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7e9ebebf-10b2-76e4-ae5f-cbdde25061f1@redhat.com>
Date:   Mon, 25 Nov 2019 21:50:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <3cbf12af7e05ea711e376ddbf93be5abf84fbf00.camel@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: ncCRsW2XPHWUN-NWdd1ogg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/11/25 21:27, Jeff Layton wrote:
> On Mon, 2019-11-25 at 06:08 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> In case the max_mds > 1 in MDS cluster and there is no any standby
>> MDS and all the max_mds MDSs are in up:active state, if one of the
>> up:active MDSs is dead, the m->m_num_laggy in kclient will be 1.
>> Then the mount will fail without considering other healthy MDSs.
>>
>> There manybe some MDSs still "in" the cluster but not in up:active
>> state, we will ignore them. Only when all the up:active MDSs in
>> the cluster are laggy will treat the cluster as not be available.
>>
>> In case decreasing the max_mds, the cluster will not stop the extra
>> up:active MDSs immediately and there will be a latency. During it
>> the up:active MDS number will be larger than the max_mds, so later
>> the m_info memories will 100% be reallocated.
>>
>> Here will pick out the up:active MDSs as the m_num_mds and allocate
>> the needed memories once.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mdsmap.c            | 32 ++++++++++----------------------
>>   include/linux/ceph/mdsmap.h |  5 +++--
>>   2 files changed, 13 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>> index 471bac335fae..cc9ec959fe46 100644
>> --- a/fs/ceph/mdsmap.c
>> +++ b/fs/ceph/mdsmap.c
>> @@ -138,14 +138,21 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>>   	m->m_session_autoclose = ceph_decode_32(p);
>>   	m->m_max_file_size = ceph_decode_64(p);
>>   	m->m_max_mds = ceph_decode_32(p);
>> -	m->m_num_mds = m->m_max_mds;
>> +
>> +	/*
>> +	 * pick out the active nodes as the m_num_mds, the m_num_mds
>> +	 * maybe larger than m_max_mds when decreasing the max_mds in
>> +	 * cluster side, in other case it should less than or equal
>> +	 * to m_max_mds.
>> +	 */
>> +	m->m_num_mds = n = ceph_decode_32(p);
>> +	m->m_num_active_mds = m->m_num_mds;
>>   
>>   	m->m_info = kcalloc(m->m_num_mds, sizeof(*m->m_info), GFP_NOFS);
>>   	if (!m->m_info)
>>   		goto nomem;
>>   
>>   	/* pick out active nodes from mds_info (state > 0) */
>> -	n = ceph_decode_32(p);
>>   	for (i = 0; i < n; i++) {
>>   		u64 global_id;
>>   		u32 namelen;
>> @@ -218,17 +225,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>>   		if (mds < 0 || state <= 0)
>>   			continue;
>>   
>> -		if (mds >= m->m_num_mds) {
>> -			int new_num = max(mds + 1, m->m_num_mds * 2);
>> -			void *new_m_info = krealloc(m->m_info,
>> -						new_num * sizeof(*m->m_info),
>> -						GFP_NOFS | __GFP_ZERO);
>> -			if (!new_m_info)
>> -				goto nomem;
>> -			m->m_info = new_m_info;
>> -			m->m_num_mds = new_num;
>> -		}
>> -
> I don't think we want to get rid of this bit. What happens if the number
> of MDS' increases after the mount occurs?
Every time when we receive a new version of mdsmap, the old whole 
mdsc->mdsmap memory will be reallocated and replaced, no matter the MDS' 
increases or decreases.

The active nodes from mds_info above will help record the actual MDS 
number and then we decode it into "m_num_active_mds". If we are 
decreasing the max_mds in the cluster side, the "m_num_active_mds" will 
very probably be larger than the expected "m_num_mds", then we 
definitely will need to reallocate the memory for m->m_info here. Why 
not allocate enough memory beforehand ?

BTW, from my investigation that the mds number decoded from the mds_info 
won't be larger than the "m_num_active_mds". If I am right then this 
code is useless here, or we need it.


>>   		info = &m->m_info[mds];
>>   		info->global_id = global_id;
>>   		info->state = state;
>> @@ -247,14 +243,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>>   			info->export_targets = NULL;
>>   		}
>>   	}
>> -	if (m->m_num_mds > m->m_max_mds) {
>> -		/* find max up mds */
>> -		for (i = m->m_num_mds; i >= m->m_max_mds; i--) {
>> -			if (i == 0 || m->m_info[i-1].state > 0)
>> -				break;
>> -		}
>> -		m->m_num_mds = i;
>> -	}
>>   
>>   	/* pg_pools */
>>   	ceph_decode_32_safe(p, end, n, bad);
>> @@ -396,7 +384,7 @@ bool ceph_mdsmap_is_cluster_available(struct ceph_mdsmap *m)
>>   		return false;
>>   	if (m->m_damaged)
>>   		return false;
>> -	if (m->m_num_laggy > 0)
>> +	if (m->m_num_laggy == m->m_num_active_mds)
>>   		return false;
>>   	for (i = 0; i < m->m_num_mds; i++) {
>>   		if (m->m_info[i].state == CEPH_MDS_STATE_ACTIVE)
>> diff --git a/include/linux/ceph/mdsmap.h b/include/linux/ceph/mdsmap.h
>> index 0067d767c9ae..3a66f4f926ce 100644
>> --- a/include/linux/ceph/mdsmap.h
>> +++ b/include/linux/ceph/mdsmap.h
>> @@ -25,8 +25,9 @@ struct ceph_mdsmap {
>>   	u32 m_session_timeout;          /* seconds */
>>   	u32 m_session_autoclose;        /* seconds */
>>   	u64 m_max_file_size;
>> -	u32 m_max_mds;                  /* size of m_addr, m_state arrays */
>> -	int m_num_mds;
>> +	u32 m_max_mds;			/* expected up:active mds number */
>> +	int m_num_active_mds;		/* actual up:active mds number */
>> +	int m_num_mds;                  /* size of m_info array */
>>   	struct ceph_mds_info *m_info;
>>   
>>   	/* which object pools file data can be stored in */


