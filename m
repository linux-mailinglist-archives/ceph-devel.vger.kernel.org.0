Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5E2112D86
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2019 15:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfLDOfj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Dec 2019 09:35:39 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48219 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727911AbfLDOfj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Dec 2019 09:35:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575470137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BURKk2xGoP5oYIy+ZuxRWHxMkxx4q1xnrlAN16HRr/4=;
        b=OtwKYBcs7Wm2s8DQlGaeu/FM5vnS3hH0j9V+Vb+X0QPb0FhxaR2hVJMm2zJ2uXZlodMZxN
        gaG9Rl0P7JG0b0+p6yOkjadLmfCSC8CV8hemoKu11wqRrcJfu24sbLXotCaMsKwXSS3SGo
        Ybze/xERTPdiNjtYoMAdom/eIXcOE/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-lh3qnDZYPAupWS8BITu08w-1; Wed, 04 Dec 2019 09:35:34 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB28B107ACC9;
        Wed,  4 Dec 2019 14:35:33 +0000 (UTC)
Received: from [10.72.12.105] (ovpn-12-105.pek2.redhat.com [10.72.12.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8964019C68;
        Wed,  4 Dec 2019 14:35:29 +0000 (UTC)
Subject: Re: [PATCH v2] ceph: trigger the reclaim work once there has enough
 pending caps
To:     xiubli@redhat.com, jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20191126123222.29510-1-xiubli@redhat.com>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <4185708e-f614-4271-3b11-2aba6f0e1da6@redhat.com>
Date:   Wed, 4 Dec 2019 22:35:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191126123222.29510-1-xiubli@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: lh3qnDZYPAupWS8BITu08w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/26/19 8:32 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The nr in ceph_reclaim_caps_nr() is very possibly larger than 1,
> so we may miss it and the reclaim work couldn't triggered as expected.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V2:
> - use a more graceful test.
> 
>   fs/ceph/mds_client.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 2c92a1452876..109ec7e2ee7b 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2020,7 +2020,7 @@ void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr)
>   	if (!nr)
>   		return;
>   	val = atomic_add_return(nr, &mdsc->cap_reclaim_pending);
> -	if (!(val % CEPH_CAPS_PER_RELEASE)) {
> +	if ((val % CEPH_CAPS_PER_RELEASE) < nr) {
>   		atomic_set(&mdsc->cap_reclaim_pending, 0);
>   		ceph_queue_cap_reclaim_work(mdsc);
>   	}
> 

Reviewed-by: "Yan, Zheng" <zyan@redhat.com>

