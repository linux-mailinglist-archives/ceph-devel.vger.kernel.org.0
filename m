Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5816A3E86
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 10:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjB0Jmb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Feb 2023 04:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjB0Jma (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Feb 2023 04:42:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469B8EC7A
        for <ceph-devel@vger.kernel.org>; Mon, 27 Feb 2023 01:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677490905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wRxOtFs1agaSCqaBeVM7mGGf4S+32vV+Ksknvvsif0=;
        b=LwwEfam+aeIpox/FQMcpk5tmLyo9ICGclgWneBv0TStrSk05TqeW/YIowroPjnH/R033nY
        QpXQ+7w7WzASWNXwyvu7HbtmzppnKKBxlOja7uWuj31ma68eYprS7aJhR//CeE2faLF4fm
        5pynNKPmDN1XOQXZlSj0OJm8ZtQBVTQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-479-oHmUkU_DNxqthl-et89jVw-1; Mon, 27 Feb 2023 04:41:41 -0500
X-MC-Unique: oHmUkU_DNxqthl-et89jVw-1
Received: by mail-pf1-f198.google.com with SMTP id i11-20020a056a00224b00b005d44149eb06so3151060pfu.10
        for <ceph-devel@vger.kernel.org>; Mon, 27 Feb 2023 01:41:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7wRxOtFs1agaSCqaBeVM7mGGf4S+32vV+Ksknvvsif0=;
        b=WDARQVZKT387L3L/pcFiJldS2xGP//aLHOSp1x2FU43anjfsT/KlX8vYD3siQ+Jlkd
         zN2PRQOB02uWFmDbJf+BmnTPxEZdUoY1uqWM+oQ0hEE4O9IhTBb5YoUn6V67aUiQIJPQ
         ktSVnxNbEO3PU++bmaDw7Wv3HnrHt1MxVdPb6q0LWV20qmUEJ3KZ4dCQyJGHHukbOAVB
         DmQRpvpOMQWkuPd7xJaZDPC0qSOh8Iqe/ubHl5evEXm5ZHnC5wbtf2jAs+NpRwIzEY81
         /qm67p2nH6hfPGPj1U/Uf7P03SLTlcAgLldiYYmzt93waEdg7IKgzntVVcJdvk8EWccB
         8ReA==
X-Gm-Message-State: AO0yUKV+dSHpGh9rp2id3KoQE11MDmP6fq7/vVNvB0cHP55HAN46YqeP
        PpHfEnqrRER8SEMUVyAVeeuM7RlUoHgv1syHJDc2ZkpG1N6+E6rRcagwa6gvnFXYfA8sxzoFarT
        WQbMBXBPTHAUdTBnenbwcrQ==
X-Received: by 2002:a17:902:e851:b0:19b:c2d:1222 with SMTP id t17-20020a170902e85100b0019b0c2d1222mr29503259plg.52.1677490900625;
        Mon, 27 Feb 2023 01:41:40 -0800 (PST)
X-Google-Smtp-Source: AK7set+a8XkuK/qdBs5cqH6EbV1PoH59Jo4XihABo+akVd840bOVrDHaz1LjFB/9tvHvX6wlE7Zmjw==
X-Received: by 2002:a17:902:e851:b0:19b:c2d:1222 with SMTP id t17-20020a170902e85100b0019b0c2d1222mr29503240plg.52.1677490900130;
        Mon, 27 Feb 2023 01:41:40 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e23-20020a170902ed9700b001964c8164aasm4139189plj.129.2023.02.27.01.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 01:41:39 -0800 (PST)
Date:   Mon, 27 Feb 2023 17:41:35 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] generic/020: fix really long attr test failure for
 ceph
Message-ID: <20230227094135.yh7t6hfxgqkw2qcr@zlang-mailbox>
References: <20230227041358.350309-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227041358.350309-1-xiubli@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Feb 27, 2023 at 12:13:58PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the CONFIG_CEPH_FS_SECURITY_LABEL is enabled the kernel ceph
> itself will set the security.selinux extended attribute to MDS.
> And it will also eat some space of the total size.
> 
> Fixes: https://tracker.ceph.com/issues/58742
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---

This version looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> V2:
> - make the 'size' and the 'selinux_size' to be local
> 
>  tests/generic/020 | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/020 b/tests/generic/020
> index be5cecad..538a24c6 100755
> --- a/tests/generic/020
> +++ b/tests/generic/020
> @@ -150,9 +150,11 @@ _attr_get_maxval_size()
>  		# it imposes a maximum size for the full set of xattrs
>  		# names+values, which by default is 64K.  Compute the maximum
>  		# taking into account the already existing attributes
> -		max_attrval_size=$(getfattr --dump -e hex $filename 2>/dev/null | \
> +		local size=$(getfattr --dump -e hex $filename 2>/dev/null | \
>  			awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
> -		max_attrval_size=$((65536 - $max_attrval_size - $max_attrval_namelen))
> +		local selinux_size=$(getfattr -n 'security.selinux' --dump -e hex $filename 2>/dev/null | \
> +			awk -F "=0x" '/^security/ {len += length($1) + length($2) / 2} END {print len}')
> +		max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))
>  		;;
>  	*)
>  		# Assume max ~1 block of attrs
> -- 
> 2.31.1
> 

