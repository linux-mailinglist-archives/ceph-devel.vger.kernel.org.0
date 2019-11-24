Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75FD110815C
	for <lists+ceph-devel@lfdr.de>; Sun, 24 Nov 2019 02:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKXBmC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 23 Nov 2019 20:42:02 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44367 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726676AbfKXBmC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 23 Nov 2019 20:42:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574559719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nRNbcrNfrTKELHB+yA4BtOByNHoGkOjiaW2U4xcVdic=;
        b=CwgqiIIru3G5nAXQpq7GwcXDkJBQ1LaZgz2tAOcOaD1OWUQRrYCAigNHgCjqzocoVp39AQ
        D8OFwPjlNc6thIEMXbHHz33LgWa+XCNtDZTHK2HprePTq1s2HCRHqCvt9s8BE9+f+V7ZMu
        K1vjFC2xMDZKugBl38QvnbYVINnqyhY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-XvmnMJVEMpq39MbZvUPiWg-1; Sat, 23 Nov 2019 20:41:56 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 768FB18037EF;
        Sun, 24 Nov 2019 01:41:55 +0000 (UTC)
Received: from [10.72.12.58] (ovpn-12-58.pek2.redhat.com [10.72.12.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0506E5D6A0;
        Sun, 24 Nov 2019 01:41:50 +0000 (UTC)
Subject: Re: [PATCH 2/3] mdsmap: fix mdsmap cluster available check based on
 laggy number
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191120082902.38666-1-xiubli@redhat.com>
 <20191120082902.38666-3-xiubli@redhat.com>
 <52135037d9009f678e1b05964f0d6a1366a77ed0.camel@kernel.org>
 <3fbcbc90-b323-5e8a-5664-fe8ce64a5100@redhat.com>
 <69d4abdfe6f62eac5be6f1b8203faa68942cc849.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f8ad15a5-ee41-9d5b-9026-5c95595d9598@redhat.com>
Date:   Sun, 24 Nov 2019 09:41:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <69d4abdfe6f62eac5be6f1b8203faa68942cc849.camel@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: XvmnMJVEMpq39MbZvUPiWg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/11/22 21:55, Jeff Layton wrote:
> On Fri, 2019-11-22 at 14:56 +0800, Xiubo Li wrote:
>> On 2019/11/22 1:30, Jeff Layton wrote:
>>> On Wed, 2019-11-20 at 03:29 -0500, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> In case the max_mds > 1 in MDS cluster and there is no any standby
>>>> MDS and all the max_mds MDSs are in up:active state, if one of the
>>>> up:active MDSs is dead, the m->m_num_laggy in kclient will be 1.
>>>> Then the mount will fail without considering other healthy MDSs.
>>>>
>>>> Only when all the MDSs in the cluster are laggy will treat the
>>>> cluster as not be available.
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/mdsmap.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>>>> index 471bac335fae..8b4f93e5b468 100644
>>>> --- a/fs/ceph/mdsmap.c
>>>> +++ b/fs/ceph/mdsmap.c
>>>> @@ -396,7 +396,7 @@ bool ceph_mdsmap_is_cluster_available(struct ceph_mdsmap *m)
>>>>    		return false;
>>>>    	if (m->m_damaged)
>>>>    		return false;
>>>> -	if (m->m_num_laggy > 0)
>>>> +	if (m->m_num_laggy == m->m_num_mds)
>>>>    		return false;
>>>>    	for (i = 0; i < m->m_num_mds; i++) {
>>>>    		if (m->m_info[i].state == CEPH_MDS_STATE_ACTIVE)
>>> Given that laggy servers are still expected to be "in" the cluster,
>>> should we just eliminate this check altogether? It seems like we'd still
>>> want to allow a mount to occur even if the cluster is lagging.
>> For this we need one way to distinguish between mds crash and transient
>> mds laggy, for now in both cases the mds will keep staying "in" the
>> cluster and be in "up:active & laggy" state.
> I would doubt there's any way to do that reliably, and in any case
> detection of that state will always involve some delay.

Yeah, checked it and It seems will be.

>
> ceph_mdsmap_is_cluster_available() is only called when mounting though.
> We wouldn't want to choose a laggy server over one that isn't, but I
> don't think we want to fail to mount just because all of the servers
> appear to be laggy. We should consider such servers to be potentially
> available but not preferred.

This makes sense.

BRs

