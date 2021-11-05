Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A74E446257
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Nov 2021 11:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhKEKqg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Nov 2021 06:46:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229690AbhKEKqf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 Nov 2021 06:46:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636109036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9RFf2l8nI830yU6Gxc8xRzqg8od8iBHzok+BYETbh/Y=;
        b=J2wSAcI7Fqv8dIBMWIiO70GgAzukaB2+UrW8iYiEuxMLehAuIk2dgr/bHWNoYEvkt3HeTG
        vCyxjfuWknosPtUpbWRZE6TWfH/x0p4/7WApUd9+nVS85wZoiYfjpetZdnXRBVBJdVmfLl
        n/hzz5FccxjRjia09l3hGMuSfuXRp88=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346--JrfoHrcM9yxKuys5E9LFQ-1; Fri, 05 Nov 2021 06:43:53 -0400
X-MC-Unique: -JrfoHrcM9yxKuys5E9LFQ-1
Received: by mail-qk1-f198.google.com with SMTP id w2-20020a3794020000b02903b54f40b442so6900609qkd.0
        for <ceph-devel@vger.kernel.org>; Fri, 05 Nov 2021 03:43:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9RFf2l8nI830yU6Gxc8xRzqg8od8iBHzok+BYETbh/Y=;
        b=E6deKJvYujvbUf5SQIaZiLQFfviVveY0crBSEE2ze783frf01bTc+N626mNM/s8j8R
         rCW0+f1/PC9BrKfBwEsOYzr7/Y3yMR5LFGKalLzsZLGRyZ8hFef0V+YWAGpvB7s6Ymro
         /6xC05z6P0bg3QXDOREJkQa2PeM+bO23yNH7t86uOts9wQvUcW6+h9MQHJcMSOyARuF6
         JkXS97UUMp4X6JKyY7zkjGdJIK7/UO7WFM0bmEA9OQv86p0fRHNn9V0OTbKMCupymjQZ
         3xaTxqFqby2P2vA1QTWhragCmF513dNPrdvkb4DPr+o3041RnxsgpiTEFsc/hFe43Jtl
         D8+A==
X-Gm-Message-State: AOAM532z+QikyT6A2ItCWw3M3R0vytiiMl0vq/DdcMIHsEW6BvIMbFRj
        5k/LEDYATILohpUFq3wvpWMpVsLbC/C72ygE1luCqqlQO6w32oLOmNnSIu15nDlDiYNMUsahqFU
        mHOdP1eEJ+LlUh0GmOh8cJw==
X-Received: by 2002:a05:6214:e8b:: with SMTP id hf11mr1698281qvb.40.1636109032807;
        Fri, 05 Nov 2021 03:43:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydcGBJh4ABuek/TqCA4f/1jsNvt3EaipOc0KEuPei6OV/kX+o+kG9UzlDbBG/thaIwlmKKKw==
X-Received: by 2002:a05:6214:e8b:: with SMTP id hf11mr1698270qvb.40.1636109032667;
        Fri, 05 Nov 2021 03:43:52 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id o12sm1951528qko.64.2021.11.05.03.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 03:43:52 -0700 (PDT)
Message-ID: <741eb031aa7e1dcd1fc766aa568551506e253252.camel@redhat.com>
Subject: Re: [PATCH v5 1/1] ceph: mount syntax module parameter
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, pdonnell@redhat.com,
        idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Date:   Fri, 05 Nov 2021 06:43:51 -0400
In-Reply-To: <20211103050039.371277-2-vshankar@redhat.com>
References: <20211103050039.371277-1-vshankar@redhat.com>
         <20211103050039.371277-2-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-11-03 at 10:30 +0530, Venky Shankar wrote:
> Add read-only paramaters for supported mount syntaxes. Primary
> user is the user-space mount helper for catching v2 syntax bugs
> during testing by cross verifying if the kernel supports v2 syntax
> on mount failure.
> 
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 609ffc8c2d78..32e5240e33a0 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1452,6 +1452,14 @@ bool disable_send_metrics = false;
>  module_param_cb(disable_send_metrics, &param_ops_metrics, &disable_send_metrics, 0644);
>  MODULE_PARM_DESC(disable_send_metrics, "Enable sending perf metrics to ceph cluster (default: on)");
>  
> +/* for both v1 and v2 syntax */
> +bool mount_support = true;

This bool should be static too. I'll just make that change in-tree, so
you don't need to re-post.

Thanks,

> +static const struct kernel_param_ops param_ops_mount_syntax = {
> +	.get = param_get_bool,
> +};
> +module_param_cb(mount_syntax_v1, &param_ops_mount_syntax, &mount_support, 0444);
> +module_param_cb(mount_syntax_v2, &param_ops_mount_syntax, &mount_support, 0444);
> +
>  module_init(init_ceph);
>  module_exit(exit_ceph);
>  

-- 
Jeff Layton <jlayton@redhat.com>

