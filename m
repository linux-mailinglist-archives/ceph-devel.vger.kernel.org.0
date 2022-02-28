Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13864C6568
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Feb 2022 10:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbiB1JG5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Feb 2022 04:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiB1JG4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 28 Feb 2022 04:06:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6628F33EBF
        for <ceph-devel@vger.kernel.org>; Mon, 28 Feb 2022 01:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646039177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UxOjvPrFBNhJz+yCZfcLG8UksIx5f8f03DNf3zt+I9k=;
        b=Djlwebcz1Vfr0irMXMEZKOwDrCm5kW7dpDyqt+wm2tttZ5yTYqUK+80csHCs2Hybk8OmSX
        TZMRDpsXE3j7fiacxISRirpJoycPJCwCRSvlhzYo3MkUo5GfBF6+GSgccxYn15h6g3GxUf
        xV6Il/LuUXQsb8hg6vJKytH1FcztAXI=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-5sC_Um54N1Ox_BDVrAzMRg-1; Mon, 28 Feb 2022 04:06:15 -0500
X-MC-Unique: 5sC_Um54N1Ox_BDVrAzMRg-1
Received: by mail-pg1-f198.google.com with SMTP id u10-20020a63df0a000000b0037886b8707bso1444759pgg.23
        for <ceph-devel@vger.kernel.org>; Mon, 28 Feb 2022 01:06:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UxOjvPrFBNhJz+yCZfcLG8UksIx5f8f03DNf3zt+I9k=;
        b=1vrhDfvp+h8vOAdIQ5FTfO+NsnWTx1xeBD7kBwTWEl/Kfsc3K/k2sw/2B1r1LegCZr
         he374I0XbjSr9/LjELhHM5w0HplwFY/2SlYZOgDjjMAqLt4dHo/SUORg64rEXTA2C0eK
         /lXWX4NyyRR4YyJTPWpGanb0ROL/rOucVs4tewp7/Wd+i2trcJu6mQTi5HaggL96i8OV
         3ViPU2nw9CfFStY2NWRnedsfNWLlQ5YVhz1XgS2w965WnJQWVf4Wo/NSL4jKBidOs8RB
         5Qe+crkptdrYNrdjkUIeVmeb4QNzgCPYVnP3pcJ+q2xm5PNIeTle1ZW+WMaJ/a0Yy2l0
         TVcg==
X-Gm-Message-State: AOAM530WB4MQJIolTRRVw53hCJqZ5lKE4eqi3e5uew+UHpPOT5Mh+Ss1
        dAowwtG9SO1lKvwJlAUBqb7gWCARS4kQxiSCDl68a5Xe0w87Phzum//5o/UmEmzqQtFI81JwbuD
        QhrLJ11TfVMCpSSYY20rc12v8VL1fMT1E4/QO3MLKDh4Fg3xw2/wHcceTrnsowJTNu5nDiRw=
X-Received: by 2002:a17:90a:a08c:b0:1bc:ff05:6f18 with SMTP id r12-20020a17090aa08c00b001bcff056f18mr13642523pjp.190.1646039173056;
        Mon, 28 Feb 2022 01:06:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqDVBHkxWNW23mYX5EPrlwZjQ9LNqdaCvxrZFoqefF64M9lXbeGwQt/pSHonAmKWDKKF513Q==
X-Received: by 2002:a17:90a:a08c:b0:1bc:ff05:6f18 with SMTP id r12-20020a17090aa08c00b001bcff056f18mr13642500pjp.190.1646039172688;
        Mon, 28 Feb 2022 01:06:12 -0800 (PST)
Received: from [10.72.12.114] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bh3-20020a056a02020300b00378b62df320sm1467643pgb.73.2022.02.28.01.06.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 01:06:12 -0800 (PST)
Subject: Re: [PATCH] ceph: increase the offset when fail to decode dentry
 names
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220228071442.48733-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <38cb4ef5-657b-8b15-82ea-6d41784f09d9@redhat.com>
Date:   Mon, 28 Feb 2022 17:06:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220228071442.48733-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

There still has bugs when skipping this.

We should just fail the readdir request and propagate the error to user 
space.

Sent a V2 to fix it.

- Xiubo


On 2/28/22 3:14 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> ------------[ cut here ]------------
> kernel BUG at fs/ceph/dir.c:537!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 16 PID: 21641 Comm: ls Tainted: G            E     5.17.0-rc2+ #92
> Hardware name: Red Hat RHEV Hypervisor, BIOS 1.11.0-2.el7 04/01/2014
>
> The corresponding code in ceph_readdir() is:
>
> 	BUG_ON(rde->offset < ctx->pos);
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/dir.c   | 13 +++++++------
>   fs/ceph/inode.c |  3 ++-
>   2 files changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index a449f4a07c07..f28eb568e0e2 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -534,6 +534,13 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   					    .ctext_len	= rde->altname_len };
>   		u32 olen = oname.len;
>   
> +		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> +		if (err) {
> +			pr_warn("Unable to decode %.*s. Skipping it.\n", rde->name_len, rde->name);
> +			ctx->pos++;
> +			continue;
> +		}
> +
>   		BUG_ON(rde->offset < ctx->pos);
>   		BUG_ON(!rde->inode.in);
>   
> @@ -542,12 +549,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   		     i, rinfo->dir_nr, ctx->pos,
>   		     rde->name_len, rde->name, &rde->inode.in);
>   
> -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> -		if (err) {
> -			dout("Unable to decode %.*s. Skipping it.\n", rde->name_len, rde->name);
> -			continue;
> -		}
> -
>   		if (!dir_emit(ctx, oname.name, oname.len,
>   			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 8b0832271fdf..b1552e6a6f0e 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1898,7 +1898,8 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>   
>   		err = ceph_fname_to_usr(&fname, &tname, &oname, &is_nokey);
>   		if (err) {
> -			dout("Unable to decode %.*s. Skipping it.", rde->name_len, rde->name);
> +			fpos_offset++;
> +			pr_warn("Unable to decode %.*s. Skipping it.", rde->name_len, rde->name);
>   			continue;
>   		}
>   

