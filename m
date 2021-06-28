Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C095D3B654F
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Jun 2021 17:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhF1PYn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Jun 2021 11:24:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235589AbhF1PWI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 11:22:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624893582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3lPZEmsPKxjacHNWtUBIyhK3YxykUSXGESdBt3o3tEU=;
        b=Ld6Kcw0Bv+/VkXHMJPm6yuxVVlNXSr2IHT8ydgIQPrHdGIio0KQonr1xKn2Zm/Wz13H+kl
        +k9JlZZGjVxCglzgiTP0zIJlEmlABa7nOCOr9TFpCUQPye/Ah1uZyzYSetQuL0nAXOuZmY
        Bu+ynNmMrJa4x1tUVflFTirQsa/dGIQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-8-WyGLFzMKiYiJ1HWVTcWQ-1; Mon, 28 Jun 2021 11:19:41 -0400
X-MC-Unique: 8-WyGLFzMKiYiJ1HWVTcWQ-1
Received: by mail-qv1-f69.google.com with SMTP id d11-20020a0cf6cb0000b029028486d617faso8923982qvo.19
        for <ceph-devel@vger.kernel.org>; Mon, 28 Jun 2021 08:19:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=3lPZEmsPKxjacHNWtUBIyhK3YxykUSXGESdBt3o3tEU=;
        b=PYKCXyqop4VLoK3sv+0/swMy1NZGPcNBvKby04DxBqtaYe4SC09nd3FZ1nNdiaSy2i
         Ay8Hzvv0ivruJKkp4CbwsNpIliPwP0FiZskltHGP8fEdwTFlwXIDKMrPNINS76oc1zqp
         nMKiv62XbREqW3P+wcrIQ9I799zXQl5rE9dY0BarTkQbg3NOL9e+7VrQ00SSyIiyHrZf
         9FToixeDre5SgcSSaMBuoKSpwGT0yQsrXCyTWhAvebqqsVqPiM/W3SCLNPyHZKdFZNtM
         WwRQ6y1Lk1XkX1qOCdhoGOESj2aGIBskWZ61HAlTm8NwGz5O0penPC2H0eQwY5sKST5t
         m9Ag==
X-Gm-Message-State: AOAM5314nHDuzzyGB85mkR1CMieDyVrElgO9kendfMH1CGB/fElk774d
        Rw/JXY3dAnJsol60FQ9b5hZnheqraOIvz96K1HoNeyxenqEnuYt7T4ctEhPzbYjJLJvBLkM3RmX
        uNJUzMkRKKlGqZB2puqJlQQ==
X-Received: by 2002:a05:620a:23b:: with SMTP id u27mr21011557qkm.98.1624893580690;
        Mon, 28 Jun 2021 08:19:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkFDxinWoobz5wYDVlB0l6YWyjqxcgn6TRtDUkPhIm9beH2TJZQeSPhyo/OYA9ZWQ2DagnGA==
X-Received: by 2002:a05:620a:23b:: with SMTP id u27mr21011542qkm.98.1624893580500;
        Mon, 28 Jun 2021 08:19:40 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id c65sm4441715qkg.84.2021.06.28.08.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 08:19:40 -0700 (PDT)
Message-ID: <d33e9bbf2b4d500e2b6cc27e757be4ad8875839a.camel@redhat.com>
Subject: Re: [PATCH 3/4] ceph: record updated mon_addr on remount
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Date:   Mon, 28 Jun 2021 11:19:39 -0400
In-Reply-To: <20210628075545.702106-4-vshankar@redhat.com>
References: <20210628075545.702106-1-vshankar@redhat.com>
         <20210628075545.702106-4-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-06-28 at 13:25 +0530, Venky Shankar wrote:
> Note that the new monitors are just shown in /proc/mounts.
> Ceph does not (re)connect to new monitors yet.
> 

I wasn't sure we'd want to do that anyway, but now I think it might be a
good idea. Being able to re-point a client to a new set of mons manually
seems like a reasonable thing to be able to do in a disaster recovery
situation or the like.

> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/super.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 84bc06e51680..48493ac372fa 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1250,6 +1250,12 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
>  	else
>  		ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
>  
> +	if (strcmp(fsc->mount_options->mon_addr, fsopt->mon_addr)) {
> +		kfree(fsc->mount_options->mon_addr);
> +		fsc->mount_options->mon_addr = kstrdup(fsopt->mon_addr,
> +						       GFP_KERNEL);
> +	}
> +

It's probably worth logging a KERN_NOTICE message or something that the
new monitor addresses were ignored. That way, if you implement
connecting to the new mons on remount later you'd have a way to tell.


>  	sync_filesystem(fc->root->d_sb);
>  	return 0;
>  }
-- 
Jeff Layton <jlayton@redhat.com>

