Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C70444009
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Nov 2021 11:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhKCKge (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Nov 2021 06:36:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231278AbhKCKgd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Nov 2021 06:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635935636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+corCrLYJVPhYk6IeS+pnaIDwbUrdRPdDBN9srlqsy4=;
        b=XWyvlH6nC13QmC4NLrMggAZv44PMUZ8DP2zj866U3TGsaJONmi4O7X1R8tyvwkopPRvMPM
        WmBGfqhZ6Rv+svFxN+FEgxNb00jyfa5IrleHsWHlLImfQEKkWk4G2jx/490Jmw1FtoLnjh
        OtEXm2fgGBDZxeR9UmPjlf452uTPBgs=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-HD9HQNj6NDGC2bdjjLb2Fg-1; Wed, 03 Nov 2021 06:33:55 -0400
X-MC-Unique: HD9HQNj6NDGC2bdjjLb2Fg-1
Received: by mail-qt1-f198.google.com with SMTP id w12-20020ac80ecc000000b002a7a4cd22faso368249qti.4
        for <ceph-devel@vger.kernel.org>; Wed, 03 Nov 2021 03:33:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+corCrLYJVPhYk6IeS+pnaIDwbUrdRPdDBN9srlqsy4=;
        b=t2gpQxT9D9BswL+YQxFGZpsAvJO9xeDVU+lslSDiKFHlW7cTsDYFY1db9m3sCpd1Na
         ZkRGfua+Rje0zNXIF9uOJ/D81NHKNilTreulplmhNMbJb1CcSeVFtqxhpPBZ//ebmmkL
         TptETN/0ZQ2O+IbbHPMzpLszTEnUIyUguMVRWj86urZsPyiz9TU8UIIrniPEHzFjx5/K
         L7YwkALDU41s5CqrPc33f9gb5oN6J/wVK4WAapdnLfTX6bMSiglYhhzdCmVTc95I6V5p
         8BE3S6KhaAF1vfVVyoU3jfh5jkujG3SvX55KYXwmGhGDypbRKDCk8c994BFVqCvH4aBF
         7NRA==
X-Gm-Message-State: AOAM531sL1zK2/Z/Hzv4jsznByUP3HRC5rq4xLUC31cA335eyDwjRYFY
        sS4mGHgWXq3+P8ZLwJFyn87+Lr0Bpsu4p6iq0+/By99uORjaYvVNZSifCwOqt4U6NuCOrqRrzEn
        c9E8Ato5DDrFRacCyDjHsNQ==
X-Received: by 2002:a05:622a:54a:: with SMTP id m10mr38910572qtx.239.1635935634995;
        Wed, 03 Nov 2021 03:33:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgEov9Tl8qh6MP2nfo/JZLsD0HBzJmVRUJHe0SxXo9MBmtccfhMPoNzu0zKxZRpfR1Pn+GJg==
X-Received: by 2002:a05:622a:54a:: with SMTP id m10mr38910557qtx.239.1635935634830;
        Wed, 03 Nov 2021 03:33:54 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id w9sm1219275qko.19.2021.11.03.03.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 03:33:54 -0700 (PDT)
Message-ID: <370d927cb6108a0242be90fedfb59df2831bca9b.camel@redhat.com>
Subject: Re: [PATCH v5 1/1] ceph: mount syntax module parameter
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, pdonnell@redhat.com,
        idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Date:   Wed, 03 Nov 2021 06:33:53 -0400
In-Reply-To: <20211103050039.371277-2-vshankar@redhat.com>
References: <20211103050039.371277-1-vshankar@redhat.com>
         <20211103050039.371277-2-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.0 (3.42.0-1.fc35) 
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
> +static const struct kernel_param_ops param_ops_mount_syntax = {
> +	.get = param_get_bool,
> +};
> +module_param_cb(mount_syntax_v1, &param_ops_mount_syntax, &mount_support, 0444);
> +module_param_cb(mount_syntax_v2, &param_ops_mount_syntax, &mount_support, 0444);
> +
>  module_init(init_ceph);
>  module_exit(exit_ceph);
>  

Thanks Venky. This looks good. Merged into testing.

Note that these new parameters are not visible via modinfo, but they do
show up in /sys/module/ceph/parameters.
-- 
Jeff Layton <jlayton@redhat.com>

