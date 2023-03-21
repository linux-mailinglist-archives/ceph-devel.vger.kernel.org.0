Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18956C3436
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Mar 2023 15:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCUO26 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Mar 2023 10:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbjCUO2y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 21 Mar 2023 10:28:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8EE298EA
        for <ceph-devel@vger.kernel.org>; Tue, 21 Mar 2023 07:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679408805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O4jIFKWJ7SQI7m658zRDkXZ0H8i+ZzhD1x6hqFYzqA0=;
        b=epzt/hO/GZxG92YLEz7yb033aN/aqqQmoGc9lAS41FS6lBB5ey6oRSrBuZ7LL44cn77m5E
        KwF4bupmCCV6hUWZB/KFDNlgSwFCnXMp+YZHtuHTSyBGtf5G+Kfb9e0c+LE0b86YPAbuDQ
        P3c0s4c0x1heRZnAZ32rsyFIYqm664M=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-2gQeqiCuOsyOZdimlND_3Q-1; Tue, 21 Mar 2023 10:26:43 -0400
X-MC-Unique: 2gQeqiCuOsyOZdimlND_3Q-1
Received: by mail-pl1-f199.google.com with SMTP id d2-20020a170902cec200b001a1e8390831so565587plg.5
        for <ceph-devel@vger.kernel.org>; Tue, 21 Mar 2023 07:26:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679408802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4jIFKWJ7SQI7m658zRDkXZ0H8i+ZzhD1x6hqFYzqA0=;
        b=c9re2oz/vEUPC9B9IuUASd1AXej2eSHr9WmN/iV8oI+nK1pj6l8Qu4FMmUbQI7NmGz
         rJNYrMFJwtVFo4zKGSjEZ9VJ3CXoOXXRWtjmYYw7RZZBKpS5yekM25VfLKm18ho/q+kH
         0Pu2mwCCwPyS5yrFugV03rHLG74N8J1hV1sDaqzYWuXqcULxO2O9likY9gqTE/LQ6xwX
         uCF4iDQL0E+PVM97uIb9Vk8XxgV5xvimNHbSKa1AOT3U0JTfJBk634ByjhoizLTbjyib
         LU68lCheIEAzIEzNotN8Xn7fA1yf2Ow2folomOQirmt5+3j1X/yKvYcTFAMWauuGtnV7
         0O3g==
X-Gm-Message-State: AO0yUKU3az0TYMTRsPPaDOPiGfNZc2196mWrfFIckzKaUF1otenTpHMh
        35Bpj7FxLHiwp81NGnIGNHTj19KLRKR+aL1EiU4B981aHmGDYsSH/7xf89XCs1ZYtnnlR4jM/2B
        kDPzlswbRFb/7vNaYFVwSFlVsJJ75E2p4
X-Received: by 2002:a17:90a:304:b0:233:feb4:895f with SMTP id 4-20020a17090a030400b00233feb4895fmr2822564pje.44.1679408802555;
        Tue, 21 Mar 2023 07:26:42 -0700 (PDT)
X-Google-Smtp-Source: AK7set/sWUhEPTfuqJB7GzmP2Dy1D/saNevsiZvy+6hBuW5V+KoVpmL7SLNuNAs3mC9pCjoVF7Td9g==
X-Received: by 2002:a17:90a:304:b0:233:feb4:895f with SMTP id 4-20020a17090a030400b00233feb4895fmr2822546pje.44.1679408802219;
        Tue, 21 Mar 2023 07:26:42 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902edc200b001a1a18a678csm8853059plk.148.2023.03.21.07.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 07:26:40 -0700 (PDT)
Date:   Tue, 21 Mar 2023 22:26:36 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] generic/020: fix another really long attr test failure
 for ceph
Message-ID: <20230321142636.epdz3wtbksmnsumk@zlang-mailbox>
References: <20230319062928.278235-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230319062928.278235-1-xiubli@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Mar 19, 2023 at 02:29:27PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the CONFIG_CEPH_FS_SECURITY_LABEL is disabled the kernel ceph
> the 'selinux_size' will be empty and then:
> max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))
> will be:
> max_attrval_size=$((65536 - $size - - $max_attrval_namelen))
> which equals to:
> max_attrval_size=$((65536 - $size + $max_attrval_namelen))
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---

Makes sense to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/020 | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tests/generic/020 b/tests/generic/020
> index 538a24c6..e00365a9 100755
> --- a/tests/generic/020
> +++ b/tests/generic/020
> @@ -154,6 +154,12 @@ _attr_get_maxval_size()
>  			awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
>  		local selinux_size=$(getfattr -n 'security.selinux' --dump -e hex $filename 2>/dev/null | \
>  			awk -F "=0x" '/^security/ {len += length($1) + length($2) / 2} END {print len}')
> +		if [ -z $size ]; then
> +			size=0
> +		fi
> +		if [ -z $selinux_size ]; then
> +			selinux_size=0
> +		fi
>  		max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))
>  		;;
>  	*)
> -- 
> 2.31.1
> 

