Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414623DA356
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Jul 2021 14:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbhG2Mrq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 29 Jul 2021 08:47:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236888AbhG2Mro (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 08:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627562860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0DrisB00xqVxEzopdeiLS7xNpIkCJ+vAmmRWiPIm3tM=;
        b=bEao/mZNTWhz4wuwrR+CCTnoKbdwZyYdqrLqkgh81nUAkiIQyn0Bc3LuI7yUJTUUkLgrNp
        AGjb7rIQhfKj93QDmSfEDhXcWLw70tLcLkwh8ZoD8zbXBkbANcg1JID0XoDB3ZlePM7VLT
        oOp2mA6iD1dJi43fWdWr+6B4UlvpOK0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-0dulereGN46qDxSqSQyeCA-1; Thu, 29 Jul 2021 08:47:39 -0400
X-MC-Unique: 0dulereGN46qDxSqSQyeCA-1
Received: by mail-pl1-f199.google.com with SMTP id s3-20020a1709029883b029012b41197000so4911564plp.16
        for <ceph-devel@vger.kernel.org>; Thu, 29 Jul 2021 05:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0DrisB00xqVxEzopdeiLS7xNpIkCJ+vAmmRWiPIm3tM=;
        b=UHFBGxD7HEEOGPMpOUqtTFIEvLRbP6/E7Urqpk6/H+c8NoeuwARMT/j2ovHGr3c5AR
         6GCSfDp3O4bahKZ+Zs2R61zELFxprq95aaCCKHKAW/d0hfObD6T50dr4/K2zCn86ee0J
         YlJhVfZSufhmLfxkqQHMbIULs7m1WsXVcLgTVW20E2ESU8BH3QDzydHLEXYZsQKSOiU5
         JYjenfgypBK7gdGaCXTAEntSDIvubwjDHC1VhprBXHJxsfIyG060GgsVwyQhQ0NZP/XR
         ML+op3EY3OBiur9cbFU/j7GbyKru78TnkpR9XaUCbo7SN5033yQEy3VwsFCG0FJwRplh
         B42w==
X-Gm-Message-State: AOAM532q2RxPqxEw6ohQNRedU4iNQ3k8I2f+FA/Yis72LC8oFCacwQFL
        oCrf7gz3yPiRhP2eIWCizyvMNpRvw0now+mL4uftmVvNUzGFUP5BthpYhIrcCMIkrHext82DQl5
        hOvWqWZ5ECKjcDNuf+h/esA==
X-Received: by 2002:a17:90a:bd98:: with SMTP id z24mr14815889pjr.99.1627562858235;
        Thu, 29 Jul 2021 05:47:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHYZqgqqKpM9k453jeG1VmTobteJukf0gQpl6xDSJsv/wpgrhd1CH7ZroOzDcEaTx/2F0weQ==
X-Received: by 2002:a17:90a:bd98:: with SMTP id z24mr14815872pjr.99.1627562857970;
        Thu, 29 Jul 2021 05:47:37 -0700 (PDT)
Received: from [10.72.12.111] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u16sm3959530pgh.53.2021.07.29.05.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 05:47:37 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: cancel delayed work instead of flushing on mdsc
 teardown
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
References: <20210729123821.100086-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f1cf16b3-ec49-aeb2-aced-760dd7402f8a@redhat.com>
Date:   Thu, 29 Jul 2021 20:47:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210729123821.100086-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/29/21 8:38 PM, Jeff Layton wrote:
> The first thing metric_delayed_work does is check mdsc->stopping,
> and then return immediately if it's set. That's good since we would
> have already torn down the metric structures at this point, otherwise,
> but there is no locking around mdsc->stopping.
>
> It's possible that the ceph_metric_destroy call could race with the
> delayed_work, in which case we could end up with the delayed_work
> accessing destroyed percpu variables.
>
> At this point in the mdsc teardown, the "stopping" flag has already been
> set, so there's no benefit to flushing the work. Move the work
> cancellation in ceph_metric_destroy ahead of the percpu variable
> destruction, and eliminate the flush_delayed_work call in
> ceph_mdsc_destroy.
>
> Cc: Xiubo Li <xiubli@redhat.com>
> Fixes: 18f473b384a6 ("ceph: periodically send perf metrics to MDSes")
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/mds_client.c | 1 -
>   fs/ceph/metric.c     | 4 ++--
>   2 files changed, 2 insertions(+), 3 deletions(-)
>
> v2: just drop the flush call altogether and move the cancel before the
>      percpu variables are destroyed (per Xiubo's suggestion).
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c43091a30ba8..34124fb1605e 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4979,7 +4979,6 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
>   
>   	ceph_metric_destroy(&mdsc->metric);
>   
> -	flush_delayed_work(&mdsc->metric.delayed_work);
>   	fsc->mdsc = NULL;
>   	kfree(mdsc);
>   	dout("mdsc_destroy %p done\n", mdsc);
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 5ac151eb0d49..04d5df29bbbf 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -302,6 +302,8 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>   	if (!m)
>   		return;
>   
> +	cancel_delayed_work_sync(&m->delayed_work);
> +
>   	percpu_counter_destroy(&m->total_inodes);
>   	percpu_counter_destroy(&m->opened_inodes);
>   	percpu_counter_destroy(&m->i_caps_mis);
> @@ -309,8 +311,6 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>   	percpu_counter_destroy(&m->d_lease_mis);
>   	percpu_counter_destroy(&m->d_lease_hit);
>   
> -	cancel_delayed_work_sync(&m->delayed_work);
> -
>   	ceph_put_mds_session(m->session);
>   }
>   

Reviewed-by: Xiubo Li <xiubli@redhat.com>

