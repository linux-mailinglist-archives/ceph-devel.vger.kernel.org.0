Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BDE532F57
	for <lists+ceph-devel@lfdr.de>; Tue, 24 May 2022 19:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239775AbiEXRB1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 May 2022 13:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239698AbiEXRBZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 May 2022 13:01:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01BE9111E
        for <ceph-devel@vger.kernel.org>; Tue, 24 May 2022 10:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653411683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b54mK8xYCAhXsjzahjRnSBRagXlWJQyhFWbgJ8hoi5w=;
        b=ZW4F7IBXPJQeU6N2k0atwSegBIGBCz3+i8amSq2OKQwfWYxQ4UJzrT3X2i9ih/B/y8uf6s
        Y6cULfbQB11xQ/SupBMklKrcVHF5inyBJPc8z4Rd68MKhmDA+2zU1AlFtDKRxpqa7qTqNx
        HbqhwMwBuCsK5BWBAxnxWPZ3H5f4Bnk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-KGFcHVlnPIysB9EqL8NqXQ-1; Tue, 24 May 2022 12:59:33 -0400
X-MC-Unique: KGFcHVlnPIysB9EqL8NqXQ-1
Received: by mail-qv1-f70.google.com with SMTP id kk13-20020a056214508d00b004622b4b8762so5787559qvb.4
        for <ceph-devel@vger.kernel.org>; Tue, 24 May 2022 09:59:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=b54mK8xYCAhXsjzahjRnSBRagXlWJQyhFWbgJ8hoi5w=;
        b=I4adDCmmjPqls/Wcttf4eoZ+1WBJxuVGgLM+9emtc/GS+OeZwg4Nn3YgtfuqtAaEKV
         gux6BQR6EecaVuWJqwZY5STGpUQ8pCJ7PDpQZy87IPIGCx3YhyFDMoiI7cY9QJ0bOQgs
         0JYXe7wSj50EtUy4dcAo5oLJOkT0rBcD6W9SCmvrsAamINrWEA1NUGIvQUXJ0owQ562R
         9ni7cJ89LvrkGNOUlSoxcirRk+c6NO2R4ybWeGDoAOqNTffnINJ+NoqI4hbPfKAAQRJD
         ucgngGzOmgieohR4dBPl7NxS90UtneyI8wZuvUlvS85J9/+6czCtyjJ6QB10zR4Lj5Zv
         qLHw==
X-Gm-Message-State: AOAM530MeWuF6YptyzjKWfm2O1+yYBrWMfLykbrPBkemD7V/vnnwuNPl
        jsEwkrowT7G+HHeksKsQHjh/nw303WN7jycTLqOSZzSNHCqVFPTJtMHn9oyUUty/fTy8/7e+6Dw
        PeFwhofAkQpChAkaGJt7RcQ==
X-Received: by 2002:a05:620a:b82:b0:6a3:9b26:d45 with SMTP id k2-20020a05620a0b8200b006a39b260d45mr6240286qkh.405.1653411572135;
        Tue, 24 May 2022 09:59:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPyK2cw49Zhkd3Nrx1cc7EK/KDdwr+rp6Aera4mFJx0isFVnaca45lMCeABPU1AAZM8KGS8A==
X-Received: by 2002:a05:620a:b82:b0:6a3:9b26:d45 with SMTP id k2-20020a05620a0b8200b006a39b260d45mr6240267qkh.405.1653411571864;
        Tue, 24 May 2022 09:59:31 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k12-20020a05620a138c00b0069fcc501851sm6179209qki.78.2022.05.24.09.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 09:59:31 -0700 (PDT)
Date:   Wed, 25 May 2022 00:59:26 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     =?utf-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] ceph/001: skip metrics check if no copyfrom mount
 option is used
Message-ID: <20220524165926.dkighy46hi75mg6s@zlang-mailbox>
References: <20220524094256.16746-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220524094256.16746-1-lhenriques@suse.de>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, May 24, 2022 at 10:42:56AM +0100, Luís Henriques wrote:
> Checking the metrics is only valid if 'copyfrom' mount option is
> explicitly set, otherwise the kernel won't be doing any remote object
> copies.  Fix the logic to skip this metrics checking if 'copyfrom' isn't
> used.
> 
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>  tests/ceph/001 | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Changes since v1:
> - Quoted 'hascopyfrom' variable in 'if' statement; while there, added
>   quotes to the 'if' statement just above.

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> diff --git a/tests/ceph/001 b/tests/ceph/001
> index 7970ce352bab..060c4c450091 100755
> --- a/tests/ceph/001
> +++ b/tests/ceph/001
> @@ -86,11 +86,15 @@ check_copyfrom_metrics()
>  	local copies=$4
>  	local c1=$(get_copyfrom_total_copies)
>  	local s1=$(get_copyfrom_total_size)
> +	local hascopyfrom=$(_fs_options $TEST_DEV | grep "copyfrom")
>  	local sum
>  
> -	if [ ! -d $metrics_dir ]; then
> +	if [ ! -d "$metrics_dir" ]; then
>  		return # skip metrics check if debugfs isn't mounted
>  	fi
> +	if [ -z "$hascopyfrom" ]; then
> +		return # ... or if we don't have copyfrom mount option
> +	fi
>  
>  	sum=$(($c0+$copies))
>  	if [ $sum -ne $c1 ]; then
> 

