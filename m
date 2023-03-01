Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE5B6A705A
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Mar 2023 16:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjCAP4C (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Mar 2023 10:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCAP4B (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Mar 2023 10:56:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C65367F7;
        Wed,  1 Mar 2023 07:56:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CCE7B80EF8;
        Wed,  1 Mar 2023 15:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EA7C433EF;
        Wed,  1 Mar 2023 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677686157;
        bh=HuN89FfjJGekQahoi0mfxn91ZSpPlUJstnL0bfpUvS8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qlXGgo+Y6ybI6ieH4zprnuuAFkzCHnU4tHrn/+XrokeudRQfIVJrWsOjoJiueYZ45
         vCsi9KAktJPx/Pm6B7FxLUbwU9vZgOXK+rTrdvGepeDX0mXOTYx3jcYNAsQM47/reh
         VKJSR+mvMUgBfxfVxbPmIhLoSnaBAkfpUnnAuH7hxwJJizpP1MnvPID2pvW5nH0gjb
         5F7i7YtX01HX+nNFae6oX9puUP0QZHuDe6k6Jv13yEtihp2BmQyB7oS+T7+Nuz4gSG
         oKHNZtk+WGSTlyypxsteOjxTQj4sXh/NgvnF3vHTzx9O9yAc7e0IsCdFg/cs1vGMko
         7MvuVc7TlDzew==
Date:   Wed, 1 Mar 2023 07:55:57 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, david@fromorbit.com,
        ceph-devel@vger.kernel.org, vshankar@redhat.com, zlang@redhat.com
Subject: Re: [PATCH] generic/{075,112}: fix printing the incorrect return
 value of fsx
Message-ID: <Y/91jWK16jYSO0Tz@magnolia>
References: <20230301030620.137153-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301030620.137153-1-xiubli@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Heh, oops.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

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
