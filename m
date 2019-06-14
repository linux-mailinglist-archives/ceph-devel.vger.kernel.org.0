Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083C945B7C
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Jun 2019 13:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfFNLcV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Jun 2019 07:32:21 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:37641 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfFNLcV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Jun 2019 07:32:21 -0400
Received: by mail-yw1-f66.google.com with SMTP id 186so949932ywo.4
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jun 2019 04:32:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+vei+vsKmf8kYTMPKS41RYYuzzi0KPaIbhMePqkHv40=;
        b=qmukxAqDeKc2SKCnMuYI2dLRhsqIg/v0mAQ6PZMkPcX6ajxlbvS0RsTFF2jZSJndWT
         jJ5Yo2gkbfBygGz+5oh5gRf/U5huroQwg1ki7XOL4lioJyaHy8wFzgD9zkd5EAR74FTr
         Hux9T6m4lM6GaskMdkfLknnVtssG9SgL+BeL1P4lMVzmPgmVNvqwCK519KqsH5fcBbGO
         Uecd2cdBkIA56LCgcGrteFHrauE7KLwCVjUyrisKkIEXDauFg/28ma9A/Ump7qs/Pnwq
         DUwEw2HkxjRJExqJIXdJoQoVY6164XwURiAD/yco1znNeClvaVtkmrmPft/0esEV3qpg
         yGDA==
X-Gm-Message-State: APjAAAWn6qq4x3/Kxyd5vMvmykARzwW9lclQzWc5FNo6Ts9GEgdVDm63
        Cv4R3uslXR+ZxVRqvj3YX45nvg==
X-Google-Smtp-Source: APXvYqwwW3xxNVmVlG0y+WzWmjl2wmOYZnFDS49qNXxPSeAhotTzpQz3OwauWBhQcli+1B3Ovyf7wA==
X-Received: by 2002:a81:238f:: with SMTP id j137mr48097660ywj.67.1560511940602;
        Fri, 14 Jun 2019 04:32:20 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-CA3.dyn6.twc.com. [2606:a000:1100:37d::ca3])
        by smtp.gmail.com with ESMTPSA id d7sm1456538ywh.14.2019.06.14.04.32.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 04:32:19 -0700 (PDT)
Message-ID: <1c118ad4d72a311ecb8fecdc6c938c1629257d9a.camel@redhat.com>
Subject: Re: [PATCH] ceph: remove request from waiting list before unregister
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Fri, 14 Jun 2019 07:32:18 -0400
In-Reply-To: <20190614025903.21540-1-zyan@redhat.com>
References: <20190614025903.21540-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-06-14 at 10:59 +0800, Yan, Zheng wrote:
> Link: https://tracker.ceph.com/issues/40339
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/mds_client.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index fda621bc8a29..776c47bd1155 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4162,6 +4162,7 @@ static void wait_requests(struct ceph_mds_client *mdsc)
>  		while ((req = __get_oldest_req(mdsc))) {
>  			dout("wait_requests timed out on tid %llu\n",
>  			     req->r_tid);
> +			list_del_init(&req->r_wait);
>  			__unregister_request(mdsc, req);
>  		}
>  	}

It might also be a good idea to add something like this to
ceph_mdsc_release_request:

     WARN_ON_ONCE(!list_empty(&req->r_wait))

...ditto for any of the other list_heads that we expect to be empty
before freeing. In any case:

Reviewed-by: Jeff Layton <jlayton@redhat.com>

