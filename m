Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D4560EE79
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 05:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbiJ0DU4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Oct 2022 23:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbiJ0DUs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Oct 2022 23:20:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C073BC74
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 20:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666840832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vVtv2gEOXwWxsxQ2dXTwNAFxDEUlqDwGil1CtfjnUKE=;
        b=epGDlAAoyldozKxyuFsGl/AnY8lqufgcIjNFuj54Wyzf88heXqigBAjA7FHtLSaUBp876D
        CpVXlJD3bb/mzzALf8OUfMJ0w09YbOqYA8dpETzcNcV5JTsJX5t7Ptm4UmpJl+s2nExuwu
        LugcTiSK2hJePou7h0QSb69Fnf1xSKk=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-392-gUOLog1DO9-6zfHWYdrHhg-1; Wed, 26 Oct 2022 23:20:30 -0400
X-MC-Unique: gUOLog1DO9-6zfHWYdrHhg-1
Received: by mail-pf1-f198.google.com with SMTP id bd33-20020a056a0027a100b005665e548115so115011pfb.10
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 20:20:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVtv2gEOXwWxsxQ2dXTwNAFxDEUlqDwGil1CtfjnUKE=;
        b=Y2KSnZiiMI6saLb+H8dks++JClFTJWfwYlPJ5M0JbXCcIsbBf1Jt0Bs0WfgHA/hMF9
         lOsR62UoEbKZeNn2zv2rmAzhGCEf0U7j5sQ+KyqmkXfNV9UR0UScso2xH6xf842Kd0Zf
         ko9EBftCA7KBc6sGHBefo4tFPhsd30UdeqHMwu+EQBHCTlhXTVeFdFGuR1rG0UOOAT3Q
         6b8+dwnmxJG3LmUy8iymNS2kmy0jbc7YWfHEr87P4xU09TGKhE0qi6fDY9PyQY6DfwZQ
         vsSRQ2t3gBawbqM+4/abLd00xl5krJk6vI/AVfRQ4uogA/9N3gJN+iGtOxTf3qKtfxe6
         S2Kw==
X-Gm-Message-State: ACrzQf2lOjPjk8cAlDkgorYVzK75aF27WzRErNWjY6805FRQ57Lb9yE6
        Lrox8oCGbx4JXAYNeUxJq7VdgJ74pc/EKY0LnAnjmnt3Y0ZmQ3yMvatb1+nF0LJiFpCPdy590XB
        vGYDVst4UBh42DQ1syab5fA==
X-Received: by 2002:a65:6e0d:0:b0:42d:707c:94ee with SMTP id bd13-20020a656e0d000000b0042d707c94eemr39077996pgb.260.1666840829498;
        Wed, 26 Oct 2022 20:20:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5+yfBAoCp6uyp6o7TVEPeswC5zUFURA/lckrWVruS6dCVyEKinOQHL7qjva5ixmmf+0ZCF4w==
X-Received: by 2002:a65:6e0d:0:b0:42d:707c:94ee with SMTP id bd13-20020a656e0d000000b0042d707c94eemr39077986pgb.260.1666840829242;
        Wed, 26 Oct 2022 20:20:29 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id sf5-20020a17090b51c500b0020adab4ab37sm107358pjb.31.2022.10.26.20.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 20:20:28 -0700 (PDT)
Date:   Thu, 27 Oct 2022 11:20:23 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        lhenriques@suse.de, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
Subject: Re: [PATCH v2] encrypt: add ceph support
Message-ID: <20221027032023.6arvnrkl7fymdjqj@zlang-mailbox>
References: <20221027030021.296548-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027030021.296548-1-xiubli@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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

Any commits about that?

Sorry I'm not familar with cephfs, is this patch enough to help ceph to test
encrypted ceph? Due to you tried to do some "checking" job last time.

Can "./check -g encrypt" work on ceph? May you paste this test result to help
to review? And welcome review points from ceph list.

Thanks,
Zorro

[1]
$ grep -rsn _scratch_mkfs_encrypted tests/generic/
tests/generic/395:22:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/396:21:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/580:23:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/581:36:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/595:35:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/613:29:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/621:57:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/429:36:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/397:28:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/398:28:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/421:24:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/440:29:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/419:29:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/435:33:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/593:24:_scratch_mkfs_encrypted &>> $seqres.full
tests/generic/576:34:_scratch_mkfs_encrypted_verity &>> $seqres.full

>  	*)
>  		_notrun "No encryption support for $FSTYP"
>  		;;
> -- 
> 2.31.1
> 

