Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A0660E2F1
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Oct 2022 16:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbiJZOMf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Oct 2022 10:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbiJZOMb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Oct 2022 10:12:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCC310D6A9
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 07:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666793548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5gKSzBMGRs/uWtkQG1q7CTLEsgBVK2NaY8cijVYGGgA=;
        b=SsdcsQshSUju4lda+utv+7YdEhxq0gt9oSwTL48tXXjpoagJrInYiaZreUHq9s2FyNSqwD
        cDuBFmOne+QinjyLI1KIWGfQlY9nDRta++AWNNwh68OITjNaUGkgpZYfpLn2MhH6VYkqVe
        1Aoi9b1mFxPTguginsfTtZKCVLoYbVQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-212-H9eJRUiMOGyyJCAul6cXKg-1; Wed, 26 Oct 2022 10:12:26 -0400
X-MC-Unique: H9eJRUiMOGyyJCAul6cXKg-1
Received: by mail-pl1-f197.google.com with SMTP id m11-20020a170902db0b00b00186d72ea4b8so2303005plx.23
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 07:12:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gKSzBMGRs/uWtkQG1q7CTLEsgBVK2NaY8cijVYGGgA=;
        b=xdl24YAncR9f4OvtWyH/vDyJ9rwyX8/3j+0Uq2cP4+T3bPfPK2DyMeg5fZG/0PzLA6
         yPIP52mIZDMUSXxNk/PqPgzk1BTq5X3LbGSmVj2V/TDxRGBmFkrgwntQhuBohEmm0JJf
         OoRsBN5ZFDveV49fqaSbFzmxJppkdVnLT5OJK/j9GjEjwDbzFw+Gr2l3ObpewryAZAhU
         LJKI1NUCeeWZz96ON0FdusxrSxh67NLgfpECebVjxCAQnnqxOECjdRx739yhvdQ6CPgx
         k1iA9m1Kt1KvHfdGYLbwAv8ROxf2UQAw8eAFQzuM8SdyXjJn0KsDkTSCTXMuO+LYWFzN
         smtQ==
X-Gm-Message-State: ACrzQf3b3UIrgDu7TSbRfw7zBmX4hglPXM+5Ra3EiPNJVYcOQn9XUMfJ
        eXdbqPXlB4mzmiORKFH7u71XPFJVt6KnKAMAeUqVGG4t422gRAYVn27a4xExm7p89P1NBb00FR8
        uJNU/FuLe8rjurBF9NXtWFQ==
X-Received: by 2002:a17:903:32cb:b0:186:deec:cd9f with SMTP id i11-20020a17090332cb00b00186deeccd9fmr2522038plr.82.1666793545109;
        Wed, 26 Oct 2022 07:12:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4vts4EIwMBrmcHQRDKwEWtkUdrUle9EHgYf9L9DAWDrNkCRpJjiebCyFeiTGY78iIplYU9sA==
X-Received: by 2002:a17:903:32cb:b0:186:deec:cd9f with SMTP id i11-20020a17090332cb00b00186deeccd9fmr2522017plr.82.1666793544785;
        Wed, 26 Oct 2022 07:12:24 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r17-20020a63ce51000000b0041a6638b357sm2854822pgi.72.2022.10.26.07.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 07:12:24 -0700 (PDT)
Date:   Wed, 26 Oct 2022 22:12:18 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        lhenriques@suse.de, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
Subject: Re: [PATCH 2/2] encrypt: add ceph support
Message-ID: <20221026141218.wg2h3ganvo2dx7hb@zlang-mailbox>
References: <20221026070418.259351-1-xiubli@redhat.com>
 <20221026070418.259351-3-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026070418.259351-3-xiubli@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Oct 26, 2022 at 03:04:18PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For ceph we couldn't use the mkfs to check whether the encryption
> is support or not, we need to mount it first and then check the
> 'set_encpolicy', etc.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  common/encrypt | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/common/encrypt b/common/encrypt
> index fd620c41..e837c9de 100644
> --- a/common/encrypt
> +++ b/common/encrypt
> @@ -153,6 +153,23 @@ _scratch_check_encrypted()
>  		# erase the UBI volume; reformated automatically on next mount
>  		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
>  		;;
> +	ceph)
> +		# Try to mount the filesystem. We need to check whether the encryption
> +		# is support or not via the ioctl cmd, such as 'set_encpolicy'.
> +		if ! _try_scratch_mount &>>$seqres.full; then
> +			_notrun "kernel is unaware of $FSTYP encryption feature," \
> +				"or mkfs options are not compatible with encryption"
> +		fi
> +
> +		mkdir $SCRATCH_MNT/tmpdir
> +		if _set_encpolicy $SCRATCH_MNT/tmpdir 2>&1 >>$seqres.full | \
> +			grep -Eq 'Inappropriate ioctl for device|Operation not supported'
> +		then
> +			_notrun "kernel does not support $FSTYP encryption"
> +		fi
> +		rmdir $SCRATCH_MNT/tmpdir
> +		_scratch_unmount

As I replied in patch 1/2, this function is a mkfs function, if ceph need a
specific mkfs way, you can do it in this function, or you even can keep it
empty

  ceph)
	;;

Or does a simple cleanup

  ceph)
	_scratch_cleanup_files
	...
	;;

I'm not familar with ceph, that depends on you. But the change in this patch is
not "mkfs", it's a checking, checking if the current $SCRATCH_MNT supports
encryption, you should do it in other function which does that checking job, not
change a mkfs function to be a check function.

Thanks,
Zorro

> +		;;
>  	*)
>  		_notrun "No encryption support for $FSTYP"
>  		;;
> -- 
> 2.31.1
> 

