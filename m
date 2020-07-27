Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDCD22EBE7
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Jul 2020 14:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgG0MRG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jul 2020 08:17:06 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49318 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726555AbgG0MRF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 08:17:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595852224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JZxHAk7kEKjN0o0IL1o8d9CHQ/KWoWwljjYPk+Y3O8c=;
        b=f5ncXUT5KsPItyQqrMSNabHR150yIVD467BhmOL1rUlC4eeTYgWSNkAM9lmb017TP7dGLN
        VbrQdm7OsmH3X2Nea8StZd/V214G26Ll4efp6TIo0ZqlN2dKpklWenMNEZ6Nktv8LMwCQ2
        FohKMbzVdCNxhPW0IghOrZZR5lQaf3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-BfR_E0PSOvqcWapIB-grFQ-1; Mon, 27 Jul 2020 08:16:58 -0400
X-MC-Unique: BfR_E0PSOvqcWapIB-grFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51ECB102C7EE;
        Mon, 27 Jul 2020 12:16:57 +0000 (UTC)
Received: from [10.72.12.116] (ovpn-12-116.pek2.redhat.com [10.72.12.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CFB2712CF;
        Mon, 27 Jul 2020 12:16:56 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix memory leak when reallocating pages array for
 writepages
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20200726122804.16008-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3c8fb2aa-834b-a202-24b4-7eb29cd9b7c3@redhat.com>
Date:   Mon, 27 Jul 2020 20:16:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200726122804.16008-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/7/26 20:28, Jeff Layton wrote:
> Once we've replaced it, we don't want to keep the old one around
> anymore.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/addr.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 01ad09733ac7..01e167efa104 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1212,6 +1212,7 @@ static int ceph_writepages_start(struct address_space *mapping,
>   			       locked_pages * sizeof(*pages));
>   			memset(data_pages + i, 0,
>   			       locked_pages * sizeof(*pages));

BTW， do we still need to memset() the data_pages ?

> +			kfree(data_pages);
>   		} else {
>   			BUG_ON(num_ops != req->r_num_ops);
>   			index = pages[i - 1]->index + 1;


