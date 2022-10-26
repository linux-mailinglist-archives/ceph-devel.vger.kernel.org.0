Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8A460E2D3
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Oct 2022 16:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiJZOFE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Oct 2022 10:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbiJZOFB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Oct 2022 10:05:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E15E4AD41
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 07:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666793093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z14ZXZUzGKjReZ1Rm3C0eR5qgCTXW0HUh+T1+61zw04=;
        b=Pni3klrTd8DCXOjkCq9vF8XLiSz8b4+kaXHXYULBXE6B7NDJAr96A3Llvan3RB7bsfltyg
        eFBDQqRmkVbfG5j53rLoT0/M6rFDZDwBNjLCMeAtaw773Yx9euvPJdvIQZ+BfPXvoNV8em
        PtkbORUo3zKfmLNcH04vxb3A1tMiKpc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-674-JWa8f9BbO4usmneI3DaX1Q-1; Wed, 26 Oct 2022 10:04:52 -0400
X-MC-Unique: JWa8f9BbO4usmneI3DaX1Q-1
Received: by mail-pl1-f200.google.com with SMTP id n1-20020a170902f60100b00179c0a5c51fso10145550plg.7
        for <ceph-devel@vger.kernel.org>; Wed, 26 Oct 2022 07:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z14ZXZUzGKjReZ1Rm3C0eR5qgCTXW0HUh+T1+61zw04=;
        b=KGS6q3Avo8HEPt21G0TRGXDdMktaI3i+42Ax7+SJeY5BumFryK42NCInmeRil6BtmQ
         qWtWbuEg/YHwye8EmoHbRj0lXqBm80K0ZoMNLLySz970vTcXoBE/aEKrDNvzHaGJBicR
         Do+l9qu/P2cWWw3uFHmyHrxg4XW2mjUjLXTzx34itq+UGzzjck1NA7xramVBpJbYmTNt
         eYkk6+l/juE3ybabU0I7pHrAMSNHypRdEYnUWdxubCP0MMEIUaUG/jvJ6Rnt+HT0wupQ
         pzitIUQ1oj82nA2fZWEAqdgCrWp/xqpg/CYI5ccmN4fi6J35/NpyjtOwUSLLR5YkxEPS
         bxXA==
X-Gm-Message-State: ACrzQf14fShXlhtj3FvQRmaqchiIx8JDTXPhjHj7wvH2R5Buk6hr7Tdh
        2GlFJgiUi054zm6xio/l6UOfrsVIOCrwNcor2Wpix4/82mrn74s0pqIMRxu4W0vBwKVnypO/KFD
        b3cN4c85L0nS/hN6ZuKAgEw==
X-Received: by 2002:a63:5b48:0:b0:458:1e98:c862 with SMTP id l8-20020a635b48000000b004581e98c862mr36835964pgm.568.1666793090909;
        Wed, 26 Oct 2022 07:04:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM45M/RvgraTMViFW3UGbjujQk/5HvQTV8sCwa+XIyNFe+kZR7mDAILVMFTri37ekCTWdyHkXA==
X-Received: by 2002:a63:5b48:0:b0:458:1e98:c862 with SMTP id l8-20020a635b48000000b004581e98c862mr36835940pgm.568.1666793090617;
        Wed, 26 Oct 2022 07:04:50 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m3-20020a63fd43000000b004393c5a8006sm2872095pgj.75.2022.10.26.07.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 07:04:49 -0700 (PDT)
Date:   Wed, 26 Oct 2022 22:04:44 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        lhenriques@suse.de, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
Subject: Re: [PATCH 1/2] encrypt: rename _scratch_mkfs_encrypted to
 _scratch_check_encrypted
Message-ID: <20221026140444.6br63mundxivfsnn@zlang-mailbox>
References: <20221026070418.259351-1-xiubli@redhat.com>
 <20221026070418.259351-2-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026070418.259351-2-xiubli@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Oct 26, 2022 at 03:04:17PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For ceph we couldn't check the encryption feature by mkfs, we need
