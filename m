Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653DB6FBC93
	for <lists+ceph-devel@lfdr.de>; Tue,  9 May 2023 03:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbjEIBhM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 May 2023 21:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjEIBhK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 May 2023 21:37:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862094494
        for <ceph-devel@vger.kernel.org>; Mon,  8 May 2023 18:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683596184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5C+6HSU0Jz2TdbMrLn8cZbBlX8OEJw4kYUwzdupPCPY=;
        b=JT0ggV9UoOSvF730f2j9IZ/W1vz5XOJuq3Vq/2cuoHGGMso8aY4DBiog/HvxoLRjVhjbnT
        29Ie/cxUxyT5+VsXC05ZCSAtMl5o4dTVkwxiEZLpAW7pxPAGG3wvG7G9kKM3+adl+HwVxj
        hZzB7e7PEu/cFcQMdtlMV8wSFYvvLFw=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-fmlhik8HOX62pE0FMYWJhA-1; Mon, 08 May 2023 21:36:23 -0400
X-MC-Unique: fmlhik8HOX62pE0FMYWJhA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1ac3606cd9eso28606555ad.2
        for <ceph-devel@vger.kernel.org>; Mon, 08 May 2023 18:36:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683596182; x=1686188182;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5C+6HSU0Jz2TdbMrLn8cZbBlX8OEJw4kYUwzdupPCPY=;
        b=JAxGYcXmA0ne6h2WmY1xOliGJJjAWuH8sO6svCp+DT8RZiGYN9an3UHXKXxs2Es4ja
         QMWvLwIEJhBibRP1VMeXHlYwe4FrsgNNPZNbKYv2d4kMXQjota2OCionJvJY0DbOFPMY
         Z6gW/TdmnpYiiF8TwEU0JEAX4173gX8YOflioN5q6/15lcaZjwpjTWMrmQ5dYDRB2U4W
         L093sIDe3DxKCFea+YvqWR6dSEV0iPzH0pjFW1EI+O2fDlhbV2ek1ij4EuNJn/B6cO26
         ejEWZ4z7GtCAY1BetNdaPj+ZlqqAw0pziBminsIr3bN/TUn93MDPAryhiwt5S0DrOgJC
         U24g==
X-Gm-Message-State: AC+VfDyyBWEcVmCNrHo/uvJ6Ghkd1QHoxDOH/3XAHw19GlbNu4BPheY5
        vcUHUribt5ZqUmsHbqK8VhyOojUnsoN5NoDkCQwWRoVWVrDBpWS9t6IhrLabvMmk2IxlWilYjcW
        7g5YzNGvLIw4FXOupXb+UIg==
X-Received: by 2002:a17:903:2312:b0:1ac:656f:a697 with SMTP id d18-20020a170903231200b001ac656fa697mr9694359plh.21.1683596182473;
        Mon, 08 May 2023 18:36:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4oc4Aw58D/v/CA0xpwhDK7vH+OGvWj01cYzKVO90LgKDzHP5sjoxoEaHgHuOGKVIt9/zr3IA==
X-Received: by 2002:a17:903:2312:b0:1ac:656f:a697 with SMTP id d18-20020a170903231200b001ac656fa697mr9694334plh.21.1683596182203;
        Mon, 08 May 2023 18:36:22 -0700 (PDT)
Received: from [10.72.12.156] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l4-20020a170902f68400b001a19f3a661esm133810plg.138.2023.05.08.18.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 18:36:21 -0700 (PDT)
Message-ID: <1c6da9b7-f424-1713-23a6-15999d954f28@redhat.com>
Date:   Tue, 9 May 2023 09:36:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/3] ceph: save name and fsid in mount source
Content-Language: en-US
To:     Hu Weiwen <huww98@outlook.com>, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB206604655F7CAB7C50C6218FC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <TYCP286MB206604655F7CAB7C50C6218FC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/8/23 01:55, Hu Weiwen wrote:
> From: Hu Weiwen <sehuww@mail.scut.edu.cn>
>
> We have name and fsid in the new device syntax.  It is confusing that
> the kernel accept these info but do not take them into account when
> connecting to the cluster.
>
> Although the mount.ceph helper program will extract the name from device
> spec and pass it as name options, these changes are still useful if we
> don't have that program installed, or if we want to call `mount()'
> directly.
>
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
>   fs/ceph/super.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 4e1f4031e888..74636b9383b8 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -267,6 +267,7 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
>   	struct ceph_fsid fsid;
>   	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
>   	struct ceph_mount_options *fsopt = pctx->opts;
> +	struct ceph_options *copts = pctx->copts;
>   	char *fsid_start, *fs_name_start;
>   
>   	if (*dev_name_end != '=') {
> @@ -285,6 +286,12 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
>   
>   	if (ceph_parse_fsid(fsid_start, &fsid))
>   		return invalfc(fc, "Invalid FSID");
> +	if (!(copts->flags & CEPH_OPT_FSID)) {
> +		copts->fsid = fsid;
> +		copts->flags |= CEPH_OPT_FSID;
> +	} else if (ceph_fsid_compare(&fsid, &copts->fsid)) {
> +		return invalfc(fc, "Mismatching cluster FSID");
> +	}
>   
>   	++fs_name_start; /* start of file system name */
>   	len = dev_name_end - fs_name_start;
> @@ -298,6 +305,16 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
>   	}
>   	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
>   
> +	len = fsid_start - dev_name - 1;
> +	if (!copts->name) {
> +		copts->name = kstrndup(dev_name, len, GFP_KERNEL);
> +		if (!copts->name)
> +			return -ENOMEM;

Shouldn't we kfree the 'copts->mds_namespace' here ?


> +	} else if (!strstrn_equals(copts->name, dev_name, len)) {
> +		return invalfc(fc, "Mismatching cephx name");
> +	}
> +	dout("cephx name '%s'\n", copts->name);
> +
>   	fsopt->new_dev_syntax = true;
>   	return 0;
>   }

