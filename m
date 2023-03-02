Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E155E6A8577
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Mar 2023 16:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCBPjg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Mar 2023 10:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCBPje (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Mar 2023 10:39:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0784319686
        for <ceph-devel@vger.kernel.org>; Thu,  2 Mar 2023 07:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677771525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e4uwHdbnK9v7ba4aqvEqtG1jfeJ5xegqZGztujgU68U=;
        b=E9OCagp+U5JT1G/OCspStkOuZ//yMfk+OxMBYnpQdyEgX5E0qi02OV74jyI7hNLYTIbqTc
        S1Y0iR3fjhQy+rlKlAnyx4dFe/j06C3xEaV1bklehDmCTevtyRfbJXrM/4ElNjOPpuS6Fa
        i4HpxsdAppzUZKC8/AO8LUXD46m1vOQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-zGjt99rGMGmT6zA6NYFtuQ-1; Thu, 02 Mar 2023 10:38:43 -0500
X-MC-Unique: zGjt99rGMGmT6zA6NYFtuQ-1
Received: by mail-pj1-f71.google.com with SMTP id q9-20020a17090a9f4900b00237d026fc55so1642251pjv.3
        for <ceph-devel@vger.kernel.org>; Thu, 02 Mar 2023 07:38:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677771523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4uwHdbnK9v7ba4aqvEqtG1jfeJ5xegqZGztujgU68U=;
        b=w07eNqVQuM5KjiZ3Qp1csFVRPOxVGNJSq2oOKJ9MoiclLREyH/wsf9lQJpcIxcUVe0
         HS9rSgLrnfgiaCuRQGt+lHwYzpxDmIB6iyZEWtY8e5CbeR9boa2sh0VIF1JNn4naOKmf
         hSQahkhFMvomRkX//wkEq2DIARM5hf3Ik6qWO5YRF/KHMi7O9rBwSLb1m4MKU9OlYr9O
         ox7s70Ff7WWjGem8Zc42I32fhJnULV0F1M+ExUwKjU3gGzojYm7UKr6ScPfKsspdUR7l
         hSaKKx4RD3JFHsLdqENIWIjsc2cz0l0jExrL53x+N+9oftRTSfxotAh6VXXqejBWTp35
         lNeA==
X-Gm-Message-State: AO0yUKViGWq2dHACzHPP8Gwc7m/4eC6FK8JLY9ojaY1fUUPFbOD+EISk
        uJYMi1RFk6PMZ9p/Wxd5m2SLol0D3ce84il/Tmx8Iglfm4rsSVKMUequ7ttHElpIM/IuKIc5Q82
        M7qd1Z0XirxYWkWx3kOVZ6w==
X-Received: by 2002:a17:903:2288:b0:19c:d452:b282 with SMTP id b8-20020a170903228800b0019cd452b282mr12322124plh.12.1677771522678;
        Thu, 02 Mar 2023 07:38:42 -0800 (PST)
X-Google-Smtp-Source: AK7set+krnQGaY0WGnJqb3tDCJGMjl+bg1/MR4tSPfkN/LorV8TIVojZi6uELXC0e6CwbEL8swRiJA==
X-Received: by 2002:a17:903:2288:b0:19c:d452:b282 with SMTP id b8-20020a170903228800b0019cd452b282mr12322104plh.12.1677771522269;
        Thu, 02 Mar 2023 07:38:42 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e9-20020a170902d38900b0019337bf957dsm10466908pld.296.2023.03.02.07.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 07:38:41 -0800 (PST)
Date:   Thu, 2 Mar 2023 23:38:37 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        ceph-devel@vger.kernel.org, vshankar@redhat.com
Subject: Re: [PATCH] generic/{075,112}: fix printing the incorrect return
 value of fsx
Message-ID: <20230302153837.w23cw5gbedmudwuk@zlang-mailbox>
References: <20230301030620.137153-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301030620.137153-1-xiubli@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Mar 01, 2023 at 11:06:20AM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> We need to save the result of the 'fsx' temporarily.
> 
> Fixes: https://tracker.ceph.com/issues/58834
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---

Hmm... how did you generate this patch? Did you change something before you
send this patch out? I can't merge it simply, always got below errors [1] [2].
May you help to generate this patch again purely?

(Of course you can keep the RVB of Darrick)

Thanks,
Zorro

[1]
$ git am ./20230301_xiubli_generic_075_112_fix_printing_the_incorrect_return_value_of_fsx.mbx
Applying: generic/{075,112}: fix printing the incorrect return value of fsx
error: patch failed: tests/generic/075:53
error: tests/generic/075: patch does not apply
Patch failed at 0001 generic/{075,112}: fix printing the incorrect return value of fsx
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

[2]
$ git am -3 ./20230301_xiubli_generic_075_112_fix_printing_the_incorrect_return_value_of_fsx.mbx
Applying: generic/{075,112}: fix printing the incorrect return value of fsx
error: sha1 information is lacking or useless (tests/generic/075).
error: could not build fake ancestor
Patch failed at 0001 generic/{075,112}: fix printing the incorrect return value of fsx
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

>  tests/generic/075 | 6 ++++--
>  tests/generic/112 | 6 ++++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/generic/075 b/tests/generic/075
> index 03a394a6..bc3a11c7 100755
> --- a/tests/generic/075
> +++ b/tests/generic/075
> @@ -53,9 +53,11 @@ _do_test()
>  
>      # This cd and use of -P gets full debug on "$RESULT_DIR" (not TEST_DEV)
>      cd $out
> -    if ! $here/ltp/fsx $_param -P "$RESULT_DIR" $seq.$_n $FSX_AVOID &>/dev/null
> +    $here/ltp/fsx $_param -P "$RESULT_DIR" $seq.$_n $FSX_AVOID &>/dev/null
> +    local res=$?
> +    if [ $res -ne 0 ]
>      then
> -	echo "    fsx ($_param) failed, $? - compare $seqres.$_n.{good,bad,fsxlog}"
> +	echo "    fsx ($_param) failed, $res - compare $seqres.$_n.{good,bad,fsxlog}"
>  	mv $out/$seq.$_n $seqres.$_n.full
>  	od -xAx $seqres.$_n.full > $seqres.$_n.bad
>  	od -xAx "$RESULT_DIR"/$seq.$_n.fsxgood > $seqres.$_n.good
> diff --git a/tests/generic/112 b/tests/generic/112
> index 971d0467..0e08cbf9 100755
> --- a/tests/generic/112
> +++ b/tests/generic/112
> @@ -53,9 +53,11 @@ _do_test()
>  
>      # This cd and use of -P gets full debug on "$RESULT_DIR" (not TEST_DEV)
>      cd $out
> -    if ! $here/ltp/fsx $_param -P "$RESULT_DIR" $FSX_AVOID $seq.$_n &>/dev/null
> +    $here/ltp/fsx $_param -P "$RESULT_DIR" $FSX_AVOID $seq.$_n &>/dev/null
> +    local res=$?
> +    if [ $res -ne 0 ]
>      then
> -	echo "    fsx ($_param) returned $? - see $seq.$_n.full"
> +	echo "    fsx ($_param) returned $res - see $seq.$_n.full"
>  	mv "$RESULT_DIR"/$seq.$_n.fsxlog $seqres.$_n.full
>  	status=1
>  	exit
> -- 
> 2.31.1
> 