> to mount it first and then check the 'get_encpolicy' ioctl cmd.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---

This patch only does an *incomplete* function rename, without any change
on that function body, that doesn't make sense, and even will bring in
regression, due to lots of cases depend on this common function. If you
really need to change a common function, please "grep" [1] this function
in xfstests-dev/ to find out and check all places use it at least.

The _scratch_mkfs_encrypted is a "mkfs" function, likes _scratch_mkfs. I
think we shouldn't change its name. If you want to check if encryption
feature is supported by ceph, I think you might hope to do that in
_require_* functions, or you even can have a ceph specific function in
common/ceph. Just not the way you did in this patchset.

Thanks,
Zorro

[1]
$ grep -rsn _scratch_mkfs_encrypted .
./common/encrypt:32:    if ! _scratch_mkfs_encrypted &>>$seqres.full; then
./common/encrypt:146:_scratch_mkfs_encrypted()
./common/encrypt:174:# Like _scratch_mkfs_encrypted(), but add -O stable_inodes if applicable for the
./common/encrypt:186:           _scratch_mkfs_encrypted
./common/encrypt:926:           _scratch_mkfs_encrypted &>> $seqres.full
./common/verity:178:_scratch_mkfs_encrypted_verity()
./common/verity:190:            _notrun "$FSTYP not supported in _scratch_mkfs_encrypted_verity"
./tests/ext4/024:36:_scratch_mkfs_encrypted &>>$seqres.full
./tests/generic/395:22:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/396:21:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/580:23:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/581:36:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/595:35:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/613:29:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/621:57:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/429:36:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/397:28:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/398:28:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/421:24:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/440:29:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/419:29:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/435:33:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/593:24:_scratch_mkfs_encrypted &>> $seqres.full
./tests/generic/576:34:_scratch_mkfs_encrypted_verity &>> $seqres.full



>  common/encrypt | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/common/encrypt b/common/encrypt
> index 45ce0954..fd620c41 100644
> --- a/common/encrypt
> +++ b/common/encrypt
> @@ -29,7 +29,7 @@ _require_scratch_encryption()
>  	# Make a filesystem on the scratch device with the encryption feature
>  	# enabled.  If this fails then probably the userspace tools (e.g.
>  	# e2fsprogs or f2fs-tools) are too old to understand encryption.
> -	if ! _scratch_mkfs_encrypted &>>$seqres.full; then
> +	if ! _scratch_check_encrypted &>>$seqres.full; then
>  		_notrun "$FSTYP userspace tools do not support encryption"
>  	fi
>  
> @@ -143,7 +143,7 @@ _require_encryption_policy_support()
>  	rm -r $dir
>  }
>  
> -_scratch_mkfs_encrypted()
> +_scratch_check_encrypted()
>  {
>  	case $FSTYP in
>  	ext4|f2fs)
> @@ -171,7 +171,7 @@ _scratch_mkfs_sized_encrypted()
>  	esac
>  }
>  
> -# Like _scratch_mkfs_encrypted(), but add -O stable_inodes if applicable for the
> +# Like _scratch_check_encrypted(), but add -O stable_inodes if applicable for the
>  # filesystem type.  This is necessary for using encryption policies that include
>  # the inode number in the IVs, e.g. policies with the IV_INO_LBLK_64 flag set.
>  _scratch_mkfs_stable_inodes_encrypted()
> @@ -183,7 +183,7 @@ _scratch_mkfs_stable_inodes_encrypted()
>  		fi
>  		;;
>  	*)
> -		_scratch_mkfs_encrypted
> +		_scratch_check_encrypted
>  		;;
>  	esac
>  }
> @@ -923,7 +923,7 @@ _verify_ciphertext_for_encryption_policy()
>  			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) )); then
>  		_scratch_mkfs_stable_inodes_encrypted &>> $seqres.full
>  	else
> -		_scratch_mkfs_encrypted &>> $seqres.full
> +		_scratch_check_encrypted &>> $seqres.full
>  	fi
>  	_scratch_mount
>  
> -- 
> 2.31.1
> 

