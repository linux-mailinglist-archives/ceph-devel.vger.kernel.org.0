Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2803F112AF7
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2019 13:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfLDMG7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Dec 2019 07:06:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45037 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727445AbfLDMG7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Dec 2019 07:06:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575461218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=syp/93gcuPvHoeHG60t3ZTi4svuD6y13CxVRQEq8ej8=;
        b=XUEiNIG3NHzjMO662g82ZHtHEuvScbv1bx+fDGNtjr/p0ZdJlD4hbxqDdn7j4b+ct6qooI
        PUtXmiIBpIWy+UmchfwqokiMV6jjwkdvIS5ktFamZ/1EzepF7siFJhMIr26QlEIE4BmbnQ
        bCW1ZiWlQTFXETlr9cPew7Fics7X0II=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-jt6au2tfP3ucqge1Kb07vQ-1; Wed, 04 Dec 2019 07:06:57 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2745E2F60;
        Wed,  4 Dec 2019 12:06:56 +0000 (UTC)
Received: from [10.72.12.69] (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFBA660C63;
        Wed,  4 Dec 2019 12:06:51 +0000 (UTC)
Subject: Re: [PATCH] ceph: add possible_max_rank and make the code more
 readable
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191204115739.53303-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4a3d6805-5e48-7665-4e89-0cb2fe208f91@redhat.com>
Date:   Wed, 4 Dec 2019 20:06:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191204115739.53303-1-xiubli@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: jt6au2tfP3ucqge1Kb07vQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/4 19:57, xiubli@redhat.com wrote:
[...]
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index a77e0ecb9a6b..889627817e52 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -14,22 +14,15 @@
>   #include "super.h"
>   
>   #define CEPH_MDS_IS_READY(i, ignore_laggy) \
> -	(m->m_info[i].state > 0 && (ignore_laggy ? true : !m->m_info[i].laggy))
> +	(m->m_info[i].state > 0 && ignore_laggy ? true : !m->m_info[i].laggy)
>   
>   static int __mdsmap_get_random_mds(struct ceph_mdsmap *m, bool ignore_laggy)
>   {
>   	int n = 0;
>   	int i, j;
>   
> -	/*
> -	 * special case for one mds, no matter it is laggy or
> -	 * not we have no choice
> -	 */
> -	if (1 == m->m_num_mds && m->m_info[0].state > 0)
> -		return 0;
> -

I removed this because when possible_max_mds != m_num_mds and the 
validate MDS rank possible be 1 or a larger number.

This bug existed even without my previous mdsmap series.

All the other code are for enhancement.

BRs

[...]

