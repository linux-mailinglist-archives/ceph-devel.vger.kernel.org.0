Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8DF60F82F
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 14:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiJ0M4Q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Oct 2022 08:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbiJ0M4P (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Oct 2022 08:56:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D02625DA
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 05:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666875372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WMSwF060H2g+KMRoX/GNSVdcFUqfmSUoNCnHJHL7JbE=;
        b=hfluMLHgY8gVtjGcrpjsdvutFFzytQUqQjrb8oB3BOhC452g3DSk9mQHNb9PZZ3K7edzvc
        pAMR4d9+gLUVWgcdh4t3OanhUyBCqf1IVrsJCOLqlrpVUiFPlSE73/nbMXTFsq8MOmnRme
        1utCmHY2CoMblX0umiCqb2U07sL/kCU=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-377-GTforQ1LPHGQbwzylYKSSw-1; Thu, 27 Oct 2022 08:56:11 -0400
X-MC-Unique: GTforQ1LPHGQbwzylYKSSw-1
Received: by mail-pf1-f200.google.com with SMTP id bd33-20020a056a0027a100b005665e548115so810118pfb.10
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 05:56:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WMSwF060H2g+KMRoX/GNSVdcFUqfmSUoNCnHJHL7JbE=;
        b=lmgF9SaJD0K3MuukdVKWyW9TTXmiqPsbAdI8MU8jMapd2vOzTfOY8jPN4Z1rHKD+xS
         iUIfu3cdyVni4+REoGhNbTuZqw1oUwrfZh2stH15o3e6chRnKlRCV10lyi3tsxzbbpKg
         K1LlnSCu5eg5k27QiGvUv5DlhRXqlDm6hUN+XAZjBtwBdIeBD97CVa5yon8Q4pNUeN7W
         yCct/soix7xHMl8hKXZ0jX90swnAaiUTvzDEPC4INxUQHV38DX6N2drLIvQipp3ixS74
         lVkAToxoAT9cqJny+emXFv8xlHR8lk8x4iIz/FHZDH8KLrMuXT1gn7vbGSEj0MpVknEk
         0Krw==
X-Gm-Message-State: ACrzQf1gfVlt35KzRxekVytiWmjJi0BFu4j2ifERMu8sF9K7Be17lBrZ
        YCP1WovpeqOVrRr4T6RiLH9fzDP7speTfe8Ft87+iSy6JAa/IfGWL/JqJg8eq1FvJvn0vqMWCYd
        FQofHpUyIlLZ9af+Jc9rS1Q==
X-Received: by 2002:a63:8943:0:b0:46f:3a91:3618 with SMTP id v64-20020a638943000000b0046f3a913618mr9581771pgd.16.1666875369524;
        Thu, 27 Oct 2022 05:56:09 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6LcGYOw1KEv4brzej4F4BOR3aPBHNn4xm3K6kcotkbdmYs51YvEMV3XFWYUpGzXbParUt6nQ==
X-Received: by 2002:a63:8943:0:b0:46f:3a91:3618 with SMTP id v64-20020a638943000000b0046f3a913618mr9581752pgd.16.1666875369243;
        Thu, 27 Oct 2022 05:56:09 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902e54100b0016be834d54asm1119869plf.306.2022.10.27.05.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 05:56:08 -0700 (PDT)
Date:   Thu, 27 Oct 2022 20:56:04 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] encrypt: add ceph support
Message-ID: <20221027125604.d2v7ubyfmuxuu73t@zlang-mailbox>
References: <20221027030021.296548-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027030021.296548-1-xiubli@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 27, 2022 at 11:00:21AM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---

According to more details (in this mail thread) about this patch, I think
this patch works. So I'd like to give it my:

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/encrypt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/encrypt b/common/encrypt
> index 45ce0954..1a77e23b 100644
> --- a/common/encrypt
> +++ b/common/encrypt
> @@ -153,6 +153,9 @@ _scratch_mkfs_encrypted()
>  		# erase the UBI volume; reformated automatically on next mount
>  		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
>  		;;
> +	ceph)
> +		_scratch_cleanup_files
> +		;;
>  	*)
>  		_notrun "No encryption support for $FSTYP"
>  		;;
> -- 
> 2.31.1
> 

