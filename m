Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1213C8A6D
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jul 2021 20:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239922AbhGNSIa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jul 2021 14:08:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59746 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229736AbhGNSIa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 14 Jul 2021 14:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626285938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bnjNV8CSjhmBTx3JUI+ZvKsuNZ9GgYRN+rNpa83rlvQ=;
        b=GOAfAyNTvL3ayqfk+Q3VOCFRBMfqe1bh5cGJRMzTmN0qLQoeAl2z/hkMKzPzotyQYTEDpg
        Pas9KBYTkisA8M7IcWfwPewHsC4BhzE281eSnuF+FXTC5ZgddU4K97C6b6h7A6wDWSPE70
        mJwMWw2b9RmNdoomcshjTalcmvdQ+Gw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-dyNlTgkaMc2uu2OXWB3R5w-1; Wed, 14 Jul 2021 14:05:36 -0400
X-MC-Unique: dyNlTgkaMc2uu2OXWB3R5w-1
Received: by mail-qv1-f69.google.com with SMTP id ca6-20020ad456060000b02902ea7953f97fso2203965qvb.22
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jul 2021 11:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=bnjNV8CSjhmBTx3JUI+ZvKsuNZ9GgYRN+rNpa83rlvQ=;
        b=mGcsINgqEGg4CiqEgSJZV9JAxFGzv32/4DHFR/HUYwhz5L93INIsC3T+VX2Qms9A4l
         /GlZFeMvBjoKZ3t9jIpVG3kULrUnEuMk0QgZp+li7brPrG1M+KxtMjnfyGKvegPnMpg0
         m+SJPXdHJNNKy8DJjkJM3wq6D6oBAqC8TBYf3eImP7T5vRDWihJ4KQSxMZluE8Etj7rv
         ioVxeQnXX6SzArNGt91amk8OZLBc+XDWAi+k4INpKjw7OQmTwvFFQnpsGvfMtWT4o8Jc
         xuQ/QASyhjEbTQAT91/LBxFw/uIli1KoSilBaew7RCz8kMOYmUx5ZhoOL+nzy0qS0KJo
         HhIg==
X-Gm-Message-State: AOAM530+URAr5DZb93796YylG8D5dSNnpjTcmtwJCb/oBq6gUOftojEB
        gnrDjF0Aiym9VZeFgmYTV1QFNSF6bNKHA81H5E5q2RLDwE5SNTa7qjv7SMQ1/gBXViAgexK/Cav
        8KOJZP+bbGyTIMFRLSpE9qA==
X-Received: by 2002:ac8:6b0f:: with SMTP id w15mr10427781qts.366.1626285936562;
        Wed, 14 Jul 2021 11:05:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOULfxoRfqLAiay3mQ0vv9JOgHJ3LuQIgza0eHtEH4ljXgrbeTbtA6fWhFPh1tEGH2wjqAoA==
X-Received: by 2002:ac8:6b0f:: with SMTP id w15mr10427774qts.366.1626285936412;
        Wed, 14 Jul 2021 11:05:36 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id j4sm725587qko.6.2021.07.14.11.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 11:05:36 -0700 (PDT)
Message-ID: <c06fd95a8caffa509282b33560b9deed8037727a.camel@redhat.com>
Subject: Re: [PATCH v4 4/5] ceph: record updated mon_addr on remount
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com,
        lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 14 Jul 2021 14:05:35 -0400
In-Reply-To: <20210714100554.85978-5-vshankar@redhat.com>
References: <20210714100554.85978-1-vshankar@redhat.com>
         <20210714100554.85978-5-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-07-14 at 15:35 +0530, Venky Shankar wrote:
> Note that the new monitors are just shown in /proc/mounts.
> Ceph does not (re)connect to new monitors yet.
> 
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/super.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index d8c6168b7fcd..d3a5a3729c5b 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1268,6 +1268,13 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
>  	else
>  		ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
>  
> +	if (strcmp(fsc->mount_options->mon_addr, fsopt->mon_addr)) {

One other problem with this patch...

The above needs to use strcmp_null(). I'll plan to make that change too.

> +		kfree(fsc->mount_options->mon_addr);
> +		fsc->mount_options->mon_addr = fsopt->mon_addr;
> +		fsopt->mon_addr = NULL;
> +		printk(KERN_NOTICE "ceph: monitor addresses recorded, but not used for reconnection");
> +	}
> +
>  	sync_filesystem(fc->root->d_sb);
>  	return 0;
>  }
-- 
Jeff Layton <jlayton@redhat.com>

